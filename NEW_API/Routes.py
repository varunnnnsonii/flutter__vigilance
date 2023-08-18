# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 17:08:19 2023

@author: VARUNN
"""

from pydantic import BaseModel

class Route(BaseModel):
    Distance:float
    Crime_Rate:float  
    CCTV_Cameras:int