//up：庞各庄大棚  jass基础-基础数据类型 
library demo initializer test 
    function test takes nothing returns nothing 
        local integer i = 2147483648 
        local integer ii 
        local integer iii 
        local integer iiii = 'Aply' 
        local real r = 2.5 
        local boolean b = true 
        local string s = "这是\n字\r符串" 
        local string ss = "这是\"字\"符串" 
        local string sss = "这是'字'符串" 
        local string ssss = "这是\\字符串" 
        local string sssss = "这是|cffcc1110字符串" 
        local string ssssss = "这是|cffcc1110字|r符串" 
        local string sssssss = "这" 
        set ii = S2I(sssssss) 
        set iii = R2I(r) 
        call BJDebugMsg(I2S(iiii)) 
    endfunction 
endlibrary 
//快捷键：在光标区域切换下一行用Ctrl+ 回车 切换至上一行用Ctrl+ shift +回车  快速删除一行是Ctrl + shift + K 
//快捷键：复制指定一行代码，shift + Alt + ↓  移动光标所指定该行代码，Alt + ↑ 或 Alt + ↓ 
//快捷键：对齐，shift + Alt + F 
