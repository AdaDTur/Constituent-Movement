import json
import numpy as np
import os

#====================GENERATING HNPS DATA====================

prepositions1 = ["with the coat", "from California"]
prepositions2 = ["in the store", "from the market", "at the park", "behind the gym", "at work", "at the event"]
verbs = ["met", "saw", "passed", "greeted"]
nouns = ["the man", "the woman", "his friend", "her friend", "his uncle", "her uncle", "his roommate", "her roommate"]
subjects = ["I", "He", "They", "She"]
adjectives = ["wealthy", "tall", "chatty", "older"]

count = 0
dict_list = []
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
	
							print(count)
							print(unshifted_sentence, str(scores[0]))
							print(shifted_sentence, str(scores[1]))
							unshifted_data = {'id': count, 'sentence': unshifted_sentence, 'shifted': False, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[0]}
							shifted_data = {'id': count, 'sentence': shifted_sentence, 'shifted': True, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[1]}
							dict_list.append(unshifted_data)
							dict_list.append(shifted_data)
							count += 1

with open('hnps_OUTPUT.json', 'w') as fp:
	for dictionary in dict_list:
		line = json.dumps(dictionary) + '\n'
		fp.write(line)

#====================GENERATING PM DATA====================

prepositions1 = []
prepositions2 = []
pivots = {['gave', 'up']: {'the idea', 'her location', 'his secret', 'the race'}, 
	  ['put', 'out']: [], 
	  ['worked', 'out']: [], 
	  ['turned', 'in']: [], 
	  ['backs', 'up']: [], 
	  ['brought', 'up']: [], 
	  ['pointed', 'out']: [], 
	  ['carries', 'out']: [], 
	  ['called', 'off']: [], 
	  ['hand', 'in']: [], 
	  ['left', 'out']: [], 
	  ['turned', 'down']: [], 
	  ['set', 'up']: [], 
	  ['threw', 'away']: [], 
	  ['takes', 'apart']: [], 
	  ['looks', 'up']: [], 
	  ['beats', 'up']: [], 
	  ['put', 'on']: [],
	  ['cleans', 'up']: [], 
	  ['kept', 'up']: [], 
	  ['brought', 'in']: [],
	  ['gave', 'away']: [], 
	  ['called', 'back']: []}
nouns = []
adjectives = []

count = 0
dict_list = []
for subject in subjects:
	for verb in verbs:
		for mod_type in ['adj', 'pp']:
			for weight1 in [0,1,1,1,2,2,2,3,3]:
				for weight2 in [0, 1, 1, 1, 2, 2, 2]:
					for prep2 in prepositions2:
						noun_split = noun.split()
						adj_list = list(np.random.choice(adjectives, weight1, replace=False))
						prep_list = list(np.random.choice(prepositions1, weight2, replace=False))
						if weight1 == 0:
							if weight2 == 0:
								unshifted_sentence = f"John {verb} {noun} {prep2}."
								shifted_sentence = f"John {verb} {prep2} {noun}."
							else:
								unshifted_sentence = f"John {verb} {noun} {' '.join(prep_list)} {prep2}."
								shifted_sentence = f"John {verb} {prep2} {noun} {' '.join(prep_list)}."
						else:
							if weight2 == 0:
								unshifted_sentence = f"John {verb} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]}{prep2}."
								shifted_sentence = f"John {verb} {prep2} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]}."
							else:
								unshifted_sentence = f"John {verb} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]} {' '.join(prep_list)} {prep2}."
								shifted_sentence = f"John {verb} {prep2} {noun_split[0]} {', '.join(adj_list)} {noun_split[1]} {' '.join(prep_list)}."
						data = [unshifted_sentence, shifted_sentence]

						print(count)
						print(unshifted_sentence, str(scores[0]))
						print(shifted_sentence, str(scores[1]))
						unshifted_data = {'id': count, 'sentence': unshifted_sentence, 'shifted': False, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[0]}
						shifted_data = {'id': count, 'sentence': shifted_sentence, 'shifted': True, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[1]}
						dict_list.append(unshifted_data)
						dict_list.append(shifted_data)
						count += 1

with open('pm_OUTPUT.json', 'w') as fp:
	for dictionary in dict_list:
		line = json.dumps(dictionary) + '\n'
		fp.write(line)


#====================GENERATING DA DATA====================

prepositions1 = ["with the coat", "from California"]
prepositions2 = ["in the store", "from the market", "at the park", "behind the gym", "at work", "at the event"]
verbs = ["met", "saw", "passed", "greeted"]
nouns = ["the man", "the woman", "his friend", "her friend", "his uncle", "her uncle", "his roommate", "her roommate"]
subjects = ["I", "He", "They", "She"]
adjectives = ["wealthy", "tall", "chatty", "older"]

count = 0
dict_list = []
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
	
							print(count)
							print(unshifted_sentence, str(scores[0]))
							print(shifted_sentence, str(scores[1]))
							unshifted_data = {'id': count, 'sentence': unshifted_sentence, 'shifted': False, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[0]}
							shifted_data = {'id': count, 'sentence': shifted_sentence, 'shifted': True, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[1]}
							dict_list.append(unshifted_data)
							dict_list.append(shifted_data)
							count += 1

with open('da_OUTPUT.json', 'w') as fp:
	for dictionary in dict_list:
		line = json.dumps(dictionary) + '\n'
		fp.write(line)


#====================GENERATING MPP DATA====================

prepositions1 = ["with the coat", "from California"]
prepositions2 = ["in the store", "from the market", "at the park", "behind the gym", "at work", "at the event"]
verbs = ["met", "saw", "passed", "greeted"]
nouns = ["the man", "the woman", "his friend", "her friend", "his uncle", "her uncle", "his roommate", "her roommate"]
subjects = ["I", "He", "They", "She"]
adjectives = ["wealthy", "tall", "chatty", "older"]

count = 0
dict_list = []
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
	
							print(count)
							print(unshifted_sentence, str(scores[0]))
							print(shifted_sentence, str(scores[1]))
							unshifted_data = {'id': count, 'sentence': unshifted_sentence, 'shifted': False, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[0]}
							shifted_data = {'id': count, 'sentence': shifted_sentence, 'shifted': True, 'subject': subject, 'verb': verb, 'noun': noun, 'adjectives': adj_list, 'prepositions': prep_list, 'final_con': prep2, 'final_con_type': 'pp', 'score':scores[1]}
							dict_list.append(unshifted_data)
							dict_list.append(shifted_data)
							count += 1

with open('mpp_OUTPUT.json', 'w') as fp:
	for dictionary in dict_list:
		line = json.dumps(dictionary) + '\n'
		fp.write(line)


