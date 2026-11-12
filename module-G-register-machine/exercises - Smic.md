# Exercises: Exploring Register-Based Machine Code

In these exercises you will use the Pharo VM's Cogit assembler through
`SmiCodeGenerator` to explore how simple integer operations are translated
into machine code.

```smalltalk
Metacello new
    baseline: 'SmiParser';
    repository: 'github://guillep/compiler-course:main';
    load.
```

The same programs can be assembled for different ISAs:

- AArch64
- x64

The goal is not to learn either assembly language in detail. Instead, use
the disassembler and the architecture documentation to understand how the
same abstract operations are implemented differently.

We will only use:

- `MoveCq:R:`
- `MoveR:R:`
- `AddR:R:`
- `AddCq:R:`
- `SubR:R:`
- `SubCq:R:`
- `MulR:R:`
- `RetN:` with 0 as argument, which returns popping 0 bytes from the stack

Do not use:

- control flow
- loops
- function calls
- pointers
- structs
- memory accesses
- division

Only registers `R0` through `R5` are needed.

---

## 1. Integer constants

Start by loading constants into registers.

```smalltalk
program := SmiCodeGenerator aarch64
    assemble: [ :asm |
        asm MoveCq: 10 R: R0.
        asm MoveCq: 20 R: R1.
        asm RetN: 0
    ].
````

### Tasks

1. Disassemble the program.
2. Run it and inspect `R0` and `R1`.
3. Change the constants.
4. Try positive and negative integers.
5. Try zero.

```smalltalk
program disassemble: 4.

runner := SmiRunner new.
runner run: program.
runner r0.
runner r1.
```

### Questions

* How is a constant moved into a register?
* How many machine instructions are generated?
* Does the generated code differ between AArch64 and x64?

---

## 2. Register-to-register moves

Use `MoveR:R:` to copy a value between registers.

For example, construct a program that:

1. puts `42` in `R0`;
2. copies `R0` to `R1`;
3. copies `R1` to `R2`.

```smalltalk
program := SmiCodeGenerator aarch64
    assemble: [ :asm |
        asm MoveCq: 42 R: R0.
        asm MoveR: R0 R: R1.
        asm MoveR: R1 R: R2.
        asm RetN: 0
    ].
```

### Tasks

1. Run the program.
2. Inspect `R0`, `R1`, and `R2`.
3. Disassemble it.
4. Repeat for x64.

### Questions

* What machine instruction implements `MoveR:R:`?
* Is a register-to-register move the same on both ISAs?
* Does the abstract operation map to exactly one machine instruction?

---

## 3. Addition of two registers

Use `AddR:R:` to add two register values.

Construct a program that computes:

```text
7 + 5
```

and leaves the result in a register.

For example, first put the operands in two registers and then perform
the addition.

### Tasks

1. Write the program.
2. Run it and verify the result.
3. Disassemble it.
4. Repeat using the other ISA.

### Questions

* Which register contains the result?
* Which operand is the destination?
* How does this correspond to the documented two-address RTL convention?
* What machine instruction implements the addition?
* In the 2AC model one of the registers get overridden. How can you avoid that and get three registers with values 7, 5 and 12?

---

## 4. Addition with a constant

Use `AddCq:R:`.

Construct programs computing:

```text
10 + 3
100 + 25
7 + (-2)
```

### Tasks

For each program:

1. Load the initial value into a register.
2. Add the constant.
3. Run the program.
4. Inspect the result.
5. Disassemble it.

### Questions

* How is `AddCq:R:` different from `AddR:R:`?
* Does the target ISA have an immediate form of its add instruction?
* Is the constant encoded directly in the machine instruction?

---

## 5. Subtraction

Use both:

```text
SubR:R:
SubCq:R:
```

Construct programs computing:

```text
20 - 7
17 - 25
10 - 30
```

### Tasks

1. Implement the examples using register operands.
2. Implement them using immediate constants.
3. Run them.
4. Disassemble them for both AArch64 and x64.

### Questions

* Which register receives the result?
* How is subtraction represented in each ISA?
* Is the immediate form different from the register form?
* What happens when the result is negative?

---

## 6. Multiplication

The RTL provides:

```text
MulR:R:
```

but there is no `MulCq:R:`.

Construct a program that computes:

```text
6 * 7
12 * 5
-3 * 8
```

You therefore need to place both operands in registers before multiplying.

### Tasks

1. Implement the three examples.
2. Run them.
3. Disassemble them for AArch64.
4. Disassemble them for x64.
5. Compare the generated machine code.

### Questions

* Which register receives the result?
* Is multiplication a single machine instruction on both ISAs?
* How similar are the AArch64 and x64 implementations?
* Why might an abstract `MulR:R:` operation be useful even though the
  concrete machine instructions are different?

---

## 7. Combining operations

Now combine several operations.

Compute:

```text
(10 + 5) * 3
```

Remember that multiplication only has a register-register form.

Then compute:

```text
(100 - 20) + 7
```

and:

```text
(8 * 9) - 10
```

### Tasks

For each expression:

1. Decide which intermediate values need registers.
2. Write the assembler program.
3. Run it.
4. Check the final result.
5. Disassemble it.

### Questions

* How many registers did you need?
* Could you reduce the number of registers?
* How does the order of the RTL instructions affect the generated code?

---

## 8. One expression, different implementations

Compute:

```text
(10 + 20) - (7 + 3)
```

Use only the available registers `R0`–`R5`.

First write the most straightforward implementation you can.

Then try to reduce the number of registers used while keeping the left-to-right evaluation order.

### Questions

* What is the minimum number of registers you can use?
* Does reducing the number of registers change the generated machine code?
* Does the answer differ between AArch64 and x64?

---

## 9. From RTL to machine instruction

Choose three of the programs above.

For each one, produce the following chain:

```text
Smalltalk expression
        ↓
RTL operation
        ↓
generated machine instruction
        ↓
effect on registers
```

For example:

```text
10 + 20
   ↓
AddCq:R:
   ↓
AArch64 add-immediate instruction
   ↓
R? = R? + 20
```

Do the same for x64.

The important point is to understand that the Cogit RTL operation is an
**abstract operation**. The concrete machine instruction is chosen by the
architecture-specific backend.

---

# Final challenge

Without using any operation other than the ones introduced in these
exercises, compute:

```text
((15 + 7) * 4) - 10
```

Then compute:

```text
(100 - 37) * (8 + 2)
```

For each program:

1. Use as few registers as you can.
2. Generate AArch64 code.
3. Generate x64 code.
4. Disassemble both.
5. Annotate each machine instruction with the RTL operation that produced it.

Finish by answering:

> What does the RTL instruction set hide from you, and what becomes visible
> when you look at the generated machine code for two different ISAs?
