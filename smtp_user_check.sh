#!/bin/bash

### --------- Dovecot-SASL Auth Check ----------

# 引数でユーザリストファイルを指定
USER_LIST=$1

# エラー時に終了
set -eU

# 引数チェック
if [ -z "$USER_LIST" ]; then
    echo "Usage: $0 <user_list_file>"
    exit 1
fi

# SMTP認証チェック開始
cat ${LIST} | while read LINE
do
	arr=($LINE)
	ADDRESS=${arr[0]}
	PW=${arr[1]}

doveadm auth login ${ADDRESS} ${PW} > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "### ${ADDRESS} ###"
	echo "OK"
else
	echo "### ${ADDRESS} ###"
	echo "Faild"
fi

done
