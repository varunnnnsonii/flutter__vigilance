from flask import Flask, request, jsonify
import joblib
import pickle
import pandas as pd
import logging
from io import StringIO

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# Load the pre-trained machine learning model
with open('vigilanceapp.pkl', 'rb') as file:
    model = pickle.load(file)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        app.logger.info("Received a prediction request.")

        # Get CSV data from the request
        csv_data = request.data.decode('utf-8')
        
        # Convert CSV data to a pandas DataFrame
        input_df = pd.read_csv(StringIO(csv_data))
        
        app.logger.debug("Input DataFrame:\n%s", input_df)
        
        # Validate input data (example: check if expected columns are present)
        expected_columns = ["column1", "column2", "column3"]  # Adjust based on your model's requirements
        if set(input_df.columns) != set(expected_columns):
            app.logger.error("Invalid input data columns: %s", input_df.columns)
            return jsonify({"error": "Invalid input data"})
        
        # Convert DataFrame to a numpy array
        input_data = input_df.values
        
        # Make predictions using the loaded model
        predictions = model.predict(input_data)
        
        app.logger.info("Predictions calculated.")

        # Return the predictions as JSON response
        return jsonify({"predictions": predictions.tolist()})
    
    except Exception as e:
        app.logger.error("An error occurred: %s", str(e))
        return jsonify({"error": "An error occurred"})

if __name__ == '__main__':
    app.run(debug=True)
