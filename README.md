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
| <              | <                      |
| >              | >                      |

## Implicit Parenthesis

In the following situations, parenthesis are optional:
- Very First Opening and Very Last Closing parentheses  
  `(D(x)5)` = `D(x)5`  
  `(D(x)D(y)5))` = `D(x)D(y)5`
- Opening Parenthesis for all Golf Scheme Keywords that require them (see keyword translation table).  
  `D(cl)(I(Nl)0(+(c(Sl))1` = `D(cl)INl)0+(cSl))1`
- Closing parenthesis for keywords with a known number of arguments
  `D(cl)INl)0+(cSl))1` => `D(cl)INl0+(cSl)1`

## Examples

- Hello World: `O"Hello World`
- Compute the length of a list: `D(cl)INl0+(cSl)1`
- [Divide the Work][1] Solution: `D(fxy)I=y0~CQyx(f-x1-yQyx")`
- [Sort by Multiplying][2] Solution: ``

1: https://codegolf.stackexchange.com/questions/170676/divide-the-work
