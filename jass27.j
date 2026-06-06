library demo initializer test
    function aaa takes nothing returns nothing
    endfunction
    
    function test takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterTimerEventSingle(t,1)
        call TriggerAddAction(t,function aaa)
        call FogEnable(false)
        call FogMaskEnable(false)
    endfunction
    
endlibrary
