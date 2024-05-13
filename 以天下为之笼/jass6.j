//up主 以天下为之笼 魔兽Jass教程（十四）排泄 
// local handle h1 = CreateItem('rate6',0,0) 
// local handle h2 = CreateIUnit(player(0),'hpea',0,0,0) 
// local timer timer1 = CreateTimer() 
// local hashtable table1 = InitHashtable() 
// local trigger trigger1 = CreateTrigger() 
// local location location1 = location(0,0) 
// local effect effect1 = AddSpecialEffectLocBJ(location1,"Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl") 

function jass6 takes nothing returns nothing 
    // local handle h1 = CreateItem('rat6',0,0) 
    // local handle h2 = CreateUnit(Player(0),'hpea',0,0,0) 
    // local item item1 = CreateItem('rat6',0,0) 
    // local unit unit1 = CreateUnit(Player(0),'hpea',0,0,0) 

    // set h1 = null 
    // set h2 = null 

    // set item1 = null 
    // set unit1 = null 

    // local timer timer1 = CreateTimer() 

    // call DestroyTimer(timer1) 
    // set timer1 = null 

    // local hashtable table1 = InitHashtable() 

    // call FlushChildHashtable(table1,1) 
    // call FlushParentHashtable(table1) 

    // local trigger trigger1 = CreateTrigger() 

    // call DestroyTrigger(trigger1) 

    local location location1 = Location(0, 0) 
    local effect effect1 = AddSpecialEffectLocBJ(location1, "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl") 

    call RemoveLocation(location1) 
    call DestroyEffect(effect1) 

    set location1 = null 
    set effect1 = null 

endfunction