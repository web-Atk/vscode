////up主 庞各庄大棚 jass基础-计时器
library demo initializer test 
    function aaa takes nothing returns nothing
        call BJDebugMsg("计时器到期了")
    endfunction
    function bbb takes nothing returns nothing
        local timer t = CreateTimer()
        local trigger tr = CreateTrigger()
        local timerdialog td = CreateTimerDialog(t)
        call TimerDialogSetTitle(td,"剩余时间")
        call TimerDialogDisplay(td,true)
        // call TimerStart(t,3,true,function aaa)
        call StartTimerBJ(t,true,3)
        call TriggerRegisterTimerExpireEvent(tr,t)
        call TriggerAddAction(tr,function aaa)
    endfunction
    function test takes nothing returns nothing 
        local trigger tr = CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr,0)
        call TriggerAddAction(tr,function bbb)
    endfunction 
endlibrary 