//无敌斩
library AItest

    globals
        unit AIUnt = null
    endglobals

    function EnumRngUnit takes nothing returns nothing
        call BJDebugMsg(GetUnitName(GetTriggerUnit())) 
    endfunction

    function AIhero takes nothing returns nothing
        local trigger trg = CreateTrigger() 
        call TriggerRegisterUnitInRangeSimple(trg, 600, AIUnt)
        call TriggerAddAction(trg, function EnumRngUnit) 
    endfunction

endlibrary

library O

    globals 
        hashtable AbiHash = InitHashtable() 
        boolean CraftEventRegistered = false
        trigger CraftTrigger = null
    endglobals 

    // 检查单位背包中是否拥有指定物品
    function HasItemInInventory takes unit whichUnit, integer itemId returns boolean
        local integer i = 0
        local item it = null
        loop
            exitwhen i >= 6
            set it = UnitItemInSlot(whichUnit, i)
            if it != null and GetItemTypeId(it) == itemId then
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction

    // 删除单位背包中指定类型的物品
    function RemoveItemByType takes unit whichUnit, integer itemId returns nothing
        local integer i = 0
        local item it = null
        loop
            exitwhen i >= 6
            set it = UnitItemInSlot(whichUnit, i)
            if it != null and GetItemTypeId(it) == itemId then
                call RemoveItem(it)
                return
            endif
            set i = i + 1
        endloop
    endfunction

    // 执行合成逻辑，满足条件则消耗材料并生成结果物品
    function TryCraft takes unit whichUnit, integer recipeItem, integer inputA, integer inputB, integer inputC, integer outputItem returns nothing
        local item pickedItem = GetManipulatedItem()
        if whichUnit == null or pickedItem == null then
            return
        endif
        if GetItemTypeId(pickedItem) != recipeItem then
            return
        endif
        if not HasItemInInventory(whichUnit, inputA) then
            return
        endif
        if not HasItemInInventory(whichUnit, inputB) then
            return
        endif
        if inputC != 0 and not HasItemInInventory(whichUnit, inputC) then
            return
        endif
        call RemoveItemByType(whichUnit, recipeItem)
        call RemoveItemByType(whichUnit, inputA)
        call RemoveItemByType(whichUnit, inputB)
        if inputC != 0 then
            call RemoveItemByType(whichUnit, inputC)
        endif
        call UnitAddItem(whichUnit, CreateItem(outputItem, GetUnitX(whichUnit), GetUnitY(whichUnit)))
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", whichUnit, "origin"))
        set pickedItem = null
    endfunction


    // 物品拾取时执行合成判断
    function CraftOnPickup takes nothing returns nothing
        local unit u = GetTriggerUnit()
        if u != null then
            // 配方：吸血鬼节杖 + 风暴大剑 = 饮血剑
            call TryCraft(u, 'I006', 'I001', 'I004', 0, 'I007')
            // 配方：匕首 + 速度之靴 = 狂战士胫甲
            call TryCraft(u, 'I009', 'I005', 'I000', 0, 'I008')
            // 配方：黑皇杖 + 大剑 = 洛萨之锋
            call TryCraft(u, 'I00Z', 'I00X', 'I00C', 0, 'I00Y')
            // 配方：活力宝石 + 精气之球 + 能量宝石 = 振魂石
            call TryCraft(u, 'I00W', 'I00I', 'I00H', 'I00G', 'I00J')
            // 配方：鹰角弓 + 短棍 + 闪避护符 = 蝴蝶
            call TryCraft(u, 'I018', 'I014', 'I017', 'I016', 'I015')
        endif
        set u = null
    endfunction


    // 初始化合成触发器
    function InitCraftTrigger takes nothing returns nothing
        if CraftTrigger == null then
            set CraftTrigger = CreateTrigger()
            call TriggerAddAction(CraftTrigger, function CraftOnPickup)
        endif
    endfunction


    // 为指定单位注册合成拾取事件
    function RegisterCraftEventForUnit takes unit u0 returns nothing
        call InitCraftTrigger()
        if u0 != null and CraftTrigger != null then
            call TriggerRegisterUnitEvent(CraftTrigger, u0, EVENT_UNIT_PICKUP_ITEM)
        endif
    endfunction

    function SpellC takes nothing returns boolean
        if CraftEventRegistered == false then
            call InitCraftTrigger()
            set CraftEventRegistered = true
        endif
        if GetSpellAbilityId() == 'A00E' then 
            return true 
        else
            return false
        endif 
    endfunction

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
        local real damage = I2R(GetRandomInt(175, 250))
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
            call UnitDamageTarget(u0, u1, damage, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
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

    function LrnSkill takes unit u0 returns nothing 
        local trigger trg = CreateTrigger() 
        call TriggerRegisterUnitEvent(trg, u0, EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddCondition(trg, Condition(function SpellC)) 
        call TriggerAddAction(trg, function SpellA) 
        //排泄 
        set u0 = null 
        set trg = null 
    endfunction 


endlibrary