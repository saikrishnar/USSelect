#! /usr/bin/bash
cd scripts
#matlab -nodesktop -nodisplay -nosplash  -r "dictionary_preparer_f0 ; quit;" 
matlab -nodesktop -nodisplay -nosplash  -r "dictionary_preparer_energy ; quit;" 
python convert_phonelabels.py
cd ../lab
rm prosody.dict tel.dict phones.dict mean_repo.dict
cat *.dict > tel.dict
cut -d ' ' -f 1 tel.dict > phones.dict
cut -d ' ' -f 2- tel.dict > prosody.dict
cd ../scripts
matlab -nodesktop -nodisplay -nosplash  -r "repo_preparer ; quit;" 
cd ../lab
paste -d ' ' phones.txt mean_durs.txt > mean_repo.dict
rm prosody.dict tel.dict phones.dict phones.txt mean_durs.txt
