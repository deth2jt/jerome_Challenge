# Enter your code here. Read input from STDIN. Print output to STDOUT
# Enter your code here. Read input from STDIN. Print output to STDOUT
import sys
import re

#ccn=6 seems wrong but I will account for it
for line in sys.stdin:
    #sys.stdout.write(line)
    #print(line)
    if(len(line) >= 16):
        pattern = '^[456][0-9]{15}|^[456][0-9]{3}-[0-9]{4}-[0-9]{4}-[0-9]{4}'
        #pattern2 = r'([0-9])\1\1\1'
        pattern2 = r"(?:.*)([0-9])\1\-\1\1(?:.*)"
        pattern3 = r"(?:.*)([0-9])\1\1\-\1(?:.*)"
        pattern4 = r"(?:.*)([0-9])\1\1\1\-(?:.*)"
        pattern5 = r"(?:.*)-([0-9])\1\1\1(?:.*)"
        pattern6 = r"(?:.*)([0-9])-\1\1\1(?:.*)"
        result = re.match(pattern, line)
        result2 = re.match(pattern2, line)
        result3 = re.match(pattern3, line)
        result4 = re.match(pattern4, line)
        result5 = re.match(pattern5, line)
        result6 = re.match(pattern6, line)
        #print(result and not result2)
        if result and not (result2 or result3 or result4 or  result5 or result6):
            #if result2:
            #sys.stdout.write("Valid")
            print("Valid")
        else:
            #sys.stdout.write("Invalid") 
            print("Invalid") 
        #sys.stdout.write("\n")
