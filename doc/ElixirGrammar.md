# Elixir 语法

<https://hexdocs.pm/elixir/main/syntax-reference.html#content>

> Leex负责识字, Yecc 负责断句.

`String` -> `Leex` --`Token`--> `Yecc` -> `Code`.

## Yecc 语法定义格式

### 格式

Erlang 风格的注释 `%`; 终结声明或规则的 `.`.

### 定义

```erlang
% <Header>

% 非终结符声明
Nonterminals grammar.

% 终结符声明
Terminals identifier.

% 起始符声明
Rootsymbol grammar.

Expect 3.

% Endsymbol

% 操作符的优先级/结合性声明

% Associative Precedence Operator.

% 语法规则

% Left_hand_side -> Right_hand_side : Associated_code.

Erlang code.

% <Erlang code>

```

## Elixir 语法点

```erlang

% Expression
% Call
% Access
% Block
% Operator
% Dot Operator
% Stab Operator
% Containers
% Function calls with parentheses
% KV
% List
% Tuple
% Bitstring
% Map
% Struct
% Keyword

```

## Leex 返回值类型

## 解读

### 非终结符

```erlang

% expr
%

```
