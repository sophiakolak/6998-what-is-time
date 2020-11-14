import pandas as pd
data = pd.read_csv('wfC318/Day_0/Raw_files_csv/combined_behavior_and_s.csv', header=None)
print(data)


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
