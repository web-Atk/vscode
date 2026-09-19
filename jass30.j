library AA initializer initB 

    globals
        hashtable ProjHash = InitHashtable()
        timer ProjTimer
        constant integer TRAJ_LINEAR = 1
        constant integer TRAJ_RECOIL = 2
        constant integer TRAJ_HOMING = 3
        constant integer TRAJ_CURVE = 4
        constant integer TRAJ_PARABOLA = 5
    endglobals
      
    private struct ProjBase
        //-------核心属性--------
        unit proj //弹幕本体
        unit source //弹幕归属
        integer projLvl //弹幕等级
        integer trajType //轨迹类型
        integer phase //阶段
        integer staFlags //状态
        //-------伤害属性--------
        real phyDmg //物理伤害
        real magDmg //魔法伤害
        real phyCrit //物理暴击
        real magCrit //魔法暴击
        damagetype dmgType //伤害类型integer
        real dmgFall //伤害衰减
        //-------运动属性--------
        real pz //Z坐标
        real curSpd //当前速度
        real accel //加速度
        real maxSpd //最大速度
        real maxRng //最大射程
        real travDist //已飞行距离
        //-------碰撞/穿透--------
        real colRng //碰撞半径
        group hitGrp //命中组
        integer maxTgt //最大目标数
        real penPow //穿透力
        boolean destTrees //伐树
        integer effFlags //命中特效
        //-------返回型轨迹--------
        real retSpd //返回速度
        real retDmg //返回伤害
        real retRng //返回半径
        //-------追踪型轨迹--------
        unit tgtUnit //目标单位
        //-------曲线型轨迹--------
        real curvPar //曲线参数
        real curvEnd //曲线终点

        integer index
        integer life
        integer maxLife
        
        // real iniSpd //初速度
        static ProjBase array pool
        static integer count = 0

        // static method onInit takes nothing returns nothing
        //     call ProjInit()
        // endmethod
        
        //添加到对象池
        static method addToPool takes ProjBase p returns nothing
            set.count = .count + 1
            set p.index = .count
            set.pool[.count] = p
        endmethod

        //从对象池中移除
        method removeFromPool takes nothing returns nothing
            local ProjBase last
            if this.index < ProjBase.count then
                set last = ProjBase.pool[ProjBase.count]
                set ProjBase.pool[this.index] = last
                set last.index = this.index
            endif
            set ProjBase.pool[ProjBase.count] = 0
            set ProjBase.count = ProjBase.count - 1
            call this.destroy()
            set last = 0
        endmethod

    endstruct

    //直线
    private struct Linear extends ProjBase

        //创建弹幕实例
        static method create takes unit u1, integer lv, integer traj, real pDmg, real mDmg, real pCrit/*
            */, real mCrit, real falloff, real pz, real spd, real acc, real maxSpd, real range /*
            */, real dist, real rad, group hitGrp, integer maxHit, real pen, boolean tree, integer fx returns thistype
            local thistype p = thistype.allocate()

            set p.proj = u1
            set p.projLvl = lv
            set p.trajType = traj
            set p.phyDmg = pDmg
            set p.magDmg = mDmg
            set p.phyCrit = pCrit
            set p.magCrit = mCrit
            set p.dmgFall = falloff
            set p.pz = pz
            set p.curSpd = spd
            set p.accel = acc
            set p.maxSpd = maxSpd
            set p.maxRng = range
            set p.travDist = dist
            set p.colRng = rad
            set p.hitGrp = hitGrp
            set p.maxTgt = maxHit
            set p.penPow = pen
            set p.destTrees = tree
            set p.effFlags = fx
            
            call ProjBase.addToPool(p)
            
            return p
        endmethod
        
        
        
        //弹幕移动
        method move takes nothing returns nothing
            local real x = GetUnitX(this.proj)
            local real y = GetUnitY(this.proj)
            local real z = this.pz 
            local real ang = GetUnitFacing(this.proj) * 0.017453292
            local real spd = this.curSpd
            if this.maxRng < spd then
                set spd = this.maxRng
                set this.maxRng = 0
            else
                set this.maxRng = this.maxRng - spd
            endif
            set x = x + Cos(ang) * spd
            set y = y + Sin(ang) * spd
            call SetUnitX(this.proj, x)
            call SetUnitY(this.proj, y)
            // set this.travDist = this.travDist + spd
            call BJDebugMsg(R2S(this.maxRng))
            if this.maxRng <= 0 then
                call this.removeFromPool()
            endif
            return
        endmethod
        
    endstruct

    //返回
    private struct Recoil extends ProjBase 
    endstruct

    //追踪
    private struct Homing extends ProjBase 
    endstruct

    //曲线
    private struct Curve extends ProjBase 
    endstruct

    //抛物线
    private struct Parabola extends ProjBase 
    endstruct

    //以后所有弹幕更新都在这里
    function ProjUpdate takes nothing returns nothing
        local integer i = 1
        local ProjBase p
        loop
            exitwhen i > ProjBase.count
            set p = ProjBase.pool[i]
            if p.trajType == TRAJ_LINEAR then
                call Linear(p).move()
            elseif p.trajType == TRAJ_RECOIL then
                // call Recoil(p).move()
            elseif p.trajType == TRAJ_HOMING then
                // call Homing(p).move()
            elseif p.trajType == TRAJ_CURVE then
                // call Curve(p).move()
            elseif p.trajType == TRAJ_PARABOLA then
                // call Parabola(p).move()
            endif
            set i = i + 1
        endloop

    endfunction

    //初始化弹幕计时器
    function ProjInit takes nothing returns nothing
        set ProjTimer = CreateTimer()
        call TimerStart(ProjTimer, 0.02, true, function ProjUpdate)
    endfunction

    //发射直线弹幕
    function SpawnLinear takes unit u0, integer lv, integer traj, real pDmg, real mDmg, real pCrit/*
        */, real mCrit, real falloff, real pz, real spd, real acc, real maxSpd, real range/*
        */, real dist, real rad, group hitGrp, integer maxHit, real pen, boolean tree, integer fx returns nothing
        call Linear.create(u0, lv, traj, pDmg, mDmg, pCrit, mCrit, falloff, pz, spd, acc, maxSpd, range, dist, rad, hitGrp, maxHit, pen, tree, fx)
    endfunction


    //----------------------------------------------------------------------------------------------------------------------------------------------

    function spell takes nothing returns nothing
        local unit u0 = GetTriggerUnit()
        local unit u2
        local real ux1 = GetUnitX(u0)
        local real uy2 = GetUnitY(u0)
        local real ax1 = GetSpellTargetX() 
        local real ay2 = GetSpellTargetY()
        local integer ab0 = GetSpellAbilityId()
        local real angle = bj_RADTODEG * Atan2(ay2 - uy2, ax1 - ux1) //技能释放方向  
        if ab0 == 'ANcl' then  
            set u2 = CreateUnit(GetOwningPlayer(u0), 'ewsp', ux1, uy2, angle)
            call SetUnitX(u2, ux1 + Cos(angle * bj_DEGTORAD) * 40)
            call SetUnitY(u2, uy2 + Sin(angle * bj_DEGTORAD) * 40)
            call SpawnLinear(u2, 1, TRAJ_LINEAR, 100, 0, 0, 0, 0, 0, 20, 0, 20, 800, 0, 50, null, 1, 0, false, 0)          
        endif
    endfunction

    function initB takes nothing returns nothing 
        local trigger trg = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(trg, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddAction(trg, function spell)
        call ProjInit()
    endfunction 

endlibrary