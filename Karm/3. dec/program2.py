
input1 = open("input1.txt", 'r')

inputArr = []

for newLine in input1:
    test = newLine.replace("\n", "")
    inputArr.append(list(test)*90)

#Traverse map

def findNumberOfTrees(slopeX, slopeY):
    rowIndex = 0
    colIndex = 0
    numberOfTrees = 0
    while (len(inputArr)-1 >= rowIndex):
        if(inputArr[rowIndex][colIndex] == "#"):
            numberOfTrees = numberOfTrees+1
        rowIndex = rowIndex + slopeY
        colIndex = colIndex + slopeX
    return numberOfTrees


a = findNumberOfTrees(1, 1)
b = findNumberOfTrees(3, 1)
c = findNumberOfTrees(5, 1)
d = findNumberOfTrees(7, 1)
e = findNumberOfTrees(1, 2)

print(a)
print(b)
print(c)
print(d)
print(e)

print(a*b*c*d*e)


