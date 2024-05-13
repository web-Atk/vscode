//up主 ギ泠神ジ 魔兽地图编辑器Jass从萌新到大佬（三） 
library timers initializer Init_timers 
    globals 
        private timer t = CreateTimer() 
        private real totleTime = 0.00 
    endglobals 

    function HandleCenterTimer takes real s, boolean b, string c returns nothing 
        if ModuloReal(totleTime, s) == 1 and totleTime >= s then 
            call ExecuteFunc(c) 
        endif 
    endfunction 

    function Timer1 takes nothing returns nothing 
        call BJDebugMsg("一秒过去了") 
    endfunction 

    function Timer3 takes nothing returns nothing 
        call BJDebugMsg("三秒过去了") 
    endfunction 

    function CenterTimer takes nothing returns nothing 
        set totleTime = totleTime + 0.01 
        call HandleCenterTimer(1, true, "Timer1") 
        call HandleCenterTimer(3, true, "Timer3") 
    endfunction 

    function Init_timers takes nothing returns nothing 
        call TimerStart(t, 0.01, true, function CenterTimer) 
    endfunction 


endlibrary