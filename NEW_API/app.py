# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import uvicorn
from fastapi import FastAPI
from Routes import Route
import numpy as np
import pickle
import pandas as pd

app = FastAPI()
pickle_in = open ("vigilanceapp.pkl","rb")
classifier=pickle.load(pickle_in)


@app.get('/')
def index():
    return{'message':'hello ,World'}


@app.get('/{name}')
def get_name(name:str):
    return {'Welcome here to api': f'{name}'}


@app.post('/predict')
def predict_route(data:Route):
    data = data.dict()
     
    Distance=data['Distance']
    Crime_Rate=data['Crime_Rate']
    CCTV_Cameras=data['CCTV_Cameras']
    
    test = [[Distance,Crime_Rate,CCTV_Cameras]] 
    
    prediction= classifier.predict(test)
    
    
    if (prediction[0]==0):
        prediction ="NEUTRAL"
    elif (prediction[0]==1):
        prediction ="SAFE "
    elif (prediction[0]==2):
        prediction ="UNSAFE ROUTE"
    return {
        'prediction': prediction
        }

if __name__ =='__main__':
    uvicorn.run(app,host='0.0.0.0',port=8000)
#uvicorn app:app --reload