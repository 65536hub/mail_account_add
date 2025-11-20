このリポジトリには、Linux サーバ上で Dovecot/Postfix を利用している環境向けのメールアカウント管理スクリプトが含まれています。


---

## 1. 目的

 本スクリプトは以下の運用自動化を目的として作成。

 - Postfix の virtual_mailbox（仮想ユーザ）と Dovecot のメールアカウントを大量に自動生成
---


## 2. スクリプトの概要

メールアカウント追加・更新 (mail_account_add.sh)

- Postfix 用仮想メールボックスリストの生成  
- Dovecot 用ハッシュ化パスワードリストの生成  
- バックアップ機能（既存ユーザーデータの退避）

## 3. スクリプトの構成

```
mail_account_tool/
├─ mail_account_add.sh       # メールアカウント生成スクリプト
├─ mail_account_list.txt     # アカウント追加用サンプルリスト
└─ README.md                 # このファイル
```

## 4. 事前準備

- RHEL系のLinux環境上にDovecot および Postfix がインストール済みであること  
- 以下のディレクトリ構成が存在すること（ポートフォリオ用に匿名化しています）

```
作業対象のディレクトリ・ファイル構成（匿名化済み）

/etc/dovecot/old            # Dovecot バックアップ保存用(事前に作成しておく)
/etc/postfix/old            # Postfix バックアップ保存用(事前に作成しておく)
~/bin/mail_account_tool/    # スクリプト配置ディレクトリ(配置場所は任意で)

Dovecot ユーザーリストファイル（例: virtual_users_org）
Postfix 仮想メールボックスファイル（例: virtual_mailboxes_org）
```

使用方法
メールアカウントの追加・更新
```
cd ~/bin/mail_account_tool
./mail_account_add.sh
```

## 5. 実行方法

- 処理内容(mail_account_add.sh)

 1. Dovecot/Postfix の設定ファイルが存在するかチェック
 2. Dovecot 仮想ユーザーのバックアップ作成
 3. mail_account_list.txt をもとにハッシュ化パスワードを生成
 4. Postfix 仮想メールボックスリストを生成


```
mail_account_list.txt の形式（サンプル）

test01@abc.jp,password1
test02@abc.jp,password2
test03@xyz.com,password3
test04@xyz.com,password4
```

## 6. 注意事項

- 実運用環境で使用する場合は、必ず既存データのバックアップを作成してください
- mail_account_list.txt に平文パスワードが含まれるため、アクセス制限を行ってください
- Dovecot のパスワードハッシュ方式（例: cram-md5）は環境に応じて変更可能です
