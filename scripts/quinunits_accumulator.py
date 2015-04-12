#!/usr/bin/python

# This program adds the suffixes _b , _e and _m to the phone labels


import os, sys

def f0_reader(filename):
    filestr = filename.split('.')[0]
    filename = '../f0/' + filestr + '.f0'
    f0_array = []   
    f = open(filename)
    for line in f:
         f0_array.append(line.split('\n')[0])
    return f0_array

def phonesuffix_adder(filename):
    f = open(filename)
    phone_array = []
    for line in f :
            if line.split('\n')[0] == '#':
                continue
            [s, e, p] = line.rstrip('\n').split()     
            phone_array.append(p)
    i = 0
    phonesuffix_array = []
    for p in phone_array:
        #print filename
        #print p
        #print len(phone_array) 
        #print 'The value of i is '  + str(i)
        #print 'The Current phone is ' + phone_array[i]
        if i < len(phone_array) :
         #print 'The next phone is ' + phone_array[i+1]
          pass
        #print ' ' 
        if i == len(phone_array) :
            pass
        else:
            
            if p == 'SIL':
             #i = i  + 1   
             phonesuffix_array.append(p)         
                         
            elif phone_array[i+1] == 'SIL':
             p = p + '_e'  
             #i = i  + 1
             phonesuffix_array.append(p)  
                         
            elif phone_array[i-1] == 'SIL':
             p = p + '_b' 
             #i = i  + 1 
             phonesuffix_array.append(p)  
                         
            else :
             p = p + '_m'  
             #i = i  + 1
             phonesuffix_array.append(p) 
            i = i  + 1 
    return phonesuffix_array



def quincontext_adder(phonesuffix_array, time_array ,f0_array, energy_array):
      print len(phonesuffix_array)
      print len(time_array)
      print len(f0_array)
      print len(energy_array)
      quinphonesuffix_array = []
      quintime_array = []
      quinf0_array = []
      quinenergy_array = []
      for i in range(2, len(time_array) - 2 ): 
           #print i
           phoneme_2p = phonesuffix_array[i-2]
           time_2p = time_array[i-2]
           f0_2p = f0_array[i-2]
           energy_2p = energy_array[i-2]         
           #phoneme_2p_index = uniquephone_list.index(phoneme_2p)

           phoneme_1p = phonesuffix_array[i-1]
           time_1p = time_array[i-1]
           f0_1p = f0_array[i-1]
           energy_1p = energy_array[i-1]
           #phoneme_1p_index = uniquephone_list.index(phoneme_1p)

           phoneme_c = phonesuffix_array[i]
           time_c = time_array[i]
           f0_c =  f0_array[i]
           energy_c = energy_array[i]        
           #phoneme_index = uniquephone_list.index(phoneme)

           phoneme_1n = phonesuffix_array[i+1]
           time_1n = time_array[i+1]
           f0_1n =  f0_array[i+1]
           energy_1n = energy_array[i+1]  
           #phoneme_1n_index = uniquephone_list.index(phoneme_1n)

           phoneme_2n = phonesuffix_array[i+2]
           time_2n = time_array[i+2]
           f0_2n =  f0_array[i+2]
           energy_2n = energy_array[i+2]  
           #phoneme_2n_index = uniquephone_list.index(phoneme_2n)

           quin_phoneme = phoneme_2p + ' ' + phoneme_1p + ' ' + phoneme_c + ' '+  phoneme_1n + ' ' + phoneme_2n
           quin_time = time_2p + ' ' + time_1p + ' ' + time_c + ' ' + time_1n + ' ' + time_2n
           quin_f0 = f0_2p + ' ' + f0_1p + ' ' + f0_c + ' ' + f0_1n + ' ' + f0_2n
           quin_energy = energy_2p + ' ' + energy_1p + ' ' + energy_c +' ' +  energy_1n + ' ' + energy_2n           
           quinphonesuffix_array.append(quin_phoneme)
           quintime_array.append(quin_time)
           quinf0_array.append(quin_f0)
           quinenergy_array.append(quin_energy)
      return quinphonesuffix_array, quintime_array, quinf0_array, quinenergy_array
     

def energy_reader(filename):
    filestr = filename.split('.')[0]
    filename = '../energy/' + filestr + '.energy'
    energy_array = []   
    f = open(filename)
    for line in f:
         energy_array.append(line.split('\n')[0])
    return energy_array




def convert(folder):
    for d, ds, fs in os.walk(folder):
        for fname in fs:
            #print fname
            if fname[-4:] != '.lab':
                continue
            fullfname = d + '/' + fname
            phone_array = []
            time_array = []
            fr = open(fullfname)
            for line in fr:
                if line.split('\n')[0] == '#':
                   continue
                [s, e, p ] = line.rstrip('\n').split()
                time_array.append(s)
            f0_array = f0_reader(fname)
            energy_array = energy_reader(fname)
            phonesuffix_array = phonesuffix_adder(fullfname)
            [quinphonessuffix_array, quintime_array, quinf0_array, quinenergy_array] = quincontext_adder(phonesuffix_array, time_array, f0_array, energy_array)
            fw = open(fullfname[:-4] + '.quinsuffixlab', 'w')
            fr.close()
            print len(quinphonessuffix_array)
            #print quintime_array
            #print quinf0_array
            #print quinenergy_array
            for k in range( 0, len(quinphonessuffix_array)):
              print fullfname
              print k
              fw.write( quinphonessuffix_array[k] + ' ' +  quintime_array[k] + ' ' + quinenergy_array[k] + ' ' + quinf0_array[k] + '\n' )     
            fw.close()
            print "Converted", fullfname


if __name__ == '__main__':
    folder = '../lab'
    if len(sys.argv) > 1:
        folder = sys.argv[1]
    print "Converting and accomodating the dictionary", folder
    convert(folder)
