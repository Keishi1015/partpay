#!/bin/bash
# SPDX-FileCopyrightText: 2026 Keishi Yonezawa
# SPDX-License-Identifier: BSD-3-Clause

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

# 6時間ちょうど
out=$(echo "9:00 15:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 8400 ] || ng "$LINENO"

# 6時間1分
out=$(echo "9:00 15:01" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 7373 ] || ng "$LINENO"

# 8時間勤務（拘束時間）
out=$(echo "9:00 17:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 10150 ] || ng "$LINENO"

# 8時間45分
out=$(echo "9:00 17:45" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 11200 ] || ng "$LINENO"

# 8時間46分
out=$(echo "9:00 17:46" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 10873 ] || ng "$LINENO"

# 9時間勤務（拘束時間）
out=$(echo "9:00 18:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 11200 ] || ng "$LINENO"

# 10時間勤務（拘束時間）
out=$(echo "9:00 19:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 12600 ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
