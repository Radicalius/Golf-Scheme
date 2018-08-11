# Golf Scheme

<i>Scheme with shorter keywords and less parenthesis</i>

Golf scheme is a scheme variant with a more succinct syntax. It is transpiled into a normal variant of scheme and run.  GSCM is the official transpiler for Golf Scheme written in scheme.  This repository provides several variants designed for use with different underlying scheme variants.  For instance, the file `gscm-chez` transpiles golf scheme into chez scheme and evaluates it.  As such, `gscm-chez` must be run using a chez scheme interpreter.  

## Syntax

Since scheme has relatively few keywords, Golf Scheme replaces them with uppercase characters (see keyword translation table).  Lowercase characters are reserved for user defined variables, functions, and formal parameters.  In addition, some parenthesis can be assumed at transpile time, and thus can be omitted (see implicit parenthesis section).  See last section for some examples.


## Keyword Translations

Each scheme keyword listed must be substituted with its corresponding letter in Golf Scheme.

| Scheme Keyword | Golf Scheme Equivalent |
|----------------|------------------------|
| append         | A                      |
| begin          | B                      |
| cons           | C                      |
| define         | D                      |
| else           | E                      |
| first or car   | F                      |
| if             | I                      |
| cond           | J                      |
| lambda         | L                      |
| null?          | N                      |
| list           | M                      |
| display        | O                      |
| pair?          | P                      |
| second or cdr  | S                      |
| nil or '()     | ~                      |
| and            | &                      |
| or             | &#124;                 |
| not            | !                      |
| number?        | #                      |
| equal?         | =                      |

## Implicit Parenthesis

In the following situations, parenthesis are optional:
- Very First Opening and Very Last Closing parenthesis  
  `(D(x)5)` = `D(x)5`  
  `(D(x)D(y)5))` = `D(x)D(y)5`  
