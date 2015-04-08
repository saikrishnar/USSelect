#! /usr/bin/bash

cd scripts

matlab -nodesktop -nodisplay -nosplash  -r "dictionary_preparer ; quit;" 
matlab -nodesktop -nodisplay -nosplash  -r "dictionary_preparer_energy ; quit;" 
python convert_labels.py
cd ../lab
cat *.dict > tel.dict
cut -d ' ' -f 1 tel.dict > phones.dict
cut -d ' ' -f 2- tel.dict > prosody.dict
