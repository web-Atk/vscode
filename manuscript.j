//此乃写jass的草稿本 

//function IFF takes nothing returns boolean 
//    return ((IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE) == false) and (IsUnitInRangeXY(GetFilterUnit(),0,0,600)==true)) 
//endfunction 



library Frostarmor initializer frostarmor 

    globals 
        hashtable SkillHash = InitHashtable() 
        trigger trg_______u = CreateTrigger() 
        group g = CreateGroup() 
    endglobals 

    function Death takes nothing returns nothing 
        local unit u = GetTriggerUnit() 
        local trigger trg0 = LoadTriggerHandle(SkillHash, GetHandleId(u), 0) 
        local trigger trg1 = LoadTriggerHandle(SkillHash, GetHandleId(u), 1) 
        call DestroyTrigger(trg0) 
        call DestroyTrigger(trg1) 
        call GroupRemoveUnit(g, u) 
        //排泄 
        set u = null 
        set trg0 = null 
        set trg1 = null 
    endfunction 

    function JiZhong takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() //受伤单位 

    endfunction 

    //发射投射物 
    function FaShe takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() //受伤单位 
        local unit u2 //马甲 
        local unit u3 //单位组随机单位 
        local unit target 
        local player p = GetOwningPlayer(u0) 
        local real d0 = GetEventDamage() 
        local real x0 = GetUnitX(u0) 
        local real y0 = GetUnitY(u0) 
        local real angle_0 = GetUnitFacing(u0) 
        local group group_0 
        local group group_1 
        //local timer tmr  
        local trigger trg 
        local trigger trg0 
        if(GetUnitAbilityLevel(u0, 'BUfa') > 0) then 
            set group_0 = CreateGroup() 
            set u2 = CreateUnit(p, 'ewsp', x0, y0, angle_0) 
            call UnitApplyTimedLife(u2, 'BHwe', 1.00) 
            call ShowUnit(u2, false) 
            call SetUnitUserData(u2, 24) 
            call GroupEnumUnitsInRange(group_0, x0, y0, 600, null) 
            loop 
                set target = FirstOfGroup(group_0) 
                exitwhen target == null 
                if IsUnitEnemy(target, p) == true and GetUnitState(u0, UNIT_STATE_LIFE) > 0 and IsUnitInRangeXY(target, x0, y0, 500) and IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE) == false then 
                    set group_1 = CreateGroup() 
                    call GroupAddUnit(group_1, target) 
                endif 
                call GroupRemoveUnit(group_0, target) 
            endloop 
            call DestroyGroup(group_0) 
            set group_0 = null 
            set u3 = GroupPickRandomUnit(group_1) 
            call DestroyGroup(group_1) 
            set group_1 = null 
            if u3 != null then 
                set trg = CreateTrigger() 
                set trg0 = CreateTrigger() 
                call IssueTargetOrder(u2, "creepthunderbolt", u3) 
                if IsUnitInGroup(u3, g) == false then 
                    call GroupAddUnit(g, u3) 
                    call TriggerRegisterUnitEvent(trg, u3, EVENT_UNIT_DAMAGED) 
                    call TriggerAddAction(trg, function JiZhong) 
                    call SaveTriggerHandle(SkillHash, GetHandleId(u3), 0, trg) 
                    call TriggerRegisterUnitEvent(trg0, u3, EVENT_UNIT_DEATH) 
                    call TriggerAddAction(trg0, function Death) 
                    call SaveTriggerHandle(SkillHash, GetHandleId(u3), 1, trg) 
                endif 
          
            endif 
        endif 
        //排泄 
        set u0 = null 
        set u2 = null 
        set u3 = null 
        set trg = null 
        set trg0 = null 
    endfunction 

    //初始函数 
    function frostarmor takes nothing returns nothing 
        local unit u1 = CreateUnit(Player(0), 'Ulic', 0.00, 0.00, 0.00) 
        call FogEnable(false) 
        call FogMaskEnable(false) 
        call SetHeroLevel(u1, 2, false) 
        call SelectUnitForPlayerSingle(u1, Player(0)) 
        call TriggerRegisterUnitEvent(trg_______u, u1, EVENT_UNIT_DAMAGED) 
        call TriggerAddAction(trg_______u, function FaShe) 
        set u1 = null 
    endfunction 








endlibrary