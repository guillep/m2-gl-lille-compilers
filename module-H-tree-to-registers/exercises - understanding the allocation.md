# Exercise 1 — Generate Register Code

These exercises continue the previous exercises on parsing and ASTs. You are given the ASTs of programs written in the language defined by the grammar in `SmiParser class >> definitionComment`.

Unlike the previous translation exercises, the target is now **register-based code** rather than stack-based code.

For this exercise, assume an **infinite supply of registers**:

```text
T1, T2, T3, ...
```

This allows you to concentrate on the traversal and code-generation process without worrying about register exhaustion.

## Register Code Generation

The code generator follows a simple **post-order traversal** of the AST.

For each node:

1. Generate code for its operands.
2. Assign a new register to the result.
3. Generate the instruction implementing the operation.
4. The result remains in its register.

For example, given:

```text
       *
      / \
     +   3
    / \
   1   2
```

a possible translation is:

```text
MoveCq: 1 T1
MoveCq: 2 T2
Add: T1 T2 T3
MoveCq: 3 T4
Mul: T3 T4 T5
```

The final result is in `T5`.

## Task

For each of the ASTs from the previous parsing exercises, generate the corresponding register-based code by hand.

Use registers `T1`, `T2`, `T3`, ... and follow a post-order traversal.

For every AST node:

* generate its operands first;
* assign a new register to the result;
* generate the corresponding instruction;
* make clear which register contains the result of each expression.

Do not try to minimize the number of registers.

Pay attention to the lifetime of each register: once an instruction has been generated, the registers containing its operands are no longer needed by that instruction.

The goal of this exercise is to understand how an AST can be translated into register-based instructions using a post-order traversal.
