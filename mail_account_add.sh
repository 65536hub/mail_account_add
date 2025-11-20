#!/bin/bash

###-------------------------------------------------------------------
#ディレクトリ構成（匿名化済み）
DOVECOT_DIR=/etc/dovecot
POSTFIX_DIR=/etc/postfix
SCRIPT_DIR="$HOME/bin/mail_account_tool"
VIRTUAL_USERS=virtual_users_org
VIRTUAL_MAILBOXES=virtual_mailboxes_org

# Dovecotのユーザーリストファイル
DOVECOT_LIST=dovecot_account_list.txt

# Dovecot仮想ユーザーのバックアップファイルの連番
NUM=0

#postfixのリストファイル
POSTFIX_LIST=$SCRIPT_DIR/mail_account_list.txt
###-------------------------------------------------------------------

# 未定義変数・エラー時に終了
set -eU

# 必要な設定ファイル・ディレクトリが存在しない場合はスクリプト終了
if [ ! -f $DOVECOT_DIR/$VIRTUAL_USERS ]; then
        echo "ファイルが存在しません.. $DOVECOT_DIR/$VIRTUAL_USERS"
        exit 1
elif [ ! -d $DOVECOT_DIR/old ]; then
        echo "ディレクトリが存在しません.. $DOVECOT_DIR/old"
        exit 1
elif [ ! -f $POSTFIX_DIR/$VIRTUAL_MAILBOXES ]; then
        echo "ファイルが存在しません.. $POSTFIX_DIR/$VIRTUAL_MAILBOXES"
        exit 1
elif [ ! -d $POSTFIX_DIR/old ]; then
        echo "ディレクトリが存在しません.. $POSTFIX_DIR/old"
        exit 1
elif [ ! -f $POSTFIX_LIST ]; then
        echo "ファイルが存在しません.. $POSTFIX_LIST"
        exit 1
fi


# Dovecot仮想ユーザーのバックアップ
cd $DOVECOT_DIR
if [ ! -f $DOVECOT_DIR/old/$VIRTUAL_USERS.$(date +%Y%m%d) ]; then
       cp -p $VIRTUAL_USERS ./old/$VIRTUAL_USERS.$(date +%Y%m%d)
       echo "=== バックアップファイルを作成しました ==="
       ls -l $DOVECOT_DIR/old/$VIRTUAL_USERS.$(date +%Y%m%d)
       echo
else
       while test -f ./old/$VIRTUAL_USERS.$(date +%Y%m%d)_$NUM
       do
               let NUM++
       done

       cp -pi ./old/$VIRTUAL_USERS.$(date +%Y%m%d) ./old/$VIRTUAL_USERS.$(date +%Y%m%d)_$NUM
       ls -l ./old/$VIRTUAL_USERS.$(date +%Y%m%d)_$NUM
       echo
fi

# ハッシュ化されたパスワード付きDovecotユーザーリストを生成する
echo "###---------- Dovecot User List ----------"
cat $POSTFIX_LIST | while IFS=, read ADDRESS PW
do
                echo -n $ADDRESS; doveadm pw -s cram-md5 -u $ADDRESS -p $PW
done | tee $SCRIPT_DIR/$DOVECOT_LIST
echo -e

awk -F "," '{print $1}' $POSTFIX_LIST | awk -F "@" '{print $1}' | while read LINE
do
        grep $LINE $DOVECOT_DIR/$VIRTUAL_USERS | tail -n 1
done


# Postfix 仮想メールボックスリストを生成する
echo "###---------- Postfix Virtual Mailbox List ----------"
awk '{print $1}' $POSTFIX_LIST | while IFS=@ read USER DOMAIN
do
               echo "$USER@$DOMAIN             $DOMAIN/$USER/Maildir/"

done

