//up主 以天下为之笼 魔兽Jass教程（十）数组 
globals 

    string array A 
    item array B 
    unit array C 
    boolean array D 
    real array E 
    integer array F 

endglobals 


function jass2 takes nothing returns nothing 

    //local integer array a 

    // set a[1]=100 
    // set a[2]=200 
    // set a[3]=300 
    // set a[4]=400 
    // set a[5]=500 

    //call BJDebugMsg(I2S(a[1])) 
    //call BJDebugMsg(I2S(a[2])) 
    //call BJDebugMsg(I2S(a[3])) 
    //call BJDebugMsg(I2S(a[4])) 
    //call BJDebugMsg(I2S(a[5])) 

    set A[0] = "Hello" 
    set A[1] = "world" 

    set B[0] = CreateItem('afac', 0, 0) 
    set B[1] = CreateItem('ssil', 100, 100) 

    call BJDebugMsg(A[0]) 
    call BJDebugMsg(A[1]) 

    call BJDebugMsg("afac：" + I2S('afac')) 
    call BJDebugMsg("ssil：" + GetItemName(B[1])) 

endfunction 

