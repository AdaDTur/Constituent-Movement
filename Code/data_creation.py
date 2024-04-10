import json
import numpy as np
from minicons import scorer
import os

prepositions1 = ["with the coat", "from California"]
prepositions2 = ["in the store", "from the market", "at the park", "behind the gym", "at work", "at the event"]
verbs = ["met", "saw", "passed", "greeted"]
nouns = ["the man", "the woman", "his friend", "her friend", "his uncle", "her uncle", "his roommate", "her roommate"]
subjects = ["I", "He", "They", "She"]
adjectives = ["wealthy", "tall", "chatty", "older"]

count = 0
dict_list = []

from huggingface_hub import login
login(token='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')

auth_token = os.getenv('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')
ilm_model = scorer.IncrementalLMScorer("sgugger/rwkv-430M-pile", 'cpu', token=auth_token) #sgugger/rwkv-430M-pile


for subject in subjects:
	for verb in verbs:
		for noun in nouns:
			for mod_type in ['adj', 'pp']:
				for weight1 in [0,1,1,1,2,2,2,3,3]:
					for weight2 in [0, 1, 1, 1, 2, 2, 2]:
						for prep2 in prepositions2:
							noun_split = noun.split()
							adj_list = list(np.random.choice(adjectives, weight1, replace=False))
							prep_list = list(np.random.choice(prepositions1, weight2, replace=False))
							if weight1 == 0:
								if weight2 == 0:
									unshifted_sentence = f"{subject} {verb} {noun} {prep2}."
									shifted_sentence = f"{subject} {verb} {prep2} {noun}."
								else:
									unshifted_sentence = f"{subject} {verb} {noun} {' '.join(prep_list)} {prep2}."
									shifted_sentence = f"{subject} {verb} {prep2} {noun} {' '.join(prep_list)}."
							else:
								if weight2 == 0:
									unshifted_sentence = f"{subject} {verb} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]}{prep2}."
									shifted_sentence = f"{subject} {verb} {prep2} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]}."
								else:
									unshifted_sentence = f"{subject} {verb} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]} {' '.join(prep_list)} {prep2}."
									shifted_sentence = f"{subject} {verb} {prep2} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]} {' '.join(prep_list)}."
							data = [unshifted_sentence, shifted_sentence]
							scores = ilm_model.sequence_score(data, reduction=lambda x: x.mean(0).item())
							print("=========================")
							print(count)
							print(unshifted_sentence, str(scores[0]))
							print(shifted_sentence, str(scores[1]))
							unshifted_data = {'id': count, 'sentence': unshifted_sentence, 'shifted': False, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[0]}
							shifted_data = {'id': count, 'sentence': shifted_sentence, 'shifted': True, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[1]}
							dict_list.append(unshifted_data)
							dict_list.append(shifted_data)
							count += 1

with open('data_file_rwkv.json', 'w') as fp:
	for dictionary in dict_list:
		line = json.dumps(dictionary) + '\n'
		fp.write(line)

"""
GOAL:

sentence: I saw my uncle on the street, shifted: 0, subject: I, verb: saw, final_con: on the street, final_con_type: pp, base_dp: my uncle, adjectives: [], mod_pp:[]
sentence: I saw my rich uncle on the street, shifted: 0, verb: saw, final_con: on the street, final_con_type: pp, base_dp: my uncle, adjectives: ['rich'], mod_pp:[]
sentence: I saw my rich, hairy uncle on the street, shifted: 0, verb: saw, final_con: on the street, final_con_type: pp, base_dp: my uncle, adjectives: ['rich', 'hairy'], mod_pp:[], weight: 2
sentence: I saw my rich, hairy uncle from Detroit on the street, shifted: 0, verb: saw, final_con: on the street, final_con_type: pp, base_dp: my uncle, adjectives: ['rich', 'hairy'], mod_pp: ['from Detroit'], weight: 3

"""


