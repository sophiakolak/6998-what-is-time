import pandas as pd
import numpy as np
import time as t

##########
# Things to set:
#filename = 'wfC318/Day_4/raw_files_csv/combined_behavior_and_s_COPY.csv'
filename = 'wfC318/Day_4/raw_files_csv/combined_behavior_and_s.csv'
#filename = 'wfC318/Day_0/Raw_files_csv/combined_behavior_and_s_COPY.csv'


# How many trials we are looking at (ex: 31 for day 0, 34 for day 4)
trial_count = 31
#trial_count = max(lap)  # all of them

##########


data = pd.read_csv(filename, header=None)
print("Prev:", data.head())
print("LEN1:", len(data))
data = data[data[7] <= 4000]  # removing all rows where mouse is licking reward past 4000cm
print("LEN2:", len(data))


time = data[1]
odor = data[10]
distance = data[7]
lap = data[9]
# neuron data starts at column "13", indexed from 0 so the first column of neuron data is data[12]
cell = data.loc[:, 12:(len(data.columns)-1)]  # neuron data


#n_cell = len(data.columns)-12
#nlap = max(lap)

##### Cleaning up data
# Changing neuron firing data to 0,1 binary
num_of_cols = len(data.columns)

for j in range(12, num_of_cols):  # for all neuron columns
    # setting value to 1 if val>0, 0 otherwise
    data[j].apply(lambda x: 1 if x > 0 else 0)
#####

lap_dictionary = {}
for i in range(0, trial_count):  # for every lap
    lap_dictionary[i] = data.loc[data[9] == i]  # associate all lap data with that lap
#print(lap_dictionary)

def findShortestTrial():
    min_time = 999999999
    max_time = 0
    shortest_trial = lap_dictionary[0]
    longest_trial = lap_dictionary[0]
    time_list = []
    for trial in lap_dictionary:
        #pair = lap_dictionary[trial].iloc[[0, -1]]
        first = lap_dictionary[trial].iloc[0]
        last = lap_dictionary[trial].iloc[-1]

        time = last[1] - first[1]
        time_list.append(time)

        if(time < min_time):
            min_time=time
            shortest_trial = trial
        if (time > max_time):
            max_time = time
            longest_trial = trial

    print("AVG trial duration:", sum(time_list)/len(time_list))

    return shortest_trial, min_time, longest_trial, max_time

shortest_trial, min_time,longest_trial, max_time = findShortestTrial()
print("Shortest Trial:", shortest_trial, "Time: ", min_time)
print("Longest Trial:", longest_trial, "Time: ", max_time)

#print("\n\n WTF:", lap_dictionary[76].iloc[0, 0:13],"\n\n")

# create empty row to store neuron data frequencies
empty_row = {}
for k in range(0, num_of_cols-13):  # 459 columns
    empty_row[k] = 0.0

def findMeanValues():
    flagCounter = 0
    test_dictionary_for_laps = {}
    start = t.time()  # for reference
    for i in lap_dictionary:  # for every trial
        # print("Lap number:", i)
        # average columns in that trial to test (eventually, in bin instead)
        current_row = pd.DataFrame(empty_row, index=[0])  # create pandas dataframe from a row of 0's (reset every lap)
        print(i)  # count 98 trial laps
        for j in range(12, num_of_cols):  # for all neuron columns
            #current_row[j - 12] = data[j].mean()
            current_row[j-12] = lap_dictionary[i][j].mean()  # fill each column spot in that row with the mean of all values in that column
            # note: because we set values to (0,1), this mean becomes frequency relative to that trial

        """
        # print a few for testing
        if flagCounter < 5:
            print(current_row)
            flagCounter += 1
        """
        test_dictionary_for_laps[i] = current_row  # set dictionary item equal to that row

    end = t.time()
    print("Time:", end-start)
    return test_dictionary_for_laps

test_dictionary_for_laps = findMeanValues()

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

#index_of_maxs = []
#for row in test_dictionary_for_laps:
#    index_of_maxs.append(test_dictionary_for_laps[row].idxmax())  # something's messed up here

#print(len(index_of_maxs), index_of_maxs)
