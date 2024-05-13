////up主 庞各庄大棚 jass基础-单位组和玩家组     
library demo initializer test 
    function aaa takes nothing returns nothing   
        local unit u = GetEnumUnit()   
        call BJDebugMsg(GetUnitName(u))   
    endfunction   
    function bbb takes nothing returns nothing
        local player p = GetEnumPlayer()
        call BJDebugMsg(GetPlayerName(p))
        // call ForceRemovePlayer(p)
    endfunction
    function test takes nothing returns nothing 
        //     local unit un   
        //     local group g = CreateGroup()   
        //     local unit u = CreateUnit(Player(0), 'hfoo', 0, 0, 0)   
        //     local unit u2 = CreateUnit(Player(0), 'hgry', 2, 0, 0)   
        //     local unit u3 = CreateUnit(Player(0), 'hkni', 4, 0, 0)   
        //     local unit u4 = CreateUnit(Player(0), 'hmtm', 6, 0, 0)   
        //     local unit u5 = CreateUnit(Player(0), 'hmpr', 8, 0, 0)   
        //     call GroupAddUnit(g, u)   
        //     call GroupAddUnit(g, u2)   
        //     call GroupAddUnit(g, u3)   
        //     call GroupAddUnit(g, u4)   
        //     call GroupAddUnit(g, u5)   

        //     // call GroupRemoveUnit(g,u)     
        //     // call ForGroup(g, function aaa)  
        //     loop  
        //         set un = FirstOfGroup(g)  
        //         exitwhen un == null  
        //         call BJDebugMsg(GetUnitName(un))  
        //         call GroupRemoveUnit(g,un)   
        //     endloop   
        local force f = CreateForce() 
        call ForceAddPlayer(f,Player(1)) 
        call ForceAddPlayer(f,Player(2)) 
        call ForceAddPlayer(f,Player(3)) 
        call ForceAddPlayer(f,Player(4)) 
        call ForForce(f, function bbb) 
    endfunction 
endlibrary 