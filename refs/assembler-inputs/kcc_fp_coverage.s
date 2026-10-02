.text
__start:
        movei 1,3
        fsc 1,233
        fltr 2,1
        fadr 1,[202600000000]
        fadl 2,4
        fsbl 2,4
        fmpl 2,4
        fdvl 2,4
        dfad 2,[202400000000]
        dfsb 2,[202400000000]
        dfmp 2,[202400000000]
        dfdv 2,[202400000000]
        ldb 3,[POINT 9,1(5),8]
        dpb 3,[POINT 9,1(5),8]
        halt
