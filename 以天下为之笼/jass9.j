//up主 以天下为之笼 魔兽Jass教程（十八）单位组实现刷怪 
library include initializer init 

  function ShuaBingCondition takes nothing returns boolean 
    return IsUnitAliveBJ(GetFilterUnit()) and GetOwningPlayer(GetFilterUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE) 
  endfunction 

  function ShuaBingAction takes nothing returns nothing 
    local group ShuaBingGroup = CreateGroup() 
    local boolexpr ShuaBingBoolexpr = Condition(function ShuaBingCondition) 
    local player p1 = Player(PLAYER_NEUTRAL_AGGRESSIVE) 
    local integer i = 0 

    call GroupEnumUnitsInRect(ShuaBingGroup, gg_rct_farm, ShuaBingBoolexpr) 

    if CountUnitsInGroup(ShuaBingGroup) == 0 then 
      loop 
        exitwhen i > 20 
        call CreateUnit(p1, 'hfoo', GetRectCenterX(gg_rct_farm), GetRectCenterY(gg_rct_farm), 60) 
        set i = i + 1 
      endloop 
        
    endif 

    call DestroyBoolExpr(ShuaBingBoolexpr) 
    call DestroyGroup(ShuaBingGroup) 
  endfunction 

  function init takes nothing returns nothing 
    local trigger ShuaBingTrigger = CreateTrigger() 
    call TriggerRegisterTimerEvent(ShuaBingTrigger, 5, true) 
    call TriggerAddAction(ShuaBingTrigger, function ShuaBingAction) 
  endfunction 

endlibrary 

library algorithm 

  // function height takes real f0 real f1 real f2 returns real 

  //   local real f3  
  //    //f0=上一个点的高度 f1=当前点的高度 f2=特效高度 
  //    if f0 > f1 then 
  //     set f3 = f0 - RAbsBJ(f0-f1) 
  //    else 
  //     set f3 = f0 + RAbsBJ(f0-f1) 
  //    endif 
  //    return f3 
  //    //call YDWEJumpTimer 
  //    //call  
  call 

  // endfunction 
endlibrary