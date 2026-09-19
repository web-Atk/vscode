function Trig_DJKXJoo03Actions takes nothing returns nothing
    set udg_GYDJooA = 1
    loop
        exitwhen udg_GYDJooA > udg_GYDJooB
        // 初始选择那几个单位是否存活
        if ((IsUnitAliveBJ(udg_GYDJooKill[udg_GYDJooA]) == true)) then
            set udg_GYDJooAimX[udg_GYDJooA] = GetUnitX(udg_GYDJooKill[udg_GYDJooA])
            set udg_GYDJooAimY[udg_GYDJooA] = GetUnitY(udg_GYDJooKill[udg_GYDJooA])
        else
        endif
        // 弹幕马甲是否存活
        if ((IsUnitAliveBJ(udg_GYDJooMJ[udg_GYDJooA]) == true)) then
            set udg_GYDJooJD02[udg_GYDJooA] = Atan2((udg_GYDJooAimY[udg_GYDJooA] - udg_GYDJooY[udg_GYDJooA]), (udg_GYDJooAimX[udg_GYDJooA] - udg_GYDJooX[udg_GYDJooA]))
            set udg_GYDJooX[udg_GYDJooA] = GetUnitX(udg_GYDJooMJ[udg_GYDJooA])
            set udg_GYDJooY[udg_GYDJooA] = GetUnitY(udg_GYDJooMJ[udg_GYDJooA])
            set udg_GYDJooXDJD[udg_GYDJooA] = udg_GYDJooJD02[udg_GYDJooA]
            // 应该是判断弹幕轨迹的if
            if (((Cos((udg_GYDJooXDJD[udg_GYDJooA] - udg_GYDJooJD[udg_GYDJooA])) <= 1.00) and (Cos((udg_GYDJooXDJD[udg_GYDJooA] - udg_GYDJooJD[udg_GYDJooA])) >= 0.90))) then
            else
                if ((Sin((udg_GYDJooXDJD[udg_GYDJooA] - udg_GYDJooJD[udg_GYDJooA])) > 0.00)) then
                    set udg_GYDJooJD[udg_GYDJooA] = (udg_GYDJooJD[udg_GYDJooA] + GetRandomReal(0.03, 0.08))
                else
                    set udg_GYDJooJD[udg_GYDJooA] = (udg_GYDJooJD[udg_GYDJooA] - GetRandomReal(0.03, 0.08))
                endif
            endif
            // 应该是判断弹幕已经接近目标后的命中
            if ((11 < 0)) then
                if ((IsUnitAliveBJ(udg_GYDJooKill[udg_GYDJooA]) == true)) then
                    set udg_GYDJooDian[0] = GetUnitLoc(udg_GYDJooKill[udg_GYDJooA])
                    call RemoveLocation(udg_GYDJooDian[0])
                    call UnitDamageTarget(udg_GYDJooBR, udg_GYDJooKill[udg_GYDJooA], udg_GYDJooFucK, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                    call AddSpecialEffectTargetUnitBJ("origin", udg_GYDJooKill[udg_GYDJooA], "Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
                    call DestroyEffect(GetLastCreatedEffectBJ())
                else
                endif
                call RemoveUnit(udg_GYDJooMJ[udg_GYDJooA])
                set udg_GYDJooC = (udg_GYDJooC - 1)
                call GroupRemoveUnitSimple(udg_GYDJooMJ[udg_GYDJooA], udg_GYDJooMJS)
            else
                call SetUnitX(udg_GYDJooMJ[udg_GYDJooA], (udg_GYDJooX[udg_GYDJooA] + (15.00 * Cos(udg_GYDJooJD[udg_GYDJooA]))))
                call SetUnitY(udg_GYDJooMJ[udg_GYDJooA], (udg_GYDJooY[udg_GYDJooA] + (15.00 * Sin(udg_GYDJooJD[udg_GYDJooA]))))
                call SetUnitFacing(udg_GYDJooMJ[udg_GYDJooA], Rad2Deg(udg_GYDJooJD[udg_GYDJooA]))
            endif
        else
        endif
        set udg_GYDJooA = udg_GYDJooA + 1
    endloop
    // 判断是否继续运行
    if (((udg_GYDJooC <= 0) or (CountUnitsInGroup(udg_GYDJooMJS) == 0))) then
        set udg_GYDJooA = 1
        loop
            exitwhen udg_GYDJooA > udg_GYDJooB
            call RemoveUnit(udg_GYDJooMJ[udg_GYDJooA])
            set udg_GYDJooJD[udg_GYDJooA] = 0.00
            set udg_GYDJooJD02[udg_GYDJooA] = 0.00
            set udg_GYDJooXDJD[udg_GYDJooA] = 0.00
            set udg_GYDJooA = udg_GYDJooA + 1
        endloop
        call GroupClear(udg_GYDJooMJS)
    else
        call StartTimerBJ(udg_GYDJooJS, false, 0.02)
    endif
endfunction

//===========================================================================
function InitTrig_DJKXJoo03 takes nothing returns nothing
    set gg_trg_DJKXJoo03 = CreateTrigger()
#ifdef DEBUG
    call YDWESaveTriggerName(gg_trg_DJKXJoo03, "DJKXJoo03")
#endif
    call TriggerRegisterTimerExpireEvent(gg_trg_DJKXJoo03, udg_GYDJooJS)
    call TriggerAddAction(gg_trg_DJKXJoo03, function Trig_DJKXJoo03Actions)
endfunction




function Trig_DJKXJoo02Conditions takes nothing returns boolean
    return ((GetSpellAbilityId() == 'A002'))
endfunction

function Trig_DJKXJoo02Func011002003 takes nothing returns boolean
    return (((IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) == false) and ((IsUnitAliveBJ(GetFilterUnit()) == true) and ((IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false) and ((IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(GetTriggerUnit())) == true) and (IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) == false))))))
endfunction

function Trig_DJKXJoo02Actions takes nothing returns nothing
    set udg_GYDJooA = 0
    set udg_GYDJooB = 10
    set udg_GYDJooC = 10
    set udg_GYDJooBR = GetTriggerUnit()
    set udg_GYDJooFucK = ((0.00 + (GetRandomReal(10.00, 20.00) * I2R(GetUnitAbilityLevelSwapped('A002', GetTriggerUnit())))) + ((0.60 * I2R(GetHeroStatBJ(bj_HEROSTAT_INT, GetTriggerUnit(), true))) + ((0.20 * I2R(GetHeroStatBJ(bj_HEROSTAT_STR, GetTriggerUnit(), true))) + (0.20 * I2R(GetHeroStatBJ(bj_HEROSTAT_AGI, GetTriggerUnit(), true))))))
    set udg_GYDJooX[0] = GetUnitX(udg_GYDJooBR)
    set udg_GYDJooY[0] = GetUnitY(udg_GYDJooBR)
    // 抽选单位
    set udg_GYDJooDian[1] = GetUnitLoc(GetTriggerUnit())
    set udg_GYDJooAimS = GetUnitsInRangeOfLocMatching(750.00, udg_GYDJooDian[1], Condition(function Trig_DJKXJoo02Func011002003))
    if ((CountUnitsInGroup(udg_GYDJooAimS) >= 1)) then
        set udg_GYDJooA = 1
        loop
            exitwhen udg_GYDJooA > udg_GYDJooB
            set udg_GYDJooKill[udg_GYDJooA] = GroupPickRandomUnit(udg_GYDJooAimS)
            set udg_GYDJooAimX[udg_GYDJooA] = GetUnitX(udg_GYDJooKill[udg_GYDJooA])
            set udg_GYDJooAimY[udg_GYDJooA] = GetUnitY(udg_GYDJooKill[udg_GYDJooA])
            set udg_GYDJooA = udg_GYDJooA + 1
        endloop
    else
        set udg_GYDJooA = 1
        loop
            exitwhen udg_GYDJooA > udg_GYDJooB
            set udg_GYDJooKill[udg_GYDJooA] = null
            set udg_GYDJooAimX[udg_GYDJooA] = udg_GYDJooX[0]
            set udg_GYDJooAimY[udg_GYDJooA] = udg_GYDJooY[0]
            set udg_GYDJooA = udg_GYDJooA + 1
        endloop
    endif
    call RemoveLocation(udg_GYDJooDian[1])
    // 创建计时器
    call StartTimerBJ(udg_GYDJooJS, false, 0.02)
    set udg_GYDJooA = 1
    loop
        exitwhen udg_GYDJooA > udg_GYDJooB
        call RemoveUnit(udg_GYDJooMJ[udg_GYDJooA])
        set udg_GYDJooA = udg_GYDJooA + 1
    endloop
    call GroupClear(udg_GYDJooMJS)
    set udg_GYDJooA = 1
    loop
        exitwhen udg_GYDJooA > udg_GYDJooB
        set udg_GYDJooJD[udg_GYDJooA] = GetRandomReal(0, (2.00 * bj_PI))
        set udg_GYDJooDian[0] = Location((udg_GYDJooX[0] + (80.00 * Cos(udg_GYDJooJD[udg_GYDJooA]))), (udg_GYDJooY[0] + (80.00 * Sin(udg_GYDJooX[udg_GYDJooA]))))
        call CreateNUnitsAtLoc(1, 'e004', GetOwningPlayer(udg_GYDJooBR), udg_GYDJooDian[0], Rad2Deg(udg_GYDJooJD[udg_GYDJooA]))
        call UnitApplyTimedLifeBJ(10.00, 'BHwe', GetLastCreatedUnit())
        call GroupAddUnitSimple(GetLastCreatedUnit(), udg_GYDJooMJS)
        set udg_GYDJooMJ[udg_GYDJooA] = GetLastCreatedUnit()
        set udg_GYDJooX[udg_GYDJooA] = GetUnitX(udg_GYDJooMJ[udg_GYDJooA])
        set udg_GYDJooY[udg_GYDJooA] = GetUnitY(udg_GYDJooMJ[udg_GYDJooA])
        set udg_GYDJooJD02[udg_GYDJooA] = Atan2((udg_GYDJooAimY[udg_GYDJooA] - udg_GYDJooY[udg_GYDJooA]), (udg_GYDJooAimX[udg_GYDJooA] - udg_GYDJooX[udg_GYDJooA]))
        call RemoveLocation(udg_GYDJooDian[0])
        set udg_GYDJooA = udg_GYDJooA + 1
    endloop
    call DestroyGroup(udg_GYDJooAimS)
endfunction

//===========================================================================
function InitTrig_DJKXJoo02 takes nothing returns nothing
    set gg_trg_DJKXJoo02 = CreateTrigger()
#ifdef DEBUG
    call YDWESaveTriggerName(gg_trg_DJKXJoo02, "DJKXJoo02")
#endif
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DJKXJoo02, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_DJKXJoo02, Condition(function Trig_DJKXJoo02Conditions))
    call TriggerAddAction(gg_trg_DJKXJoo02, function Trig_DJKXJoo02Actions)
endfunction

