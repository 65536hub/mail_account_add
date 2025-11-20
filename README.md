■概要

このリポジトリには、Linux サーバ上で Dovecot/Postfix を利用している環境向けのメールアカウント管理スクリプトが含まれています。

主な機能は以下の通りです。

1.メールアカウント追加・更新 (mail_account_add.sh)

- Postfix 用仮想メールボックスリストの生成  
- Dovecot 用ハッシュ化パスワードリストの生成  
- バックアップ機能（既存ユーザーデータの退避）

2.SMTP 認証チェック (smtp_user_check.sh)

- Dovecot SASL 認証の確認
- 指定ユーザーリストに対してログイン可否を検証


```
スクリプト構成（匿名化済み）

mail_account_tool/
├─ mail_account_add.sh       # メールアカウント生成スクリプト
├─ smtp_user_check.sh        # SMTP認証チェックスクリプト
├─ mail_account_list.txt     # アカウント追加用サンプルリスト
└─ README.md                 # このファイル
```

■事前準備

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
1. メールアカウントの追加・更新
```
cd ~/bin/mail_account_tool
./mail_account_add.sh
```

■処理内容(mail_account_add.sh)

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

※カンマ区切りで <メールアドレス>,<パスワード> の形式

2. SMTP 認証チェック
```
./smtp_user_check.sh mail_account_list.txt
```

■処理内容(smtp_user_check.sh)

- 指定したユーザーリストに対して doveadm auth login を実行
- ログイン成功/失敗を表示


■注意事項

- 実運用環境で使用する場合は、必ず既存データのバックアップを作成してください
- mail_account_list.txt に平文パスワードが含まれるため、アクセス制限を行ってください
- Dovecot のパスワードハッシュ方式（例: cram-md5）は環境に応じて変更可能です
