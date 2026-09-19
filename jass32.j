//单位被弹幕命中后做动作
function BulletUnitAction takes integer index, real X, real Y, real Range returns nothing
    local unit BulletUnit = udg_Bullet[index]
    local unit PlayerUnit
    local integer ID = 0
    loop
        set ID = ID+1
        set PlayerUnit = udg_PlayerUnit[ID]
        if ( PlayerUnit != null ) then
            if ( IsUnitInRangeXY(PlayerUnit, X, Y, Range) ) then
                call KillUnit(BulletUnit)
                call DisplayTimedTextToPlayer(Player(0),0,0,2,"弹幕命中")
            endif
        endif
        exitwhen ID == 12
    endloop
    set BulletUnit = null
    set PlayerUnit = null
endfunction

//最高位数组下标填充到被销毁的数组下标处
function MoveIndex takes integer index returns nothing
    set udg_Bullet[index] = udg_Bullet[udg_Bullet_IndexMax]
    set udg_Bullet_X[index] = udg_Bullet_X[udg_Bullet_IndexMax]
    set udg_Bullet_Y[index] = udg_Bullet_Y[udg_Bullet_IndexMax]
    set udg_Bullet_Face[index] = udg_Bullet_Face[udg_Bullet_IndexMax]
    set udg_Bullet_Speed[index] = udg_Bullet_Speed[udg_Bullet_IndexMax]
    set udg_Bullet_Range[index] = udg_Bullet_Range[udg_Bullet_IndexMax]
    set udg_Bullet_LifeTime[index] = udg_Bullet_LifeTime[udg_Bullet_IndexMax]
    set udg_Bullet_MaxLifeTime[index] = udg_Bullet_MaxLifeTime[udg_Bullet_IndexMax]
    
    set udg_Bullet_IndexMax = udg_Bullet_IndexMax-1 //返回数组最高位
endfunction

//移动弹幕
function BulletMove takes nothing returns nothing
    local unit GroupUnit
    local unit Unit
    local real X
    local real Y
    local real Face
    local real Speed
    local real Range
    local real LifeTime
    local real MaxLifeTime
    
    local integer playerindex = 0
    local integer index = 0
    local integer indexmax = udg_Bullet_IndexMax
    loop
        set index = index+1
        
        set Unit = udg_Bullet[index]
        set LifeTime = udg_Bullet_LifeTime[index]
        set MaxLifeTime = udg_Bullet_MaxLifeTime[index]
        
        if ( GetWidgetLife(Unit) > 0 ) then
            if ( LifeTime <= MaxLifeTime ) then
                set X = udg_Bullet_X[index]
                set Y = udg_Bullet_Y[index]
                set Face = udg_Bullet_Face[index]
                set Speed = udg_Bullet_Speed[index]
                set Range = udg_Bullet_Range[index]
                
                set X = X+Cos(Face*0.01745)*Speed
                set Y = Y+Sin(Face*0.01745)*Speed
                
                call SetUnitX(Unit, X)
                call SetUnitY(Unit, Y)
                
                call GroupEnumUnitsInRange(udg_Bullet_Group, X, Y, Range, null)
                set GroupUnit = FirstOfGroup(udg_Bullet_Group)
                if ( GroupUnit != null ) then
                    call BulletUnitAction(index, X, Y, Range)//弹幕碰撞到单位做动作(弹幕,X,Y,碰撞范围)
                endif
                call GroupClear(udg_Bullet_Group)
                
                set udg_Bullet_X[index] = X
                set udg_Bullet_Y[index] = Y
                
                set LifeTime = LifeTime+1                    //存在帧数
                set udg_Bullet_LifeTime[index] = LifeTime
                
            else
                call KillUnit(Unit)
            endif
        else
            if ( index < udg_Bullet_IndexMax ) then
                call MoveIndex(index)
            endif
        endif
        exitwhen index >= indexmax
    endloop
    
    set GroupUnit = null
    set Unit = null
endfunction

//call CreateBullet(单位,X,Y,方向,速度,碰撞范围,存活帧数) 该函数会返回弹幕单位
function CreateBullet takes unit Bullet, real X, real Y, real Face, real Speed, real Range, real MaxLifeTime returns unit
    set udg_Bullet_IndexMax = udg_Bullet_IndexMax+1 //从最高位申请数组空间
    
    call DisplayTimedTextToPlayer(Player(0),0,0,2,"最高位:"+I2S(udg_Bullet_IndexMax))
    
    set udg_Bullet[udg_Bullet_IndexMax] = Bullet
    set udg_Bullet_X[udg_Bullet_IndexMax] = X
    set udg_Bullet_Y[udg_Bullet_IndexMax] = Y
    set udg_Bullet_Face[udg_Bullet_IndexMax] = Face
    set udg_Bullet_Speed[udg_Bullet_IndexMax] = Speed/udg_FPS      //每秒移动的距离
    set udg_Bullet_Range[udg_Bullet_IndexMax] = Range/2            //碰撞半径
    
    set udg_Bullet_LifeTime[udg_Bullet_IndexMax] = 0               //存活帧数初始化
    set udg_Bullet_MaxLifeTime[udg_Bullet_IndexMax] = MaxLifeTime
    return Bullet
endfunction

function BulletInitialization takes nothing returns nothing
    call TimerStart(CreateTimer(), (1/udg_FPS), true, function BulletMove)
endfunction