//up主 ギ泠神ジ 魔兽地图编辑器Jass从萌新到大佬（四） 
library test initializer abc 
    globals 
        trigger trg_Chet = CreateTrigger() 
        trigger trg_AbilityEffect = CreateTrigger() 
        trigger trg_UseItem = CreateTrigger() 
        unit array hero 
    endglobals 

    private function Action_HG takes nothing returns nothing 
        local player wj = GetTriggerPlayer() 
        local unit u = hero[GetConvertedPlayerId(wj)] 
        call SetUnitPosition(u, 0.00, 0.00) 
        set u = null 
        set wj = null 
    endfunction 
    private function Action_Ability takes nothing returns nothing 
        local unit u = GetTriggerUnit() 
        local integer abilityId = GetSpellAbilityId() 
        local ability abilityE = GetSpellAbility() 
        if abilityId == 'AHds' then 
            call BJDebugMsg("你释放了神圣护甲！！！") 
        endif 
        set abilityE = null 
        set u = null 
    endfunction 
    private function Action_UseItem takes nothing returns nothing 
        local unit u = GetTriggerUnit() 
        local item wp = GetManipulatedItem() 
        local integer itemId = GetItemTypeId(wp) 
        if itemId == 'pnvu' then 
            call BJDebugMsg("你使用了无敌药水！") 
        endif 
        set wp = null 
        set u = null 
    endfunction 

    function I2U takes integer i returns unit 
        call SaveFogStateHandle(ht, 0, i, ConvertFogState(i)) 
        //call SetUnitState 
        return LoadUnitHandle(ht, 0, i) 
    endfunction 

    private function abc takes nothing returns nothing 
        local integer i = 1 
        local integer uid 
        set hero[1] = CreateUnit(ConvertedPlayer(1), 'Hpal', 0.00, 0.00, 270.00) 
        set uid = GetHandleId(hero[1]) 
        loop 
            exitwhen i > 12 
            call TriggerRegisterPlayerChatEvent(trg_Chet, ConvertedPlayer(i), "hg", false) 
            set i = i + 1 
        endloop 
        call TriggerAddAction(trg_Chet, function Action_HG) 
        call TriggerRegisterUnitEvent(trg_AbilityEffect, hero[1], EVENT_UNIT_SPELL_EFFECT) 
        call TriggerAddAction(trg_AbilityEffect, function Action_Ability) 
        call TriggerRegisterAnyUnitEventBJ(trg_UseItem, EVENT_PLAYER_UNIT_USE_ITEM) 
        call TriggerAddAction(trg_UseItem, function Action_UseItem) 
        call BJDebugMsg(GetUnitName(I2U(uid))) 
    endfunction 
endlibrary 


library test1 
    globals 
        hashtable ht = InitHashtable() 
    endglobals 
    private function abc takes nothing returns nothing 
    endfunction 
endlibrary 
