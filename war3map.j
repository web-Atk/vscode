globals
//globals from MultiPageInventorySystem:
constant boolean LIBRARY_MultiPageInventorySystem=true
integer array MultiPageInventorySystem___unitPage
integer array MultiPageInventorySystem___unitPagesMax
unit array MultiPageInventorySystem___invUnit
location MultiPageInventorySystem___itemSaveLoc= GetRectCenter(GetPlayableMapRect())
//endglobals from MultiPageInventorySystem
    // User-defined
integer udg_UDexWasted= 0
integer udg_UDex= 0
integer array udg_UDexNext
integer array udg_UDexPrev
boolean array udg_IsUnitPreplaced
real udg_UnitIndexEvent= 0
unit array udg_UDexUnits
integer udg_UDexRecycle= 0
integer udg_UDexGen= 0
boolean udg_UnitIndexerEnabled= false
integer array udg_InvAbility
integer udg_InvAbilitiesTotal= 0
hashtable udg_InvHash= null
string udg_InvHotkeyLeft
string udg_InvHotkeyRight

    // Generated
trigger gg_trg_Unit_Indexer= null
trigger gg_trg_Inventory_System_Setup= null
trigger gg_trg_Init= null
trigger gg_trg_Change_owner= null
trigger gg_trg_Inventory_descriptions= null
unit gg_unit_Oshd_0311= null
unit gg_unit_Edem_0243= null
unit gg_unit_Emoo_0242= null
unit gg_unit_Hblm_0165= null
unit gg_unit_hpea_0000= null
unit gg_unit_hfoo_0106= null


//JASSHelper struct globals:

endglobals


//library MultiPageInventorySystem:

	//----------------------------------------------\\
	//                                              \\
	//  Multi-page Inventory System                 \\
	//  Version 1.0.10                              \\
	//  Written by Rahko / Sabeximus#2923           \\
	//                                              \\
	//----------------------------------------------\\


 function InventoryButtonsSetPageText takes player whichPlayer,string s returns nothing
		if GetLocalPlayer() == whichPlayer then
			call BlzFrameSetText(BlzGetFrameByName("ScriptDialogButton", 102), s)
		endif
	endfunction

 function SaveInventory takes nothing returns nothing
  local player p= GetTriggerPlayer()
  local integer id= GetConvertedPlayerId(p)
  local integer parentKey= GetHandleId(MultiPageInventorySystem___invUnit[id])
  local integer key= GetUnitUserData(MultiPageInventorySystem___invUnit[id])
  local integer currentPage= MultiPageInventorySystem___unitPage[key]
  local integer maxPages= MultiPageInventorySystem___unitPagesMax[key]
  local integer n= 1
  local integer i= 1
		
		loop
			if ( n == currentPage ) then
				loop
					call SaveItemHandle(udg_InvHash, parentKey, ( i - 1 ) + n * 6, UnitItemInSlotBJ(MultiPageInventorySystem___invUnit[id], i))
					set i=i + 1
					exitwhen i > 6
				endloop
			endif
			set n=n + 1
			exitwhen n > maxPages
		endloop

		set p=null
	endfunction

 function LoadInventory takes nothing returns nothing
  local player p= GetTriggerPlayer()
  local integer id= GetConvertedPlayerId(p)
  local integer parentKey= GetHandleId(MultiPageInventorySystem___invUnit[id])
  local integer key= GetUnitUserData(MultiPageInventorySystem___invUnit[id])
  local integer currentPage= MultiPageInventorySystem___unitPage[key]
  local integer maxPages= MultiPageInventorySystem___unitPagesMax[key]
  local integer n= 1
  local integer i= 1
  local item oldItem= null
  local item newItem= null
		loop
			if ( n == currentPage ) then
				loop
					set oldItem=UnitItemInSlotBJ(MultiPageInventorySystem___invUnit[id], i)
					set newItem=LoadItemHandle(udg_InvHash, parentKey, ( i - 1 ) + n * 6)
					call SetItemPositionLoc(oldItem, MultiPageInventorySystem___itemSaveLoc)
					call SetItemVisibleBJ(false, oldItem)
					call SetItemVisibleBJ(true, newItem)
					call UnitAddItemSwapped(newItem, MultiPageInventorySystem___invUnit[id])
					set i=i + 1
					exitwhen i > 6
				endloop
			endif
			set n=n + 1
			exitwhen n > maxPages
		endloop

		set p=null
		set oldItem=null
		set newItem=null
	endfunction

 function InventoryButtonClickLeft takes nothing returns nothing
  local string s= ""
  local player p= GetTriggerPlayer()
  local integer key= GetUnitUserData(MultiPageInventorySystem___invUnit[GetConvertedPlayerId(p)])
		call BlzFrameSetEnable(BlzGetFrameByName("ScriptDialogButton", 100), false)
		call BlzFrameSetEnable(BlzGetFrameByName("ScriptDialogButton", 100), true)
		call SaveInventory()
		if ( MultiPageInventorySystem___unitPage[key] <= 1 ) then
			set MultiPageInventorySystem___unitPage[key]=( MultiPageInventorySystem___unitPagesMax[key] )
		else
			set MultiPageInventorySystem___unitPage[key]=( MultiPageInventorySystem___unitPage[key] - 1 )
		endif
		call LoadInventory()
		set s=( "|cffffffff" + I2S(MultiPageInventorySystem___unitPage[key]) + "/" + I2S(MultiPageInventorySystem___unitPagesMax[key]) + "|r" )
		call InventoryButtonsSetPageText(p , s)

		set p=null
	endfunction

 function InventoryButtonClickRight takes nothing returns nothing
  local string s= ""
  local player p= GetTriggerPlayer()
  local integer key= GetUnitUserData(MultiPageInventorySystem___invUnit[GetConvertedPlayerId(p)])
		call BlzFrameSetEnable(BlzGetFrameByName("ScriptDialogButton", 101), false)
		call BlzFrameSetEnable(BlzGetFrameByName("ScriptDialogButton", 101), true)
		call SaveInventory()
		if ( MultiPageInventorySystem___unitPage[key] >= ( MultiPageInventorySystem___unitPagesMax[key] ) ) then
			set MultiPageInventorySystem___unitPage[key]=1
		else
			set MultiPageInventorySystem___unitPage[key]=( MultiPageInventorySystem___unitPage[key] + 1 )
		endif
		call LoadInventory()
		set s=( "|cffffffff" + I2S(MultiPageInventorySystem___unitPage[key]) + "/" + I2S(MultiPageInventorySystem___unitPagesMax[key]) + "|r" )
		call InventoryButtonsSetPageText(p , s)

		set p=null
	endfunction

 function InventoryButtonsHide takes player whichPlayer returns nothing
		if GetLocalPlayer() == whichPlayer then
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 100), false)
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 101), false)
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 102), false)
		endif
	endfunction

 function InventoryButtonsShow takes player whichPlayer returns nothing
		if GetLocalPlayer() == whichPlayer then
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 100), true)
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 101), true)
			call BlzFrameSetVisible(BlzGetFrameByName("ScriptDialogButton", 102), true)
		endif
	endfunction

 function ShowButtonsConditions takes nothing returns boolean
		if ( GetTriggerPlayer() == GetOwningPlayer(GetTriggerUnit()) ) then
			return true
		else
			return false
		endif
	endfunction
	
 function ShowButtonsActions takes nothing returns nothing
  local string s= ""
  local integer i= 1
  local integer key= 0
  local player p= GetTriggerPlayer()
  local unit u= GetTriggerUnit()
		loop
			if ( GetUnitAbilityLevelSwapped(udg_InvAbility[i], u) > 0 ) then
				set MultiPageInventorySystem___invUnit[GetConvertedPlayerId(p)]=u
				set key=GetUnitUserData(u)
				set MultiPageInventorySystem___unitPagesMax[key]=BlzGetAbilityIntegerField(BlzGetUnitAbility(u, udg_InvAbility[i]), ABILITY_IF_PRIORITY)
				call InventoryButtonsShow(p)
				if ( MultiPageInventorySystem___unitPage[key] <= 0 ) or ( MultiPageInventorySystem___unitPage[key] > MultiPageInventorySystem___unitPagesMax[key] ) then
					set MultiPageInventorySystem___unitPage[key]=1
				endif
				set s=( "|cffffffff" + ( I2S(MultiPageInventorySystem___unitPage[key]) ) + "/" + ( I2S(MultiPageInventorySystem___unitPagesMax[key]) + "|r" ) )
				call InventoryButtonsSetPageText(p , s)
				exitwhen true
			else
				set MultiPageInventorySystem___invUnit[GetConvertedPlayerId(p)]=null
				call InventoryButtonsHide(p)
			endif
			set i=i + 1
			exitwhen i > udg_InvAbilitiesTotal
		endloop

		set p=null
		set u=null
	endfunction
	
 function HideButtonsActions takes nothing returns nothing
    	call InventoryButtonsHide(GetTriggerPlayer())
	endfunction

 function CreateInventoryButtons takes nothing returns nothing
  local trigger trigInvLeft= CreateTrigger()
  local trigger trigInvRight= CreateTrigger()
  local trigger trigShowButtons= CreateTrigger()
  local trigger trigHideButtons= CreateTrigger()
  local trigger trigHotkeyLeft= CreateTrigger()
  local trigger trigHotkeyRight= CreateTrigger()
  local oskeytype hotkeyLeft= null
  local oskeytype hotkeyRight= null
  local string hotkeyLeftString= ""
  local string hotkeyRightString= ""
  local integer i= 0

  local framehandle invButtonLeft= BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 100)
  local framehandle invButtonLeftTooltipBackground= BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 100)
  local framehandle invButtonLeftTooltipText= BlzCreateFrameByType("TEXT", "MyScriptDialogButtonTooltip", invButtonLeftTooltipBackground, "", 100)
  local framehandle invButtonRight= BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 101)
  local framehandle invButtonRightTooltipBackground= BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 101)
  local framehandle invButtonRightTooltipText= BlzCreateFrameByType("TEXT", "MyScriptDialogButtonTooltip", invButtonRightTooltipBackground, "", 101)
  local framehandle invButtonPage= BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 102)
		
		if ( StringCase(udg_InvHotkeyLeft, true) == "Q" ) then
			set hotkeyLeft=OSKEY_Q
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "W" ) then
			set hotkeyLeft=OSKEY_W
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "E" ) then
			set hotkeyLeft=OSKEY_E
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "R" ) then
			set hotkeyLeft=OSKEY_R
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "T" ) then
			set hotkeyLeft=OSKEY_T
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "Y" ) then
			set hotkeyLeft=OSKEY_Y
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "U" ) then
			set hotkeyLeft=OSKEY_U
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "I" ) then
			set hotkeyLeft=OSKEY_I
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "O" ) then
			set hotkeyLeft=OSKEY_O
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "P" ) then
			set hotkeyLeft=OSKEY_P
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "A" ) then
			set hotkeyLeft=OSKEY_A
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "S" ) then
			set hotkeyLeft=OSKEY_S
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "D" ) then
			set hotkeyLeft=OSKEY_D
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "F" ) then
			set hotkeyLeft=OSKEY_F
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "G" ) then
			set hotkeyLeft=OSKEY_G
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "H" ) then
			set hotkeyLeft=OSKEY_H
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "J" ) then
			set hotkeyLeft=OSKEY_J
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "K" ) then
			set hotkeyLeft=OSKEY_K
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "L" ) then
			set hotkeyLeft=OSKEY_L
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "Z" ) then
			set hotkeyLeft=OSKEY_Z
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "X" ) then
			set hotkeyLeft=OSKEY_X
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "C" ) then
			set hotkeyLeft=OSKEY_C
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "V" ) then
			set hotkeyLeft=OSKEY_V
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "B" ) then
			set hotkeyLeft=OSKEY_B
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "N" ) then
			set hotkeyLeft=OSKEY_N
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "M" ) then
			set hotkeyLeft=OSKEY_M
			set hotkeyLeftString=StringCase(udg_InvHotkeyLeft, true)
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD0" ) then
			set hotkeyLeft=OSKEY_NUMPAD0
			set hotkeyLeftString="NumPad 0"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD1" ) then
			set hotkeyLeft=OSKEY_NUMPAD1
			set hotkeyLeftString="NumPad 1"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD2" ) then
			set hotkeyLeft=OSKEY_NUMPAD2
			set hotkeyLeftString="NumPad 2"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD3" ) then
			set hotkeyLeft=OSKEY_NUMPAD3
			set hotkeyLeftString="NumPad 3"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD4" ) then
			set hotkeyLeft=OSKEY_NUMPAD4
			set hotkeyLeftString="NumPad 4"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD5" ) then
			set hotkeyLeft=OSKEY_NUMPAD5
			set hotkeyLeftString="NumPad 5"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD6" ) then
			set hotkeyLeft=OSKEY_NUMPAD6
			set hotkeyLeftString="NumPad 6"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD7" ) then
			set hotkeyLeft=OSKEY_NUMPAD7
			set hotkeyLeftString="NumPad 7"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD8" ) then
			set hotkeyLeft=OSKEY_NUMPAD8
			set hotkeyLeftString="NumPad 8"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD9" ) then
			set hotkeyLeft=OSKEY_NUMPAD9
			set hotkeyLeftString="NumPad 9"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD/" ) then
			set hotkeyLeft=OSKEY_DIVIDE
			set hotkeyLeftString="NumPad ÷"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD*" ) then
			set hotkeyLeft=OSKEY_MULTIPLY
			set hotkeyLeftString="NumPad ×"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD-" ) then
			set hotkeyLeft=OSKEY_SUBTRACT
			set hotkeyLeftString="NumPad -"
		endif
		if ( StringCase(udg_InvHotkeyLeft, true) == "NUMPAD+" ) then
			set hotkeyLeft=OSKEY_ADD
			set hotkeyLeftString="NumPad +"
		endif
		
		if ( StringCase(udg_InvHotkeyRight, true) == "Q" ) then
			set hotkeyRight=OSKEY_Q
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "W" ) then
			set hotkeyRight=OSKEY_W
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "E" ) then
			set hotkeyRight=OSKEY_E
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "R" ) then
			set hotkeyRight=OSKEY_R
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "T" ) then
			set hotkeyRight=OSKEY_T
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "Y" ) then
			set hotkeyRight=OSKEY_Y
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "U" ) then
			set hotkeyRight=OSKEY_U
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "I" ) then
			set hotkeyRight=OSKEY_I
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "O" ) then
			set hotkeyRight=OSKEY_O
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "P" ) then
			set hotkeyRight=OSKEY_P
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "A" ) then
			set hotkeyRight=OSKEY_A
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "S" ) then
			set hotkeyRight=OSKEY_S
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "D" ) then
			set hotkeyRight=OSKEY_D
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "F" ) then
			set hotkeyRight=OSKEY_F
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "G" ) then
			set hotkeyRight=OSKEY_G
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "H" ) then
			set hotkeyRight=OSKEY_H
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "J" ) then
			set hotkeyRight=OSKEY_J
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "K" ) then
			set hotkeyRight=OSKEY_K
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "L" ) then
			set hotkeyRight=OSKEY_L
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "Z" ) then
			set hotkeyRight=OSKEY_Z
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "X" ) then
			set hotkeyRight=OSKEY_X
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "C" ) then
			set hotkeyRight=OSKEY_C
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "V" ) then
			set hotkeyRight=OSKEY_V
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "B" ) then
			set hotkeyRight=OSKEY_B
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "N" ) then
			set hotkeyRight=OSKEY_N
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "M" ) then
			set hotkeyRight=OSKEY_M
			set hotkeyRightString=StringCase(udg_InvHotkeyRight, true)
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD0" ) then
			set hotkeyRight=OSKEY_NUMPAD0
			set hotkeyRightString="NumPad 0"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD1" ) then
			set hotkeyRight=OSKEY_NUMPAD1
			set hotkeyRightString="NumPad 1"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD2" ) then
			set hotkeyRight=OSKEY_NUMPAD2
			set hotkeyRightString="NumPad 2"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD3" ) then
			set hotkeyRight=OSKEY_NUMPAD3
			set hotkeyRightString="NumPad 3"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD4" ) then
			set hotkeyRight=OSKEY_NUMPAD4
			set hotkeyRightString="NumPad 4"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD5" ) then
			set hotkeyRight=OSKEY_NUMPAD5
			set hotkeyRightString="NumPad 5"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD6" ) then
			set hotkeyRight=OSKEY_NUMPAD6
			set hotkeyRightString="NumPad 6"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD7" ) then
			set hotkeyRight=OSKEY_NUMPAD7
			set hotkeyRightString="NumPad 7"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD8" ) then
			set hotkeyRight=OSKEY_NUMPAD8
			set hotkeyRightString="NumPad 8"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD9" ) then
			set hotkeyRight=OSKEY_NUMPAD9
			set hotkeyRightString="NumPad 9"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD/" ) then
			set hotkeyRight=OSKEY_DIVIDE
			set hotkeyRightString="NumPad ÷"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD*" ) then
			set hotkeyRight=OSKEY_MULTIPLY
			set hotkeyRightString="NumPad ×"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD-" ) then
			set hotkeyRight=OSKEY_SUBTRACT
			set hotkeyRightString="NumPad -"
		endif
		if ( StringCase(udg_InvHotkeyRight, true) == "NUMPAD+" ) then
			set hotkeyRight=OSKEY_ADD
			set hotkeyRightString="NumPad +"
		endif

		call BlzFrameSetSize(invButtonLeft, 0.033, 0.025)
		call BlzFrameSetSize(invButtonRight, 0.033, 0.025)
		call BlzFrameSetSize(invButtonPage, 0.04, 0.025)
		call BlzFrameSetSize(invButtonLeftTooltipText, 0, 0)
		call BlzFrameSetSize(invButtonRightTooltipText, 0, 0)

		call BlzFrameSetAbsPoint(invButtonPage, FRAMEPOINT_CENTER, 0.5513, 0.1425)
		call BlzFrameSetPoint(invButtonLeft, FRAMEPOINT_RIGHT, invButtonPage, FRAMEPOINT_LEFT, 0.005, 0)
		call BlzFrameSetPoint(invButtonRight, FRAMEPOINT_LEFT, invButtonPage, FRAMEPOINT_RIGHT, - 0.005, 0)

		call BlzFrameSetPoint(invButtonLeftTooltipBackground, FRAMEPOINT_BOTTOMLEFT, invButtonLeftTooltipText, FRAMEPOINT_BOTTOMLEFT, - 0.01, - 0.01)
		call BlzFrameSetPoint(invButtonLeftTooltipBackground, FRAMEPOINT_TOPRIGHT, invButtonLeftTooltipText, FRAMEPOINT_TOPRIGHT, 0.01, 0.01)
		call BlzFrameSetPoint(invButtonRightTooltipBackground, FRAMEPOINT_BOTTOMLEFT, invButtonRightTooltipText, FRAMEPOINT_BOTTOMLEFT, - 0.01, - 0.01)
		call BlzFrameSetPoint(invButtonRightTooltipBackground, FRAMEPOINT_TOPRIGHT, invButtonRightTooltipText, FRAMEPOINT_TOPRIGHT, 0.01, 0.01)
		
		call BlzFrameSetTooltip(invButtonLeft, invButtonLeftTooltipBackground)
		call BlzFrameSetTooltip(invButtonRight, invButtonRightTooltipBackground)
		
		call BlzFrameSetPoint(invButtonLeftTooltipText, FRAMEPOINT_BOTTOM, invButtonLeft, FRAMEPOINT_TOP, 0, 0.005)
		call BlzFrameSetPoint(invButtonRightTooltipText, FRAMEPOINT_BOTTOM, invButtonRight, FRAMEPOINT_TOP, 0, 0.005)

		call BlzFrameSetAlpha(invButtonLeftTooltipBackground, 25)
		call BlzFrameSetAlpha(invButtonRightTooltipBackground, 25)

		call BlzFrameSetEnable(invButtonLeftTooltipText, false)
		if hotkeyLeftString != "" then
			call BlzFrameSetText(invButtonLeftTooltipText, "Previous page (|cffffcc00" + hotkeyLeftString + "|r)\n|cffc0c0c0Click to view previous inventory page.|r")
		else
			call BlzFrameSetText(invButtonLeftTooltipText, "Previous page\n|cffc0c0c0Click to view previous inventory page.|r")
		endif
		call BlzFrameSetEnable(invButtonRightTooltipText, false)
		if hotkeyRightString != "" then
			call BlzFrameSetText(invButtonRightTooltipText, "Next page (|cffffcc00" + hotkeyRightString + "|r)\n|cffc0c0c0Click to view next inventory page.|r")
		else
			call BlzFrameSetText(invButtonRightTooltipText, "Next page\n|cffc0c0c0Click to view next inventory page.|r")
		endif
		call BlzFrameSetText(invButtonLeft, "<-")
		call BlzFrameSetText(invButtonRight, "->")
		call BlzFrameSetText(invButtonPage, "|cffff0000Error|r")

		call BlzFrameSetEnable(BlzGetFrameByName("ScriptDialogButton", 102), false)

		call BlzTriggerRegisterFrameEvent(trigInvLeft, invButtonLeft, FRAMEEVENT_CONTROL_CLICK)
		call BlzTriggerRegisterFrameEvent(trigInvRight, invButtonRight, FRAMEEVENT_CONTROL_CLICK)
		call TriggerAddAction(trigInvLeft, function InventoryButtonClickLeft)
		call TriggerAddAction(trigInvRight, function InventoryButtonClickRight)

		loop
			call TriggerRegisterPlayerSelectionEventBJ(trigShowButtons, Player(i), true)
			call TriggerRegisterPlayerSelectionEventBJ(trigHideButtons, Player(i), false)
			call BlzTriggerRegisterPlayerKeyEvent(trigHotkeyLeft, Player(i), hotkeyLeft, 0, true)
			call BlzTriggerRegisterPlayerKeyEvent(trigHotkeyRight, Player(i), hotkeyRight, 0, true)
			set i=i + 1
			exitwhen i > 24
		endloop
		call TriggerAddCondition(trigShowButtons, Condition(function ShowButtonsConditions))
		call TriggerAddAction(trigShowButtons, function ShowButtonsActions)
		call TriggerAddAction(trigHideButtons, function HideButtonsActions)
		
		call TriggerAddAction(trigHotkeyLeft, function InventoryButtonClickLeft)
		call TriggerAddAction(trigHotkeyRight, function InventoryButtonClickRight)
	endfunction

//library MultiPageInventorySystem ends
//===========================================================================
// 
// Multi-Page Inventory System 1.0.10
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Map Author:  Rahko
// 
//===========================================================================

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************


function InitGlobals takes nothing returns nothing
    local integer i= 0
    set udg_UDexWasted=0
    set udg_UDex=0
    set i=0
    loop
        exitwhen ( i > 1 )
        set udg_UDexNext[i]=0
        set i=i + 1
    endloop

    set i=0
    loop
        exitwhen ( i > 1 )
        set udg_UDexPrev[i]=0
        set i=i + 1
    endloop

    set i=0
    loop
        exitwhen ( i > 1 )
        set udg_IsUnitPreplaced[i]=false
        set i=i + 1
    endloop

    set udg_UnitIndexEvent=0
    set udg_UDexRecycle=0
    set udg_UDexGen=0
    set udg_UnitIndexerEnabled=false
    set udg_InvAbilitiesTotal=0
    set udg_InvHotkeyLeft=""
    set udg_InvHotkeyRight=""
endfunction

//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//***************************************************************************
//*  Inventory Buttons

//***************************************************************************
//*
//*  Items
//*
//***************************************************************************

function CreateAllItems takes nothing returns nothing
    local integer itemID

    call BlzCreateItemWithSkin('ches', 616.7, - 170.6, 'ches')
    call BlzCreateItemWithSkin('ches', 632.0, 178.9, 'ches')
    call BlzCreateItemWithSkin('ches', 627.8, 73.9, 'ches')
    call BlzCreateItemWithSkin('ches', 624.7, - 18.2, 'ches')
    call BlzCreateItemWithSkin('ches', 620.3, - 98.4, 'ches')
    call BlzCreateItemWithSkin('ches', 642.2, 315.2, 'ches')
    call BlzCreateItemWithSkin('ckng', 23.8, - 60.1, 'ckng')
    call BlzCreateItemWithSkin('ckng', 23.5, - 121.7, 'ckng')
    call BlzCreateItemWithSkin('ckng', 24.0, - 6.1, 'ckng')
    call BlzCreateItemWithSkin('ckng', 21.7, 49.1, 'ckng')
    call BlzCreateItemWithSkin('ckng', 19.4, 108.5, 'ckng')
    call BlzCreateItemWithSkin('ckng', 14.4, 172.5, 'ckng')
    call BlzCreateItemWithSkin('ckng', 4.0, 281.3, 'ckng')
    call BlzCreateItemWithSkin('desc', 119.8, - 21.2, 'desc')
    call BlzCreateItemWithSkin('desc', 116.6, 61.5, 'desc')
    call BlzCreateItemWithSkin('desc', 119.1, 178.9, 'desc')
    call BlzCreateItemWithSkin('desc', 131.7, 271.3, 'desc')
    call BlzCreateItemWithSkin('desc', 127.4, - 124.6, 'desc')
    call BlzCreateItemWithSkin('engs', 757.0, 291.5, 'engs')
    call BlzCreateItemWithSkin('engs', 737.4, - 6.1, 'engs')
    call BlzCreateItemWithSkin('engs', 747.6, 86.4, 'engs')
    call BlzCreateItemWithSkin('engs', 728.7, - 51.1, 'engs')
    call BlzCreateItemWithSkin('engs', 712.1, - 136.2, 'engs')
    call BlzCreateItemWithSkin('engs', 756.8, 172.5, 'engs')
    call BlzCreateItemWithSkin('fgdg', 1487.5, - 532.5, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1496.9, - 434.6, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1500.8, - 377.5, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1499.9, - 341.9, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1500.8, - 277.6, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1491.6, - 488.1, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1491.3, - 581.4, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1488.3, - 616.3, 'fgdg')
    call BlzCreateItemWithSkin('fgdg', 1501.9, - 224.6, 'fgdg')
    call BlzCreateItemWithSkin('fgrd', 1812.5, - 244.6, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1804.3, - 424.5, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1812.4, - 299.3, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1807.1, - 385.7, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1810.4, - 344.0, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1796.8, - 509.4, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1790.3, - 641.6, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1783.9, - 609.0, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1802.5, - 466.5, 'fgrd')
    call BlzCreateItemWithSkin('fgrd', 1792.7, - 560.8, 'fgrd')
    call BlzCreateItemWithSkin('fgrg', 1244.5, - 118.4, 'fgrg')
    call BlzCreateItemWithSkin('fgrg', 1246.7, 54.8, 'fgrg')
    call BlzCreateItemWithSkin('fgrg', 1275.6, 292.2, 'fgrg')
    call BlzCreateItemWithSkin('fgrg', 1259.5, 171.0, 'fgrg')
    call BlzCreateItemWithSkin('fgrg', 1244.0, - 34.7, 'fgrg')
    call BlzCreateItemWithSkin('gldo', 1497.0, - 27.8, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1496.3, - 98.6, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1491.5, - 182.2, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1506.6, 192.6, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1500.6, 48.0, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1505.8, 116.0, 'gldo')
    call BlzCreateItemWithSkin('gldo', 1505.1, 299.1, 'gldo')
    call BlzCreateItemWithSkin('infs', 1685.6, - 295.0, 'infs')
    call BlzCreateItemWithSkin('infs', 1689.6, - 385.7, 'infs')
    call BlzCreateItemWithSkin('infs', 1687.2, - 438.6, 'infs')
    call BlzCreateItemWithSkin('infs', 1687.8, - 474.3, 'infs')
    call BlzCreateItemWithSkin('infs', 1687.2, - 524.8, 'infs')
    call BlzCreateItemWithSkin('infs', 1687.0, - 562.7, 'infs')
    call BlzCreateItemWithSkin('infs', 1684.2, - 596.2, 'infs')
    call BlzCreateItemWithSkin('infs', 1687.8, - 630.8, 'infs')
    call BlzCreateItemWithSkin('infs', 1686.5, - 331.4, 'infs')
    call BlzCreateItemWithSkin('infs', 1696.9, - 197.5, 'infs')
    call BlzCreateItemWithSkin('infs', 1688.4, - 246.8, 'infs')
    call BlzCreateItemWithSkin('ledg', 884.6, 305.0, 'ledg')
    call BlzCreateItemWithSkin('ledg', 856.2, 89.6, 'ledg')
    call BlzCreateItemWithSkin('ledg', 850.7, 6.1, 'ledg')
    call BlzCreateItemWithSkin('ledg', 853.2, - 57.1, 'ledg')
    call BlzCreateItemWithSkin('ledg', 849.0, - 144.8, 'ledg')
    call BlzCreateItemWithSkin('ledg', 868.1, 182.2, 'ledg')
    call BlzCreateItemWithSkin('mcri', 128.1, - 399.1, 'mcri')
    call BlzCreateItemWithSkin('mcri', 123.5, - 358.2, 'mcri')
    call BlzCreateItemWithSkin('mcri', 130.5, - 485.6, 'mcri')
    call BlzCreateItemWithSkin('mcri', 129.9, - 527.4, 'mcri')
    call BlzCreateItemWithSkin('mcri', 119.9, - 296.1, 'mcri')
    call BlzCreateItemWithSkin('mcri', 125.1, - 221.4, 'mcri')
    call BlzCreateItemWithSkin('mcri', 131.0, - 566.5, 'mcri')
    call BlzCreateItemWithSkin('mcri', 135.4, - 606.4, 'mcri')
    call BlzCreateItemWithSkin('mcri', 129.3, - 441.0, 'mcri')
    call BlzCreateItemWithSkin('mcri', 120.6, - 257.0, 'mcri')
    call BlzCreateItemWithSkin('mcri', 127.8, - 182.9, 'mcri')
    call BlzCreateItemWithSkin('modt', 246.7, - 113.0, 'modt')
    call BlzCreateItemWithSkin('modt', 248.9, - 66.0, 'modt')
    call BlzCreateItemWithSkin('modt', 251.0, 322.0, 'modt')
    call BlzCreateItemWithSkin('modt', 251.6, - 9.1, 'modt')
    call BlzCreateItemWithSkin('modt', 252.8, 70.8, 'modt')
    call BlzCreateItemWithSkin('modt', 244.3, - 164.9, 'modt')
    call BlzCreateItemWithSkin('modt', 251.8, 162.8, 'modt')
    call BlzCreateItemWithSkin('ofir', 1389.5, 83.4, 'ofir')
    call BlzCreateItemWithSkin('ofir', 1389.0, 162.4, 'ofir')
    call BlzCreateItemWithSkin('ofir', 1386.1, 306.1, 'ofir')
    call BlzCreateItemWithSkin('ofir', 1376.1, - 137.7, 'ofir')
    call BlzCreateItemWithSkin('ofir', 1389.2, 25.6, 'ofir')
    call BlzCreateItemWithSkin('ofir', 1384.0, - 55.7, 'ofir')
    call BlzCreateItemWithSkin('ofro', 366.2, 156.3, 'ofro')
    call BlzCreateItemWithSkin('ofro', 381.4, 305.0, 'ofro')
    call BlzCreateItemWithSkin('ofro', 380.4, - 80.8, 'ofro')
    call BlzCreateItemWithSkin('ofro', 372.3, 55.2, 'ofro')
    call BlzCreateItemWithSkin('ofro', 376.3, - 33.2, 'ofro')
    call BlzCreateItemWithSkin('ofro', 379.7, - 124.6, 'ofro')
    call BlzCreateItemWithSkin('olig', 1594.5, 89.9, 'olig')
    call BlzCreateItemWithSkin('olig', 1570.0, - 134.7, 'olig')
    call BlzCreateItemWithSkin('olig', 1602.2, 189.2, 'olig')
    call BlzCreateItemWithSkin('olig', 1614.4, 345.0, 'olig')
    call BlzCreateItemWithSkin('olig', 1584.2, - 27.8, 'olig')
    call BlzCreateItemWithSkin('oslo', 1712.3, 302.6, 'oslo')
    call BlzCreateItemWithSkin('oslo', 1723.0, 159.0, 'oslo')
    call BlzCreateItemWithSkin('oslo', 1720.4, 6.6, 'oslo')
    call BlzCreateItemWithSkin('oslo', 1710.7, - 71.1, 'oslo')
    call BlzCreateItemWithSkin('oslo', 1702.5, - 155.6, 'oslo')
    call BlzCreateItemWithSkin('oslo', 1722.4, 86.7, 'oslo')
    call BlzCreateItemWithSkin('oven', 1823.2, 299.1, 'oven')
    call BlzCreateItemWithSkin('oven', 1814.7, - 58.8, 'oven')
    call BlzCreateItemWithSkin('oven', 1824.0, 83.4, 'oven')
    call BlzCreateItemWithSkin('oven', 1812.4, - 185.1, 'oven')
    call BlzCreateItemWithSkin('oven', 1813.9, - 134.7, 'oven')
    call BlzCreateItemWithSkin('oven', 1827.2, 179.1, 'oven')
    call BlzCreateItemWithSkin('oven', 1819.0, 9.8, 'oven')
    call BlzCreateItemWithSkin('pclr', - 82.0, - 414.2, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 83.2, - 446.3, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 81.0, - 490.0, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 82.0, - 523.5, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 85.0, - 558.8, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 83.7, - 591.3, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 81.5, - 632.5, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 90.1, - 241.9, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 83.2, - 356.4, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 90.3, - 286.8, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 86.6, - 323.2, 'pclr')
    call BlzCreateItemWithSkin('pclr', - 81.1, - 188.1, 'pclr')
    call BlzCreateItemWithSkin('phea', 245.1, - 437.2, 'phea')
    call BlzCreateItemWithSkin('phea', 245.3, - 379.7, 'phea')
    call BlzCreateItemWithSkin('phea', 240.2, - 340.3, 'phea')
    call BlzCreateItemWithSkin('phea', 236.7, - 294.1, 'phea')
    call BlzCreateItemWithSkin('phea', 238.7, - 248.7, 'phea')
    call BlzCreateItemWithSkin('phea', 251.7, - 200.1, 'phea')
    call BlzCreateItemWithSkin('phea', 237.9, - 527.4, 'phea')
    call BlzCreateItemWithSkin('phea', 232.8, - 570.0, 'phea')
    call BlzCreateItemWithSkin('phea', 237.7, - 606.4, 'phea')
    call BlzCreateItemWithSkin('phea', 243.2, - 485.6, 'phea')
    call BlzCreateItemWithSkin('phlt', 971.4, 42.9, 'phlt')
    call BlzCreateItemWithSkin('phlt', 982.9, 121.2, 'phlt')
    call BlzCreateItemWithSkin('phlt', 987.1, 188.7, 'phlt')
    call BlzCreateItemWithSkin('phlt', 1011.9, 298.2, 'phlt')
    call BlzCreateItemWithSkin('phlt', 947.0, - 147.7, 'phlt')
    call BlzCreateItemWithSkin('phlt', 957.2, - 77.8, 'phlt')
    call BlzCreateItemWithSkin('phlt', 964.0, - 12.1, 'phlt')
    call BlzCreateItemWithSkin('pinv', 361.9, - 596.1, 'pinv')
    call BlzCreateItemWithSkin('pinv', 363.6, - 552.4, 'pinv')
    call BlzCreateItemWithSkin('pinv', 372.1, - 507.6, 'pinv')
    call BlzCreateItemWithSkin('pinv', 375.4, - 467.2, 'pinv')
    call BlzCreateItemWithSkin('pinv', 376.8, - 431.5, 'pinv')
    call BlzCreateItemWithSkin('pinv', 378.4, - 393.3, 'pinv')
    call BlzCreateItemWithSkin('pinv', 380.6, - 338.4, 'pinv')
    call BlzCreateItemWithSkin('pinv', 380.7, - 290.0, 'pinv')
    call BlzCreateItemWithSkin('pinv', 378.9, - 244.5, 'pinv')
    call BlzCreateItemWithSkin('pinv', 372.9, - 210.8, 'pinv')
    call BlzCreateItemWithSkin('pinv', 374.3, - 172.1, 'pinv')
    call BlzCreateItemWithSkin('plcl', 29.1, - 169.9, 'plcl')
    call BlzCreateItemWithSkin('plcl', 13.6, - 259.1, 'plcl')
    call BlzCreateItemWithSkin('plcl', 15.7, - 296.1, 'plcl')
    call BlzCreateItemWithSkin('plcl', 18.4, - 344.3, 'plcl')
    call BlzCreateItemWithSkin('plcl', 20.3, - 377.8, 'plcl')
    call BlzCreateItemWithSkin('plcl', 24.4, - 420.1, 'plcl')
    call BlzCreateItemWithSkin('plcl', 25.3, - 467.2, 'plcl')
    call BlzCreateItemWithSkin('plcl', 24.9, - 520.2, 'plcl')
    call BlzCreateItemWithSkin('plcl', 25.0, - 580.5, 'plcl')
    call BlzCreateItemWithSkin('plcl', 22.6, - 625.2, 'plcl')
    call BlzCreateItemWithSkin('plcl', 18.0, - 206.5, 'plcl')
    call BlzCreateItemWithSkin('pman', 613.6, - 265.3, 'pman')
    call BlzCreateItemWithSkin('pman', 594.5, - 571.7, 'pman')
    call BlzCreateItemWithSkin('pman', 599.7, - 538.2, 'pman')
    call BlzCreateItemWithSkin('pman', 604.8, - 489.3, 'pman')
    call BlzCreateItemWithSkin('pman', 605.2, - 452.2, 'pman')
    call BlzCreateItemWithSkin('pman', 608.3, - 404.8, 'pman')
    call BlzCreateItemWithSkin('pman', 612.2, - 350.3, 'pman')
    call BlzCreateItemWithSkin('pman', 613.9, - 316.3, 'pman')
    call BlzCreateItemWithSkin('pman', 617.9, - 204.4, 'pman')
    call BlzCreateItemWithSkin('pman', 598.5, - 613.3, 'pman')
    call BlzCreateItemWithSkin('pnvl', 509.0, - 234.0, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 500.9, - 554.1, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 504.0, - 513.0, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 501.5, - 456.0, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 520.3, - 180.7, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 499.3, - 368.0, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 502.2, - 328.4, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 504.8, - 292.0, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 498.2, - 589.2, 'pnvl')
    call BlzCreateItemWithSkin('pnvl', 497.7, - 414.4, 'pnvl')
    call BlzCreateItemWithSkin('ratf', - 87.6, - 136.2, 'ratf')
    call BlzCreateItemWithSkin('ratf', - 89.6, 137.1, 'ratf')
    call BlzCreateItemWithSkin('ratf', - 86.0, 241.3, 'ratf')
    call BlzCreateItemWithSkin('ratf', - 89.8, - 6.1, 'ratf')
    call BlzCreateItemWithSkin('ratf', - 89.1, - 51.1, 'ratf')
    call BlzCreateItemWithSkin('ratf', - 90.6, 42.9, 'ratf')
    call BlzCreateItemWithSkin('rde4', 519.7, - 60.1, 'rde4')
    call BlzCreateItemWithSkin('rde4', 522.9, - 127.5, 'rde4')
    call BlzCreateItemWithSkin('rde4', 511.4, 175.7, 'rde4')
    call BlzCreateItemWithSkin('rde4', 519.2, 318.6, 'rde4')
    call BlzCreateItemWithSkin('rde4', 509.7, 73.9, 'rde4')
    call BlzCreateItemWithSkin('rde4', 513.5, 6.1, 'rde4')
    call BlzCreateItemWithSkin('shas', 1095.3, - 634.7, 'shas')
    call BlzCreateItemWithSkin('shas', 1103.5, - 328.8, 'shas')
    call BlzCreateItemWithSkin('shas', 1106.4, - 293.1, 'shas')
    call BlzCreateItemWithSkin('shas', 1108.0, - 250.4, 'shas')
    call BlzCreateItemWithSkin('shas', 1100.2, - 412.1, 'shas')
    call BlzCreateItemWithSkin('shas', 1099.2, - 445.6, 'shas')
    call BlzCreateItemWithSkin('shas', 1098.1, - 501.4, 'shas')
    call BlzCreateItemWithSkin('shas', 1097.1, - 553.7, 'shas')
    call BlzCreateItemWithSkin('shas', 1094.8, - 601.0, 'shas')
    call BlzCreateItemWithSkin('shas', 1100.3, - 367.9, 'shas')
    call BlzCreateItemWithSkin('shea', 722.5, - 221.4, 'shea')
    call BlzCreateItemWithSkin('shea', 727.2, - 169.9, 'shea')
    call BlzCreateItemWithSkin('shea', 723.6, - 254.9, 'shea')
    call BlzCreateItemWithSkin('shea', 725.2, - 312.3, 'shea')
    call BlzCreateItemWithSkin('shea', 726.9, - 379.7, 'shea')
    call BlzCreateItemWithSkin('shea', 727.8, - 412.5, 'shea')
    call BlzCreateItemWithSkin('shea', 730.0, - 459.7, 'shea')
    call BlzCreateItemWithSkin('shea', 728.2, - 509.4, 'shea')
    call BlzCreateItemWithSkin('shea', 729.0, - 552.4, 'shea')
    call BlzCreateItemWithSkin('shea', 727.5, - 597.8, 'shea')
    call BlzCreateItemWithSkin('sman', 850.8, - 499.5, 'sman')
    call BlzCreateItemWithSkin('sman', 851.6, - 546.3, 'sman')
    call BlzCreateItemWithSkin('sman', 857.0, - 451.5, 'sman')
    call BlzCreateItemWithSkin('sman', 862.1, - 394.1, 'sman')
    call BlzCreateItemWithSkin('sman', 859.9, - 339.2, 'sman')
    call BlzCreateItemWithSkin('sman', 852.9, - 299.5, 'sman')
    call BlzCreateItemWithSkin('sman', 847.9, - 219.8, 'sman')
    call BlzCreateItemWithSkin('sman', 847.4, - 265.4, 'sman')
    call BlzCreateItemWithSkin('sman', 852.3, - 593.8, 'sman')
    call BlzCreateItemWithSkin('spro', 961.0, - 468.9, 'spro')
    call BlzCreateItemWithSkin('spro', 960.8, - 531.5, 'spro')
    call BlzCreateItemWithSkin('spro', 968.3, - 320.5, 'spro')
    call BlzCreateItemWithSkin('spro', 956.4, - 620.6, 'spro')
    call BlzCreateItemWithSkin('spro', 958.0, - 583.0, 'spro')
    call BlzCreateItemWithSkin('spro', 960.5, - 412.1, 'spro')
    call BlzCreateItemWithSkin('spro', 963.9, - 371.9, 'spro')
    call BlzCreateItemWithSkin('spro', 964.8, - 228.6, 'spro')
    call BlzCreateItemWithSkin('spro', 965.0, - 179.9, 'spro')
    call BlzCreateItemWithSkin('spro', 968.3, - 276.1, 'spro')
    call BlzCreateItemWithSkin('totw', 1120.5, - 19.0, 'totw')
    call BlzCreateItemWithSkin('totw', 1120.9, 25.7, 'totw')
    call BlzCreateItemWithSkin('totw', 1118.9, 87.5, 'totw')
    call BlzCreateItemWithSkin('totw', 1120.1, 154.1, 'totw')
    call BlzCreateItemWithSkin('totw', 1139.7, 295.7, 'totw')
    call BlzCreateItemWithSkin('totw', 1118.2, - 87.7, 'totw')
    call BlzCreateItemWithSkin('totw', 1110.9, - 181.7, 'totw')
    call BlzCreateItemWithSkin('tret', 1259.0, - 463.1, 'tret')
    call BlzCreateItemWithSkin('tret', 1252.9, - 166.4, 'tret')
    call BlzCreateItemWithSkin('tret', 1246.7, - 204.4, 'tret')
    call BlzCreateItemWithSkin('tret', 1248.6, - 252.5, 'tret')
    call BlzCreateItemWithSkin('tret', 1255.1, - 305.8, 'tret')
    call BlzCreateItemWithSkin('tret', 1257.6, - 359.7, 'tret')
    call BlzCreateItemWithSkin('tret', 1258.6, - 410.1, 'tret')
    call BlzCreateItemWithSkin('tret', 1252.5, - 514.6, 'tret')
    call BlzCreateItemWithSkin('tret', 1246.6, - 561.1, 'tret')
    call BlzCreateItemWithSkin('tret', 1243.3, - 601.0, 'tret')
    call BlzCreateItemWithSkin('tret', 1242.1, - 636.5, 'tret')
    call BlzCreateItemWithSkin('whwd', 1582.3, - 229.1, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1579.2, - 275.4, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1585.4, - 320.7, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1586.3, - 362.9, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1581.5, - 418.4, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1578.3, - 450.6, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1573.7, - 503.6, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1572.1, - 547.7, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1572.2, - 601.7, 'whwd')
    call BlzCreateItemWithSkin('whwd', 1590.5, - 172.4, 'whwd')
    call BlzCreateItemWithSkin('wild', 1387.0, - 183.9, 'wild')
    call BlzCreateItemWithSkin('wild', 1379.7, - 240.2, 'wild')
    call BlzCreateItemWithSkin('wild', 1379.9, - 297.1, 'wild')
    call BlzCreateItemWithSkin('wild', 1378.1, - 352.4, 'wild')
    call BlzCreateItemWithSkin('wild', 1377.7, - 412.3, 'wild')
    call BlzCreateItemWithSkin('wild', 1375.0, - 474.3, 'wild')
    call BlzCreateItemWithSkin('wild', 1371.5, - 509.4, 'wild')
    call BlzCreateItemWithSkin('wild', 1369.8, - 543.9, 'wild')
    call BlzCreateItemWithSkin('wild', 1367.2, - 586.9, 'wild')
    call BlzCreateItemWithSkin('wild', 1370.4, - 621.8, 'wild')
endfunction

//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************

//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set gg_unit_hpea_0000=BlzCreateUnitWithSkin(p, 'hpea', - 276.7, - 816.8, 337.763, 'hpea')
    set gg_unit_hfoo_0106=BlzCreateUnitWithSkin(p, 'hfoo', - 307.2, 112.7, 42.365, 'hfoo')
    set u=BlzCreateUnitWithSkin(p, 'Hpal', - 307.1, - 225.7, 142.178, 'Hpal')
    set gg_unit_Hblm_0165=BlzCreateUnitWithSkin(p, 'Hblm', - 308.5, - 38.2, 180.895, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'Ofar', - 291.4, 295.0, 219.140, 'Ofar')
    set gg_unit_Emoo_0242=BlzCreateUnitWithSkin(p, 'Emoo', - 302.4, - 436.6, 301.870, 'Emoo')
    set gg_unit_Edem_0243=BlzCreateUnitWithSkin(p, 'Edem', - 270.5, - 648.3, 129.610, 'Edem')
    set u=BlzCreateUnitWithSkin(p, 'Otch', - 309.6, 695.7, 117.656, 'Otch')
    set u=BlzCreateUnitWithSkin(p, 'Ulic', - 294.3, 486.0, 327.765, 'Ulic')
    set gg_unit_Oshd_0311=BlzCreateUnitWithSkin(p, 'Oshd', - 327.3, 962.3, 197.134, 'Oshd')
endfunction

//===========================================================================
function CreateUnitsForPlayer1 takes nothing returns nothing
    local player p= Player(1)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=BlzCreateUnitWithSkin(p, 'Otch', - 757.3, 699.0, 102.725, 'Otch')
    set u=BlzCreateUnitWithSkin(p, 'Oshd', - 749.4, 928.8, 315.669, 'Oshd')
    set u=BlzCreateUnitWithSkin(p, 'hfoo', - 755.2, 112.7, 42.365, 'hfoo')
    set u=BlzCreateUnitWithSkin(p, 'Hpal', - 755.1, - 225.7, 142.178, 'Hpal')
    set u=BlzCreateUnitWithSkin(p, 'Hblm', - 756.5, - 38.2, 180.895, 'Hblm')
    set u=BlzCreateUnitWithSkin(p, 'Ofar', - 739.4, 295.0, 219.140, 'Ofar')
    set u=BlzCreateUnitWithSkin(p, 'Ekee', - 761.3, - 423.1, 294.170, 'Ekee')
    set u=BlzCreateUnitWithSkin(p, 'Ulic', - 742.3, 486.0, 327.765, 'Ulic')
endfunction

//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
endfunction

//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0()
    call CreateUnitsForPlayer1()
endfunction

//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings()
    call CreatePlayerUnits()
endfunction

//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************

//===========================================================================
// Trigger: Unit Indexer
//
// This trigger works in two key phases:
// 1) During map initialization, enumerate all existing units of all players to give them an index.
// 2) Adds a second event to itself to index new units as they enter the map.
// As a unit enters the map, check for any old units that may have been removed at some point in order to free their index.
//===========================================================================
function Trig_Unit_Indexer_Func009Func005Func005C takes nothing returns boolean
    if ( not ( GetUnitUserData(udg_UDexUnits[udg_UDex]) == 0 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Indexer_Func009Func005C takes nothing returns boolean
    if ( not ( udg_UDexWasted == 32 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Indexer_Func009C takes nothing returns boolean
    if ( not ( udg_IsUnitPreplaced[0] == false ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Indexer_Func019Func004C takes nothing returns boolean
    if ( not ( udg_UDexRecycle == 0 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Indexer_Func019C takes nothing returns boolean
    if ( not ( udg_UnitIndexerEnabled == true ) ) then
        return false
    endif
    if ( not ( GetUnitUserData(GetFilterUnit()) == 0 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Indexer_Actions takes nothing returns nothing
        call ExecuteFunc("InitializeUnitIndexer")
    endfunction
    //  
    // This is the core function - it provides an index all existing units and for units as they enter the map
    //  
    function IndexUnit takes nothing returns boolean
        local integer pdex= udg_UDex
        local integer ndex
    if ( Trig_Unit_Indexer_Func009C() ) then
        //  
        // Check for removed units for every (32) new units created
        //  
        set udg_UDexWasted=( udg_UDexWasted + 1 )
        if ( Trig_Unit_Indexer_Func009Func005C() ) then
            set udg_UDexWasted=0
            set udg_UDex=udg_UDexNext[0]
            loop
                exitwhen udg_UDex == 0
            if ( Trig_Unit_Indexer_Func009Func005Func005C() ) then
                //  
                // Remove index from linked list
                //  
                set ndex=udg_UDexNext[udg_UDex]
                set udg_UDexNext[udg_UDexPrev[udg_UDex]]=ndex
                set udg_UDexPrev[ndex]=udg_UDexPrev[udg_UDex]
                set udg_UDexPrev[udg_UDex]=0
                set udg_IsUnitPreplaced[udg_UDex]=false
                //  
                // Fire deindex event for UDex
                //  
                set udg_UnitIndexEvent=2.00
                set udg_UnitIndexEvent=0.00
                //  
                // Recycle the index for later use
                //  
                set udg_UDexUnits[udg_UDex]=null
                set udg_UDexNext[udg_UDex]=udg_UDexRecycle
                set udg_UDexRecycle=udg_UDex
                set udg_UDex=ndex
            else
                set udg_UDex=udg_UDexNext[udg_UDex]
            endif
            endloop
        else
        endif
    else
    endif
    //  
    // You can use the boolean UnitIndexerEnabled to protect some of your undesirable units from being indexed
    // - Example:
    // -- Set UnitIndexerEnabled = False
    // -- Unit - Create 1 Dummy for (Triggering player) at TempLoc facing 0.00 degrees
    // -- Set UnitIndexerEnabled = True
    //  
    // You can also customize the following block - if conditions are false the (Matching unit) won't be indexed.
    //  
    if ( Trig_Unit_Indexer_Func019C() ) then
        //  
        // Generate a unique integer index for this unit
        //  
        if ( Trig_Unit_Indexer_Func019Func004C() ) then
            set udg_UDex=( udg_UDexGen + 1 )
            set udg_UDexGen=udg_UDex
        else
            set udg_UDex=udg_UDexRecycle
            set udg_UDexRecycle=udg_UDexNext[udg_UDex]
        endif
        //  
        // Link index to unit, unit to index
        //  
        set udg_UDexUnits[udg_UDex]=GetFilterUnit()
        call SetUnitUserData(udg_UDexUnits[udg_UDex], udg_UDex)
        set udg_IsUnitPreplaced[udg_UDex]=udg_IsUnitPreplaced[0]
        //  
        // Use a doubly-linked list to store all active indexes
        //  
        set udg_UDexPrev[udg_UDexNext[0]]=udg_UDex
        set udg_UDexNext[udg_UDex]=udg_UDexNext[0]
        set udg_UDexNext[0]=udg_UDex
        //  
        // Fire index event for UDex
        //  
        set udg_UnitIndexEvent=0.00
        set udg_UnitIndexEvent=1.00
        set udg_UnitIndexEvent=0.00
    else
    endif
        set udg_UDex=pdex
        return false
    endfunction
    //  
    // The next function initializes the core of the system
    //  
    function InitializeUnitIndexer takes nothing returns nothing
        local integer i= 0
        local region re= CreateRegion()
        local rect r= GetWorldBounds()
        local boolexpr b= Filter(function IndexUnit)
    set udg_UnitIndexEvent=- 1.00
    set udg_UnitIndexerEnabled=true
    set udg_IsUnitPreplaced[0]=true
        call RegionAddRect(re, r)
        call TriggerRegisterEnterRegion(CreateTrigger(), re, b)
        call RemoveRect(r)
        set re=null
        set r=null
        loop
            call GroupEnumUnitsOfPlayer(bj_lastCreatedGroup, Player(i), b)
            set i=i + 1
            exitwhen i == bj_MAX_PLAYER_SLOTS
        endloop
        set b=null
    //  
    // This is the "Unit Indexer Initialized" event, use it instead of "Map Initialization" for best results
    //  
    set udg_IsUnitPreplaced[0]=false
    set udg_UnitIndexEvent=3.00
endfunction

//===========================================================================
function InitTrig_Unit_Indexer takes nothing returns nothing
    set gg_trg_Unit_Indexer=CreateTrigger()
    call TriggerAddAction(gg_trg_Unit_Indexer, function Trig_Unit_Indexer_Actions)
endfunction

//===========================================================================
// Trigger: Inventory System Setup
//===========================================================================
function Trig_Inventory_System_Setup_Actions takes nothing returns nothing
    // =============================================================
    //   SETUP  
    // =============================================================
    // Set the multi-page inventory abilities here following the examples:                         
    // (Just copy any inventory ability. The inventory doesn't even need to have 6 slots)          
    // (Use the ability's "Stats - Priority for Spell Steal" field as the number of pages for that inventory.)    
    set udg_InvAbility[1]='A000'
    set udg_InvAbility[2]='A001'
    set udg_InvAbility[3]='A002'
    set udg_InvAbility[4]='A003'
    set udg_InvAbility[5]='A004'
    set udg_InvAbility[6]='A005'
    set udg_InvAbility[7]='A006'
    set udg_InvAbility[8]='A007'
    //                                                                                                                           
    // Set total amount of different inventory abilities:             
    set udg_InvAbilitiesTotal=8
    // =============================================================
    // Hotkeys:
    // (Valid hotkeys: A...Z, NumPad0...NumPad9, NumPad/, NumPad*, NumPad-, NumPad+)
    set udg_InvHotkeyLeft="G"
    set udg_InvHotkeyRight="T"
    // =============================================================
    //                                                                                                                           
    //                                                                                                                           
    //                                                                                                                           
    //                                                                                                                           
    // =============================================================
    // Don't touch the code below!
    // =============================================================
    call InitHashtableBJ()
    set udg_InvHash=GetLastCreatedHashtableBJ()
    call CreateInventoryButtons()
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=GetPlayers()
    loop
        exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
        call InventoryButtonsHide(ConvertedPlayer(GetForLoopIndexA()))
        set bj_forLoopAIndex=bj_forLoopAIndex + 1
    endloop
    // =============================================================
endfunction

//===========================================================================
function InitTrig_Inventory_System_Setup takes nothing returns nothing
    set gg_trg_Inventory_System_Setup=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Inventory_System_Setup, 0.00)
    call TriggerAddAction(gg_trg_Inventory_System_Setup, function Trig_Inventory_System_Setup_Actions)
endfunction

//===========================================================================
// Trigger: Init
//===========================================================================
function Trig_Init_Actions takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player(0), Player(1), bj_ALLIANCE_ALLIED)
    call SetPlayerAllianceStateBJ(Player(1), Player(0), bj_ALLIANCE_ALLIED)
    call FogEnableOff()
    call FogMaskEnableOff()
endfunction

//===========================================================================
function InitTrig_Init takes nothing returns nothing
    set gg_trg_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Init, function Trig_Init_Actions)
endfunction

//===========================================================================
// Trigger: Change owner
//===========================================================================
function Trig_Change_owner_Func001Func001C takes nothing returns boolean
    if ( not ( GetOwningPlayer(GetEnumUnit()) == Player(0) ) ) then
        return false
    endif
    return true
endfunction

function Trig_Change_owner_Func001A takes nothing returns nothing
    if ( Trig_Change_owner_Func001Func001C() ) then
        call SetUnitOwner(GetEnumUnit(), Player(1), true)
    else
        call SetUnitOwner(GetEnumUnit(), Player(0), true)
    endif
endfunction

function Trig_Change_owner_Actions takes nothing returns nothing
    call ForGroupBJ(GetUnitsInRectAll(GetPlayableMapRect()), function Trig_Change_owner_Func001A)
    call InventoryButtonsHide(GetTriggerPlayer())
endfunction

//===========================================================================
function InitTrig_Change_owner takes nothing returns nothing
    set gg_trg_Change_owner=CreateTrigger()
    call TriggerRegisterPlayerEventEndCinematic(gg_trg_Change_owner, Player(0))
    call TriggerAddAction(gg_trg_Change_owner, function Trig_Change_owner_Actions)
endfunction

//===========================================================================
// Trigger: Inventory descriptions
//===========================================================================
function Trig_Inventory_descriptions_Func002C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_hpea_0000 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func003C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_Edem_0243 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func004C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_Emoo_0242 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func005C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_Hblm_0165 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func006C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_hfoo_0106 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func007C takes nothing returns boolean
    if ( not ( GetTriggerUnit() == gg_unit_Oshd_0311 ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Func008C takes nothing returns boolean
    if ( not ( GetOwningPlayer(GetTriggerUnit()) != Player(0) ) ) then
        return false
    endif
    return true
endfunction

function Trig_Inventory_descriptions_Actions takes nothing returns nothing
    call ClearTextMessagesBJ(GetPlayersAll())
    if ( Trig_Inventory_descriptions_Func002C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_043")
    else
    endif
    if ( Trig_Inventory_descriptions_Func003C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_044")
    else
    endif
    if ( Trig_Inventory_descriptions_Func004C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_045")
    else
    endif
    if ( Trig_Inventory_descriptions_Func005C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_051")
    else
    endif
    if ( Trig_Inventory_descriptions_Func006C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_046")
    else
    endif
    if ( Trig_Inventory_descriptions_Func007C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_047")
    else
    endif
    if ( Trig_Inventory_descriptions_Func008C() ) then
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_052")
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_048")
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_049")
        call DisplayTextToForce(GetPlayersAll(), "TRIGSTR_050")
    else
    endif
endfunction

//===========================================================================
function InitTrig_Inventory_descriptions takes nothing returns nothing
    set gg_trg_Inventory_descriptions=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Inventory_descriptions, Player(0), true)
    call TriggerAddAction(gg_trg_Inventory_descriptions, function Trig_Inventory_descriptions_Actions)
endfunction

//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Unit_Indexer()
    call InitTrig_Inventory_System_Setup()
    call InitTrig_Init()
    call InitTrig_Change_owner()
    call InitTrig_Inventory_descriptions()
endfunction

//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_Unit_Indexer)
    call ConditionalTriggerExecute(gg_trg_Init)
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), true)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_002
    call SetPlayerTeam(Player(0), 0)

endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds(- 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("LordaeronSummerDay")
    call SetAmbientNightSound("LordaeronSummerNight")
    call SetMapMusic("Music", true, 0)
    call CreateAllItems()
    call CreateAllUnits()
    call InitBlizzard()


    call InitGlobals()
    call InitCustomTriggers()
    call RunInitializationTriggers()

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName("TRIGSTR_003")
    call SetMapDescription("TRIGSTR_005")
    call SetPlayers(1)
    call SetTeams(1)
    call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)

    call DefineStartLocation(0, - 320.0, - 512.0)

    // Player setup
    call InitCustomPlayerSlots()
    call SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    call InitGenericPlayerSlots()
endfunction




//Struct method generated initializers/callers:

