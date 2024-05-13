library a initializer init_a 

    globals 
        hashtable hash_test = InitHashtable() 
    endglobals 

    


    function tl_act takes nothing returns nothing 

        //local real sh LoadReal (hash_test,GetHandleId(GetExpiredTimer()),StringHash("伤害值")) 
        local unit u1 = LoadUnitHandle(hash_test, GetHandleId(GetExpiredTimer()), StringHash("伤害者")) 
        //local unit m LoadUnitHandle(hash_test,GetHandleId(GetExpiredTimer()),StringHash("受害者")) 
        //call BJDebugMsg(R2S(sh)+"|"+GetUnitName(u1)+"|"+GetUnitName(m)) 
        call FlushChildHashtable(hash_test, GetHandleId(GetExpiredTimer())) 
        call DestroyTimer(GetExpiredTimer()) 
        set u1 = null 
        local force foc = GetPlayersAll 
        call DestroyForce 
        //set m = null 

    endfunction 

    function init_a takes nothing returns nothing 
        local unit u1 = GetTriggerUnit() 
        local unit m = GetSpellAbilityUnit() 
        local timer t1 
        local real sh 
        set sh = GetHeroInt(u1, false) + 19.00 
        set t1 = CreateTimer() 

        call SaveReal(hash_test, GetHandleId(t1), StringHash("伤害值"), sh) 

        call SaveStr(hash_test, GetHandleId(t1), StringHash("字符"), "2333333") 

        call SaveUnitHandle(hash_test, GetHandleId(t1), StringHash("伤害者"), u1) 
        call SaveUnitHandle(hash_test, GetHandleId(t1), StringHash("受害者"), m) 

        call TimerStart(t1, 1.00, false, function tl_act) 

        set t1 = null 
        set u1 = null 
        set m = null 

    endfunction 


endlibrary 
    