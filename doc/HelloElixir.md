# Hello Elixir

## Code

```elixir
IO.puts "Hello, Elixir!"
```

## Command

```bash
erl -pa ebin -elixir ansi_enabled true -noshell -s elixir start_cli -extra example/hello.ex
```

## Sequence Diagram

### `elixir:start_cli`

```mermaid
sequenceDiagram
    participant elixir
    participant application
    participant code
    participant Elixir.Kernel.CLI

    elixir->>application: ensure_all_started(?MODULE)
    application-->>elixir: {ok, _}
    elixir->>code: ensure_loaded('Elixir.Logger')
    code-->>elixir: {error, _}
    elixir->>Elixir.Kernel.CLI: main(init:get_plain_arguments())
```

### `Elixir.Kernel.CLI:main`

```mermaid
sequenceDiagram
    participant Elixir.Kernel.CLI
    participant Elixir.Kernel
    participant Elixir.Code
    participant elixir_code_server
    participant Module.ParallelChecker
    participant elixir_compiler
    participant elixir


    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: parse_argv(argv)
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: parse_argv(argv, @blank_config)
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: run(fun)
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: exec_fun(fun, {:ok, 0})
    Elixir.Kernel.CLI->>Elixir.Kernel: spawn_monitor(fn -> fun.(elem(res, 1)) end)
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: process_commands
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: process_command({:file, file}, _config) when is_binary(file)
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: wrapper(fn -> Code.require_file(file) end)
    Elixir.Kernel.CLI->>Elixir.Code: require_file(file)
    Elixir.Code->>elixir_code_server: call({:acquire, file})
    elixir_code_server->>Elixir.Code: proceed
    Elixir.Code->>Elixir.Module.ParallelChecker: verify/1
    Module.ParallelChecker->>elixir_compiler: file/2
    elixir_compiler->>elixir_compiler: string/3
    elixir_compiler->>elixir: string_to_quoted!/5
    elixir_compiler->>elixir_compiler: quoted/3
    elixir_compiler->>elixir_compiler: get(elixir_module_binaries)
    elixir_compiler->>elixir_compiler: eval_or_compile
    elixir_compiler->>elixir_compiler: fast_compile
    Elixir.Kernel.CLI->>Elixir.Kernel.CLI: at_exit

```

可知, `main` 函数主要由 `parse_argv` 和 `process_command` 两个重要过程构成.

`parse_argv` 解析 `argv`, 定义 `config`, 传给 `process_command`.

编译过程有点复杂, 需要单独拿出来.

## Debug

```bash
make clean_elixir compile

bin/elixir example/hello.ex
```

### Info

```elixir
argv = "example/hello.ex"
config = %{
  commands: [file: "example/hello.ex"],
  compile: [],
  compiler_options: [],
  errors: [],
  no_halt: false,
  output: ".",
  pa: [],
  profile: nil,
  pz: [],
  verbose_compile: false
}

```

## API

```erlang
application:ensure_all_started/1
code:ensure_loaded/1
init:get_plain_arguments/0
maps:to_list/1
```
