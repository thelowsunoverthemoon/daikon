@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F %%A in ('ECHO PROMPT $E ^| CMD') DO SET "\e=%%A"

TITLE Calculator

CALL DAIKON SET_CONST_MATRIX a 5 10 1
CALL DAIKON SET_CONST_MATRIX b 10 6 1
CALL DAIKON SET_CONST_MATRIX d 5 6 1

CALL DAIKON GEN_EXPR "MULT a b c" ^
                     "ADD c d c" ^
                     "MULT_CONST c 100"

CALL DAIKON CREATE_PRINT %a[m]% %a[n]% 8
CALL DAIKON CREATE_PRINT %b[m]% %b[n]% 8
CALL DAIKON CREATE_PRINT %d[m]% %d[n]% 8

ECHO %\e%[?25l 
FOR /L %%? in () DO (
    SET /A "rand[xa]=!RANDOM! %% a[n] + 1", "rand[ya]=!RANDOM! %% a[m] + 1", ^
           "rand[xb]=!RANDOM! %% b[n] + 1", "rand[yb]=!RANDOM! %% b[m] + 1", ^
           "rand[xd]=!RANDOM! %% d[n] + 1", "rand[yd]=!RANDOM! %% d[m] + 1", ^
           "a[!rand[ya]!.!rand[xa]!]=!RANDOM! %% 100", ^
           "b[!rand[yb]!.!rand[xb]!]=!RANDOM! %% 100", ^
           "d[!rand[yd]!.!rand[xd]!]=!RANDOM! %% 100", ^
           "%$expr%"
           
    ECHO %\e%[2;5HMatrix a%\e%[3;5H%print[5.10]:$o=a% ^
         %\e%[9;5HMatrix b%\e%[10;5H%print[10.6]:$o=b% ^
         %\e%[21;5HMatrix d%\e%[22;5H%print[5.6]:$o=d% ^
         %\e%[28;5Ha * b + d + 100%\e%[29;5H%print[5.6]:$o=c%

)


EXIT /B