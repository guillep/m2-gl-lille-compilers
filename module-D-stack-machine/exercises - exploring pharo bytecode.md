# Exploring Pharo 13 Bytecode

In this exercise, we will explore how Pharo 13 translates Pharo source code into bytecode.

We will use the `OpalCompiler` directly from a Playground and inspect the resulting compiled code.

## Compiling and inspecting code

The `OpalCompiler` can compile either a method or, when scripting mode is enabled, an expression.

### Compiling an expression

By default, scripting mode is **disabled**:

```smalltalk
OpalCompiler new isScripting
```

returns `false`.

To compile an expression, enable scripting mode with `isScripting: true`.

For example, to inspect the code generated for the expression `1 + 1`, execute:

```smalltalk
(OpalCompiler new
    isScripting: true;
    compile: '1 + 1') inspect
```

### Compiling a method

When scripting mode is disabled, the compiler expects a method definition. Since `isScripting` is `false` by default, a method can simply be compiled with:

```smalltalk
(OpalCompiler new
    compile: 'answer
        ^42') inspect
```

You can also explicitly set scripting mode to false:

```smalltalk
(OpalCompiler new
    isScripting: false;
    compile: 'answer
        ^42') inspect
```

For the exercises below:

* use `isScripting: true` when compiling an expression;
* use `compile:` directly when compiling a method.

The result can be inspected using `inspect`.

The inspector provides several useful views, including:

* the source code;
* the bytecode;
* the mapping between bytecode and source code;
* the method's literals;
* arguments and temporaries.

Your task is to explore these views and infer how different Smalltalk constructs are represented.

Pay particular attention to:

* how constants and literals are represented;
* how arguments and temporaries are accessed;
* how assignments are represented;
* how message sends appear in the bytecode;
* how blocks are created;
* how blocks access variables from their enclosing context;
* what happens when operators such as `+` and `*` are used.

The goal is not to memorize bytecode instructions. Instead, use the compiler and inspector to discover the relationship between **Smalltalk source code** and **Pharo bytecode**.

---

# Exercises

## 1. A minimal method

Compile and inspect:

```smalltalk
answer
    ^42
```

Then compile and inspect:

```smalltalk
answer
    ^self
```

Compare the two methods.

Answer:

* What bytecode is generated in each case? `returnSelf` | `returnTop`
* Where does `42` appear? `pushConstant 42`
* How is `self` represented? `returnSelf`
* What is the difference between accessing `self` and accessing a literal? `self` is loaded by a primitive and returned directly with a special bytecode

---

## 2. Literals

Compile and inspect each of these:

```smalltalk
answer
    ^42
```
constant

```smalltalk
answer
    ^3.14
```
constant

```smalltalk
answer
    ^'hello'
```

constant


```smalltalk
answer
    ^#hello
```

constant

Pay particular attention to the **literal table**.

Answer:

* Which values appear as literals? all of them
* How does the bytecode access them? using `pushConstant <index>`
* Are numbers, strings, and symbols represented in the same way? si

---

## 3. Temporaries

Compile and inspect:

```smalltalk
answer
    | x |
    x := 42.
    ^x
```

Then:

```smalltalk
answer
    | x y |
    x := 42.
    y := 23.
    ^x + y
```

Identify:

* the temporary variables;
* the bytecodes that write them;
* the bytecodes that read them.

Answer:

* Do the names `x` and `y` appear in the bytecode?
* How does the bytecode identify each temporary?
* What is the difference between reading and writing a temporary?

---

## 4. Arguments and temporaries

Compile and inspect:

```smalltalk
copy: x
    | y |
    y := x.
    ^y
```

Then:

```smalltalk
copy: x
    | y |
    y := 42.
    ^x
```

Compare how `x` and `y` are represented.

Answer:

* How are arguments represented?
* How are temporaries represented?
* Do they use different bytecode instructions?
* Can you determine their positions from the bytecode?

---

## 5. Assignments

Compile and inspect:

```smalltalk
answer
    | x |
    x := 10.
    ^x
```

Then:

```smalltalk
answer
    | x |
    x := 10.
    x := 20.
    ^x
```

Study the mapping between the source code and the bytecode.

Answer:

* Which instructions correspond to each assignment?
* What happens to `10` after the assignment?
* What happens to `20`?
* How is the final value of `x` obtained?

Try to describe, in terms of a stack machine, what happens when executing:

```smalltalk
x := 10
```

---

## 6. Operators are messages

Compile and inspect:

```smalltalk
answer
    ^3 + 4
```

Then:

```smalltalk
answer
    ^3 - 4
```

```smalltalk
answer
    ^3 * 4
```

```smalltalk
answer
    ^3 < 4
```

Finally:

```smalltalk
answer
    ^3 + 4 * 5
```

Using the bytecode and source mapping, determine:

* Which bytecode instruction represents `+`?
* Which represents `*`?
* Where are the selectors?
* Is there a bytecode instruction specifically for addition?
* What happens to `3` and `4` before the `#+` message is sent?

Then inspect the existing method:

```smalltalk
SmallInteger >> #+
```

Compare it with the bytecode generated for:

```smalltalk
3 + 4
```

The goal is to discover the relationship between:

```smalltalk
a + b
```

and sending the message:

```smalltalk
#+
```

---

## 7. Blocks

Compile and inspect:

```smalltalk
answer
    ^[ 42 ]
```

Then:

```smalltalk
answer
    ^[ 1 + 2 ]
```

Explore the bytecode carefully.

Answer:

* Does the outer method contain the instructions that execute `42`?
* Where is the bytecode for the block?
* How is the block created?
* What is the relationship between the outer method and the block's code?

Try to distinguish between:

```text
creating the block
```

and:

```text
executing the block
```

---

## 8. A block captures a temporary

Compile and inspect:

```smalltalk
answer
    | x |
    x := 42.
    ^ [ x ]
```

Then:

```smalltalk
answer
    | x |
    x := 42.
    ^[ x + 1 ]
```

Pay attention to both the outer method and the block's bytecode.

Answer:

* Where is `x` stored?
* How does the block access `x`?
* Is this the same kind of access used for `x` outside the block?
* What additional information does the block seem to need?
* Does the block contain a copy of `x`, or does it access the variable from the enclosing context?

Use the term **capture** to describe what is happening.

---

## 9. A block modifies a captured variable

Compile and inspect:

```smalltalk
answer
    | x |
    x := 0.
    ^[ x := x + 1 ]
```

Compare the access to `x` in:

```smalltalk
x := 0
```

with the accesses to `x` inside:

```smalltalk
[ x := x + 1 ]
```

Answer:

* What differences do you observe in the bytecode?
* How can the block modify a variable belonging to the enclosing method?
* What mechanism allows the value of `x` to be shared?
* Why would simply copying the value `0` into the block not be sufficient?

The goal is to discover, from the bytecode, the mechanism used for **captured variables and shared contexts**.

---

## 10. Multiple captured variables

Compile and inspect:

```smalltalk
answer
    | x y |
    x := 10.
    y := 20.
    ^[ x + y ]
```

Then:

```smalltalk
answer
    | x y |
    x := 10.
    y := 20.
    ^[ x := x + y ]
```

Analyze carefully:

* how `x` is accessed;
* how `y` is accessed;
* where `+` is sent;
* which bytecodes create the block;
* which bytecodes belong to the block itself;
* which variables are captured;
* which variables can be modified from inside the block.

Finally, explain in your own words what it means for a block to **capture variables from its enclosing context**.

---

# Extra challenge — Find an example in Pharo

So far, all examples have been deliberately small.

Now find an **existing method in Pharo 13** that contains:

1. at least two temporaries;
2. a block;
3. a variable from the method used inside the block;
4. an arithmetic operation;
5. at least one message sent to `self`.

Use Pharo's method search tools to find a suitable example. (shift + enter)

Inspect the method and document:

* the source code;
* its temporaries;
* its literals;
* its message sends;
* the creation of the block;
* accesses to captured variables;
* the return.
