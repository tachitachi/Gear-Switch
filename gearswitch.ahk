;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

reload:

cheats = 0
item_x = -1
item_y = -1

;IniRead, numHotkeys, config.ini, Setup, hotkeys, 0
IniRead, windowName, config.ini, Setup, window, 0
IniRead, chatTimeout, config.ini, Setup, chatTimeout, 5000

numHotkeys = 20

IniRead, toggle, config.ini, Setup, toggleKey, 0
IniRead, reloadKey, config.ini, Setup, reloadKey, 0

Hotkey, IfWinActive, ahk_class %windowName%
Hotkey, %toggle%, ToggleMacros, On
Hotkey, IfWinActive
Hotkey, %toggle%, DefaultAction, On



Hotkey, IfWinActive, ahk_class %windowName%
Hotkey, %reloadKey%, reload, On
Hotkey, IfWinActive
Hotkey, %reloadKey%, DefaultAction, On






Loop, %numHotkeys%
{
	i = %A_Index%
	en := "enabled" . i
	tn := "trigger" . i
	an := "addKey" . i
	
	section := "Hotkey" . i
	
	IniRead, e, config.ini, %section%, enabled, 0
	IniRead, t, config.ini, %section%, trigger, 0
	IniRead, a, config.ini, %section%, addKey, 0
	IniRead, nd, config.ini, %section%, nodisable, 0
	IniRead, nt, config.ini, %section%, notrigger, 0
	IniRead, s, config.ini, %section%, addSpam, 0
	IniRead, c, config.ini, %section%, addClick, 0
	IniRead, r, config.ini, %section%, reverse, 0
	
	key1_%i% = %t%
	key2_%i% = %a%
	nd_%i% = %nd%
	nt_%i% = %nt%
	s_%i% = %s%
	c_%i% = %c%
	r_%i% = %r%
	
	Hotkey1 = %t%

	if e = 1
	{
	
			Hotkey, IfWinActive, ahk_class %windowName%
			Hotkey, %Hotkey1%, SpecialAction, On
			Hotkey, IfWinActive
			Hotkey, %Hotkey1%, DefaultAction, On
			
	}
	
}



IniRead, buffEnabled, config.ini, Buff, enabled, 0

if buffEnabled = 1
{

	IniRead, buffKey, config.ini, Buff, buffKey, F3
	IniRead, resetKey, config.ini, Buff, resetKey, F4
	IniRead, itemWidth, config.ini, Buff, itemWindowWidth, 7
	IniRead, itemStart, config.ini, Buff, startSlot, 1
	IniRead, numBuffs, config.ini, Buff, buffs, 3
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %buffKey%, itemBuffs, On
	Hotkey, IfWinActive
	Hotkey, %buffKey%, DefaultAction, On
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %resetKey%, resetBuffs, On
	Hotkey, IfWinActive
	Hotkey, %resetKey%, DefaultAction, On
	




}

IniRead, replayEnabled, config.ini, Replay, enabled, 0

if replayEnabled = 1
{

	IniRead, replayKey, config.ini, Replay, nameKey, F9
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %replayKey%, replayName, On
	Hotkey, IfWinActive
	Hotkey, %replayKey%, DefaultAction, On
	
}

IniRead, hpSpamEnabled, config.ini, HPspam, enabled, 0

if hpSpamEnabled = 1
{

	IniRead, hpKey, config.ini, HPspam, key, a
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %hpKey%, hpSpam, On
	Hotkey, IfWinActive
	Hotkey, %hpKey%, DefaultAction, On
	
}

IniRead, spSpamEnabled, config.ini, SPspam, enabled, 0

if spSpamEnabled = 1
{

	IniRead, spKey, config.ini, SPspam, key, s
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %spKey%, spSpam, On
	Hotkey, IfWinActive
	Hotkey, %spKey%, DefaultAction, On
	
}


IniRead, slowSpamEnabled, config.ini, SlowSpam, enabled, 0

if slowSpamEnabled = 1
{

	IniRead, slowKey, config.ini, SlowSpam, key, e
	
	Hotkey, IfWinActive, ahk_class %windowName%
	Hotkey, %slowKey%, slowSpam, On
	Hotkey, IfWinActive
	Hotkey, %slowKey%, DefaultAction, On
	
}


getKeyNum(trigger,hotkeys)
{
	Loop, %hotkeys%
	{
		i = %A_Index%
		k = key1_%i%
		k := %k%
		if trigger = %k%
		{
			return i
		}
	
	}
	return
}


getKey(trigger,hotkeys)
{
	Loop, %hotkeys%
	{
		i = %A_Index%
		k = key1_%i%
		k := %k%
		if trigger = %k%
		{
			k2 = key2_%i%
			k2 := %k2%
			
			if RegExMatch(k2, "[a-zA-Z0-9]+"){
				SendInput {%k2%}
				return i
			}
			SendInput %k2%
			return i
		}
	
	}
	return
}



$Backspace::
{
	Send {Backspace}
	
	if cheats = 1
	{
		cheats = 0
		chat = 1
		SetTimer, chatReset, %chatTimeout%
		return
	}

	return
}

$Enter::
{
	Send {Enter}
	
	if chat = 1
	{
		chat = 0
		cheats = 1
		SetTimer, chatReset, off
		return
	}

	return
}

doubleclick(){
	Click down
	sleep 100
	Click up
	sleep 50
	Click down
	sleep 100
	Click up
}


Skip:
	Goto, AfterHotkey

	
SpecialAction:
	tempkey = %A_thisHotkey%
	Hotkey, %tempkey%, Off
	
	i := getKeyNum(tempkey,numHotkeys)
	v := nd_%i%
	addClick := c_%i%
	addSpam := s_%i%
	notrigger := nt_%i%
	r := r_%i%
	
	spamcount = 0
	if (cheats = 1 or v = 1) and (addSpam = 1)
	Loop
	{ 
		if not GetKeyState(tempkey,"P") 
			break 

		if spamcount = 5
			break
			
		if (cheats = 1 or v = 1) and (r = 0)
			getKey(tempkey,numHotkeys)
		
		if notrigger = 0
		{
			if RegExMatch(tempkey, "[a-zA-Z0-9]+"){
				SendInput {%tempkey%}
				
				if (addClick = 1) and (cheats = 1 or v = 1)
				{
					sleep 15
					Click down
					sleep 15
					Click up
				}
			}
			else
			{
				SendInput %tempkey%
			}
		}
		
		if (cheats = 1 or v = 1) and (r = 1)
			getKey(tempkey,numHotkeys)
			
        sleep 15
			
	}
	else
	{
		if (cheats = 1 or v = 1) and (r = 0)
			getKey(tempkey,numHotkeys)
		
		if notrigger = 0
		{
			if RegExMatch(tempkey, "[a-zA-Z0-9]+"){
				SendInput {%tempkey%}
				
				if (addClick = 1) and (cheats = 1 or v = 1)
				{
					sleep 15
					Click down
					sleep 15
					Click up
					sleep 15
					SendInput {%tempkey%}
				}
			}
			else
			{
				SendInput %tempkey%
			}
		}
		
		if (cheats = 1 or v = 1) and (r = 1)
			getKey(tempkey,numHotkeys)
	}
	
	
	
	
	
	
	Hotkey, %tempkey%, On
return

DefaultAction:
	tempkey = %A_thisHotkey%
	Hotkey, %tempkey%, Off
	
	if RegExMatch(tempkey, "[a-zA-Z0-9]+"){
		SendInput {%tempkey%}
		return
	}
	
	
	SendInput %tempkey%
	Hotkey, %tempkey%, On
return

ToggleMacros:
	tempkey = %A_thisHotkey%
	Hotkey, %tempkey%, Off
	cheats := !cheats
	Hotkey, %tempkey%, On
return

chatReset:
	SetTimer, chatReset, off
	chat = 0
	cheats = 1
return

itemBuffs:

	MouseGetPos, curx, cury

	if item_x = -1
	{
		MouseGetPos, item_x, item_y
		item_x := item_x - (itemStart - 1) * 32
	}
	
	blockinput MouseMove

	Loop, %numBuffs%
	{
	
		i := A_Index - 1
		xoff := Mod(i + (itemStart - 1), itemWidth)
		yoff := (i + (itemStart - 1)) // itemWidth
	
		
		MouseMove, item_x + xoff * 32, item_y + yoff * 32, 0
		doubleclick()
		sleep 100
		
		
	
	}
	
	MouseMove, curx, cury, 0
	
	blockinput MouseMoveOff

return	

replayName:
    FormatTime, date,, WoE_yyyy-MM-dd-HH-mm-ss
    send %date%
return

hpSpam:
	tempkeyHp = %A_thisHotkey%
	Hotkey, %tempkeyHp%, Off
	
	hpcount = 0
	if cheats = 1
	Loop
	{ 
		if not GetKeyState(tempkeyHp,"P") 
			break 

		if hpcount = 5
			break
			
		if RegExMatch(tempkeyHp, "[a-zA-Z0-9]+"){
			SendInput {%tempkeyHp%}
		}
		else
			SendInput %tempkeyHp%
		
		sleep 100
		hpcount++
	}
	else{
		if RegExMatch(tempkeyHp, "[a-zA-Z0-9]+"){
			SendInput {%tempkeyHp%}
		}
		else
			SendInput %tempkeyHp%
	}
	
	Hotkey, %tempkeyHp%, On
return

spSpam:
	tempkeySp = %A_thisHotkey%
	Hotkey, %tempkeySp%, Off
	
	spcount = 0
	if cheats = 1
	Loop
	{ 
		if not GetKeyState(tempkeySp,"P") 
			break 
			
		if spcount = 5
			break

		if RegExMatch(tempkeySp, "[a-zA-Z0-9]+"){
			SendInput {%tempkeySp%}
		}
		else
			SendInput %tempkeySp%
		sleep 100
		spcount++
	}
	else{
	if RegExMatch(tempkeySp, "[a-zA-Z0-9]+"){
			SendInput {%tempkeySp%}
		}
		else
			SendInput %tempkeySp%
	}
	
	Hotkey, %tempkeySp%, On
return


slowSpam:
	tempkeySlow = %A_thisHotkey%
	Hotkey, %tempkeySlow%, Off
	
	slowcount = 0
	if cheats = 1
	Loop
	{ 
		if not GetKeyState(tempkeySlow,"P") 
			break 

		if slowcount = 5
			break
			
		if RegExMatch(tempkeySlow, "[a-zA-Z0-9]+"){
			SendInput {%tempkeySlow%}
		}
		else
			SendInput %tempkeySlow%
		sleep 200
		slowcount++
	}
	else{
		if RegExMatch(tempkeySlow, "[a-zA-Z0-9]+"){
			SendInput {%tempkeySlow%}
		}
		else
			SendInput %tempkeySlow%
	}
	
	Hotkey, %tempkeySlow%, On
return



resetBuffs:
	item_x = -1
	item_y = -1


return
	
AfterHotkey:


