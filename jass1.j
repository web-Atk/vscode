#ifndef BJDebugMsg
#define BJDebugMsg BJDebugMsgInclude
library JhLib 

    
    function BJDebugMsgInclude takes string msg returns nothing
        local integer i = 0
        set msg = "老子是东山狼突营成乙"
        loop
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 60, msg)
            set i = i + 1
            exitwhen i == bj_MAX_PLAYERS
        endloop
    endfunction 

    function ABC takes code callback returns nothing
        local trigger tgr = CreateTrigger()
        call BJDebugMsg("111")
        call TriggerRegisterPlayerEventEndCinematic(tgr,Player(0))
        call TriggerAddAction(tgr,callback)
    endfunction
endlibrary  
#endif 

// UnitDamagePoint  
// UnitDamagePointLoc  

