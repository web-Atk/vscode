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