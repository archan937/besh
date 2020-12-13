# Besh [![Build Status](https://travis-ci.org/archan937/besh.svg?branch=master)](http://travis-ci.org/archan937/besh)

Transpile Elixir scripts to Bash scripts

## Features

As you might have guessed Besh only transpiles a small fraction of what the beautiful Elixir language and its standard library provides.

Currently Besh supports the following concepts:

* **string variable assignment** => `s = "Hi, my name is Paul"`
* **integer variable assignment** => `i = 1982`
* **float variable assignment** => `f = 1.8`
* **array variable assignment** => `a = [1, 2, 3, 4]`
* **string concatenation** => `s = "hello " <> "world"` or `s = a <> ":" <> b`
* **string interpolation** => `s = "#{f} #{i}"`
* **string comparisons** => `"a" != "b"`
* **integer comparisons** => `1 > 0`
* **compound operators** => `("a" == "b") or {{ 1 < 2 }}`
* **if statements** => `if "b" > "a" do`
* **while statements** => `while bool do`
* **for loops** => `for i = 10, i > 0, i.- do` or `for color <- colors do`
* **value inspection** => `inspect(i)`
* **printing strings** => `IO.puts(s)` or `IO.write("hello")`
* **printing inspected variables** => `IO.inspect(s, label: "string")`
* **printing arrays** => `IO.inspect(@(a))`

See [the examples](https://github.com/archan937/besh/tree/master/examples) for all what you can write and their corresponding [expected scripts](https://github.com/archan937/besh/tree/master/test/expected).

## Usage

Use the `besh` executable:

```shell
$ bin/besh -h
Usage: besh [options] FILE
    -d, --debug                 Print mismatched Elixir AST
    -e, --execute               Execute generate script
    -h, --help                  Show this help message
    -o, --output                Write the script to this file
```

### Examples

If you do not provide the `-e` or `-o` flag then the resulting script will be printed:

```shell
$ bin/besh examples/hello_world.ex
#!/bin/bash

name="Hello world"
echo $name
```

The `-e` flag immediately executes the script:

```shell
$ bin/besh -e examples/variables.ex
'1'
'string'
'Concat'
A: '3'
B: '21'
C: 1 2 str true false
'3:21'
'31 2 str true false'
'1.1'
```

The `-o` flag writes the script to the specified location:

```shell
$ bin/besh -o write.sh examples/write.ex; cat write.sh
#!/bin/bash

echo -n "Hello world"
```

The `-d` flag prints the Elixir AST which gets prewalked during the transpilation process:

```shell
$ bin/besh -d examples/hello_world.ex
Line 142: {:__block__, [],
 [
   {:=, [line: 1], [{:name, [line: 1], nil}, "Hello world"]},
   {{:., [line: 2], [{:__aliases__, [line: 2], [:IO]}, :puts]}, [line: 2],
    [{:name, [line: 2], nil}]}
 ]}
Line 75: {:=, [line: 1], [{:name, [line: 1], nil}, "Hello world"]}
Line 241: "Hello world"
Line 61: {{:., [line: 2], [{:__aliases__, [line: 2], [:IO]}, :puts]}, [line: 2],
 [{:name, [line: 2], nil}]}
Line 236: {:name, [line: 2], nil}
#!/bin/bash

name="Hello world"
echo $name
```

## Contact me

For support, remarks and requests, please mail me at [pm_engel@icloud.com](mailto:pm_engel@icloud.com).

## License

Copyright (c) 2020 Paul Engel, released under the MIT License

http://github.com/archan937 – http://twitter.com/archan937 – [pm_engel@icloud.com](mailto:pm_engel@icloud.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
