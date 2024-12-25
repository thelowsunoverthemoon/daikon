@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F %%A in ('ECHO PROMPT $E ^| CMD') DO SET "\e=%%A"
SET "sin=(a=((x*31416/180)%%62832)+(((x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) "
SET "cos=(a=((15708-x*31416/180)%%62832)+(((15708-x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) "
SET "pause=FOR /L %%J in (1, #, 1000000) DO REM"

TITLE Rotate
MODE 35, 35
(CHCP 65001)>NUL

:: other degrees become smaller and smaller due to rounding
SET "degree=45"

SET /A "s1.1=%cos:x=degree%"
SET /A "s1.2=%sin:x=degree%"
SET /A "s2.1=-s1.2"
SET /A "s2.2=s1.1"
SET matrix=%s1.1% %s1.2%; ^
           %s2.1% %s2.2%
CALL DAIKON SET_MATRIX rotate "%matrix%"
SET matrix=2 2 9 9; ^
           2 9 2 9
CALL DAIKON SET_MATRIX points "%matrix%"

CALL DAIKON GEN_EXPR "MULT rotate points out" ^
                     "ROUND out 10000" ^
                     "DIV_CONST out 10000" ^
                     "EQUAL points out" ^
                     "ADD_CONST out 18"

ECHO %\e%[?25l%\e%[38;2;66;230;245m

FOR /L %%G in () DO (
    SET /A "%$expr%"
    FOR /L %%N in (1, 1, !out[n]!) DO (
        SET "disp=!disp!%\e%[!out[1.%%N]!;!out[2.%%N]!H█"
    )
    ECHO %\e%[2J!disp!
    SET "disp="
    %pause:#=10%
)

EXIT /B