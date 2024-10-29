#!/bin/dash
case "$1" in
0)
    echo the
    echo
    echo "ANSWER is  2"
    ;;
1)
    echo " The "
    echo "  "
    echo "answer    is 2 "
    ;;
2)
    echo The
    echo "answer is  d"
    echo
    ;;
3)
    echo There is extra
    echo text here
    echo "but answer is still 2"
    ;;
*)
    echo The
    echo
    echo "answer is  $1"
esac
