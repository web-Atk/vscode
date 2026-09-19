//此乃废案函数存放处

//=============================================================================================================================
[Strafe]
title = "移动射击 <疾魔制作>"
description = "为 ${指定单位}绑定${马甲单位}实现移动射击，其使用${通魔}接收攻击指令，另外需要[暗夜精灵]-扎根可转向为TRUE的${技能}为马甲辅助技能"
comment = "注意：马甲为模型上半身；设主体[主动攻击范围]和马甲[攻击范围]数值一致；通魔模拟攻击按钮[X3.Y0]，需要0冷却0蓝耗，动作/施法持续时间为0，目标类型为单位或点目标，施法距离为攻击距离"
category = TC_YDST
[[.args]]
type = unit
default = "GetTriggerUnit"
[[.args]]
type = unitcode
[[.args]]
type = abilcode
[[.args]]
type = abilcode
//===============================================================================================================================

//------------------------------------移动射击<疾魔制作>--------------------------------------
    function StrafeAtkCmd takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u1 = LoadUnitHandle(SysHash, GetHandleId(u0), 0)
        local unit u2 = GetOrderTargetUnit()
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real ux3 = GetUnitX(u2)
        local real uy4 = GetUnitY(u2)
        local real ax1 = GetOrderPointX()
        local real ay2 = GetOrderPointY()
        local integer i = 0
        local unit tar
        local real range1
        local real range2
        local real range3
        local real angle
        local group ugp = CreateGroup()
        local integer array ordId
        set ordId[1] = OrderId("attack")
        set ordId[2] = OrderId("smart")
        set ordId[3] = OrderId("stop")
        if GetIssuedOrderId() == ordId[3] then//是否发出停止命令
            call IssueImmediateOrder(u1,"stop")
        else
            if GetIssuedOrderId() == ordId[2] or GetIssuedOrderId() == ordId[1] then//是否发出攻击命令或右键移动命令
                if u2 != null then//是否有目标单位
                    set range3 = SquareRoot(Pow(ux1 - ux3, 2.00) + Pow(uy2 - uy4, 2.00))
                    if range3 <= GetUnitDefaultAcquireRange(u0) then //如果目标单位在攻击范围内（待优化）
                        call IssueTargetOrder(u1,"attack", u2)
                        call IssueImmediateOrder(u0,"stop")
                    else
                        call IssueTargetOrder(u1,"attack", u2)
                        call IssueImmediateOrder(u0,"stop")
                    endif
                else
                    if GetIssuedOrderId() == ordId[2] then//判定为右键移动命令
                        set range1 = 700.00
                        set range2 = 600.00
                        set angle = bj_RADTODEG * Atan2(ay2 - uy2, ax1 - ux1)
                        call GroupEnumUnitsInRange(ugp, ux1, uy2, range1, null)
                        loop
                            set tar = FirstOfGroup(ugp)
                            exitwhen tar == null 
                            if IsUnitEnemy(tar, GetOwningPlayer(u0)) and IsUnitInRangeXY(tar, ux1, uy2, range2) == true and GetUnitState(tar, UNIT_STATE_LIFE) > 0 then
                                set i = i + 1
                            endif
                            call GroupRemoveUnit(ugp, tar)
                        endloop 
                        if i > 0 then
                            call DoNothing()
                        else
                            call SetUnitFacing(u1, angle)
                            call IssueImmediateOrder(u1,"stop")
                        endif
                    endif
                endif
            endif
        endif
        // call IssuePointOrder(u1,"attack", ax1, ay2)
    endfunction

    function StrafeMove takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local unit u0 = LoadUnitHandle(SysHash, GetHandleId(tmr), 0)
        local unit u1 = LoadUnitHandle(SysHash, GetHandleId(tmr), 1)
        local real time = LoadReal(SysHash, GetHandleId(tmr), 2)
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real uHgt1 = GetUnitFlyHeight(u0) 
        local real uHgt2 = GetUnitFlyHeight(u1) 
        local integer Str1 = GetHeroStr(u0, false)
        local integer Agi1 = GetHeroAgi(u0, false)
        local integer Int1 = GetHeroInt(u0, false)
        local integer Str2 = GetHeroStr(u1, false)
        local integer Agi2 = GetHeroAgi(u1, false)
        local integer Int2 = GetHeroInt(u1, false)
        call SetUnitX(u1, ux1)
        call SetUnitY(u1, uy2)
        if Str2 != Str1 then
            call SetHeroStr(u1, Str1, true)
        endif
        if Agi2 != Agi1 then
            call SetHeroAgi(u1, Agi1, true)
        endif
        if Int2 != Int1 then
            call SetHeroInt(u1, Int1, true)
        endif
        if uHgt2 != uHgt1 then
            call SetUnitFlyHeight(u1, uHgt1, 0)
        endif
        if IsUnitPaused(u0) == true then
            call PauseUnit(u1, true)
        else
            call PauseUnit(u1, false)
        endif
        if GetUnitState(u1, UNIT_STATE_LIFE) <= 0 then
            set time = time + 0.02
            call SaveReal(SysHash, GetHandleId(tmr), 2, time)
            if time >= 5 then
                call FlushChildHashtable(SysHash, GetHandleId(tmr))
                call FlushChildHashtable(SysHash, GetHandleId(u0))
                call DestroyTimer(tmr)
                call RemoveUnit(u1)
            endif
        else
            if GetUnitState(u0, UNIT_STATE_LIFE) <= 0 then
                call KillUnit(u1)
            endif
        endif
    endfunction

    //移动射击（单位、单位类型、技能类型、技能类型）
    function Strafe takes unit u0, integer icUnt, integer icAb1, integer icAb2 returns nothing
        local player ply = GetOwningPlayer(u0)
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real angle = GetUnitFacing(u0)
        local integer i = 0
        local integer lv = GetHeroLevel(u0)
        local integer exp = GetHeroXP(u0)
        local item array itms
        local integer array icItms
        local unit u1 = CreateUnit(ply, icUnt, ux1, uy2, angle)
        local timer tmr = CreateTimer()
        local trigger tgr1 = CreateTrigger()
        call UnitAddAbility(u0, icAb1)
        call UnitMakeAbilityPermanent(u0, true, icAb1)
        call UnitAddAbility(u0, 'Abun')
        call UnitMakeAbilityPermanent(u0, true, 'Abun')
        loop
            set itms[i] = UnitItemInSlot(u0, i)
            set icItms[i] = GetItemTypeId(itms[i])
            set itms[i] = CreateItem(icItms[i], GetUnitX(u1), GetUnitY(u1))
            call UnitAddItem(u1, itms[i])
            set i = i + 1
            exitwhen i >= 6
        endloop
        call UnitAddAbility(u1, 'Amrf') 
        call UnitRemoveAbility(u1, 'Amrf') 
        if lv > 1 then
            call SetHeroLevel(u1, lv, false)
        endif
        call SetHeroXP(u1, exp, false)
        call UnitAddAbility(u1, icAb2) 
        call UnitRemoveAbility(u1, icAb2) 
        call SaveUnitHandle(SysHash, GetHandleId(u0), 0, u1)
        call SaveUnitHandle(SysHash, GetHandleId(tmr), 0, u0)
        call SaveUnitHandle(SysHash, GetHandleId(tmr), 1, u1)
        call SaveReal(SysHash, GetHandleId(tmr), 2, 0)
        call TimerStart(tmr, 0.02, true, function StrafeMove)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_TARGET_ORDER)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_POINT_ORDER)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_ORDER)
        call TriggerAddAction(tgr1, function StrafeAtkCmd)
    endfunction

    //==================================================================================================================================