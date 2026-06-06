//这是一张函数草拟图，并不完整，仅供参考
library Draft initializer init

    globals 
        hashtable SysHash = InitHashtable()
    endglobals 

    function StrafeAtkCmd takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u1 = LoadUnitHandle(SysHash, GetHandleId(u0), 0)
        local unit u2 = GetOrderTargetUnit()
        local real ax1 = GetOrderPointX()
        local real ay2 = GetOrderPointY()
        local integer array ordId
        set ordId[1] = OrderId("attack")
        set ordId[2] = OrderId("smart")
        set ordId[3] = OrderId("stop")
        if GetIssuedOrderId() == ordId[3] then
            call IssueImmediateOrder(u1,"stop")
        else
            if GetIssuedOrderId() == ordId[2] or GetIssuedOrderId() == ordId[1] then
                if u2 != null then
                    call IssueTargetOrder(u1,"attack", u2)
                else
                    if GetIssuedOrderId() == ordId[2] then
                        // call 
                    endif
                endif
            endif
        endif
        call BJDebugMsg(GetUnitName(u1))
        // call IssuePointOrder(u1,"attack", ax1, ay2)
    endfunction

    function StrafeMove takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local unit u0 = LoadUnitHandle(SysHash, GetHandleId(tmr), 0)
        local unit u1 = LoadUnitHandle(SysHash, GetHandleId(tmr), 1)
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
    endfunction

    //移动射击
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
        call TimerStart(tmr, 0.02, true, function StrafeMove)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_TARGET_ORDER)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_POINT_ORDER)
        call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_ISSUED_ORDER)
        call TriggerAddAction(tgr1, function StrafeAtkCmd)
    endfunction

    //初始化
    function init takes nothing returns nothing 
        local unit hero     
        call FogEnableOff() 
        call FogMaskEnableOff() 
        set hero = CreateUnit(Player(0), 'E000', -636.7, -341.6, 90) 
        call UnitAddItemByIdSwapped('ratf', hero)
        call UnitAddItemByIdSwapped('bgst', hero)
        call UnitAddItemByIdSwapped('hcun', hero)
        call UnitAddItemByIdSwapped('evtl', hero)
        call UnitAddItemByIdSwapped('bspd', hero)
        call UnitAddItemByIdSwapped('rde1', hero)
        call Strafe(hero, 'E001', 'A000', 'Aro1')
       

        //排泄        
        set hero = null 
    endfunction 

endlibrary