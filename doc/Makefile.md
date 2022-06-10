# Makefile

## 核心规则

目标-依赖-命令

## 工作原理

make

1. 查找 Makefile 文件

2. 查找目标(默认为第一个)

3. 满足目标依赖

4. 执行命令

## 命令

### 嵌套执行

```mak
sub:
  cd subdir && $(MAKE)

sub:
  $(MAKE) -C subdir

```

### 命令序列

```mak

define cc
  rm *.out
  cc main.c
endef

$(cc)

```

## 变量

### 基础

```mak

Foo ?= bar

ifeq ($(origin FOO), undefined)
  FOO = bar
endif

```
