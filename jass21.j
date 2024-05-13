////up主 庞各庄大棚 jass基础-数组 
library demo initializer test 
    // function aaa takes integer array arr returns nothing 
    //     call BJDebugMsg("-------------") 
    // endfunction 
    function test takes nothing returns nothing 
        local integer array arr 
        local integer array myArr 
        local integer i 
        local integer res 
        set arr[0] = 1 
        set arr[1] = 2 
        set arr[88] = 2 
        set arr[99] = 2 
        //    set i = arr[0] 
        //    set i = arr[1] 
        //    call aaa(arr) 
        //    set arr = myArr 
        loop 
            exitwhen i == 100 
            if arr[i] != 0 then 
                set res = arr[i] 
            endif 
            set i = i + 1 
        endloop 
    endfunction 
endlibrary 