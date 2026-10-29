# Parsing Exercises: Drawing ASTs

In these exercises, you will practice parsing by constructing abstract syntax trees (ASTs) by hand.

You are given a grammar describing a small subset of Pharo syntax. For each program, parse the program according to the grammar and **draw its AST on paper**.

Do not evaluate the expressions. The goal is to determine the structure imposed by the grammar.

## Reading the Grammar

The grammar is written in a notation similar to **BNF (Backus–Naur Form)**. Each rule defines how a syntactic construct can be formed.

For example:

```text
BinaryMessage ::= UnaryMessage BinaryMessagePart*
```

This means that a `BinaryMessage` consists of one `UnaryMessage`, followed by **zero or more** `BinaryMessagePart`s.

The notation used in this grammar is:

```text
A ::= B C
```

means that `A` consists of `B` followed by `C`.

```text
A ::= B | C
```

means that `A` can be either `B` or `C`.

```text
A*
```

means **zero or more** occurrences of `A`.

```text
A+
```

means **one or more** occurrences of `A`.

Parentheses group elements together. For example:

```text
Sequence ::= Statement (';' Statement)*
```

means that a `Sequence` contains one `Statement`, optionally followed by any number of additional statements, each preceded by `;`.

Names such as `Expression`, `Statement`, and `BinaryMessage` refer to other grammar rules. Literal symbols such as `;`, `(`, `)`, and `:=` refer directly to those tokens in the source program.

## Grammar

The following grammar describes the subset of Pharo used in these exercises.

```text
Program       ::= Expression

Expression    ::= MessageExpression | AssignmentExpression

AssignmentExpression ::= Variable ':=' Expression

MessageExpression
              ::= KeywordMessage
                | BinaryMessage

KeywordMessage
              ::= BinaryMessage KeywordMessagePart+
KeywordMessagePart
              ::= Keyword BinaryMessage

BinaryMessage ::= UnaryMessage BinaryMessagePart*
BinaryMessagePart
              ::= BinarySelector UnaryMessage

UnaryMessage  ::= Primary UnaryMessagePart*
UnaryMessagePart
              ::= UnarySelector

Primary       ::= Variable
                | Literal
                | Block
                | '(' Expression ')'

Block         ::= '[' BlockArguments? '|' Sequence? ']'

BlockArguments
              ::= BlockArgument+

BlockArgument ::= ':' Variable

Literal       ::= Integer
                | String
                | true
                | false
                | nil

Variable      ::= identifier

Keyword       ::= identifier ':'
UnarySelector  ::= identifier
BinarySelector ::= '+' | '-' | '*' | '/' | '=' | '<' | '>' | '<=' | '>='
```

For this worksheet, assume the grammar above generates AST nodes with names:

```text
Assignment
Message
Variable
Integer
String
Boolean
Nil
Block
```

For message nodes, even though the grammar supports different kinds, assume they all generate the same kind of AST nodes following this structure. I.e., a message node contains the node representing the receiver, the selector, and a list of arguments, which may be an empty list.

```text
Message
    receiver
    selector
    arguments
```

For example, a `KeywordMessage` with a selector such as `at:put:` is represented by one selector with two arguments.


## Exercise 1 — Literals

Draw the grammar derivation and its AST for:

```smalltalk
42
```

---

## Exercise 2 — Variables and Unary Messages

Draw the grammar derivation and its AST for:

```smalltalk
answer factorial
```

---

## Exercise 3 — Binary Messages

Draw the grammar derivation and its AST for:

```smalltalk
3 + 4
```

Pay attention to the fact that `+` is a **binary message**, not an arithmetic operation built into the grammar.

---

## Exercise 4 — Unary and Binary Messages

Draw the grammar derivation and its AST for:

```smalltalk
3 factorial + 2
```

Determine which expression is the receiver of `+`.

---

## Exercise 5 — Keyword Messages

Draw the grammar derivation and its AST for:

```smalltalk
array at: 3
```

Identify the receiver, selector, and argument of the message.

---

## Exercise 6 — Multiple Keyword Arguments

Draw the grammar derivation and its AST for:

```smalltalk
array at: 3 put: 42
```

The selector of the message is:

```text
at:put:
```

The message has two arguments.

---

## Exercise 7 — Message Precedence

Draw the grammar derivation and its AST for:

```smalltalk
object size + 1
```

Use the grammar to determine whether this is parsed as:

```text
object size
```

followed by `+ 1`, or as something else.

---

## Exercise 8 — Parentheses

Draw the grammar derivation and its AST for:

```smalltalk
(1 + 2) * 3
```

Compare the structure with what you would obtain from:

```smalltalk
1 + 2 * 3
```

The grammar, rather than conventional arithmetic precedence, determines the structure.

---

## Exercise 9 — Assignment

Draw the grammar derivation and its AST for:

```smalltalk
result := 3 + 4
```

The left-hand side is a variable, while the right-hand side is an expression.

---

## Exercise 10 — Blocks

Draw the grammar derivation and its AST for:

```smalltalk
[ 1 + 2 ]
```

The expression inside the brackets is the body of a block.

---

## Exercise 11 — Blocks with Arguments

Draw the grammar derivation and its AST for:

```smalltalk
[ :x | x + 1 ]
```

Your AST should represent:

* the block argument `x`;
* the body of the block;
* the binary message `+`.