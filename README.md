<p align="center">
  <img src="img/daikon.png">
</p>
<p align="center">
  <b>Optimized matrix operations via generated expressions in Batch</b>
</p>

## Features
* Easy-to-use interface
* Supports all basic matrix operations
* Generates expressions instead of FOR loops
* Allows calculations in a single SET /A
* No external exes, contained within a single batch file

## Usage
**daikon** is a simple Batch library that allows matrix operations through generating expressions. It includes a "building block" interface that allows you to compose operations together, allowing you to run them using a single SET /A. It is ideal for simulations or programs where the operations are defined beforehand. Furthermore, through the use of line continuations, one can create extremely readable code. For example, a grayscale filter is as simple as

```Batch
SET matrix=255 255 32; ^
           255 12 255; ^
           213 77 196; ^
           100 123 57; ^
           120 50 140; ^
           100 255 140; ^
           62 230 98

CALL DAIKON SET_MATRIX cols "%matrix%"
CALL DAIKON SET_CONST_MATRIX avg 3 1 1

CALL DAIKON GEN_EXPR "MULT cols avg gray" ^
                     "DIV_CONST gray 3"
                     
SET /A "%$expr%"
```

## Documentation
Visit the documentation [here](doc/README.md)!
 
## Examples
Look at the examples [here](ex)! To run them, copy ```daikon.bat``` [here](src/daikon.bat) into the same directory.
