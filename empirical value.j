//模拟经验系统 
library Exp initializer InitTrig_Exp //击杀单位获得经验 
    globals 
        trigger gg_trg_Exp 

    endglobals 

    function SetTextTagShowToPlay takes texttag tag, real r1, player p1 returns nothing 
        local force pls = CreateForce() 
        call ForceAddPlayer(pls, p1) 
        call SetTextTagLifespan(tag, r1) 
        call SetTextTagVisibility(tag, false) 
        call ShowTextTagForceBJ(true, tag, pls) 
        call DestroyForce(pls) 
        set pls = null 
    endfunction 

    function Trig_Exp_Conditions takes nothing returns boolean 
        local texttag tag = null 
        local integer Exp = GetUnitPointValue(GetDyingUnit()) 
        local location loc = null 
        if IsUnitType(GetKillingUnit(), UNIT_TYPE_HERO) and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(GetKillingUnit())) then 
            set tag = CreateTextTag() 
            set loc = GetUnitLoc(GetKillingUnit()) 
            call AddHeroXP(GetKillingUnit(), GetUnitPointValue(GetDyingUnit()), true) 
            call SetTextTagText(tag, "|cFF993300+ Exp " + I2S(Exp) + "|r", TextTagSize2Height(10)) 
            call SetTextTagPermanent(tag, false) 
            call SetTextTagPos(tag, GetLocationX(loc) -50, GetLocationY(loc) + 50, 100.00) 
            call SetTextTagVelocityBJ(tag, 64, 90) 
            call SetTextTagShowToPlay(tag, 1.00, GetOwningPlayer(GetKillingUnit())) 
        endif 
        call RemoveLocation(loc) 
        set loc = null 
        set tag = null 
        return false 
    endfunction 


    //=========================================================================== 
    function InitTrig_Exp takes nothing returns nothing 
        set gg_trg_Exp = CreateTrigger() 
        call YDWESaveTriggerName(gg_trg_Exp, "Exp") 
        call TriggerRegisterAnyUnitEventBJ(gg_trg_Exp, EVENT_PLAYER_UNIT_DEATH) 
        call TriggerAddCondition(gg_trg_Exp, Condition(function Trig_Exp_Conditions)) 
    endfunction 


endlibrary