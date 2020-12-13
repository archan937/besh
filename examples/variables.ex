a = 1
b = "string"
c = "Con" <> "cat"

IO.inspect(a)
IO.inspect(b)
IO.inspect(c)

a = 1 + 2
b = a * 7
c = [1, 2, "str", true, false]

IO.inspect(a, label: "A")
IO.inspect(b, label: "B")
IO.inspect(@(c), label: "C")

d = "#{a}:#{b}"
e = "#{a}#{inspect(@(c))}"
f = 1.1

IO.inspect(d)
IO.inspect(e)
IO.inspect(f)
