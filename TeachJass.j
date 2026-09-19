    globals
        boolean b = false
        unit u = null
        string s = "失败了"
    
    endglobals

    function CC takes nothing returns boolean
        return b
    endfunction


    function AA takes nothing returns nothing
        local item i = null
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local integer ID = 5 / 2
        if b == false then
            set b = true
            set u = CreateUnit(Player(0), 'Hpal', 0, 0, 0)
        endif

        if GetRandomInt (1, 2) == 1 then
            set i = CreateItem( 'I000', GetUnitX(u), GetUnitY(u)) 
        else
            call BJDebugMsg(s)
        endif
        call UnitAddItem(u, i)

    endfunction

    function BB takes unit u, real x, real y returns nothing
        local unit u1 = CreateUnit(Player(0), 'hpea', GetUnitX(u), GetUnitY(u), 0)
        if IssueBuildOrderById(u1, 'hpea', x, y) == true then
            call BJDebugMsg("成功了")
        else
            call BJDebugMsg("失败了")
        endif
        call KillUnit(u1)
    endfunction
