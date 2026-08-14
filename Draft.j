//这是一张函数草拟图，并不完整，仅供参考


library Draft

    globals 
        hashtable SysHash = InitHashtable()
    endglobals 

    //------------------------------------范围选取--------------------------------------


    //---------------------------------------------------------------------------------

    //------------------------------------冲锋<疾魔制作>--------------------------------------

    function SetTimerData takes timer t, integer data returns nothing
        call SaveInteger(SysHash, GetHandleId(t), 0, data)
    endfunction

    function GetTimerData takes timer t returns integer
        return LoadInteger(SysHash, GetHandleId(t), 0)
    endfunction

    private struct ChargeData
        unit caster //施法单位
        real UnitX //当前X轴
        real UnitY //当前Y轴
        real angle //冲锋角度
        real rate //速率
        real speed //步距
        real range //总距离
        real treeRange //树木检测范围
        real distance  //当前进度
        real height //最高跳跃高度
        real h0 //跳跃高度计算
        boolean trees //摧毁树木
        boolean touch //不计算碰撞
        boolean flight //无视地形
        boolean keep //是否前进
        pathingtype pathing //地形类型
        string EffectAddress //特效地址
        effect eff0 //特效
        string EffectPoint //附加点
        timer MoveTimer //计时器
        real Circle_X//圆心X
        real Circle_Y//圆心Y
        real Circle_R//圆半径
    endstruct

    private struct Charge extends ChargeData
        static method create takes unit c, real rt, real ang, real rng, real hgt, boolean tres, boolean tch, boolean flt, string eff, string point returns Charge
            local Charge this = Charge.allocate() //分配内存

            //初始化成员变量
            set this.caster = c //施法单位
            set this.UnitX = GetUnitX(c) //当前X轴
            set this.UnitY = GetUnitY(c) //当前Y轴
            set this.angle = ang //冲锋角度
            set this.rate = rt //速率
            set this.speed = this.rate / 50 //步距
            set this.range = rng //总距离
            set this.height = hgt//最高跳跃高度
            set this.h0 = hgt * 4 - hgt * 4 * 2 //跳跃高度计算
            set this.treeRange = 100 //树木检测范围
            set this.distance = 0 //当前进度
            set this.trees = tres //摧毁树木
            set this.touch = tch //不计算碰撞
            set this.flight = flt //无视地形
            set this.keep = false //是否前进
            set this.EffectAddress = eff //特效地址
            set this.eff0 = null //特效
            set this.EffectPoint = point //附加点
            set this.MoveTimer = CreateTimer() 
            if this.flight == true then
                set this.pathing = PATHING_TYPE_FLYABILITY
            else
                set this.pathing = PATHING_TYPE_WALKABILITY
            endif
            call TimerStart(this.MoveTimer, 0.02, true, function Charge.onMove)
            call SetTimerData(this.MoveTimer, this)
            if this.height > 0 then
                call UnitAddAbility(this.caster, 'Amrf') 
                call UnitRemoveAbility(this.caster, 'Amrf') 
            endif
            return this
        endmethod

        private static method KillPickedTrees takes nothing returns nothing
            local destructable dst = GetEnumDestructable()
            local Charge this = Charge.EnumThis
            local integer array tretyp
            set tretyp[1] = 'ITtw' //冰封王座树木
            set tretyp[2] = 'ITtc' //冰封王座伞状树木
            set tretyp[3] = 'NTtc' //诺森德伞状树木
            set tretyp[4] = 'FTtw' //秋季树木
            set tretyp[5] = 'GTsh' //地底树木
            set tretyp[6] = 'LTlt' //夏季树木
            set tretyp[7] = 'JTct' //城邦枯树
            set tretyp[8] = 'JTtw' //达拉然遗迹树木
            set tretyp[9] = 'KTtw' //黑色城堡树木
            set tretyp[10] = 'ATtr' //白杨谷树木
            set tretyp[11] = 'ATtc' //白杨谷伞状树木
            set tretyp[12] = 'DTsh' //地下城树木
            set tretyp[13] = 'BTtw' //荒芜之地树木
            set tretyp[14] = 'BTtc' //贫瘠之地的伞状树木 
            set tretyp[15] = 'CTtr' //费尔伍德树木
            set tretyp[16] = 'CTtc' //费尔伍德伞状树木
            set tretyp[17] = 'YTwt'  //城邦冬树木
            set tretyp[18] = 'YTst' //城邦积雪树木
            set tretyp[19] = 'YTft' //城邦秋树木
            set tretyp[20] = 'YTct' //城邦夏树木
            set tretyp[21] = 'VTlt' //村庄树木
            set tretyp[22] = 'WTtw' //冬季树木
            set tretyp[23] = 'WTst' //积雪树木
            set tretyp[24] = 'NTtw' //诺森德树木
            set tretyp[25] = 'OTtw' //边缘之地树木
            if this.trees == true then
                call KillDestructable(dst)
            elseif this.flight == false then
                set this.keep = true
            endif
        endmethod

        static Charge EnumThis

        private static method FilterCircle takes nothing returns boolean
            local real dx = GetDestructableX(GetFilterDestructable()) - Charge.EnumThis.Circle_X
            local real dy = GetDestructableY(GetFilterDestructable()) - Charge.EnumThis.Circle_Y
            return dx * dx + dy * dy <= Charge.EnumThis.Circle_R * Charge.EnumThis.Circle_R   
        endmethod


        private method EnumTreesInCircle takes real x, real y, real r, code callback returns nothing
            local rect rectArea
            set rectArea = Rect(x - r, y - r, x + r, y + r)
            set this.Circle_X = x
            set this.Circle_Y = y
            set this.Circle_R = r
            set Charge.EnumThis = this
            // 保存xy和r
            call EnumDestructablesInRect(rectArea, Filter(function thistype.FilterCircle), callback)
            call RemoveRect(rectArea)
        endmethod

        private static method onMove takes nothing returns nothing
            local timer tmr = GetExpiredTimer()
            local Charge this = GetTimerData(tmr)
            local real NewX = GetUnitX(this.caster) + this.speed * (CosBJ(this.angle)) 
            local real NewY = GetUnitY(this.caster) + this.speed * (SinBJ(this.angle)) 
            local real h1 = 0
            local real h2 = 0
            set this.distance = this.distance + this.speed
            set this.keep = IsTerrainPathable(NewX, NewY, this.pathing)
            call this.EnumTreesInCircle(NewX, NewY, this.treeRange, function thistype.KillPickedTrees)
            if this.height > 0 then
                set h1 = this.h0 / Pow(this.range, 2) 
                set h2 = h1 * this.distance * (this.distance - this.range) 
                call SetUnitFlyHeight(this.caster, h2, 0) 
            endif
            if this.keep == false then
                call SetUnitX(this.caster, NewX)
                call SetUnitY(this.caster, NewY)    
                if this.EffectAddress != "" and this.eff0 == null and this.EffectPoint != null then
                    set this.eff0 = AddSpecialEffectTarget(this.EffectAddress, this.caster, this.EffectPoint)
                elseif this.EffectAddress != "" and this.EffectPoint == null then
                    call DestroyEffect(this.eff0)
                    set this.eff0 = AddSpecialEffect(this.EffectAddress, NewX, NewY)
                endif            
            endif
            if this.distance >= this.range or this.keep == true then
                call this.destroy()
            endif
        endmethod

        method destroy takes nothing returns nothing
            call SetUnitFlyHeight(this.caster, 0, 0) 
            call DestroyEffect(this.eff0)
            call DestroyTimer(this.MoveTimer)
            set this.MoveTimer = null
            set this.caster = null
            call this.deallocate()
        endmethod

    endstruct

    //冲锋（单位、速率、角度、距离、高度、是否摧毁树木、是否忽略碰撞、是否无视地形、特效路径、附加点）
    function JMcharge takes unit u0, integer rate, real angle, real range, real height, boolean trees, boolean touch, boolean flight, string eff, string point returns nothing
        call Charge.create(u0, rate, angle, range, height, trees, touch, flight, eff, point)
    endfunction

    //-------------------------------------------------------------------------------------
    
    //创建测试单位
    function TestUnit takes nothing returns nothing 
        set hero = CreateUnit(Player(0), 'E000', -636.7, -341.6, 90) 
        call UnitAddItemByIdSwapped('ratf', hero)
        call UnitAddItemByIdSwapped('bgst', hero)
        call UnitAddItemByIdSwapped('hcun', hero)
        call UnitAddItemByIdSwapped('evtl', hero)
        call UnitAddItemByIdSwapped('bspd', hero)
        call UnitAddItemByIdSwapped('rde1', hero)
        call BJDebugMsg("创建测试单位成功")
    endfunction 

endlibrary