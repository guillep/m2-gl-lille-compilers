# From ASTs to Stack Bytecode

## Introduction

In the previous parsing exercises, you constructed an AST for each given Pharo program.

In this exercise, you will translate those ASTs into stack bytecode. Use the abstract stack-machine instruction set introduced in the **bytecode exercise**. Refer to that exercise for the available instructions and their semantics.

For **each program from the previous parsing exercises**:

1. **Code:** Refer to the corresponding parsing exercise.
2. **AST:** Redraw the AST from the parsing exercise.
3. **Stack bytecode:** Write the sequence of stack instructions corresponding to the AST.

> **Important:** You must redraw the AST for each exercise. Do not simply refer to your previous drawing. Having the AST next to the bytecode makes the translation easier to follow and makes your work easier to correct.

The bytecode should be derived directly from the structure of the AST. Pay particular attention to the order in which subexpressions are evaluated and to the effect of each instruction on the stack.

## Exercises

For each program from the parsing exercises, provide:

**Code**
See the corresponding parsing exercise.

**AST**
Redraw the AST.

**Stack bytecode**
Translate the AST into stack instructions.
