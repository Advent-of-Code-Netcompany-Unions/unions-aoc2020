input1 = open("input.txt", 'r')

inputArr = []

passport = ""
for newLine in input1:
    passport = passport+newLine
    if(newLine == '\n'):
        txt = passport.replace('\n','')
        inputArr.append(txt)
        passport=''


print(len(inputArr))

isValid = True   
def check(chkstr):
    if(isNotinPassport(passport, chkstr)):
        global isValid
        isValid = True

def isNotinPassport(passport, chcStr):
    return chcStr not in passport


numberOfInvalidPassport = 0
for passport in inputArr:
    isValid = False    
    check("byr")
    check("iyr")
    check("eyr")
    check("hgt")
    check("hcl")
    check("ecl")
    check("pid")
    #check("cid")
    if (isValid == True):
        numberOfInvalidPassport = numberOfInvalidPassport+1

print(len(inputArr) - numberOfInvalidPassport)