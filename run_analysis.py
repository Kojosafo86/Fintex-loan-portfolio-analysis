"""
run_analysis.py
---------------
Runs the whole project end to end:

  1. loads data/smaller_data_set.csv into an in-memory DuckDB database
  2. builds the loan / instalment / payment tables (sql/00_build_model.sql)
  3. runs every query in sql/01-07 and saves each result to results/
  4. draws the charts in images/ (see make_charts.py)

Usage:
    pip install duckdb pandas matplotlib
    python run_analysis.py
"""
from pathlib import Path
import re

import duckdb

ROOT = Path(__file__).parent
SQL_DIR = ROOT / "sql"
RESULTS = ROOT / "results"
RESULTS.mkdir(exist_ok=True)


def statements(sql_text: str):
    """Split a .sql file into individual statements (drops comments)."""
    no_comments = re.sub(r"--[^\n]*", "", sql_text)
    return [s.strip() for s in no_comments.split(";") if s.strip()]


def main():
    con = duckdb.connect()
    con.execute(
        "CREATE TABLE raw AS SELECT * FROM "
        f"read_csv_auto('{ROOT / 'data' / 'smaller_data_set.csv'}', header = true)"
    )
    con.execute((SQL_DIR / "00_build_model.sql").read_text())

    for sql_file in sorted(SQL_DIR.glob("0[1-9]_*.sql")):
        for i, stmt in enumerate(statements(sql_file.read_text()), start=1):
            df = con.execute(stmt).df()
            out = RESULTS / f"{sql_file.stem}_{i}.csv"
            df.to_csv(out, index=False)
            print(f"\n=== {out.name} ===")
            print(df.to_string(index=False))

    # Reconciliation check: net payments must match at raw and loan grain.
    raw_paid, loan_paid = con.execute(
        "SELECT (SELECT SUM(paid_amount) FROM raw), (SELECT SUM(total_paid) FROM loans)"
    ).fetchone()
    assert abs(raw_paid - loan_paid) < 0.01, "payments do not reconcile"
    print(f"\nReconciled: net payments {raw_paid:,.2f} at both grains.")

    import make_charts
    make_charts.main(RESULTS, ROOT / "images")


if __name__ == "__main__":
    main()
