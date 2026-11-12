# Generating Abstract Stack Code from an AST

In this exercise, you will implement a code generator that translates the AST of a program into code for an abstract stack machine.

The parser is already implemented. You do not need to modify it.

You can obtain an AST with:

```smalltalk
SmiParser parse: 'aSmiProgram'
```

The language only allows **functions at the top level**. Therefore, the result of code generation is not a single sequence of instructions.

Instead, your code generator must produce a list of generated functions, with one instruction sequence for each function:

```text
Program
   │
   ├── Function ──→ instruction sequence
   ├── Function ──→ instruction sequence
   └── Function ──→ instruction sequence
```

Your goal is to translate the tree-shaped AST into linear abstract stack code while preserving the structure of the functions. Introduce missing instructions you may need (e.g., to set values to variables), but check that with the teachers!

## 1. Understand the target representation

Before implementing the generator, inspect the AST produced for a program containing several functions.

For example:

```text
function add(a, b) {
    return a + b;
}

function main() {
    return add(1, 2);
}
```

Determine:

* how the program represents its functions;
* how each function represents its name;
* how parameters are represented;
* how the function body is represented;
* where the generated instructions for each function should be stored.

Sketch the expected result:

```text
Program
  │
  ├── add
  │     └── instructions
  │
  └── main
        └── instructions
```

The code generator should preserve this function-level structure.

## 2. Generating code for a function

Start with a function containing a very simple body.

For example:

```text
function answer() {
    return 42;
}
```

Generate the instruction sequence for the function.

Determine:

1. which instruction represents the constant `42`;
2. which instruction represents returning the value;
3. what the stack contains immediately before the return;
4. what the generated instruction sequence should be.

Then test:

```text
function answer() {
    return 1 + 2;
}
```

Trace the stack while executing the generated instructions.

## 3. Generating code for expressions

Implement code generation for the basic expression nodes:

* integer literals;
* variable reads;
* variable assignments;
* binary operators.

For each AST node, determine:

1. which instructions must be emitted;
2. what the stack looks like before the generated code;
3. what the stack looks like afterwards.

For example, for:

```text
a + b
```

the generated code must evaluate `a` and `b` and leave their result on the stack.

Test this with:

```text
1 + 2
```

and then with nested expressions.

Use the AST structure to determine the order in which subexpressions are generated.

## 4. Variables and parameters

Functions can have parameters.

Consider:

```text
function add(a, b) {
    return a + b;
}
```

Determine how the generated code accesses `a` and `b`.
Implement the necessary code generation for variable reads.

## 5. Statements

Implement code generation for:

* expression statements;
* `return`;
* `Print`;
* blocks.

For every statement, determine whether its generated code leaves a value on the stack or consumes the value it produces.

Then test functions containing several statements.

## 6. Binary operators

Implement code generation for all binary operators supported by the language.

Test simple expressions first:

```text
1 + 2
1 - 2
2 * 3
6 / 2
1 < 2
1 <= 2
1 = 2
1 > 2
1 >= 2
```

Then test nested expressions.

For each operator, verify the expected stack transformation.

## 7. Assignments

Implement variable assignment.
Determine how variables should be represented by the abstract machine and how assignments affect the generated code.

Test examples such as:

```text
function f() {
    a := 1;
    return a;
}
```

and:

```text
function f() {
    a := 1;
    a := a + 2;
    return a;
}
```

Trace the stack and variable state through the generated instructions.

## 8. Control flow

Implement code generation for:

```text
if expression then {
    ...
}
```

The generated code must evaluate the condition and execute the body only when the condition has the appropriate value.

Represent the control flow using the abstract machine's conditional and jump instructions.

Draw the resulting instruction sequence for a small example before implementing it.

For example:

```text
function positive(a) {
    if a > 0 then {
        Print "positive";
    }
}
```

Pay attention to where labels or jump targets are needed.