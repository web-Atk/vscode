//up主 以天下为之笼 魔兽Jass教程（十二）触发器 
function con takes nothing returns boolean 
  return true 
endfunction 


function action takes nothing returns nothing 
  
  call BJDebugMsg("HelloWorld!!!") 

endfunction 


function jass4 takes nothing returns nothing 

  local trigger t1 = CreateTrigger() 
  call TriggerRegisterPlayerChatEvent(t1, Player(0), "1", true) 
  call TriggerAddCondition(t1, Condition(function con)) 
  call TriggerAddAction(t1, function action) 


endfunction