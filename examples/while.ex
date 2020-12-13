bool = true
i = 0

while bool do
  IO.puts(i)
  i.+
  if i == 5 do
    break
  end
end
