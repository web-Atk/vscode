library AALib initializer init 

    globals
        hashtable HashSys = InitHashtable() 
        timer Timer_0
    endglobals

    function DetectionAOE2 takes nothing returns nothing
        
    endfunction

    function DetectionAOE1 takes unit u0, location pt, integer untid returns nothing 
        local unit array unt 
        local player ply = Player(PLAYER_NEUTRAL_AGGRESSIVE) 
        local trigger tgr = CreateTrigger()
        local real ax1 = GetLocationX(pt) 
        local real ay2 = GetLocationY(pt) 
        local real ax3 = ax1 + 64 * (CosBJ(90)) 
        local real ay4 = ay2 + 64 * (SinBJ(90)) 
        local real ax5
        local real ay6 
        local real rng
        local integer i = 0 
        loop 
            exitwhen i == 38
            set i = i + 1 
            set rng = 32*I2R(i)
            set ax5 = ax3 + rng * (CosBJ(90)) 
            set ay6 = ay4 + rng * (SinBJ(90)) 
            if IsTerrainPathable(ax5, ay6, PATHING_TYPE_FLYABILITY) == false then 
                set unt[i] = CreateUnit(ply, untid, ax3, ay4, 0) 
                call UnitAddAbility(unt[i],'Aro1')
                call UnitRemoveAbility(unt[i],'Aro1')
                call SetUnitPathing(unt[i],false)
                call SetUnitX(unt[i],ax5)
                call SetUnitY(unt[i],ay6)
                call TriggerRegisterUnitEvent(tgr,unt[i],EVENT_UNIT_DAMAGED)
                call TriggerAddAction(tgr,function DetectionAOE2)
            else 
                set i = 38
            endif 
            call BJDebugMsg(R2S(rng))
        endloop 
        //~  
        set u0 = null 
        set pt = null 
    endfunction 

    function Spell takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local integer ab0 = GetSpellAbilityId() 
        local location pt = GetUnitLoc(u0)
        local integer untid = 'hpea'
        if ab0 == 'A000' then  
            call DetectionAOE1(u0, pt, untid) 
        endif 
    endfunction 
    
    function init takes nothing returns nothing 
        local trigger tgr = CreateTrigger() 
        set udg_unit_0 = gg_unit_Hblm_0002
        call TriggerRegisterUnitEvent(tgr, udg_unit_0, EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddAction(tgr, function Spell) 
        //~               
        set tgr = null 
    endfunction 

endlibrary