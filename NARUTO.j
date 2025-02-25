library LibA initializer init 
    globals 
        hashtable HashSys = InitHashtable() 
        unit array hero 
        force Olplys = CreateForce() //在线玩家组                    
        fogmodifier array vmd 
        fogmodifier array jdc 
        unit array store 
        boolean wtf = false
        //装备合成素材
        string icItmA = "desc"
    endglobals 

    //指令-英雄升级
    function CmdLvup takes nothing returns nothing
        local player ply = GetTriggerPlayer()
        local unit u0 = udg_PlyHero[GetPlayerId(ply)]
        local string s1 = SubString(GetPlayerName(ply), 0, 9)
        local string s2
        local integer i
        if s1 == "WorldEdit" and u0 != null then
            set s2 = SubString(GetEventPlayerChatString(), 7, 9)
            set i = S2I(s2)
            if i <= 50 then
                call SetHeroLevel(u0, i, true)
            endif
        endif
        //~
        set u0 = null
        set ply = null
    endfunction

    //指令-获取金币
    function CmdGold takes nothing returns nothing
        local player ply = GetTriggerPlayer()
        local string s1 = SubString(GetPlayerName(ply), 0, 9)
        local string s2
        local integer i
        if s1 == "WorldEdit" then
            set s2 = SubString(GetEventPlayerChatString(), 6, 13)
            set i = S2I(s2)
            if i <= 1234567 then
                call SetPlayerState(ply, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(ply, PLAYER_STATE_RESOURCE_GOLD) + i)
            endif
        endif
        //~
        set ply = null
    endfunction

    //指令-无限火力
    function Wtf takes nothing returns nothing
        local player ply = GetTriggerPlayer()
        local string s1 = SubString(GetPlayerName(ply), 0, 9)
        if s1 == "WorldEdit" then
            if wtf == true then
                set wtf = false
                call DisplayTextToPlayer(ply, 0, 0, "WTF模式已经关闭。")
            else
                set wtf = true
                call DisplayTextToPlayer(ply, 0, 0, "WTF模式已经被激活。在这个模式下使用技能不需要消耗魔法并且没有冷却时间。")

            endif
        endif
    endfunction

    //清除CD
    function WtfCd takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local unit u0 = LoadUnitHandle(HashSys, GetHandleId(tmr), 0)
        call UnitResetCooldown(u0)
        call SetUnitState(u0, UNIT_STATE_MANA, GetUnitState(u0, UNIT_STATE_MAX_MANA))
        call DestroyTimer(tmr)
    endfunction

    //出售
    function Sell takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local integer icUnt = GetUnitTypeId(GetSoldUnit())
        local player ply = GetOwningPlayer(GetSoldUnit())
        // call BJDebugMsg("出售单位为：" + GetUnitName(u0))
    endfunction

    //招式名
    function Moves takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local real x0 = GetUnitX(u0)
        local real y0 = GetUnitY(u0)
        local string s = GetAbilityName(GetSpellAbilityId())
        local texttag ttg = CreateTextTag()
        local real vel = TextTagSpeed2Velocity(64)
        local real xvel = vel * Cos(90 * bj_DEGTORAD)
        local real yvel = vel * Sin(90 * bj_DEGTORAD)
        call SetTextTagText(ttg, s, 0.02)
        call SetTextTagPos(ttg, x0, y0, 0)
        call SetTextTagVelocity(ttg, xvel, yvel)
        call SetTextTagColor(ttg, 255, 255, 255, 255)
        call SetTextTagPermanent(ttg, false)
        call SetTextTagLifespan(ttg, 2.20)
        call SetTextTagVisibility(ttg, true)
        //~
        set ttg = null 
    endfunction

    //施法事件
    function Spell takes nothing returns nothing 
        local unit u0 = GetTriggerUnit() 
        local unit u1 = GetSpellTargetUnit() 
        local integer ab0 = GetSpellAbilityId() 
        local integer aLv = GetUnitAbilityLevel(u0, ab0) 
        local real ax1 = GetSpellTargetX() 
        local real ay2 = GetSpellTargetY() 
        local timer tmr
        if ab0 == 'A001' then //技能1    
            //   call JumpC(u0, ax1, ay2) 
        endif 
        if ab0 == 'A002' then //技能2 
            //   call WaveA(u0, ax1, ay2, aLv) 
        endif 
        if wtf == true then //wtf模式已开启
            set tmr = CreateTimer()
            call SaveUnitHandle(HashSys, GetHandleId(tmr), 0, u0)
            call TimerStart(tmr, 0, false, function WtfCd)
        endif
        //~
        set u0 = null
        set u1 = null 
        set tmr = null 
    endfunction 

    //出生点      
    function SpawnPoint takes player ply returns location 
        local integer PlyIdx = GetPlayerId(ply) 
        local location pt 
        if PlyIdx == 1 or PlyIdx == 2 or PlyIdx == 3 then //玩家2、3、4出生点       
            // call SetUnitX(u0, -6126.8)       
            // call SetUnitY(u0, -6262.6)       
            set pt = Location( - 6126.8, - 6262.6) 
        endif 
        if PlyIdx == 5 or PlyIdx == 6 or PlyIdx == 7 then //玩家6、7、8出生点       
            // call SetUnitX(u0, 3506.0)       
            // call SetUnitY(u0, -6447.8)       
            set pt = Location(3506.0, - 6447.8) 
        endif 
        if PlyIdx == 9 or PlyIdx == 10 or PlyIdx == 11 then //玩家10、11、12出生点       
            // call SetUnitX(u0, -1601.4)       
            // call SetUnitY(u0, 1319.8)       
            set pt = Location( - 1601.4, 1319.8) 
        endif 
        return pt 
    endfunction 


    // //选取单位做动作
    // function SelectUntJM takes unit u0, code callback returns nothing
        
    // endfunction

    //选取单位做动作(结构体)
    // struct SeleUnt 
    //     unit targetUnit
    //     code callback 

    //     method CallFun takes nothing returns nothing
    //         call callback(targetUnit)
    //     endmethod
    // endstruct

    //选取单位组做动作
    function ForGroupNew takes group ugp0, integer i returns nothing
        local unit target
        local group ugp1 = CreateGroup()
        call GroupAddGroup(ugp0, ugp1)
        loop
            set target = FirstOfGroup(ugp1)
            exitwhen target == null 
            if i == 1 then//爆炸而死
                call ExplodeUnitBJ(target)
            endif
            if i == 2 then//杀死删除
                call KillUnit(target)
                call RemoveUnit(target)
            endif
            call GroupRemoveUnit(ugp1, target) 
        endloop
        call DestroyGroup(ugp1)
    endfunction

    //失败动作2
    function Failure2 takes player ply returns nothing
        if ply == Player(0) then
            call CustomDefeatBJ(Player(1), "木叶忍者村被摧毁了！你们失败了！")
            call CustomDefeatBJ(Player(2), "木叶忍者村被摧毁了！你们失败了！")
            call CustomDefeatBJ(Player(3), "木叶忍者村被摧毁了！你们失败了！")
        endif
    endfunction

    //失败动作1
    function Failure1 takes player ply returns nothing
        local group ugp = CreateGroup() 
        local integer i = 0
        if ply == Player(0) then
            set i = 1
            call GroupEnumUnitsOfPlayer(ugp, Player(0), null)
            call ForGroupNew(ugp, i)
            call DisableTrigger(gg_trg_Spawn_Purple_North_1)
            call DisableTrigger(gg_trg_Spawn_Purple_north_2)
            call DisableTrigger(gg_trg_Spawn_Purple_East_1)
            call DisableTrigger(gg_trg_Spawn_purple_east_2)
            call DisableTrigger(gg_trg_Spawn_Purple_Middle_1)
            call DisableTrigger(gg_trg_Spawn_Purple_middle_2)
            call DisableTrigger(gg_trg_Spawn_Purple_middle_3)
            call Failure2(ply)
        endif
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
        local unit u1 = GetKillingUnit()
        local player ply0 = GetOwningPlayer(u0) 
        local player ply1 = GetOwningPlayer(u1)
        local integer lv = GetUnitLevel(u0)
        local integer i = - 1
        local timer tmr = null
        local integer TmrIdx 
        local string d = udg_Player_Colour[GetPlayerId(ply0)] 
        local string k = udg_Player_Colour[GetPlayerId(ply1)] 
        //英雄相关的死亡
        if IsUnitType(u0, UNIT_TYPE_HERO) == true then
            set tmr = CreateTimer() 
            set TmrIdx = GetHandleId(tmr) 
            call SaveUnitHandle(HashSys, TmrIdx, 0, u0) 
            call TimerStart(tmr, 10, false, function Revive) 
            call DisplayTimedTextToPlayer(ply0, 0, 0, 2,((d + GetPlayerName(ply0)) + " |r阵亡！10秒后复活")) 
            loop
                exitwhen i == 11
                set i = i + 1
                call DisplayTimedTextToPlayer(Player(i), 0, 0, 10, (d + GetPlayerName(ply0) + "|c00ff3300 被 |r" +(k + GetPlayerName(ply1)) + "|r" + "|c00ff3300 杀死了!!|r "))
                call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, (k + GetPlayerName(ply1)) + "和他的盟友|r 获得" + "|CffD8D800" + I2S(30 * lv) + "|r" + "金钱")
                if IsPlayerAlly(Player(i), ply1) == true then
                    call SetPlayerState(ply1, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(ply1, PLAYER_STATE_RESOURCE_GOLD) + 30 * lv)
                endif
            endloop
        endif
        //建筑相关的死亡
        if IsUnitType(u0, UNIT_TYPE_STRUCTURE) == true and GetUnitTypeId(u0) == 'hcas' then
            call Failure1(ply0)
        endif
        //~    
        set tmr = null 
        set u0 = null 
        set u1 = null
        set ply0 = null
        set ply1 = null  
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
        local trigger tgr1 
        local trigger tgr2
        local location pt 
        if udg_PlyHero[PlyIdx] == null and GetOwningPlayer(u0) == Player(PLAYER_NEUTRAL_PASSIVE) and IsUnitType(u0, UNIT_TYPE_HERO) == true then 
            if u0 == hero[PlyIdx] then 
                call SetUnitOwner(u0, ply, true) 
                set udg_PlyHero[PlyIdx] = u0 
                call SetPlayerName(ply, GetPlayerName(ply) + "(" + GetUnitName(u0) + ")") 
                set tgr = CreateTrigger() 
                set tgr1 = CreateTrigger() 
                set tgr2 = CreateTrigger() 
                call TriggerRegisterUnitEvent(tgr, u0, EVENT_UNIT_DEATH) //单位死亡
                call TriggerAddAction(tgr, function Death) 
                call TriggerRegisterUnitEvent(tgr1, u0, EVENT_UNIT_SPELL_CAST) //开始施法
                call TriggerAddAction(tgr1, function Moves) 
                call TriggerRegisterUnitEvent(tgr2, u0, EVENT_UNIT_SPELL_EFFECT) //发动效果
                call TriggerAddAction(tgr2, function Spell) 
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
        set tgr1 = null 
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
        local integer i = - 1
        loop
            exitwhen i == 11
            set i = i + 1
            if GetPlayerSlotState(ply) == PLAYER_SLOT_STATE_LEFT and IsPlayerAlly(ply, Player(i)) then
                call SetPlayerAlliance(ply, Player(i), ALLIANCE_SHARED_ADVANCED_CONTROL, true)
            endif
        endloop
        set ply = null //~
    endfunction


    //玩家离开 
    function Leaves takes nothing returns nothing 
        local player ply = GetTriggerPlayer() 
        local integer i = - 1 
        call ForceRemovePlayer(Olplys, ply)
        call ForForce(Olplys, function Control)
        loop 
            exitwhen i == 11 
            set i = i + 1
            call DisplayTextToPlayer(Player(i), 0, 0, udg_Player_Colour[GetPlayerId(ply)] + GetPlayerName(ply) + "|r 离开了游戏")  
        endloop 
        set ply = null //~
    endfunction 

    //地图初始化                      
    function init takes nothing returns nothing 
        local player array plys 
        local integer i = - 1 
        local integer i0 = - 1 
        local trigger array tgr 
        local unit array bulid
        local timer tmr = CreateTimer() 
        set bulid[0] = CreateUnit(Player(0), 'hcas', - 6400, - 6656, 90)
        // set bulid[1] = CreateUnit(Player(4), 'hcas', 3776, - 6784, 90)
        // set bulid[2] = CreateUnit(Player(8), 'hcas', - 1600, 1728, 90)
        set tgr[1] = CreateTrigger() 
        set tgr[2] = CreateTrigger() 
        set tgr[3] = CreateTrigger() 
        set tgr[4] = CreateTrigger() 
        set tgr[5] = CreateTrigger() 
        set tgr[6] = CreateTrigger() 
        set tgr[7] = CreateTrigger() 
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
                call TriggerRegisterPlayerChatEvent(tgr[3], plys[i], "-lvlup", false)
                call TriggerRegisterPlayerChatEvent(tgr[4], plys[i], "-gold", false)
                call TriggerRegisterPlayerChatEvent(tgr[5], plys[i], "-wtf", true)
            endif 
            set plys[i] = null //~                                
        endloop 
        loop
            exitwhen i0 == 3
            set i0 = i0 + 1
            call TriggerRegisterUnitEvent(tgr[6], bulid[i0], EVENT_UNIT_DEATH)
            call TriggerRegisterUnitEvent(tgr[7], bulid[i0], EVENT_UNIT_SELL_ITEM)
            // call BJDebugMsg(GetUnitName(store[i0]))
        endloop
        call TriggerAddAction(tgr[1], function SeltHeroA) 
        call TriggerAddAction(tgr[2], function Leaves) 
        call TriggerAddAction(tgr[3], function CmdLvup) 
        call TriggerAddAction(tgr[4], function CmdGold) 
        call TriggerAddAction(tgr[5], function Wtf) 
        call TriggerAddAction(tgr[6], function Death) 
        call TriggerAddAction(tgr[7], function Sell) 
        //~  
        set tmr = null 
        set tgr[1] = null 
        set tgr[2] = null 
        set tgr[3] = null 
        set tgr[4] = null 
        set tgr[5] = null 
        set tgr[6] = null 
    endfunction 
endlibrary 
