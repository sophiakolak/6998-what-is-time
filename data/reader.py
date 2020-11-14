import csv

#with open('wfC318/Day_0/Raw_files_csv/S.csv', newline='\n') as csvfile:
with open('wfC318/Day_0/Raw_files_csv/combined_behavior_and_s.csv', newline='\n') as csvfile:
    dreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    counter = 0
    for row in dreader:
        if counter<5:
            print(', '.join(row))
            counter=counter+1
