import pandas as pd
import numpy as np
import statsmodels.api as sm
from patsy import dmatrices

model_names = ["gpt2", "gpt2_med", "gpt2_large", "gpt2_xl", "llama_3", "llama_3_chat", "mistral_0.3", "mistral_0.3_chat", "babyllama", "babyopt", "olmo", "olmo_chat"]
filepath = "MPP_new_olmo_chat.csv"
df = pd.read_csv(filepath)

for model_name in model_names:
    #DIFFERENCE ANALYSIS
    df['adj1'] = df['adj1'].apply(lambda x: x if isinstance(x, list) else eval(x))
    df['adj2'] = df['adj2'].apply(lambda x: x if isinstance(x, list) else eval(x))
    df['preps1'] = df['preps1'].apply(lambda x: x if isinstance(x, list) else eval(x))
    df['preps2'] = df['preps2'].apply(lambda x: x if isinstance(x, list) else eval(x))
    df['adj_weight'] = df['adj1'].apply(lambda x: len(x)) + df['adj2'].apply(lambda x: len(x))
    df['prep_weight'] = df['preps1'].apply(lambda x: len(x)) + df['preps2'].apply(lambda x: len(x))
    df['weight'] = df['adj_weight'] + df['prep_weight']
    df['diff'] = df[f'{model_name}_scores'].apply(lambda x: eval(x)[0] - eval(x)[1])

    for i in np.unique(df['weight']):
        weight_specific = df[df['weight'] == i]
        #print(f"At weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")

    for i in np.unique(df['adj_weight']):
        weight_specific = df[df['adj_weight'] == i]
        #print(f"At adj weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")

    for i in np.unique(df['prep_weight']):
        weight_specific = df[df['prep_weight'] == i]
        #print(f"At prep weight {i}, average unshifted-shifted: {np.mean(weight_specific['diff'])}")



    # """
    #OLS REGRESSION
    y, X = dmatrices('diff ~ adj_weight + prep_weight', data=df, return_type='dataframe') # This prepares your data in the right format for the statsmodels package
    '''
    Note that the string 'diff ~ adj_weight + prep_weight' follows what is often standard notation for regression modelling:
    the thing to the left of the '~' is your outcome variable, and the things to the right are the variables whose effect on the outcome variable you're evaluating.
    The use of the '+'s reflects the actual mathematical form of the linear regression: y as a function of coefficient_1*x_1 + coefficient_2*x_2 + ... + coefficient_n+x_n.
    '''

    model = sm.OLS(y, X) # This sets up the linear regression
    res = model.fit() # This fits the linear regression model
    print(model_name)
    print(res.summary()) # Results
    # """
    print("===================================")
