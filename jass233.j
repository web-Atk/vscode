library TreeSentinel initializer init
  globals
    hashtable ComHash = InitHashtable()
  endglobals

  function A takes nothing returns nothing
    call BJDebugMsg("I'm coming!!!")
  endfunction

  function B takes nothing returns nothing
    local timer tmr0 = GetExpiredTimer()
    local integer i0 = GetHandleId(tmr0)
    local unit u0 = LoadUnitHandle(ComHash,i0,0)
    //设坐标1为x1，y1，坐标2为x2，y2则两坐标距离=((x1-x2)²+(y1-y2)²)的平方根.
    local real array px 
    local real array py
     //A点是（-195.9和-234.7） B点是（2523.3和-301.7）
    local real distance
    set px[1] = GetUnitX(u0)//distance > 15.00
    set py[1] = GetUnitY(u0)
    set px[2] = LoadReal(ComHash,i0,1)
    set py[2] = LoadReal(ComHash,i0,2)
    set distance = SquareRoot(Pow(px[2]-px[1],2.00)+Pow(py[2]-py[1],2.00))  
    //call BJDebugMsg(R2S(distance))
    //call BJDebugMsg("X轴："+R2S(px[2])+"Y轴："+R2S(py[2]))
      if IsUnitInRangeXY(u0,px[2],py[2],1.00) == false then
        call IssuePointOrder(u0,"move",px[2],py[2])
        //call BJDebugMsg("跑")
      else
        //call BJDebugMsg("掉头")
        if px[2] == 2523.3 and py[2] == -301.7 then
          call SaveReal(ComHash,i0,1,-195.9)//保存X轴至哈希表
          call SaveReal(ComHash,i0,2,-234.7)//保存Y轴至哈希表
        else
          call SaveReal(ComHash,i0,1,2523.3)//保存X轴至哈希表
          call SaveReal(ComHash,i0,2,-301.7)//保存Y轴至哈希表
        endif
        set px[2] = LoadReal(ComHash,i0,1)
        set py[2] = LoadReal(ComHash,i0,2)
        call IssuePointOrder(u0,"move",px[2],py[2])
      endif
    //排泄↓
    set u0 = null
    set tmr0 = null
  endfunction

  function State takes nothing returns nothing
    local timer tmr0 = GetExpiredTimer()
    local integer i0 = GetHandleId(tmr0)
    local unit u0 = LoadUnitHandle(ComHash,i0,0)

  endfunction

  function init takes nothing returns nothing
    local unit u0
    local player p0 = Player(PLAYER_NEUTRAL_AGGRESSIVE)
    local trigger tgr = CreateTrigger()
    local timer tmr0 = CreateTimer()
    local integer i0 = GetHandleId(tmr0)
    call FogEnable(false)
    call FogMaskEnable(false)
    set u0 = CreateUnit(p0,'Hlgr',-195.9,-234.7,0)//新建BOSS单位
    call TriggerRegisterUnitInRangeSimple(tgr,400,u0)//接近BOSS 400距离时触发
    call TriggerAddAction(tgr,function A)
    call TimerStart(tmr0,0.5,true,function State)//开启计时器
    call SaveUnitHandle(ComHash,i0,0,u0)//保存单位至哈希表
    call SaveReal(ComHash,i0,1,2523.3)//保存X轴至哈希表
    call SaveReal(ComHash,i0,2,-301.7)//保存Y轴至哈希表
    // call AddSpecialEffect("units\\orc\\SentryWard\\SentryWard.mdl",-195.9,-234.7)
    // call AddSpecialEffect("units\\orc\\SentryWard\\SentryWard.mdl",2523.3,-301.7)
    //排泄↓
    set u0 = null
    set tmr0 = null
    set p0 = null
  endfunction

endlibrary