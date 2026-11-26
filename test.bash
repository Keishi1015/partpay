#!/bin/bash

ng () {
    echo ${1}行目のテスト失敗
    res=1
}

res=0

# 1時間勤務
out=$(echo "9:30 10:30" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

# 5時間勤務
out=$(echo "10:00 15:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 7000 ] || ng "$LINENO"

# 4時間30分勤務
out=$(echo "10:00 14:30" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 6300 ] || ng "$LINENO"

# 複数日の勤務
out=$(printf "9:00 14:00\n10:00 14:30\n12:00 14:00\n" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 16100 ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
