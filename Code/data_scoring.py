### Data Validation:
import pandas as pd
from minicons import scorer
import os
from torch.utils.data import DataLoader
from huggingface_hub import login

login(token='YOUR_TOKEN')
auth_token = os.getenv('YOUR_TOKEN')

models = {'gpt2':'openai-community/gpt2', 'gpt2_med':'openai-community/gpt2-medium', 'gpt2_large':'openai-community/gpt2-large', 'gpt2_xl':'openai-community/gpt2-xl', 'llama_3':'meta-llama/Meta-Llama-3-8B', 'llama_3_chat':'meta-llama/Meta-Llama-3-8B-Instruct', 'mistral_0.3':'mistralai/Mistral-7B-v0.3', 'mistral_0.3_chat':'mistralai/Mistral-7B-Instruct-v0.3', 'babyllama':'babylm/babyllama-100m-2024', 'babyopt':'babylm/opt-125m-strict-2023', 'olmo':'allenai/OLMo-7B-0724-hf', 'olmo_chat':'allenai/OLMo-7B-0724-Instruct-hf'} 

data = pd.read_csv("INPUT.csv")
stims = DataLoader(list(zip(data["sentence_shifted"], data["sentence_nonshifted"])), batch_size = 100)

for model in models:
    print(f"MODEL: {model}")
    ilm_model = scorer.IncrementalLMScorer(models[model], 'cuda', token=auth_token)
    scores = []
    i=0
    for batch in stims:
        shift, nonshift = batch
        shift_score = ilm_model.sequence_score(shift, reduction=lambda x: x.sum(0).item())
        nonshift_score = ilm_model.sequence_score(nonshift, reduction=lambda x: x.sum(0).item())
        scores.extend(zip(shift_score, nonshift_score))
        print(i)
        i+=100
    
    data[f"{model}_scores"] = scores
    data.to_csv('OUTPUT.CSV')


