input1 = open("input.txt", 'r')

inputArr = []

groupe = []
for newLine in input1:
    txt = newLine.replace('\n','')
    if(txt != ''):
        groupe.append(txt)
    if(newLine == '\n'):
        inputArr.append(groupe)
        groupe=[]

sum = 0
for groupe in inputArr:
    result = set(groupe[0]).intersection(*groupe)
    sum = sum + len(result)

print(sum)