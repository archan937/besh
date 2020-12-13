status = 201

case status do
  204 ->
    IO.puts("No content")
  ~b/2*/ ->
    IO.puts("Success")
  ~b/3*/ ->
    IO.puts("Redirect")
  401 ->
    IO.puts("Unauthorized")
  ~b/4*/ ->
    IO.puts("Error")
  ~b/5*/ ->
    IO.puts("Internal error")
  ~b/*/ ->
    IO.puts("Unknown")
end

status = 204

case status do
  204 ->
    IO.puts("No content")
  ~b/2*/ ->
    IO.puts("Success")
  ~b/3*/ ->
    IO.puts("Redirect")
  401 ->
    IO.puts("Unauthorized")
  ~b/4*/ ->
    IO.puts("Error")
  ~b/5*/ ->
    IO.puts("Internal error")
  ~b/*/ ->
    IO.puts("Unknown")
end

status = 401

case status do
  ~b/2*/ ->
    IO.puts("Success")
  204 ->
    IO.puts("No content")
  ~b/3*/ ->
    IO.puts("Redirect")
  401 ->
    IO.puts("Unauthorized")
  ~b/4*/ ->
    IO.puts("Error")
  ~b/5*/ ->
    IO.puts("Internal error")
  ~b/*/ ->
    IO.puts("Unknown")
end

status = 500

case status do
  204 ->
    IO.puts("No content")
  ~b/2*/ ->
    IO.puts("Success")
  ~b/3*/ ->
    IO.puts("Redirect")
  401 ->
    IO.puts("Unauthorized")
  ~b/4*/ ->
    IO.puts("Error")
  ~b/5*/ ->
    IO.puts("Internal error")
  ~b/*/ ->
    IO.puts("Unknown")
end

status = 999

case status do
  204 ->
    IO.puts("No content")
  ~b/2*/ ->
    IO.puts("Success")
  ~b/3*/ ->
    IO.puts("Redirect")
  401 ->
    IO.puts("Unauthorized")
  ~b/4*/ ->
    IO.puts("Error")
  ~b/5*/ ->
    IO.puts("Internal error")
  ~b/*/ ->
    IO.puts("Unknown")
end
