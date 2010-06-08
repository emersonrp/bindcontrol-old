package Utility;

use strict;


my ($resetfile1, $resetfile2, $resetkey, $numbinds);

sub WriteBind {
	my ($file,$key,$bindtext) = @_;

	if (not $file) { die("Invalid file argument to cbWriteBind."); }
	if (not $key)  { die("invalid key: $key"); }

	my $prefix;
	# writes out a bind to the given file in the format [key] "[bindtext]"\n
	# This makes writing new binds a bit easier.
	# get rid of prefix and suffix whitespace in bindtext.
	if ($bindtext =~ /^-? \$\$/) { $prefix = '- $$'; }
	$bindtext =~ s/^ +//;
	$bindtext =~ s/ +$//;

	# $bindtext =~ prefix..string.gsub(bindtext,"^%$%$","")
	# $bindtext =~ string.gsub(bindtext,"%$%$%$%$","$$")
	my $s = qq|$key "$bindtext"\n|;
	if (length $s > 255) {
		# TODO TODO TODO
		# iup.Message("Warning!","A bindfile line for the "..key.." key ("..cbGetDesc(activeprofile,key)..") in file "..file.filename.." is longer than 255 characters, you may experience problems ingame!")
	}
	if ($file eq $resetfile1 and $key eq $resetkey) {
		# TODO TODO TODO
		# table.insert(resetfile2.binds,{key=key,s=s})
	}
	# TODO TODO TODO
	# table.insert(file.binds,{key=key,s=s})
	$numbinds++;
}

1;
__DATA__

local cats = {}
local mods = {}
local profile = {}
profile.__index = profile
dialogs = {}
dlgs_mt = {__mode="k"}
setmetatable(dialogs,dlgs_mt)
local filelist = {}

local fmt = {__index={close=function() end}}

local function basicSer(o)
	if type(o) == "number" then
		return tostring(o)
	elseif type(o) == "boolean" then
		return "true"
	elseif type(o) == "string" then
		return string.format("%q",o)
	else
		return "nil"
	end
end

local function validKey(o)
	if type(o) == "number" then
		return true
	elseif type(o) == "boolean" then
		return true
	elseif type(o) == "string" then
		return true
	elseif type(o) == "table" then
		return true
	else
		return nil
	end
end

function dumptable(file,n,o,nList)
	nList = nList or {}
	file:write(n.." = ")
	if type(o) == "number" or type(o) == "string" or type(o) == "boolean" then
		file:write(basicSer(o).."\n")
	elseif type(o) == "table" then
		if nList[o] then
			file:write(nList[o].."\n")
		else
			nList[o] = n
			file:write("{}\n")
			local o2 = {}
			for k,v in pairs(o) do
				if validKey(k) and v then
					table.insert(o2,{k=k,v=v})
				end
			end
			table.sort(o2,function(a,b)
				if (type(a.k) == type(b.k)) and (type(a.k) ~= "table") then
					return a.k < b.k
				end
				return type(a.k) < type(b.k)
			end)
			for i,t in ipairs(o2) do
				if type(t.k) == "table" then
					if nList[t.k] then
						dumptable(file,string.format("%s[%s]",n,nList[t.k]),t.v,nList)
					else
						dumptable(file,string.format("%s[false]",n),t.v,nList)
					end
				else
					dumptable(file,string.format("%s[%s]",n,basicSer(t.k)),t.v,nList)
				end
			end
		end
	elseif type(o) == "userdata" then
		file:write("nil\n")
	elseif type(o) == "function" then
		file:write("nil\n")
	else
		error("cannot save a "..type(o))
	end
end

function cbOpen(filename, mode,real)
	if real then return assert(io.open(filename,mode)) else
		local f = {}
		f.filename = filename
		f.mode = mode
		f.binds = {}
		setmetatable(f,fmt)
		filelist[filename] = f
		return f
	end
end

function getMainKey(key)
	local str = key or "UNBOUND"
	str = string.upper(str)
	local mkey
	str = string.gsub(str,"LSHIFT","")
	str = string.gsub(str,"RSHIFT","")
	str = string.gsub(str,"SHIFT","")
	str = string.gsub(str,"LCTRL","")
	str = string.gsub(str,"RCTRL","")
	str = string.gsub(str,"CTRL","")
	str = string.gsub(str,"LALT","")
	str = string.gsub(str,"RALT","")
	str = string.gsub(str,"ALT","")
	mkey = string.gsub(str,"%+","")
	return mkey
end

local progressbar
local progressdialog
local numbinds = 0
local progress = 0
local pbmax = 0
local conflictbinds

function incProgBar(n)
	if progressbar then
		n = n or 1
		progress = (progress or 0) + n
		if progress > pbmax then progress = pbmax end
		progressbar.value = progress
		iup.Flush()
		progressdialog.size = nil
		progressdialog:show()
	end
end

function newProgBar(title,barmax,text)
	pbmax = barmax
	progressbar = iup.gauge{min=0,max=barmax,value=0,text=text or " "}
	progressdialog = iup.dialog{progressbar,title=title,maxbox="NO",resize="NO"}
	progressdialog:show()
	progress = 0
end

function setProgBarText(text)
	progressbar.text = text
end

function resetProgBar(barmax,text)
	pbmax = barmax
	progressbar.value = 0
	progress = 0
	progressbar.text=text or " "
	progressbar.max=barmax
	iup.Flush()
end

function delProgBar()
	progressdialog:hide()
	progressdialog = nil
	progressbar = nil
	cbdlg.bringfront = "YES"
end

function cbWriteFile(f)
	local file = assert(io.open(f.filename,f.mode))
	--add in bind sorter here
	table.sort(f.binds,function(a,b)
		return getMainKey(a.key) < getMainKey(b.key)
	end)
	local i = 0
	for _,v in ipairs(f.binds) do
		incProgBar()
		file:write(v.s)
		i = i + 1
	end
	file:close()
	return i
end

function cbCheckConflict(t,k,Purpose)
	if not t[k] then return end
	if string.upper(t[k]) == "UNBOUND" then return end
	if not conflictbinds.binds[t[k]] then
		-- no conflict, add this to the list of binds.
		conflictbinds.binds[t[k]] = {keybase = getMainKey(t[k]) or "UNBOUND",t=t,k=k,purpose=Purpose}
	else
		-- conflict...
		local c
		if not conflictbinds.conflicts[t[k]] then
			-- first conflict for this key.
			c = {}
			table.insert(c,conflictbinds.binds[t[k]])
			conflictbinds.conflicts[t[k]] = c
		else
			c = conflictbinds.conflicts[t[k]]
		end
		table.insert(c,{keybase = getMainKey(t[k]) or "UNBOUND",t=t,k=k,purpose=Purpose})
	end
end

function cbResolveConflict(conflict,key,profile)
	local clist = {}
	local conflictdlg
	table.insert(clist,iup.label{title = "\n  Please Resolve these Keybind Conflicts and close this window when you are done.\n\n"})
	for i,v in ipairs(conflict) do
		table.insert(clist,(cbBindBox(v.purpose,v.t,v.k,nil,profile,nil,nil,300,nil,function() conflictdlg.bringfront="YES" end)))
	end
	conflictdlg = iup.dialog{iup.vbox(clist),maxbox="NO",resize="NO",title="Conflict Resolution"}
	iup.Popup(conflictdlg,iup.CENTER,iup.CENTER)
end

local resetstring

function cbGetBaseReset(profile)
	--return ""
	return "$$bind_load_file "..profile.base.."\\subreset.txt"
end

function cbAddReset(s)
	resetstring = resetstring.."$$"..s
end

function cbResolveKeyConflicts(self,initprogbar)
	if initprogbar then
		local modcount = 0
		for _,module in pairs(mods) do
			if module.bindisused(self) then
				modcount = modcount+1
			end
		end
		newProgBar("Generating Bindfiles",modcount)
	end
	conflictbinds = {}
	conflictbinds.binds = {}
	conflictbinds.conflicts = {}
	setProgBarText("Finding Conflicts")
	for _,module in pairs(mods) do
		if module.bindisused(self) then
			incProgBar()
			module.findconflicts(self)
		end
	end
	cbCheckConflict(self,"ResetKey","Binds Reset Key")
	local conflicts = {}
	for k,v in pairs(conflictbinds.conflicts) do table.insert(conflicts,{v=v,k=k}) table.sort(conflicts,function(a,b) return a.v[1].keybase < b.v[1].keybase end) end
	resetProgBar(table.getn(conflicts),"Resolving Conflicts")
	for i,v in ipairs(conflicts) do
		incProgBar()
		cbResolveConflict(v.v,v.k,self)
	end
	conflictbinds = nil
	if initprogbar then
		delProgBar()
	end
end

local resetfile1
local resetfile2
local resetkey

local activeprofile

function profile:write()
	-- adding a check here to indicate that spaces in profile paths are not likely to be usable.
	activeprofile = self
	if (string.find(self.base," ",1,true)) then
		iup.Message("WARNING!","Using a Bind Directory with spaces will NOT work when you try to /bindloadfile, remove the spaces!")
		return
	end
	local ret,err = cbMakeDirectory(self.base)
	if not cbFileExists(self.base) then iup.Message("",self.base.." "..err) end
	self.resetfile = cbOpen(self.base .. "\\reset.txt","w")
	resetfile1 = self.resetfile
	resetkey = self.ResetKey
	resetfile2 = cbOpen(self.base .. "\\subreset.txt","w")
	resetstring = "bind_load_file "..self.base.."\\reset.txt"
	if self.resetnotice then
		resetstring = resetstring.."$$tell $name, Keybinds reloaded."
	end
	if self.resetfile == nil then iup.Message("Error", "Resetfile not created!") end
	local modcount = 0
	for _,module in pairs(mods) do
		if module.bindisused(self) then
			modcount = modcount+1
		end
	end
	newProgBar("Generating Bindfiles",modcount)
	cbResolveKeyConflicts(self)
	resetProgBar(modcount," ")
	for _,module in pairs(mods) do
		if module.bindisused(self) then
			setProgBarText(module.label)
			incProgBar()
			module.makebind(self)
		end
	end
	cbWriteBind(self.resetfile,self.ResetKey,resetstring)
	self.resetfile:close()
	resetfile2:close()
	resetProgBar(numbinds,"Writing Files")
	local count = 0
	for k,v in pairs(filelist) do
		count = count + cbWriteFile(v)
	end
	delProgBar()
	self.resetfile = nil
	resetfile1 = nil
	resetfile2 = nil
	resetkey = nil
	--iup.Message("Saved "..count.." binds","Done!\n\nNow log on to the character you made this for and type:\n\n/bindloadfile "..self.base.."\\reset.txt\n\nMake sure you use the \\ Backslash key for the file location!")
	local top = iup.vbox{iup.fill{rastersize="10x10"},iup.label{title="Done!\n\nNow log on to the character you made this for and type:\n",expand="YES",alignment="ACENTER"},iup.fill{rastersize="10x10"}}
	local textitem = iup.text{value="/bindloadfile "..self.base.."\\reset.txt",readonly="YES",expand="YES",alignment="ACENTER"}
	local bottom = iup.vbox{iup.fill{rastersize="10x10"},iup.label{title="If you are reloading binds on your character, \nyou may also be able to just hit your Reset Key and reset your binds.",alignment="ACENTER"},iup.fill{rastersize="10x10"}}
	local finished = iup.dialog{iup.hbox{iup.fill{rastersize="10x"},iup.vbox{top,textitem,bottom},iup.fill{rastersize="10x"}},title="Saved "..count.." binds",maxbox="NO",minbox="NO",resize="NO"}
	finished:popup(iup.CENTER,iup.CENTER)
	cbdlg.bringfront="YES"
	activeprofile = nil
end

function cbWriteToggleBind(filedown,fileup,key,binddown,bindup,filedownname,fileupname)
	cbWriteBind(filedown,key,"+ $$"..binddown.."$$bindloadfile "..fileupname)
	cbWriteBind(fileup,key,"- $$"..bindup.."$$bindloadfile "..filedownname)
end

function cbNewBind(str)
	str = str or "UNBOUND"
	str = string.upper(str)
	local mkey,shift,ctrl,alt
	if string.find(str,"LSHIFT") then shift = "LSHIFT" end
	str = string.gsub(str,"LSHIFT","")
	if string.find(str,"RSHIFT") then shift = "RSHIFT" end
	str = string.gsub(str,"RSHIFT","")
	if string.find(str,"SHIFT") then shift = "LSHIFT" end
	str = string.gsub(str,"SHIFT","")
	if string.find(str,"LCTRL") then ctrl = "LCTRL" end
	str = string.gsub(str,"LCTRL","")
	if string.find(str,"RCTRL") then ctrl = "RCTRL" end
	str = string.gsub(str,"RCTRL","")
	if string.find(str,"CTRL") then ctrl = "LCTRL" end
	str = string.gsub(str,"CTRL","")
	if string.find(str,"LALT") then alt = "LALT" end
	str = string.gsub(str,"LALT","")
	if string.find(str,"RALT") then alt = "RALT" end
	str = string.gsub(str,"RALT","")
	if string.find(str,"ALT") then alt = "LCTRL" end
	str = string.gsub(str,"ALT","")
	mkey = string.gsub(str,"%+","")
	local t={}
	t.mainkey = mkey
	t.shift = shift
	t.ctrl = ctrl
	t.alt = alt
	t.bind = t.shift
	if (not t.bind) and t.ctrl then
		t.bind = t.ctrl
	elseif t.bind and t.ctrl then
		t.bind = t.bind.."+"..t.ctrl
	end
	if (not t.bind) and t.alt then
		t.bind = t.alt
	elseif t.bind and t.alt then
		t.bind = t.bind.."+"..t.alt
	end
	if (not t.bind) and t.mainkey then
		t.bind = t.mainkey
	elseif t.bind and not (t.mainkey == "") then
		t.bind = t.bind.."+"..t.mainkey
	end
	if not t.bind then t.bind = "" end
	return t
end

function cbSetBind(bindkey,curbind)
	bindkey = string.upper(bindkey)
	bindkey = string.upper(bindkey)
	if bindkey=="LSHIFT" or bindkey=="RSHIFT" then
		if bindkey==curbind.shift then
			curbind.shift=nil
		else
			curbind.shift = bindkey
		end
	elseif bindkey=="LCTRL" or bindkey=="RCTRL" then
		if bindkey==curbind.ctrl then
			curbind.ctrl=nil
		else
			curbind.ctrl = bindkey
		end
	elseif bindkey=="LALT" or bindkey=="RALT" then
		if bindkey==curbind.alt then
			curbind.alt=nil
		else
			curbind.alt = bindkey
		end
	else
		if curbind.mainkey == bindkey then
			curbind.mainkey = ""
		else
			curbind.mainkey = bindkey
		end
	end
	curbind.bind = curbind.shift
	if (not curbind.bind) and curbind.ctrl then
		curbind.bind = curbind.ctrl
	elseif curbind.bind and curbind.ctrl then
		curbind.bind = curbind.bind.."+"..curbind.ctrl
	end
	if (not curbind.bind) and curbind.alt then
		curbind.bind = curbind.alt
	elseif curbind.bind and curbind.alt then
		curbind.bind = curbind.bind.."+"..curbind.alt
	end
	if (not curbind.bind) and curbind.mainkey then
		curbind.bind = curbind.mainkey
	elseif curbind.bind and curbind.mainkey then
		curbind.bind = curbind.bind.."+"..curbind.mainkey
	end
	if not curbind.bind then curbind.bind = "" end
	curbind.bind = string.gsub(curbind.bind,"%+$","")
	if curbind.bind == "" then curbind.bind = "UNBOUND" end
end

function cbSetDesc(profile,bindkey,desc,label,t,k)
	if not bindkey then return end
	profile.binds = profile.binds or {}
	profile.binds_label = profile.binds_label or {}
	profile.binds_tk = profile.binds_tk or {}
	if type(desc) == "function" then
		profile.binds[bindkey] = desc()
	else
		profile.binds[bindkey] = desc
	end
	profile.binds_label[bindkey] = label
	profile.binds_tk[bindkey] = {t = t; k = k}
end

function cbMakeDescLink(prefix,t,k,suffix)
	local o = {}
	o.prefix = prefix or ""
	o.t = t
	o.k = k
	o.suffix = suffix or ""
	return o
end

function cbGetDesc(profile,bindkey)
	if profile.binds then
		if type(profile.binds[bindkey]) == "table" then
			if not profile.binds[bindkey].t[profile.binds[bindkey].k] then return profile.binds[bindkey].prefix.."Unknown"..profile.binds[bindkey].suffix end
			return profile.binds[bindkey].prefix..profile.binds[bindkey].t[profile.binds[bindkey].k]..profile.binds[bindkey].suffix
		else
			return profile.binds[bindkey] or "Unbound"
		end
	else
		return "Unknown"
	end
end

function cbUnboundOrEqualTo(a,b,profile)
	profile.binds = profile.binds or {}
	if profile.binds[a] then
		if string.upper(a) == "UNBOUND" then return true end
		return a == b
	else
		return true
	end
end

function cbGetBindKey(bkey,desc,profile,label,t,k)
	local curbind = cbNewBind(bkey)
	curbind = cbPopVKeyboard(curbind,profile) -- This shouldn't return until after a bindkey was chosen.
	if curbind then
		-- check to see if the new key is unbound or identical to bkey, if not, ask for confirmation
		if not cbUnboundOrEqualTo(curbind.bind,bkey,profile) then
			-- ask for confirm, if yes then
			if iup.Alarm("Overwrite "..cbGetDesc(profile,curbind.bind).."?","This key combo is used for a different bind.  Overwrite it?","No","Yes") == 2 then
				-- overwrite the original bind to no key, or UNBOUND
				profile.binds_tk[curbind.bind].t[profile.binds_tk[curbind.bind].k] = "UNBOUND"
				if profile.binds_label[curbind.bind] then
					profile.binds_label[curbind.bind].title = "UNBOUND"
				end
				-- if the original key has a visible label indicating it's status, reset it's title.
				cbSetDesc(profile,bkey,nil,nil,nil,nil)
				cbSetDesc(profile,curbind.bind,desc,label,t,k)
				return curbind.bind
			else
				return bkey
			end
		else
			cbSetDesc(profile,bkey,nil,nil,nil,nil)
			cbSetDesc(profile,curbind.bind,desc,label,t,k)
			return curbind.bind
		end
	else
		return bkey
	end
end

--local function dumptable(file,o,depth)
--	depth = depth or 1
--	if type(o) == "number" then
--		file:write(o)
--	elseif type(o) == "string" then
--		file:write(string.format("%q", o))
--	elseif type(o) == "boolean" then
--		if o then file:write("true") else file:write("nil") end
--	elseif type(o) == "table" then
--		file:write("{\n")
--		for k,v in pairs(o) do
--			for i=1,depth do file:write("  ") end
--			file:write("[")
--			dumptable(file,k,0)
--			file:write("] = ")
--			dumptable(file,v,depth+1)
--			file:write(",\n")
--		end
--		for i=2,depth do file:write("  ") end
--		file:write("}")
--	elseif type(o) == "userdata" then
--		file:write("nil") -- because we don't test type til here and we can't serialize userdata.
--	else
--		error("cannot serialize a " .. type(o))
--	end
--end

function profile:saveprofile(saveasnewfile,saveasdefault)
	cbResolveKeyConflicts(self,true)
	if (string.find(self.base," ",1,true)) then
		iup.Message("WARNING!","Using a Bind Directory with spaces will NOT work when you try to /bindloadfile, remove the spaces before you generate your bindfiles!")
	end
	local profilefile
	if saveasnewfile then
		local fileDlg = iup.filedlg{
			dialogtype="SAVE",
			title="Save Profile",
			extfilter="CityBinder Profiles|*.cbp;All Files|*.*",
			directory=cbBaseLocation;file=self.profile
		}
		fileDlg:popup(iup.CURRENT, iup.CURRENT)
		if fileDlg.status == "-1" then cbdlg.bringfront="YES" return end
		self.modified = nil
		if string.lower(string.sub(fileDlg.value,-4)) ~= ".cbp" then
			self.profile = fileDlg.value..".cbp"
		else
			self.profile = fileDlg.value
		end
		cbMakeDirectory(string.sub(self.profile,1,(string.find(self.profile,"\\[^\\]+$"))))
		profilefile = cbOpen(self.profile,"w",true)
	elseif saveasdefault then
		if cbFileExists("default.lua") then
			local res = iup.Alarm("Save over your Default Settings?","Are you sure you want to save over your default settings?","Yes","No")
			if res == 2 then return end
		end
		self.modified = nil
		profilefile = cbOpen("default.lua","w",true)
	else
		profilefile = cbOpen(self.profile, "w", true)
	end
	dumptable(profilefile,"loadup",self)
	profilefile:close()
	cbdlg.bringfront = "YES"
--	if saveasdefault then
--		iup.Message("Profile Saved","Successfully saved default profile")
--	else
--		iup.Message("Profile Saved","Successfully saved profile "..self.profile)
--	end
end

function cbCheckBoxCB(profile,t,val,cb)
	return function(_,v)
		profile.modified = true
		if v == 1 then
			t[val] = true
		else
			t[val] = nil
		end
		if cb then cb() end
	end
end

function cbTextBoxCB(profile,t,val,cb)
	return function(_,c,s)
		profile.modified = true
		t[val] = s
		if cb then cb() end
		return iup.DEFAULT
	end
end

function cbListBoxCB(profile,t,numval,strval,cb)
	return function(_,str,i,v)
		profile.modified = true
		if v == 1 then
			if numval then
				t[numval] = i
			end
			if strval then
				t[strval] = str
			end
		end
		if cb then cb() end
	end
end

local cbTTip = nil
function cbToolTip(tip)
	cbTTip = tip
end

function cbToggleText(label,togval,txtval,togcb,txtcb,w,h,w2,h2)
	w = w or 100
	h = h or 21
	w2 = w2 or 100
	h2 = h2 or 21
	local ttext = iup.text{value = txtval; rastersize = w2.."x"..h2, tip = cbTTip}
	ttext.action = txtcb
	if not togval then ttext.active = "NO" end

	local chkval
	if togval then chkval = "ON" else chkval = "OFF" end

	local ttoggle = iup.toggle{title = label, value = chkval;rastersize = w.."x"..h, tip = cbTTip}
	ttoggle.action = function(_,v) togcb(_,v) if v == 1 then ttext.active ="YES" else ttext.active="NO" end end
	cbTTip = nil
	return iup.hbox{ttoggle,ttext;alignment="ACENTER"}
end

function cbTextBox(label,val,callback,w,h,w2,h2)
	w = w or 100
	h = h or 21
	w2 = w2 or w
	h2 = h2 or h
	local ttext = iup.text{value = val; rastersize = w.."x"..h, tip = cbTTip}
	ttext.action = callback
	cbTTip = nil
	if label then
		return iup.hbox{iup.label{title = label; rastersize = w2.."x"},ttext;alignment="ACENTER"}, ttext
	else
		return ttext
	end
end

function cbBindBox(label,t,k,desc,profile,w,h,w2,h2,postcb)
	local tk = t[k] or "UNBOUND"
	local val = string.upper(tk)
	w = w or 100
	h = h or 21
	w2 = w2 or 100
	h2 = h2 or 21
	desc = desc or label
	local ttext = iup.label{title = val; rastersize = (w-20).."x"}
	--ttext.action = callback
	local tbtn = iup.button{title="..."; rastersize = "20x"..h, tip = cbTTip}
	tbtn.action = function()
		ttext.title = cbGetBindKey(t[k],desc,profile,ttext,t,k)
		if postcb then postcb() end
		profile.modified = true
		t[k] = ttext.title
	end
	cbTTip = nil
	return iup.hbox{iup.label{title = label; rastersize = w2.."x"},ttext,tbtn;alignment="ACENTER"}
end

function cbCheckBind(label,t,k,tgl,desc,profile,w,h,w2,h2,tglcb)
	local tk = t[k] or "UNBOUND"
	local val = string.upper(tk)
	local ttgl = "ON"
	if not t[tgl] then ttgl = "OFF" end
	w = w or 100
	h = h or 21
	w2 = w2 or 100
	h2 = h2 or 21
	desc = desc or label
	local ttext = iup.label{title = val; rastersize = (w-20).."x"}

	local tbtn = iup.button{title="..."; rastersize = "20x"..h, tip = cbTTip}
	tbtn.action = function()
		ttext.title = cbGetBindKey(t[k],desc,profile,ttext,t,k)
		profile.modified = true
		t[k] = ttext.title
	end
	if not t[tgl] then
		tbtn.active = "NO"
		ttext.active = "NO"
	end
	cbTTip = nil
	local lbl = iup.toggle{title = label; value=ttgl; rastersize = w2.."x"}
	lbl.action = function(_,v)
		profile.modified = true
		if v == 1 then
			t[tgl] = true
			tbtn.active = "YES"
			ttext.active = "YES"
		else
			t[tgl] = nil
			tbtn.active = "NO"
			ttext.active = "NO"
		end
		if tglcb then tglcb() end
	end
	return iup.hbox{lbl,ttext,tbtn;alignment="ACENTER"}
end

function cbListBox(label,list,numitems,val,callback,w,h,w2,h2,editable)
	w = w or 100
	h = h or 21
	w2 = w2 or 100
	h2 = h2 or 21
	local ttable = {}
	for i = 1,table.getn(list) do ttable[i] = list[i] end
	ttable.dropdown = "YES"
	ttable.visible_items = numitems
	ttable.value = val
	ttable.rastersize = w.."x"..h
	ttable.tip = cbTTip
	if editable then
		ttable.editbox = "YES"
	end
	if numitems > 20 then
		ttable.visible_items = 20
	end
	local tlist = iup.list(ttable)
	tlist.action = callback
	if editable then
		tlist.edit_cb = function(_,c,s) callback(_,s,nil,1) return iup.DEFAULT end
	end
	cbTTip = nil
	return iup.hbox{iup.label{title = label; rastersize = w2.."x"},tlist;alignment="ACENTER"},tlist
end

function cbUpdateListBox(listbox,newtable)
	local k = 1
	for j,v in ipairs(newtable) do
		listbox[j] = v
		k = j + 1
	end
	listbox[k] = nil
	k = k - 1
	if k > 20 then k = 20 end
	listbox.visible_items = k
end

function cbListText(label,list,methodval,txtval,methcb,txtcb,w,h,w2,h2,w3,h3)
	w = w or 150
	h = h or 21
	w2 = w2 or 375
	h2 = h2 or 21
	w3 = w3 or 75
	h3 = h3 or 21
	local ttext = iup.text{value = txtval; rastersize = w2 .. "x"..h2, tip = cbTTip}
	ttext.action = txtcb

	local ttable = {}
	for i = 1,table.getn(list) do ttable[i] = list[i] end
	ttable.dropdown = "YES"
	ttable.visible_items = table.getn(list)
	ttable.value = methodval
	ttable.rastersize = w3.."x"..h3
	ttable.tip = "Choose the method used for Chatty feedback for this command."
	local tmethod = iup.list(ttable)
	tmethod.action = methcb
	cbTTip = nil
	return iup.hbox{iup.label{title=label; rastersize = w.."x"};tmethod;ttext;alignment="ACENTER"}
end

function cbButton(label,callback,w,h,add)
	w = w or 200
	h = h or 21
	local t = {title = label; rastersize = w.."x"..h, tip = cbTTip}
	if add then
		for k,v in pairs(add) do t[k] = v end
	end
	local tbtn = iup.button(t)
	tbtn.action = callback
	cbTTip = nil
	return tbtn
end

function cbCheckBox(label,val,callback,w,h)
	w = w or 200
	h = h or 21
	local chkval
	if val then chkval = "ON" else chkval = "OFF" end
	
	local tchkbox = iup.toggle{title = label, value = chkval;rastersize = w.."x"..h, tip = cbTTip}
	tchkbox.action = callback
	cbTTip = nil
	return tchkbox
end

function cbDirDlg(profile,label,t,v,title)
	local w = 100-21
	local h = 21
	local val = t[v] or ""
	local tfilelabel = iup.label{title=val;rastersize=w.."x"}
	local tdlgbtn = iup.button{title="...";rastersize="21x21";tip=cbTTip}
	title = title or label
	tdlgbtn.action = function()
		local fileDlg = iup.filedlg{dialogtype="DIR",title=title,directory=t[v],allownew="NO"}
		fileDlg:popup(iup.CURRENT, iup.CURRENT)
		if fileDlg.status == "0" then
			t[v] = fileDlg.value
			tfilelabel.title = fileDlg.value
		end
	end
	cbTTip = nil
	return iup.hbox{iup.label{title=label; rastersize=(w+21).."x"};tfilelabel;tdlgbtn;alignment="ACENTER"}
end

function cbPowerList(label,powerlist,t,v,profile,w,h,w2,h2)
	return cbListBox(label,powerlist,table.getn(powerlist),t[v],
		function(_,s,i,w)
			if w == 1 then t[v] = s end
			profile.modified = true
		end,
	w,h,w2,h2,true)
end

function cbTogglePower(label,powerlist,togval,t,v,togcb,profile,w,h,w2,h2)
	w = w or 100
	h = h or 21
	w2 = w2 or 100
	h2 = h2 or 21
	local ttable = {}
	for i = 1,table.getn(powerlist) do ttable[i] = powerlist[i] end
	ttable.dropdown = "YES"
	ttable.visible_items = numitems
	ttable.value = t[v]
	ttable.rastersize = w2.."x"..h2
	ttable.tip = cbTTip
	ttable.editbox = "YES"
	if table.getn(powerlist) > 20 then
		ttable.visible_items = 20
	end
	local tlist = iup.list(ttable)
	tlist.action = function(_,s,i,w)
		if w == 1 then t[v] = s end
		profile.modified = true
	end
	tlist.edit_cb = function(_,c,s) tlist.action(_,s,nil,1) end

	if not togval then tlist.active = "NO" end

	local chkval
	if togval then chkval = "ON" else chkval = "OFF" end

	local ttoggle = iup.toggle{title = label, value = chkval;rastersize = w.."x"..h, tip = cbTTip}
	ttoggle.action = function(_,v) togcb(_,v) if v == 1 then tlist.active ="YES" else tlist.active="NO" end end
	cbTTip = nil
	return iup.hbox{ttoggle,tlist;alignment="ACENTER"}
end

function buildColorImage(r,g,b)
	return iup.image{
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		{ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
		colors = { r.." "..g.." "..b }
	}
end

function cbChatColorInit(t)
	if not t then
		t = {}
		t.enable = nil
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
	end
	return t
end

function cbChatColorOutput(t)
	if type(t) ~= "table" then return "" end
	if not t.enable then return "" end
	local border = string.format("<bordercolor #%02x%02x%02x>",t.border.r,t.border.g,t.border.b)
	local color = string.format("<color #%02x%02x%02x>",t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
	local bgcolor = string.format("<bgcolor #%02x%02x%02x>",t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
	return border..color..bgcolor
end

function cbChatColors(profile,t)
	local enable,border,bgcolor,fgcolor = "enable", "border", "bgcolor", "fgcolor"
	local bordercolor = iup.label{title=" ";image = buildColorImage(t[border].r,t[border].g,t[border].b); rastersize="17x17"}
	local borderbtn = iup.button{title="Border";rastersize="40x21"}
	borderbtn.action=function()
		t[border].r,t[border].g,t[border].b = cbGetColor(t[border].r,t[border].g,t[border].b)
		bordercolor.image = buildColorImage(t[border].r,t[border].g,t[border].b)
		if refreshcb then refreshcb() end
		profile.modified = true
	end
	local bgc = iup.label{title=" ";image = buildColorImage(t[bgcolor].r,t[bgcolor].g,t[bgcolor].b); rastersize="17x17"}
	local bgbtn = iup.button{title="BG";rastersize="40x21"}
	bgbtn.action=function()
		t[bgcolor].r,t[bgcolor].g,t[bgcolor].b = cbGetColor(t[bgcolor].r,t[bgcolor].g,t[bgcolor].b)
		bgc.image = buildColorImage(t[bgcolor].r,t[bgcolor].g,t[bgcolor].b)
		if refreshcb then refreshcb() end
		profile.modified = true
	end
	local textcolor = iup.label{title=" ";image = buildColorImage(t[fgcolor].r,t[fgcolor].g,t[fgcolor].b); rastersize="17x17"}
	local textbtn = iup.button{title="Text";rastersize="40x21"}
	textbtn.action=function()
		t[fgcolor].r,t[fgcolor].g,t[fgcolor].b = cbGetColor(t[fgcolor].r,t[fgcolor].g,t[fgcolor].b)
		textcolor.image = buildColorImage(t[fgcolor].r,t[fgcolor].g,t[fgcolor].b)
		if refreshcb then refreshcb() end
		profile.modified = true
	end
	local refreshfunction = function()
		if t[enable] then
			borderbtn.active = "YES"
			bgbtn.active = "YES"
			textbtn.active = "YES"
		else
			borderbtn.active = "NO"
			bgbtn.active = "NO"
			textbtn.active = "NO"
		end
	end
	refreshfunction()
	local chatcolorenable = cbCheckBox("",t[enable],cbCheckBoxCB(profile,t,enable,refreshfunction),21)
	return iup.hbox{chatcolorenable,iup.frame{bordercolor;sunken="YES"; rastersize="21x21";margin="1x1"},borderbtn,
		iup.frame{bgc;sunken="YES"; rastersize="21x21";margin="1x1"},bgbtn,
		iup.frame{textcolor;sunken="YES"; rastersize="21x21";margin="1x1"},textbtn}
end

function cbExportModuleSettings(profile,settings,t,as,multibind,exfile)
	t = t or profile
	as = as or settings
	local fileDlg
	local filename
	if not exfile then
		local over = "NO"
		if multibind then over = "YES" end
		fileDlg = iup.filedlg{dialogtype="SAVE",title="Export Binds",extfilter="CityBinder Modules|*.cbm;All Files|*.*",
			directory=cbBaseLocation,nooverwriteprompt=over}
		fileDlg:popup(iup.CURRENT, iup.CURRENT)
		if fileDlg.status ~= "-1" then
			if string.lower(string.sub(fileDlg.value,-4)) ~= ".cbm" then
				filename = fileDlg.value..".cbm"
			else
				filename = fileDlg.value
			end
		end
	else
		fileDlg = {}
		fileDlg.status = "0"
		filename = exfile
	end
	if fileDlg.status == "0" or fileDlg.status == "1" then
		if multibind then
			-- determine replace, add, cancel.
			_import = {} _import[as]={}
			if (not exfile) and cbFileExists(filename) then
				local ret = iup.Alarm("CBM File Already Exists!",filename.." Already Exists!","Replace","Add","Cancel")
				if ret == 2 then
					dofile(filename)
				elseif ret == 3 then
					return
				end
			elseif exfile then
				dofile(exfile)
			end
			table.insert(_import[as],t[settings])
			local exportfile = cbOpen(filename,"w",true)
			dumptable(exportfile,"_import["..basicSer(as).."]",_import[as])
			exportfile:close()
			return filename
		else
			local exportfile = cbOpen(filename,"w",true)
			dumptable(exportfile,"_import["..basicSer(as).."]",t[settings])
			exportfile:close()
		end
	end
end

function cbImportModuleSettings(profile,settings,t,as,multibind)
	t = t or profile
	as = as or settings
	local fileDlg = iup.filedlg{dialogtype="OPEN",title="Import Binds",extfilter="CityBinder Modules|*.cbm;All Files|*.*",
		directory=cbBaseLocation,allownew="NO"}
	fileDlg:popup(iup.CURRENT, iup.CURRENT)
	local filename = fileDlg.value
	if fileDlg.status == "0" or fileDlg.status == "1" then
		_import = {}
		dofile(filename)
		local t2 = _import[as]
		if t2 then
			profile.modified = true
			if multibind then
				return t2
			else
				t[settings] = t2
			end
			return true
		end
	end
	return nil
end

function cbImportExportButtons(profile,settings,reloadCB,w,h,w2,h2)
	-- create two buttons.
	local exportbtn = cbButton("Export...",function() cbExportModuleSettings(profile,settings) end,w,h)
	local importbtn = cbButton("Import...",function()
		local dialog = profile[settings].dialog
		if cbImportModuleSettings(profile,settings) then
			-- Resolve Key COnflicts.
			cbResolveKeyConflicts(profile,true)
			-- unload and reload profile[settings].dialog
			dialog:hide()
			--sbinds.dlg:destroy()
			reloadCB(profile)
			--cbShowDialog(profile[settings].dialog,218,10,profile,function(self) profile[settings].dialog = nil end)
		end
	end,w2,h2)
	return iup.hbox{exportbtn,importbtn}
end

function cbCleanDlgs(base,dlg)
	if dlg then
		if base then
			base.dialogs[dlg] = nil
		else
			dialogs[dlg] = nil
		end
	end
end

function cbShowDialog(dlg,x,y,base,cb)
	if not base then
		if x then
			dlg:showxy(x + mdiClient.x, y + mdiClient.y)
		else
			dlg:show()
		end
		if cb then
			dlg.close_cb = function() dialogs[dlg] = nil return cb() end
		else
			dlg.close_cb = function() dialogs[dlg] = nil end
		end
		dialogs[dlg] = true
	else
		if x then
			dlg:showxy(x + mdiClient.x, y + mdiClient.y)
		else
			dlg:show()
		end
		if cb then
			dlg.close_cb = function() base.dialogs[dlg] = nil return cb() end
		else
			dlg.close_cb = function() base.dialogs[dlg] = nil end
		end
		base.dialogs[dlg] = true
	end
end

ATPrimaries = {
	{"Archery","Assault Rifle","Electrical Blast","Energy Blast","Fire Blast","Ice Blast","Sonic Attack","Psychic Blast"},
	{"Dark Melee","Electric Melee","Energy Melee","Fiery Melee","Stone Melee","Super Strength","War Mace","Battle Axe","Dual Blades"},
	{"Earth Control","Fire Control","Gravity Control","Ice Control","Illusion Control","Mind Control","Plant Control"},
	{"Assault Rifle","Dark Blast","Energy Blast","Fire Blast","Ice Blast","Radiation Blast","Sonic Attack","Electrical Blast"},
	{"Dark Miasma","Empathy","Force Field","Kinetics","Radiation Emission","Sonic Resonance","Storm Summoning","Trick Arrow","Cold Domination"},
	{"Fire Control","Gravity Control","Ice Control","Mind Control","Plant Control","Earth Control"},
	{"Mercenaries","Necromancy","Ninjas","Robotics","Thugs"},
	{"Luminous Blast"},
	{"Broad Sword","Claws","Dark Melee","Katana","Martial Arts","Spines","Dual Blades","Fiery Melee"},
	{"Claws","Dark Melee","Energy Melee","Martial Arts","Ninja Blade","Spines","Dual Blades","Electical Melee"},
	{"Fiery Aura","Ice Armor","Invulnerability","Stone Armor","Willpower","Dark Armor"},
	{"Umbral Blast"}
}

ATSecondaries = {
	{"Devices","Electricity Manipulation","Energy Manipulation","Fire Manipulation","Ice Manipulation","Mental Manipulation"},
	{"Dark Armor","Electric Armor","Energy Aura","Fiery Aura","Invulnerability","Stone Armor","Super Reflexes","Willpower"},
	{"Empathy","Force Field","Kinetics","Radiation Emission","Sonic Resonance","Storm Summoning","Trick Arrow","Pain Domination","Thermal Radiation"},
	{"Cold Domination","Dark Miasma","Kinetics","Radiation Emission","Sonic Resonance","Thermal Radiation","Traps"},
	{"Archery","Dark Blast","Electrical Blast","Energy Blast","Psychic Blast","Radiation Blast","Sonic Attack","Ice Blast"},
	{"Energy Assault","Fiery Assault","Icy Assault","Psionic Assault","Thorny Assault","Electricity Assault"},
	{"Dark Miasma","Force Field","Poison","Traps","Trick Arrow","Pain Domination","Storm Summoning"},
	{"Luminous Aura"},
	{"Dark Armor","Invulnerability","Regeneration","Super Reflexes","Willpower","Fiery Aura"},
	{"Dark Armor","Energy Aura","Ninjitsu","Regeneration","Super Reflexes","Willpower","Electric Armor"},
	{"Battle Axe","Energy Melee","Fiery Melee","Ice Melee","Stone Melee","Super Strength","War Mace","Dark Melee","Dual Blades"},
	{"Umbral Aura"}
}

ATEpics = {
	{"Cold Mastery","Electric Mastery","Flame Mastery","Force Mastery","Munitions Mastery"},
	{"Mace Mastery","Leviathan Mastery","Soul Mastery","Mu Mastery"},
	{"Fire Mastery","Ice Mastery","Primal Forces","Psionic Mastery","Stone Mastery"},
	{"Mace Mastery","Leviathan Mastery","Soul Mastery","Mu Mastery"},
	{"Dark Mastery","Electricity Mastery","Power Mastery","Psychic Mastery"},
	{"Mace Mastery","Leviathan Mastery","Soul Mastery","Mu Mastery"},
	{"Mace Mastery","Leviathan Mastery","Soul Mastery","Mu Mastery"},
	{"Peacebringer Inherents"},
	{"Body Mastery","Darkness Mastery","Weapon Mastery"},
	{"Mace Mastery","Leviathan Mastery","Soul Mastery","Mu Mastery"},
	{"Arctic Mastery","Earth Mastery","Energy Mastery","Pyre Mastery"},
	{"Warshade Inherents"}
}

ATGeneral = {
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Leadership","Leaping","Medicine","Presence","Speed"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Flight","Leadership","Leaping","Medicine","Presence","Speed","Teleportation"},
	{"None","Concealment","Fighting","Fitness","Leadership","Leaping","Medicine","Presence","Speed"},
}

function cbReloadPowers(t)
	-- this function loads all the available click powers based on the powerset choices from the profile dialog.
	-- first start with the basic inherents that everyone can possibly have access to..
	local powerset = {"Sprint","Brawl","Rest","Prestige Power Slide","Prestige Power Rush","Prestige Power Dash","Prestige Power Surge ","Prestige Power Quick"}
	-- Next add click powers from the at primary
 	for i,v in ipairs(powersets[t.archetype]["Primary"][ATPrimaries[t.atnumber][t.primaryset]]) do
 		table.insert(powerset,v)
 	end
	for i,v in ipairs(powersets[t.archetype]["Secondary"][ATSecondaries[t.atnumber][t.secondaryset]]) do
		table.insert(powerset,v)
	end
	if t.atnumber ~= 8 and t.atnumber ~= 12 then
		for i,v in ipairs(powersets[t.archetype]["Epic Pool"][ATEpics[t.atnumber][t.epicset]]) do
			table.insert(powerset,v)
		end
	else
		-- Handle the special case of Kheldians without Epics, but with Additional Inherent powers.
		for i,v in ipairs(powersets[t.archetype]["Inherent"]["Inherent"]) do
			table.insert(powerset,v)
		end
		for k,j in pairs(powersets[t.archetype]["Dependent"]) do
			for i,v in ipairs(j) do
				table.insert(powerset,v)
			end
		end
	end
	if t.ppset1 > 1 and t.ppset1 ~= 4 then
		for i,v in ipairs(powersets["General"]["Pool"][ATGeneral[t.atnumber][t.ppset1]]) do
			table.insert(powerset,v)
		end
	end
	if t.ppset2 > 1 and t.ppset2 ~= 4 then
		for i,v in ipairs(powersets["General"]["Pool"][ATGeneral[t.atnumber][t.ppset2]]) do
			table.insert(powerset,v)
		end
	end
	if t.ppset3 > 1 and t.ppset3 ~= 4 then
		for i,v in ipairs(powersets["General"]["Pool"][ATGeneral[t.atnumber][t.ppset3]]) do
			table.insert(powerset,v)
		end
	end
	if t.ppset4 > 1 and t.ppset4 ~= 4 then
		for i,v in ipairs(powersets["General"]["Pool"][ATGeneral[t.atnumber][t.ppset4]]) do
			table.insert(powerset,v)
		end
	end
	table.insert(powerset,"Eye of the Magus")
	table.insert(powerset,"Crey CBX-9 Pistol")
	table.insert(powerset,"Gaes of the Kind Ones")
	table.insert(powerset,"Vanguard Medal")
	t.powerset = powerset
end

function cbNewProfile(name,filename)
	local t
	if name == nil then
		dofile(filename)
		t = loadup
		if not t then iup.Message("Error","It appears that the file you chose is either not a CityBinder Profile, or is corrupted or damaged.") return end
	else
		if not cbFileExists("default.lua") then
			cbCopyFile("stddefault.lua","default.lua")
		end
		dofile("default.lua")
		t = loadup
		t.profile = nil -- make sure we don't have a default filename from earlier versions.
	end
	t.primaryset = t.primaryset or 1
	t.secondaryset = t.secondaryset or 1
	t.ppset1 = t.ppset1 or 1
	t.ppset2 = t.ppset2 or 1
	t.ppset3 = t.ppset3 or 1
	t.ppset4 = t.ppset4 or 1
	t.epicset = t.epicset or 1

	setmetatable(t,profile)
	t.dialogs = {}
	setmetatable(t.dialogs,dlgs_mt)
	local dlg = {}
	
	cbToolTip("Name your Profile!  This has no effect ingame or out")
	local tnamehbox = cbTextBox("Profile Name",t.name,function(_,c,v) t.name = v return iup.DEFAULT end)
	table.insert(dlg,tnamehbox)
	
	cbToolTip("This is where your bindfiles will be stored on your computer")
	--local tbasehbox = cbTextBox("Bind Directory",t.base,function(_,c,v) t.base = v return iup.DEFAULT end)
	local tbasehbox = cbDirDlg(t,"Bind Directory",t,"base","Bind Directory")
	table.insert(dlg,tbasehbox)
	
	cbToolTip("Select your Character's Primary Powerset")
	local tprimary,tprimlistbox = cbListBox("Primary",ATPrimaries[t.atnumber],table.getn(ATPrimaries[t.atnumber]),t.primaryset,
		function(_,str,i,v) t.modified = true if v == 1 then t.primaryset = i cbReloadPowers(t) end end)

	cbToolTip("Select your Character's Secondary Powerset")
	local tsecondary,tseclistbox = cbListBox("Secondary",ATSecondaries[t.atnumber],table.getn(ATSecondaries[t.atnumber]),t.secondaryset,
		function(_,str,i,v) t.modified = true if v == 1 then t.secondaryset = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's First Power Pool")
	local tpp1,tpp1listbox = cbListBox("Power Pool 1",ATGeneral[t.atnumber],table.getn(ATGeneral[t.atnumber]),t.ppset1,
		function(_,str,i,v) t.modified = true if v == 1 then t.ppset1 = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's Second Power Pool")
	local tpp2,tpp2listbox = cbListBox("Power Pool 2",ATGeneral[t.atnumber],table.getn(ATGeneral[t.atnumber]),t.ppset2,
		function(_,str,i,v) t.modified = true if v == 1 then t.ppset2 = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's Third Power Pool")
	local tpp3,tpp3listbox = cbListBox("Power Pool 3",ATGeneral[t.atnumber],table.getn(ATGeneral[t.atnumber]),t.ppset3,
		function(_,str,i,v) t.modified = true if v == 1 then t.ppset3 = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's Fourth Power Pool")
	local tpp4,tpp4listbox = cbListBox("Power Pool 4",ATGeneral[t.atnumber],table.getn(ATGeneral[t.atnumber]),t.ppset4,
		function(_,str,i,v) t.modified = true if v == 1 then t.ppset4 = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's Epic/Patron Powerset")
	local tepic,tepiclistbox = cbListBox("Epic/Patron",ATEpics[t.atnumber],table.getn(ATEpics[t.atnumber]),t.epicset,
		function(_,str,i,v) t.modified = true if v == 1 then t.epicset = i cbReloadPowers(t) end end)
		
	cbToolTip("Select your Character's Archetype")
	local tathbox = cbListBox("Archetype",{"Blaster","Brute","Controller","Corruptor","Defender","Dominator",
		"Mastermind","Peacebringer","Scrapper","Stalker","Tanker","Warshade"},12,t.atnumber,
		function(_,str,i,v)
			t.modified = true
			if v == 1 then
				local kheldswitch = false
				t.archetype = str
				if (i == 8 or i == 12) and t.atnumber ~= 8 and t.atnumber ~=12 then
					kheldswitch = true
				end
				if (t.atnumber == 8 or t.atnumber == 12) and i ~= 8 and i ~=12 then
					kheldswitch = true
				end
				t.atnumber = i
				cbUpdateListBox(tprimlistbox,ATPrimaries[i])
				--local k = 0
				--for j,v in pairs(ATPrimaries[i]) do
					--tprimlistbox[j] = v
					--k = j + 1
				--end
				--tprimlistbox[k] = nil
				cbUpdateListBox(tseclistbox,ATSecondaries[i])
				--k = 0
				--for j,v in pairs(ATSecondaries[i]) do
					--tseclistbox[j] = v
					--k = j + 1
				--end
				--tseclistbox[k] = nil
				cbUpdateListBox(tepiclistbox,ATEpics[i])
				--k = 0
				--for j,v in pairs(ATEpics[i]) do
					--tepiclistbox[j] = v
					--k = j + 1
				--end
				--tepiclistbox[k] = nil
				cbUpdateListBox(tpp1listbox,ATGeneral[i])
				cbUpdateListBox(tpp2listbox,ATGeneral[i])
				cbUpdateListBox(tpp3listbox,ATGeneral[i])
				cbUpdateListBox(tpp4listbox,ATGeneral[i])
				--k = 0
				--for j,v in pairs(ATGeneral[i]) do
					--tpp1listbox[j] = v
					--tpp2listbox[j] = v
					--tpp3listbox[j] = v
					--tpp4listbox[j] = v
					--k = j + 1
				--end
				--tpp1listbox[k] = nil
				--tpp2listbox[k] = nil
				--tpp3listbox[k] = nil
				--tpp4listbox[k] = nil
				t.primaryset = 1
				tprimlistbox.value = 1
				t.secondaryset = 1
				tseclistbox.value = 1
				t.epicset = 1
				tepiclistbox.value = 1
				if kheldswitch then
					t.ppset1 = 1
					t.ppset2 = 1
					t.ppset3 = 1
					t.ppset4 = 1
					tpp1listbox.value = 1
					tpp2listbox.value = 1
					tpp3listbox.value = 1
					tpp4listbox.value = 1
				end
				cbReloadPowers(t)
			end
		end)
	table.insert(dlg,tathbox)
	table.insert(dlg,tprimary)
	table.insert(dlg,tsecondary)
	table.insert(dlg,tepic)
	table.insert(dlg,tpp1)
	table.insert(dlg,tpp2)
	table.insert(dlg,tpp3)
	table.insert(dlg,tpp4)
	cbReloadPowers(t)
	
	cbToolTip("This key is used by certain modules to reset binds")
	local tresethbox = cbBindBox("Binds Reset Key",t,"ResetKey","Binds Reset Key",t)
	table.insert(dlg,tresethbox)

	cbToolTip("Check this to Enable feedback when you Reset your Binds")
	local tresetnotice = cbCheckBox("Enable Reset Feedback Selftell",t.resetnotice,cbCheckBoxCB(t,t,'resetnotice'))
	table.insert(dlg,tresetnotice)
	
	for cat in pairs(cats) do
	for _,module in pairs(cats[cat]) do
		local modbtnfunc = module.bindsettings
		local modbtn = cbButton(module.btnlabel,function(_) modbtnfunc(t) end)
		table.insert(dlg,modbtn)
	end
	end
	
	cbToolTip("Click this to save your CityBinder profile for later use and modification")
	local savebutton = cbButton("Save Profile",function(_) t:saveprofile(false, false) end)
	table.insert(dlg,savebutton)

	cbToolTip("Click this to save a copy of your CityBinder profile")
	local savebutton = cbButton("Save Copy Of Profile...",function(_) t:saveprofile(true, false) end)
	table.insert(dlg,savebutton)

	cbToolTip("Click this to save this CityBinder profile as the default settings for future new profiles")
	local saveasdefault = cbButton("Save as Default",function(_) t:saveprofile(false,true) end)
	table.insert(dlg,saveasdefault)

	cbToolTip("Click this to generate your profile's bindfiles")
	local writebutton = cbButton("Generate Bindfiles",function(_) t:write() end)
	table.insert(dlg,writebutton)

	profiledlg = iup.dialog{iup.vbox(dlg);title = t.name,maxbox="NO",resize="NO",toolbox="YES",mdichild="YES",mdiclient=mdiClient}
	cbShowDialog(profiledlg,10,10,nil,function()
		if t.modified then
			local i = iup.Alarm("CityBinder","Profile not saved.  Save it now?","Yes","No","Cancel")
			if i == 3 then
				return iup.IGNORE
			elseif i == 1 then
				t:saveprofile(false, false)
			end
		end
		for k,v in pairs(t.dialogs) do if v then k:hide() end end
	end)
	dialogs[t] = t.dialogs
	return t
end

function cbAddModule(module,label,category)
	module.category = category
	module.label = label
	module.btnlabel = category .. " : " .. label
	if cats[category] == nil then
		cats[category] = {}
	end
	cats[category][label] = module
	mods[category .. ":" .. label] = module
end