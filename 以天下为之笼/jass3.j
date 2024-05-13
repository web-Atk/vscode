//up主 以天下为之笼 魔兽Jass教程（十一）哈希表 
globals 

  hashtable A = InitHashtable() 

endglobals 


function jass3 takes nothing returns nothing 

  call SaveInteger(A, 1, 1, 100) 

  call SaveBoolean(A, 1, 2, true) 

  call SaveStr(A, 1, 3, "HelloWorld") 

  call BJDebugMsg(I2S(LoadInteger(A, 1, 1))) 

  call BJDebugMsg(LoadStr(A, 1, 3)) 



endfunction