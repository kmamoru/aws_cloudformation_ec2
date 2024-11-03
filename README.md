# キーペアの作成

```
$ aws ec2 create-key-pair \
--key-name project1_key \
--key-type rsa \
--query 'KeyMaterial' \
--output text \
> project1_key.pem

```

EC2 キーペアを確認

# スタックの作成

```
$ make create-stack EnvName=dev
```

(cloudformation 確認する)

# 説明(chatGPT)

```
この Makefile は AWS CloudFormation のスタック管理のためのルールが含まれます。以下が各ルールの説明です。

- cf_file は、スタックの YAML ファイルの名前を保持する変数です。
- stack_name は、作成される CloudFormation スタックの名前を保持する変数です。`project1-ec2-を名前に含み、$EnvName`の値を追加します。
- stack_input_file は、`create-stack`ルールの入力パラメータを含む JSON ファイルへのパスを保持する変数です。
- change_set_input_file は、`create-change-set`ルールの入力パラメータを含む JSON ファイルへのパスを保持する変数です。
- change_set_name は、現在の日付に基づいて名前が割り当てられる変数です。これは CloudFormation Change Set の名前として使用されます。
- validate-template は、テンプレートの構文を検証するために aws cloudformation validate-template コマンドを実行するルールです。
- gen-stack-skeleton は、入力パラメータでスタックを作成するために使用できるスケルトン JSON ファイルを作成するために aws cloudformation create-stack コマンドを実行するルールです。
- gen-stack-json は、`envsubst` を使用して、`${stack_input_file}`で指定されたファイル内の環境変数を置換して`${EnvName}/cli-input-create-stack.json`に保存するルールです。
- gen-change-set-json は、`envsubst` を使用して、`${change_set_input_file }`で指定されたファイル内の環境変数を置換して`${EnvName}/cli-input-create-change-set.json`に保存するルールです。
- create-stack は、`stack_name`で指定された CloudFormation スタックを、`cf_file`で指定された CloudFormation テンプレートを使用して作成するルールです。
- stack-create-complete は、指定された`${stack_name}`のスタックが正常に作成されるまで待機するルールです。
- create-change-set は、CloudFormation Change Set を作成するルールです。変数`change_set_name`を Change Set の名前として使用し、`${stack_name}`で指定されたスタック、`cf_file`で指定された CloudFormation テンプレートを使用します。
- describe-change-set は、CloudFormation Change Set の内容を説明するルールです。
- execute-change-set は、指定された CloudFormation スタックに変更を適用するルールです。
- create-env は、`${EnvName}/cli-input-create-stack.json`で指定された入力パラメータで CloudFormation スタックを作成するルールです。
```

# できるもの

- AWS CloudFormation を使用して、EC2 インスタンスを作成
  - EC2 インスタンス
    - 3 台
      - master-node
      - worker-node1
      - worker-node2
    - インスタンスタイプは、t2.micro
    - AMI は、ami-0ed99df77a82560e6
    - セキュリティグループは、SSH（22 番ポート）のみ許可
    - それぞれ Python3.10, Nodejs 18, Java11, Docker をインストール
  - キーペア
    - project1_key

# 使い方

```bash
ssh -i "project1_key.pem" ubuntu@<public_ip>
```

# 後片付け

1. stack 削除

```bash
$ make delete-stack EnvName=dev
```

2.  キーペア削除
    EC2 > キーペア > project1_key > 削除

---

## 以下環境確認メモ

```
python3 --version

node -v
npm -v

docker --version
```

### python が 3.8 だったので変更

```bash
$ python3 --version
Python 3.8.10

$ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
$ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
$ sudo update-alternatives --config python3

There are 2 choices for the alternative python3 (providing /usr/bin/python3).

  Selection    Path                 Priority   Status
------------------------------------------------------------
* 0            /usr/bin/python3.10   2         auto mode
  1            /usr/bin/python3.10   2         manual mode
  2            /usr/bin/python3.8    1         manual mode

Press <enter> to keep the current choice[*], or type selection number: 0

$ python3 --version
>>> Python 3.10.15
```
