function XPtraceBB takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local integer tmrId = GetHandleId(tmr)
        local unit caster = LoadUnitHandle(HashBre, tmrId, 0)
        local group projGroup = LoadGroupHandle(HashBre, tmrId, 1)
        local integer shot = LoadInteger(HashBre, tmrId, 3)
        local group aliveGroup = CreateGroup()
        local unit proj
        local unit target
        local integer projId
        local real projX
        local real projY
        local real targetX
        local real targetY
        local real angle
        local real targetAngle
        local real projNewX
        local real projNewY
        loop
            set proj = FirstOfGroup(projGroup)
            exitwhen proj == null
            call GroupRemoveUnit(projGroup, proj)
            set projId = GetHandleId(proj)
            set target = LoadUnitHandle(HashBre, projId, 0)
            set angle = LoadReal(HashBre, projId, 1)
            set projX = GetUnitX(proj)
            set projY = GetUnitY(proj)
            set targetX = GetUnitX(target)
            set targetY = GetUnitY(target)
            set targetAngle = Atan2(targetY - projY, targetX - projX)
            if Cos(targetAngle - angle) <= 1 and Cos(targetAngle - angle) >= 0.9 then
            else
                if Sin(targetAngle - angle) > 0 then
                    set angle = angle + GetRandomReal(0.03, 0.08)
                else
                    set angle = angle - GetRandomReal(0.03, 0.08)
                endif
            endif
            call SaveReal(HashBre, projId, 1, angle)
            if GetUnitState(proj, UNIT_STATE_LIFE) > 0 then
                set projNewX = projX + 15 * Cos(angle)
                set projNewY = projY + 15 * Sin(angle)
                call SetUnitX(proj, projNewX)
                call SetUnitY(proj, projNewY)
                call SetUnitFacing(proj, Rad2Deg(angle))
                call GroupAddUnit(aliveGroup, proj)
            else
                set shot = shot - 1
                call FlushChildHashtable(HashBre, projId)
                call RemoveUnit(proj)
            endif
            set proj = null
            set target = null
        endloop
        call GroupAddGroup(aliveGroup, projGroup)
        call SaveGroupHandle(HashBre, tmrId, 1, projGroup)
        call SaveInteger(HashBre, tmrId, 3, shot)
        call DestroyGroup(aliveGroup)
        if shot <= 0 then
            call FlushChildHashtable(HashBre, tmrId)
            call DestroyTimer(tmr)
        else
            call TimerStart(tmr, 0.02, false, function XPtraceBB)
        endif
        set caster = null
        set tmr = null
        set projGroup = null
        set aliveGroup = null
    endfunction

    function XPtraceAA takes unit u0, integer icUnt, real dmg, group ugp0 returns nothing 
        local unit u1
        local unit u2
        local player ply = GetOwningPlayer(u0)
        local group ugp1 = CreateGroup()
        local timer tmr = CreateTimer()
        local integer tmrId = GetHandleId(tmr)
        local integer unitId
        local integer i = 0
        local integer shot = 10
        local real cx = GetUnitX(u0)
        local real cy = GetUnitY(u0)
        local real ux
        local real uy
        local real tx
        local real ty
        local real angle

        local real array targetX
        local real array targetY
        local unit array target
        set i = 0
        loop
            exitwhen i == 10
            set i = i + 1
            set target[i] = GroupPickRandomUnit(ugp0)
            set targetX[i] = GetUnitX(target[i])
            set targetY[i] = GetUnitY(target[i])
        endloop
        set i = 0
        loop
            exitwhen i == 10
            set i = i + 1
            set angle = GetRandomReal(0, 2 * bj_PI)
            set ux = cx + 80 * Cos(angle)
            set uy = cy + 80 * Sin(angle)
            set u1 = CreateUnit(ply, icUnt, ux, uy, Rad2Deg(angle))
            set angle = Atan2(targetY[i] - uy, targetX[i] - ux)
            call UnitApplyTimedLife(u1, 'BHwe', 10)
            call GroupAddUnit(ugp1, u1)
            set unitId = GetHandleId(u1)
            call SaveUnitHandle(HashBre, unitId, 0, target[i])
            call SaveReal(HashBre, unitId, 1, angle)
            set u1 = null
            set u2 = null
        endloop
        call SaveUnitHandle(HashBre, tmrId, 0, u0)
        call SaveGroupHandle(HashBre, tmrId, 1, ugp1)
        call SaveReal(HashBre, tmrId, 2, dmg)
        call SaveInteger(HashBre, tmrId, 3, shot)
        call TimerStart(tmr, 0.02, false, function XPtraceBB)
        call DestroyGroup(ugp0)
        set ugp1 = null
        set tmr = null
        set u0 = null
    endfunction