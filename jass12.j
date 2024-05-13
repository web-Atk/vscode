////up主 庞各庄大棚 jass基础-code 
library demo initializer test 
    function aaa takes nothing returns boolean  //code 不能带参数，但可以带返回值
        call BJDebugMsg("--------") 
        return true
    endfunction 

    function test takes nothing returns nothing 
        local code a = function aaa 
        local timer t = CreateTimer() 
        call TimerStart(t, 5, false, a) 
    endfunction 
endlibrary 