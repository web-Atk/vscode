////up主 庞各庄大棚 jass基础-funciton_3_递归 
library demo initializer test 
    globals
        integer i = 0
    endglobals
    function aaa takes unit u returns nothing 
        if GetUnitState(u,UNIT_STATE_LIFE) < 10 then  //这是出口，让函数退出循环
            return
        endif
        call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_LIFE)-1)
        call aaa(u) 
    endfunction 
    function test takes nothing returns nothing 
        local unit u = CreateUnit(Player(0),'hfoo',0,0,0)
        call aaa(u) 
    endfunction 
endlibrary 