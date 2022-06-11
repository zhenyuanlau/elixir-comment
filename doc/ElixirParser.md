# Elixir 语法解析

Elixir 使用 `yecc` 生成语法解析器, 通过 `elixir_tokenizer` 实现词法解析.

## 构建规则

编译 `elixir_parser.yrl` 为 `elixir_parser.erl`.

`elixir_parser.yrl` 定义了 Elixir 的语法.

```mak
Q := @
PARSER := src/elixir_parser.erl

$(PARSER): src/elixir_parser.yrl
	$(Q) erlc -o $@ +'{verbose,true}' +'{report,true}' $<
```

即, `@ erlc -o src/elixir_parser.erl +'{verbose,true}' +'{report,true}' src/elixir_parser.yrl`

`erl` 命令参数理解:

```erl
{verbose, boolean()}.

% Determines whether the parser generator should give full information about resolved and unresolved parse action conflicts (true),
% or only about those conflicts that prevent a parser from being generated from the input grammar (false, the default).

{report, boolean()}.
% This is a short form for both report_errors and report_warnings.
```

## YRL 记法

参考 [yecc](https://www.erlang.org/doc/man/yecc.html), 阅读 `elixir_parser.yrl`.

`elixir_parser.yrl` 有 1215 行(`Erlang code.` 在 649 行), 生成的 `elixir_parser.erl` 有 34212 行.

```yrl
% declaration

% Optional: Header Endsymbol Expect

% nonterminal categories
Nonterminals
  grammar
  .

% terminal categories
Terminals
  identifier
  .

% rootsymbol
Rootsymbol grammar.

% operator precedences
% associative & precedence

Left       5 do.

% grammar rules
% Left_hand_side -> Right_hand_side : Associated_code.
% Left_hand_side -> Right_hand_side.

grammar -> '$empty' : {'__block__', [], []}.

%% Expressions
%% Blocks
%% Helpers
% Operators
% Dot operator
% Function calls with no parentheses
% Containers
% Function calls with parentheses
% KV
% Lists
% Tuple
% Bitstrings
% Map and structs

Erlang code.

```

## LALR 解析算法

LALR(Look-Ahead Left Reversed Rightmost Derivation), 即 `向前查看反向最右推导`.

Left := 解析器从左向右移动, 处理 `Token` 流

Reversed Rightmost Derivation := 解析器自底向上, 通过移动/归约匹配语法规则

Look-Ahead := 解析器查看下一个 `Token`, 或移动或归约

## 重点

重点理解 Elixir 语法解析器构建过程和 Elixir 语法规则文件, 而非 Elixir 语法解析器的算法实现.

```erl
-module(elixir_parser).
-export([parse/1, parse_and_scan/1, format_error/1]).
-file("src/elixir_parser.yrl", 649).
```

```erl
-module(elixir_tokenizer).
-include("elixir.hrl").
-include("elixir_tokenizer.hrl").
-export([tokenize/1, tokenize/3, tokenize/4, invalid_do_error/1]).
```

最后, 关注 `elixir_parser` 和 `elixir_tokenizer` 导出的函数, 在解释/编译 Elixir 代码过程中有用到.
