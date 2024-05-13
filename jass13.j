////up主 庞各庄大棚 jass基础-function_1    
library demo initializer test 
    
function bbb takes nothing returns widget
    local unit u = CreateUnit(Player(0),'hfoo',0,0,0)
    return u //这也是成立的，因为unit父类就是widget
endfunction

    function aaa takes integer i, integer j returns integer //传过来的是形参 
        local integer x = i + j 
        if i > j then 
            return //一旦出现return就不会再执行下面的动作
        endif 
        loop 
            exitwhen i > 3 
            if i == j then 
                return //循环也是一样的，一旦出现返还值就会退出循环
            endif 
            set i = i + 1 
        endloop 
        call BJDebugMsg("++++++") 
    endfunction 

    function test takes nothing returns nothing //变量需要先声明后赋值，声明置顶 
        local integer a = 11 
        local integer b = 22 
        local integer res = aaa(a, b) 
        call BJDebugMsg(I2S(res)) 
    endfunction 
endlibrary 