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
cell = data.loc[:, 12:(len(data.columns)-1)]  # neuron data
print(cell)

n_cell = len(data.columns)-12
nlap = max(lap)
print("LEN", n_cell)
# find way to find last lap
# in matlab, used find() to find row with the most number of equal components
# i.e. the row that was previously selected
# iLast(max())  # find way to find last lap --> just use counter?

#lapDistance = []
#for i in range(0, nlap):
    #lapDistance.append( distance(iLap(i),iLap(i+1)) ) range in iLap

lap_dictionary = {}
for i in range(0, max(lap)):
    lap_dictionary[i] = data.loc[data[9] == i]
print(lap_dictionary)


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