# Exercise 2 — Implement a Register-Based Translator

Create a new translator starting from the previous translation exercise.
The new translator will no longer produce abstract stack instructions.
Instead, it will interact directly with the provided `SmiCodeGenerator`.

The code generator can be used as follows:

```smalltalk
program := SmiCodeGenerator aarch64
    assemble: [ :asm |
        asm MoveCq: 1 R: R0.
        asm PushR: R0.
        asm MoveCq: 1 R: R0.
        asm RetN: 0
    ].
```

Your translator should therefore generate instructions by sending messages to the assembler rather than constructing an intermediate list of stack instructions.

Please consider the following:
 - a smi return instruction should put the return value into the R0 register before returning
 - the runner will consider that as the return value of the program


## Example Smi Programs

The following are examples of valid programs according to the grammar.
Remember that **only functions can appear at the top level**.
Consider that there is a single `main` function, and you need just to translate that in these exercises.

### A function returning a constant

```text
function main() {
    return 1;
}
```

### A function returning an arithmetic expression

```text
function main() {
    return 1 + 2;
}
```

### A function with a nested expression

```text
function main() {
    return (1 + 2) * 3;
}
```

### A function with several operations

```text
function main() {
    return 10 - 2 * 3;
}
```

These examples exercise different aspects of the translator:

* constants require generating a value in a register;
* binary operations require multiple operand registers;
* nested expressions exercise the post-order traversal;
* assignments require keeping a computed value available;
* multiple statements exercise register lifetimes across statements.

## Register Pool

The translator uses a fixed set of registers:

```text
R0 R1 R2 R3 R4 R5 R6 R7 R8
```

These are the registers exposed by the code-generation interface. `SmiCodeGenerator` maps them to appropriate underlying registers for the target architecture.

The translator should not need to know which physical registers are used by the architecture.

A register pool is responsible for allocating and releasing registers. It should conceptually provide operations such as:

```smalltalk
registerPool takeRegister
registerPool returnRegister: aRegister
```

The translator should use the register pool rather than choosing registers directly.

## Translation Algorithm

The translator should implement the following algorithm for every AST node:

```text
visit(node):
    translate all operands
    obtain a register for the result
    generate the instruction
    release the operand registers
    return the result register
```

For example, the general structure can be:

```smalltalk
visit: aNode
    | operands resultRegister |

    operands := aNode operands collect: [ :operand |
        self visit: operand
    ].

    resultRegister := registerPool takeRegister.

    self
        generateInstruction: aNode
        on: resultRegister
        ops: operands.

    operands do: [ :register |
        registerPool returnRegister: register
    ].

    ^ resultRegister
```

Implement the missing parts of the translator so that the ASTs from the previous exercises can be translated into actual code using `SmiCodeGenerator`.

## Functions

The language grammar only permits **functions at the top level**.

Therefore, the translator does not translate the whole program into a single sequence of instructions. Instead, it must generate a sequence of instructions **for each function**.

The function-level structure of the AST should be preserved by the translator.

For example:

```text
function calculate() {
    x := 1 + 2;
    return x * 3;
}

function other() {
    return 10 - 4;
}
```

The translator must generate code separately for `calculate` and `other`.

## Testing

Use the generated code with the appropriate `SmiCodeGenerator` architecture:

```smalltalk
SmiCodeGenerator aarch64
```

Test your translator with the example programs above as well as the ASTs from the previous exercises.

For each example, verify that:

1. the AST is traversed in post-order;
2. registers are obtained from the register pool;
3. the generated instructions use the registers `R0` through `R8`;
4. operand registers are released when they are no longer needed;
5. the register containing the result of an expression remains allocated;
6. each function produces its own sequence of instructions.

The two exercises have different purposes:

| Exercise | Registers       | Code generation            |
| -------- | --------------- | -------------------------- |
| 1        | `T1`, `T2`, ... | By hand                    |
| 2        | `R0`–`R8`       | Through `SmiCodeGenerator` |

Exercise 1 focuses on the **post-order traversal and register-based representation**.

Exercise 2 adds **register allocation with a finite register pool** and connects the translator to the actual RTL code-generation interface.
