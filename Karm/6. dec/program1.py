input1 = open("input.txt", 'r')

inputArr = []

groupe = ""
for newLine in input1:
    groupe = groupe+newLine
    if(newLine == '\n'):
        txt = groupe.replace('\n','')
        inputArr.append(txt)
        groupe=''

repeatingQ = []
sum = 0
for groupe in inputArr:
    sum = sum + len(set(groupe))

print(sum)