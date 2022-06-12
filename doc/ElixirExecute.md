# Elixir 执行流程

## Code

```elixir
IO.puts "Hello, Elixir!"
```

## Command

```bash
erl -pa ebin -elixir ansi_enabled true -noshell -s elixir start_cli -extra example/hello.ex
```

## Sequence Diagram

### `elixir:start_cli/0`

```mermaid
sequenceDiagram
    participant elixir
    participant application
    participant code
    participant init
    participant Kernel.CLI

    elixir->>application:ensure_all_started(?MODULE)
    application-->>elixir: {ok, _}
    elixir->>code: ensure_loaded('Elixir.Logger')
    code-->>elixir: {error, _}
    elixir->>init:get_plain_arguments()
    init-->>elixir:plain_arguments
    elixir->>Kernel.CLI:main(plain_arguments)
```

### `Kernel.CLI:main/1`

```mermaid
sequenceDiagram
    participant Kernel.CLI
    participant Kernel
    participant Code

    Kernel.CLI->>Kernel.CLI:parse_argv(argv)
    Kernel.CLI->>Kernel.CLI:parse_argv(argv, @blank_config)
    Kernel.CLI-->>Kernel.CLI: {config, argv}
    Kernel.CLI->>Kernel.CLI:run(fun)
    Kernel.CLI->>Kernel.CLI:exec_fun(fun, {:ok, 0})
    Kernel.CLI->>Kernel:spawn_monitor(fn -> fun.(elem({:ok, 0}, 1)) end)
    Kernel.CLI->>Kernel.CLI:process_commands(config)
    Kernel.CLI->>Kernel.CLI:process_command({:file, file}, config)
    Kernel.CLI->>Kernel.CLI:wrapper(fn -> Code.require_file(file) end)
    Kernel.CLI->>Code:require_file(file)
    Kernel.CLI->>Kernel.CLI:at_exit/1

```

`Kernel.CLI:main/1`

- `Kernel.CLI:parse_argv/1`
- `Kernel.CLI:process_command/2`

可知, `parse_argv` 解析 `argv`, 定义 `config`, 传给 `process_command`, 继而调用 `Code:require_file/1`.

通过 Debug, 得:

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

### `Code:require_file/1`

```mermaid
sequenceDiagram
    participant Kernel.CLI
    participant Code
    participant elixir_code_server
    participant Module.ParallelChecker
    participant elixir_compiler

    Kernel.CLI->>Code:require_file(file)
    Code->>elixir_code_server:call({:acquire, file})
    elixir_code_server->>Code:{reply, proceed, _}
    Code->>Module.ParallelChecker:verify/1
    Module.ParallelChecker->>elixir_compiler:file/2
    elixir_compiler-->>Module.ParallelChecker: {result, compile_info}
    Module.ParallelChecker->>Module.ParallelChecker:verify/3
    Module.ParallelChecker-->>Code: result
    Code->>elixir_code_server:cast({:required, file})
    Code->>Kernel.CLI: result
```

### `elixir_compiler:file/2`

```mermaid
sequenceDiagram
    participant Module.ParallelChecker
    participant elixir_compiler
    participant elixir
    participant file

    Module.ParallelChecker->>elixir_compiler:file/2
    elixir_compiler->>file:read_file/2
    file-->>elixir_compiler: {ok, Bin}
    elixir_compiler->>elixir_utils:characters_to_list(Bin)
    elixir_utils-->>elixir_compiler: Content
    elixir_compiler->>elixir_compiler:string(Content, File, Callback)
    elixir_compiler->>elixir:string_to_quoted!/5
    elixir-->>elixir_compiler: Forms
    elixir_compiler->>elixir_compiler:quoted(Forms, File, Callback)
    elixir_compiler->>elixir_compiler:unzip_reverse/3
    elixir_compiler-->>Module.ParallelChecker: {Mods, Infos}
```

### `elixir_lexical:run/3`

```mermaid
sequenceDiagram
    participant elixir_compiler
    participant elixir_lexical
    participant elixir_module
    participant Module
    participant elixir_code_server

    elixir_compiler->>elixir_lexical: run/3
    elixir_compiler->>elixir_compiler:fast_compile
    elixir_compiler->>elixir_module: eval_form/6
    elixir_module->>elixir_compiler:compile
    elixir_compiler->>elixir_compiler:dispatch(Module, Fun, Args, Purgeable)
    elixir_compiler->> Module:Fun(Args)
    elixir_compiler->>elixir_code_server:cast/1
```

细节待补充.

## ETS

## 进程字典

## API
