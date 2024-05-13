library O initializer init 

    globals 
        hashtable AbiHash = InitHashtable() 
    endglobals 


    function SpellB takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local unit u0 = LoadUnitHandle(AbiHash, GetHandleId(tmr), 0) 
        local unit u2 = LoadUnitHandle(AbiHash, GetHandleId(tmr), 1) 
        local integer i0 = LoadInteger(AbiHash, GetHandleId(tmr), 2) 
        local effect eff = LoadEffectHandle(AbiHash, GetHandleId(tmr), 3) 
        local player p0 = GetOwningPlayer(u0) 
        local real ang = GetRandomReal(0, 360) 
        local unit target 
        local unit u1 
        local real ux0 = GetUnitX(u0) 
        local real uy0 = GetUnitY(u0) 
        local real ux1 
        local real uy1 
        local real ux2 
        local real uy2 
        local group ugp = CreateGroup() 
        local group ugp2 = CreateGroup() 
        set i0 = i0 - 1 
        call SaveInteger(AbiHash, GetHandleId(tmr), 2, i0) 
        call GroupEnumUnitsInRange(ugp, ux0, uy0, 600, null) 
        loop 
            set target = FirstOfGroup(ugp) 
            exitwhen target == null 
            if IsUnitEnemy(target, p0) == true and GetUnitState(target, UNIT_STATE_LIFE) > 0 and IsUnitInRangeXY(target, ux0, uy0, 500) == true and target != u2 then 
                call GroupAddUnit(ugp2, target) 
            endif 
            call GroupRemoveUnit(ugp, target) 
        endloop 
        call DestroyGroup(ugp) 
        set ugp = null 
        set u1 = GroupPickRandomUnit(ugp2) 
        call DestroyGroup(ugp2) 
        set ugp2 = null 
        if u1 != null then 
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", ux0, uy0)) 
            set ux1 = GetUnitX(u1) 
            set uy1 = GetUnitY(u1) 
            set ux2 = ux1 + 40 * (CosBJ(ang)) 
            set uy2 = uy1 + 40 * (SinBJ(ang)) 
            call SetUnitX(u0, ux2) 
            call SetUnitY(u0, uy2) 
            call IssueTargetOrder(u0, "attackone", u1) 
            call SaveUnitHandle(AbiHash, GetHandleId(tmr), 1, u1) 
        else 
            set i0 = 0 
        endif 
        if i0 <= 0 then 
            call DestroyEffect(eff) 
            call FlushChildHashtable(AbiHash, GetHandleId(tmr)) 
            call DestroyTimer(tmr) 
        endif 
    endfunction 


    function SpellA takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u1 = GetSpellTargetUnit() 
        local real ux0 = GetUnitX(u0) 
        local real uy0 = GetUnitY(u0) 
        local real ux1 = GetUnitX(u1) 
        local real uy1 = GetUnitY(u1) 
        local real ang = GetRandomReal(0, 360) 
        local real ux2 = ux1 + 40 * (CosBJ(ang)) 
        local real uy2 = uy1 + 40 * (SinBJ(ang)) 
        local effect eff = AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl", u0, "weapon") 
        local timer tmr = CreateTimer() 
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", ux0, uy0)) 
        call SetUnitX(u0, ux2) 
        call SetUnitY(u0, uy2) 
        call IssueTargetOrder(u0, "attackone", u1) 
        call TimerStart(tmr, 0.4, true, function SpellB) 
        call SaveUnitHandle(AbiHash, GetHandleId(tmr), 0, u0) 
        call SaveUnitHandle(AbiHash, GetHandleId(tmr), 1, u1) 
        call SaveInteger(AbiHash, GetHandleId(tmr), 2, 6) 
        call SaveEffectHandle(AbiHash, GetHandleId(tmr), 3, eff) 
    endfunction 

    function init takes nothing returns nothing 
        local unit u0 = CreateUnit(Player(0), 'Obla', -636.7, -341.6, 270) 
        local trigger trg = CreateTrigger() 
        call FogEnableOff() 
        call FogMaskEnableOff() 
        call SetHeroLevel(u0, 10, false) 
        call SelectUnitForPlayerSingle(u0, Player(0)) 
        call TriggerRegisterUnitEvent(trg, u0, EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddAction(trg, function SpellA) 
        //排泄 
        set u0 = null 
        set trg = null 
    endfunction 


endlibrary