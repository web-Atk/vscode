library A initializer init
    globals
        hashtable HashSkill = InitHashtable()
    endglobals

    function JumpB takes nothing returns nothing
       local integer TmrAds = GetHandleId(GetExpiredTimer())
       local unit u0 = LoadUnitHandle(HashSkill,TmrAds,0)
       local real distance = LoadReal(HashSkill,TmrAds,1)//总距离
       local real ux1 = GetUnitX(u0)
       local real uy2 = GetUnitY(u0)
       local real ax1 = LoadReal(HashSkill,TmrAds,2)//技能X轴
       local real ay2 = LoadReal(HashSkill,TmrAds,3)//技能Y轴
       local real vly = LoadReal(HashSkill,TmrAds,4)//初速
       local real range = LoadReal(HashSkill,TmrAds,5) //已移动距离
       local real angle = LoadReal(HashSkill,TmrAds,6)//跳跃角度
       local real speed = 1500/50 //速率
       local real ux3
       local real uy4
       local real hight 
       if vly < speed then
          if  vly+10 > speed then
            set vly = speed
          else
            set vly = vly+10
          endif
       endif
       //call BJDebugMsg(R2S(angle))
       call SaveReal(HashSkill,TmrAds,4,vly)
    //    set ux3 =(ux1+(CosBJ(angle))*vly)
    //    set uy4 =(uy2+(SinBJ(angle))*vly)      
       set ux3 = ux1+vly*(CosBJ(angle))
       set uy4 = uy2+vly*(SinBJ(angle)) 
       set range = range+vly
       call SaveReal(HashSkill,TmrAds,5,range)
       set hight = (range/distance)*180
       set hight = ModuloReal(ModuloReal(hight,360)+360,360)
       set hight = 200*SinBJ(hight)
       if range >= distance then
        call SetUnitFlyHeight(u0,0,0)
        call FlushChildHashtable(HashSkill,TmrAds)
        call DestroyTimer(GetExpiredTimer())        
       else
        call SetUnitX(u0,ux3)
        call SetUnitY(u0,uy4)
        call SetUnitFlyHeight(u0,hight,0)
       endif
       //排泄
       set u0 = null
       
    endfunction


    function JumpA takes unit u0,real ax1,real ay2 returns nothing
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real distance = SquareRoot(Pow(ux1-ax1,2)+Pow(uy2-ay2,2))
        local real angle = bj_RADTODEG*Atan2(ay2-uy2,ax1-ux1)//技能释放方向
        local timer tmr= CreateTimer()
        local integer TmrAds = GetHandleId(tmr)
        if distance > 600 then
            set distance = 600
        endif
        //call BJDebugMsg(GetAbilityName(GetSpellAbilityId()))
        call TimerStart(tmr,0.02,true,function JumpB)
        call SaveUnitHandle(HashSkill,TmrAds,0,u0)
        call SaveReal(HashSkill,TmrAds,1,distance)//总距离
        call SaveReal(HashSkill,TmrAds,2,ax1)//技能X轴
        call SaveReal(HashSkill,TmrAds,3,ay2)//技能Y轴
        call SaveReal(HashSkill,TmrAds,4,10)//初速
        call SaveReal(HashSkill,TmrAds,5,0)//已移动距离
        call SaveReal(HashSkill,TmrAds,6,angle)//跳跃角度
        call UnitAddAbility(u0,'Amrf')
        call UnitRemoveAbility(u0,'Amrf')
       //排泄
       set u0 = null
       set tmr = null
       
    endfunction

    function WaveB takes nothing returns nothing
        local timer tmr = GetExpiredTimer()
        local integer TmrAds = GetHandleId(tmr)
        local unit u0 = LoadUnitHandle(HashSkill,TmrAds,0)
        local integer UAds = GetHandleId(u0)
        local player p0 = GetOwningPlayer(u0) 
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real distance = LoadReal(HashSkill,TmrAds,1)//总距离
        local real vly = LoadReal(HashSkill,TmrAds,2)//初速
        local real range = LoadReal(HashSkill,TmrAds,3) //已移动距离
        local real angle = LoadReal(HashSkill,TmrAds,4)//技能释放方向
        local integer nub = LoadInteger(HashSkill,UAds,0)//跳跃次数
        local real speed = 1500/50 //速率
        local real sp0 = 300 //伪范围
        local real sp1 = 120 //真范围
        local real damage = 10
        local group gp0 = CreateGroup()
        local real ux3
        local real uy4
        local real ux5
        local real uy6
        local real hight 
        local unit target 
        if vly < speed then
          if  vly+10 > speed then
            set vly = speed
          else
            set vly = vly+10
          endif
        endif
        call SaveReal(HashSkill,TmrAds,2,vly)          
        set ux3 = ux1+vly*(CosBJ(angle))
        set uy4 = uy2+vly*(SinBJ(angle)) 
        set range = range+vly
        call SaveReal(HashSkill,TmrAds,3,range)
        set hight = (range/distance)*180
        set hight = ModuloReal(ModuloReal(hight,360)+360,360)
        set hight = 50*SinBJ(hight)//高度50
        if range >= distance then
          call SetUnitFlyHeight(u0,0,0)
          if nub >= 3 then
            call KillUnit(u0)
            call FlushChildHashtable(HashSkill,TmrAds)
            call DestroyTimer(GetExpiredTimer())
           else
            call SaveReal(HashSkill,TmrAds,2,10)//初速
            call SaveReal(HashSkill,TmrAds,3,0)//已移动距离
            set nub = nub+1
            call SaveInteger(HashSkill,UAds,0,nub)//跳跃次数
          endif
        else
          call SetUnitX(u0,ux3)
          call SetUnitY(u0,uy4)
          call SetUnitFlyHeight(u0,hight,0)
          call GroupEnumUnitsInRange(gp0,ux3,uy4,sp0,null)
          loop
            set target = FirstOfGroup(gp0)
            exitwhen target == null
            if IsUnitEnemy(target,p0) then
                if GetUnitState(target,UNIT_STATE_LIFE)>0 and IsUnitInRangeXY(target,ux3,uy4,sp1) == true then
                    if IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE)==false then                                            
                      set ux5 = GetUnitX(target)+20*(CosBJ(angle))
                      set uy6 = GetUnitY(target)+20*(SinBJ(angle))
                      call SetUnitX(target,ux5)
                      call SetUnitY(target,uy6)
                      call UnitDamageTarget(u0,target,damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                    endif
                endif
            endif  
            call GroupRemoveUnit(gp0,target)         
          endloop
        endif
        //排泄
        call DestroyGroup(gp0)
        set gp0 = null
        set u0 = null
        set tmr = null
        set target = null
        set p0 = null

    endfunction

    function WaveA takes unit u0,real ax1,real ay2,integer aLv returns nothing
        local player p0 = GetOwningPlayer(u0) 
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real angle = bj_RADTODEG*Atan2(ay2-uy2,ax1-ux1) //技能释放方向
        local real ux3 = ux1+40*(CosBJ(angle))
        local real uy4 = uy2+40*(SinBJ(angle)) 
        local real distance = 200
        local unit u2 = CreateUnit(p0,'e001',ux3,uy4,angle)
        local integer UAds = GetHandleId(u2)
        local timer tmr= CreateTimer()
        local integer TmrAds = GetHandleId(tmr)
        call SetUnitX(u2,ux3)
        call SetUnitY(u2,uy4)
        call TimerStart(tmr,0.02,true,function WaveB)
        call SaveUnitHandle(HashSkill,TmrAds,0,u2)
        call SaveReal(HashSkill,TmrAds,1,distance)//总距离
        call SaveReal(HashSkill,TmrAds,2,10)//初速
        call SaveReal(HashSkill,TmrAds,3,0)//已移动距离
        call SaveReal(HashSkill,TmrAds,4,angle)//技能释放方向
        call SaveInteger(HashSkill,UAds,0,0)//跳跃次数
        //排泄
        set u0 = null
        set u2 = null
        set tmr = null
        set p0 = null
    endfunction

    //==========================================================================================

    function Spell takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u1 = GetSpellTargetUnit()
        local integer ab0 = GetSpellAbilityId()
        local integer aLv = GetUnitAbilityLevel(u0,ab0)
        local real ax1 = GetSpellTargetX()
        local real ay2 = GetSpellTargetY()
        if ab0 == 'A001' then //跳跃技能
           call JumpA(u0,ax1,ay2)
        endif
        if ab0 == 'A002' then //海浪技能
            call WaveA(u0,ax1,ay2,aLv)
        endif
    endfunction

    function init takes nothing returns nothing
        local unit u0
        local trigger trg = CreateTrigger()
        set u0 = CreateUnit(Player(0),'Hvwd',-636.7,-341.6,270)
        call FogEnableOff()
        call FogMaskEnableOff()
        call SelectUnitForPlayerSingle(u0,Player(0))
        call UnitAddAbility(u0,'A001')
        call UnitMakeAbilityPermanent(u0,true,'A001')
        call UnitAddAbility(u0,'A002')
        call UnitMakeAbilityPermanent(u0,true,'A002')
        call TriggerRegisterUnitEvent(trg,u0,EVENT_UNIT_SPELL_EFFECT)
        //call TriggerAddCondition
        call TriggerAddAction(trg,function Spell)
        //排泄
        set u0 = null

    endfunction

endlibrary
