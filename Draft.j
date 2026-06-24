//这是一张函数草拟图，并不完整，仅供参考


library Draft

    // globals 
    //     hashtable SysHash = InitHashtable()
    // endglobals 

    
    
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