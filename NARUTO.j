library LibA initializer init 
    globals 
        hashtable HashSys = InitHashtable() 
        unit array hero 
        force Olplys = CreateForce() //在线玩家组                    
        fogmodifier array vmd 
        fogmodifier array jdc 
    endglobals 

    //出生点      
    function SpawnPoint takes player ply returns location 
        local integer PlyIdx = GetPlayerId(ply) 
        local location pt 
        if PlyIdx == 1 or PlyIdx == 2 or PlyIdx == 3 then //玩家2、3、4出生点       
            // call SetUnitX(u0, -6126.8)       
            // call SetUnitY(u0, -6262.6)       
            set pt = Location(-6126.8, -6262.6) 
        endif 
        if PlyIdx == 5 or PlyIdx == 6 or PlyIdx == 7 then //玩家6、7、8出生点       
            // call SetUnitX(u0, 3506.0)       
            // call SetUnitY(u0, -6447.8)       
            set pt = Location(3506.0, -6447.8) 
        endif 
        if PlyIdx == 9 or PlyIdx == 10 or PlyIdx == 11 then //玩家10、11、12出生点       
            // call SetUnitX(u0, -1601.4)       
            // call SetUnitY(u0, 1319.8)       
            set pt = Location(-1601.4, 1319.8) 
        endif 
        return pt 
    endfunction 

    //复活    
    function Revive takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local integer TmrIdx = GetHandleId(tmr) 
        local unit u0 = LoadUnitHandle(HashSys, TmrIdx, 0) 
        local player ply0 = GetOwningPlayer(u0) 
        local location pt = SpawnPoint(ply0) 
        local real mp = GetUnitState(u0, UNIT_STATE_MAX_MANA) 
        call ReviveHeroLoc(u0, pt, true) 
        call SetUnitState(u0, UNIT_STATE_MANA, mp) 
        if GetLocalPlayer() == ply0 then 
            call PanCameraToTimed(GetLocationX(pt), GetLocationY(pt), 0.3) 
            call ClearSelection() 
            call SelectUnit(u0, true) 
        endif 
        call RemoveLocation(pt) 
        //~    
        set tmr = null 
        set u0 = null 
        set ply0 = null 
        set pt = null 
    endfunction 

    //死亡相关      
    function Death takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local player ply0 = GetOwningPlayer(u0) 
        local timer tmr = CreateTimer() 
        local integer TmrIdx = GetHandleId(tmr) 
        local string s = udg_Player_Colour[GetPlayerId(ply0)] 
        call SaveUnitHandle(HashSys, TmrIdx, 0, u0) 
        call TimerStart(tmr, 10, false, function Revive) 
        call DisplayTimedTextToPlayer(ply0, 0, 0, 2, ((s + GetPlayerName(ply0)) + " |r阵亡！10秒后复活")) 
        //~    
        set tmr = null 
        set u0 = null 
        set ply0 = null 
    endfunction 


    //选择英雄B       
    function SeltHeroB takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local player ply = LoadPlayerHandle(HashSys, GetHandleId(tmr), 0) 
        local integer PlyIdx = GetPlayerId(ply) 
        set hero[PlyIdx] = null 
        //~         
        set tmr = null 
        set ply = null 
    endfunction 

    //选择英雄A                    
    function SeltHeroA takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local player ply = GetTriggerPlayer() 
        local integer PlyIdx = GetPlayerId(ply) 
        local timer tmr 
        local trigger tgr 
        local location pt 
        if udg_PlyHero[PlyIdx] == null and GetOwningPlayer(u0) == Player(PLAYER_NEUTRAL_PASSIVE) and IsUnitType(u0, UNIT_TYPE_HERO) == true then 
            if u0 == hero[PlyIdx] then 
                call SetUnitOwner(u0, ply, true) 
                set udg_PlyHero[PlyIdx] = u0 
                call SetPlayerName(ply, GetPlayerName(ply) + "(" + GetUnitName(u0) + ")") 
                set tgr = CreateTrigger() 
                call TriggerRegisterUnitEvent(tgr, u0, EVENT_UNIT_DEATH) 
                call TriggerAddAction(tgr, function Death) 
                set pt = SpawnPoint(ply) 
                call SetUnitX(u0, GetLocationX(pt)) 
                call SetUnitY(u0, GetLocationY(pt)) 
                call UnitAddAbility(u0, 'AEbl') 
                call UnitMakeAbilityPermanent(u0, true, 'AEbl') 
                if GetLocalPlayer() == ply then 
                    call PanCameraToTimed(GetLocationX(pt), GetLocationY(pt), 0.3) 
                endif 
                call DestroyFogModifier(vmd[PlyIdx]) 
                call RemoveLocation(pt) 
            else 
                set hero[PlyIdx] = u0 
                set tmr = CreateTimer() 
                call SavePlayerHandle(HashSys, GetHandleId(tmr), 0, ply) 
                call TimerStart(tmr, 0.24, false, function SeltHeroB) 
                call DisplayTextToPlayer(ply, 0, 0, "您想选择|c00FFFF00" + GetUnitName(u0) + "|r吗？双击他吧！") 
            endif 

            
        endif 
        //~          
        set u0 = null 
        set ply = null 
        set tmr = null 
        set tgr = null 
        set pt = null 
    endfunction 

    // function Spawn1 takes nothing returns nothing
        
    // endfunction

    //刷兵       
    function Spawn takes nothing returns nothing 
        local timer tmr = GetExpiredTimer() 
        local integer Idx = GetHandleId(tmr) 
        local integer lp1 = 0 
        local unit array sdr 
        local real f0 = LoadReal(HashSys, Idx, 0) 
        set f0 = f0 + 0.5
        call SaveReal(HashSys, Idx, 0, f0) 
    
        if ModuloReal(f0, 15) == 0 then 
            call BJDebugMsg("第" + R2S(f0) + "秒发兵") 
            loop 
                exitwhen lp1 == 2 
                set lp1 = lp1 + 1 
                // set sdr[lp1] = CreateUnit(Player(0), 'hmil', 0, 0, 0)  
            endloop 
        endif 
    endfunction 

    //离线英雄分配
    function Control takes nothing returns nothing
        local player ply = GetEnumPlayer()
        local integer i = -1
        loop
            exitwhen i == 11
            set i = i+1
            if GetPlayerSlotState(ply) == PLAYER_SLOT_STATE_LEFT and IsPlayerAlly(ply,Player(i)) then
                call SetPlayerAlliance(ply,Player(i),ALLIANCE_SHARED_ADVANCED_CONTROL,true)
            endif
        endloop
        set ply = null //~
    endfunction


    //玩家离开 
    function Leaves takes nothing returns nothing 
        local player ply = GetTriggerPlayer() 
        local integer i = -1 
        call ForceRemovePlayer(Olplys,ply)
        call ForForce(Olplys,function Control)
        loop 
            exitwhen i == 11 
            set i = i + 1
            call DisplayTextToPlayer(Player(i),0,0,udg_Player_Colour[GetPlayerId(ply)] + GetPlayerName(ply) + "|r 离开了游戏")  
        endloop 
        set ply = null //~
    endfunction 

    //地图初始化                      
    function init takes nothing returns nothing 
        local player array plys 
        local integer i = -1 
        local trigger array tgr 
        local timer tmr = CreateTimer() 
        set tgr[1] = CreateTrigger() 
        set tgr[2] = CreateTrigger() 
        call SaveReal(HashSys, GetHandleId(tmr), 0, 0)
        call TimerStart(tmr, 0.5, true, function Spawn) 
        call SetTimeOfDay(12.00) 
        loop 
            exitwhen i == 11 
            set i = i + 1 
            set plys[i] = Player(i) 
            call SetPlayerState(plys[i], PLAYER_STATE_GIVES_BOUNTY, 1) 
            call TriggerRegisterPlayerEvent(tgr[2], plys[i], EVENT_PLAYER_LEAVE) 
            if GetPlayerController(plys[i]) == MAP_CONTROL_USER and GetPlayerSlotState(plys[i]) == PLAYER_SLOT_STATE_PLAYING then 
                set vmd[i] = CreateFogModifierRect(plys[i], FOG_OF_WAR_VISIBLE, gg_rct_East_Spawn_Viz, false, true) 
                set jdc[i] = CreateFogModifierRect(plys[i], FOG_OF_WAR_VISIBLE, gg_rct_jdc, false, false) 
                call ForceAddPlayer(Olplys, plys[i]) //加入在线玩家组                    
                call SetPlayerState(plys[i], PLAYER_STATE_RESOURCE_GOLD, 500) //初始资源                    
                call FogModifierStart(vmd[i]) //启动选择英雄区域可见度修改器                            
                // call FogModifierStart(jdc[i])                    
                call TriggerRegisterPlayerUnitEvent(tgr[1], plys[i], EVENT_PLAYER_UNIT_SELECTED, null) 
            endif 
            set plys[i] = null //~                                
        endloop 
        call TriggerAddAction(tgr[1], function SeltHeroA) 
        call TriggerAddAction(tgr[2], function Leaves) 
        //~  
        set tmr = null 
        set tgr[1] = null 
        set tgr[2] = null 
    endfunction 
endlibrary 
