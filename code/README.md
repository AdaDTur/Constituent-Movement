# Code Folder

## Data Creation
We use `data_creation.py` to generate synthetic data, and `shift_miner.py` to mine data from publicly available natural language corpora.

## Data Scoring
Originally, we computed *mean* sequence scores for the data using `data_mean_scoring.py`, but made the decision to switch to using *summed* sequence scores instead using `compute_sums.py`. For simplicity, we also provide `data_sum_scoring.py`, to cleanly compute summed sequence scores from scratch.

## Modelling
For modelling, we use `modelling.R` and `plots.R` to generate all plots.
