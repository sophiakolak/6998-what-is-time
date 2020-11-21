import pandas as pd

data = pd.read_csv('wfC318/Day_4/Raw_files_csv/combined_behavior_and_s.csv', header=None)
#data.info()
print(data.head())
length = len(data)
print(length)

#print(data.sample(5))
#print(data)
#print(data.iloc[1])

"""
for i, j in data.iterrows():
    print(i, j)
print(data.at[4,7])
print(data.at[5,7])
print(data.at[6,7])
print(data.loc[4,7])
print(data.loc[5,7])
"""

counter=0
for i in range(0, length):  # for every row of data
    if data.at[i, 7]>4000:  # if the distance > 4000
        counter += 1  # number of rows removed
        print(counter, data.at[i,7])
        data.pop(i)  # remove that row

print("New length:", len(data))


"""
#with open('wfC318/Day_0/Raw_files_csv/S.csv', newline='\n') as csvfile:
with open('wfC318/Day_0/Raw_files_csv/combined_behavior_and_s.csv', newline='\n') as csvfile:
    dreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    counter = 0
    matrix = []
    for row in dreader:
        matrix.append(row)
        if counter<5:
            print(', '.join(row))
            print("adding:", row)
            counter=counter+1

"""
