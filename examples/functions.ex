def say_hello(name) do
  greet = "Hello, #{name}!"
  return "#{greet}!"
end

hello = say_hello("Paul")
IO.puts "Output: #{hello}!"
