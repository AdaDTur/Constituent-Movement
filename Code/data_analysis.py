import pandas as pd
import numpy as np
import statsmodels.api as sm
from patsy import dmatrices

model_names = ["gpt2", "gpt2_med", "gpt2_large", "gpt2_xl", "distilgpt2", "llama2", "llama2_chat", "rwkv"]
for model_name in model_names:
    print("============" + model_name.upper() + "============")
    filepath = "data/data_file_" + model_name + "_final.json"

    #DIFFERENCE ANALYSIS
    df = pd.read_json(filepath, lines=True)
    df['adj_weight'] = df['adjectives'].apply(lambda x: len(x))
    df['prep_weight'] = df['prepositions'].apply(lambda x: len(x))
    df['weight'] = df['adj_weight'] + df['prep_weight']
    df_shifted = df[df['shifted']].reset_index(drop=True).rename(columns={'sentence': 'sentence_shifted'})
    df_unshifted = df[~df['shifted']].reset_index(drop=True).rename(columns={'sentence': 'sentence_unshifted'})
    df_merged = df_shifted.drop(columns=['shifted', 'score'])
    df_merged['diff'] = df_unshifted['score'] - df_shifted['score']
    for i in np.unique(df_merged['weight']):
        weight_specific = df_merged[df_merged['weight'] == i]
        print(f"At weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")

    for i in np.unique(df_merged['adj_weight']):
        weight_specific = df_merged[df_merged['adj_weight'] == i]
        print(f"At adj weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")

    for i in np.unique(df_merged['prep_weight']):
        weight_specific = df_merged[df_merged['prep_weight'] == i]
        print(f"At prep weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")



    # """
    #OLS REGRESSION
    df = pd.read_json(filepath, lines=True)

    for column in ['subject', 'verb', 'noun', 'adjectives', 'prepositions', 'final_con', 'final_con_type']:
        #print(f"Variable: {column}\nUnique Values: {np.unique(df[column])}\n\n")
        continue

    df['adj_weight'] = df['adjectives'].apply(lambda x: len(x))
    df['prep_weight'] = df['prepositions'].apply(lambda x: len(x))
    df['weight'] = df['adj_weight']+df['prep_weight']


    df_shifted = df[df['shifted']].reset_index(drop=True).rename(columns={'sentence':'sentence_shifted'})
    df_unshifted = df[~df['shifted']].reset_index(drop=True).rename(columns={'sentence':'sentence_unshifted'})
    df_merged = df_shifted.drop(columns=['shifted', 'score'])
    df_merged['diff'] = df_unshifted['score'] - df_shifted['score']

    y, X = dmatrices('diff ~ adj_weight + prep_weight', data=df_merged, return_type='dataframe') # This prepares your data in the right format for the statsmodels package
    '''
    Note that the string 'diff ~ adj_weight + prep_weight' follows what is often standard notation for regression modelling:
    the thing to the left of the '~' is your outcome variable, and the things to the right are the variables whose effect on the outcome variable you're evaluating.
    The use of the '+'s reflects the actual mathematical form of the linear regression: y as a function of coefficient_1*x_1 + coefficient_2*x_2 + ... + coefficient_n+x_n.
    '''

    model = sm.OLS(y, X) # This sets up the linear regression
    res = model.fit() # This fits the linear regression model
    print(res.summary()) # Results
    # """
    print("===================================")

