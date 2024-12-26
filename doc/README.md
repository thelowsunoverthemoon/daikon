## How to Use

1. Copy ```daikon.bat``` into your specified directory
2. Call ```daikon``` with respect to that directory with the function needed.
3. Important : expressions cannot use variable names containing ? or #. Furthermore, ```daikon``` uses internal variables starting with $. It is recommended to not use variables starting with $ to avoid being overwritten. Finally, be aware of the line limit and variable limit in Batch. If the code fails unexpectedly, try splitting up the lines or expressions.

## Matrix Notation

Matrixes are represented through m by n notation, where m are rows and n is columns. Given a matrix `z`, ```daikon``` defines ```z[m]```, ```z[n]```, and ```z[y.x]``` where y and x represent the indices of the specific element.

---

```
:CREATE_PRINT <m> <n> <space>
```

Defines a macro in the form ```print[m.n]``` which can be used to print a matrix in that form. Windows 10+ only. Subsitute ```$o``` with the name of your matrix. For example

```Batch
CALL DAIKON SET_CONST_MATRIX a 5 10 1
CALL DAIKON CREATE_PRINT %a[m]% %a[n]% 8
%print[5.10]:$o=a%
```

* **m** matrix m
* **n** matrix n
* **space** width of column

---

```
:SET_IDENTITY_MATRIX <var> <d>
```

Creates an identity matrix with ```d``` dimensions

* **var** matrix name
* **d** matrix dimensions

---

```
:SET_CONST_MATRIX <var> <m> <n> <c>
```

Creates an ```m``` by ```n``` matrix filled **c**

* **var** matrix name
* **m** matrix m
* **n** matrix n
* **c** constant to fill

---

```
:SET_MATRIX <var> <matrix>
```

Creates a matrix with the contents of ```matrix```. For example

```Batch
SET matrix=2 2 9 9; ^
           2 9 2 9
CALL DAIKON SET_MATRIX points "%matrix%"
```

* **var** matrix name
* **matrix** matrix contents by row, in the form ```"a b c d; e f g h"```. Use line continuations for readable code

---

```
:GEN_EXPR <operations>
```

Generates an expression and returns it in the variable ```$expr```. See below for more details

* **operations** a list of operations (see below) in the form ```"operation 1" "operation 2"```

## Matrix Operations

The operations defined are

* **MULT a b c** multiplies ```a``` with ```b``` into ```c``` (created or overwritten)
* **MULT_CONST a c** multiplies ```a``` element-wise by ```c```
* **DIV_CONST a c** divides ```a``` element-wise by ```c```
* **ADD a b c** adds ```a``` with ```b``` into ```c``` (created or overwritten)
* **ADD_CONST a c** adds ```a``` element-wise by ```c```
* **EQUAL a b** sets ```a``` (created or overwritten) element-wise to ```b``` 
* **ROUND a c** rounds ```a``` element-wise to the nearest ```c```. For example with constant 10, 5 to 10, 2 to 0, -2 to 0, -5 to -10

They must reference already created matrixes. Please note that ```MULT```, ```EQUAL``` and ```ADD``` can create matrixes, which can then be referenced afterwards. Behaviour for invalid matrixes (eg, multiplying two matrixes with incorrect dimensions) will result in incorrect but silent behaviour. Furthermore, for those that take a constant, it can either be any number literal that ```SET /A``` can handle, or a variable name.

