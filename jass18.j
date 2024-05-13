////up主 庞各庄大棚 jass基础-全局变量和权限修饰符
globals
    public integer i = 100
endglobals
library demo initializer test 
    
    // public function aaa takes nothing returns nothing
    //     call BJDebugMsg("==========")
    // endfunction
    function test takes nothing returns nothing 
    //   call demo2_aaa()
    //   call demo2_bbb()
    //   call demo2_ccc()
    call BJDebugMsg(I2S(demo2_i))
    endfunction 
endlibrary 

library demo2
    
    public function aaa takes nothing returns nothing
        call BJDebugMsg("==========")
    endfunction
    public function bbb takes nothing returns nothing
        call BJDebugMsg("-=-------------------")
    endfunction
    public function ccc takes nothing returns nothing
        call BJDebugMsg("000000")
    endfunction
endlibrary
