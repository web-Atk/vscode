////up主 庞各庄大棚 jass基础-触发器 
library demo initializer test 
    globals
        real r = 10
    endglobals
    function aaa takes nothing returns nothing 
        call BJDebugMsg("-----------") 
    endfunction 
    function bbb takes nothing returns nothing
        set r = r -1
        call BJDebugMsg(R2S(r))
    endfunction
    function test takes nothing returns nothing 
        local trigger t = CreateTrigger() 
        local timer tm = CreateTimer()
        call TimerStart(tm,1,true,function bbb)
        // local unit u = CreateUnit(Player(0), 'hfoo', 0, 0, 0) 
        // call TriggerRegisterPlayerEvent(t,Player(0),EVENT_PLAYER_CHAT) 
        // call TriggerRegisterPlayerChatEvent(t,Player(0),"111",false) 
        // call TriggerRegisterPlayerUnitEvent(t,Player(0),EVENT_PLAYER_UNIT_PICKUP_ITEM,null) 
        // call TriggerRegisterUnitLifeEvent(t,u,LESS_THAN,400) 
        call TriggerRegisterVariableEvent(t,"r",LESS_THAN,3)
        // call TriggerAddCondition() 
        call TriggerAddAction(t, function aaa) 
    endfunction 
endlibrary 