#!/usr/bin/perl

use strict;

package PowerBindCmds;

sub caseless {
	my ($s)
	return string.gsub(s,"%a",function(z) return "["..z:lower()..z:upper().."]" end)
}

sub match1arg {
	my ($s,arg1,arg2match)
	arg2match = arg2match or "(.*)"
	local a,b = string.match(s,"^([^ ]*) "..arg2match)
	if (not a) { return nil }
	if (a:lower() == arg1:lower()) { return b }
}

sub match2arg {
	my ($s,arg1,arg2match,arg3match)
	arg2match = arg2match or "(.*)"
	arg3match = arg3match or "(.*)"
	local a,b,c = string.match(s,"^([^ ]*) "..arg2match.." "..arg3match)
	if (not a) { return nil }
	if (a:lower() == arg1:lower()) { return b,c }
}

local formUsePowerCmd = function(t,profile,refreshcb)
	local powerlist = profile.powerset or {}
	t.settings = iup.frame{iup.vbox{
		(cbListBox("Method",{"Toggle","On","Off"},3,t.method,
			function(_,s,i,v)
				if (v == 1) { t.method = i }
				profile.modified = true
				if (refreshcb) { refreshcb() }
			}
		)),
		(cbListBox("Power",powerlist,table.getn(powerlist),t.power,
			function(_,s,i,v)
				if (v == 1) { t.power = s }
				profile.modified = true
				if (refreshcb) { refreshcb() }
			},
		196,nil,100,nil,true))
	}}
	return t
}

local newUsePowerCmd = function()
	-- return a table containing the needed items for controlling this power.
	local t = {}
	t.type = "Use Power"
	t.method = 1
	t.power = ""
	return t
}

local makeUsePowerCmd = function(t)
	if (t.method == 1) {
		return "powexecname "..t.power
	elseif (t.method == 2) {
		return "powexectoggleon "..t.power
	else
		return "powexectoggleoff "..t.power
	}
}

local matchUsePowerCmd = function(s,profile)
	local power = match1arg(s,"powexecname")
	if (power) { return {type="Use Power",method=1,power=power} }
	power = match1arg(s,"powexectoggleon")
	if (power) { return {type="Use Power",method=2,power=power} }
	power = match1arg(s,"powexectoggleoff")
	if (power) { return {type="Use Power",method=3,power=power} }
}

addCmd("Use Power",newUsePowerCmd,formUsePowerCmd,makeUsePowerCmd,matchUsePowerCmd)

sub cbGetColor {
	my ($r,g,b)
	local tr, tg, tb = r,g,b
	local redbox, greenbox, bluebox
	local colorbox
	local okbtn, cancelbtn
	colorbox = iup.colorbrowser{rgb=tr.." "..tg.." "..tb}
	redbox,redtext = cbTextBox("Red:",tr,function(_,c,s) tr = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
	greenbox,greentext = cbTextBox("Green:",tg,function(_,c,s) tg = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
	bluebox,bluetext = cbTextBox("Blue:",tb,function(_,c,s) tb = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
	colorbox.drag_cb = function(_,cbr,cbg,cbb) tr, tg, tb = cbr, cbg, cbb redtext.value = cbr greentext.value = cbg bluetext.value = cbb }
	okbtn = iup.button{title="OK";rastersize="100x21"}
	cancelbtn = iup.button{title="Cancel";rastersize="100x21"}
	local box = iup.hbox{colorbox,iup.vbox{redbox,greenbox,bluebox,iup.hbox{okbtn,cancelbtn}}}
	local colordlg = iup.dialog{box,title="Select a Color",maxbox="NO",resize="NO"}
	okbtn.action = function() colordlg:hide() }
	cancelbtn.action = function() tr,tg,tb = r,g,b colordlg:hide() }
	colordlg:popup(iup.CENTER,iup.CENTER)
	return tr, tg, tb
}

local formChatCommand = function(t,profile,refreshcb)
	local bordercolor = iup.label{title=" ";image = buildColorImage(t.border.r,t.border.g,t.border.b); rastersize="17x17"}
	local borderbtn = iup.button{title="Border";rastersize="46x21"}
	borderbtn.action=function()
		t.border.r,t.border.g,t.border.b = cbGetColor(t.border.r,t.border.g,t.border.b)
		bordercolor.image = buildColorImage(t.border.r,t.border.g,t.border.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}
	local bgcolor = iup.label{title=" ";image = buildColorImage(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b); rastersize="17x17"}
	local bgbtn = iup.button{title="BG";rastersize="45x21"}
	bgbtn.action=function()
		t.bgcolor.r,t.bgcolor.g,t.bgcolor.b = cbGetColor(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
		bgcolor.image = buildColorImage(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}
	local textcolor = iup.label{title=" ";image = buildColorImage(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b); rastersize="17x17"}
	local textbtn = iup.button{title="Text";rastersize="46x21"}
	textbtn.action=function()
		t.fgcolor.r,t.fgcolor.g,t.fgcolor.b = cbGetColor(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
		textcolor.image = buildColorImage(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}

	t.settings = iup.frame{iup.vbox{
		(cbCheckBox("Chat Bubble Colors",t.usecolors,function(_,v) if (v == 1) { t.usecolors = true else t.usecolors = nil } profile.modified = true if (refreshcb) { refreshcb() } })),
		iup.hbox{
			iup.frame{bordercolor;sunken="YES"; rastersize="21x21";margin="1x1"},borderbtn,
			iup.frame{bgcolor;sunken="YES"; rastersize="21x21";margin="1x1"},bgbtn,
			iup.frame{textcolor;sunken="YES"; rastersize="21x21";margin="1x1"},textbtn},
		(cbListBox("Duration",{"1","2","3","4","5","6","7 (Default)","8","9","10","11","12","13","14","15","16","17","18","19","20"},20,t.duration,function(_,s,i,v)
			if (v == 1) { t.duration = i } profile.modified = true if (refreshcb) { refreshcb() } })),
		(cbListBox("Size",{"0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5"},11,tostring(t.size),function(_,s,i,v)
			if (v == 1) { t.size = tonumber(s) } profile.modified = true if (refreshcb) { refreshcb() } },nil,nil,nil,nil,true)),
		(cbListBox("Channel",{"say","group","broadcast","local","yell","fri}s","request","arena","supergroup","coalition","tell $target,","tell $name,"},12,t.channel,cbListBoxCB(profile,t,"channel",nil,refreshcb))),
		--(cbToggleText("Message",t.usemsg,t.text,cbCheckBoxCB(profile,t,"usemsg"),cbTextBoxCB(profile,t,"text",refreshcb),nil,nil,196))
		(cbCheckBox("Use Beginchat",not t.usemsg,cbCheckBoxCB(profile,t,"usemsg",
			function()
				t.usemsg = not t.usemsg
				if (refreshcb) { refreshcb() }
			}),196)),
		(cbTextBox("Message",t.text,cbTextBoxCB(profile,t,"text",refreshcb),196,nil,100))
		--iup.label{title="Text"},
		--cbTextBox(nil,t.text,function(_,c,s) profile.modified = true t.text = s return iup.DEFAULT },296)
	}}
	return t
}

local newChatCommand = function()
	local t = {}
	t.type = "Chat Command"
	t.channel = 1
	t.text = ""
	t.duration = 7
	t.size = 1.0
	t.usecolors = nil
	t.border = {}
	t.border.r = 0
	t.border.g = 0
	t.border.b = 0
	t.fgcolor = {}
	t.fgcolor.r = 0
	t.fgcolor.g = 0
	t.fgcolor.b = 0
	t.bgcolor = {}
	t.bgcolor.r = 255
	t.bgcolor.g = 255
	t.bgcolor.b = 255
	return t
}

local chatchannelmap = {"s","g","b","l","y","f","req","ac","sg","c","t $target,","t $name,"}

local makeChatCommand = function(t)
	local size = "<scale "..t.size..">"
	local duration = "<duration "..t.duration..">"
	local border = string.format("<bordercolor #%02x%02x%02x>",t.border.r,t.border.g,t.border.b)
	local color = string.format("<color #%02x%02x%02x>",t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
	local bgcolor = string.format("<bgcolor #%02x%02x%02x>",t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
	if (t.size == 1.0) { size = "" }
	if (t.duration == 7) { duration = "" }
	if (not t.usecolors) {
		border = ""
		color = ""
		bgcolor = ""
	}
	if (t.usemsg) {
		return chatchannelmap[t.channel].." "..size..duration..border..color..bgcolor..t.text
	else
		return "beginchat /"..chatchannelmap[t.channel].." "..size..duration..border..color..bgcolor..t.text
	}
}

local hexconv={["0"] = 0,["1"] = 1,["2"] = 2,["3"] = 3,["4"] = 4,["5"] = 5,["6"] = 6,["7"] = 7,
	["8"] = 8,["9"] = 9,["a"] = 10,["b"] = 11,["c"] = 12,["d"] = 13,["e"] = 14,["f"] = 15}

local sub stringToColor {
	my ($s)
	local t = {s:byte(1,-1)}
	local r = (hexconv[t[1]]*16)+hexconv[t[2]]
	local g = (hexconv[t[3]]*16)+hexconv[t[4]]
	local b = (hexconv[t[5]]*16)+hexconv[t[6]]
	return {r=r,g=g,b=b}
}

local chatchannel = {"s","g","b","l","y","f","req","ac","sg","c","t $target,","t $name,","tell $target,","tell $name,","p $target,","p $name,",
	"private $target,","private $name,","whisper $target,","whisper $name,","fri}s","group","team","yell","broadcast","local","request","sell",
	"auction","supergroup","coalition","arena","say"}
local revchatchannel = {["say"] = 1,["s"] = 1,["t $target,"] = 11,["tell $target,"] = 11,["private $target,"] = 11,["p $target,"] = 11,
	["whisper $target,"] = 11,["t $name,"] = 12,["tell $name,"] = 12,["private $name,"] = 12,["p $name,"] = 12,["whisper $name,"] = 12,["f"] = 6,
	["group"] = 2,["g"] = 2,["team"] = 2,["yell"] = 5,["y"] = 5,["broadcast"] = 3,["b"] = 3,["local"] = 4,["l"] = 4,["request"] = 7,["req"] = 7,
	["sell"] = 7,["auction"] = 7,["supergroup"] = 9,["sg"] = 9,["coalition"] = 10,["c"] = 10,["ac"] = 8,["arena"] = 8,}

local matchChatCommand = function(s,profile)
	for i,v in ipairs(chatchannel) do
		local withmessage = true
		local msg = match1arg(s,v)
		if (not msg) {
			local s2
			if (string.sub(s,1,11):lower() == "beginchat /") {
				s2 = string.sub(s,12,-1)
				msg = match1arg(s2,v)
				if (msg) { withmessage = nil }
			}
		}
		if (not msg) {
			if (s:lower() == "beginchat /"..v.." ") {
				msg = ""
				withmessage = nil
			}
		}
		if (msg) {
			local size = match1arg(msg,"<scale","(.*)>")
			if (size) {
				msg = string.gsub(msg,caseless("<scale "..size..">"),"")
				size = tonumber(size)
			}
			if (not size) { size = 1.0 }
			local duration = match1arg(msg,"<duration","(.*)>")
			if (duration) {
				msg = string.gsub(msg,caseless("<duration "..duration..">"),"")
				duration = tonumber(duration)
			}
			if (not duration) { duration = 7 }
			local usecolors
			local border = match1arg(msg,"<bordercolor","#(%x%x%x%x%x%x)>")
			if (border) {
				msg = string.gsub(msg,caseless("<bordercolor #"..border..">"),"")
				border = stringToColor(border)
				usecolors = true
			}
			if (not border) { border = {r=0,g=0,b=0} }
			local color = match1arg(msg,"<color","#(%x%x%x%x%x%x)>")
			if (color) {
				msg = string.gsub(msg,caseless("<color #"..color..">"),"")
				color = stringToColor(color)
				usecolors = true
			}
			if (not color) { color = {r=0,g=0,b=0} }
			local bgcolor = match1arg(msg,"<bgcolor","#(%x%x%x%x%x%x)>")
			if (bgcolor) {
				msg = string.gsub(msg,caseless("<bgcolor #"..bgcolor..">"),"")
				bgcolor = stringToColor(bgcolor)
				usecolors = true
			}
			if (not bgcolor) { bgcolor = {r=255,g=255,b=255} }
			--if (not withmessage) { msg = "" }
			-- now build the table with the information at hand...
			local t = {}
			t.type = "Chat Command"
			t.channel = revchatchannel[v]
			t.usemsg = withmessage
			t.text = msg
			t.duration = duration
			t.size = size
			t.usecolors = usecolors
			t.border = border
			t.fgcolor = color
			t.bgcolor = bgcolor
			return t
		}
	}
}

addCmd("Chat Command",newChatCommand,formChatCommand,makeChatCommand,matchChatCommand)

local formCostumeChange = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Costume",{"First","Second","Third","Fourth","Fifth"},5,t.cslot+1,function(_,s,i,v)
			if (v == 1) { t.cslot = i - 1 }
			profile.modified = true
			if (refreshcb) { refreshcb() }
		},nil,nil,196))}
	return t
}

local newCostumeChange = function()
	local t = {}
	t.type = "Costume Change"
	t.cslot = 0
	return t
}

local makeCostumeChange = function(t)
	return "cc "..t.cslot
}

local matchCostumeChange = function(s,profile)
	local cslot
	cslot = match1arg(s,"cc","(%d*)")
	if (cslot and tonumber(cslot)) {
		if (tonumber(cslot) > -1 and tonumber(cslot) < 5) {
			return {type="Costume Change",cslot=tonumber(cslot)}
		}
	}
	cslot = match1arg(s,"costumechange","(%d*)")
	if (cslot and tonumber(cslot)) {
		if (tonumber(cslot) > -1 and tonumber(cslot) < 5) {
			return {type="Costume Change",cslot=tonumber(cslot)}
		}
	}
}

addCmd("Costume Change",newCostumeChange,formCostumeChange,makeCostumeChange,matchCostumeChange)

local formAFKMessage = function(t,profile,refreshcb)
	t.settings = iup.frame{cbTextBox(nil,t.afkmsg,cbTextBoxCB(profile,t,"afkmsg",refreshcb),296)}
	return t
}

local newAFKMessage = function()
	local t = {}
	t.type = "Away From Keyboard"
	t.afkmsg = ""
	return t
}

local makeAFKMessage = function(t)
	if (t.afkmsg == "") {
		return "afk"
	}
	return "afk "..t.afkmsg
}

local matchAFKMessage = function(s,profile)
	if (s:lower() == "afk ") { return nil }
	if (s:lower() == "afk") { return {type="Away From Keyboard",afkmsg=""} }
	local afkmsg = match1arg(s,"afk")
	if (afkmsg) { return {type="Away From Keyboard",afkmsg=afkmsg} }
}

addCmd("Away From Keyboard",newAFKMessage,formAFKMessage,makeAFKMessage,matchAFKMessage)

local formSGMode = function(t,profile)
	t.settings = nil
	return t
}

local newSGMode = function()
	local t = {}
	t.type = "SGMode Toggle"
	t.nosettings = true
	return t
}

local makeSGMode = function(t)
	return "sgmode"
}

local matchSGMode = function(s,profile)
	if (s:lower() == "sgmode") { return {type = "SGMode Toggle",nosettings = true} }
}

addCmd("SGMode Toggle",newSGMode,formSGMode,makeSGMode,matchSGMode)

local formUnselect = function(t,profile)
	t.settings = nil
	return t
}

local newUnselect = function()
	local t = {}
	t.type = "Unselect"
	t.nosettings = true
	return t
}

local makeUnselect = function(t)
	return "unselect"
}

local matchUnselect = function(s,profile)
	if (s:lower() == "unselect") { return {type="Unselect",nosettings=true} }
}

addCmd("Unselect",newUnselect,formUnselect,makeUnselect,matchUnselect)

local formTargetEnemy = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196))}
	return t
}

local newTargetEnemy = function()
	local t = {}
	t.type = "Target Enemy"
	t.mode = 1
	return t
}

local makeTargetEnemy = function(t)
	local tab = {"near","far","next","prev"}
	return "targetenemy"..tab[t.mode]
}

local matchTargetEnemy = function(s,profile)
	if (s:lower() == "targetenemynear") { return {type="Target Enemy",mode=1} }
	if (s:lower() == "targetenemyfar") { return {type="Target Enemy",mode=2} }
	if (s:lower() == "targetenemynext") { return {type="Target Enemy",mode=3} }
	if (s:lower() == "targetenemyprev") { return {type="Target Enemy",mode=4} }
}

addCmd("Target Enemy",newTargetEnemy,formTargetEnemy,makeTargetEnemy,matchTargetEnemy)

local formTargetFri} = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196))}
	return t
}

local newTargetFri} = function()
	local t = {}
	t.type = "Target Fri}"
	t.mode = 1
	return t
}

local makeTargetFri} = function(t)
	local tab = {"near","far","next","prev"}
	return "targetfri}"..tab[t.mode]
}

local matchTargetFriend = function(s,profile)
	if (s:lower() == "targetfriendnear") { return {type="Target Friend",mode=1} }
	if (s:lower() == "targetfriendfar") { return {type="Target Friend",mode=2} }
	if (s:lower() == "targetfriendnext") { return {type="Target Friend",mode=3} }
	if (s:lower() == "targetfriendprev") { return {type="Target Friend",mode=4} }
}

addCmd("Target Friend",newTargetFriend,formTargetFriend,makeTargetFriend,matchTargetFriend)

local formTargetCustom = function(t,profile,refreshcb)
	t.settings = iup.frame{iup.vbox{
		(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196)),
		iup.hbox{(cbCheckBox("Target Enemies",t.enemy,cbCheckBoxCB(profile,t,"enemy",refreshcb),148)),
			(cbCheckBox("Target Friends",t.friend,cbCheckBoxCB(profile,t,"friend",refreshcb),148))},
		iup.hbox{(cbCheckBox("Target Defeated",t.defeated,cbCheckBoxCB(profile,t,"defeated",refreshcb),148)),
			(cbCheckBox("Target Living",t.alive,cbCheckBoxCB(profile,t,"alive",refreshcb),148))},
		iup.hbox{(cbCheckBox("Target My Pets",t.mypet,cbCheckBoxCB(profile,t,"mypet",refreshcb),148)),
			(cbCheckBox("Target Not My Pets",t.notmypet,cbCheckBoxCB(profile,t,"notmypet",refreshcb),148))},
		iup.hbox{(cbCheckBox("Target Base Items",t.base,cbCheckBoxCB(profile,t,"base",refreshcb),148)),
			(cbCheckBox("Target No Base Items",t.notbase,cbCheckBoxCB(profile,t,"notbase",refreshcb),148))}
		}
	}
	return t
}

local newTargetCustom = function()
	local t = {}
	t.type = "Target Custom"
	t.mode = 1
	return t
}

local makeTargetCustom = function(t)
	local tab = {"near","far","next","prev"}
	local enemy = ""
	local friend = ""
	local defeated = ""
	local alive = ""
	local mypet = ""
	local notmypet = ""
	local base = ""
	local notbase = ""
	if (t.enemy) { enemy = " enemy" }
	if (t.friend) { friend = " friend" }
	if (t.defeated) { defeated = " defeated" }
	if (t.alive) { alive = " alive" }
	if (t.mypet) { mypet = " mypet" }
	if (t.notmypet) { notmypet = " notmypet" }
	if (t.base) { base = " base" }
	if (t.notbase) { notbase = " notbase" }
	return "targetcustom"..tab[t.mode]..enemy..friend..defeated..alive..mypet..notmypet..base..notbase
}

local matchTargetCustom = function(s,profile)
	local tab = {"near","far","next","prev"}
	for i,v in ipairs(tab) do
		if (s:lower() == "targetcustom"..v.." ") { return nil }
		local msg = match1arg(s,"targetcustom"..v)
		if (msg) {
			msg = " "..msg:lower()
			local enemy = string.match(msg," enemy")
			if (enemy) { msg = string.gsub(msg,caseless(" enemy"),"") enemy = true }
			local friend = string.match(msg," friend")
			if (friend) { msg = string.gsub(msg,caseless(" friend"),"") friend = true }
			local defeated = string.match(msg," defeated")
			if (defeated) { msg = string.gsub(msg,caseless(" defeated"),"") defeated = true }
			local alive = string.match(msg," alive")
			if (alive) { msg = string.gsub(msg,caseless(" alive"),"") alive = true }
			local mypet = string.match(msg," mypet")
			if (mypet) { msg = string.gsub(msg,caseless(" mypet"),"") mypet = true }
			local notmypet = string.match(msg," notmypet")
			if (notmypet) { msg = string.gsub(msg,caseless(" notmypet"),"") notmypet = true }
			local base = string.match(msg," base")
			if (base) { msg = string.gsub(msg,caseless(" base"),"") base = true }
			local notbase = string.match(msg," notbase")
			if (notbase) { msg = string.gsub(msg,caseless(" notbase"),"") notbase = true }
			--msg = string.gsub(msg," ","")
			--iup.Message("","|"..msg.."|")
			if (msg == "") {
				return {
					type="Target Custom",
					mode=i,
					enemy=enemy,
					friend=friend,
					defeated=defeated,
					alive=alive,
					mypet=mypet,
					notmypet=notmypet,
					base=base,
					notbase=notbase
				}
			}
		}
	}
}

addCmd("Target Custom",newTargetCustom,formTargetCustom,makeTargetCustom,matchTargetCustom)

local formPowExecTray = function(t,profile,refreshcb)
	t.settings = iup.frame{iup.hbox{
		(cbListBox("Power Tray",{"Main Tray","Alt Tray","Alt 2 Tray","Tray 1","Tray 2","Tray 3","Tray 4","Tray 5","Tray 6","Tray 7","Tray 8","Tray 9","Tray 10"},13,t.tray,cbListBoxCB(profile,t,"tray",nil,refreshcb),74,nil,74)),
		(cbListBox("Power Slot",{"1","2","3","4","5","6","7","8","9","10"},10,t.slot,cbListBoxCB(profile,t,"slot",nil,refreshcb),74,nil,74)),
		}
	}
	return t
}

local newPowExecTray = function()
	local t = {}
	t.type = "Use Power From Tray"
	t.tray = 1
	t.slot = 1
	return t
}

local makePowExecTray = function(t)
	local mode = "slot"
	local mode2 = ""
	if (t.tray > 3) { mode = "tray" mode2 = " "..(t.tray - 3) }
	if (t.tray == 3) { mode = "alt2slot" }
	if (t.tray == 2) { mode = "altslot" }
	return "powexec"..mode.." "..t.slot..mode2
}

local matchPowExecTray = function(s,profile)
	local tray,slot
	slot = match1arg(s,"powexecslot")
	if (slot and tonumber(slot)) { return {type="Use Power From Tray",tray=1,slot=tonumber(slot)} }
	slot = match1arg(s,"powexecaltslot")
	if (slot and tonumber(slot)) { return {type="Use Power From Tray",tray=2,slot=tonumber(slot)} }
	slot = match1arg(s,"powexecalt2slot")
	if (slot and tonumber(slot)) { return {type="Use Power From Tray",tray=3,slot=tonumber(slot)} }
	slot,tray = match2arg(s,"powexectray")
	if (slot and tray and tonumber(slot) and tonumber(tray)) { return {type="Use Power From Tray",tray=3+tonumber(tray),slot=tonumber(slot)} }
}

addCmd("Use Power From Tray",newPowExecTray,formPowExecTray,makePowExecTray,matchPowExecTray)

local formCustomBind = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbTextBox(nil,t.custom,cbTextBoxCB(profile,t,"custom",refreshcb),296))}
	return t
}

newCustomBind = function()
	local t = {}
	t.type = "Custom Bind"
	t.custom = ""
	return t
}

local makeCustomBind = function(t)
	return t.custom
}

addCmd("Custom Bind",newCustomBind,formCustomBind,makeCustomBind)

local emotelist = 
{"afraid","alakazam","alakazamreact","angry","assumepositionwall","atease","attack","backflip","batsmash",
"batsmashreact","bb","bbaltitude","bbbeat","bbcatchme","bbdance","bbdiscofreak","bbdogwalk","bbelectrovibe",
"bbheavydude","bbinfooverload","bbjumpy","bbkickit","bblooker","bbmeaty","bbmoveon","bbnotorious","bbpeace",
"bbquickie","bbraver","bbshuffle","bbspaz","bbtechnoid","bbvenus","bbwahwah","bbwinditup","bbyellow",
"beatchest","biglaugh","bigwave","blankfiller","boombox","bow","bowdown","burp","buzzoff","champion","cheer",
"chicken","clap","coin","cointoss","cower","crack","crossarms","curseyou","dance","dice","disagree",
"dontattack","drat","drink","dropboombox","drumdance","dustoff","elaugh","elegantbow","evillaugh","explain",
"fancybow","fear","flashlight","flex","flex1","flex2","flex3","flexa","flexb","flexc","flip","flipcoin",
"frustrated","getsome","goaway","grief","hand","handsup","hi","holdtorch","huh","jumpingjacks","kata","kissit",
"kneel","knuckle","knuckles","laptop","laugh","laugh2","laughtoo","lecture","ledgesit","lotus","martialarts",
"militarysalute","muahahaha","newspaper","no","nod","noooo","overhere","panhandle","paper","peerin","plot",
"point","praise","protest","raisehand","research","researchlow","roar","rock","rolldice","salute","scared",
"scheme","scissors","score1","score2","score3","score4","score5","score6","score7","score8","score9","score10",
"screen","shucks","sit","slap","slapreact","slash","slashthroat","sleep","smack","smackyou","sorry","stop",
"surrender","talk","talktohand","tarzan","taunt","taunt1","taunt2","taunta","tauntb","thanks","thankyou","thewave",
"threathand","thumbsup","touchscreen","type","typing","victory","villainlaugh","villainouslaugh","walllean",
"wave","wavefist","welcome","what","whistle","wings","winner","yata","yatayata","yes","yoga","yourewelcome"}
local emotecount = table.getn(emotelist)

local formEmoteBind = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Emote",emotelist,emotecount,t.emote,cbListBoxCB(profile,t,nil,"emote",refreshcb),196,nil,nil,nil,true))}
	return t
}

local newEmoteBind = function()
	local t = {}
	t.type = "Emote"
	t.emote = "afraid"
	return t
}

local makeEmoteBind = function(t)
	return "em "..t.emote
}

local matchEmoteBind = function(s,profile)
	local emote = match1arg(s,"e")
	if (emote) { return {type="Emote",emote=emote} }
	local emote = match1arg(s,"em")
	if (emote) { return {type="Emote",emote=emote} }
	local emote = match1arg(s,"me")
	if (emote) { return {type="Emote",emote=emote} }
	local emote = match1arg(s,"emote")
	if (emote) { return {type="Emote",emote=emote} }
}

addCmd("Emote",newEmoteBind,formEmoteBind,makeEmoteBind,matchEmoteBind)

local formPowerAbort = function(t,profile)
	t.settings = nil
	return t
}

local newPowerAbort = function()
	local t = {}
	t.type = "Power Abort"
	t.nosettings = true
	return t
}

local makePowerAbort = function(t)
	return "powexecabort"
}

local matchPowerAbort = function(s,profile)
	if (s:lower() == "powexecabort") { return {type="Power Abort",nosettings=true} }
}

addCmd("Power Abort",newPowerAbort,formPowerAbort,makePowerAbort,matchPowerAbort)

local formPowerUnqueue = function(t,profile)
	t.settings = nil
	return t
}

local newPowerUnqueue = function()
	local t = {}
	t.type = "Power Unqueue"
	t.nosettings = true
	return t
}

local makePowerUnqueue = function(t)
	return "powexecunqueue"
}

local matchPowerUnqueue = function(s,profile)
	if (s:lower() == "powexecunqueue") { return {type="Power Unqueue",nosettings=true} }
}

addCmd("Power Unqueue",newPowerUnqueue,formPowerUnqueue,makePowerUnqueue,matchPowerUnqueue)

local formAutoPower = function(t,profile,refreshcb)
	local powerlist = profile.powerset or {}
	t.settings = iup.frame{(cbListBox("Power",powerlist,table.getn(powerlist),t.power,
		function(_,s,i,v)
			if (v == 1) { t.power = s }
			profile.modified = true
			if (refreshcb) { refreshcb() }
		},196,nil,100,nil,true))
	}
	return t
}

local newAutoPower = function()
	-- return a table containing the needed items for controlling this power.
	local t = {}
	t.type = "Auto Power"
	t.power = ""
	return t
}

local makeAutoPower = function(t)
	return "powexecauto "..t.power
}

local matchAutoPower = function(s,profile)
	local power = match1arg(s,"powexecauto")
	if (power) { return {type="Auto Power",power=power} }
}

addCmd("Auto Power",newAutoPower,formAutoPower,makeAutoPower,matchAutoPower)

local formInspExecTray = function(t,profile,refreshcb)
	t.settings = iup.frame{iup.hbox{
		(cbTextBox("Row",t.row,cbTextBoxCB(profile,t,"row",refreshcb),74,nil,74)),
		(cbTextBox("Column",t.col,cbTextBoxCB(profile,t,"col",refreshcb),74,nil,74)),
		}
	}
	return t
}

local newInspExecTray = function()
	local t = {}
	t.type = "Use Inspiration From Row/Column"
	t.row = "1"
	t.col = "1"
	return t
}

local makeInspExecTray = function(t)
	if (t.row == "1") {
		return "inspexecslot "..t.col
	else
		return "inspexectray "..t.col.." "..t.row
	}
}

local matchInspExecTray = function(s,profile)
	local col,row = match2arg(s,"inspexectray","(%d*)","(%d*)")
	if (col and row) { return {type="Use Inspiration From Row/Column",row=row,col=col} }
	col = match1arg(s,"inspexecslot","(%d*)")
	if (col) { return {type="Use Inspiration From Row/Column",row="1",col=col} }
}

addCmd("Use Inspiration From Row/Column",newInspExecTray,formInspExecTray,makeInspExecTray,matchInspExecTray)

local insps = {"Insight","Keen Insight","Uncanny Insight",
"Respite","Dramatic Improvement","Resurgance",
"Enrage","Focused Rage","Righteous Rage",
"Catch a Breath","Take a Breather","Second Wind",
"Luck","Good Luck","Phenomenal Luck",
"Break Free","Emerge","Escape",
"Sturdy","Rugged","Robust"}

local formInspExecName = function(t,profile,refreshcb)
	t.settings = iup.frame{
		(cbListBox("Inspiration",insps,table.getn(insps),t.insp,cbListBoxCB(profile,t,"insp",nil,refreshcb),196))
	}
	return t
}

local newInspExecName = function()
	local t = {}
	t.type = "Use Inspiration By Name"
	t.insp = 1
	return t
}

local makeInspExecName = function(t)
	return "inspexecname "..insps[t.insp]
}

local matchInspExecName = function(s,profile)
	for i,v in ipairs(insps) do
		if (s:lower() == "inspexecname "..v:lower()) { return {type="Use Inspiration By Name",insp=i} }
	}
}

addCmd("Use Inspiration By Name",newInspExecName,formInspExecName,makeInspExecName,matchInspExecName)

local formGlobalChat = function(t,profile,refreshcb)
	if (t.prefix) { t.msg = t.prefix..' '..t.msg t.prefix = nil }
	t.settings = iup.frame{iup.vbox{
		(cbTextBox("Channel",t.channel,cbTextBoxCB(profile,t,"channel",refreshcb),196,nil,100)),
		(cbCheckBox("Use Beginchat",not t.usemsg,cbCheckBoxCB(profile,t,"usemsg",
			function()
				t.usemsg = not t.usemsg
				if (refreshcb) {
					refreshcb()
				}
			}),196,nil,100)),
		(cbTextBox("Message",t.msg,cbTextBoxCB(profile,t,"msg",refreshcb),100,nil,196))}
	}
	return t
}

local newGlobalChat = function()
	local t = {}
	t.type = "Chat Command (Global)"
	t.channel = "CityBinder"
	t.msg = "[$name $level]:"
	return t
}

local makeGlobalChat = function(t)
	if (t.prefix) { t.msg = t.prefix..' '..t.msg t.prefix = nil }
	if (t.usemsg) {
		return 'send "'..t.channel..'" '..t.msg
	else
		return 'beginchat /send "'..t.channel..'" '..t.msg
	}
}

local matchGlobalChat = function(s,profile)
	local channel, msg
	channel, msg = match2arg(s,'send','"([^"]*)"','(.*)')
	if (channel and msg) { return {type="Chat Command (Global)",usemsg=true,channel=channel,msg=msg} }
	--channel, msg = match2arg(s,'beginchat /send','"([^"]*)"','(.*) ')
	--if (channel and msg) { return {type="Chat Command (Global)",channel=channel,msg=msg} }
	local s2
	if (string.sub(s,1,11):lower() == "beginchat /") {
		s2 = string.sub(s,12,-1)
	else
		return nil
	}
	channel, msg = match2arg(s2,'send','"([^"]*)"','(.*)')
	if (channel and msg) { return {type="Chat Command (Global)",channel=channel,msg=msg} }
}

addCmd("Chat Command (Global)",newGlobalChat,formGlobalChat,makeGlobalChat,matchGlobalChat)

local windowlist = {"powers","manage","chat","tray","target","nav","map","menu","pets"}
local revwindowlist = {}
for i,v in ipairs(windowlist) do revwindowlist[v] = i }

local formWindowToggle = function(t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Window",windowlist,table.getn(windowlist),t.window,
		function(_,s,i,v)
			if (v == 1) { t.window = s }
			profile.modified = true
			if (refreshcb) { refreshcb() }
		},196,nil,100,nil,true))
	}
	return t
}

local newWindowToggle = function()
	-- return a table containing the needed items for controlling this power.
	local t = {}
	t.type = "Window Toggle"
	t.window = "powers"
	return t
}

local makeWindowToggle = function(t)
	return t.window
}

local matchWindowToggle = function(s,profile)
	if (revwindowlist[s:lower()]) { return {type="Window Toggle",window=s:lower()} }
}

addCmd("Window Toggle",newWindowToggle,formWindowToggle,makeWindowToggle,matchWindowToggle)

local formTeamPetSelect = function(t,profile,refreshcb)
	t.settings = iup.frame{iup.vbox{(cbListBox("Team or Pet Select",{"Teammate","Henchman"},2,t.teamsel,
			function(_,s,i,v)
				if (v == 1) { t.teamsel = i }
				profile.modified = true
				if (refreshcb) { refreshcb() }
			},196,nil,100,nil)),
		(cbListBox("Team/Pet Number",{"1","2","3","4","5","6","7","8","9","10","11"},11,t.number,
			function(_,s,i,v)
				if (v == 1) { t.number = i }
				profile.modified = true
				if (refreshcb) { refreshcb() }
			},196,nil,100,nil))
	}}
	return t
}

local newTeamPetSelect = function()
	-- return a table containing the needed items for controlling this power.
	local t = {}
	t.type = "Team/Pet Select"
	t.teamsel = 1
	t.number = 1
	return t
}

local makeTeamPetSelect = function(t)
	if (t.teamsel == 1) {
		return "teamselect "..t.number
	else
		return "petselect "..(t.number-1)
	}
}

local matchTeamPetSelect = function(s,profile)
	local number = match1arg(s,"teamselect","(%d*)")
	if (number) { return {type="Team/Pet Select",teamsel=1,number=tonumber(number)} }
	number = match1arg(s,"petselect","(%d*)")
	if (number) { return {type="Team/Pet Select",teamsel=2,number=tonumber(number)+1} }
}

addCmd("Team/Pet Select",newTeamPetSelect,formTeamPetSelect,makeTeamPetSelect,matchTeamPetSelect)

chatnogloballimit = {cmdlist={"Emote","Custom Bind","Costume Change","Chat Command"}}

1;
