#!/usr/bin/ksh
#This shell filters error messages from a log file. If there is an error that is critical, a message will be sent saying that a critical
#error was found. 
#Possible cases:
#
#log file 1: Two non-critical erros. Output: "No critical error was found". ERR-09, ERR-08.
#log file 2: One non-critical error. Output: "No critical error was found". ERR-09.
#log file 3: One non-critical error and one critical error. Output: "Error was found". ERR-09, ERR-02.
#log file 4: Two non-critical error and one critical error. Output: "Error was found". ERR-09, ERR-08 ERR-05.
#Log file example:
# ERR-01... ERR-02... ERR-09... ERR-04... ERR-05... ERR-03 ERR-01... ERR-02... ERR-02... ERR-08... ERR-05... ERR-03

umask 111
. $HOME/ .bash_profile

#store errors that are not critical in variables
ERR09= `grep -o ERR-09 /file-path/logfile.txt`
ERR08= `grep -o ERR-09 /file-path/logfile.txt`

echo "List the errors from log file."
echo "*******************************"

# eliminating possible duplicate errors
ERRLIST= $(grep -e 'ERR*' /file-path/logfile.txt | awk '{ for (i=1; i < NF; i++) if (!a[$i]++) printf ("%s%s", $i, FS) }{ printf("\n") }')
echo $ERRLIST

# get the number of errors:
echo: "number of errors:"
echo "$ERRLIST" | grep -c 'ERR'
#store the number in a variable
total = `echo "$ERRLIST" | grep -c 'ERR'`
echo $total


#f there is not error then output: no erros

if [ 0 == $total ]; then
    echo "no errors"
    exit 0
    
elif [[ 2 == $total && -n $ERR09 && -n $ERR08]]; then
    echo "No critical error was found"
    exit 0

elif  [[ 1 == $total &&  -n $ERR08]]; then
    echo "No critical error was found"
    exit 0

elif  [[ 1 == $total &&  -n $ERR09]]; then
    echo "No critical error was found"
    exit 0

else
    echo "Error was found"
    exit 1
fi