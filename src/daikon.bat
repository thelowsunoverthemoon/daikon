CALL :%1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF

:CREATE_PRINT <m> <n> <space>
FOR /F %%A in ('ECHO PROMPT $E ^| CMD') DO SET "\e=%%A"
SET /A "$n=%3 * %2"
FOR /L %%Y in (1, 1, %1) DO (
    FOR /L %%X in (1, 1, %2) DO (
        SET "print[%1.%2]=!print[%1.%2]!%\e%[s%\e%[%3X^!$o[%%Y.%%X]^!%\e%[u%\e%[%3C"
    )
    SET "print[%1.%2]=!print[%1.%2]!%\e%[B%\e%[!$n!D"
)
SET "$n="
GOTO :EOF

:SET_IDENTITY_MATRIX <var> <d>
SET /A "%1[m]=%2", "%1[n]=%2"
FOR /L %%M in (1, 1, %2) DO (
    FOR /L %%N in (1, 1, %2) DO (
        IF "%%M" == "%%N" (
            SET "%1[%%M.%%N]=1"
        ) else (
            SET "%1[%%M.%%N]=0"
        )
    )
)
GOTO :EOF

:SET_CONST_MATRIX <var> <m> <n> <c>
SET /A "%1[m]=%2", "%1[n]=%3"
FOR /L %%M in (1, 1, %2) DO (
    FOR /L %%N in (1, 1, %3) DO (
        SET "%1[%%M.%%N]=%4"
    )
)
GOTO :EOF

:GEN_EXPR <operations>
SET "$end[MULT_CONST]=*$c"
SET "$end[DIV_CONST]=/$c"
SET "$end[ADD_CONST]=+$c"
FOR %%# in (%*) DO (
    FOR /F "tokens=1-4 delims= " %%A in ("%%~#") DO (
        IF /I "%%A" == "MULT" (
            CALL :SET_TEMP_EXPR MULT !%%B[m]!.!%%B[n]!.!%%C[n]! $expr[temp]
            SET "$expr[temp]=!$expr[temp]:$b=%%C!"
            CALL :WRITE_SAVED_EXPR %%B
            CALL :WRITE_SAVED_EXPR %%C
            SET /A "%%D[m]=%%B[m]", "%%D[n]=%%C[n]"
            SET "$expr=!$expr!!$expr[temp]:$o=%%D!,"
            SET "$save[%%D]="
        ) else IF /I "%%A" == "ADD" (
            CALL :SET_TEMP_EXPR ADD !%%B[m]!.!%%B[n]! $expr[temp]
            SET "$expr[temp]=!$expr[temp]:$b=%%C!"
            CALL :WRITE_SAVED_EXPR %%B
            CALL :WRITE_SAVED_EXPR %%C
            SET /A "%%D[m]=%%B[m]", "%%D[n]=%%C[n]"
            SET "$expr=!$expr!!$expr[temp]:$o=%%D!,"
            SET "$save[%%D]="
        ) else IF /I "%%A" == "EQUAL" (
            CALL :SET_TEMP_EXPR EQUAL !%%B[m]!.!%%B[n]! $expr[temp]
            CALL :WRITE_SAVED_EXPR %%C
            SET "$expr=!$expr!!$expr[temp]:$b=%%C!,"
            SET "$save[%%B]="
        ) else IF /I "%%A" == "ROUND" (
            CALL :SET_TEMP_EXPR ROUND !%%B[m]!.!%%B[n]! $expr[temp]
            CALL :WRITE_SAVED_EXPR %%B
            SET "$expr=!$expr!!$expr[temp]:$c=%%C!,"
        ) else (
            IF "!$save[%%B]!" == "" (
                CALL :SET_TEMP_EXPR SINGLE !%%B[m]!.!%%B[n]! $save[%%B]
            )
            FOR %%1 in ("!$start[%%A]!") DO (
                FOR %%2 in ("!$end[%%A]:$c=%%C!") DO (
                    SET "$save[%%B]=!$save[%%B]:?=?%%~1(!"
                    SET "$save[%%B]=!$save[%%B]:#=)%%~2#!"
                )
            )
        )
    )
)
FOR /F "tokens=1,* delims==" %%S in ('SET $save[ 2^>NUL') DO (
    SET "$expr[temp]=%%T"
    SET "$expr[temp]=!$expr[temp]:?=!"
    SET "$expr=!$expr!!$expr[temp]:#=!,"
    SET "%%S="
)
SET "$expr=%$expr:~0,-1%"
SET "$args="
GOTO :EOF

:SET_TEMP_EXPR <type> <args> <var>
SET "$args=%2"
IF not defined %1[%$args%] (
    CALL :SET_FORM %1 %$args:.= %
)
FOR %%? in ("%$args%") DO (
    SET "%3=!%1[%%~?]:$a=%%B!"
)
GOTO :EOF

:WRITE_SAVED_EXPR <var>
IF defined $save[%1] (
    SET "$save[%1]=!$save[%1]:?=!"
    SET "$expr=!$expr!!$save[%1]:#=!,"
    SET "$save[%1]="
)
GOTO :EOF

:SET_FORM <type> <args>
IF /I "%1" == "MULT" (
    FOR /L %%Y in (1, 1, %2) DO (
        FOR /L %%X in (1, 1, %4) DO (
            SET "mult[%2.%3.%4]=!mult[%2.%3.%4]!,$o[%%Y.%%X]="
            FOR /L %%D in (1, 1, %3) DO (
                SET "mult[%2.%3.%4]=!mult[%2.%3.%4]!$a[%%Y.%%D]*$b[%%D.%%X]+"
            )
            SET "mult[%2.%3.%4]=!mult[%2.%3.%4]:~0,-1!"
        )
    )
    SET "mult[%2.%3.%4]=!mult[%2.%3.%4]:~1!"
) else IF /I "%1" == "SINGLE" (
    FOR /L %%Y in (1, 1, %2) DO (
        FOR /L %%X in (1, 1, %3) DO (
            SET "single[%2.%3]=!single[%2.%3]!,$a[%%Y.%%X]=?$a[%%Y.%%X]#"
        )
    )
    SET "single[%2.%3]=!single[%2.%3]:~1!"
) else IF /I "%1" == "ADD" (
    FOR /L %%Y in (1, 1, %2) DO (
        FOR /L %%X in (1, 1, %3) DO (
            SET "add[%2.%3]=!add[%2.%3]!,$o[%%Y.%%X]=$a[%%Y.%%X]+$b[%%Y.%%X]"
        )
    )
    SET "add[%2.%3]=!add[%2.%3]:~1!"
) else IF /I "%1" == "EQUAL" (
    FOR /L %%Y in (1, 1, %2) DO (
        FOR /L %%X in (1, 1, %3) DO (
            SET "equal[%2.%3]=!equal[%2.%3]!,$a[%%Y.%%X]=$b[%%Y.%%X]"
        )
    )
    SET "equal[%2.%3]=!equal[%2.%3]:~1!"
) else IF /I "%1" == "ROUND" (
    FOR /L %%Y in (1, 1, %2) DO (
        FOR /L %%X in (1, 1, %3) DO (
            SET "round[%2.%3]=!round[%2.%3]!,$a[%%Y.%%X]=($a[%%Y.%%X]+(($a[%%Y.%%X]>>31)*2+1)*$t)/$c*$c"
        )
    )
    SET "round[%2.%3]=$t=$c/2!round[%2.%3]!"
)
GOTO :EOF

:SET_MATRIX <var> <matrix>
SET "$str=%2"
SET "%1[m]=0"
FOR %%Y in (%$str:;=" "%) DO (
    SET /A "%1[n]=0", "%1[m]+=1"
    FOR %%X in (%%~Y) DO (
        SET /A "%1[n]+=1"
        SET "%1[!%1[m]!.!%1[n]!]=%%X"
    )
)
SET "$str="
GOTO :EOF