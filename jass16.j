////up主 庞各庄大棚 jass基础-条件语句和循环语句             
library demo initializer test 
    function test takes nothing returns nothing 
        // if not IsFogEnabled() then  //not的用法，是否有战争，不是假的             
        //     call FogEnable(false)             
        //     call BJDebugMsg("迷雾已清除")             
        // endif             
        // if IsFogMaskEnabled() then             
        //     call FogMaskEnable(false)             
        // endif             
        // local integer i = 0             
        // loop             
        //     call BJDebugMsg(I2S(i))             
        //     set i = i +1             
        //     exitwhen i == 10  //退出循环出口可以放在任意位置，居然看你想要实现的效果             
        // endloop             
        // local integer i = 0             
        // local integer j = 0             
        // loop                      //嵌套式循环            
        //     exitwhen i == 10             
        //     set j = 0             //重置内层的循环整数才能让它循环100次，嵌套式循环是优先执行内层循环，再慢慢从扩展到外层            
        //     loop             
        //         exitwhen j == 10             
        //         call BJDebugMsg("-----------")            
        //         set j = j + 1             
        //     endloop             
        //     set i = i + 1             
        // endloop             
        // * * * * *                 //拼一段字符串：星+空格+星.......         
        // local string s = "*"          
        // local string space = " "          
        // local string res = ""          
        // local integer i = 0          
        // loop          
        //     exitwhen i == 9          
        //     if ModuloInteger(i, 2) == 0 then   //因为i是从零开始，所以判断为偶数则加一颗星，否则则插入空格         
        //         set res = res + s          
        //     else          
        //         set res = res + space          
        //     endif          
        //     set i = i + 1          
        // endloop          
        // call BJDebugMsg(res)          

        //        *         
        //       ***         
        //      *****         
        //     *******         
        //    *********         

        //   1  1  4     
        //   2  3  3     
        //   3  5  2  2n + 1     
        //   4  7  1     
        //   5  9  0  4-n     
        local string s = "*" 
        local string space = " " 
        local string n = "\n" //换行符      
        local string res = "" 

        local integer i = 0 
        local integer j = 0 
        loop 
            exitwhen i == 5 
            set j = 0 
            loop 
                exitwhen j == 9 
                if j < 4 - i then 
                    set res = res + space 
                elseif j < i + 5 then 
                    set res = res + s 
                endif 
                set j = j + 1 
            endloop 
            set res = res + n 
            set i = i + 1 
        endloop 
        call BJDebugMsg(res) 

        //        *         
        //       ***         
        //      *****         
        //     *******         
        //    *********   
        //     *******     
        //      *****         
        //       ***         
        //        *         
    endfunction 
endlibrary 