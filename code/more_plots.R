#setwd('Users/Downloads/Mila/Constituent_Movement_LLMs')
## ^^ Change that obviously
library(tidyverse)
library(glue)
library(rjson)

MPP <- read_csv("Downloads/Mila/Constituent_Movement_LLMs/MPP.csv")
human_data <- read_csv("Downloads/Mila/Constituent_Movement_LLMs/full_mpp_hs_data_new.csv")
MPP <- MPP %>% mutate(verb = as.factor(verb)) %>% filter(syll_ratio > 0)

### Make some plots...

# Look across models:

MPP %>% 
  pivot_longer(
    cols = c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", 
             "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", 
             "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), 
    names_to = "source", 
    values_to = "score"
  ) %>%
  mutate(
    token_ratio = case_when(
      source == "gpt2_score" ~ gpt2_token_ratio,
      source == "gpt2_med_score" ~ gpt2_med_token_ratio,
      source == "gpt2_large_score" ~ gpt2_large_token_ratio,
      source == "gpt2_xl_score" ~ gpt2_xl_token_ratio,
      source == "llama_3_score" ~ llama_3_token_ratio,
      source == "llama_3_chat_score" ~ llama_3_chat_token_ratio,
      source == "babyopt_score" ~ babyopt_token_ratio,
      source == "babyllama_score" ~ babyllama_token_ratio,
      source == "mistral_0.3_score" ~ mistral_0.3_token_ratio,
      source == "mistral_0.3_chat_score" ~ mistral_0.3_chat_token_ratio,
      source == "olmo_score" ~ olmo_token_ratio,
      source == "olmo_chat_score" ~ olmo_chat_token_ratio,
      TRUE ~ NA_real_
    )
  )

# Full high-level variable performance
MPP %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  #filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  ggtitle("Model Preference Scores on Multiple PP Shift") + 
  xlab("Ratio of First Constituent Weight to Second") + 
  ylab(expression("Mean M"["preference"] ~ " Score")) + 
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"), labels = c("Modifier Weight Ratio", "Syllable Weight Ratio", "Word Length Ratio"))

# Model-wise performance
MPP %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio", "gpt2_token_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  filter(source=='gpt2_score') %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  ggtitle("Model Preference Scores on Multiple PP Shift") + 
  xlab("Ratio of First Constituent Weight to Second") + 
  ylab(expression("Mean M"["preference"] ~ " Score")) + 
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00",
                              "gpt2_token_ratio" = "orange"), labels = c("Modifier Weight Ratio", "Syllable Weight Ratio", "Word Length Ratio", "Token Length Ratio"))


### Do Model Results Correlate with Humans

human_data <- human_data %>%
  mutate(
    responses = lapply(responses, function(x) {
      if (is.na(x) || x == "") {
        return(NA)  # Handle empty or missing values
      }
      as.numeric(strsplit(gsub("[\\[\\]]", "", x), ", ")[[1]])
    }),
    average = sapply(responses, function(x) {
      if (all(is.na(x))) return(NA)  # Handle cases where responses could not be parsed
      mean(x, na.rm = TRUE)
    })
  )

# Step 2: Reshape the data and filter for one model (e.g., 'gpt2_xl_score')
reshaped_data <- human_data %>%
  pivot_longer(
    cols = c(
      "gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score",
      "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score",
      "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"
    ),
    names_to = "source",
    values_to = "score"
  ) %>%
  filter(source == "gpt2_xl_score" & !is.na(average) & !is.na(score))  # Select one model and filter non-NA rows

# Step 3: Plot for the selected model
ggplot(reshaped_data, aes(x = average, y = score)) +
  geom_point(alpha = 0.6) +  # Scatter plot
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = -2, ymax = 1, fill = "lightgray", alpha = 0.2) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +  # Regression line with shading
  ggtitle("Correlation between GPT-2 XL and Human Responses") +
  xlab("Mean of Human Responses") +
  ylab("GPT-2 XL M Preference Score") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )
