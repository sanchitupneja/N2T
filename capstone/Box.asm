(LOOP)
    @KBD
    D=M
    @SET_WHITE
    D;JEQ

    @color
    M=-1
    @DRAW_INIT
    0;JMP

(SET_WHITE)
    @color
    M=0

(DRAW_INIT)
    @18784
    D=A
    @addr
    M=D

    @20
    D=A
    @rows
    M=D

(ROW_LOOP)
    @rows
    D=M
    @LOOP
    D;JEQ

    @color
    D=M
    @addr
    A=M
    M=D
    A=A+1
    M=D
    A=A+1
    M=D
    A=A+1
    M=D

    @32
    D=A
    @addr
    M=D+M

    @rows
    M=M-1

    @ROW_LOOP
    0;JMP