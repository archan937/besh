for counter = 10, counter > 0, counter.- do
  IO.write "#{counter} "
end

for color <- ["Blue", "Green", "Pink", "White", "Red"] do
  IO.puts "Color = #{color}"
end

colors = ["Blue", "Green", "Pink", "White", "Red"]

for color <- colors do
  if color == "Blue" do
    IO.puts "My favorite color is #{color}"
  end
end
