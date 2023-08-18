# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 17:15:53 2023

@author: VARUNN
"""

import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get('/')
def index():
    return {'message': 'Hello World'}
@app.get('/Welcome')
def get_name():
    return {'Welcome here to api': f'{name}'}


if __name__ ==' __main__':
    uvicorn.run(app,host='127.0.0.1',port=8000)
    