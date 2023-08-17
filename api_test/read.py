import requests
import pandas as pd
from io import StringIO

# Load CSV data from file
csv_data = """Distance from Police Station (km), Crime Rate, Number of CCTV Cameras
0.5,1.5,5
"""

# Convert CSV data to a DataFrame
input_df = pd.read_csv(StringIO(csv_data))

# Convert DataFrame to CSV string
csv_string = input_df.to_csv(index=False)

# API endpoint URL
url = "http://127.0.0.1:5000/predict"

# Send POST request with CSV data
response = requests.post(url, data=csv_string, headers={"Content-Type": "text/csv"})

# Print the response content
print(response.json())
