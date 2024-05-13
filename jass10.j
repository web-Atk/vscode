////up主 庞各庄大棚 魔兽地图编辑器Jass教程基础篇  
library demo initializer test 
    function test takes nothing returns nothing 
        local string a = "0.123456789" 
        local string c = SubString(a,0,2) 
        call BJDebugMsg(c)//= 01 
        // local boolean a = true 
        // local boolean b = false 
        // local boolean c = not b //表达式符号优先级：布尔运算符＜比较运算符＜算术运算符
        // // 算术运算符（+ - * /）＞ 比较运算符（> <）＞ 布尔运算符（= and or）
        // if c then 
        //     call BJDebugMsg("true") 
        // else 
        //     call BJDebugMsg("false") 
        // endif 

    endfunction 
endlibrary 
