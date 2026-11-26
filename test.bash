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

# 実労働時間8時間
out=$(echo "9:00 18:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 11200 ] || ng "$LINENO"

# 残業1分
out=$(echo "9:00 18:01" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 11229 ] || ng "$LINENO"

# 残業1時間
out=$(echo "9:00 19:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 12950 ] || ng "$LINENO"

# 残業2時間
out=$(echo "9:00 20:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 14700 ] || ng "$LINENO"

# 残業を含む複数日の勤務
out=$(printf "9:00 19:00\n9:00 20:00\n" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 27650 ] || ng "$LINENO"

# 深夜勤務なし
out=$(echo "21:00 22:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

# 深夜勤務1時間
out=$(echo "22:00 23:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 1750 ] || ng "$LINENO"

# 通常勤務と深夜勤務
out=$(echo "21:00 23:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 3150 ] || ng "$LINENO"

# 残業と深夜勤務の重複
out=$(echo "13:00 23:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 13300 ] || ng "$LINENO"

# 通常・残業・深夜勤務
out=$(echo "12:00 24:00" | ./partpay)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = 17150 ] || ng "$LINENO"

# 早朝の深夜勤務
out=$(echo "3:00 5:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 3500 ] || ng "$LINENO"

# 深夜勤務の終了時刻をまたぐ勤務
out=$(echo "4:00 6:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 3150 ] || ng "$LINENO"

# 5時以降は通常勤務
out=$(echo "5:00 6:00" | ./partpay)
[ "$?" = 0 ]       || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

# 深夜開始時刻の境界
out=$(echo "21:59 22:01" | ./partpay)
[ "$?" = 0 ]     || ng "$LINENO"
[ "${out}" = 52 ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
