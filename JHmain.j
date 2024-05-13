library JhLib 

    globals 
        hashtable HashBre = InitHashtable() 
        hashtable HashSys = InitHashtable() 
    endglobals 

    function XPtraceB takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local integer TmrAds = GetHandleId(GetExpiredTimer()) 
        local unit u0 = LoadUnitHandle(HashBre, TmrAds, 0) 
        local group ugp0 = LoadGroupHandle(HashBre, TmrAds, 1) 
        local real f0 = LoadReal(HashBre, TmrAds, 2) 
        local integer lv = LoadInteger(HashBre, TmrAds, 3) 
        local unit array u1 
        local unit array u2 
        local real array u1x 
        local real array u1y 
        local real array u2x 
        local real array u2y 
        local integer array UntAds 
        local player ply = GetOwningPlayer(u0) 
        local real array r0 //JD                   
        local real array r1 //JD02                   
        local real array r2 //XDJD                   
        local integer i = 0 
        local unit u4 
        local real f1 
        local real f2 
        local group ugp1 = CreateGroup() 
        loop 
            set u4 = FirstOfGroup(ugp0) 
            exitwhen u4 == null 
            set i = i + 1 
            set u1[i] = u4 
            set UntAds[i] = GetHandleId(u1[i]) 
            set u2[i] = LoadUnitHandle(HashBre, UntAds[i], 0) 
            set r0[i] = LoadReal(HashBre, UntAds[i], 1) 
            set u1x[i] = GetUnitX(u1[i]) 
            set u1y[i] = GetUnitY(u1[i]) 
            set u2x[i] = GetUnitX(u2[i]) 
            set u2y[i] = GetUnitY(u2[i]) 
            set r1[i] = Atan2(u2y[i] -u1y[i], u2x[i] -u1x[i]) 
            set r2[i] = r1[i] 
            if Cos(r2[i] -r0[i]) <= 1.0 and Cos(r2[i] -r0[i]) >= 0.9 then 
                call DoNothing() 
            else 
                if Sin(r2[i] -r0[i]) > 0.0 then 
                    set r0[i] = r0[i] + GetRandomReal(0.03, 0.08) 
                else 
                    set r0[i] = r0[i] -GetRandomReal(0.03, 0.08) 
                endif 
            endif 
            call SaveReal(HashBre, UntAds[i], 1, r0[i]) 
            if GetUnitState(u1[i], UNIT_STATE_LIFE) > 0 then 
                call GroupAddUnit(ugp1, u4) 
                set f1 = u1x[i] + 15 * (Cos(r0[i])) 
                set f2 = u1y[i] + 15 * (Sin(r0[i])) 
                call SetUnitX(u1[i], f1) 
                call SetUnitY(u1[i], f2) 
                call SetUnitFacing(u1[i], Rad2Deg(r0[i])) 
            else 
                set lv = lv - 1 
                call SaveInteger(HashBre, TmrAds, 3, lv) 
                call FlushChildHashtable(HashBre, UntAds[i]) 
            endif 
            //排泄             
            set u1[i] = null 
            set u2[i] = null 
            call GroupRemoveUnit(ugp0, u4) 
        endloop 
        call GroupAddGroup(ugp1, ugp0) 
        call SaveGroupHandle(HashBre, TmrAds, 1, ugp0) 
        if lv <= 0 then 
            set i = 0 
            loop 
                exitwhen i == 10 
                set i = i + 1 
                call RemoveUnit(u1[i]) 
            endloop 
            call FlushChildHashtable(HashBre, TmrAds) 
            call DestroyTimer(tmr) 
            call BJDebugMsg("计时器已删除") 
        else 
            call TimerStart(tmr, 0.02, false, function XPtraceB) 
        endif 
    endfunction 

    function XPtraceA takes unit u0, integer icUnt, real f0, group ugp0 returns nothing 
        local unit array u1 
        local unit array u2 
        local real array u1x 
        local real array u1y 
        local real array u2x 
        local real array u2y 
        local player ply = GetOwningPlayer(u0) 
        local real array r0 
        local real f1 = GetUnitX(u0) 
        local real f2 = GetUnitY(u0) 
        local integer i = 0 
        local integer lv 
        local real angle 
        local timer tmr = CreateTimer() 
        local group ugp1 = CreateGroup() 
        local integer array index 
        loop 
            exitwhen i == 10 
            set i = i + 1 
            set u2[i] = GroupPickRandomUnit(ugp0) 
            set u2x[i] = GetUnitX(u2[i]) 
            set u2y[i] = GetUnitY(u2[i]) 
        endloop 
        set i = 0 
        loop 
            exitwhen i == 10 
            set i = i + 1 
            set angle = GetRandomReal(0, 2 * 3.14159) 
            set u1x[i] = f1 + 80 * (Cos(angle)) 
            set u1y[i] = f2 + 80 * (Sin(angle)) 
            set u1[i] = CreateUnit(ply, icUnt, u1x[i], u1y[1], angle) 
            set r0[i] = Atan2(u2y[i] -u1y[i], u2x[i] -u1x[i]) 
            set index[0] = GetHandleId(tmr) 
            set index[1] = GetHandleId(u1[i]) 
            call UnitApplyTimedLife(u1[i], 'BHwe', 3) 
            call GroupAddUnit(ugp1, u1[i]) 
            call SaveUnitHandle(HashBre, index[1], 0, u1[i]) 
            call SaveReal(HashBre, index[1], 1, angle) 
            set lv = GetUnitLevel(u1[i]) 
            //排泄                       
            set u1[i] = null 
            set u2[i] = null 
        endloop 
        call SaveUnitHandle(HashBre, index[0], 0, u0) 
        call SaveGroupHandle(HashBre, index[0], 1, ugp1) 
        call SaveReal(HashBre, index[0], 2, f0) 
        call SaveInteger(HashBre, index[0], 3, lv) 
        call TimerStart(tmr, 0.02, false, function XPtraceB) 
        //排泄                        
        call DestroyGroup(ugp0) 
        set tmr = null 
        set ugp0 = null 
    endfunction 

    function SpellB takes nothing returns nothing 
        local integer index = GetHandleId(GetExpiredTimer()) 
        local location pt = LoadLocationHandle(HashSys, index, 0) 
        local group ugp = LoadGroupHandle(HashSys, index, 1) 
        local real ang = LoadReal(HashSys, index, 2) 
        local real Sale = LoadReal(HashSys, index, 3) 
        local real CD = LoadReal(HashSys, index, 4) 
        local real SD = LoadReal(HashSys, index, 5) 
        local real rng = LoadReal(HashSys, index, 6) 
        local real B = LoadReal(HashSys, index, 7) 
        local real ax1 = GetLocationX(pt) 
        local real ay2 = GetLocationY(pt) 
        local group ugp0 = CreateGroup() 
        local unit u2 
        local real f0 
        local real f1 
        local real f2 
        set Sale = Sale + 0.02 
        call BJDebugMsg(R2S(Sale)) 
        call SaveReal(HashSys, index, 3, Sale) 
        loop 
            set u2 = FirstOfGroup(ugp) 
            exitwhen u2 == null 
            set B = B + 1 
            call SaveReal(HashSys, index, 7, B) 
            set f1 = ax1 + rng * CosBJ(ang * B + SD * (Sale / 0.02)) 
            set f2 = ay2 + rng * SinBJ(ang * B + SD * (Sale / 0.02)) 
            call SetUnitX(u2, f1) 
            call SetUnitY(u2, f2) 
            call GroupRemoveUnit(ugp, u2) 
            call GroupAddUnit(ugp0, u2) 
            set u2 = null 
        endloop 
        call GroupAddGroup(ugp0, ugp) 
        if Sale == CD then 
            loop 
                set u2 = FirstOfGroup(ugp) 
                exitwhen u2 == null 
                call KillUnit(u2) 
                call GroupRemoveUnit(ugp, u2) 
                call RemoveUnit(u2) 
                set u2 = null 
            endloop 
            call RemoveLocation(pt) 
            call DestroyGroup(ugp) 
            call DestroyTimer(GetExpiredTimer()) 
        endif 
        //~ 
        call GroupClear(ugp0) 
        call DestroyGroup(ugp0) 
        set ugp = null 
    endfunction 

    function SpellA takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u2 
        local player ply = GetOwningPlayer(u0) 
        local group ugp = CreateGroup() 
        local timer tmr = CreateTimer() 
        local real ux1 = GetUnitX(u0) 
        local real uy2 = GetUnitY(u0) 
        local location pt = Location(ux1, uy2) 
        local real ux3 
        local real uy4 
        local real B = 0 
        local real Sale = 0 
        local real ang = 180 
        local real ang0 = GetUnitFacing(u0) 
        local real num = 2 
        local real CD = 10 
        local real SD = 10
        local real rng = 600 
        local real height = 73 
        local integer i = 0 
        local integer index = GetHandleId(tmr) 
        local real array f 
        loop 
            exitwhen i == 2 
            set i = i + 1 
            set f[0] = ang * I2R(i) 
            set ux3 = ux1 + rng * (CosBJ(f[0])) 
            set uy4 = uy2 + rng * (SinBJ(f[0])) 
            set u2 = CreateUnit(ply, 'hfoo', ux3, uy4, ang0 - (I2R(i) * 180)) 
            call UnitAddAbility(u2, 'Amrf') 
            call UnitRemoveAbility(u2, 'Amrf') 
            call SetUnitFlyHeight(u2, height, 0) 
            call UnitAddAbility(u2, 'Aloc') 
            call GroupAddUnit(ugp, u2) 
            call SetUnitX(u2, ux3) 
            call SetUnitY(u2, uy4) 
            set u2 = null 
        endloop 
        call SaveLocationHandle(HashSys, index, 0, pt) 
        call SaveGroupHandle(HashSys, index, 1, ugp) 
        call SaveReal(HashSys, index, 2, ang) 
        call SaveReal(HashSys, index, 3, Sale) 
        call SaveReal(HashSys, index, 4, CD) 
        call SaveReal(HashSys, index, 5, SD) 
        call SaveReal(HashSys, index, 6, rng) 
        call SaveReal(HashSys, index, 7, B) 
        call TimerStart(tmr, 0.02, true, function SpellB) 
        //~ 
        set ugp = null 
        set tmr = null 
        set pt = null 

    endfunction 

    function test takes unit u0 returns nothing 
        local trigger tgr = CreateTrigger() 
        call TriggerRegisterUnitEvent(tgr, u0, EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddAction(tgr, function SpellA) 
        //~           
        set u0 = null 
        set tgr = null 
    endfunction 
endlibrary 
