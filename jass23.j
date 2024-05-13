////up主 庞各庄大棚 jass基础-单位池和物品池    
library demo initializer test 
    globals 
        // unitpool up   
        integer array unitArr 
        real array weightArr 
        real r = 300 
    endglobals 
    function aaa takes nothing returns nothing 
        // call PlaceRandomUnit(up, Player(0), 0, 0, 0)   
        local real ran = GetRandomReal(0, r) 
        local unit u 
        local integer i = 0
        local integer j 
        call BJDebugMsg(R2S(ran)) 
        loop 
            exitwhen i == 3
            if ran <= weightArr[i] then
                set j = i
                set i = 3
                else
                    set i = i + 1 
            endif 
        endloop 
        set u = CreateUnit(Player(0),unitArr[j],0,0,0)
    endfunction 
    function test takes nothing returns nothing 
        local trigger t = CreateTrigger()   
        // set up = CreateUnitPool()   
        // call UnitPoolAddUnitType(up, 'hfoo', 180) //三个权重为100的物种加进单位池里，总权重就是300，每个种类的随机概率就是百分之三点三（3.3%）    
        // call UnitPoolAddUnitType(up, 'hgry', 20)   
        // call UnitPoolAddUnitType(up, 'hkni', 100)   
        call TriggerRegisterPlayerChatEvent(t, Player(0), "1", true) 
        call TriggerAddAction(t, function aaa) 
        set unitArr[0] = 'hfoo' 
        set unitArr[1] = 'hgry' 
        set unitArr[2] = 'hkni' 
        set weightArr[0] = 100 
        set weightArr[1] = 280 
        set weightArr[2] = 300 
    endfunction 
endlibrary 