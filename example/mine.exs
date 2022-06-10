defmodule Mine.Mod do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end

defmodule Mine do
  require Mine.Mod, as: Mod

  def main() do
    Mod.unless(false, do: IO.puts("It's true!"))
  end
end

Mine.main()
