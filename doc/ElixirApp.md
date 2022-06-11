# Elixir 应用

Elixir 是一个 Erlang/OTP 应用.

## Elixir Application

`elixir.app.src` 文件内容如下:

```erlang
{application, elixir,
[{description, "elixir"},
 {vsn, '$will-be-replaced'},
 {modules, '$will-be-replaced'},
 {registered, [elixir_sup, elixir_config, elixir_code_server]},
 {applications, [kernel,stdlib,compiler]},
 {mod, {elixir,[]}},
 {env, [{check_endianness, true}, {ansi_enabled, false}, {time_zone_database, 'Elixir.Calendar.UTCOnlyTimeZoneDatabase'}]}
]}.
```

可知, `elixir` 是一个 Erlang/OTP 应用, 入口是 `elixir:start`, 重要模块 `elixir_sup`/`elixir_config`/`elixir_code_server`.

`elixir:start`, 加载 `Elixir.String.Tokenizer`, 启动 `elixir_sup`.

## Elixir Supervisor

`elixir_sup:start_link` 启动两个 worker 进程, `elixir_config` 和 `elixir_code_server`.

`elixir_config` 和 `elixir_code_server` 都是 `gen_server`.

## Elixir Worker

### Elixir Config

依赖 `ETS`, 负责管理 Elixir 配置.

### Elixir Code Server

依赖 `ETS`, 负责处理 Elixir 代码相关请求.

## Elixir CLI

`elixir` 非 `iex` 模式下, 会调用  `elixir:start_cli`.

`elixir:elixir_cli` 会调用 `'Elixir.Kernel.CLI':main`(`lib/kernel/cli.ex`).

```elixir
main |> run |> exec_fun |> fun.()
```
