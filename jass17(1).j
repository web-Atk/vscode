#include "jass17(3).j"
library demo2 requires util
    // private function aaa takes nothing returns nothing  //可以通过加修饰符private来避免同名函数被引用
    //     call BJDebugMsg("aaa执行了")
    // endfunction 
    function bbb takes nothing returns nothing
        call BJDebugMsg("bbb执行了")
        call aaa()
    endfunction
endlibrary 
