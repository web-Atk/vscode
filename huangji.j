library A initializer init 

    globals 
        hashtable HashSkill = InitHashtable() 
        group ugp0 = CreateGroup() 
    endglobals 

    //======================================================================         
    //流沙移行         
    function displacement takes nothing returns nothing 
        local timer tmr0 = GetExpiredTimer() 
        local unit u0 = LoadUnitHandle(HashSkill, GetHandleId(tmr0), 0) 
        local unit u1 = LoadUnitHandle(HashSkill, GetHandleId(tmr0), 1) 
        local location pt = LoadLocationHandle(HashSkill, GetHandleId(tmr0), 1) 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local real ux3 = GetUnitX(u1) 
        local real uy4 = GetUnitY(u1) 
        local real ux5 
        local real uy6 
        local real rng = SquareRoot(Pow(ux1 - ux3, 2.00) + Pow(uy2 - uy4, 2.00)) 
        local real angle = bj_RADTODEG * Atan2(uy4 - uy2, ux3 - ux1) //技能释放方向   
        if u1 == null then 
            set ux3 = GetLocationX(pt) 
            set uy4 = GetLocationY(pt) 
            set rng = SquareRoot(Pow(ux1 - ux3, 2.00) + Pow(uy2 - uy4, 2.00)) 
            set angle = bj_RADTODEG * Atan2(uy4 - uy2, ux3 - ux1) 
        endif 
        if rng <= 30 then 
            call SetUnitX(u0, ux3) 
            call SetUnitY(u0, uy4) 
            if GetUnitTypeId(u0) == 'hfoo' then 
                call ResetUnitAnimation(u0) 
            endif 
            call RemoveLocation(pt) 
            call FlushChildHashtable(HashSkill, GetHandleId(tmr0)) 
            call DestroyTimer(tmr0) 
        else 
            set ux5 = ux1 + 30 * (CosBJ(angle)) 
            set uy6 = uy2 + 30 * (SinBJ(angle)) 
            call SetUnitX(u0, ux5) 
            call SetUnitY(u0, uy6) 
        endif 
        call SetUnitFacing(u0, angle) 
        set tmr0 = null 
        set u0 = null 
        set u1 = null 
        set pt = null 
    endfunction 

    //E流沙移形         
    function transposal takes unit u0, real ax1, real ay2 returns nothing 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local real ux3 
        local real uy4 
        local real rng 
        local real r1 = 999999 
        local integer i0 = LoadInteger(HashSkill, GetHandleId(ugp0), 0) 
        local group ugp = CreateGroup() 
        local unit target 
        local unit u2 
        local timer tmr1 
        if i0 > 0 then 
            call GroupAddGroup(ugp0, ugp) 
            loop 
                set target = FirstOfGroup(ugp) 
                exitwhen target == null 
                set ux3 = GetUnitX(target) 
                set uy4 = GetUnitY(target) 
                set rng = SquareRoot(Pow(ax1 - ux3, 2.00) + Pow(ay2 - uy4, 2.00)) //两个坐标的距离    
                if rng < r1 then 
                    set r1 = rng 
                    set u2 = target 
                endif 
                call GroupRemoveUnit(ugp, target) 
            endloop 
            set tmr1 = CreateTimer() 
            call TimerStart(tmr1, 0.02, true, function displacement) 
            call SaveUnitHandle(HashSkill, GetHandleId(tmr1), 0, u0) 
            call SaveUnitHandle(HashSkill, GetHandleId(tmr1), 1, u2) 
            //call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",u2,"overhead")) //测试特效         
            call DestroyGroup(ugp) 
            set u2 = null 
            set target = null 
        else 
        endif 
        set u0 = null 
        set tmr1 = null 
        
    endfunction 
    
    //攻击触发         
    function Attack takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u1 = GetAttacker() 
        local unit target 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local group ugp = CreateGroup() 
        call GroupAddGroup(ugp0, ugp) 
        if GetUnitTypeId(u1) == 'Hamg' then 
            loop 
                set target = FirstOfGroup(ugp) 
                exitwhen target == null 
                if IsUnitInRangeXY(u0, ux1, uy2, 125) then 
                    call IssueTargetOrder(target, "attackonce", u0) 
                endif 
                call GroupRemoveUnit(ugp, target) 
            endloop 
        endif 
        call DestroyGroup(ugp) 
        set u0 = null 
        set u1 = null 
        set target = null 
    endfunction 

    //沙兵连接         
    function soldierB takes nothing returns nothing 
        local timer tmr0 = GetExpiredTimer() 
        local unit u0 = LoadUnitHandle(HashSkill, GetHandleId(tmr0), 0) 
        local unit u1 = LoadUnitHandle(HashSkill, GetHandleId(tmr0), 1) 
        local lightning scLig = LoadLightningHandle(HashSkill, GetHandleId(tmr0), 2) 
        local real f0 = LoadReal(HashSkill, GetHandleId(tmr0), 3) 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local real ux3 = GetUnitX(u1) 
        local real uy4 = GetUnitY(u1) 
        local integer i0 = LoadInteger(HashSkill, GetHandleId(ugp0), 0) 
        local boolean b0 = false 
        local real rng = SquareRoot(Pow(ux1 - ux3, 2.00) + Pow(uy2 - uy4, 2.00)) 
        set f0 = f0 + 0.02
        call SaveReal(HashSkill, GetHandleId(tmr0), 3, f0)  
        // call BJDebugMsg("相隔距离："+R2S(rng))         
        if rng >= 600 then 
            call IssueImmediateOrder(u1, "stop") 
        endif 
        if IsUnitInRangeXY(u0, ux3, uy4, 1000) == false or f0 == 10 then 
            call KillUnit(u1) 
            call RemoveUnit(u1)
            call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl",ux3,uy4)) 
        endif 
        if(GetUnitState(u0, UNIT_STATE_LIFE) > 0) and(GetUnitState(u1, UNIT_STATE_LIFE) > 0) then 
            call DoNothing() 
        else 
            call DestroyLightning(scLig) 
            call GroupRemoveUnit(ugp0, u1) 
            call SaveInteger(HashSkill, GetHandleId(ugp0), 0, i0 - 1) 
            call FlushChildHashtable(HashSkill, GetHandleId(tmr0)) 
            call DestroyTimer(tmr0) 
            set b0 = true 
        endif 
        if b0 == false then 
            call MoveLightningEx(scLig, false, ux1, uy2, 50, ux3, uy4, 50) 
        endif 
        set u0 = null 
        set u1 = null 
        set tmr0 = null 
    endfunction 

    //W沙兵现身         
    function soldierA takes unit u0, real ax1, real ay2, real ang returns nothing 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local player p0 = GetOwningPlayer(u0) 
        local unit u1 = CreateUnit(p0, 'hfoo', ax1, ay2, ang) 
        local real ux3 = GetUnitX(u1) 
        local real uy4 = GetUnitY(u1) 
        local integer i0 = LoadInteger(HashSkill, GetHandleId(ugp0), 0) 
        local timer tmr0 = CreateTimer() 
        local lightning scLig = AddLightningEx("DRAM", false, ux1, uy2, 50, ux3, uy4, 50) 
        call UnitAddAbility(u1, 'Aro1') 
        call UnitRemoveAbility(u1, 'Aro1') 
        call UnitAddAbility(u1, 'Apiv') 
        call GroupAddUnit(ugp0, u1) 
        call TimerStart(tmr0, 0.02, true, function soldierB) 
        call SaveUnitHandle(HashSkill, GetHandleId(tmr0), 0, u0) 
        call SaveUnitHandle(HashSkill, GetHandleId(tmr0), 1, u1) 
        call SaveLightningHandle(HashSkill, GetHandleId(tmr0), 2, scLig) 
        call SaveReal(HashSkill, GetHandleId(tmr0), 3, 0) 
        call SaveInteger(HashSkill, GetHandleId(ugp0), 0, i0 + 1) 
        set u0 = null 
        set u1 = null 
        set tmr0 = null 
    endfunction 

    //狂沙冲刺         
    
    //Q狂沙猛攻         
    function onslaught takes unit u0, real ax1, real ay2 returns nothing 
        local real ux1 
        local real uy2 
        local location pt = Location(ax1, ay2) 
        local group ugp = CreateGroup() 
        local unit target 
        local integer i0 = LoadInteger(HashSkill, GetHandleId(ugp0), 0) 
        local real angle 
        local timer tmr1 
        if i0 > 0 then 
            call GroupAddGroup(ugp0, ugp) 
            loop 
                set target = FirstOfGroup(ugp) 
                exitwhen target == null 
                set ux1 = GetUnitX(target) 
                set uy2 = GetUnitY(target) 
                set angle = bj_RADTODEG * Atan2(ay2 - uy2, ax1 - ux1) //技能释放方向    
                call SetUnitFacing(target, angle) 
                set tmr1 = CreateTimer() 
                // call SetUnitAnimation(target,"walk")  
                call SetUnitAnimationByIndex(target, 1) 
                call SaveUnitHandle(HashSkill, GetHandleId(tmr1), 0, target) 
                call SaveLocationHandle(HashSkill, GetHandleId(tmr1), 1, pt) 
                // call SaveReal(HashSkill, GetHandleId(tmr1), 2, angle)    
                // call SaveInteger(HashSkill, GetHandleId(tmr1), 3, 3)    
                call TimerStart(tmr1, 0.02, true, function displacement) 
                call GroupRemoveUnit(ugp, target) 
            endloop 
            call DestroyGroup(ugp) 
            set target = null 
        endif 
        set pt = null 
    endfunction 
    //======================================================================         
    
    //技能登记         
    function Spell takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u1 = GetSpellTargetUnit() 
        local integer ab0 = GetSpellAbilityId() 
        local integer aLv = GetUnitAbilityLevel(u0, ab0) 
        local real ax1 = GetSpellTargetX() 
        local real ay2 = GetSpellTargetY() 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local real distance = SquareRoot(Pow(ux1 - ax1, 2) + Pow(uy2 - ay2, 2)) 
        local real ang = bj_RADTODEG * Atan2(ay2 - uy2, ax1 - ux1) //技能释放方向         
        if ab0 == 'A000' then //沙兵现身         
            call soldierA(u0, ax1, ay2, ang) 
        endif 
        if ab0 == 'A003' then //流沙移形         
            call transposal(u0, ax1, ay2) 
        endif 
        if ab0 == 'A002' then //狂沙猛攻         
            call onslaught(u0, ax1, ay2) 
        endif 
        set u0 = null 
        set u1 = null 

    endfunction 

    //初始化         
    function init takes nothing returns nothing 
        local unit u0 
        local trigger trg = CreateTrigger() 
        local trigger trg0 = CreateTrigger() 
        set u0 = CreateUnit(Player(0), 'Hamg', -636.7, -341.6, 270) 
        call FogEnableOff() 
        call FogMaskEnableOff() 
        call SelectUnitForPlayerSingle(u0, Player(0)) 
        call UnitAddAbility(u0, 'A000') 
        call UnitAddAbility(u0, 'A003') 
        call UnitAddAbility(u0, 'A002') 
        call UnitMakeAbilityPermanent(u0, true, 'A000') 
        call UnitMakeAbilityPermanent(u0, true, 'A003') 
        call UnitMakeAbilityPermanent(u0, true, 'A002') 
        call TriggerRegisterUnitEvent(trg, u0, EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddAction(trg, function Spell) 
        call TriggerRegisterAnyUnitEventBJ(trg0, EVENT_PLAYER_UNIT_ATTACKED) 
        call TriggerAddAction(trg0, function Attack) 
        //排泄         
        set u0 = null 
        set trg = null 
        set trg0 = null 
    endfunction 

endlibrary