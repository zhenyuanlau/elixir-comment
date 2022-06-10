# Elixir 命令行

## 概览

Elixir 命令行包装了底层的 `erl` 命令, 故需要熟悉 `erl` 命令的用法.

### `elixir`

包装 `erl` 命令.

执行 `ELIXIR_CLI_DRY_RUN=true elixir ...` , 打印实际执行的命令.

### `elixirc`

包装 `elixir` 命令, 添加 `+elixirc`.

## 剖析

### 打印命令

```bash
ELIXIR_CLI_DRY_RUN=true bin/elixir +elixirc example/hello.ex

# => erl -pa ebin -elixir ansi_enabled true -noshell -s elixir start_cli -extra +elixirc example/hello.ex
```

### 参数解析

`elixir` 最后执行 `exec "$@"`, 可知, 之前都是在处理位置参数.

`$@` 扩展为位置参数, `set` 命令可以修改位置参数.

在 `elixir` 中, 不考虑 `RUN_ERL_PIPE`, 最后一处执行 `set` 命令代码如下:

```bash
set -- "$ERTS_BIN$ERL_EXEC" -pa "$SCRIPT_PATH"/../ebin $ELIXIR_ERL_OPTIONS $ERL "$@"
```

故, 需要先理解变量 `ERTS_BIN`/`ERL_EXEC`/`SCRIPT_PATH`/`ELIXIR_ERL_OPTIONS`/`ERL`, 再理解位置参数的处理过程.

```bash
ERTS_BIN=
ERTS_BIN="$ERTS_BIN"

ERL_EXEC="erl"
# ERL_EXEC="werl" if [ "$OS" = "Windows_NT" ]
# ERL_EXEC="run_erl" if [ -n "$RUN_ERL_PIPE" ]

SELF=$(readlink_f "$0")
SCRIPT_PATH=$(dirname "$SELF")

# ELIXIR_ERL_OPTIONS

ERL=""

# ERL="$ERL -hidden"
# ERL="$ERL -logger handle_otp_reports $2"
# ERL="$ERL -logger handle_sasl_reports $2"
# ERL="$ERL $2"
# ERL="-noshell -s elixir start_cli $ERL"
# ERL="-elixir ansi_enabled true $ERL"
```

默认情况下, 我们最终得到 `erl -pa ebin -elixir ansi_enabled true -noshell -s elixir start_cli`.

理解脚本参数的处理过程, 需要先掌握 `set`/`eval`/`shift` 等命令.

接下来, 重点理解脚本参数的处理过程:

```bash
I=1
E=0
LENGTH=$#
set -- "$@" -extra
# -extra 是最后一个位置参数
while [ $I -le $LENGTH ]; do
  # 一个接一个地处理位置参数
  S=0
  C=0
  case "$1" in
    # 分情况处理
    # 设置 S/C 的值
    # E 增 1, 定义变量 Eₙ 的值为 $1
  esac
  while [ $I -le $LENGTH ] && [ $C -gt 0 ]; do
    C=$((C - 1))
    I=$((I + 1))
    # 追加参数
    set -- "$@" "$1"
    # 从左侧, 弹出 1 个参数
    shift
  done

  I=$((I + S))
  # 从左侧, 弹出 `$S` 个参数
  shift $S
done

I=$((E - 1))
while [ $I -ge 0 ]; do
  # 定义变量 VAL 的值为 Eₙ
  eval "VAL=\$E$I"
  # 插入参数 VAL
  set -- "$VAL" "$@"
  I=$((I - 1))
done

```

在这里, 有两个技巧性的处理:

1. `while` + `shift` 按序处理参数

2. `eval` 动态创建变量 Eₙ, 保存参数

## 结论

`elixir`/`elixirc` 的入口点是 `elixir:start_cli`.

## 参考

[erl 文档](https://www.erlang.org/doc/man/erl.html)
