#!/bin/bash
# SPDX-FileCopyrightText: 2026 Keishi Yonezawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo ${1}行目のテスト失敗
    res=1
}

res=0

# 基本給料
out=$(echo "9:30 10:30" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

out=$(echo "10:00 15:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 7000 ] || ng "$LINENO"

out=$(echo "10:00 14:30" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 6300 ] || ng "$LINENO"

# 複数日の合計
out=$(printf "9:00 14:00\n10:00 14:30\n12:00 14:00\n" | ./partpay -t)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 16100 ] || ng "$LINENO"

# 休憩時間
out=$(echo "9:00 15:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 8400 ] || ng "$LINENO"

out=$(echo "9:00 15:01" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 7373 ] || ng "$LINENO"

out=$(echo "9:00 17:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10150 ] || ng "$LINENO"

out=$(echo "9:00 17:45" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 11200 ] || ng "$LINENO"

out=$(echo "9:00 17:46" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10873 ] || ng "$LINENO"

# 残業割増
out=$(echo "9:00 18:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 11200 ] || ng "$LINENO"

out=$(echo "9:00 18:01" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 11229 ] || ng "$LINENO"

out=$(echo "9:00 19:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 12950 ] || ng "$LINENO"

out=$(echo "9:00 20:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 14700 ] || ng "$LINENO"

out=$(printf "9:00 19:00\n9:00 20:00\n" | ./partpay -t)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 27650 ] || ng "$LINENO"

# 深夜割増
out=$(echo "21:00 22:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

out=$(echo "22:00 23:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1750 ] || ng "$LINENO"

out=$(echo "21:00 23:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 3150 ] || ng "$LINENO"

out=$(echo "13:00 23:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 13300 ] || ng "$LINENO"

out=$(echo "12:00 24:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 17150 ] || ng "$LINENO"

out=$(echo "9:00 23:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 20300 ] || ng "$LINENO"

out=$(echo "3:00 5:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 3500 ] || ng "$LINENO"

out=$(echo "4:00 6:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 3150 ] || ng "$LINENO"

out=$(echo "5:00 6:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1400 ] || ng "$LINENO"

out=$(echo "21:59 22:01" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 52 ] || ng "$LINENO"

# 不正入力
for input in "abc def" "a:00 18:00" "9:00" \
             "9:00 18:00 19:00" "9:60 18:00" \
             "25:00 26:00" "-1:00 18:00" \
             "9:00 24:01" "24:00 24:00" ""
do
    out=$(echo "$input" | ./partpay 2>/dev/null)
    [ "$?" = 1 ] || ng "$LINENO"
    [ "${out}" = "" ] || ng "$LINENO"
done

# 複数行の途中で不正入力
out=$(printf "9:00 10:00\nabc def\n" | ./partpay 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

# 標準エラー出力
out=$(echo "9:60 18:00" | ./partpay 2>&1 >/dev/null)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "分の範囲が正しくありません" ] || ng "$LINENO"

# 日付またぎ
out=$(echo "23:00 1:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 3500 ] || ng "$LINENO"

out=$(echo "22:00 2:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 7000 ] || ng "$LINENO"

out=$(echo "18:00 2:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 11550 ] || ng "$LINENO"

out=$(echo "22:00 5:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10937 ] || ng "$LINENO"

out=$(echo "23:00 6:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10850 ] || ng "$LINENO"

out=$(echo "18:00 4:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 15050 ] || ng "$LINENO"

out=$(echo "23:59 0:01" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 58 ] || ng "$LINENO"

out=$(echo "23:00 5:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10500 ] || ng "$LINENO"

out=$(echo "9:00 9:00" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 0 ] || ng "$LINENO"

out=$(printf "23:00 1:00\n22:00 2:00\n" | ./partpay -t)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 10500 ] || ng "$LINENO"

# 時給指定
out=$(echo "9:00 10:00" | ./partpay -w 1500)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1500 ] || ng "$LINENO"

# 長い形式のオプション
out=$(echo "9:00 10:00" | ./partpay --wage 1600)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 1600 ] || ng "$LINENO"

# 時給変更と深夜割増
out=$(echo "22:00 23:00" | ./partpay -w 1600)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 2000 ] || ng "$LINENO"

# 日ごとの出力
out=$(printf "9:00 10:00\n10:00 12:00\n" | ./partpay)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "$(printf '1400\n2800')" ] || ng "$LINENO"

# 合計出力
out=$(printf "9:00 10:00\n10:00 12:00\n" | ./partpay -t)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 4200 ] || ng "$LINENO"

# オプションの併用
out=$(printf "9:00 10:00\n10:00 12:00\n" | ./partpay -w 1500 -t)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = 4500 ] || ng "$LINENO"

# 不正な時給
for wage in 0 -100 abc 1400.5
do
    out=$(echo "9:00 10:00" | ./partpay -w "$wage" 2>/dev/null)
    [ "$?" = 2 ] || ng "$LINENO"
    [ "${out}" = "" ] || ng "$LINENO"
done

# 存在しないオプション
out=$(./partpay -x 2>/dev/null)
[ "$?" = 2 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

# ヘルプ
./partpay -h >/dev/null
[ "$?" = 0 ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
