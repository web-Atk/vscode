////up主 庞各庄大棚 jass基础-自定义library 
#include "jass17(1).j"
#include "jass17(2).j"
#include "jass17(3).j"
library demo initializer test requires demo2,demo3,util
    // function aaa takes nothing returns nothing 
    //     call BJDebugMsg("aaa执行了") 
    // endfunction 

    function test takes nothing returns nothing 
        // call aaa() 
        call bbb()
        call ccc()
    endfunction 
endlibrary 
