"""
make_charts.py
--------------
Draws the README charts from the CSVs in results/. Called by run_analysis.py.
"""
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

SURFACE = "#fcfcfb"
INK = "#0b0b0b"
INK_2 = "#52514e"
GRID = "#e6e5e1"
SERIES = ["#2a78d6", "#eb6834", "#1baf7a", "#4a3aa7"]  # blue, orange, aqua, violet
MUTED_FILL = "#b9cfee"                                  # lighter blue for incomplete vintages

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 10,
    "axes.edgecolor": GRID,
    "axes.labelcolor": INK_2,
    "xtick.color": INK_2,
    "ytick.color": INK_2,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "figure.facecolor": SURFACE,
    "axes.facecolor": SURFACE,
})


def _style(ax):
    ax.grid(axis="y", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)
    ax.tick_params(length=0)


def vintage_chart(results: Path, out: Path):
    v = pd.read_csv(results / "02_vintage_performance_1.csv")
    # drop vintages under half matured: too few loans have reached their outcome
    v = v[v["principal_loss_rate"].notna() & (v["share_matured"] >= 0.5)]
    complete = v["share_matured"] >= 0.95
    fig, (a1, a2) = plt.subplots(2, 1, figsize=(9, 6.2), sharex=True,
                                 gridspec_kw={"height_ratios": [1.4, 1]})
    colors = [SERIES[0] if c else MUTED_FILL for c in complete]
    a1.bar(v["vintage_quarter"], v["principal_loss_rate"] * 100, color=colors, width=0.7)
    for x, y in zip(v["vintage_quarter"], v["principal_loss_rate"] * 100):
        if x in ("2020-Q3", "2022-Q4"):
            a1.annotate(f"{y:.1f}%", (x, y), ha="center", va="bottom",
                        xytext=(0, 3), textcoords="offset points", color=INK, fontsize=9)
    a1.set_ylabel("Principal loss rate (%)")
    a1.set_title("Loss rates fell as loans grew larger",
                 loc="left", color=INK, fontsize=13, fontweight="bold", pad=22)
    a1.text(0, 1.02, "Matured loans by disbursement quarter. Lighter bar: still seasoning (<95% matured); 2023-Q2 omitted (44% matured).",
            transform=a1.transAxes, color=INK_2, fontsize=9)
    _style(a1)
    a2.bar(v["vintage_quarter"], v["avg_loan_size"], color=SERIES[0], width=0.7)
    a2.set_ylabel("Average loan size")
    _style(a2)
    plt.setp(a2.get_xticklabels(), rotation=45, ha="right")
    fig.tight_layout()
    fig.savefig(out / "vintage_loss_and_loan_size.png", dpi=160)
    plt.close(fig)


def repeat_chart(results: Path, out: Path):
    r = pd.read_csv(results / "04_repeat_borrowers_1.csv")
    labels = [s.split(". ", 1)[1] for s in r["borrower_stage"]]
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.bar(labels, r["principal_loss_rate"] * 100, color=SERIES[0], width=0.6)
    for x, y in zip(labels, r["principal_loss_rate"] * 100):
        ax.annotate(f"{y:.1f}%", (x, y), ha="center", va="bottom",
                    xytext=(0, 3), textcoords="offset points", color=INK, fontsize=9)
    ax.set_ylabel("Principal loss rate (%)")
    ax.set_title("First loans lost 15% of principal; from the 6th loan, ~3-4%",
                 loc="left", color=INK, fontsize=13, fontweight="bold", pad=22)
    ax.text(0, 1.02, "Matured loans by the client's loan sequence number.",
            transform=ax.transAxes, color=INK_2, fontsize=9)
    _style(ax)
    fig.tight_layout()
    fig.savefig(out / "repeat_borrower_loss.png", dpi=160)
    plt.close(fig)


def curves_chart(results: Path, out: Path):
    c = pd.read_csv(results / "03_vintage_curves_1.csv")
    picks = ["2020-Q3", "2021-Q1", "2022-Q1", "2022-Q4"]
    fig, ax = plt.subplots(figsize=(8, 4.4))
    for color, vq in zip(SERIES, picks):
        d = c[(c["vintage_quarter"] == vq) & (c["months_on_book"] <= 6)]
        y = d["cumulative_collected_pct_of_principal"] * 100
        ax.plot(d["months_on_book"], y, color=color, linewidth=2, label=vq)
    ax.axhline(100, color=INK_2, linewidth=0.8, linestyle=(0, (3, 3)))
    ax.text(0.05, 101.5, "principal repaid", color=INK_2, fontsize=8)
    ax.set_xlabel("Months on book")
    ax.set_ylabel("Cumulative collected (% of principal)")
    ax.set_xlim(0, 6)
    ax.set_title("2020-Q3 collected fastest early, then stalled lowest",
                 loc="left", color=INK, fontsize=13, fontweight="bold", pad=22)
    ax.text(0, 1.02, "Net collections as a share of principal lent, by quarterly vintage.",
            transform=ax.transAxes, color=INK_2, fontsize=9)
    ax.legend(frameon=False, loc="lower right", fontsize=9)
    _style(ax)
    fig.tight_layout()
    fig.savefig(out / "vintage_curves.png", dpi=160)
    plt.close(fig)


def main(results: Path, out: Path):
    out.mkdir(exist_ok=True)
    vintage_chart(results, out)
    repeat_chart(results, out)
    curves_chart(results, out)
    print(f"Charts written to {out}")
