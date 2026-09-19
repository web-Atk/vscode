//这是一张函数草拟图，并不完整，仅供参考


library Draft initializer TestUnit

    globals 
        hashtable AveHash = InitHashtable()
    endglobals 

    function AA takes nothing returns nothing
    endfunction

    //------------------------------------扇形选取--------------------------------------

   //扇形选取
    function PickSector takes real face, real ax, real ay, real angle, real range, code callback returns nothing
        local real ux
        local real uy
        local real ang0 
        local real check
        local real rng0 = range + 50
        local unit target
        local group ugp0 = CreateGroup()
        local group ugp1 = CreateGroup()
        set face = ModuloReal(face + 360,360)
        call GroupEnumUnitsInRange(ugp0, ax, ay, rng0, null)
        loop
            set target = FirstOfGroup(ugp0) 
            exitwhen target == null 
            set ux = GetUnitX(target)
            set uy = GetUnitY(target)
            set ang0 = ModuloReal(bj_RADTODEG * Atan2(uy - ay, ux - ax) + 360,360) 
            set check = 180 - (RAbsBJ(180 - RAbsBJ(ang0 - face)))
            if IsUnitInRangeXY(target,ax,ay,range) and check <= angle / 2 then
                call GroupAddUnit(ugp1, target)
            endif
            call GroupRemoveUnit(ugp0, target) 
        endloop
        call DestroyGroup(ugp0)
        call ForGroup(ugp1,callback)
        call DestroyGroup(ugp1)
    endfunction



    //---------------------------------------------------------------------------------

    
    
    //创建测试单位
    function TestUnit takes nothing returns nothing 
        set hero = CreateUnit(Player(0), 'Npbm', -636.7, -341.6, 90) 
        call SelectHeroSkill(hero, 'ANbf')
        call UnitAddItemByIdSwapped('ratf', hero)
        call UnitAddItemByIdSwapped('bgst', hero)
        call UnitAddItemByIdSwapped('hcun', hero)
        call UnitAddItemByIdSwapped('evtl', hero)
        call UnitAddItemByIdSwapped('bspd', hero)
        call UnitAddItemByIdSwapped('rde1', hero)
    endfunction 

    
endlibrary