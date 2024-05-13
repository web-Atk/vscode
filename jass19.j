////up主 庞各庄大棚 jass基础-哈希表存取值 
library demo initializer test 
    function test takes nothing returns nothing 
        local hashtable ht = InitHashtable() 
        // local integer i = 1 
        // local integer res
        // call SaveInteger(ht, 0, 0, i) 
        // call SaveInteger(ht, 0, 0, 2) 
        // set res = LoadInteger(ht,0,0)
        // call BJDebugMsg(I2S(i))
        local unit u = CreateUnit(Player(0),'hfoo',0,0,0)
        local unit res
        call SaveUnitHandle(ht,StringHash("单位"),0,u)    //可以通过StringHash(参数类型：字符串)把字符串转化为哈希值
        set res = LoadUnitHandle(ht,StringHash("单位"),0)
        
    endfunction 
endlibrary 