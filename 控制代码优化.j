/*
晕眩系统 
CtrUt(unit,real,integer)
1是晕眩
2是冰冻
3是缠绕
*/
globals
hashtable KzHs=InitHashtable()
endglobals
function CtrUt1 takes nothing returns nothing
local timer tm=GetExpiredTimer()
local integer tp=GetHandleId(tm)
local unit u=LoadUnitHandle(KzHs,tp,1)
local integer up=GetHandleId(u)
local integer b=LoadInteger(KzHs,tp,2)
call SaveInteger(KzHs,tp,3,LoadInteger(KzHs,tp,3)-1)/*局部特效计数*/
call SaveInteger(KzHs,up,1,LoadInteger(KzHs,up,1)-1)/*总控制计数*/
call DisplayTextToPlayer( Player(0), 0, 0,I2S(LoadInteger(KzHs,up,1))+"-"+I2S(LoadInteger(KzHs,tp,3)))
if(LoadInteger(KzHs,tp,3)<=0)then
    call DestroyEffect( LoadEffectHandle(KzHs,tp,4))
    call FlushChildHashtable(KzHs,tp)
    call DestroyTimer(tm)
endif
if(LoadInteger(KzHs,up,1)<=0)then
    call SetUnitTimeScalePercent( u, 100 )
    call PauseUnitBJ( false, u )
    call DisplayTextToPlayer( Player(0), 0, 0,"解除")
endif
if(IsUnitDeadBJ(u)==true)then
    call SetUnitTimeScalePercent( u, 100 )
    call PauseUnitBJ( false, u )
    call DestroyEffect( LoadEffectHandle(KzHs,tp,4))
    call DestroyTimer(tm)
    call FlushChildHashtable(KzHs,tp)
    call FlushChildHashtable(KzHs,up)
endif
set u=null
set tm=null
endfunction 
function CtrUt takes unit u,real t,integer b returns nothing
local timer tm=CreateTimer()
local integer tp=GetHandleId(tm)
local integer up=GetHandleId(u)
local integer ft=R2I(t/0.04)
call SaveInteger(KzHs,tp,3,ft)
call SaveInteger(KzHs,up,1,LoadInteger(KzHs,up,1)+ft)
if(b==1)then
    call AddSpecialEffectTargetUnitBJ( "overhead",u,"Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl" )
    call SaveEffectHandle(KzHs,tp,4,GetLastCreatedEffectBJ())
elseif(b==2)then
    call AddSpecialEffectTargetUnitBJ( "origin",u,"Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl" )
    call SaveEffectHandle(KzHs,tp,4,GetLastCreatedEffectBJ())
elseif(b==3)then
    call AddSpecialEffectTargetUnitBJ( "origin",u,"Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl" )
    call SaveEffectHandle(KzHs,tp,4,GetLastCreatedEffectBJ())
endif
call SaveUnitHandle(KzHs,tp,1,u)
call SaveInteger(KzHs,tp,2,b)
call SetUnitTimeScalePercent( u, 0.00 )
call PauseUnitBJ( true, u )
call TimerStart(tm,0.04,true,function CtrUt1)
set tm=null
set u=null
endfunction