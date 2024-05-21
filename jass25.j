////up主 庞各庄大棚 jass基础-计时器  
library demo initializer test 
    globals 
        unit boss = null 
        real leftLife 
    endglobals 
    function aaa takes nothing returns nothing 
        // call BJDebugMsg("计时器到期了")  
        set boss = CreateUnit(Player(2), 'hfoo', 0, 0, 0) 
    endfunction 
    function bbb takes nothing returns nothing 
        local timer t = CreateTimer() 
        local trigger tr = CreateTrigger() 
        local timerdialog td = CreateTimerDialog(t) 
        call TimerDialogSetTitle(td, "剩余时间") 
        call TimerDialogDisplay(td, true) 
        // call TimerStart(t,3,true,function aaa)  
        call StartTimerBJ(t, false, 3) 
        call TriggerRegisterTimerExpireEvent(tr, t) 
        call TriggerAddAction(tr, function aaa) 
    endfunction 
    function ccc takes nothing returns nothing 
        call SetUnitInvulnerable(boss, true) 
    endfunction 
    function ddd takes nothing returns nothing 
        if boss != null then 
            set leftLife = GetUnitState(boss, UNIT_STATE_LIFE) 
            call BJDebugMsg(R2S(leftLife)) 
        endif 
    endfunction 
    function test takes nothing returns nothing 
        local trigger tr = CreateTrigger() 
        local trigger t2 = CreateTrigger() 
        local timer tt = CreateTimer() 
        call TimerStart(tt, 1, true, function ddd) 
        call TriggerRegisterTimerEventSingle(tr, 0) 
        call TriggerAddAction(tr, function bbb) 
        call TriggerRegisterVariableEvent(t2, "leftLife", LESS_THAN, 400) 
        call TriggerAddAction(t2, function ccc) 
        call FogEnable(false) 
        call FogMaskEnable(false) 
    endfunction 
endlibrary 