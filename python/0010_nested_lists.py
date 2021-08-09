'''

Given the names and grades for each student in a class of N students, store
them in a nested list and print the name(s) of any student(s) having the second
lowest grade.

Note: If there are multiple students with the second lowest grade, order their
names alphabetically and print each name on a new line.

'''
from collections import defaultdict

if __name__ == '__main__':
    students = []
    for _ in range(int(input())):
        name = input()
        score = float(input())
        
        students.append([name, score])
    
    grades = defaultdict(lambda: [])
    lowest = second_lowest = 999
    for s, g in students:
        if g < lowest:
            second_lowest = lowest
            lowest = g
        elif g < second_lowest and g != lowest:
            second_lowest = g
        
        grades[g].append(s)
        
    print(*sorted(grades[second_lowest]), sep='\n')


'''

marksheet = [[input(), float(input())] for _ in range(n)]

second_highest = sorted(list({marks for name, marks in marksheet}))[1]
print('\n'.join([a for a,b in sorted(marksheet) if b == second_highest]))

'''



