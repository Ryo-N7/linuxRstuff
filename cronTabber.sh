read boom
START=$(date +%s)
# do something
$1
# start your script work here
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "XXX $1 $START $DIFF"
