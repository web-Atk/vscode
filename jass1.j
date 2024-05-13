#ifndef BJDebugMsg
#define BJDebugMsgInclude
// library JhLib  
// function UnitDamagePointLocInclude takes unit whichUnit, real delay, real radius, real x, real y, real amount, boolean attack, boolean ranged, attacktype attackType, damagetype damageType, weapontype weaponType returns boolean  
//     return true  
// endfunction  
function BJDebugMsgInclude takes string msg returns nothing
    local integer i = 0
    loop
        call DisplayTimedTextToPlayer(Player(i), 0, 0, 60, msg)
        set i = i + 1
        exitwhen i == bj_MAX_PLAYERS
    endloop
endfunction 
// endlibrary  


// UnitDamagePoint  
// UnitDamagePointLoc  
#endif 
