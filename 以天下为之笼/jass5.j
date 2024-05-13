//up主 以天下为之笼 魔兽Jass教程（十三）计时器 
globals 

    timer tm1 = CreateTimer() 

endglobals 

function action takes nothing returns nothing 

    call BJDebugMsg("五秒过去了！") 

    call DestroyTimer(tm1) 

endfunction 

function jass5 takes nothing returns nothing 

    //local timer tm1 = CreateTimer() 

    call TimerStart(tm1, 5, false, function action) 

endfunction