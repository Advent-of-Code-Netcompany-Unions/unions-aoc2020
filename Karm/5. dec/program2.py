input1 = open("input.txt", 'r')

inputArr = []


for newLine in input1:
    inputArr.append(newLine)


totalRows = 127
totalseats = 8

def getupperOrLower(letter, value, key):
    if(letter == key):
        lower = value[0]
        upper = value[1]
        upper = lower + int((value[1]-value[0])/2)
        return [lower, upper]
    else:
        lower = value[0]
        upper = value[1]
        lower = lower + int((value[1]-value[0])/2)+1
        return [lower, upper]

def findSeat(boardingpass):
    seats = [0, 7]
    for index in range(7,10):
        letter = list(boardingpass)[index]
        seats = getupperOrLower(letter, seats, "L")
    return seats

result = []
for seatNumber in inputArr:
    rows = [0,127]

    index = 0
    for letter in list(seatNumber):
        index = index+1      
        if (index >= 7):
            if(list(seatNumber)[6] == "F"):
                rows= rows[0]
                seats = findSeat(seatNumber)[0]
            else:
                rows= rows[1]
                seats = findSeat(seatNumber)[0]  
            result.append(rows*8+seats)    
            break
        rows = getupperOrLower(letter, rows, "F")
result.sort()
index = 0
for number in result:
    nextIndex = index+1
    nextNumber = number+1
    if(nextNumber != result[nextIndex] ):
        print(number, " ", result[nextIndex])
        print(nextNumber)
    index = index+1


            

