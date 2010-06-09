-- CityBinder - Bind File Generator for City of Heroes and City of Villains
-- Copyright (C) 2005-2006  Jeff Sheets

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


local module = {}

local function addSBind(sbinds,n,profile) -- this returns an IUP vbox/hbox to be inserted into the SBind Dialog box
	local sbind = sbinds[n]
	local sbtitle = cbTextBox("Bind Name",sbind.title,cbTextBoxCB(profile,sbind,"title"),200,nil,100)
	cbToolTip("Choose the Key Combo for this bind")
	--local bindkey = cbBindBox("Bind Key",sbind,"Key",function() return "SB: "..sbind.Command end,profile,200)
	local bindkey = cbBindBox("Bind Key",sbind,"Key",cbMakeDescLink("Simple Bind ",sbind,"title"),profile,200)
	cbToolTip("Enter the Commands to be run when the Key Combo is pressed")
	--local bindcmd = cbTextBox("Bind Command",sbind.Command,cbTextBoxCB(profile,sbind,"Command"),200,nil,100)
	local bindcmd = cbPowerBindBtn("Bind Command",sbind,"Command",nil,300,nil,profile)
	cbToolTip("Click this to Delete this Bind, it will ask for confirmation before deleting")
	local delbtn = cbButton("Delete this Bind",function()
		if iup.Alarm("Confirm Deletion","Are you sure you want to delete this bind?","Yes","No") == 1 then
			table.remove(sbinds,n)
			sbinds.curbind = sbinds.curbind - 1
			if sbinds.curbind == 0 then sbinds.curbind = 1 end
			sbinds.dlg:hide()
			--sbinds.dlg:destroy()
			sbinds.dlg = nil
			module.createDialog(sbinds,profile)
			cbShowDialog(sbinds.dlg,218,10,profile,sbinds.dlg_close_cb)
			profile.modified = true 
		end end,150)
	local exportbtn = cbButton("Export...",function() cbExportModuleSettings(profile,n,sbinds,"SimpleBind",true) end,150)
	return iup.frame{iup.vbox{sbtitle,bindkey,bindcmd,iup.hbox{delbtn,exportbtn}},cx = 0, cy = 65 * (n-1)}
end

local function newSBind() -- this returns the default empty Simple Bind table to be inserted into SBinds
	local t = {}
	t.Key = "UNBOUND"
	--t.Command = newPowerBind()
	--t.Command = ""
	return t
end

function module.createDialog(sbinds,profile)
	local box = {}
	for i = 1,table.getn(sbinds) do
		table.insert(box,addSBind(sbinds,i,profile))
	end
	sbinds.curbind = sbinds.curbind or 1
	cbToolTip("Click this to add a new bind")
	local newbindbtn = cbButton("New Simple Bind",
		function()
			table.insert(sbinds,newSBind())
			sbinds.curbind = table.getn(sbinds)
			sbinds.dlg:hide()
			--sbinds.dlg:destroy()
			sbinds.dlg = nil
			module.createDialog(sbinds,profile)
			cbShowDialog(sbinds.dlg,218,10,profile,sbinds.dlg_close_cb)
			profile.modified = true 
		end,100)
	local importbtn = cbButton("Import Simple Bind",function()
		-- get the simple binds contained in a selected Module.
		local importtable = cbImportModuleSettings(profile,nil,nil,"SimpleBind",true)
		if not importtable then return end
		for i,v in ipairs(importtable) do
			table.insert(sbinds,v)
		end
		--local newsbind_n = table.getn(sbinds)
		sbinds.curbind = table.getn(sbinds)
		sbinds.dlg:hide()
		sbinds.dlg = nil
		-- Resolve Key COnflicts.
		cbResolveKeyConflicts(profile,true)
		module.createDialog(sbinds,profile)
		cbShowDialog(sbinds.dlg,218,10,profile,sbinds.dlg_close_cb)
		profile.modified = true
	end,100)
	local sbEnablePrev = "NO"
	local sbEnableNext = "NO"
	if sbinds.curbind > 1 then sbEnablePrev = "YES" end
	cbToolTip("Click this to go to the previous bind")
	sbinds.prevbind = cbButton("<<",function(self)
			sbinds.curbind = sbinds.curbind - 1
			if sbinds.curbind < 1 then sbinds.curbind = 1 end
			sbinds.zbox.value = box[sbinds.curbind]
			sbinds.poslabel.title = sbinds.curbind.."/"..table.getn(sbinds)
			local sbEnablePrev = "NO"
			if sbinds.curbind > 1 then sbEnablePrev = "YES" end
			sbinds.prevbind.active=sbEnablePrev
			local sbEnableNext = "NO"
			if sbinds.curbind < table.getn(sbinds) then sbEnableNext = "YES" end
			sbinds.nextbind.active=sbEnableNext
		end,25,nil,{active=sbEnablePrev})
	if sbinds.curbind < table.getn(sbinds) then sbEnableNext = "YES" end
	cbToolTip("Click this to go to the previous bind")
	sbinds.nextbind = cbButton(">>",function(self)
			sbinds.curbind = sbinds.curbind + 1
			if sbinds.curbind > table.getn(sbinds) then sbinds.curbind = table.getn(sbinds) end
			sbinds.zbox.value = box[sbinds.curbind]
			sbinds.poslabel.title = sbinds.curbind.."/"..table.getn(sbinds)
			local sbEnablePrev = "NO"
			if sbinds.curbind > 1 then sbEnablePrev = "YES" end
			sbinds.prevbind.active=sbEnablePrev
			local sbEnableNext = "NO"
			if sbinds.curbind < table.getn(sbinds) then sbEnableNext = "YES" end
			sbinds.nextbind.active=sbEnableNext
		end,25,nil,{active=sbEnableNext})
	sbinds.poslabel = iup.label{title = sbinds.curbind.."/"..table.getn(sbinds);rastersize="50x";alignment="ACENTER"}
	box.value = box[sbinds.curbind]
	sbinds.zbox = iup.zbox(box)
	sbinds.dlg = iup.dialog{iup.vbox{sbinds.zbox,iup.hbox{sbinds.prevbind;newbindbtn;importbtn;sbinds.poslabel;sbinds.nextbind;alignment="ACENTER"};alignment="ACENTER"};title = "General : Simple Binds",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
	sbinds.dlg_close_cb = function(self) sbinds.dlg = nil end
end

function module.bindsettings(profile)
	local sbinds = profile.sbinds
	if sbinds == nil then
		sbinds = {}
		profile.sbinds = sbinds
	end
	if sbinds.dlg then
		sbinds.dlg:show()
	else
		module.createDialog(sbinds,profile)
		cbShowDialog(sbinds.dlg,218,10,profile,sbinds.dlg_close_cb)
	end
end

function module.makebind(profile)
	local resetfile = profile.resetfile
	local sbinds = profile.sbinds
	for i = 1,table.getn(sbinds) do
		cbWriteBind(resetfile,sbinds[i].Key,cbPBindToString(sbinds[i].Command))
	end
end

function module.findconflicts(profile)
	local sbinds = profile.sbinds
	for i = 1,table.getn(sbinds) do
		cbCheckConflict(sbinds[i],"Key","Simple Bind "..(sbinds[i].title or "Unknown"))
	end
end

function module.bindisused(profile)
	if profile.sbinds == nil then return nil end
	return table.getn(profile.sbinds) > 0
end

cbAddModule(module,"Simple Binds","General")
