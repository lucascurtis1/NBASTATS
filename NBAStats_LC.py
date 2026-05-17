# -*- coding: utf-8 -*-
"""
Created on Thu May 14 15:04:35 2026
Lucas Curtis
Python portion of NBA 3pt Statistics project
"""
import os

import pandas as pd

from collections import defaultdict
"""
note to self:
    defaultdict is a function that helps to make dictionaries. In this case I used defaultdict(list) in order
    to easily make a dictionary in which the values are lists
"""



os.chdir(r"C:\Users\skywa\OneDrive\Documents\FunCode\NBA3PT\SAS_Datasets_NBA3PT")


sastables = os.listdir(r"C:\Users\skywa\OneDrive\Documents\FunCode\NBA3PT\SAS_Datasets_NBA3PT")
"""
returns the sas7bdat files of each basketball position by each year,
with each file taking up one index of a list
"""

"""
    data = pd.read_sas(dataset_i, encoding='utf-8')
reads in the SAS file; the encoding part helps to read in the team names cleanly
"""
def Centers(dataset_i):
    """
    Takes a sas dataset and ultimately returns a dataframe that includes the point value I came up with,
    +0 for low efficiency and volume, +1 for high efficiency or volume, and +2 for high efficiency and volume.
    
    Unique to Centers
    """
    data = pd.read_sas(dataset_i, encoding='utf-8')
    if '22' in dataset_i:
        LA_Pct = .354
    elif '23' in dataset_i:
        LA_Pct = .361
    elif '24' in dataset_i:
        LA_Pct = .366
    elif '25' in dataset_i:
        LA_Pct = .360
    data2 = data.assign(
        Over_LA_Pct = data['Percentage'] > LA_Pct,
        Over_3PM_Std = data['Made'] > 1.5
        )
    With_Point_Values = data2.assign(
        Point_Value = data2['Over_LA_Pct'].astype(int) + data2['Over_3PM_Std'].astype(int)
        )   
    return With_Point_Values

def PgSgSf(dataset_i):
    """
    Takes a sas dataset and ultimately returns a dataframe that includes the point value I came up with,
    +0 for low efficiency and volume, +1 for high efficiency or volume, and +2 for high efficiency and volume.
    
    Unique to Point Guards, Shooting Guards, and Small Forwards
    """
    data = pd.read_sas(dataset_i, encoding='utf-8')
    if '22' in dataset_i:
        LA_Pct = .354
    elif '23' in dataset_i:
        LA_Pct = .361
    elif '24' in dataset_i:
        LA_Pct = .366
    elif '25' in dataset_i:
        LA_Pct = .360
    data2 = data.assign(
        Over_LA_Pct = data['Percentage'] > LA_Pct,
        Over_3PM_Std = data['Made'] > 4.5
        )
    With_Point_Values = data2.assign(
        Point_Value = data2['Over_LA_Pct'].astype(int) + data2['Over_3PM_Std'].astype(int)
        )
    return With_Point_Values

def PowerForwards(dataset_i):
    """
    Takes a sas dataset and ultimately returns a dataframe that includes the point value I came up with,
    +0 for low efficiency and volume, +1 for high efficiency or volume, and +2 for high efficiency and volume.
    
    Unique to Power Forwards
    """
    data = pd.read_sas(dataset_i, encoding='utf-8')
    if '22' in dataset_i:
        LA_Pct = .354
    elif '23' in dataset_i:
        LA_Pct = .361
    elif '24' in dataset_i:
        LA_Pct = .366
    elif '25' in dataset_i:
        LA_Pct = .360
    data2 = data.assign(
        Over_LA_Pct = data['Percentage'] > LA_Pct,
        Over_3PM_Std = data['Made'] > 3.5
        )
    With_Point_Values = data2.assign(
        Point_Value = data2['Over_LA_Pct'].astype(int) + data2['Over_3PM_Std'].astype(int)
        )
    return With_Point_Values



datasets_by_year = defaultdict(list)

for dataset_i in sastables:
    """
    Creates a dictionary that 
    filters datasets by year, assuming year is in the name of the file
    
    uses defaultdict from collections
    """
    if '22' in dataset_i:
        datasets_by_year['2022'].append(dataset_i)
    elif '23' in dataset_i:
        datasets_by_year['2023'].append(dataset_i)
    elif '24' in dataset_i:
        datasets_by_year['2024'].append(dataset_i)
    elif '25' in dataset_i:
        datasets_by_year['2025'].append(dataset_i)

    
dataframes_by_year = defaultdict(list)

for key , value in datasets_by_year.items():
    """
    creates a dictionary, where the key is year and the values are a list of dataframes, one for each position
    """
    for dataset_i in value:
        if 'pg' or 'sg' or 'sf' in dataset_i:
            PV = PgSgSf(dataset_i)
            dataframes_by_year[key].append(PV)
        elif 'pf' in dataset_i:
            PV = PowerForwards(dataset_i)
            dataframes_by_year[key].append(PV)
        else:
            PV = Centers(dataset_i)
            dataframes_by_year[key].append(PV)

Series_of_PV_dict = defaultdict(list)

for key, value in dataframes_by_year.items():
    """
    I like this and dataframes_by_year apart just in case I like the previous dataframe for future use.
    However, they could be made into one step.
    
    this specific for loop takes the dictionary of dataframes and creates a dictionary of series that consist of:
        index == team names | column == Point Values
    """
    for dataframe in value:
        dataframe1 = dataframe.set_index('Team')
        PV_only_series = dataframe1['Point_Value']
        PV_only_series = PV_only_series.fillna(0)
        Series_of_PV_dict[key].append(PV_only_series)

Point_Value_Dictionary = {}
for key, value in Series_of_PV_dict.items():
    """
    This now gives a dictionary (Point_Value_Dictionary) with {year : series containing point value at each team (the index being team) }
    example:
        {2022: Team
                ATL    3.0
                BOS    4.0
                BRK    5.0
                CHI    0.0
                DAL    5.0
                DEN    0.0
                GSW    5.0
                MEM    4.0
                MIA    2.0
                MIL    3.0
                MIN    0.0
                NOP    2.0
                PHI    3.0
                PHO    4.0
                TOR    0.0
                UTA    0.0
                Name: Point_Value, dtype: float64
        }
    """
    Point_Value_Dictionary[key] = sum(value).fillna(0)
        


    
    
