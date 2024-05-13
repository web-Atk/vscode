//位移建筑判断法 
//X坐标偏移 
function MUYE_GetUnitX takes real q, real w, real e returns real 
    return(q + w * CosBJ(e)) 
endfunction 
//Y坐标偏移 
function MUYE_GetUnitY takes real q, real w, real e returns real 
    return(q + w * SinBJ(e)) 
endfunction 
//单位坐标位移 
function MUYE_unit_MoveXY_1 takes unit u, real q, real w returns nothing 
    call SetUnitX(u, MUYE_GetUnitX(GetUnitX(u), q, w)) 
    call SetUnitY(u, MUYE_GetUnitY(GetUnitY(u), q, w)) 
endfunction 
//布尔值建造法单位坐标位移 
function MUYE_unit_MoveXY_2 takes unit u, integer u2, real q, real w returns nothing 
    local boolean b 
    local real x = MUYE_GetUnitX(GetUnitX(u), q, w) 
    local real y = MUYE_GetUnitY(GetUnitY(u), q, w) 
    local unit u = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), u2, x, y, 0) 
    call UnitAddAbility(u, 'Aeth') 
    set b = IssueBuildOrderById(u, GetUnitTypeId(u), x, y) 
    if b == true then 
        call MUYE_unit_MoveXY_1(u, q, w) 
        call UnitRemoveAbility(u, 'Aeth') 
    endif 
    set u = null 
endfunction 


