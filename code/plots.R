setwd('C:\\Users\\gaura\\Desktop\\McGill Semesters\\Summer 2024\\Ada Project')
## ^^ Change that obviously
library(tidyverse)
library(glue)

HNPS <- read_csv("HNPS.csv")
PM <- read_csv("PM.csv")
DA <- read_csv("DA.csv")
MPP <- read_csv("MPP.csv")
HNPS <- HNPS %>% mutate(verb = as.factor(verb)) %>% filter(syll_ratio > 0)
PM <- PM %>% mutate(verb = as.factor(verb)) %>% filter(syll_ratio > 0)
MPP <- MPP %>% mutate(verb = as.factor(verb)) %>% filter(syll_ratio > 0)
DA <- DA %>% mutate(verb = as.factor(verb)) %>% filter(syll_ratio > 0)


HNPS_mined <- read_csv("HNPS_mined.csv") 
PM_mined <- read_csv("PM_mined.csv")
DA_mined <- read_csv("DA_mined.csv")
MPP_mined <- read_csv("MPP_mined.csv")
HNPS_mined <- HNPS_mined %>% filter(syll_ratio > 0)
PM_mined <- PM_mined %>% filter(syll_ratio > 0)
MPP_mined <- MPP_mined %>% filter(syll_ratio > 0)
DA_mined <- DA_mined %>% filter(syll_ratio > 0)


### Make some plots...

# Look across models:
HNPS %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Heavy NP Shift")


# This adds token lengths also: 
# I haven't implemented it with the others, 
# but the key is the mutate(token_ratio...) bit that isn't in the others
HNPS %>% 
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
  ) %>%
  pivot_longer(
    cols = c("wordlength_ratio", "syll_ratio", "mods_ratio", "token_ratio"), 
    names_to = "ratio_type", 
    values_to = "ratio"
  ) %>%
  dplyr::select(score, source, ratio, ratio_type) %>%
  group_by(ratio_type, ratio, source) %>%
  summarise(mean_score = mean(score)) %>%
  ggplot(aes(x = ratio, y = mean_score, color = ratio_type)) +
  geom_line() +
  facet_wrap(~source) +
  scale_color_manual(values = c(
    "wordlength_ratio" = "black", 
    "syll_ratio" = "#0072B2", 
    "mods_ratio" = "#D55E00",
    "token_ratio" = "orange"
  )) +
  ggtitle("Heavy NP Shift")


HNPS_mined %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Heavy NP Shift: Mined Data")

PM %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Particle Movement")

PM_mined %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Particle Movement: Mined Data")


MPP %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Multiple PPs")

MPP_mined %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Multiple PPs: Mined Data")




DA %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Dative Alternation")


DA_mined %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type) %>% 
  #filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `source`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00")) + 
  ggtitle("Dative Alternation: Mined Data")



# Fix one model, view by final con / verb:
HNPS %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "black", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))

HNPS %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`, `final con`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`, `final con`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_grid(`final con` ~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))

PM %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`, `particle`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`, `particle`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap(`verb` ~ `particle`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))


DA %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap( ~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))

DA %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`, `obj2`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`, `obj2`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_grid(`obj2` ~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))

MPP %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_wrap( ~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))

MPP %>% pivot_longer(cols=c("gpt2_score", "gpt2_med_score", "gpt2_large_score", "gpt2_xl_score", "llama_3_score", "llama_3_chat_score", "babyopt_score", "babyllama_score", "mistral_0.3_score", "mistral_0.3_chat_score", "olmo_score", "olmo_chat_score"), names_to = "source", values_to = "score") %>%
  pivot_longer(cols=c("wordlength_ratio", "syll_ratio", "mods_ratio"), names_to="ratio_type", values_to = "ratio") %>% 
  dplyr::select(score, source, ratio, ratio_type, `verb`, `obj1`) %>% 
  filter(source=='olmo_score') %>% 
  group_by(ratio_type, ratio, source, `verb`, `obj1`) %>% 
  summarise(mean_score = mean(score)) %>% 
  ggplot(aes(x=ratio, y=mean_score, color=ratio_type)) +
  geom_line() +
  facet_grid(`obj` ~ `verb`) +
  scale_color_manual(values=c("wordlength_ratio" = "#F0E442", 
                              "syll_ratio" = "#0072B2", 
                              "mods_ratio" = "#D55E00"))




### Do Model Results Correlate with One Another?

HNPS %>% 
  ggplot(aes(x=llama_3_score, y=mistral_0.3_score, colour=syll_ratio)) +
  geom_point()

cor(HNPS$llama_3_score, HNPS$mistral_0.3_score, method="spearman")

