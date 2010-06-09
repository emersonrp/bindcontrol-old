#!/usr/bin/perl

use strict;

package PowerBindCmds;

sub match1arg {
	my ($s,$arg1,$arg2match) = @_;
	$arg2match ||= "(.*)";
	my ($a,$b) = $s =~ /^([^ ]*) $arg2match/;
	return unless $a;
	if (lc $a eq lc $arg1) { return $b }
}

sub match2arg {
	my ($s,$arg1,$arg2match,$arg3match) = @_;
	$arg2match ||= "(.*)";
	$arg3match ||= "(.*)";
	my ($a,$b,$c) = $s =~ /^([^ ]*) $arg2match $arg3match/;
	return unless $a;
	if (lc $a eq lc $arg1) { return ($b,$c) }
}

################################################################################
sub formUsePowerCmd {
	my ($t,$profile,$refreshcb) = @_;
	my $powerlist = $profile->{'powerset'} || {};
# 	$t->{'settings'} = iup.frame{iup.vbox{
# 		(cbListBox("Method",{"Toggle","On","Off"},3,t.method,
# 			function(_,s,i,v)
# 				if (v == 1) { t.method = i }
# 				profile.modified = true
# 				if (refreshcb) { refreshcb() }
# 			}
# 		)),
# 		(cbListBox("Power",powerlist,table.getn(powerlist),t.power,
# 			function(_,s,i,v)
# 				if (v == 1) { t.power = s }
# 				profile.modified = true
# 				if (refreshcb) { refreshcb() }
# 			},
# 		196,nil,100,nil,true))
# 	}}
	return $t;
}

sub newUsePowerCmd { return { type => "Use Power", method => 1, power => ''}; }

sub makeUsePowerCmd {
	my ($t) = @_;
	if ($t->{'method'} == 1) {
		return "powexecname $t->{'power'}";
	} elsif ($t->{'method'} == 2) {
		return "powexectoggleon $t->{'power'}";
	} else {
		return "powexectoggleoff $t->{'power'}";
	}
}

sub matchUsePowerCmd {
	my ($s,$profile) = @_;
	my $power = match1arg($s,"powexecname");
	if ($power) { return {type => "Use Power", method => 1, power => $power} }
	$power    = match1arg($s,"powexectoggleon");
	if ($power) { return {type => "Use Power", method => 2, power => $power} }
	$power    = match1arg($s,"powexectoggleoff");
	if ($power) { return {type => "Use Power", method => 3, power => $power} }
}

addCmd("Use Power",&newUsePowerCmd,&formUsePowerCmd,&makeUsePowerCmd,&matchUsePowerCmd);
################################################################################
################################################################################
sub formCostumeChange {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{(cbListBox("Costume",{"First","Second","Third","Fourth","Fifth"},5,t.cslot+1,function(_,s,i,v)
#			if (v == 1) { t.cslot = i - 1 }
#			profile.modified = true
#			if (refreshcb) { refreshcb() }
#		},nil,nil,196))}
	return $t;
}

sub newCostumeChange { return { type => "Costume Change", cslot => 0 } }

sub makeCostumeChange { return "cc " . shift()->{'cslot'} }

sub matchCostumeChange {
	my ($s,$profile) = @_;
	if (my $cslot = match1arg($s,"cc|costumechange",'(\d+)')) {
		if ($cslot > -1 and $cslot < 5) {
			return { type => "Costume Change", cslot => $cslot };
		}
	}
}

addCmd("Costume Change",&newCostumeChange,&formCostumeChange,&makeCostumeChange,&matchCostumeChange);
################################################################################


################################################################################
sub formAFKMessage {
	my ($t,$profile,$refreshcb) = @_;
	# t.settings = iup.frame{cbTextBox(nil,t.afkmsg,cbTextBoxCB(profile,t,"afkmsg",refreshcb),296)}
	return $t;
}

sub newAFKMessage { { type => "Away From Keyboard", afkmsg => '' } }

sub makeAFKMessage {
	my $t = shift;
	return ($t->{'afkmsg'} eq "") ? "afk" : "afk $t->{'afkmsg'}";
}

sub matchAFKMessage {
	my ($s,$profile);
	if (lc $s eq "afk ") { return }  # hmm why?
	if (lc $s eq "afk")  { return {type => "Away From Keyboard", afkmsg => ""} }
	if (my $afkmsg = match1arg($s,"afk")) { return {type => "Away From Keyboard", afkmsg => $afkmsg } }
}

addCmd("Away From Keyboard",&newAFKMessage,&formAFKMessage,&makeAFKMessage,&matchAFKMessage);
################################################################################

################################################################################
sub formSGMode {
	my $t = shift;
	undef $t->{'settings'};
	return $t;
}

sub newSGMode { { type => "SGMode Toggle", nosettings => 1 } }

sub makeSGMode { "sgmode" }

sub matchSGMode {
	my $s = shift;
	if (lc $s eq "sgmode") { return { type => "SGMode Toggle", nosettings => 1 } }
}

addCmd("SGMode Toggle",&newSGMode,&formSGMode,&makeSGMode,&matchSGMode);
################################################################################

################################################################################
sub formUnselect {
	my $t = shift;
	undef $t->{'settings'};
	return $t;
}

sub newUnselect { { type => "Unselect", nosettings => 1 } }

sub makeUnselect { "unselect" }

sub matchUnselect {
	my $s = shift;
	if (lc $s eq "unselect") { return { type => "Unselect", nosettings => 1 } }
}

addCmd("Unselect",&newUnselect,&formUnselect,&makeUnselect,&matchUnselect);
################################################################################

################################################################################
sub formTargetEnemy {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196))}
	return $t;
}

sub newTargetEnemy { { type => "Target Enemy", mode => 1 } }

sub makeTargetEnemy {
	my $t = shift;
	return "targetenemy" . qw(near far next prev)[$t->{'mode'} - 1];
}

sub matchTargetEnemy {
	return {
		type => "Target Enemy",
		mode => {
			targetenemynear => 1,
			targetenemyfar => 2,
			targetenemynext => 3,
			targetenemyprev => 4,
		}->{ lc shift() },
	};
}

addCmd("Target Enemy",&newTargetEnemy,&formTargetEnemy,&makeTargetEnemy,&matchTargetEnemy);
################################################################################

################################################################################
sub formTargetFriend {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196))}
	return $t;
}

sub newTargetFriend { { type => "Target Friend", mode => 1 } }

sub makeTargetFriend {
	my $t = shift;
	return "targetfriend" . qw(near far next prev)[$t->{'mode'} - 1];
}

sub matchTargetFriend {
	return {
		type => "Target Friend",
		mode => {
			targetfriendnear => 1,
			targetfriendfar => 2,
			targetfriendnext => 3,
			targetfriendprev => 4,
		}->{ lc shift() },
	};
}

addCmd("Target Friend",&newTargetFriend,&formTargetFriend,&makeTargetFriend,&matchTargetFriend);
################################################################################

################################################################################
sub formTargetCustom {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{iup.vbox{
#		(cbListBox("Target Mode",{"Near","Far","Next","Prev"},4,t.mode,cbListBoxCB(profile,t,"mode",nil,refreshcb),nil,nil,196)),
#		iup.hbox{(cbCheckBox("Target Enemies",t.enemy,cbCheckBoxCB(profile,t,"enemy",refreshcb),148)),
#			(cbCheckBox("Target Friends",t.friend,cbCheckBoxCB(profile,t,"friend",refreshcb),148))},
#		iup.hbox{(cbCheckBox("Target Defeated",t.defeated,cbCheckBoxCB(profile,t,"defeated",refreshcb),148)),
#			(cbCheckBox("Target Living",t.alive,cbCheckBoxCB(profile,t,"alive",refreshcb),148))},
#		iup.hbox{(cbCheckBox("Target My Pets",t.mypet,cbCheckBoxCB(profile,t,"mypet",refreshcb),148)),
#			(cbCheckBox("Target Not My Pets",t.notmypet,cbCheckBoxCB(profile,t,"notmypet",refreshcb),148))},
#		iup.hbox{(cbCheckBox("Target Base Items",t.base,cbCheckBoxCB(profile,t,"base",refreshcb),148)),
#			(cbCheckBox("Target No Base Items",t.notbase,cbCheckBoxCB(profile,t,"notbase",refreshcb),148))}
#		}
#	}
	return $t;
}

sub newTargetCustom { { type => "Target Custom", mode => 1 } }

sub makeTargetCustom {
	my $t = shift;
	my $bind = "targetcustom" . qw(near far next prev)[$t->{'mode'} - 1];

	for (qw(enemy friend defeated alive mypet notmypet base notbase)) {
		$bind .= " $_" if $t->{$_};
	}
	return $bind;

}

sub matchTargetCustom {
	my $s = shift;

	my $return = {};

	for my $v (qw( near far next prev )) {
		return if (lc $s eq "targetcustom$v");  # bail if there's nothing special
		if (my $msg = match1arg($s,"targetcustom$v")) {

			for my $case (qw(enemy friend defeated alive mypet notmypet base notbase)) {
				$return->{$case} = $msg =~ s/ $case//ig;
			}
		}
	}

	return $return;
}

addCmd("Target Custom",&newTargetCustom,&formTargetCustom,&makeTargetCustom,&matchTargetCustom);
################################################################################

################################################################################
sub formPowExecTray {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{iup.hbox{
#		(cbListBox("Power Tray",{"Main Tray","Alt Tray","Alt 2 Tray","Tray 1","Tray 2","Tray 3","Tray 4","Tray 5","Tray 6","Tray 7","Tray 8","Tray 9","Tray 10"},13,t.tray,cbListBoxCB(profile,t,"tray",nil,refreshcb),74,nil,74)),
#		(cbListBox("Power Slot",{"1","2","3","4","5","6","7","8","9","10"},10,t.slot,cbListBoxCB(profile,t,"slot",nil,refreshcb),74,nil,74)),
#		}
#	}
	return $t;
}

sub newPowExecTray { { type => "Use Power From Tray", tray => 1, slot => 1 } }

sub makePowExecTray {
	my $t = shift;
	my $mode = "slot";
	my $mode2 = "";
	if ($t->{'tray'}  > 3) { $mode = "tray"; $mode2 = " ".($t->{'tray'} - 3) }
	if ($t->{'tray'} == 3) { $mode = "alt2slot" }
	if ($t->{'tray'} == 2) { $mode = "altslot" }
	return "powexec$mode $t->{'slot'}$mode2";
}

sub matchPowExecTray {
	my $s = shift;
	my ($tray, $slot);

	if ($slot = match1arg($s,"powexecslot"))     { return { type => "Use Power From Tray", tray => 1, slot => $slot} }
	if ($slot = match1arg($s,"powexecaltslot"))  { return { type => "Use Power From Tray", tray => 2, slot => $slot} }
	if ($slot = match1arg($s,"powexecalt2slot")) { return { type => "Use Power From Tray", tray => 3, slot => $slot} }
	($slot,$tray) = match2arg(s,"powexectray");
	if ($slot and $tray) { return { type => "Use Power From Tray", tray => $tray+3, slot => $slot} }
}

addCmd("Use Power From Tray",&newPowExecTray,&formPowExecTray,&makePowExecTray,&matchPowExecTray);
################################################################################

################################################################################
sub formCustomBind {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{(cbTextBox(nil,t.custom,cbTextBoxCB(profile,t,"custom",refreshcb),296))}
	return $t;
}

sub newCustomBind { { type => "Custom Bind", custom => '' } }

sub makeCustomBind { shift()->{'custom'} }

addCmd("Custom Bind",&newCustomBind,&formCustomBind,&makeCustomBind);
################################################################################

################################################################################
### TODO -- put this in GameData.pm
my @emotelist = qw|
	afraid alakazam alakazamreact angry assumepositionwall atease attack backflip batsmash
	batsmashreact bb bbaltitude bbbeat bbcatchme bbdance bbdiscofreak bbdogwalk bbelectrovibe
	bbheavydude bbinfooverload bbjumpy bbkickit bblooker bbmeaty bbmoveon bbnotorious bbpeace
	bbquickie bbraver bbshuffle bbspaz bbtechnoid bbvenus bbwahwah bbwinditup bbyellow
	beatchest biglaugh bigwave blankfiller boombox bow bowdown burp buzzoff champion cheer
	chicken clap coin cointoss cower crack crossarms curseyou dance dice disagree
	dontattack drat drink dropboombox drumdance dustoff elaugh elegantbow evillaugh explain
	fancybow fear flashlight flex flex1 flex2 flex3 flexa flexb flexc flip flipcoin
	frustrated getsome goaway grief hand handsup hi holdtorch huh jumpingjacks kata kissit
	kneel knuckle knuckles laptop laugh laugh2 laughtoo lecture ledgesit lotus martialarts
	militarysalute muahahaha newspaper no nod noooo overhere panhandle paper peerin plot
	point praise protest raisehand research researchlow roar rock rolldice salute scared
	scheme scissors score1 score2 score3 score4 score5 score6 score7 score8 score9 score10
	screen shucks sit slap slapreact slash slashthroat sleep smack smackyou sorry stop
	surrender talk talktohand tarzan taunt taunt1 taunt2 taunta tauntb thanks thankyou thewave
	threathand thumbsup touchscreen type typing victory villainlaugh villainouslaugh walllean
	wave wavefist welcome what whistle wings winner yata yatayata yes yoga yourewelcome"
|;

sub formEmoteBind {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{(cbListBox("Emote",emotelist,emotecount,t.emote,cbListBoxCB(profile,t,nil,"emote",refreshcb),196,nil,nil,nil,true))}
	return $t;
}

sub newEmoteBind { { type => "Emote", emote => "afraid" } }

sub makeEmoteBind { "em " . shift()->{'emote'} }

sub matchEmoteBind { if (my $emote = match1arg(shift(),"e|em|me|emote")) { return {type => "Emote",emote => $emote } } }

addCmd("Emote",&newEmoteBind,&formEmoteBind,&makeEmoteBind,&matchEmoteBind);
################################################################################

################################################################################
sub formPowerAbort {
	my $t = shift;
	undef $t->{'settings'};
	return $t;
}

sub newPowerAbort { { type => "Power Abort", nosettings => 1 } }

sub makePowerAbort { "powexecabort" }

sub matchPowerAbort { if (lc shift() eq "powexecabort") { return { type => "Power Abort", nosettings => 1 } } }

addCmd("Power Abort",newPowerAbort,formPowerAbort,makePowerAbort,matchPowerAbort);
################################################################################

################################################################################
sub formPowerUnqueue {
	my $t = shift;
	undef $t->{'settings'};
	return $t;
}

sub newPowerUnqueue { { type => "Power Unqueue", nosettings => 1 } }

sub makePowerUnqueue { "powexecunqueue" }

sub matchPowerUnqueue { if (lc shift() eq "powexecunqueue") { return { type => "Power Unqueue", nosettings => 1 } } }

addCmd("Power Unqueue",&newPowerUnqueue,&formPowerUnqueue,&makePowerUnqueue,&matchPowerUnqueue);
################################################################################

################################################################################
sub formAutoPower {
	my ($t,$profile,$refreshcb) = @_;
#	my powerlist = profile.powerset or {}
#	t.settings = iup.frame{(cbListBox("Power",powerlist,table.getn(powerlist),t.power,
#		function(_,s,i,v)
#			if (v == 1) { t.power = s }
#			profile.modified = true
#			if (refreshcb) { refreshcb() }
#		},196,nil,100,nil,true))
#	}
	return $t;
}

sub newAutoPower { { type => "Auto Power", power => '' } }

sub makeAutoPower { return "powexecauto" . shift()->{'power'} }

sub matchAutoPower { if (my $power = match1arg($s, "powexecauto")) { return { type => "Auto Power", power => $power } } }

addCmd("Auto Power",&newAutoPower,&formAutoPower,&makeAutoPower,&matchAutoPower);
################################################################################

################################################################################
sub formInspExecTray {
	my ($t,$profile,$refreshcb) = @_;
#	t.settings = iup.frame{iup.hbox{
#		(cbTextBox("Row",t.row,cbTextBoxCB(profile,t,"row",refreshcb),74,nil,74)),
#		(cbTextBox("Column",t.col,cbTextBoxCB(profile,t,"col",refreshcb),74,nil,74)),
#		}
#	}
	return $t;
}

sub newInspExecTray { { type => "Use Inspiration From Row/Column", row => 1, col => 1 } }

sub makeInspExecTray {
	my $t - shift;
	if ($t->{'row'} == "1") {
		return "inspexecslot $t->{'col'}"
	} else {
		return "inspexectray $t->{'col'} $t->{'row'}"
	}
}

sub matchInspExecTray {
	my $s = shift;
	my ($col,$row) = match2arg(%s,"inspexectray","(%d*)","(%d*)")
	if ($col and $row) { return { type => "Use Inspiration From Row/Column", row => $row, col => $col } }

	$col = match1arg($s,"inspexecslot","(%d*)")
	if ($col) { return { type => "Use Inspiration From Row/Column", row => 1, col => $col } }
}

addCmd("Use Inspiration From Row/Column",&newInspExecTray,&formInspExecTray,&makeInspExecTray,&matchInspExecTray);
################################################################################

sub insps = {"Insight","Keen Insight","Uncanny Insight",
"Respite","Dramatic Improvement","Resurgance",
"Enrage","Focused Rage","Righteous Rage",
"Catch a Breath","Take a Breather","Second Wind",
"Luck","Good Luck","Phenomenal Luck",
"Break Free","Emerge","Escape",
"Sturdy","Rugged","Robust"}

sub formInspExecName {
	my (t,profile,refreshcb)
	t.settings = iup.frame{
		(cbListBox("Inspiration",insps,table.getn(insps),t.insp,cbListBoxCB(profile,t,"insp",nil,refreshcb),196))
	}
	return t
}

sub newInspExecName {
	my ()
	my t = {}
	t.type = "Use Inspiration By Name"
	t.insp = 1
	return t
}

sub makeInspExecName {
	my (t)
	return "inspexecname "..insps[t.insp]
}

sub matchInspExecName {
	my (s,profile)
	for i,v in ipairs(insps) do
		if (s:lower() == "inspexecname "..v:lower()) { return {type="Use Inspiration By Name",insp=i} }
	}
}

addCmd("Use Inspiration By Name",newInspExecName,formInspExecName,makeInspExecName,matchInspExecName);

sub formGlobalChat {
	my (t,profile,refreshcb)
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

sub newGlobalChat {
	my ()
	my t = {}
	t.type = "Chat Command (Global)"
	t.channel = "CityBinder"
	t.msg = "[$name $level]:"
	return t
}

sub makeGlobalChat {
	my (t)
	if (t.prefix) { t.msg = t.prefix..' '..t.msg t.prefix = nil }
	if (t.usemsg) {
		return 'send "'..t.channel..'" '..t.msg
	} else {
		return 'beginchat /send "'..t.channel..'" '..t.msg
	}
}

sub matchGlobalChat {
	my (s,profile)
	my channel, msg
	channel, msg = match2arg(s,'send','"([^"]*)"','(.*)')
	if (channel and msg) { return {type="Chat Command (Global)",usemsg=true,channel=channel,msg=msg} }
	--channel, msg = match2arg(s,'beginchat /send','"([^"]*)"','(.*) ')
	--if (channel and msg) { return {type="Chat Command (Global)",channel=channel,msg=msg} }
	my s2
	if (string.sub(s,1,11):lower() == "beginchat /") {
		s2 = string.sub(s,12,-1)
	} else {
		return nil
	}
	channel, msg = match2arg(s2,'send','"([^"]*)"','(.*)')
	if (channel and msg) { return {type="Chat Command (Global)",channel=channel,msg=msg} }
}

addCmd("Chat Command (Global)",newGlobalChat,formGlobalChat,makeGlobalChat,matchGlobalChat);

sub windowlist = {"powers","manage","chat","tray","target","nav","map","menu","pets"}
sub revwindowlist = {}
for i,v in ipairs(windowlist) do revwindowlist[v] = i }

sub formWindowToggle {
	my (t,profile,refreshcb)
	t.settings = iup.frame{(cbListBox("Window",windowlist,table.getn(windowlist),t.window,
		function(_,s,i,v)
			if (v == 1) { t.window = s }
			profile.modified = true
			if (refreshcb) { refreshcb() }
		},196,nil,100,nil,true))
	}
	return t
}

sub newWindowToggle {
	my ()
	-- return a table containing the needed items for controlling this power.
	my t = {}
	t.type = "Window Toggle"
	t.window = "powers"
	return t
}

sub makeWindowToggle {
	my (t)
	return t.window
}

sub matchWindowToggle {
	my (s,profile)
	if (revwindowlist[s:lower()]) { return {type="Window Toggle",window=s:lower()} }
}

addCmd("Window Toggle",newWindowToggle,formWindowToggle,makeWindowToggle,matchWindowToggle);

sub formTeamPetSelect {
	my (t,profile,refreshcb)
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

sub newTeamPetSelect {
	my ()
	-- return a table containing the needed items for controlling this power.
	my t = {}
	t.type = "Team/Pet Select"
	t.teamsel = 1
	t.number = 1
	return t
}

sub makeTeamPetSelect {
	my (t)
	if (t.teamsel == 1) {
		return "teamselect "..t.number
	} else {
		return "petselect "..(t.number-1)
	}
}

sub matchTeamPetSelect {
	my (s,profile)
	my number = match1arg(s,"teamselect","(%d*)")
	if (number) { return {type="Team/Pet Select",teamsel=1,number=tonumber(number)} }
	number = match1arg(s,"petselect","(%d*)")
	if (number) { return {type="Team/Pet Select",teamsel=2,number=tonumber(number)+1} }
}

addCmd("Team/Pet Select",newTeamPetSelect,formTeamPetSelect,makeTeamPetSelect,matchTeamPetSelect);

sub cbGetColor {
	my ($r,$g,$b) = @_;
# 	my tr, tg, tb = r,g,b
# 	my redbox, greenbox, bluebox
# 	my colorbox
# 	my okbtn, cancelbtn
# 	colorbox = iup.colorbrowser{rgb=tr.." "..tg.." "..tb}
# 	redbox,redtext = cbTextBox("Red:",tr,function(_,c,s) tr = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
# 	greenbox,greentext = cbTextBox("Green:",tg,function(_,c,s) tg = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
# 	bluebox,bluetext = cbTextBox("Blue:",tb,function(_,c,s) tb = tonumber(s) colorbox.rgb = tr.." "..tg.." "..tb return iup.DEFAULT })
# 	colorbox.drag_cb = function(_,cbr,cbg,cbb) tr, tg, tb = cbr, cbg, cbb redtext.value = cbr greentext.value = cbg bluetext.value = cbb }
# 	okbtn = iup.button{title="OK";rastersize="100x21"}
# 	cancelbtn = iup.button{title="Cancel";rastersize="100x21"}
# 	my box = iup.hbox{colorbox,iup.vbox{redbox,greenbox,bluebox,iup.hbox{okbtn,cancelbtn}}}
# 	my colordlg = iup.dialog{box,title="Select a Color",maxbox="NO",resize="NO"}
# 	okbtn.action = function() colordlg:hide() }
# 	cancelbtn.action = function() tr,tg,tb = r,g,b colordlg:hide() }
# 	colordlg:popup(iup.CENTER,iup.CENTER)
# 	return tr, tg, tb
}

sub formChatCommand {
	my (t,profile,refreshcb)
	my bordercolor = iup.label{title=" ";image = buildColorImage(t.border.r,t.border.g,t.border.b); rastersize="17x17"}
	my borderbtn = iup.button{title="Border";rastersize="46x21"}
	borderbtn.action=function()
		t.border.r,t.border.g,t.border.b = cbGetColor(t.border.r,t.border.g,t.border.b)
		bordercolor.image = buildColorImage(t.border.r,t.border.g,t.border.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}
	my bgcolor = iup.label{title=" ";image = buildColorImage(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b); rastersize="17x17"}
	my bgbtn = iup.button{title="BG";rastersize="45x21"}
	bgbtn.action=function()
		t.bgcolor.r,t.bgcolor.g,t.bgcolor.b = cbGetColor(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
		bgcolor.image = buildColorImage(t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}
	my textcolor = iup.label{title=" ";image = buildColorImage(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b); rastersize="17x17"}
	my textbtn = iup.button{title="Text";rastersize="46x21"}
	textbtn.action=function()
		t.fgcolor.r,t.fgcolor.g,t.fgcolor.b = cbGetColor(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
		textcolor.image = buildColorImage(t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
		if (refreshcb) { refreshcb() }
		profile.modified = true
	}

	t.settings = iup.frame{iup.vbox{
		(cbCheckBox("Chat Bubble Colors",t.usecolors,function(_,v) if (v == 1) { t.usecolors = true } else { t.usecolors = nil } profile.modified = true if (refreshcb) { refreshcb() } })),
		iup.hbox{
			iup.frame{bordercolor;sunken="YES"; rastersize="21x21";margin="1x1"},borderbtn,
			iup.frame{bgcolor;sunken="YES"; rastersize="21x21";margin="1x1"},bgbtn,
			iup.frame{textcolor;sunken="YES"; rastersize="21x21";margin="1x1"},textbtn},
		(cbListBox("Duration",{"1","2","3","4","5","6","7 (Default)","8","9","10","11","12","13","14","15","16","17","18","19","20"},20,t.duration,function(_,s,i,v)
			if (v == 1) { t.duration = i } profile.modified = true if (refreshcb) { refreshcb() } })),
		(cbListBox("Size",{"0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5"},11,tostring(t.size),function(_,s,i,v)
			if (v == 1) { t.size = tonumber(s) } profile.modified = true if (refreshcb) { refreshcb() } },nil,nil,nil,nil,true)),
		(cbListBox("Channel",{"say","group","broadcast","my","yell","fri}s","request","arena","supergroup","coalition","tell $target,","tell $name,"},12,t.channel,cbListBoxCB(profile,t,"channel",nil,refreshcb))),
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

sub newChatCommand {
	{
		type => "Chat Command",
		channel => 1,
		text => "",
		duration => 7,
		size => 1.0,
		usecolors => nil,
		border => {
			r => 0,
			g => 0,
			b => 0,
		},
		fgcolor => {
			r => 0,
			g => 0,
			b => 0,
		},
		bgcolor => {
			r => 255,
			g => 255,
			b => 255,
		},
	}
}

my $chatchannelmap = {"s","g","b","l","y","f","req","ac","sg","c","t $target,","t $name,"};

sub makeChatCommand {
	my (t)
	my size = "<scale "..t.size..">"
	my duration = "<duration "..t.duration..">"
	my border = string.format("<bordercolor #%02x%02x%02x>",t.border.r,t.border.g,t.border.b)
	my color = string.format("<color #%02x%02x%02x>",t.fgcolor.r,t.fgcolor.g,t.fgcolor.b)
	my bgcolor = string.format("<bgcolor #%02x%02x%02x>",t.bgcolor.r,t.bgcolor.g,t.bgcolor.b)
	if (t.size == 1.0) { size = "" }
	if (t.duration == 7) { duration = "" }
	if (not t.usecolors) {
		border = ""
		color = ""
		bgcolor = ""
	}
	if (t.usemsg) {
		return chatchannelmap[t.channel].." "..size..duration..border..color..bgcolor..t.text
	} else {
		return "beginchat /"..chatchannelmap[t.channel].." "..size..duration..border..color..bgcolor..t.text
	}
}

sub hexconv={["0"] = 0,["1"] = 1,["2"] = 2,["3"] = 3,["4"] = 4,["5"] = 5,["6"] = 6,["7"] = 7,
	["8"] = 8,["9"] = 9,["a"] = 10,["b"] = 11,["c"] = 12,["d"] = 13,["e"] = 14,["f"] = 15}

sub sub stringToColor {
	my ($s) = @_;
	my t = {s:byte(1,-1)}
	my r = (hexconv[t[1]]*16)+hexconv[t[2]]
	my g = (hexconv[t[3]]*16)+hexconv[t[4]]
	my b = (hexconv[t[5]]*16)+hexconv[t[6]]
	return {r=r,g=g,b=b}
}

sub chatchannel = {"s","g","b","l","y","f","req","ac","sg","c","t $target,","t $name,","tell $target,","tell $name,","p $target,","p $name,",
	"private $target,","private $name,","whisper $target,","whisper $name,","fri}s","group","team","yell","broadcast","my","request","sell",
	"auction","supergroup","coalition","arena","say"}
sub revchatchannel = {["say"] = 1,["s"] = 1,["t $target,"] = 11,["tell $target,"] = 11,["private $target,"] = 11,["p $target,"] = 11,
	["whisper $target,"] = 11,["t $name,"] = 12,["tell $name,"] = 12,["private $name,"] = 12,["p $name,"] = 12,["whisper $name,"] = 12,["f"] = 6,
	["group"] = 2,["g"] = 2,["team"] = 2,["yell"] = 5,["y"] = 5,["broadcast"] = 3,["b"] = 3,["my"] = 4,["l"] = 4,["request"] = 7,["req"] = 7,
	["sell"] = 7,["auction"] = 7,["supergroup"] = 9,["sg"] = 9,["coalition"] = 10,["c"] = 10,["ac"] = 8,["arena"] = 8,}

sub matchChatCommand {
	my (s,profile)
	for i,v in ipairs(chatchannel) do
		my withmessage = true
		my msg = match1arg(s,v)
		if (not msg) {
			my s2
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
			my size = match1arg(msg,"<scale","(.*)>")
			if (size) {
				msg = string.gsub(msg,caseless("<scale "..size..">"),"")
				size = tonumber(size)
			}
			if (not size) { size = 1.0 }
			my duration = match1arg(msg,"<duration","(.*)>")
			if (duration) {
				msg = string.gsub(msg,caseless("<duration "..duration..">"),"")
				duration = tonumber(duration)
			}
			if (not duration) { duration = 7 }
			my usecolors
			my border = match1arg(msg,"<bordercolor","#(%x%x%x%x%x%x)>")
			if (border) {
				msg = string.gsub(msg,caseless("<bordercolor #"..border..">"),"")
				border = stringToColor(border)
				usecolors = true
			}
			if (not border) { border = {r=0,g=0,b=0} }
			my color = match1arg(msg,"<color","#(%x%x%x%x%x%x)>")
			if (color) {
				msg = string.gsub(msg,caseless("<color #"..color..">"),"")
				color = stringToColor(color)
				usecolors = true
			}
			if (not color) { color = {r=0,g=0,b=0} }
			my bgcolor = match1arg(msg,"<bgcolor","#(%x%x%x%x%x%x)>")
			if (bgcolor) {
				msg = string.gsub(msg,caseless("<bgcolor #"..bgcolor..">"),"")
				bgcolor = stringToColor(bgcolor)
				usecolors = true
			}
			if (not bgcolor) { bgcolor = {r=255,g=255,b=255} }
			--if (not withmessage) { msg = "" }
			-- now build the table with the information at hand...
			my t = {}
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

addCmd("Chat Command",newChatCommand,formChatCommand,makeChatCommand,matchChatCommand);

chatnogloballimit = {cmdlist={"Emote","Custom Bind","Costume Change","Chat Command"}}

1;
