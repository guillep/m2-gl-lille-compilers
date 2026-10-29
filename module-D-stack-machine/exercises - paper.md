# Abstract Stack Machine — Instruction Set and Exercises

For every exercise:

* The initial contents of the operand stack are explicitly specified.
* The program must work for **all valid initial stacks**, not just the example.
* The final result must be left on the stack.
* Variables: pushing the value of a variable `a` can be written with the instruction `PUSH a`. You can only use the variables given in each exercises, and they are read-only.


---


# Abstract machine

The machine consists of a single **operand stack** and a program counter.

There is **no memory** and therefore no `LOAD` or `STORE` operation.

The stack is written with its **top on the right**.

For example:

```text
[3, 5, 7]
```

means that `7` is the top of the stack.

Unless otherwise specified, a program must leave its result on the stack.

Boolean values are represented by:

* `0` = false
* `1` = true

## Complete instruction set

The machine has the following instructions, explained below:

```text
PUSH k
POP
DUP
SWAP

ADD
SUB
MUL
MOD

EQ
LT

LABEL L
JUMP L
JUMP_IF_ZERO L
```

## Stack manipulation

| Instruction | Stack effect        | Description                         |
| ----------- | ------------------- | ----------------------------------- |
| `PUSH k`    | `S → S, k`          | Push constant `k` onto the stack.   |
| `POP`       | `S, x → S`          | Remove and discard the top element. |
| `DUP`       | `S, x → S, x, x`    | Duplicate the top element.          |
| `SWAP`      | `S, x, y → S, y, x` | Exchange the two top elements.      |

### Example

Starting with:

```text
[2, 5]
```

After:

```text
PUSH 17
```

it becomes:

```text
[2, 5, 17]
```

After:

```text
POP
```

it becomes:

```text
[2, 5]
```

After:

```text
SWAP
```

it becomes:

```text
[5, 2]
```

After:

```text
DUP
```

the stack is:

```text
[5, 2, 2]
```

---

## Arithmetic

All binary arithmetic instructions consume the two top elements.

| Instruction | Stack effect           | Description       |
| ----------- | ---------------------- | ----------------- |
| `ADD`       | `S, a, b → S, a+b`     | Addition          |
| `SUB`       | `S, a, b → S, a-b`     | Subtraction       |
| `MUL`       | `S, a, b → S, a×b`     | Multiplication    |
| `MOD`       | `S, a, b → S, a mod b` | Integer remainder |

The order matters for `SUB` and `MOD`.

For example:

```text
[10, 3]
SUB
```

produces:

```text
[7]
```

---

## Comparison

| Instruction | Stack effect        | Description                         |
| ----------- | ------------------- | ----------------------------------- |
| `EQ`        | `S, a, b → S, a=b`  | Push `1` if `a = b`, otherwise `0`. |
| `LT`        | `S, a, b → S, a<b`  | Push `1` if `a < b`, otherwise `0`. |

For example:

```text
PUSH 3
PUSH 7
LT
```

leaves:

```text
[1]
```

`a > b` can be expressed as `b < a`, so a separate `GT` instruction is unnecessary.

---

## Control flow

### `LABEL L`

Defines a named position in the program.

```text
loop:
```

is shorthand for:

```text
LABEL loop
```

Labels do not modify the stack.

### `JUMP L`

Unconditionally transfers control to label `L`.

### `JUMP_IF_ZERO L`

Pops the top value from the stack.

* If the value is `0`, execution jumps to `L`.
* If the value is non-zero, execution continues with the next instruction.

For example:

```text
PUSH condition
PUSH 0
EQ
JUMP_IF_ZERO else
PUSH 1
else:
...
```

implements the equivalent of:

```text
if (condition == 0){
    1
}
...

```

# Level 1 — Basic stack programming

## Exercise 1 — Arithmetic expression

Produce a program that computes:

```
(a+b) * (c-2)
```

The initial stack is empty `[]`. `a`, `b` and  `c` are variables.

```text
Given:

a = 1
b = 4
c = 3
INITIAL_STACK = []

RESULT = [5]
```


---

## Exercise 2 — Expression with repeated operands

Produce a program that computes:

```
x^2+x
```

Where `x` is the top of the stack.

Example:

```text
Given:

INITIAL_STACK = [5]

RESULT = [30]
```

---

## Exercise 3 — A more complicated expression

Produce a program that computes:

```
(b-a)*(c+d)
```

Where `a` is the top of the stack, `b`, `c` and `d` are variables.

Example:

```text
Given:

b = 10
c = 4
d = 2
INITIAL_STACK = [10]

RESULT = [42]
```

---

## Exercise 4 — Boolean expression

Produce a program that computes:

```
(a < b) AND (b < c)
```

Where `a`, `b` and `c` are variables.

Use only `EQ`, `LT`, and control-flow instructions.
The final stack must contain `0` or `1`.


Example 1:

```text
[2, 5, 8] → [1]
[2, 8, 5] → [0]
```

```text
Given:

a = 2
b = 5
c = 8
INITIAL_STACK = []

RESULT = [1]
```

Example 2:

```text
Given:

a = 2
b = 8
c = 5
INITIAL_STACK = []

RESULT = [0]
```

---

# Level 2 — Conditionals

## Exercise 5 — Absolute value

Produce a program that computes:

```
|x|
```

Where `x` is the top of the stack.

Example 1:

```text
Given:

INITIAL_STACK = [-7]

RESULT = [7]
```

Example 2:

```text
Given:

INITIAL_STACK = [3]

RESULT = [3]
```

Example 3:

```text
Given:

INITIAL_STACK = [0]

RESULT = [0]
```

**To make it more interesting:** Can you do it without multiplication?

---

## Exercise 6 — Maximum of two values

Produce a program that computes:

```
max(a, b)
```

Where `a` is the top of the stack and `b` is a variable.

Example 1:

```text
Given:

b = 17
INITIAL_STACK = [5]

RESULT = [17]
```

Example 2:

```text
Given:

b = 5
INITIAL_STACK = [17]

RESULT = [17]
```

---

## Exercise 7 — Sign function

Produce a program that computes:

```
signof(a)
```

Where `a` is the top of the stack.
Returning 1 if positive, -1 if negative, 0 if zero.

Example 1:

```text
Given:

INITIAL_STACK = [5]

RESULT = [1]
```

Example 1:

```text
Given:

INITIAL_STACK = [0]

RESULT = [0]
```

Example 1:

```text
Given:

INITIAL_STACK = [-5]

RESULT = [-1]
```

---

## Exercise 8 — Conditional arithmetic

Produce a program that computes:

```
a+b if a < b
a-b otherwise
```

Where `a` is the top of the stack and `b` is a variable.

Example 1:

```text
Given:

b = 17
INITIAL_STACK = [5]

RESULT = [22]
```

Example 2:

```text
Given:

b = 5
INITIAL_STACK = [17]

RESULT = [12]
```

---

# Level 3 — Loops

The following exercises require genuine loops using `LABEL`, `JUMP`, and `JUMP_IF_ZERO`.

## Exercise 9 — Push values from N to 1

Produce a program that pushes to the stack all values from N to 1.
Where `N` is the top of the stack.

Example:

```text
Given:

INITIAL_STACK = [5]

RESULT = [5, 4, 3, 2 1]
```

---

## Exercise 10 — Sum from 1 to n

Produce a program that computes the sum from 1 to N.
Where `N` is the top of the stack.

Example:

```text
Given:

INITIAL_STACK = [5]

RESULT = [15]
```

Because 1+2+3+4+5 = 15

**Tip:** Can you reuse your solution of the previous exercise and use a marker on the stack?

---

## Exercise 11 — Factorial

Produce a program that computes the N!.
Where `N` is the top of the stack, and, for the sake of the exercise, is always > 1.

Example:

```text
Given:

INITIAL_STACK = [5]

RESULT = [120]
```

Remember N! = N*(N-1)! and 1!=0

**Tip:** Can you reuse your solution of the previous exercise?

---
## Exercise 12 — Count zeros

Produce a program that computes the number of zeroes in the stack.
Consider that at the bottom of the stack there is a non-zero `marker` value that you can use to compute when you finished.

Example:

```text
Given:

INITIAL_STACK = [marker, 0, 1, 12, 0 ,27]

RESULT = [2]
```

**Tip:** The marker at the base of the stack is nice. How can you maintain the counter?