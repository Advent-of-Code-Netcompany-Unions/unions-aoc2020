
input1 = open("input1.txt", 'r')

inputArr = []

for newLine in input1:
    print(newLine.find("\n"))
    test = newLine.replace("\n", "")
    inputArr.append(list(test)*40)

#Traverse map

rowIndex = 0
colIndex = 0
numberOfTrees = 0
print(len(inputArr))
print(len(inputArr[0]))
while (len(inputArr)-1 >= rowIndex):
    if(inputArr[rowIndex][colIndex] == "#"):
        numberOfTrees = numberOfTrees+1
    rowIndex = rowIndex + 1
    colIndex = colIndex + 3

print("rowindex: ", rowIndex)
print("colIndex: " , colIndex)
print(numberOfTrees)