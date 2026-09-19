//系统库
library SysLib initializer init
    
    globals
        //伤害注册触发器
        trigger dmgTgr = CreateTrigger() 
        //死亡注册触发器
        trigger dthTgr = CreateTrigger()
        //伤害触发器重新注册动作
        trigger dmgResetTgr = CreateTrigger()
        //受伤单位组 
        group dmgGroup = CreateGroup()
        trigger SpellTgr = CreateTrigger()
        trigger SpellEndTgr = CreateTrigger()
        trigger SpellStopTgr = CreateTrigger()
        // trigger SmdTgr = CreateTrigger() //召唤触发暂时作废
        hashtable AbiHash = InitHashtable() //绑定幻象依赖的马甲
        //历史注册次数
        integer evtRegCnt = 0
        boolean isWin = true
        boolean wtf = false
        boolean Test = false
        constant integer DAMAGE_TYPE_PHYSICAL = 0    // 物理伤害
        constant integer DAMAGE_TYPE_MAGICAL = 1     // 魔法伤害
        constant integer DAMAGE_TYPE_HOLY = 2      // 神圣伤害
        constant real DAMAGE_EVENT_RESET_INTERVAL = 1200 // 销毁伤害事件触发器间隔
    endglobals

    //查询玩家编号（完整版）
    function Controller takes integer i returns player
        if i >= 0 and i <= 11 then
            return Player(i)
        elseif i == 12 then
            return Player(PLAYER_NEUTRAL_AGGRESSIVE)
        elseif i == 13 then
            return Player(bj_PLAYER_NEUTRAL_VICTIM)
        elseif i == 14 then
            return Player(bj_PLAYER_NEUTRAL_EXTRA)
        elseif i == 15 then
            return Player(PLAYER_NEUTRAL_PASSIVE)
        endif
        return null
    endfunction
    
    //响应ESC
    function ESC takes nothing returns nothing
        call BJDebugMsg("单位组：" + I2S(CountUnitsInGroup(dmgGroup)))
        call BJDebugMsg("伤害事件历史注册：" + I2S(evtRegCnt))
        if Test then
            set Test = false
            call BJDebugMsg("测试模式已经关闭")
        else
            set Test = true
            call BJDebugMsg("测试模式已开启")
        endif
    endfunction

    //为玩家1打印信息
    function Print takes string str returns nothing
        if Test then
            call DisplayTimedTextFromPlayer(Player(0), 0, 0, 15, str)
        endif
    endfunction

    //判断是否为BOSS，此乃偷懒函数
    function IsBOSS takes integer uid returns boolean
        if uid == 'h00O' or uid == 'o001' or uid == 'e00A' then
            return true
        else
            return false
        endif
    endfunction

    //圆内随机点<飞星乱弹>
    function RandCirclePoint takes location p0, location p1, real radius returns location
        local real curX = GetLocationX(p0)
        local real curY = GetLocationY(p0)
        local real centerX = GetLocationX(p1)
        local real centerY = GetLocationY(p1)
        local real baseAngle
        local real finalAngle
        local real angleOffset
        local real dirX
        local real dirY
        local real toCenterX
        local real toCenterY
        local real dot
        local real distToCenter
        local real maxDistance
        local real distance
        local real newX
        local real newY
        set baseAngle = Atan2(centerY - curY, centerX - curX)
        set angleOffset = GetRandomReal(-45.00, 45.00)
        set finalAngle = baseAngle + angleOffset * 0.01745329252
        set dirX = Cos(finalAngle)
        set dirY = Sin(finalAngle)
        set toCenterX = centerX - curX
        set toCenterY = centerY - curY
        set distToCenter = SquareRoot(toCenterX * toCenterX + toCenterY * toCenterY)
        set dot = toCenterX * dirX + toCenterY * dirY
        set maxDistance = dot + SquareRoot(dot * dot + radius * radius - distToCenter * distToCenter)
        set distance = GetRandomReal(100, maxDistance)
        set newX = curX + dirX * distance
        set newY = curY + dirY * distance
        call RemoveLocation(p0)
        call RemoveLocation(p1)
        return Location(newX, newY)
    endfunction

    //生成N个单位在坐标，暴雪原生函数会互相覆盖最后创建单位组，导致获取失败
    function CreateNUnitsAtXY takes integer cnt, integer uid, player ply, real x, real y, real facing returns group
        local group ugp = CreateGroup()
        local unit u
        loop
            set cnt = cnt - 1
            exitwhen cnt < 0
            set u = CreateUnit(ply, uid, x, y, facing)
            call GroupAddUnit(ugp, u)
        endloop
        return ugp
    endfunction


    //-------------------------------------------------------------------------------------------------------
    //字符串转Rawcode
    function CharToAscii takes string c returns integer
        local string chars = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
        local integer i = 0

        loop
            exitwhen i >= StringLength(chars)

            if SubString(chars, i, i + 1) == c then
                return i + 32
            endif

            set i = i + 1
        endloop

        return - 1
    endfunction


    function StringToRawcode takes string s returns integer
        local integer a
        local integer b
        local integer c
        local integer d

        if StringLength(s) != 4 then
            return 0
        endif

        set a = CharToAscii(SubString(s, 0, 1))
        set b = CharToAscii(SubString(s, 1, 2))
        set c = CharToAscii(SubString(s, 2, 3))
        set d = CharToAscii(SubString(s, 3, 4))

        if a < 0 or b < 0 or c < 0 or d < 0 then
            return 0
        endif

        return a * 16777216 + b * 65536 + c * 256 + d
    endfunction
    //-------------------------------------------------------------------------------------------------------

    //英雄复活
    function Respawn takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local unit u0 = LoadUnitHandle(udg_Hash_System, GetHandleId(tmr), 0)
        call ReviveHero(u0, 4860.3, -5023.9, true)
        call SetUnitState(u0, UNIT_STATE_MANA, GetUnitState(u0, UNIT_STATE_MAX_MANA))
        call SelectUnitForPlayerSingle(u0, GetOwningPlayer(u0))
        call DestroyTimer(tmr)
        set tmr = null
    endfunction

    //输入指令创建英雄
    function SpawnHeroCmd takes player ply, string str returns nothing 
        local location point = GetCameraTargetPositionLoc()
        local real x = GetLocationX(point)  
        local real y = GetLocationY(point)
        local integer uid
        call RemoveLocation(point)  
        set str = SubString(str, 8, 12)
        set uid = StringToRawcode(str)
        if udg_Player_Hero[GetPlayerId(ply) + 1] == null then
            set udg_Player_Hero[GetPlayerId(ply) + 1] = CreateUnit(ply, uid, x, y, 0)
            if udg_Player_Hero[GetPlayerId(ply) + 1] != null and IsUnitType(udg_Player_Hero[GetPlayerId(ply) + 1], UNIT_TYPE_HERO) == true then
                call SelectUnitForPlayerSingle(udg_Player_Hero[GetPlayerId(ply) + 1], ply)
                call UnitAddAbility(udg_Player_Hero[GetPlayerId(ply) + 1], 'Asal')
                call UnitMakeAbilityPermanent(udg_Player_Hero[GetPlayerId(ply) + 1], true, 'Asal')
                call DestroyTrigger(gg_trg_Create_a_Hero)
                call TriggerRegisterUnitEvent(SpellTgr, udg_Player_Hero[GetPlayerId(ply) + 1], EVENT_UNIT_SPELL_EFFECT)
                call TriggerRegisterUnitEvent(SpellEndTgr, udg_Player_Hero[GetPlayerId(ply) + 1], EVENT_UNIT_SPELL_FINISH)
                call TriggerRegisterUnitEvent(SpellStopTgr, udg_Player_Hero[GetPlayerId(ply) + 1], EVENT_UNIT_SPELL_ENDCAST)
            else
                set udg_Player_Hero[GetPlayerId(ply) + 1] = null  
            endif
        endif
    endfunction
    
    //女王俯卧养伤
    function HurtQueen takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u1 = GetEventDamageSource()
        //女王养伤
        if u0 == udg_Queen and GetUnitStateSwap(UNIT_STATE_LIFE, u0) <= (GetUnitStateSwap(UNIT_STATE_MAX_LIFE, u0) * 0.30) then 
            call SetPlayerAbilityAvailable(Player(8), 'Astn', true) 
            call IssueImmediateOrder(u0, "stoneform")
        endif
    endfunction
    
    //受伤单位进入地图
    function EnterMap takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u1
        local real ux 
        local real uy 
        local integer i = GetUnitAbilityLevel(u0, 'Aloc')   
        if i <= 0 then
            set evtRegCnt = evtRegCnt + 1
            call GroupAddUnit(dmgGroup, u0)
            call TriggerRegisterUnitEvent(dmgTgr, u0, EVENT_UNIT_DAMAGED)
            call TriggerRegisterUnitEvent(dthTgr, u0, EVENT_UNIT_DEATH)
        endif
        if IsUnitIllusion(u0) and GetUnitAbilityLevel(u0, 'B001') > 0 then //幻象施法系列 这里把i的值改了，后面要改，需要注意！！！
            set u1 = udg_Player_Hero[GetPlayerId(GetOwningPlayer(u0)) + 1]
            set ux = GetUnitX(u1)
            set uy = GetUnitY(u1)
            set i = GetHandleId(u1)
            set u1 = LoadUnitHandle(AbiHash, i, 0)
            call UnitAddAbility(u0, 'Aloc')
            call UnitAddAbility(u0, 'Abun')
            call SetUnitVertexColor(u0, 255, 255, 255, 127)
            call SetUnitOwner(u0, Player(PLAYER_NEUTRAL_PASSIVE), false)
            call UnitApplyTimedLife(u0, 'BHwe', GetUnitState(u1, UNIT_STATE_LIFE)) 
            call SetUnitX(u0, ux)
            call SetUnitY(u0, uy)
            call SetUnitAnimationByIndex(u0, GetUnitUserData(u1))
            call FlushChildHashtable(AbiHash, i)
            call BJDebugMsg("召唤者" + GetUnitName(u1) + "召唤物" + GetUnitName(u0))
        endif
        if udg_Player_Hero[GetPlayerId(GetOwningPlayer(u0)) + 1] == u0 then //开局装备
            call UnitAddItemByIdSwapped('ankh', u0)
            call UnitAddItemByIdSwapped('pghe', u0)
        endif
        set u0 = null
        set u1 = null
    endfunction
    
    //排泄伤害事件倒计时
    function DmgTimer takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local group ugp = CreateGroup()
        local unit u1 
        call DestroyTrigger(dmgTgr)
        set dmgTgr = CreateTrigger()
        call GroupAddGroup(dmgGroup, ugp)
        loop
            set u1 = FirstOfGroup(ugp)
            exitwhen u1 == null
            call TriggerRegisterUnitEvent(dmgTgr, u1, EVENT_UNIT_DAMAGED)
            call GroupRemoveUnit(ugp, u1)
        endloop
        call TriggerExecute(dmgResetTgr)
        call DestroyGroup(ugp)
        call TimerStart(tmr, DAMAGE_EVENT_RESET_INTERVAL, false, function DmgTimer)
        call BJDebugMsg("伤害事件重置")
    endfunction

    function Defeat takes nothing returns nothing
        call DisplayTimedTextFromPlayer(GetEnumPlayer(), 0, 0, 15,"女王已死，你们的任务失败了！")
    endfunction
    
    //受伤单位死亡（敌方英雄死亡时记得豁免非英雄判定）
    function DmgDeath takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local integer cnt = 0
        local timer tmr
        if not IsUnitType(u0, UNIT_TYPE_HERO) or IsUnitIllusion(u0) then
            call GroupRemoveUnit(dmgGroup, u0)
        else
            loop 
                set cnt = cnt + 1
                exitwhen cnt >= 10
                if u0 == udg_Player_Hero[cnt] then
                    set tmr = CreateTimer()
                    call SaveUnitHandle(udg_Hash_System, GetHandleId(tmr), 0, u0)
                    call TimerStart(tmr, 10, false, function Respawn)
                endif
            endloop
        endif
        //女王死亡
        if u0 == udg_Queen then
            call ForForce(udg_Players, function Defeat)
            set isWin = false
        endif
        set tmr = null
    endfunction
    
    //地图初始化
    function init takes nothing returns nothing
        local unit u1 
        local trigger tgr = CreateTrigger()
        local rect rct = GetEntireMapRect()
        local region rgn = CreateRegion()
        local group ugp = CreateGroup()
        local timer tmr = CreateTimer()
        local integer cnt = 0
        loop
            exitwhen cnt > 16
            call GroupEnumUnitsOfPlayer(ugp, Controller(cnt), null) //这函数会重置单位组，含清空再添加
            call GroupAddGroup(ugp, dmgGroup)
            set cnt = cnt + 1
        endloop
        call GroupAddGroup(dmgGroup, ugp)
        set evtRegCnt = evtRegCnt + CountUnitsInGroup(dmgGroup)
        loop
            set u1 = FirstOfGroup(ugp)
            exitwhen u1 == null
            call TriggerRegisterUnitEvent(dmgTgr, u1, EVENT_UNIT_DAMAGED)
            call TriggerRegisterUnitEvent(dthTgr, u1, EVENT_UNIT_DEATH)
            call GroupRemoveUnit(ugp, u1)
        endloop
        call TriggerAddAction(dthTgr, function DmgDeath)
        call RegionAddRect(rgn, rct)
        call TriggerRegisterEnterRegion(tgr, rgn, null) //任意单位进入地图事件
        call TriggerAddAction(tgr, function EnterMap)
        call TimerStart(tmr, DAMAGE_EVENT_RESET_INTERVAL, false, function DmgTimer)
        call DestroyGroup(ugp)
        call RemoveRect(rct)
        set tgr = null
        set rgn = null
        set ugp = null
    endfunction

endlibrary

//技能施法库
library SpellLib initializer init requires SysLib


    //任意单位召唤响应函数
    // function IllusionA takes nothing returns nothing
    // endfunction

    //伤害显示
    function DmgShow takes nothing returns nothing
    endfunction

    //防守图通用判断
    function IsUnitValidAOEDmg takes nothing returns boolean
        if IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) != true and IsUnitEnemy(GetFilterUnit(), Player(8)) /*
            */and GetUnitStateSwap(UNIT_STATE_LIFE, GetFilterUnit()) > 0.00 then
            return true
        else
            return false
        endif
    endfunction

    //范围伤害
    function AOEDamage takes unit caster, real damage, real x, real y, real rng1, integer dmgtype returns nothing //施暴者、造成伤害、圆心、伤害类型、范围
        local real rng2 = rng1 + 50
        local group ugp = CreateGroup()
        local unit target
        call GroupEnumUnitsInRange(ugp, x, y, rng2, function IsUnitValidAOEDmg)
        loop
            set target = FirstOfGroup(ugp)
            exitwhen target == null
            if IsUnitInRangeXY(target, x, y, rng1) then
                if dmgtype == 0 then //物理伤害
                    call UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                elseif dmgtype == 1 then //魔法伤害
                    call UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                elseif dmgtype == 2 then //神圣伤害
                    call UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
            endif
            call GroupRemoveUnit(ugp, target)
        endloop
        call DestroyGroup(ugp)
    endfunction

    //普攻判断-掠夺法
    function AtkDmgTwo takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local integer index = GetHandleId(tmr)
        local unit tgtUnit = LoadUnitHandle(AbiHash, index, 0)
        local unit srcUnit = LoadUnitHandle(AbiHash, index, 1)
        local player ply = GetOwningPlayer(srcUnit)
        local real DmgAmt = LoadReal(AbiHash, GetHandleId(tmr), 2)
        local integer prevLum = LoadInteger(AbiHash, index, 3) //前一秒的木材
        local integer curLum = GetPlayerState(ply, PLAYER_STATE_RESOURCE_LUMBER) //当前木材
        local real hp = GetUnitState(srcUnit, UNIT_STATE_LIFE)
        local real tx = GetUnitX(tgtUnit)
        local real ty = GetUnitY(tgtUnit)
        local integer Int = GetHeroInt(srcUnit, true)
        if curLum > prevLum then 
            call SetPlayerState(ply, PLAYER_STATE_RESOURCE_LUMBER, prevLum) //判断为普攻
            call SetUnitState(srcUnit, UNIT_STATE_LIFE, hp + (DmgAmt * 0.2))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", srcUnit,"chest"))
            if GetUnitAbilityLevel(srcUnit, 'AUfn') > 0 then
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", tx, ty))
                call AOEDamage(srcUnit, I2R(Int) * 0.5, tx, ty, 200, DAMAGE_TYPE_MAGICAL)
            endif
        endif
        //排泄
        call FlushChildHashtable(AbiHash, index)
        call DestroyTimer(tmr)
        set tmr = null
    endfunction

    //普攻伤害-掠夺法
    function AtkDmgOne takes nothing returns nothing
        local unit tgtUnit = GetTriggerUnit()
        local unit srcUnit = GetEventDamageSource()
        local player ply = GetOwningPlayer(srcUnit)
        local real DmgAmt = GetEventDamage()
        local integer prevLum = GetPlayerState(ply, PLAYER_STATE_RESOURCE_LUMBER)
        local timer tmr 
        if DmgAmt > 0 and GetUnitAbilityLevel(srcUnit, 'Asal') > 0 then
            set tmr = CreateTimer()
            call SaveUnitHandle(AbiHash, GetHandleId(tmr), 0, tgtUnit)
            call SaveUnitHandle(AbiHash, GetHandleId(tmr), 1, srcUnit)
            call SaveReal(AbiHash, GetHandleId(tmr), 2, DmgAmt)
            call SaveInteger(AbiHash, GetHandleId(tmr), 3, prevLum)
            call TimerStart(tmr, 0, false, function AtkDmgTwo)
        endif
        set tmr = null
    endfunction

    //技能伤害
    function AbiDamage takes nothing returns nothing
        local unit tgtUnit = GetTriggerUnit()
        local unit srcUnit = GetEventDamageSource()
        local real DmgAmt = GetEventDamage()
    endfunction

    function Channel takes unit u0, integer abi, integer aLv, real ax, real ay returns nothing
        local unit u2
        local real ux = GetUnitX(u0)
        local real uy = GetUnitY(u0)
        local real angle = GetUnitFacing(u0)
        local player ply = GetOwningPlayer(u0)
        local trigger tgr = CreateTrigger()
        set u2 = CreateUnit(ply, 'e00B', -2705, 3437.2, angle)
        call ShowUnit(u2, false)
        call SaveUnitHandle(AbiHash, GetHandleId(u0), 0, u2)
        // call SetUnitX(u2, ux)
        // call SetUnitY(u2, uy)
        call UnitApplyTimedLife(u2, 'BHwe', 10)
        call IssueNeutralTargetOrderById(ply, u2, 852274, u0)
        if abi == 'A010' then //暴风雪
            call SetUnitUserData(u2, 9)
            call SetUnitState(u2, UNIT_STATE_LIFE, 7)
            call UnitAddAbility(u2, 'Aro2')
            call UnitAddAbility(u2, 'AHbz')
            call SetUnitAbilityLevel(u2, 'AHbz', aLv)
            call IssuePointOrder(u2, "blizzard", ax, ay)
        endif
        if abi == 'A011' then  //群星坠落
            call SetUnitX(u2, ux)
            call SetUnitY(u2, uy)
            call SetUnitUserData(u2, 1)
            call SetUnitState(u2, UNIT_STATE_LIFE, 60)
            call UnitAddAbility(u2, 'Aro2')
            call UnitAddAbility(u2, 'AEsf')
            call SetUnitAbilityLevel(u2, 'AEsf', aLv)
            call IssueImmediateOrder(u2, "starfall")
        endif
        if abi == 'A012' then  //火焰雨
            call SetUnitUserData(u2, 12)
            call SetUnitState(u2, UNIT_STATE_LIFE, 10)
            call UnitAddAbility(u2, 'Aro2')
            call UnitAddAbility(u2, 'ANrf')
            call SetUnitAbilityLevel(u2, 'ANrf', aLv)
            call IssuePointOrder(u2, "rainoffire", ax, ay)
        endif
    endfunction

    //施法事件（停止施法）
    function SpellStop takes nothing returns nothing
        local unit u0 = GetTriggerUnit() //施法者
        local integer abi = GetSpellAbilityId() //技能
        if wtf then //WTF模式
            call UnitResetCooldown(u0)
            call SetUnitState(u0, UNIT_STATE_MANA, GetUnitState(u0, UNIT_STATE_MAX_MANA))
        endif
    endfunction

    //施法事件（施法结束）
    function SpellEnd takes nothing returns nothing
        
    endfunction

    //施法事件（后摇开始）
    function Spell takes nothing returns nothing
        local unit u0 = GetTriggerUnit() //施法者
        local unit u1 = GetSpellTargetUnit() //技能目标
        local integer abi = GetSpellAbilityId() //技能
        local integer aLv = GetUnitAbilityLevel(u0, abi) //技能等级
        local real ax1 = GetSpellTargetX() //技能目标点X坐标
        local real ay2 = GetSpellTargetY() //技能目标点Y坐标
        local real angle = bj_RADTODEG * Atan2(ay2 - GetUnitY(u0), ax1 - GetUnitX(u0)) //技能释放方向   
        if abi == 'A010' or abi == 'A011' or abi == 'A012' or abi == 'A014' then //持续施法  
            call Channel(u0, abi, aLv, ax1, ay2) 
        endif 
        // if abi == 'A002' then //海浪技能    
        //     call WaveA(u0, ax1, ay2, aLv) 
        // endif 
        // if abi == 'A003' then //冲锋技能    
        //
        // endif 
    endfunction

    //注册伤害动作
    function DmgEventRebindHandler takes nothing returns nothing
        call TriggerAddAction(dmgTgr, function HurtQueen)
        call TriggerAddAction(dmgTgr, function AtkDmgOne)  
        call TriggerAddAction(dmgTgr, function AbiDamage)  
    endfunction

    private function init takes nothing returns nothing
        call TriggerAddAction(SpellTgr, function Spell)     
        call TriggerAddAction(SpellEndTgr, function SpellEnd)
        call TriggerAddAction(SpellStopTgr, function SpellStop)
        call TriggerAddAction(dmgResetTgr, function DmgEventRebindHandler)  
        call DmgEventRebindHandler()
        // call TriggerRegisterAnyUnitEventBJ(SmdTgr, EVENT_PLAYER_UNIT_SUMMON) //召唤事件暂时作废
        // call TriggerAddAction(SmdTgr, function IllusionA)
    endfunction

endlibrary