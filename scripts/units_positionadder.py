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
        print filename
        print p
        print len(phone_array) 
        print 'The value of i is '  + str(i)
        print 'The Current phone is ' + phone_array[i]
        if i < len(phone_array) -1:
         print 'The next phone is ' + phone_array[i+1]
        print ' ' 
        if i == len(phone_array) - 1:
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
            if fname[-4:] != '.lab':
                continue
            fullfname = d + '/' + fname
            phone_array = []
            time_array = []
            fr = open(fullfname)
            f0_array = f0_reader(fname)
            energy_array = energy_reader(fname)
            phonesuffix_array = phonesuffix_adder(fullfname)
            for line in fr:
                if line.split('\n')[0] == '#':
                   continue
                [s, e, p ] = line.rstrip('\n').split()
                time_array.append(s)
                phone_array.append(p)               
            fw = open(fullfname[:-4] + '.suffixlab', 'w')
            i = 0
            for line in range(0, len(time_array) -1):
#              try:
                print i
                current_time = time_array[i]
                next_time = time_array[i+1]
                phone = phonesuffix_array[i]
                s_ns = str(int(float(current_time)*16000 ))
                e_ns = str(int(float(next_time)*16000 ))
                start_frame = str(int(s_ns)/80)
          # Adding a cheap trick to eliminate the Index Error. Assumption is that the energy in the last two frames is fairly constant.
                end_frame = str(int(e_ns)/80-2)             
                #print len(time_array)
                print len(energy_array)
                print len(f0_array)
                print fullfname
                print start_frame , end_frame                
                start_energy = energy_array[int(start_frame) - 1]
                end_energy = energy_array[int(end_frame) ]
                start_f0 = f0_array[int(start_frame) - 1]
                end_f0 = f0_array[int(end_frame)  ]
                fw.write( phone + ' ' + s_ns + ' ' + e_ns + ' '  + start_frame + ' ' + end_frame + ' ' + start_energy + ' ' + end_energy + ' ' + start_f0 + ' ' + end_f0 + ' ' + fname +  '\n')
                i = i + 1
#              except IndexError:
#                pass
            fr.close()
            fw.close()
            print "Converted", fullfname


if __name__ == '__main__':
    folder = '../lab'
    if len(sys.argv) > 1:
        folder = sys.argv[1]
    print "Converting and accomodating the dictionary", folder
    convert(folder)
