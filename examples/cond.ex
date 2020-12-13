cond do
  {{ 1 == 1 }} ->
    IO.puts("a")
  true ->
    IO.puts("b")
end

cond do
  false ->
    IO.puts("a")
  true ->
    IO.puts("b")
end

cond do
  false ->
    IO.puts("a")
  {{ 1 == 1 }} ->
     IO.puts("b")
  true ->
    IO.puts("c")
end

cond do
  false ->
    IO.puts("a")
  {{ 1 == 2 }} ->
     IO.puts("b")
  "a" == "a" ->
    IO.puts("c")
end
