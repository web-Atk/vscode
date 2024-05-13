//腐烂之触技能效果 
library test1 //initializer rotting_touch 
  globals 
    hashtable abl = InitHashtable() 
  endglobals 

  function Decay takes nothing returns nothing 
    local unit u0 = LoadUnitHandle(abl, GetHandleId(GetExpiredTimer()), 0) 
    local unit u1 = LoadUnitHandle(abl, GetHandleId(GetExpiredTimer()), 1) 
    local real hp1 = GetUnitState(u0, UNIT_STATE_LIFE) 
    local real hp2 = LoadReal(abl, GetHandleId(u0), 1) 
    local real r1 = LoadReal(abl, GetHandleId(u0), 0) 
    local real r2 = hp1 - hp2 
    local real r3 = 0 
    set r1 = r1 - 0.01 
    call SaveReal(abl, GetHandleId(u0), 0, r1) 
    //call BJDebugMsg("当前血量"+R2S(hp1)) 
    //call BJDebugMsg("上一秒血量"+R2S(hp2)) 
    if r2 > 5.0 then 
      set r3 = hp1 - r2 
      //call BJDebugMsg("血量相差"+R2S(r2)) 
      call SetUnitState(u0, UNIT_STATE_LIFE, r3) 
      call UnitDamageTarget(u1, u0, r2, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS) 
    endif 
    if r1 <= 0.0 or GetUnitState(u0, UNIT_STATE_LIFE) <= 0 then 
      call UnitRemoveAbility(u0, 'AUau') 
      call UnitRemoveAbility(u0, 'BUav') 
      call FlushChildHashtable(abl, GetHandleId(u0)) 
      call FlushChildHashtable(abl, GetHandleId(GetExpiredTimer())) 
      call DestroyTimer(GetExpiredTimer()) 
      //call BJDebugMsg("Death!!!") 
    else 
      call SaveReal(abl, GetHandleId(u0), 1, GetUnitState(u0, UNIT_STATE_LIFE)) 
    endif 

    set u0 = null 
    set u1 = null 
    
  
  endfunction 

  native UnitAlive 


  function rotting_touch takes unit u0, unit u1, real r1 returns nothing 
    local timer t1 
    local integer lv = GetUnitAbilityLevel(u0, 'AUau') 
    if lv > 0 then 
      call SaveReal(abl, GetHandleId(u0), 0, r1) 
      //call BJDebugMsg("null") 
    else 
      call UnitAddAbility(u0, 'AUau') 
      set t1 = CreateTimer() 
      call SaveReal(abl, GetHandleId(u0), 0, r1) 
      call SaveReal(abl, GetHandleId(u0), 1, GetUnitState(u1, UNIT_STATE_LIFE)) 
      call SaveUnitHandle(abl, GetHandleId(t1), 0, u0) 
      call SaveUnitHandle(abl, GetHandleId(t1), 1, u1) 
      call TimerStart(t1, 0.01, true, function Decay) 
      //call BJDebugMsg("hello world") 
    endif 

    set u0 = null 
    set u1 = null 
    set t1 = null 

  endfunction 

endlibrary