# Bash

输入
-> 词法解析(引号/转义/别名扩展)
-> 语法解析(简单命令/复合命令)
-> 模式扩展
-> 重定向
-> 执行命令
-> 退出状态

## 命令

### 内置命令

```bash
set -- "$ERTS_BIN$ERL_EXEC" -pa "$SCRIPT_PATH"/../ebin $ELIXIR_ERL_OPTIONS $ERL "$@"
```

### 复合命令

```bash
for PART in "$@"; do
  ESCAPED = $PART
done

if [ -n "$DRY_RUN" ]; then
  echo "$@"
else
  exec "$@"
fi
```

## 脚本

```bash
#!/bin/sh

set -e

```

## 引号

## 变量

### 环境变量

### 定义变量

## 函数

命名/成组命令

```bash
erl_set () {
  eval "E${E}=\$1"
  E=$((E + 1))
}
```

## 参数

### 特殊参数

|形式| 扩展义|
|---|---|
|$* | |
|$@ | |
|$# | |
|$? | |
|$- | |
|$$ | |
|$! | |
|$0 | |

## 扩展

### 括号扩展

### 波浪线扩展

### 参数/变量扩展

### 算术扩展

### 文件名扩展
