# Bash

Elixir 命令行工具 `elixir`/`elixirc` 是用 Bash 编写的.

理解 `elixir`/`elixirc` 需要了解 Bash 编程. 在这里, 梳理刚好够用的 Bash 知识.

本文, 代码片段引自 `elixir`/`elixirc` 源码.

## 脚本

脚本是包含一组命令的文件, 脚本执行流程 `读取命令-执行命令-退出`.

`$0` := 脚本名称

`$n` := 脚本参数

```bash
#!/usr/bin/env bash
```

## 命令

### 内置命令

#### `set`

1. 修改选项值
2. 设置位置参数
3. 打印变量

```bash
# 打印变量
set
```

```bash
# TL;DR
# 立即退出如果命令返回非0状态
set -e
```

```bash
set -- "$ERTS_BIN$ERL_EXEC" -pa "$SCRIPT_PATH"/../ebin $ELIXIR_ERL_OPTIONS $ERL "$@"
```

### `break`

> Exit from a for, while, until, or select loop.

### `shift`

### `test`

> Evaluate a conditional expression expr and return a status of 0 (true) or 1 (false).

```bash
test -t 1 -a -t 2

[ $# -eq 0 ]
```

### `exit`

> Exit the shell, returning a status of n to the shell’s parent.

```bash
exit 1
```

### `eval`

### `exec`

### 复合命令

#### 分组命令

```bash
# The exit status of both of these constructs is the exit status of list.

{ [ $# -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ]; }; }
```

#### 条件结构

```bash

if [ -n "$DRY_RUN" ]; then
  echo "$@"
else
  exec "$@"
fi
```

```bash
case $1 in
  "$2"*) true;;
  *) false;;
esac
```

#### 循环结构

```bash
for PART in "$@"; do
  ESCAPED = $PART
done
```

```bash
I=$((E - 1))
while [ $I -ge 0 ]; do
  eval "VAL=\$E$I"
  set -- "$VAL" "$@"
  I=$((I - 1))
done
```

## 参数

```bash
# 定义
ELIXIR_VERSION=1.14.0-dev
ERL_EXEC="erl"
MODE="elixir"

# 使用
echo "$ELIXIR_VERSION"
```

## 函数

命名/成组命令.

```bash
erl_set () {
  eval "E${E}=\$1"
  E=$((E + 1))
}
```

## 扩展

### 参数/变量扩展

|形式  | 语义                |
|:---:|---------------------|
|$@ | 扩展为位置参数, 从 1 开始|
|$# | 扩展为位置参数的个数     |
|$0 | 扩展为脚本名称          |
|$n | 扩展为第 n 个位置参数    |

## 特性

### 条件表达式

命令: `test` | `[` | `[[`

|表达式             |语义                                            |
|------------------|-----------------------------------------------|
|-n string         |True if the length of string is non-zero|
|-z string         |True if the length of string is zero|
|string1 = string2 |True if the strings are equal|
|string1 != string2|True if the strings are not equal|
|-h file|True if file exists and is a symbolic link|
|arg1 OP arg2      |OP is one of ‘-eq’, ‘-ne’, ‘-lt’, ‘-le’, ‘-gt’, or ‘-ge’|

## 难点

### `*` 和 `@` 扩展语义

### 重定向

## 参考

[Bash Reference Manual](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html)
