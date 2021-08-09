'''

Given the participants' score sheet for your University Sports Day, you are
required to find the runner-up score. You are given scores. Store them in a
list and find the score of the runner-up.

'''
if __name__ == '__main__':
    n = int(input())
    arr = [int(n) for n in input().split()]
    
    winner = max(arr)
    #arr[:] = (n for n in arr if n != winner)

    print(max([n for n in arr if n != winner]))

'''
O(n) solution

    winner = runner_up = -1
    for n in arr:
        if n > winner:
            runner_up = winner
            winner = n
        elif n > runner_up and n != winner:
            runner_up = n

    return runner_up
'''
