////up主 庞各庄大棚 jass基础-function_2_值传递和引用传递
library demo initializer test 
    function aaa takes string s,integer i ,unit u returns nothing
        set s = "这是aaa方法"
        set i = 22
        call BJDebugMsg(s)
        call BJDebugMsg(I2S(i))
        call SetUnitState(u,UNIT_STATE_LIFE,100)
        call BJDebugMsg(R2S(GetUnitState(u,UNIT_STATE_LIFE)))
    endfunction
    function test takes nothing returns nothing 
        local string s = "这是test方法"
        local integer i = 11
        local unit u = CreateUnit(Player(0),'hfoo',0,0,0)
        call aaa(s,i,u)
        call BJDebugMsg(s)
        call BJDebugMsg(I2S(i))
        call BJDebugMsg(R2S(GetUnitState(u,UNIT_STATE_LIFE)))
    endfunction 
endlibrary 