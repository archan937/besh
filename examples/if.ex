if "a" .== "a" do
  IO.puts("Equal (strings)")
end

if "a" .!= "b" do
  IO.puts("Not equal (strings)")
end

if "b" .> "a" do
  IO.puts("Greater than (strings)")
end

if "a" .< "b" do
  IO.puts("Less than (strings)")
end

if 1 == 1 do
  IO.puts("Equal")
end

if 0 != 1 do
  IO.puts("Not equal")
end

if 1 > 0 do
  IO.puts("Greater than")
end

if 1 >= 0 do
  IO.puts("Greater or equal (greater)")
end

if 0 >= 0 do
  IO.puts("Greater or equal (equal)")
end

if 0 < 1 do
  IO.puts("Less than")
end

if 0 <= 1 do
  IO.puts("Less or equal (less)")
end

if 1 <= 1 do
  IO.puts("Less or equal (equal)")
end

if is_empty("") do
  IO.puts("Zero-length")
end

if is_not_empty("abc") do
  IO.puts("Not zero-length")
end

if ("a" .== "a") and ("b" .== "b") do
  IO.puts("And")
end

if ("a" .== "b") or ("c" .== "c") do
  IO.puts("Or")
end
