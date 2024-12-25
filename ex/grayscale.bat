@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F %%A in ('ECHO PROMPT $E ^| CMD') DO SET "\e=%%A"

TITLE Grayscale
(CHCP 65001)>NUL

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

ECHO %\e%[?25lNormal
FOR /L %%Y in (1, 1, %cols[m]%) DO (
    ECHO %\e%[38;2;!cols[%%Y.1]!;!cols[%%Y.2]!;!cols[%%Y.3]!m██████████
)
ECHO %\e%[0mGrayscale
FOR /L %%Y in (1, 1, %gray[m]%) DO (
    ECHO %\e%[38;2;!gray[%%Y.1]!;!gray[%%Y.1]!;!gray[%%Y.1]!m██████████
)

(PAUSE)>NUL
EXIT /B