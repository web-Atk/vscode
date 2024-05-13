library channel initializer init 

    globals 
        hashtable HashSys = InitHashtable() 
        timer tmr = CreateTimer() 
    endglobals 

    function Clock takes nothing returns string
        local real f0 = LoadReal(HashSys, GetHandleId(tmr), 0) 
        local real f1 = f0 / 60     
        local real f2 = ModuloReal(f0, 60) 
        local string array abs 
        set abs[0] = "00" 
        set abs[1] = R2S(f0) 
        set abs[2] = R2S(f1) 
        set abs[3] = R2S(f2) 
        if f0 >= 1 then 
            set abs[4] = "0" + SubString(abs[1], 0, 1) //十位0 + 个位 ，单位秒        
            set abs[5] = SubString(abs[1], 2, 4) //小数点后两位，单位微妙       
            set abs[6] = "|cff44e41c[" + abs[0] + ":" + abs[4] + ":" + abs[5] + "]:|r" 
            if f0 >= 10 then 
                set abs[4] = SubString(abs[1], 0, 2) //取十位 + 个位       
                set abs[5] = SubString(abs[1], 3, 5) //小数点后两位，单位微妙       
                set abs[6] = "|cff44e41c[" + abs[0] + ":" + abs[4] + ":" + abs[5] + "]:|r" 
                if f1 >= 1 then 
                    set abs[0] = "0" + SubString(abs[2], 0, 1) //十位0 + 个位 ，单位秒    
                    if f1 >= 10 then 
                        set abs[0] = SubString(abs[2], 0, 2) //取十位 + 个位     
                    endif 
                    if f2 >= 1 then 
                        set abs[4] = "0" + SubString(abs[3], 0, 1) //十位0 + 个位 ，单位秒   
                        set abs[5] = SubString(abs[3], 2, 4) //小数点后两位，单位微妙    
                        if f2 >= 10 then 
                            set abs[4] = SubString(abs[3], 0, 2) //取十位 + 个位   
                            set abs[5] = SubString(abs[3], 3, 5) //小数点后两位，单位微妙   
                        endif 
                    endif 
                    set abs[6] = "|cff44e41c[" + abs[0] + ":" + abs[4] + ":" + abs[5] + "]:|r" 
                endif 
            endif 
        else 
            set abs[5] = SubString(abs[1], 2, 4) //小数点后两位，单位微妙       
            set abs[6] = "|cff44e41c[" + abs[0] + ":" + abs[0] + ":" + abs[5] + "]:|r" 
        endif 
        return abs[6] 
    endfunction 

    function SpellE takes nothing returns nothing 
        local string array abs 
        local integer ab0 = GetSpellAbilityId() 
        set abs[0] = "|ce8da3838(" + GetAbilityName(ab0) + ")|r" 
        set abs[1] = "停止施法" 
        set abs[2] = Clock()
        set abs[3] = abs[2] + abs[1] + abs[0]
        call DisplayTextToPlayer(Player(0),0,0,abs[3])
    endfunction 

    function SpellD takes nothing returns nothing 
        local string array abs 
        local integer ab0 = GetSpellAbilityId() 
        set abs[0] = "|ce8da3838(" + GetAbilityName(ab0) + ")|r" 
        set abs[1] = "施法结束" 
        set abs[2] = Clock()
        set abs[3] = abs[2] + abs[1] + abs[0]
        call DisplayTextToPlayer(Player(0),0,0,abs[3])
    endfunction 

    function SpellC takes nothing returns nothing 
        local string array abs 
        local integer ab0 = GetSpellAbilityId() 
        set abs[0] = "|ce8da3838(" + GetAbilityName(ab0) + ")|r" 
        set abs[1] = "发动技能" 
        set abs[2] = Clock()
        set abs[3] = abs[2] + abs[1] + abs[0]
        call DisplayTextToPlayer(Player(0),0,0,abs[3])
    endfunction 

    function SpellB takes nothing returns nothing 
        local string array abs 
        local integer ab0 = GetSpellAbilityId() 
        set abs[0] = "|ce8da3838(" + GetAbilityName(ab0) + ")|r" 
        set abs[1] = "开始施法" 
        set abs[2] = Clock()
        set abs[3] = abs[2] + abs[1] + abs[0]
        call DisplayTextToPlayer(Player(0),0,0,abs[3])
    endfunction 

    function SpellA takes nothing returns nothing 
        local string array abs 
        local integer ab0 = GetSpellAbilityId() 
        set abs[0] = "|ce8da3838(" + GetAbilityName(ab0) + ")|r" 
        set abs[1] = "准备施法" 
        set abs[2] = Clock()
        set abs[3] = abs[2] + abs[1] + abs[0]
        call DisplayTextToPlayer(Player(0),0,0,abs[3])
    endfunction 


    function Playtime takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local real f = LoadReal(HashSys, GetHandleId(tmr), 0) 
        set f = f + 0.01 
        call SaveReal(HashSys, GetHandleId(tmr), 0, f) 
        set tmr = null 
    endfunction 

    function init takes nothing returns nothing 
        local trigger array tgr 
        local integer i = 0 
        loop 
            exitwhen i == 5 
            set i = i + 1 
            set tgr[i] = CreateTrigger() 
        endloop 
        call SaveReal(HashSys, GetHandleId(tmr), 0, 0) 
        call TimerStart(tmr, 0.01, true, function Playtime) 
        call TriggerRegisterAnyUnitEventBJ(tgr[1], EVENT_PLAYER_UNIT_SPELL_CHANNEL) //准备施法         
        call TriggerRegisterAnyUnitEventBJ(tgr[2], EVENT_PLAYER_UNIT_SPELL_CAST) //开始施法         
        call TriggerRegisterAnyUnitEventBJ(tgr[3], EVENT_PLAYER_UNIT_SPELL_EFFECT) //发动技能         
        call TriggerRegisterAnyUnitEventBJ(tgr[4], EVENT_PLAYER_UNIT_SPELL_FINISH) //施法结束         
        call TriggerRegisterAnyUnitEventBJ(tgr[5], EVENT_PLAYER_UNIT_SPELL_ENDCAST) //停止施法         
        call TriggerAddAction(tgr[1], function SpellA) 
        call TriggerAddAction(tgr[2], function SpellB) 
        call TriggerAddAction(tgr[3], function SpellC) 
        call TriggerAddAction(tgr[4], function SpellD) 
        call TriggerAddAction(tgr[5], function SpellE) 
        call FogEnable(false) 
        call FogMaskEnable(false) 
        //~
        set i = 0
        loop
            exitwhen i == 5 
            set i = i + 1 
            set tgr[i] = null
        endloop 
    endfunction 
endlibrary 
