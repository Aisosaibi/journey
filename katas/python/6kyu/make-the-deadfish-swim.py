# Codewars kata: https://www.codewars.com/kata/make-the-deadfish-swim
# 6 kyu, python

def parse(data):
    value = 0
    result = []
    
    for cmd in data:
        match cmd:
            case 'i': value += 1
            case 'd': value -= 1
            case 's': value **= 2
            case 'o': result.append(value)
            
    return result
