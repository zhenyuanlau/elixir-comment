# Elixir 构建

对 [Elixir Makefile](https://github.com/elixir-lang/elixir/blob/main/Makefile) 做了裁剪, 只构建 Elixir 和 Elixir 标准库.

## 概览

简单罗列了构建任务的依赖关系.

```mak
.PHONY: compile erlang elixir unicode app clean clean_residual_files

default: compile

compile: erlang app elixir

erlang: parser

elixir: stdlib

stdlib: kernel version

```

## 剖析

### 变量

```mak

ELIXIRC := bin/elixirc --ignore-module-conflict $(ELIXIRC_OPTS)
ERLC := erlc
ERL_MAKE := if [ -n "$(ERLC_OPTS)" ]; then ERL_COMPILER_OPTIONS=$(ERLC_OPTS) erl -make; else erl -make; fi
ERL := erl -noshell -pa ebin
GENERATE_APP := $(CURDIR)/generate_app.escript
VERSION := $(strip $(shell cat VERSION))
Q := @

APP := ebin/elixir.app
PARSER := src/elixir_parser.erl
KERNEL := ebin/Elixir.Kernel.beam
UNICODE := ebin/Elixir.String.Unicode.beam

```

变量 `VERSION` 为 VERSION 文件的内容

变量 `GENERATE_APP` 为 OTP 应用资源文件构建脚本路径.

目录 `src` 存放 Elixir 的实现

目录 `lib` 存放 Elixir 标准库的实现

目录 `ebin` 存放 Erlang 字节码

### 构建 APP

构建 `ebin/elixir.app` 文件.

### 构建 Erlang/Parser

构建 Elixir 的 Erlang 实现.

### 构建 Elixir

构建 `Elixir.Kernel`

```bash
$(ERL) -s elixir_compiler bootstrap -s erlang halt
```

构建 Elixir 标准库

```bash
$(ELIXIRC) "lib/**/*.ex" -o ebin
```

这里有点自举的意思, 但是使用 `elixir` 编译代码, 需要依赖 `Elixir.Kernel`.

## 重点

1. Elixir 是一个 OTP 应用
2. Elixir 编译的入口点是 `elixir_compiler:bootstrap`

## 参考

[跟我一起写Makefile](https://seisman.github.io/how-to-write-makefile/index.html)
