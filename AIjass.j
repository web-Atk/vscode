library Util

//攻击处理
function Attack takes nothing returns nothing
    local unit u0 = GetTriggerUnit()//被攻击单位
    local unit u1 = GetAttacker()//攻击单位
    local real Mp = GetUnitState(u1,UNIT_STATE_MANA)
    local real sp = 10
    if IsUnitType(u1,UNIT_TYPE_HERO) == true then
       if Mp>0 then
        if Mp>sp then
            set Mp = Mp-sp
           else
            set Mp = 0
           endif
        call SetUnitState(u1,UNIT_STATE_MANA,Mp)
        else
           call IssueImmediateOrder(u1,"stop")
        endif
        call SaveReal(AbeHash,GetHandleId(u1),0,0)
      else
        //call BJDebugMsg("英雄被打了")
    endif

    

endfunction

//伤害处理
function Damage takes nothing returns nothing
    local unit u0 = GetTriggerUnit()//受伤单位
    local unit u1 = GetEventDamageSource()//伤害来源
    local real D2R = GetEventDamage()
    local real ux1 = GetUnitX(u1)
    local real uy2 = GetUnitY(u1)
    //call BJDebugMsg(R2S(D2R))
endfunction

//英雄复活函数
function Resurgence takes nothing returns nothing
    local unit u0 = LoadUnitHandle(ComHash,GetHandleId(GetExpiredTimer()),0)
    local player p0 = GetOwningPlayer(u0) 
    call ReviveHero(u0,-2502.5,2640.0,false)
    call SelectUnitAddForPlayer(u0,p0)
    call SetUnitFacing(u0,90)
    //call PanCameraToTimed(-2502.5,2640.0,0)
    //排泄
    set u0 = null   
    call FlushChildHashtable(ComHash,GetHandleId(GetExpiredTimer()))
    call DestroyTimer(GetExpiredTimer())
endfunction

//死亡函数
function Death takes nothing returns nothing
    local unit u0 = GetTriggerUnit()
    local unit u1 = GetKillingUnit()
    local player p0 = GetOwningPlayer(u0)
    local player p1 = GetOwningPlayer(u1)
    local real ux = GetUnitX(u0)
    local real uy = GetUnitY(u0)
    local timer tmr 
    local trigger trg0 
    local trigger trg1 
    local trigger trg2
    if IsUnitType(u0,UNIT_TYPE_HERO) == true then
          set tmr = CreateTimer()
          call TimerStart(tmr,5.00,false,function Resurgence)//开启复活计时器
          call SaveUnitHandle(ComHash,GetHandleId(tmr),0,u0)//给计时器绑定单位
          call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN, 3.00, "ReplaceableTextures\\CameraMasks\\SpecialSplatMask.blp", 0, 0, 0, 10.00)//显示字幕
          call SetUnitX(unit_1,ux)
          call SetUnitY(unit_1,uy)
          call SetUnitUserData(unit_1,GetPlayerState(p0,PLAYER_STATE_RESOURCE_GOLD))
          call SetPlayerState(p0,PLAYER_STATE_RESOURCE_GOLD,0)
        else 
          //判断为中立敌对单位则排泄
          if p0 == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            set trg0 = LoadTriggerHandle(DgeHash,GetHandleId(u0),0) 
            set trg1 = LoadTriggerHandle(DgeHash,GetHandleId(u0),1) 
            set trg2 = LoadTriggerHandle(DgeHash,GetHandleId(u0),2) 
            //call TriggerRemoveAction(trg,)//打算删除触发器动作，但不知道怎么填
            call DestroyTrigger(trg0)
            call DestroyTrigger(trg1)
            call DestroyTrigger(trg2)
            call FlushChildHashtable(DgeHash,GetHandleId(u0))
            if u1 == null then               
                call RemoveUnit(u0)
            endif
          endif
    endif
    //排泄
    set u0 = null
    set u1 = null
    set tmr = null
    set p0 = null
    set p1 = null
    set trg0 = null
    set trg1 = null
endfunction


//创建怪物并赋值
function CreaterMonster takes player p,integer Uid,real ux,real uy returns unit
    local trigger trg01
    local trigger trg02 
    local trigger trg03
    local unit u = CreateUnit(p,Uid,ux,uy,GetRandomReal(0,360))  
    if  p == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
        set trg01 = CreateTrigger()
        set trg02 = CreateTrigger()
        set trg03 = CreateTrigger()
        call TriggerRegisterUnitEvent(trg01,u,EVENT_UNIT_DAMAGED)//注册单位接受伤害事件
        call TriggerAddAction(trg01,function Damage)//触发添加伤害处理
        call SaveTriggerHandle(DgeHash,GetHandleId(u),0,trg01)//储存伤害触发器
        call TriggerRegisterUnitEvent(trg02,u,EVENT_UNIT_DEATH)//注册单位死亡事件
        call TriggerAddAction(trg02,function Death)//触发添加死亡处理
        call SaveTriggerHandle(DgeHash,GetHandleId(u),1,trg02)//储存死亡触发器
        call TriggerRegisterUnitEvent(trg03,u,EVENT_UNIT_ATTACKED)//注册单位被攻击事件
        call TriggerAddAction(trg03,function Attack)//触发添加攻击处理
        call SaveTriggerHandle(DgeHash,GetHandleId(u),2,trg03)//储存被攻击触发器
    endif
    return u
endfunction

//精力条系统
function Sp takes nothing returns nothing
    local timer tmr = GetExpiredTimer()
    local unit u = LoadUnitHandle(AbeHash,GetHandleId(tmr),0)
    local real r0 = LoadReal(AbeHash,GetHandleId(u),0)
    local real mp = GetUnitState(u,UNIT_STATE_MANA)
    //call BJDebugMsg("当前魔法值："+R2S(mp))
    if r0 >= 2.00 then
        call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)+1.00)
      else
        set r0 = r0+0.05
        call SaveReal(AbeHash,GetHandleId(u),0,r0)
    endif
    //排泄
    set u = null
    set tmr = null
    
endfunction

//掉落灵魂B
function SoulB takes nothing returns nothing
    local timer tmr = GetExpiredTimer()
    local unit u = LoadUnitHandle(ComHash,GetHandleId(tmr),0)
    local real ux = GetUnitX(unit_1)
    local real uy = GetUnitY(unit_1)
    if IsUnitInRangeXY(u,ux,uy,60) then
        if GetUnitAbilityLevel(u,'A002') > 0 then
            call DoNothing()
        else
            call UnitAddAbility(u,'A002')
            call UnitMakeAbilityPermanent(u,true,'A002')
        endif
      else
        call UnitRemoveAbility(u,'A002')
        call UnitMakeAbilityPermanent(u,false,'A002')
        call FlushChildHashtable(ComHash,GetHandleId(tmr))
        call DestroyTimer(tmr)
    endif
    //排泄
    set u = null
    set tmr = null
endfunction

//掉落灵魂A
function SoulA takes nothing returns nothing
    local unit u = GetTriggerUnit()//接近灵魂的单位
    local timer tmr = CreateTimer()
    call UnitAddAbility(u,'A002')
    call UnitMakeAbilityPermanent(u,true,'A002')
    call TimerStart(tmr,0.02,true,function SoulB)
    call SaveUnitHandle(ComHash,GetHandleId(tmr),0,u)
    //排泄
    set u = null
    set tmr = null
endfunction

//定时删除特效
function DelEff takes nothing returns nothing
    local timer tmr = GetExpiredTimer()
    local effect eff = LoadEffectHandle(ComHash,GetHandleId(tmr),0)
    call DestroyEffect(eff)
    //排泄
    call FlushChildHashtable(ComHash,GetHandleId(tmr))
    call DestroyTimer(tmr)
    set tmr = null
endfunction

endlibrary

//========================================================================================================================================

library A initializer init requires Util

    globals
        hashtable ComHash= InitHashtable()//常用哈希表
        hashtable DgeHash = InitHashtable()//伤害哈希表
        hashtable AbeHash = InitHashtable()//属性哈希表
        trigger DgeTgr = CreateTrigger()
        unit unit_0 
        unit unit_1 
        unit unit_2
    endglobals



//拾取灵魂
function PickupSoul takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local player p = GetOwningPlayer(u)
    local real ux = GetUnitX(unit_1)
    local real uy = GetUnitY(unit_1)
    local effect eff = AddSpecialEffect("Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl",ux,uy)
    local timer tmr = CreateTimer()
    call TimerStart(tmr,0.5,false,function DelEff)
    call SaveEffectHandle(ComHash,GetHandleId(tmr),0,eff)
    call SetUnitX(unit_1,0)
    call SetUnitY(unit_1,0)
    call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+GetUnitUserData(unit_1))
    //call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl",u,"origin"))
    //排泄
    set u = null
    set p = null
endfunction

//进入区域事件
function Enter takes nothing returns nothing
    local unit u0 = GetTriggerUnit()
    local unit array u
    local location array pt 
    local player p = Player(PLAYER_NEUTRAL_AGGRESSIVE)
    local integer i = 1
    local real ux
    local real uy 
    if IsUnitType(u0,UNIT_TYPE_HERO) then
      loop                
        exitwhen i > 2
        set pt[i] = GetRandomLocInRect(gg_rct______________000)
        set ux = GetLocationX(pt[i])
        set uy = GetLocationY(pt[i])
        set u[i] = CreaterMonster(p,'n000',ux,uy) 
        call RemoveLocation(pt[i])
        set pt[i] = null 
        set u[i] = null  
        set i = i+1   
      endloop
    endif
    //call BJDebugMsg("进入区域")
    //排泄
    set u0 = null
    set p = null
endfunction

//离开区域事件
function Leave takes nothing returns nothing
    local unit u0 = GetTriggerUnit()
    local player p = Player(PLAYER_NEUTRAL_AGGRESSIVE)
    local group g
    local unit target 
    if IsUnitType(u0,UNIT_TYPE_HERO) then
        set g = CreateGroup()
        call GroupEnumUnitsInRect(g,gg_rct______________000,null)
        loop
            set target = FirstOfGroup(g)
            exitwhen target == null
            if GetOwningPlayer(target)==p then
                call KillUnit(target)
                if GetUnitState(target,UNIT_STATE_LIFE) < 1.00 then
                    call RemoveUnit(target)
                endif
            endif
            call GroupRemoveUnit(g,target)            
        endloop
        call DestroyGroup(g)
        set g = null
      else
        call DoNothing()//非英雄离开时执行动作
    endif
    //排泄
    set u0 = null
    set p = null   
    set target = null
endfunction

//获取物品函数
function Pickup takes nothing returns nothing
    local unit u0 = GetTriggerUnit()
    local real ux = GetUnitX(u0)
    local real uy = GetUnitY(u0)
    local item itm = GetManipulatedItem()
    local item array Itm0
    local integer i = 0
    local boolean b = false
    local integer lv = GetItemLevel(itm)
    loop            
        exitwhen i > 5 or b == true
        set Itm0[i] = UnitItemInSlot(u0,i)
        if GetItemLevel(Itm0[i]) == lv and Itm0[i] != itm then
            call UnitDropItemPoint(u0,itm,ux,uy)
            set b = true
            call BJDebugMsg("同类物品已存在")
        endif
        set i = i+1
    endloop

endfunction

//丢弃物品函数
function Drop takes nothing returns nothing
    local unit u0 = GetTriggerUnit()
    local item itm = GetManipulatedItem()
endfunction

//可用指令1
function Command takes nothing returns nothing
    call UnitAddItemToSlotById(unit_2,'I000',0)
    //call UnitAddItemToSlotById(unit_2,'I001',1)
endfunction

//初始化函数
function init takes nothing returns nothing
    local trigger tgr0 = CreateTrigger()
    local trigger tgr1 = CreateTrigger()
    local trigger tgr2 = CreateTrigger()
    local trigger tgr3 = CreateTrigger()
    local trigger tgr4 = CreateTrigger()
    local trigger tgr5 = CreateTrigger()
    local trigger tgr6 = CreateTrigger()
    local trigger tgr7 = CreateTrigger()
    local trigger tgr8 = CreateTrigger()
    local trigger tgr9 = CreateTrigger()
    local player p = Player(0)
    local timer tmr = CreateTimer()
    local unit u = CreateUnit(p,'Hpb1',-2502.5,2640.0,90)    
    local region rectRegion = CreateRegion()
    local rect rct = GetPlayableMapRect()
    set unit_0 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),'e000',0,0,0)//公用提供硬直马甲
    set unit_1 = CreateUnit(p,'e001',0,0,GetRandomReal(0,360))//灵魂特效马甲
    set unit_2 = u
    call SetUnitColor(unit_1,PLAYER_COLOR_GREEN)//设值灵魂特效颜色
    call SuspendTimeOfDay(true)
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,4.00)
    call SelectUnitAddForPlayer(u,p)
    call TriggerRegisterUnitEvent(tgr0,u,EVENT_UNIT_DEATH)
    call TriggerAddAction(tgr0,function Death)
    //call TriggerRegisterEnterRectSimple(tgr1,gg_rct______________000)
    call RegionAddRect(rectRegion,gg_rct______________000) 
    call TriggerRegisterEnterRegion(tgr1,rectRegion,null)
    call TriggerRegisterLeaveRegion(tgr2,rectRegion,null)
    call TriggerAddAction(tgr1,function Enter)   
    call TriggerAddAction(tgr2,function Leave)
    call TriggerRegisterUnitEvent(tgr3,u,EVENT_UNIT_DAMAGED)
    call TriggerAddAction(tgr3,function Damage)
    call TriggerRegisterUnitEvent(tgr4,u,EVENT_UNIT_PICKUP_ITEM)
    call TriggerRegisterUnitEvent(tgr5,u,EVENT_UNIT_DROP_ITEM)
    call TriggerAddAction(tgr4,function Pickup)
    call TriggerAddAction(tgr5,function Drop)
    call TriggerRegisterUnitInRangeSimple(tgr6,50,unit_1)
    call TriggerAddAction(tgr6,function SoulA)
    call TriggerRegisterUnitEvent(tgr7,u,EVENT_UNIT_SPELL_EFFECT)
    call TriggerAddAction(tgr7,function PickupSoul)
    call TriggerRegisterPlayerChatEvent(tgr8,p,"1",true)
    call TriggerAddAction(tgr8,function Command)
    call TriggerRegisterUnitEvent(tgr9,u,EVENT_UNIT_ATTACKED)
    call TriggerAddAction(tgr9,function Attack)
    call TimerStart(tmr,0.05,true,function Sp)//开启精力条检测计时器
    call SaveUnitHandle(AbeHash,GetHandleId(tmr),0,u)//索引0存储单位
    call SaveReal(AbeHash,GetHandleId(u),0,1.00)//索引1存储累计值
    call ShowUnit(unit_0,false)
    call CreateFogModifierRectBJ( true, Player(PLAYER_NEUTRAL_PASSIVE), FOG_OF_WAR_VISIBLE, rct)//给中立被动玩家开全图视野
    call SetPlayerHandicapXP(p,0)
    call SetCameraTargetController(u,0,0,true)
    // call FogEnable(false)
    // call FogMaskEnable(false)
    //排泄
    set u = null
    set p = null
    set rectRegion = null
    set tmr = null
endfunction

endlibrary