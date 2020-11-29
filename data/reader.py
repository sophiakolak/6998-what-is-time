import pandas as pd
import numpy as np

data = pd.read_csv('wfC318/Day_4/Raw_files_csv/combined_behavior_and_s.csv', header=None)
#data.info()
print(data.head())
length = len(data)
print(length)

#print(data.sample(5))
#print(data)
#print(data.iloc[1])


print("hello")

"""
for i, j in data.iterrows():
    print(i, j)
print(data.at[4,7])
print(data.at[5,7])
print(data.loc[4,7])
print(data.loc[5,7])
"""


time = data[1]
odor = data[10]
distance = data[7]
lap = data[9]
# neuron data starts at column "13", indexed from 0 so the first column of neuron data is data[12]
cell = data.loc[:, 12:(len(data.columns)-1)]  # neuron data
#print(cell)
print("TEST MAX N1:", max(data[12]), " N2:", max(data[13]))

n_cell = len(data.columns)-12
nlap = max(lap)
#print("LEN", n_cell)
# find way to find last lap
# in matlab, used find() to find row with the most number of equal components
# i.e. the row that was previously selected
# iLast(max())  # find way to find last lap --> just use counter?


lap_dictionary = {}
for i in range(0, max(lap)): # for every lap
    lap_dictionary[i] = data.loc[data[9] == i]  # associate all lap data with that lap
#print(lap_dictionary)

# create empty row to be used as neuron data
empty_row = {}
for k in range(0,459):  # 459 columns
    empty_row[k] = 0.0
print("empty_row!", len(empty_row), empty_row)

test_dictionary_for_laps = {}
for i in lap_dictionary:  # for every trial
    #print("Lap number:", i)

    # average columns in that trial to test (eventually, in bin instead)
    current_row = pd.DataFrame(empty_row, index=[0])  # create pandas dataframe from a row of 0's
    print(i)
    for j in range(12, 471):  # for all neuron columns
        print(j)
        # setting value to 1 if val>0, 0 otherwise
        # if we really have to do this, find a different way
        for l in range(0, len(data[j])):
            print(l)
            if data[j][l] > 0:
                data.at[j, l] = 1  # replaces float value with binary --> this is crazy slow
                #print("hello!")

        current_row[j-12] = data[j].mean()  # fill each column spot in that row with the mean of all values in that column
        # note: because we set values, this mean becomes frequency relative to that trial

    test_dictionary_for_laps[i] = current_row  # set dictionary item equal to that row

print(test_dictionary_for_laps)

"""
ilast =
np.zeros( define size )
bins = pd.DataFrame( zero'd bins )

# Remove rows where mouse is licking for reward past 4000
counter=0
for i in range(0, length):  # for every row of data
    if data.at[i, 7]>4000:  # if the distance > 4000
        counter += 1  # number of rows removed
        print(counter, data.at[i,7])
        data.pop(i)  # remove that row

print("New length:", len(data))
"""