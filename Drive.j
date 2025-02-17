library IIA initializer init 

    globals 
        hashtable Hash = InitHashtable() 
        unit PlyHero 
    endglobals 

    function D2 takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local unit u0 = LoadUnitHandle(Hash,GetHandleId(tmr),0)
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local real speed = 300 / 50 //速率    
        local real ux3 
        local real uy4 
        local real angle = GetUnitFacing(u0)
        set ux3 = ux1 + speed * (CosBJ(angle)) 
        set uy4 = uy2 + speed * (SinBJ(angle)) 
        call SetUnitX(u0, ux3) 
        call SetUnitY(u0, uy4) 
    endfunction

    //前进档
    function D1 takes unit u0 returns nothing
        local timer tmr = LoadTimerHandle(Hash,GetHandleId(u0),0)  
        // call SetUnitAnimationByIndex(u0,3)   
        call SetUnitAnimation(u0,"walk")     
        call TimerStart(tmr,0.02,true,function D2)
        set tmr = null
    endfunction

    //一键启动
    function Start takes unit u0 returns nothing
        local real mp = GetUnitState(u0,UNIT_STATE_MANA)
        local integer i
        local timer tmr = LoadTimerHandle(Hash,GetHandleId(u0),0)  
        if mp > 0 then
            call SetUnitState(u0,UNIT_STATE_MANA,0)
            call PauseTimer(tmr)
        else
            call SetUnitState(u0,UNIT_STATE_MANA,900)
            set i = 0
            call SaveInteger(Hash,GetHandleId(u0),0,i)
        endif
        set tmr = null
    endfunction


    //施法登记
    function Spell takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u1 = GetSpellTargetUnit() 
        local integer ab0 = GetSpellAbilityId() 
        local integer aLv = GetUnitAbilityLevel(u0, ab0) 
        local real ax1 = GetSpellTargetX() 
        local real ay2 = GetSpellTargetY() 
        if ab0 == 'A000' then //一键启动    
          call Start(u0) 
        endif
        if ab0 == 'A001' then //前进档 
            call D1(u0) 
          endif
      endfunction 

    //初始化        
    function init takes nothing returns nothing 
        local unit u0            
        local trigger trg = CreateTrigger()
        local timer tmr = CreateTimer()  
        call FogEnableOff() 
        call FogMaskEnableOff() 
        set u0 = CreateUnit(Player(0), 'hmtt', -636.7, -341.6, 90) 
        call SelectUnitForPlayerSingle(u0, Player(0)) 
        call SetCameraTargetController(u0,0,0,false)
        set PlyHero = u0 
        call TriggerRegisterUnitEvent(trg, u0, EVENT_UNIT_SPELL_EFFECT)  
        call TriggerAddAction(trg, function Spell)  
        call SaveTimerHandle(Hash,GetHandleId(u0),0,tmr)  
        call SaveUnitHandle(Hash,GetHandleId(tmr),0,u0)    
        // call SaveInteger(Hash,GetHandleId(tmr),0,i)    
        // call UnitAddAbility(u0, 'A000')    
        // call UnitAddAbility(u0, 'A001')    
        // call UnitAddAbility(u0, 'A002')    
        // call UnitMakeAbilityPermanent(u0, true, 'A000')    
        // call UnitMakeAbilityPermanent(u0, true, 'A001')    
        // call UnitMakeAbilityPermanent(u0, true, 'A002')    
        // call TriggerRegisterPlayerKeyEventBJ(gg_trg____________________001, Player(0), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP)  
        // call TriggerRegisterPlayerKeyEventBJ(gg_trg____________________002, Player(0), bj_KEYEVENTTYPE_RELEASE, bj_KEYEVENTKEY_UP)
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