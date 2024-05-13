////up主 庞各庄大棚 jass基础-handle类型1
library demo initializer test 
    function test takes nothing returns nothing 
        local real f
        local unit u = CreateUnit(Player(0),'hfoo',0,0,0)  //unit的父类是widget
        set f = GetWidgetLife(u)
        call BJDebugMsg(R2S(f))
         
    endfunction 
endlibrary 