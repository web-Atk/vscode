////up主 庞各庄大棚 jass基础-handle类型1  
library demo initializer test 
    function aaa takes nothing returns nothing 
        local item it = GetManipulatedItem() 
        call BJDebugMsg(GetItemName(it)) 
    endfunction 
    function bbb takes nothing returns boolean 
        local item it = GetManipulatedItem() 
        if GetItemTypeId(it) == 'ratf' then 
            return true 
        endif 
        return false 
    endfunction 
    function ddd takes nothing returns boolean
        local item it = GetFilterItem()
        return GetItemTypeId(it) == 'ratf'
    endfunction
    function ccc takes nothing returns nothing 
        local rect re = Rect(-500, -500, 500, 500) 
        local item it = RandomItemInRectBJ(re, Filter(function ddd)) 
        call BJDebugMsg(GetItemName(it)) 
    endfunction 
    function test takes nothing returns nothing 
        local trigger t = CreateTrigger() 
        local trigger t2 = CreateTrigger() 
        local filterfunc ff = Filter(function bbb) 
        local conditionfunc cf = Condition(function bbb) 
        call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM) 
        // call TriggerAddCondition(t,Condition(function bbb))  
        call TriggerAddCondition(t, Filter(function bbb)) 
        call TriggerAddAction(t, function aaa) 
        call TriggerRegisterPlayerChatEvent(t2, Player(0), "1", true) 
        call TriggerAddAction(t2, function ccc) 
    endfunction 
endlibrary 
