import csv
import uuid
import random
from datetime import datetime, timedelta

# File path
output_file = "transactions.csv"

# Constants
total_rows = 10_000_000  # Approx. 1GB
chunk_size = 100_000  # Writing in chunks
transaction_types = ["Purchase", "Refund", "Withdrawal", "Deposit", "Transfer"]
start_date = datetime(2020, 1, 1)
end_date = datetime(2025, 1, 1)

# Function to generate random date
def random_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

# Generate and write data
with open(output_file, mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Transaction_ID", "Date", "Customer_ID", "Amount", "Transaction_Type"])
    
    for _ in range(total_rows // chunk_size):
        rows = [
            [
                str(uuid.uuid4()),
                random_date(start_date, end_date).strftime("%Y-%m-%d %H:%M:%S"),
                random.randint(100000, 999999),
                round(random.uniform(1, 5000), 2),
                random.choice(transaction_types)
            ]
            for _ in range(chunk_size)
        ]
        writer.writerows(rows)

print(f"CSV file generated: {output_file}")
