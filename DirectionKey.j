library IIA initializer init 

    globals 
        hashtable Hash = InitHashtable() 
        unit PlyHero 
    endglobals 

    function TT takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local integer i = LoadInteger(Hash,GetHandleId(tmr),0)
        set i = i+1
        call SaveInteger(Hash,GetHandleId(tmr),0,i)
        call BJDebugMsg(I2S(i))
    endfunction

    //初始化        
    function init takes nothing returns nothing 
        local unit u0 
        local timer tmr =CreateTimer()
        local integer i = 0
        // local trigger Up = CreateTrigger()   
        // local trigger Down = CreateTrigger() 
        // local trigger Left = CreateTrigger()  
        // local trigger Right = CreateTrigger() 
        set u0 = CreateUnit(Player(0), 'Hpal', -636.7, -341.6, 270) 
        call FogEnableOff() 
        call FogMaskEnableOff() 
        call SelectUnitForPlayerSingle(u0, Player(0)) 
        set PlyHero = u0 
        call SaveInteger(Hash,GetHandleId(tmr),0,i)
        call TimerStart(tmr,1,true,function TT)
        // call UnitAddAbility(u0, 'A000')    
        // call UnitAddAbility(u0, 'A001')    
        // call UnitAddAbility(u0, 'A002')    
        // call UnitMakeAbilityPermanent(u0, true, 'A000')    
        // call UnitMakeAbilityPermanent(u0, true, 'A001')    
        // call UnitMakeAbilityPermanent(u0, true, 'A002')    
        // call TriggerRegisterUnitEvent(trg, u0, EVENT_UNIT_SPELL_EFFECT)  
        // call TriggerRegisterPlayerKeyEventBJ(gg_trg____________________001, Player(0), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP)  
        // call TriggerRegisterPlayerKeyEventBJ(gg_trg____________________002, Player(0), bj_KEYEVENTTYPE_RELEASE, bj_KEYEVENTKEY_UP)
        // call TriggerAddAction(trg, function Spell)    
        // call TriggerRegisterAnyUnitEventBJ(trg0, EVENT_PLAYER_UNIT_ATTACKED)    
        // call TriggerAddAction(trg0, function Attack)    
        // call BJDebugMsg(SubString("111111", 1, 5))
        // call TriggerRegisterPlayerSelectionEventBJ(gg_trg____________________004, Player(0), true)
        //排泄        
        set u0 = null 
        // set trg = null   
        // set trg0 = null   
    endfunction 

endlibrary