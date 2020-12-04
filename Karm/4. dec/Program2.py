import re 

input1 = open("input.txt", 'r')

inputArr = []

passport = ""
for newLine in input1:
    passport = passport+newLine
    if(newLine == '\n'):
        txt = passport.replace('\n',' ')
        inputArr.append(txt)
        passport=''

isValid = True   
def check(chkstr):
    if(isNotinPassport(passport, chkstr)):
        global isValid
        isValid = True

def isNotinPassport(passport, chcStr):
    return chcStr not in passport


numberOfValidPassport = []
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
    if (isValid == False):
        numberOfValidPassport.append(passport)

#check elements
isElementvalid = False
def checkhgt(passportele):
    global isElementvalid
    for element in passportele:
        if(element.startswith("hgt")):
            value = element.split(":")[1]
            if ("cm" in value):
                hgt = value.replace("cm", "")
                if(not (150 <= int(hgt) <= 193)):
                    isElementvalid = False
            else:
                hgt = value.replace("in", "")
                if(not (59 <= int(hgt) <= 76)):
                    isElementvalid = False

def checkElement(passportele, key, lowerLimit, higherlimit):
    global isElementvalid
    for element in passportele:
        if(element.startswith(key)):
            
            value = element.split(":")[1]
            if(not (lowerLimit <= int(value) <= higherlimit)):
                isElementvalid = False

def checkhcl(passportele):
    global isElementvalid
    for element in passportele:
        if(element.startswith("hcl")):
            value = element.split(":")[1]
            if("#" not in value):
                isElementvalid = False
            if(len(value) != 7):
                isElementvalid = False
            txtMatch = re.match("#[0-9]*[a-f]*", value)
            if(txtMatch is None):
                isElementvalid = False

def checkEye(passportele):
    global isElementvalid
    for element in passportele:
        if(element.startswith("ecl")):
            value = element.split(":")[1]
            exclusions = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
            if(value not in exclusions):
                isElementvalid = False

def checkpid(passportele):
    global isElementvalid
    for element in passportele:
        if(element.startswith("pid")):
            value = element.split(":")[1]
            if(len(value) != 9):
                isElementvalid = False


validPassports = []
for passport in numberOfValidPassport:
    isElementvalid = True
    passportElements = passport.split(" ")
    checkhgt(passportElements)
    checkElement(passportElements, "byr", 1920, 2020)
    checkElement(passportElements, "iyr", 2010, 2020)
    checkElement(passportElements, "eyr", 2020, 2030)
    checkhcl(passportElements)
    checkEye(passportElements)
    checkpid(passportElements)
    if (isElementvalid == True):
        validPassports.append(passport)
print(len(numberOfValidPassport))
print(len(validPassports))

