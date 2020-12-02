
input1 = open("input1.txt", 'r')

inputArr = []

for newLine in input1:
    repeatRange = newLine.split(" ")[0]
    letter = newLine.split(" ")[1].replace(":", "")
    password = newLine.split(" ")[2]
    inputArr.append([repeatRange, letter, password])

print("input size: ", len(inputArr))

validpasswords = []

for k in inputArr:
    letter = k[1]
    minimum, maximum = k[0].split("-")
    password = k[2]
    amount = password.count(letter)
    if (letter == password[int(minimum)-1] or letter == password[int(maximum)-1]):
        if (letter == password[int(minimum)-1] and letter == password[int(maximum)-1]):
            continue
        validpasswords.append(k)


print("number of valid pass: ", len(validpasswords))