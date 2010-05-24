package SoD;

use strict;
use Wx qw(
	wxALL wxVERTICAL
	wxDefaultPosition wxDefaultSize wxDefaultValidator
	wxCB_READONLY
	wxALIGN_RIGHT
);
use Wx::Event qw(
	EVT_CHECKBOX
);


use BCConstants;

use constant true => 1;
use constant nil => undef;

my @sodConvert = qw( NonSOD Base Fly Jump Run );

#  function sodConvertDefaultBack(profile,SoD,uiupdate)
#  	return function(_,str,i,v)
#  		profile.modified = true
#  		if v == 1 then
#  			$SoD->{'Default'} = sodConvertDefaultBackTable[i]
#  			if type(uiupdate) == "function" then uiupdate() end
#  		end
#  	end
#  end


use base 'Wx::Panel';

sub new {
	my ($class, $parentwindow) = @_;

	my $self = $class->SUPER::new($parentwindow);

	my $topSizer = Wx::FlexGridSizer->new(0,1,3,3);

	$topSizer->Add(
		Wx::CheckBox->new( $self, USE_SOD, "Enable Speed On Demand Binds" ),
		0,
		wxALL,
		10,
	);

	$self->SetSizer($topSizer);

	EVT_CHECKBOX( $self, USE_SOD, \&FillSoDPanel );

	return $self;
}

# is this gonna be right?  scope the various panels here.
my ($generalSizer,$sprintSizer);
sub FillSoDPanel {

	my ($panel, $event) = @_;

	my $cb = $event->GetEventObject();

	my $overallSizer = $panel->GetSizer();

	##### GENERAL MOVEMENT KEYS
	if (!$generalSizer) {

		# general movement keys
		$generalSizer = Wx::FlexGridSizer->new(0,2,3,3);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Up:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, UP_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Down:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, DOWN_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Forward:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, FORWARD_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Back:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, BACK_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Strafe Left:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, STRAFE_LEFT_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Strafe Right:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, STRAFE_RIGHT_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Turn Left:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, TURN_LEFT_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Turn Right:"), 0, wxALL,);
		$generalSizer->Add( Wx::TextCtrl->  new($panel, TURN_RIGHT_KEY, ""), 0, wxALL,);

		$generalSizer->Add( Wx::CheckBox->new($panel, MOUSECHORD_SOD, "Use Mousechord as SoD Forward"), 0, wxALL,);

		$overallSizer->Add($generalSizer);
	}

	$generalSizer->Show($cb->IsChecked());
	$overallSizer->Layout();


	##### SPRINT SOD BINDS
	if (!$sprintSizer) {

		# general movement keys
		$sprintSizer = Wx::FlexGridSizer->new(0,2,3,3);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Sprint Power:"), 0, wxALL,);
		$sprintSizer->Add( Wx::ComboBox->new(
				$panel, SPRINT_PICKER, '',
				wxDefaultPosition, wxDefaultSize,
				[@Profile::SprintPowers],
				wxCB_READONLY,
			), 0, wxALL,);

		$sprintSizer->Add( Wx::CheckBox->new($panel, AUTO_MOUSELOOK, "Automatically Mouselook When Moving"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		# TODO -- decide what to do with this.
		# $sprintSizer->Add( Wx::CheckBox->new($panel, SPRINT_UNQUEUE, "Exec powexecunqueue"), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Autorun:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, AUTORUN_KEY, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Follow Target:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, FOLLOW_KEY, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Non-SoD Mode:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, NON_SOD_KEY, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Sprint-Only SoD Mode:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, SPRINT_ONLY_SOD_KEY, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::CheckBox->new($panel, SPRINT_SOD, "Enable Sprint SoD"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "SoD Mode Toggle:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, SOD_TOGGLE_KEY, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::CheckBox->new($panel, CHANGE_TRAVEL_CAMERA, "Change Camera Distance When Travel Power Active"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Base Camera Distance:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, BASE_CAMERA_DISTANCE, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Travelling Camera Distance:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, TRAVEL_CAMERA_DISTANCE, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::CheckBox->new($panel, CHANGE_TRAVEL_DETAIL, "Change Graphic Detail When Travel Power Active"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Base Detail Level:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, BASE_DETAIL_LEVEL, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::StaticText->new($panel, -1, "Travelling Detail Level:"), 0, wxALL,);
		$sprintSizer->Add( Wx::TextCtrl->  new($panel, TRAVEL_DETAIL_LEVEL, ""), 0, wxALL,);

		$sprintSizer->Add( Wx::CheckBox->new($panel, HIDE_WINDOWS_TELEPORTING, "Hide Windows When Teleporting"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		$sprintSizer->Add( Wx::CheckBox->new($panel, SEND_SOD_SELF_TELLS, "Send Self-Tells When Changing SoD Modes"), 0, wxALL,);
		$sprintSizer->AddSpacer(1);

		$overallSizer->Add($sprintSizer);
	}

	$sprintSizer->Show($cb->IsChecked());
	$overallSizer->Layout();



	# keep moving this to the bottom?
	$overallSizer->Fit($panel);

	my $poolPowers = Profile::poolPowers();

	# OK, now find all the movement powers
	for ( sort keys %$poolPowers ) {

	}


#			local sssjEnabled
#			cbToolTip("Choose the Key Combo to Toggle Super Speed mode")
#			local sodrunmodehbox = cbBindBox("Speed Mode Key",SoD,"RunModeKey",nil,profile)
#			if not $SoD->{'SS'}->{'SS'} or $SoD->{'Default'} == "Run" then
#				sodrunmodehbox.active="NO"
#			else
#				sodrunmodehbox.active="YES"
#			end
#			cbToolTip("Check this if you only want Super Speed to be used when moving.")
#			local sodssmobileonly = cbCheckBox("Mobile SS Only",$SoD->{'SS'}->{'MobileOnly'},cbCheckBoxCB(profile,$SoD->{'SS'},"MobileOnly"))
#			cbToolTip("Check this to enable Super Speed+Super Jump Mode.")
#			local sodsssjmode = cbCheckBox("Super Speed+Super Jump Mode",$SoD->{'SS'}->{'SSSJMode'},cbCheckBoxCB(profile,$SoD->{'SS'},"SSSJMode"))
#			cbToolTip("Check this if you want to use Super Speed SoD Binds")
#			local sodrunprimhbox = cbCheckBox("Character has Super Speed?",$SoD->{'SS'}->{'SS'},
#				function(_,v) profile.modified = true 
#					if v == 1 then
#						$SoD->{'Run'}->{'Primary'} = "Super Speed"
#						$SoD->{'SS'}->{'SS'} = true
#						$SoD->{'Run'}->{'PrimaryNumber'} = 2
#						if $SoD->{'Default'} ~= "Run" then
#							sodrunmodehbox.active="YES"
#						end
#						sodssmobileonly.active = "YES"
#						sssjEnabled()
#					else
#						$SoD->{'Run'}->{'Primary'} = "None"
#						$SoD->{'SS'}->{'SS'} = nil
#						$SoD->{'Run'}->{'PrimaryNumber'} = 1
#						sodrunmodehbox.active="NO"
#						sodssmobileonly.active = "NO"
#						sssjEnabled()
#					end
#				end
#			)
#			if not $SoD->{'SS'}->{'SS'} then sodssmobileonly.active="NO" end
#			
#			cbToolTip("Choose the Key Combo to switch to Jump mode")
#			local sodjmpmodehbox = cbBindBox("Jump Mode Key",SoD,"JumpModeKey",nil,profile)
#			cbToolTip("Check this if you want to use a simple mode toggle for Combat Jumping and Super Jump")
#			local sodsimplejump = cbCheckBox("Use Simple CJ/SJ Mode Toggle?",$SoD->{'Jump'}->{'Simple'},
#				cbCheckBoxCB(profile,$SoD->{'Jump'},"Simple"))
#			local jmpEnabled = function()
#				if $SoD->{'Jump'}->{'CJ'} or $SoD->{'Jump'}->{'SJ'} then
#					if $SoD->{'Default'} ~= "Jump" then
#						sodjmpmodehbox.active = "YES"
#					else
#						sodjmpmodehbox.active = "NO"
#					end
#					sodsimplejump.active = "YES"
#				else
#					sodjmpmodehbox.active = "NO"
#					sodsimplejump.active = "NO"
#				end
#			end
#			jmpEnabled()
#			cbToolTip("Check this if your Character has the Combat Jumping power")
#			#  Use a customized callback here in order to call the jmpEnabled() function when needed
#			local sodhascj = cbCheckBox("Character has Combat Jumping?",$SoD->{'Jump'}->{'CJ'},
#				function(_,v) profile.modified = true if v == 1 then $SoD->{'Jump'}->{'CJ'} = true else $SoD->{'Jump'}->{'CJ'} = nil end jmpEnabled() end)
#			cbToolTip("Check this if your Character has the Super Jump power")
#			#  Use a customized callback here in order to call the jmpEnabled() function when needed
#			sssjEnabled = function()
#				if $SoD->{'SS'}->{'SS'} and $SoD->{'Jump'}->{'SJ'} then
#					sodsssjmode.active = "YES"
#				else
#					sodsssjmode.active = "NO"
#				end
#			end
#			local sodhasjump = cbCheckBox("Character has Super Jump?",$SoD->{'Jump'}->{'SJ'},
#				function(_,v) profile.modified = true if v == 1 then $SoD->{'Jump'}->{'SJ'} = true else $SoD->{'Jump'}->{'SJ'} = nil end jmpEnabled() sssjEnabled() end
#			)
#			
#			sssjEnabled()
#			
#			local flyEnabled
#			local HasHoverText = "Character Has Hover?"
#			local sodhasqflight
#			local sodqflighthbox
#			if profile.archetype == "Peacebringer" then
#				HasHoverText = "Character Has Combat Flight?"
#				cbToolTip("Choose the Key Combo to switch to Quantum Flight mode")
#				sodqflighthbox = cbBindBox("Q. Fly Mode Key",SoD,"QFlyModeKey",nil,profile)
#				local function qflyenabled()
#					if $SoD->{'Fly'}->{'QFly'} then
#						sodqflighthbox.active = "YES"
#					else
#						sodqflighthbox.active = "NO"
#					end
#				end
#				cbToolTip("Check this if your Character has the Quantum Flight power")
#				sodhasqflight = cbCheckBox("Character Has Quantum Flight?",$SoD->{'Fly'}->{'QFly'},
#					function(_,v) profile.modified = true if v == 1 then $SoD->{'Fly'}->{'QFly'} = true else $SoD->{'Fly'}->{'QFly'} = nil end qflyenabled() end)
#				qflyenabled()
#			end
#			cbToolTip("Choose the Key Combo to switch to Fly mode")
#			local sodflymodehbox = cbBindBox("Fly Mode Key",SoD,"FlyModeKey",nil,profile)
#			cbToolTip("Check this if your Character has the Hover power")
#			#  Use a customized callback here in order to call the flyEnabled() function when needed
#			local sodhashover = cbCheckBox(HasHoverText,$SoD->{'Fly'}->{'Hover'},
#				function(_,v) profile.modified = true if v == 1 then $SoD->{'Fly'}->{'Hover'} = true else $SoD->{'Fly'}->{'Hover'} = nil end flyEnabled() end)
#			cbToolTip("Check this if your Character has the Fly power")
#			#  Use a customized callback here in order to call the flyEnabled() function when needed
#			local sodhasfly = cbCheckBox("Character Has Fly?",$SoD->{'Fly'}->{'Fly'},
#				function(_,v) profile.modified = true if v == 1 then $SoD->{'Fly'}->{'Fly'} = true else $SoD->{'Fly'}->{'Fly'} = nil end flyEnabled() end)
#		
#		
#			local TPQuestion = "Teleport Bind"
#			local sodtpbind
#			if profile.archetype == "Peacebringer" then
#				TPQuestion = "Dwarf Step Bind"
#			elseif profile.archetype == "Warshade" then
#				TPQuestion = "Shd/Dwf Step Bind"
#			end
#			cbToolTip("Set this to the first Key in your Teleport Key Combo, e.g. LSHIFT if the Teleport is bound to LSHIFT+LBUTTON")
#			local sodtpcombo = cbBindBox("TP ComboKey",$SoD->{'TP'},"ComboKey",nil,profile)
#			cbToolTip("Choose the Reset Key for the teleport bind")
#			local sodtpreset = cbBindBox("TP ResetKey",$SoD->{'TP'},"ResetKey",nil,profile)
#			cbToolTip("Choose the Key Combo to teleport with")
#			sodtpbind = cbBindBox(TPQuestion,$SoD->{'TP'},"BindKey",nil,profile)
#			cbToolTip("Enable this if you have Hover and want to automatically activate it when teleporting.")
#			sodtphover = cbCheckBox("Auto-Hover when Teleporting?",$SoD->{'TP'}->{'TPHover'},cbCheckBoxCB(profile,$SoD->{'TP'},"TPHover"))
#			if not $SoD->{'TP'}->{'Enable'} then
#				sodtpcombo.active = "NO"
#				sodtpreset.active = "NO"
#				sodtpbind.active = "NO"
#				sodtphover.active = "NO"
#			elseif $SoD->{'Fly'}->{'Hover'} then
#				sodtphover.active = "YES"
#			end
#			cbToolTip("Chech this to enable the advanced TP binds for the TP power pool, or for Kheldian TP Powers")
#			local sodhastp = cbCheckBox("Character Has TP?",$SoD->{'TP'}->{'Enable'},
#				function(_,v) profile.modified = true 
#					if v == 1 then
#						$SoD->{'TP'}->{'Enable'} = true
#						sodtpcombo.active = "YES"
#						sodtpreset.active = "YES"
#						sodtpbind.active = "YES"
#						if $SoD->{'Fly'}->{'Hover'} then
#							sodtphover.active = "YES"
#						else
#							sodtphover.active = "NO"
#						end
#					else
#						$SoD->{'TP'}->{'Enable'} = nil
#						sodtpcombo.active = "NO"
#						sodtpreset.active = "NO"
#						sodtpbind.active = "NO"
#						sodtphover.active = "NO"
#					end
#				end)
#		
#		# 	local gflyenabled
#		# 	cbToolTip("Choose the Key Combo to switch to Group Fly mode")
#		# 	local sodgflymodehbox = cbBindBox("Group Fly Key",SoD,"GFlyModeKey",nil,profile)
#		# 	cbToolTip("Check this if your Character has the Group Fly power")
#		# 	local sodhasgfly = cbCheckBox("Character Has Group Fly?",$SoD->{'Fly'}->{'GFly'},
#		# 		function(_,v) profile.modified = true 
#		# 			if v == 1 then
#		# 				$SoD->{'Fly'}->{'GFly'} = true
#		# 			else
#		# 				$SoD->{'Fly'}->{'GFly'} = nil
#		# 			end
#		# 			gflyEnabled()
#		# 		end
#		# 	)
#		
#		
#			local TTPQuestion = "Team TP Bind"
#			local sodttpbind
#			cbToolTip("Set this to the first Key in your Team TP Key Combo, e.g. LSHIFT if the Team TP is bound to LSHIFT+LBUTTON")
#			local sodttpcombo = cbBindBox("TTP ComboKey",$SoD->{'TTP'},"ComboKey",nil,profile)
#			cbToolTip("Choose the Reset Key for the teleport bind")
#			local sodttpreset = cbBindBox("TTP ResetKey",$SoD->{'TTP'},"ResetKey",nil,profile)
#			cbToolTip("Choose the Key Combo to teleport with")
#			sodttpbind = cbBindBox(TPQuestion,$SoD->{'TTP'},"BindKey",nil,profile)
#		# 	cbToolTip("Enable this if you have Group Fly and want to automatically activate it when team teleporting.")
#		# 	sodttpgfly = cbCheckBox("Auto-Group Fly when Team 'Porting?",$SoD->{'TP'}->{'TTPGFly'},cbCheckBoxCB(profile,$SoD->{'TP'},"TTPGFly"))
#			if not $SoD->{'TTP'}->{'Enable'} then
#				sodttpcombo.active = "NO"
#				sodttpreset.active = "NO"
#				sodttpbind.active = "NO"
#			end
#		# 	if $SoD->{'Fly'}->{'GFly'} and $SoD->{'TTP'}->{'Enable'} then
#		# 		sodttpgfly.active = "YES"
#		# 	else
#		# 		sodttpgfly.active = "NO"
#		# 	end
#			cbToolTip("Chech this to enable the advanced TP binds for the Team TP power")
#			local sodhasttp = cbCheckBox("Character Has Team TP?",$SoD->{'TTP'}->{'Enable'},
#				function(_,v) profile.modified = true 
#					if v == 1 then
#						$SoD->{'TTP'}->{'Enable'} = true
#						sodttpcombo.active = "YES"
#						sodttpreset.active = "YES"
#						sodttpbind.active = "YES"
#		# 				if $SoD->{'Fly'}->{'GFly'} then
#		# 					sodttpgfly.active = "YES"
#		# 				else
#		# 					sodttpgfly.active = "NO"
#		# 				end
#					else
#						$SoD->{'TTP'}->{'Enable'} = nil
#						sodttpcombo.active = "NO"
#						sodttpreset.active = "NO"
#						sodttpbind.active = "NO"
#		# 				sodttpgfly.active = "NO"
#					end
#				end)
#		
#			cbToolTip("Check this to Enable the Temp Travel Power Mode")
#			local sodtempenable = cbCheckBox("Enable Temp Travel Mode",$SoD->{'Temp'}->{'Enable'},cbCheckBoxCB(profile,$SoD->{'Temp'},'Enable'))
#			cbToolTip("Choose the Key Combo to switch to Temp Travel mode")
#			local sodtempmodehbox = cbBindBox("Temp Mode Key",SoD,"TempModeKey",nil,profile)
#			cbToolTip("Set this to a powertray to change to Use for Temp Travel Powers")
#			local sodtemptrayhbox = cbTextBox("Temp Travel Tray",$SoD->{'Temp'}->{'Tray'},cbTextBoxCB(profile,$SoD->{'Temp'},"Tray"))
#			cbToolTip("Choose the Key Combo to Toggle to Temp Travel power tray")
#			local sodtemptrayswitchhbox = cbBindBox("Tray Toggle Key",$SoD->{'Temp'},"TraySwitch",nil,profile)
#		
#			flyEnabled = function()
#				if $SoD->{'Fly'}->{'Hover'} and $SoD->{'TP'}->{'Enable'} then
#					sodtphover.active = "YES"
#				else
#					sodtphover.active = "NO"
#				end
#				if $SoD->{'Fly'}->{'Hover'} or $SoD->{'Fly'}->{'Fly'} then
#					if $SoD->{'Default'} ~= "Fly" then
#						sodflymodehbox.active = "YES"
#					else
#						sodflymodehbox.active = "NO"
#					end
#				else
#					sodflymodehbox.active = "NO"
#				end
#			end
#			flyEnabled()
#		
#		# 	gflyEnabled = function()
#		# 		if $SoD->{'Fly'}->{'GFly'} and $SoD->{'TTP'}->{'Enable'} then
#		# 			sodttpgfly.active = "YES"
#		# 		else
#		# 			sodttpgfly.active = "NO"
#		# 		end
#		# 		if $SoD->{'Fly'}->{'GFly'} and $SoD->{'Default'} ~= "GFly" then
#		# 			sodgflymodehbox.active = "YES"
#		# 		else
#		# 			sodgflymodehbox.active = "NO"
#		# 		end
#		# 	end
#		# 	gflyEnabled()
#		
#			
#			local khnovatgl,khnovatray,khdwarftgl,khdwarftray,khhumanpwr,khhumanbnd,khhumanpbind,khnovapbind,khdwarfpbind
#			if profile.archetype == "Warshade" or profile.archetype == "Peacebringer" then
#				cbToolTip("Check this to Enable a toggle key for Nova Form")
#				khnovatgl = cbCheckBox("Use Nova Toggle?",$SoD->{'Nova'}->{'Enable'},
#					cbCheckBoxCB(profile,$SoD->{'Nova'},"Enable"))
#				cbToolTip("Choose the Key Combo to toggle Nova Form with")
#				khnovabnd = cbBindBox("Nova Form Bind",$SoD->{'Nova'},"ModeKey",nil,profile)
#				cbToolTip("Set this to a powertray to change to when in Nova Form")
#				khnovatray = cbTextBox("Nova Power Tray",$SoD->{'Nova'}->{'PowerTray'},cbTextBoxCB(profile,$SoD->{'Nova'},"PowerTray"))
#				cbToolTip("Check this to Enable a toggle key for Dwarf Form")
#				khdwarftgl = cbCheckBox("Use Dwarf Toggle?",$SoD->{'Dwarf'}->{'Enable'},
#					cbCheckBoxCB(profile,$SoD->{'Dwarf'},"Enable"))
#				cbToolTip("Choose the Key Combo to toggle Dwarf Form with")
#				khdwarfbnd = cbBindBox("Dwarf Form Bind",$SoD->{'Dwarf'},"ModeKey",nil,profile)
#				cbToolTip("Set this to a powertray to change to when in Dwarf Form")
#				khdwarftray = cbTextBox("Dwarf Power Tray",$SoD->{'Dwarf'}->{'PowerTray'},cbTextBoxCB(profile,$SoD->{'Dwarf'},"PowerTray"))
#				khhumanpwr = cbTogglePower("Human Form Power",profile.powerset,$SoD->{'UseHumanFormPower'},SoD,"HumanFormShield",
#					cbCheckBoxCB(profile,SoD,"UseHumanFormPower"),profile)
#				khhumanpbind = iup.hbox{iup.label{title="Human",rastersize="50x"},(cbPowerBindBtn(nil,$SoD->{'Human'},"HumanPBind",nil,150,nil,profile))}
#				khnovapbind = iup.hbox{iup.label{title="Nova",rastersize="50x"},(cbPowerBindBtn(nil,$SoD->{'Human'},"NovaPBind",nil,150,nil,profile))}
#				khdwarfpbind = iup.hbox{iup.label{title="Dwarf",rastersize="50x"},(cbPowerBindBtn(nil,$SoD->{'Human'},"DwarfPBind",nil,150,nil,profile))}
#				local function humanpbindenable()
#					if $SoD->{'Human'}->{'Enable'} then
#						khhumanpbind.active = "YES"
#						khnovapbind.active = "YES"
#						khdwarfpbind.active = "YES"
#					else
#						khhumanpbind.active = "NO"
#						khnovapbind.active = "NO"
#						khdwarfpbind.active = "NO"
#					end
#				end
#				cbToolTip("Check this and choose a key if you want a separate key to enter human form, instead of toggling with Nova and Dwarf keys.")
#				khhumanbnd = cbCheckBind("Human Form Bind",$SoD->{'Human'},"ModeKey","Enable",nil,profile,nil,nil,nil,nil,humanpbindenable)
#				humanpbindenable()
#			end
#		
#			if $SoD->{'NonSoD'} and $SoD->{'Default'} ~= "NonSoD" then sodnonsodkeyhbox.active = "YES" else sodnonsodkeyhbox.active = "NO" end
#			if $SoD->{'Base'} and $SoD->{'Default'} ~= "Base" then sodbasekeyhbox.active = "YES" else sodbasekeyhbox.active = "NO" end
#			uiupdate = function()
#				#  enable all those bind boxes that aren't the new default.
#				jmpEnabled() #  these check for default status
#				flyEnabled()
#		# 		gflyEnabled()
#				if $SoD->{'NonSoD'} and $SoD->{'Default'} ~= "NonSoD" then sodnonsodkeyhbox.active = "YES" else sodnonsodkeyhbox.active = "NO" end
#				if $SoD->{'Base'} and $SoD->{'Default'} ~= "Base" then sodbasekeyhbox.active = "YES" else sodbasekeyhbox.active = "NO" end
#				if $SoD->{'SS'}->{'SS'} and $SoD->{'Default'} ~= "Run" then
#					sodrunmodehbox.active="YES"
#				else
#					sodrunmodehbox.active="NO"
#				end
#			end
#			
#			cbToolTip("Choose your Default Movement Mode")
#			local soddefaulthbox = cbListBox("Default Move Mode",{"Non-SoD","Sprint SoD","Super Speed","Super Jump","Flight"},5,sodConvertDefault[$SoD->{'Default'}],
#				sodConvertDefaultBack(profile,SoD,uiupdate),150,21,50)
#			
#			
#			#  Credits and Enable SoD Checkbox go in the same Hbox
#			local boxa = iup.vbox{credits,sodenable}
#			#  Movement Keys all go in a single frame titled Movement Keys
#			local boxb = iup.frame{iup.vbox{soduphbox,soddownhbox,sodforhbox,sodmousechord,sodbackhbox,sodlefthbox,sodrighthbox,sodtlefthbox,sodtrighthbox},
#				margin="0x0",Title="Movement Keys"}
#			#  General Movement Settings are in the next frame
#			# local boxc = iup.frame{iup.vbox{sodrunsechbox,sodunqueue,sodamlook,sodautorunhbox,sodfollowhbox,sodtogglehbox},
#			local boxc = iup.frame{iup.vbox{sodrunsechbox,soddefaulthbox,sodamlook,sodautorunhbox,sodfollowhbox,sodnonsodtgl,sodnonsodkeyhbox,sodbasetgl,sodbasekeyhbox},
#				margin="0x0",Title="General Settings"}
#			#  Detail Settings are placed in the next Frame
#			local boxd = iup.frame{iup.vbox{sodruncamdist,sodflycamdist,sodworlddetailnormal,sodworlddetailmoving,sodhidewindows,sodfeedback},
#				margin="0x0",Title="Detail Settings"}
#				
#			#  Next Column, first box is the Superspeed options
#			local boxe = iup.frame{iup.vbox{sodrunprimhbox,sodrunmodehbox,sodssmobileonly,sodsssjmode},margin="0x0",Title="Super Speed on Demand"}
#			#  Next is SuperJump Settings
#			local boxf = iup.frame{iup.vbox{sodhasjump,sodhascj,sodsimplejump,sodjmpmodehbox},margin="0x0",Title="Super Jump on Demand"}
#			#  Next is Flight stuff.  Only used by non warshades
#			local boxg
#			if profile.archetype == "Peacebringer" then
#				boxg = iup.frame{iup.vbox{sodhashover,sodflymodehbox,sodhasqflight,sodqflighthbox},margin="0x0",Title="Flight on Demand"}
#			elseif not (profile.archetype == "Warshade") then
#				boxg = iup.frame{iup.vbox{sodhashover,sodhasfly,sodflymodehbox},margin="0x0",Title="Flight on Demand"}
#			end
#			#  Next is the Teleport stuff
#			local boxh
#			if profile.archetype ~= "Warshade" and profile.archetype ~= "Peacebringer" then
#				boxh = iup.frame{iup.vbox{sodhastp,sodtpbind,sodtpcombo,sodtpreset,sodtphover},margin="0x0",
#					Title="Advanced Teleport Binds"}
#			else
#				boxh = iup.frame{iup.vbox{sodhastp,sodtpbind,sodtpcombo,sodtpreset},margin="0x0",
#					Title="Advanced Teleport Binds"}
#			end
#			#  Next is the Kheldian only Nova/Dwarf Toggles
#			local boxi = iup.frame{iup.vbox{khnovatgl,khnovabnd,khnovatray,khdwarftgl,khdwarfbnd,khdwarftray,khhumanpwr,khhumanbnd,
#				iup.label{title="Kheldian Form Powerbinds"},
#				khhumanpbind,khnovapbind,khdwarfpbind},margin="0x0",
#				Title="Nova/Dwarf Form Toggle Settings"}
#		
#			#  Third Column is for Team TP and Group Fly
#			# local boxj = iup.frame{iup.vbox{sodhasgfly,sodgflymodehbox},margin="0x0",Title="Group Fly Mode"}
#			local boxk = iup.frame{iup.vbox{sodhasttp,sodttpbind,sodttpcombo,sodttpreset},margin="0x0",
#				Title="Team Teleport Binds"}
#			local expimpbtn = cbImportExportButtons(profile,"SoD",module.bindsettings,100,nil,100)
#			
#			local boxt = iup.frame{iup.vbox{sodtempenable,sodtempmodehbox,sodtemptrayhbox,sodtemptrayswitchhbox},margin="0x0",Title="Temp Travel Power Mode"}
#		
#			local soddlg
#			if profile.archetype == "Peacebringer" then
#				soddlg = iup.dialog{iup.hbox{iup.fill{size="5"},iup.vbox{boxa,iup.fill{size="5"},boxb,iup.fill{size="5"},boxc,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxd,iup.fill{size="5"},boxe,iup.fill{size="5"},boxf,iup.fill{size="5"},boxg,iup.fill{size="5"},boxh,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxi,iup.fill{size="5"},boxt,iup.fill{size="5"},expimpbtn},iup.fill{size="5"}
#					},title = "Movement : Speed on Demand",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#			elseif profile.archetype == "Warshade" then
#				soddlg = iup.dialog{iup.hbox{iup.fill{size="5"},iup.vbox{boxa,iup.fill{size="5"},boxb,iup.fill{size="5"},boxc,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxd,iup.fill{size="5"},boxe,iup.fill{size="5"},boxf,iup.fill{size="5"},boxh,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxi,iup.fill{size="5"},boxt,iup.fill{size="5"},expimpbtn},iup.fill{size="5"}
#					},title = "Movement : Speed on Demand",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#			else
#				soddlg = iup.dialog{iup.hbox{iup.fill{size="5"},iup.vbox{boxa,iup.fill{size="5"},boxb,iup.fill{size="5"},boxc,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxd,iup.fill{size="5"},boxe,iup.fill{size="5"},boxf,iup.fill{size="5"},boxg,iup.fill{size="5"},boxh,iup.fill{size="5"}},iup.fill{size="5"},
#					iup.vbox{iup.fill{size="5"},boxk,boxt,iup.fill{size="5"},expimpbtn},iup.fill{size="5"}
#					},title = "Movement : Speed on Demand",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#			end
#			# soddlg.close_cb = function(self) $SoD->{'dialog'} = nil end
#			# soddlg:showxy(218,10)
#			uiupdate()
#			cbShowDialog(soddlg,218,10,profile,function(self) $SoD->{'dialog'} = nil end)
#			$SoD->{'dialog'} = soddlg
}


sub bindsettings {
	my $profile = shift;

	$profile->{'SoD'} ||= {

		Base => 1,
		Up => "SPACE",
		Down => "X",
		Forward => "W",
		Back => "S",
		Left => "A",
		Right => "D",
		RunModeKey => "C",
		FlyModeKey => "F",
		AutoRunKey => "R",
		FollowKey => "TILDE",
		Run => {
			Primary => "none",
			PrimaryNumber => 1,
			Secondary => "Sprint",
			SecondaryNumber => 1,
		},
		Fly => {
			Hover => undef,
			Fly => undef,
			GFly => undef,
		},
		Unqueue => true,
		AutoMouseLook => undef,
		ToggleKey => "LCTRL+M",
		enable => undef,
	};

	my $SoD = $profile->{'SoD'};

	if (not $SoD->{'Version'}) {
		$SoD->{'Version'} = 0.51;
		if ($SoD->{'Run'}->{'SecondaryNumber'} < 4) {
			$SoD->{'Run'}->{'SecondaryNumber'} = 1;
			$SoD->{'Run'}->{'Secondary'} = "Sprint";
		}
		if ($SoD->{'Run'}->{'SecondaryNumber'} > 3) {
			$SoD->{'Run'}->{'SecondaryNumber'} -= 2;
		}
	}
	if (not $SoD->{'Version'} or $SoD->{'Version'} < 0.51) {
		$SoD->{'Version'} = 0.51;
		$SoD->{'Base'} = 1;
	}
	# $SoD->{'MouseChord'} ||= undef;
	$SoD->{'JumpModeKey'} ||= "T";
	$SoD->{'GFlyModeKey'} ||= "G";
	$SoD->{'NonSoDModeKey'} ||= "UNBOUND";
	$SoD->{'BaseModeKey'} ||= "UNBOUND";
	$SoD->{'Default'} ||= "Base";
	$SoD->{'Jump'} ||= {};
	# $SoD->{'Run.UseCamdist'} ||= undef;
	$SoD->{'Run.Camdist'} ||= "15";
	# $SoD->{'Fly.UseCamdist'} ||= undef;
	$SoD->{'Fly.Camdist'} ||= "60";
	$SoD->{'SS'} ||= $SoD->{'SS'} or {};
	if (!$SoD->{'SS'}->{'SS'} and ($SoD->{'Run'}->{'PrimaryNumber'} == 2)) { $SoD->{'SS'}->{'SS'} = 1; }

	$SoD->{'TTP'} ||= {};
	$SoD->{'TTP'}->{'BindKey'} ||="LSHIFT+LBUTTON";
	$SoD->{'TTP'}->{'ComboKey'} ||="LSHIFT";
	$SoD->{'TTP'}->{'ResetKey'} ||="LCTRL+T";

	$SoD->{'TP'} ||= {};
	$SoD->{'TP'}->{'BindKey'} ||= "LSHIFT+LBUTTON";
	$SoD->{'TP'}->{'ComboKey'} ||= "LSHIFT";
	$SoD->{'TP'}->{'ResetKey'} ||= "LCTRL+T";

	if (!$SoD->{'Version'} or $SoD->{'Version'} < 0.71) {
		$SoD->{'TP'}->{'HideWindows'} = 1;
		$SoD->{'Version'} = 0.71
	}

	# $SoD->{'TP'}->{'TP'} ||= "Teleport";
	# $SoD->{'TP'}->{'Num'} ||= 1;

	$SoD->{'Nova'} ||= {};
	$SoD->{'Nova'}->{'ModeKey'} ||= "T";
	$SoD->{'Nova'}->{'PowerTray'} ||= "4";

	$SoD->{'Dwarf'} ||= {};
	$SoD->{'Dwarf'}->{'ModeKey'} ||= "G";
	$SoD->{'Dwarf'}->{'PowerTray'} ||= "5";

	if ($profile->{'archetype'} eq "Peacebringer") {
		$SoD->{'Nova'}->{'Nova'} = "Bright Nova";
		$SoD->{'Dwarf'}->{'Dwarf'} = "White Dwarf";
		$SoD->{'HumanFormShield'} ||= "Shining Shield";

	} elsif ($profile->{'archetype'} eq "Warshade") {
		$SoD->{'Nova'}->{'Nova'} = "Dark Nova";
		$SoD->{'Dwarf'}->{'Dwarf'} = "Black Dwarf";
		$SoD->{'HumanFormShield'} ||= "Gravity Shield";
	}

	$SoD->{'Human'} ||= {};
	$SoD->{'Human'}->{'ModeKey'} ||= "UNBOUND";
	$SoD->{'Human'}->{'HumanPBind'} ||= "nop";
	$SoD->{'Human'}->{'NovaPBind'} ||= "nop";
	$SoD->{'Human'}->{'DwarfPBind'} ||= "nop";

	$SoD->{'Detail'} ||= {};
	$SoD->{'Detail'}->{'NormalAmt'} ||= "1.0";
	$SoD->{'Detail'}->{'MovingAmt'} ||= "0.5";

	$SoD->{'DefaultMode'} ||= "Base";

	#  Temp Travel Powers
	$SoD->{'Temp'} ||= {};
	$SoD->{'Temp'}->{'Tray'} ||= "6";
	$SoD->{'Temp'}->{'TraySwitch'} ||= "UNBOUND";
	$SoD->{'TempModeKey'} ||= "UNBOUND";




	$SoD->{'dialog'} ||= makeSoDDialog();
	$SoD->{'dialog'}->show();
}

1;
__DATA__

#  toggleon variation
function actPower_toggle(start,unq,on,...)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff...
		traytest = on.trayslot
	end
	unq = nil
	local offpower = {}
	for i,v in ipairs(arg) do
		if type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and not (w == on) and not offpower[w] then
					if type(w) == "table" then
						if w.trayslot ~= traytest then
							s = s.."$$powexectray "..w.trayslot
							unq = true
						end
					else
						offpower[w] = true
						s = s.."$$powexectoggleoff "..w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s.."$$powexectray "..v.trayslot
				unq = true
			end
		else
			if not (v == "") and not (w == on) and not offpower[v] then
				offpower[v] = true
				s = s.."$$powexectoggleoff "..v
			end
		end
	end
	if unq and not (s == "") then
		s = s.."$$powexecunqueue"
	end
	# if start then s = string.sub(s,3,string.len(s)) end
	if on and not (on == "") then
		if type(on) == "table" then
			#  deal with power slot stuff...
			s = s.."$$powexectray "..on.trayslot.."$$powexectray "..on.trayslot
		else
			s = s.."$$powexectoggleon "..on
		end
	end
	return s
end

function actPower_name(start,unq,on,...)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff...
		traytest = on.trayslot
	end
	for i,v in ipairs(arg) do
		if type(v) == "string" then
			if not (v == "") and v ~= on then
				s = s.."$$powexecname "..v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w ~= on then
					if type(w) == "table" then
						if w.trayslot ~= traytest then
							s = s.."$$powexectray "..w.trayslot
						end
					else
						s = s.."$$powexecname "..w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s.."$$powexectray "..v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s.."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on ~= "" then
		if type(on) == "table" then
			#  deal with power slot stuff...
			s = s.."$$powexectray "..on.trayslot.."$$powexectray "..on.trayslot
		else
			s = s.."$$powexecname "..on.."$$powexecname "..on
		end
	end
	if start then s = string.sub(s,3,string.len(s)) end
	return s
end

#  updated hybrid binds can reduce the space used in SoD Bindfiles by more than 40KB per SoD mode generated
function actPower_hybrid(start,unq,on,...)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff...
		traytest = on.trayslot
	end
	for i,v in ipairs(arg) do
		if type(v) == "string" then
			if not (v == "") and v ~= on then
				s = s.."$$powexecname "..v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w ~= on then
					if type(w) == "table" then
						if w.trayslot ~= traytest then
							s = s.."$$powexectray "..w.trayslot
						end
					else
						s = s.."$$powexecname "..w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s.."$$powexectray "..v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s.."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on ~= "" then
		if type(on) == "table" then
			#  deal with power slot stuff...
			s = s.."$$powexectray "..on.trayslot.."$$powexectray "..on.trayslot
		else
			s = s.."$$powexectoggleon "..on
		end
	end
	if start then s = string.sub(s,3,string.len(s)) end
	return s
end

local actPower = actPower_name
# local actPower = actPower_toggle

function makeNonSoDModeKey(profile,t,bl,curfile,turnoff,fix,fb)
	local bindload
	local SoD = profile.SoD
	if not t.NonSoDModeKey then return end
	if t.NonSoDModeKey == "UNBOUND" then return end
	local feedback = ""
	if not fb and $SoD->{'Feedback'} then feedback="$$t $name, Non-SoD Mode" end
	t.ini = t.ini or ""
	if bl=="r" then
		bindload=t.bln..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		if fix then
			fix(profile,t,t.NonSoDModeKey,makeNonSoDModeKey,"n",bl,curfile,turnoff,"",feedback)
		else
			cbWriteBind(curfile,t.NonSoDModeKey,t.ini..actPower_toggle(nil,true,nil,turnoff)..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detailhi..t.runcamdist..feedback..bindload)
		end
	elseif bl=="ar" then
		bindload=t.blan..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		if fix then
			fix(profile,t,t.NonSoDModeKey,makeNonSoDModeKey,"n",bl,curfile,turnoff,"a",feedback)
		else
			cbWriteBind(curfile,t.NonSoDModeKey,t.ini..actPower_toggle(nil,true,nil,turnoff)..t.detailhi..t.runcamdist.."$$up 0"..t.dow..t.lef..t.rig..feedback..bindload)
		end
	else
		if fix then
			fix(profile,t,t.NonSoDModeKey,makeNonSoDModeKey,"n",bl,curfile,turnoff,"f",feedback)
		else
			cbWriteBind(curfile,t.NonSoDModeKey,t.ini..actPower_toggle(nil,true,nil,turnoff)..t.detailhi..t.runcamdist.."$$up 0"..feedback..t.blfn..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
		end
	end
	t.ini = ""
end

function makeTempModeKey(profile,t,bl,curfile,turnoff)
	local bindload
	local SoD = profile.SoD
	if not t.TempModeKey then return end
	if t.TempModeKey == "UNBOUND" then return end
	local feedback = ""
	if $SoD->{'Feedback'} then feedback="$$t $name, Temp Mode" end
	t.ini = t.ini or ""
	local trayslot = {trayslot = "1 "..$SoD->{'Temp'}->{'Tray'}}
	if bl=="r" then
		bindload=t.blt..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		cbWriteBind(curfile,t.TempModeKey,t.ini..actPower(nil,true,trayslot,turnoff)..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..bindload)
	elseif bl=="ar" then
		bindload=t.pathat..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		local bl2 = t.pathat..t.space..t.X..t.W..t.S..t.A..t.D.."_t.txt"
		local tglfile = cbOpen(bl2,"w")
		cbWriteToggleBind(curfile,tglfile,t.TempModeKey,t.ini..actPower(nil,true,trayslot,turnoff)..t.detaillo..t.flycamdist.."$$up 0"..t.dow..t.lef..t.rig,feedback,bindload,bl2)
		tglfile:close()
	else
		cbWriteBind(curfile,t.TempModeKey,t.ini..actPower(nil,true,trayslot,turnoff)..t.detaillo..t.flycamdist.."$$up 0"..feedback..t.blft..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
	end
	t.ini = ""
end

function makeQFlyModeKey(profile,t,bl,curfile,turnoff,modestr)
	local bindload
	local SoD = profile.SoD
	if not t.QFlyModeKey then return end
	if t.QFlyModeKey == "UNBOUND" then return end
	if modestr == "NonSoD" then cbWriteBind(curfile,t.QFlyModeKey,"powexecname Quantum Flight") return end
	local feedback = ""
	if $SoD->{'Feedback'} then feedback="$$t $name, QFlight Mode" end
	t.ini = t.ini or ""
	if bl=="r" then
		bindload=t.pathn..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		local bl2 = t.pathn..t.space..t.X..t.W..t.S..t.A..t.D.."_q.txt"
		local tglfile = cbOpen(bl2,"w")
		local tray = ""
		if (modestr == "Nova") or (modestr == "Dwarf") then tray = "$$gototray 1" end
		cbWriteToggleBind(curfile,tglfile,t.QFlyModeKey,t.ini..actPower_toggle(nil,true,"Quantum Flight",turnoff)..tray..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist,feedback,bindload,bl2)
		tglfile:close()
	elseif bl=="ar" then
		bindload=t.pathan..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		local bl2 = t.pathan..t.space..t.X..t.W..t.S..t.A..t.D.."_q.txt"
		local tglfile = cbOpen(bl2,"w")
		cbWriteToggleBind(curfile,tglfile,t.QFlyModeKey,t.ini..actPower_toggle(nil,true,"Quantum Flight",turnoff)..t.detaillo..t.flycamdist.."$$up 0"..t.dow..t.lef..t.rig,feedback,bindload,bl2)
		tglfile:close()
	else
		# bindload=t.pathfn..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		# local bl2 = t.pathfn..t.space..t.X..t.W..t.S..t.A..t.D.."_q.txt"
		# local tglfile = cbOpen(bl2,"w")
		cbWriteBind(curfile,t.QFlyModeKey,t.ini..actPower_toggle(nil,true,"Quantum Flight",turnoff)..t.detaillo..t.flycamdist.."$$up 0"..feedback..t.blfn..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
		# tglfile:close()
	end
	t.ini = ""
end

function makeBaseModeKey(profile,t,bl,curfile,turnoff,fix,fb)
	local bindload
	local SoD = profile.SoD
	if not t.BaseModeKey then return end
	if t.BaseModeKey == "UNBOUND" then return end
	local feedback = ""
	if not fb and $SoD->{'Feedback'} then feedback="$$t $name, Sprint-SoD Mode" end
	t.ini = t.ini or ""
	if bl=="r" then
		bindload=t.bl..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		local turnon
		# if t.horizkeys > 0 then turnon = "+down"..string.sub(t.on,3,string.len(t.on))..t.sprint..turnoff else turnon = "+down" end
		if t.horizkeys > 0 then turnon = actPower_toggle(true,true,t.sprint,turnoff) else turnon = actPower_toggle(true,true,nil,turnoff) end
		if fix then
			fix(profile,t,t.BaseModeKey,makeBaseModeKey,"r",bl,curfile,turnoff,"",feedback)
		else
			cbWriteBind(curfile,t.BaseModeKey,t.ini..turnon..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detailhi..t.runcamdist..feedback..bindload)
		end
	elseif bl=="ar" then
		bindload=t.blgr..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
		if fix then
			fix(profile,t,t.BaseModeKey,makeBaseModeKey,"r",bl,curfile,turnoff,"a",feedback)
		else
			cbWriteBind(curfile,t.BaseModeKey,t.ini..actPower_toggle(true,true,t.sprint,turnoff)..t.detailhi..t.runcamdist.."$$up 0"..t.dow..t.lef..t.rig..feedback..bindload)
		end
	else
		if fix then
			fix(profile,t,t.BaseModeKey,makeBaseModeKey,"r",bl,curfile,turnoff,"f",feedback)
		else
			cbWriteBind(curfile,t.BaseModeKey,t.ini..actPower_toggle(true,true,t.sprint,turnoff)..t.detailhi..t.runcamdist.."$$up 0"..feedback..t.blfr..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
		end
	end
	t.ini = ""
end

function makeSpeedModeKey(profile,t,bl,curfile,turnoff,fix,fb)
	local bindload
	local SoD = profile.SoD
	local feedback = ""
	if not fb and $SoD->{'Feedback'} then feedback="$$t $name, Superspeed Mode" end
	t.ini = t.ini or ""
	if t.canss > 0 then
		if bl=="s" then
			bindload=t.bls..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.RunModeKey,makeSpeedModeKey,"s",bl,curfile,turnoff,"",feedback)
			else
				cbWriteBind(curfile,t.RunModeKey,t.ini..actPower_toggle(true,true,t.speed,turnoff)..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..bindload)
			end
		elseif bl=="as" then
			bindload=t.blas..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.RunModeKey,makeSpeedModeKey,"s",bl,curfile,turnoff,"a",feedback)
			elseif feedback == "" then
				cbWriteBind(curfile,t.RunModeKey,t.ini..actPower_toggle(true,true,t.speed,turnoff)..t.up..t.dow..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..bindload)
			else
				bindload=t.pathas..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
				local bl2=t.pathas..t.space..t.X..t.W..t.S..t.A..t.D.."_s.txt"
				local tglfile = cbOpen(bl2,"w")
				cbWriteToggleBind(curfile,tglfile,t.RunModeKey,t.ini..actPower_toggle(true,true,t.speed,turnoff)..t.up..t.dow..t.lef..t.rig..t.detaillo..t.flycamdist,feedback,bindload,bl2)
				tglfile:close()
			end
		else
			if fix then
				fix(profile,t,t.RunModeKey,makeSpeedModeKey,"s",bl,curfile,turnoff,"f",feedback)
			else
				cbWriteBind(curfile,t.RunModeKey,t.ini..actPower_toggle(true,true,t.speed,turnoff)..'$$up 0'..t.detaillo..t.flycamdist..feedback..t.blfs..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
			end
		end
	end
	t.ini = ""
end

function makeJumpModeKey(profile,t,bl,curfile,turnoff,fbl)
	local bindload, filename, tglfile
	local SoD = profile.SoD
	if t.canjmp > 0 and not $SoD->{'Jump'}->{'Simple'} then
		local feedback = ""
		if $SoD->{'Feedback'} then feedback="$$t $name, Superjump Mode" end
		if bl=="j" then
			bindload=t.blj..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			local a
			if (t.horizkeys+t.space)>0 then a = actPower(nil,true,t.jump,turnoff).."$$up 1" else a = actPower(nil,true,t.cjmp,turnoff) end
			filename = fbl..t.space..t.X..t.W..t.S..t.A..t.D.."j.txt"
			tglfile = cbOpen(filename,"w")
			cbWriteBind(tglfile,t.JumpModeKey,'-down'..a..t.detaillo..t.flycamdist..bindload)
			tglfile:close()
			cbWriteBind(curfile,t.JumpModeKey,'+down'..feedback..'$$bindloadfile '..filename)
		elseif bl=="aj" then
			bindload=t.blaj..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			filename = fbl..t.space..t.X..t.W..t.S..t.A..t.D.."j.txt"
			tglfile = cbOpen(filename,"w")
			cbWriteBind(tglfile,t.JumpModeKey,'-down'..actPower(nil,true,t.jump,turnoff).."$$up 1"..t.detaillo..t.flycamdist..t.dow..t.lef..t.rig..bindload)
			tglfile:close()
			cbWriteBind(curfile,t.JumpModeKey,'+down'..feedback..'$$bindloadfile '..filename)
		else
			filename = fbl..t.space..t.X..t.W..t.S..t.A..t.D.."j.txt"
			tglfile = cbOpen(filename,"w")
			cbWriteBind(tglfile,t.JumpModeKey,'-down'..actPower(nil,true,t.jump,turnoff).."$$up 1"..t.detaillo..t.flycamdist..t.blfj..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
			tglfile:close()
			cbWriteBind(curfile,t.JumpModeKey,'+down'..feedback..'$$bindloadfile '..filename)
		end
	end
end

function makeFlyModeKey(profile,t,bl,curfile,turnoff,fix,fb,fb_on_a)
	local bindload, turnon
	if not t.FlyModeKey then error("invalid Fly Mode Key",2) end
	local SoD = profile.SoD
	local feedback = ""
	if not fb and $SoD->{'Feedback'} then feedback="$$t $name, Flight Mode" end
	t.ini = t.ini or ""
	if t.canhov+t.canfly > 0 then
		if bl=="bo" then
			bindload=t.blbo..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.FlyModeKey,makeFlyModeKey,"f",bl,curfile,turnoff,"",feedback)
			else
				cbWriteBind(curfile,t.FlyModeKey,"+down$$"..actPower_toggle(true,true,t.flyx,turnoff).."$$up 1$$down 0"..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..bindload)
			end
		elseif bl=="a" then
			if not fb_on_a then feedback = "" end
			bindload=t.bla..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if t.tkeys==0 then turnon=t.hover else turnon=t.flyx end
			if fix then
				fix(profile,t,t.FlyModeKey,makeFlyModeKey,"f",bl,curfile,turnoff,"",feedback)
			else
				cbWriteBind(curfile,t.FlyModeKey,t.ini..actPower_toggle(true,true,turnon,turnoff)..t.up..t.dow..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..bindload)
			end
		elseif bl=="af" then
			bindload=t.blaf..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.FlyModeKey,makeFlyModeKey,"f",bl,curfile,turnoff,"a",feedback)
			else
				cbWriteBind(curfile,t.FlyModeKey,t.ini..actPower_toggle(true,true,t.flyx,turnoff)..t.detaillo..t.flycamdist..t.dow..t.lef..t.rig..feedback..bindload)
			end
		else
			if fix then
				fix(profile,t,t.FlyModeKey,makeFlyModeKey,"f",bl,curfile,turnoff,"f",feedback)
			else
				cbWriteBind(curfile,t.FlyModeKey,t.ini..actPower_toggle(true,true,t.flyx,turnoff)..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist..feedback..t.blff..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
			end
		end
	end
	t.ini = ""
end

function makeGFlyModeKey(profile,t,bl,curfile,turnoff,fix)
	local bindload
	local SoD = profile.SoD
	t.ini = t.ini or ""
	if t.cangfly > 0 then
		if bl=="gbo" then
			bindload=t.blgbo..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.GFlyModeKey,makeGFlyModeKey,"gf",bl,curfile,turnoff,"")
			else
				cbWriteBind(curfile,t.GFlyModeKey,t.ini..'$$up 1$$down 0'..actPower_toggle(nil,true,t.gfly,turnoff)..t.forw..t.bac..t.lef..t.rig..t.detaillo..t.flycamdist..bindload)
			end
		elseif bl=="gaf" then
			bindload=t.blgaf..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
			if fix then
				fix(profile,t,t.GFlyModeKey,makeGFlyModeKey,"gf",bl,curfile,turnoff,"a")
			else
				cbWriteBind(curfile,t.GFlyModeKey,t.ini..t.detaillo..t.flycamdist..t.up..t.dow..t.lef..t.rig..bindload)
			end
		else
			if fix then
				fix(profile,t,t.GFlyModeKey,makeGFlyModeKey,"gf",bl,curfile,turnoff,"f")
			else
				if bl == "gf" then
					cbWriteBind(curfile,t.GFlyModeKey,t.ini..actPower_toggle(true,true,t.gfly,turnoff)..t.detaillo..t.flycamdist..t.blgff..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
				else
					cbWriteBind(curfile,t.GFlyModeKey,t.ini..t.detaillo..t.flycamdist..t.blgff..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
				end
			end
		end
	end
	t.ini = ""
end

function sodJumpFix(profile,t,key,makeModeKey,suffix,bl,curfile,turnoff,autofollowmode,feedback)
	local filename=t["path"..autofollowmode.."j"]..t.space..t.X..t.W..t.S..t.A..t.D..suffix..".txt"
	local tglfile = cbOpen(filename,"w")
	t.ini = "-down$$"
	makeModeKey(profile,t,bl,tglfile,turnoff,nil,true)
	tglfile:close()
	cbWriteBind(curfile,key,"+down"..feedback..actPower(nil,true,t.cjmp)..'$$bindloadfile '..filename)
end

function sodSetDownFix(profile,t,key,makeModeKey,suffix,bl,curfile,turnoff,autofollowmode,feedback)
	local pathsuffix = "f"
	if autofollowmode == "" then pathsuffix = "a" end
	# iup.Message("",tostring(t.space)..tostring(t.X)..tostring(t.W)..tostring(t.S)..tostring(t.A)..tostring(t.D)..tostring("path"..autofollowmode..pathsuffix)..tostring(suffix))
	local filename=t["path"..autofollowmode..pathsuffix]..t.space..t.X..t.W..t.S..t.A..t.D..suffix..".txt"
	local tglfile = cbOpen(filename,"w")
	t.ini = "-down$$"
	makeModeKey(profile,t,bl,tglfile,turnoff,nil,true)
	tglfile:close()
	cbWriteBind(curfile,key,'+down'..feedback..'$$bindloadfile '..filename)
end

function sodResetKey(curfile,profile,path,turnoff,moddir)
	if not moddir then
		cbWriteBind(curfile,profile.ResetKey,'up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'..turnoff..'$$t $name, SoD Binds Reset'..cbGetBaseReset(profile)..'$$bindloadfile '..path..'000000.txt')
	elseif moddir == "up" then
		cbWriteBind(curfile,profile.ResetKey,'up 1$$down 0$$forward 0$$backward 0$$left 0$$right 0'..turnoff..'$$t $name, SoD Binds Reset'..cbGetBaseReset(profile)..'$$bindloadfile '..path..'000000.txt')
	elseif moddir == "down" then
		cbWriteBind(curfile,profile.ResetKey,'up 0$$down 1$$forward 0$$backward 0$$left 0$$right 0'..turnoff..'$$t $name, SoD Binds Reset'..cbGetBaseReset(profile)..'$$bindloadfile '..path..'000000.txt')
	end
end

function sodDefaultResetKey(mobile,stationary)
	cbAddReset('up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'..actPower(nil,true,stationary,mobile)..'$$t $name, SoD Binds Reset')
end

function sodUpKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml# , aj
	local upx, dow, forw, bac, lef, rig = t.upx, t.dow, t.forw, t.bac, t.lef, t.rig
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if not flight and not sssj then mobile = nil stationary = nil end
	if bo == "bo" then upx = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then upx = "$$up 0" dow = "$$down 1" end
	
	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = t.jkeys
		if t.tkeys == 1 and t.space == 1 then upx="$$up 0" else upx="$$up 1" end
		if t.X == 1 then upx="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if t.tkeys == 1 and t.space == 1 then
		ml = t.mloff
		if not stationary and mobile ~= stationary  then
			toggleoff = mobile
		end
		toggleon = stationary
	else
		toggleoff = nil
	end
	
	local toggleoff2 = nil
	if sssj then
		if t.space == 0 then #  if we are hitting the space bar rather than releasing its...
			toggleon = sssj
			toggleoff = mobile
			if stationary and stationary ~= mobile then
				toggleoff2 = stationary
			end
		elseif t.space == 1 then #  if we are releasing the space bar ...
			toggleoff = sssj
			if t.horizkeys > 0 or autorun then #  and we are moving laterally, or in autorun...
				toggleon = mobile
			else #  otherwise turn on the stationary power...
				toggleon = stationary
			end
		end
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff,toggleoff2)
	end

	bindload = bl..(1-t.space)..t.X..t.W..t.S..t.A..t.D..".txt"
	ml = ml or ""
	
	local ini = "+down"
	if t.space == 1 then
		ini = "-down"
	end

	if followbl then
		local move
		if t.space==1 then
			move = ""
		else
			bindload = followbl..(1-t.space)..t.X..t.W..t.S..t.A..t.D..".txt"
			move = upx..dow..forw..bac..lef..rig
		end
		cbWriteBind(curfile,$SoD->{'Up'},ini..move..bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Up'},ini..upx..dow..forw..bac..lef..rig..ml..toggle..bindload)
	else
		if not sssj then toggle = "" end #  returns the following line to the way it was before sssj
		cbWriteBind(curfile,$SoD->{'Up'},ini..upx..dow.."$$backward 0"..lef..rig..toggle..t.mlon..bindload)
	end
end

function sodDownKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml# , aj
	local up, dowx, forw, bac, lef, rig = t.up, t.dowx, t.forw, t.bac, t.lef, t.rig
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if not flight then mobile = nil stationary = nil end
	if bo == "bo" then up = "$$up 1" dowx = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dowx = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dowx = "$$down 0"
		# if t.cancj == 1 then aj=t.cjmp end
		# if t.canjmp == 1 then aj=t.jump end
		actkeys = t.jkeys
		if t.X == 1 and t.tkeys > 1 then up="$$up 1" else up="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if t.tkeys == 1 and t.X == 1 then
		ml = t.mloff
		if not stationary and mobile ~= stationary  then
			toggleoff = mobile
		end
		toggleon = stationary
	else
		toggleoff = nil
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl..t.space..(1-t.X)..t.W..t.S..t.A..t.D..".txt"
	ml = ml or ""

	local ini = "+down"
	if t.X == 1 then
		ini = "-down"
	end

	if followbl then
		local move
		if t.X==1 then
			move = ""
		else
			bindload = followbl..t.space.."1"..t.W..t.S..t.A..t.D..".txt"
			move = up..dowx..forw..bac..lef..rig
		end
		cbWriteBind(curfile,$SoD->{'Down'},ini..move..bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Down'},ini..up..dowx..forw..bac..lef..rig..ml..toggle..bindload)
	else
		cbWriteBind(curfile,$SoD->{'Down'},ini..up..dowx.."$$backward 0"..lef..rig..t.mlon..bindload)
	end
end

function sodForwardKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,sssj)
	local ml
	local up, dow, forx, bac, lef, rig = t.up, t.dow, t.forx, t.bac, t.lef, t.rig
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = t.jkeys
		if t.tkeys == 1 and t.W == 1 then up="$$up 0" else up="$$up 1" end
		if t.X == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if t.tkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if t.tkeys == 1 and t.W == 1 then
		ml = t.mloff
	end
		
	if not flight then
		if t.horizkeys == 1 and t.W == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if t.tkeys == 1 and t.W == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and t.space == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl..t.space..t.X..(1-t.W)..t.S..t.A..t.D..".txt"
	ml = ml or ""

	local ini = "+down"
	if t.W == 1 then
		ini = "-down"
	end

	if followbl then
		if t.W==1 then
			move = ini
		else
			bindload=followbl..t.space..t.X..(1-t.W)..t.S..t.A..t.D..".txt"
			move = ini..up..dow..forx..bac..lef..rig
		end
		cbWriteBind(curfile,$SoD->{'Forward'},move..bindload)
		if $SoD->{'MouseChord'} then
			if t.W~=1 then move = ini..up..dow..forx..bac..rig..lef end
			cbWriteBind(curfile,'mousechord',move..bindload)
		end
	elseif not autorunbl then
		cbWriteBind(curfile,$SoD->{'Forward'},ini..up..dow..forx..bac..lef..rig..ml..toggle..bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini..up..dow..forx..bac..rig..lef..ml..toggle..bindload)
		end
	else
		if t.W ~= 1 then
			bindload = autorunbl..t.space..t.X..(1-t.W)..t.S..t.A..t.D..".txt"
		end
		cbWriteBind(curfile,$SoD->{'Forward'},ini..up..dow..'$$forward 1$$backward 0'..lef..rig..t.mlon..bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini..up..dow..'$$forward 1$$backward 0'..rig..lef..t.mlon..bindload)
		end
	end
end

function sodBackKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,sssj)
	local ml
	local up, dow, forw, bacx, lef, rig = t.up, t.dow, t.forw, t.bacx, t.lef, t.rig
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = t.jkeys
		if t.tkeys == 1 and t.S == 1 then up="$$up 0" else up="$$up 1" end
		if t.X == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if t.tkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if t.tkeys == 1 and t.S == 1 then
		ml = t.mloff
	end
		
	if not flight then
		if t.horizkeys == 1 and t.S == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if t.tkeys == 1 and t.S == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and t.space == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl..t.space..t.X..t.W..(1-t.S)..t.A..t.D..".txt"
	ml = ml or ""

	local ini = "+down"
	if t.S == 1 then
		ini = "-down"
	end

	if followbl then
		if t.S==1 then
			move = ini
		else
			bindload=followbl..t.space..t.X..t.W..(1-t.S)..t.A..t.D..".txt"
			move = ini..up..dow..forw..bacx..lef..rig
		end
		cbWriteBind(curfile,$SoD->{'Back'},move..bindload)
	elseif not autorunbl then
		cbWriteBind(curfile,$SoD->{'Back'},ini..up..dow..forw..bacx..lef..rig..ml..toggle..bindload)
	else
		local move
		if t.S==1 then
			move = "$$forward 1$$backward 0"
		else
			move = "$$forward 0$$backward 1"
			bindload=autorunbl..t.space..t.X..t.W..(1-t.S)..t.A..t.D..".txt"
		end
		cbWriteBind(curfile,$SoD->{'Back'},ini..up..dow..move..lef..rig..t.mlon..bindload)
	end
end

function sodLeftKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml
	local up, dow, forw, bac, lefx, rig = t.up, t.dow, t.forw, t.bac, t.lefx, t.rig
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = t.jkeys
		if t.tkeys == 1 and t.A == 1 then up="$$up 0" else up="$$up 1" end
		if t.X == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if t.tkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if t.tkeys == 1 and t.A == 1 then
		ml = t.mloff
	end
		
	if not flight then
		if t.horizkeys == 1 and t.A == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if t.tkeys == 1 and t.A == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and t.space == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl..t.space..t.X..t.W..t.S..(1-t.A)..t.D..".txt"
	ml = ml or ""

	local ini = "+down"
	if t.A == 1 then
		ini = "-down"
	end

	if followbl then
		if t.A==1 then
			move = ini
		else
			bindload=followbl..t.space..t.X..t.W..t.S..(1-t.A)..t.D..".txt"
			move = ini..up..dow..forw..bac..lefx..rig
		end
		cbWriteBind(curfile,$SoD->{'Left'},move..bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Left'},ini..up..dow..forw..bac..lefx..rig..ml..toggle..bindload)
	else
		cbWriteBind(curfile,$SoD->{'Left'},ini..up..dow.."$$backward 0"..lefx..rig..t.mlon..bindload)
	end
end

function sodRightKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml
	local up, dow, forw, bac, lef, rigx = t.up, t.dow, t.forw, t.bac, t.lef, t.rigx
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = t.tkeys
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = t.jkeys
		if t.tkeys == 1 and t.D == 1 then up="$$up 0" else up="$$up 1" end
		if t.X == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if t.tkeys == 0 then
		ml = t.mlon
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if t.tkeys == 1 and t.D == 1 then
		ml = t.mloff
	end
		
	if not flight then
		if t.horizkeys == 1 and t.D == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if t.tkeys == 1 and t.D == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and t.space == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl..t.space..t.X..t.W..t.S..t.A..(1-t.D)..".txt"
	ml = ml or ""

	local ini = "+down"
	if t.D == 1 then
		ini = "-down"
	end

	if followbl then
		if t.D==1 then
			move = ini
		else
			bindload=followbl..t.space..t.X..t.W..t.S..t.A..(1-t.D)..".txt"
			move = ini..up..dow..forw..bac..lef..rigx
		end
		cbWriteBind(curfile,$SoD->{'Right'},move..bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Right'},ini..up..dow..forw..bac..lef..rigx..ml..toggle..bindload)
	else
		cbWriteBind(curfile,$SoD->{'Right'},ini..up..dow.."$$forward 1$$backward 0"..lef..rigx..t.mlon..bindload)
	end
end

function sodAutoRunKey(t,bl,curfile,SoD,mobile,sssj)
	local bindload
	bindload = bl..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
	if sssj and t.space == 1 then
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'..t.up..t.dow..t.lef..t.rig..t.mlon..actPower(nil,true,sssj,mobile)..bindload)
	else
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'..t.up..t.dow..t.lef..t.rig..t.mlon..actPower(nil,true,mobile)..bindload)
	end
end

function sodAutoRunOffKey(t,bl,curfile,SoD,mobile,stationary,flight,sssj)
	local toggleon=""
	local toggleoff
	if sssj and t.space == 1 then toggleoff = mobile mobile = sssj end
	if not flight and not sssj then
		if t.horizkeys > 0 then
			toggleon=t.mlon..actPower(nil,true,mobile)
		else
			toggleon=t.mloff..actPower(nil,true,stationary,mobile)
		end
	elseif sssj then
		if t.horizkeys > 0 or t.space == 1 then
			toggleon=t.mlon..actPower(nil,true,mobile,toggleoff)
		else
			toggleon=t.mloff..actPower(nil,true,stationary,mobile,toggleoff)
		end
	else
		if t.tkeys > 0 then
			toggleon=t.mlon..actPower(nil,true,mobile)
		else
			toggleon=t.mloff..actPower(nil,true,stationary,mobile)
		end
	end
	bindload=bl..t.space..t.X..t.W..t.S..t.A..t.D..".txt"
	cbWriteBind(curfile,$SoD->{'AutoRunKey'},t.up..t.dow..t.forw..t.bac..t.lef..t.rig..toggleon..bindload)
end

function sodFollowKey(t,bl,curfile,SoD,mobile)
	cbWriteBind(curfile,$SoD->{'FollowKey'},'follow'..actPower(nil,true,mobile)..bl..t.space..t.X..t.W..t.S..t.A..t.D..'.txt')
end

function sodFollowOffKey(t,bl,curfile,SoD,mobile,stationary,flight)
	local toggle = ""
	if not flight then
		if t.horizkeys==0 then
			if stationary ~= mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	else
		if t.tkeys==0 then
			if stationary ~= mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	end
	cbWriteBind(curfile,$SoD->{'FollowKey'},"follow"..toggle..t.up..t.dow..t.forw..t.bac..t.lef..t.rig..bl..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
end

function makeSoDFile(profile,t,bl,bla,blf,path,patha,pathf,mobile,stationary,modestr,flight,fix,turnoff,pathbo,pathsd,blbo,blsd,sssj)
	if modestr == "QFly" then return end
	local SoD = profile.SoD
	local curfile
	turnoff = turnoff or {mobile,stationary}
	if ($SoD->{'Default'} == modestr) and (t.tkeys == 0) then
		curfile = profile.resetfile
		sodDefaultResetKey(mobile,stationary)

		sodUpKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodDownKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodForwardKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodBackKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodLeftKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodRightKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)

		if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"r",curfile,{mobile,stationary}) end
		if modestr ~= "Base" then makeBaseModeKey(profile,t,"r",curfile,turnoff,fix) end
		if modestr ~= "Fly" then makeFlyModeKey(profile,t,"bo",curfile,turnoff,fix) end
		# if modestr ~= "GFly" then makeGFlyModeKey(profile,t,"gf",curfile,turnoff,fix) end
		if modestr ~= "Run" then makeSpeedModeKey(profile,t,"s",curfile,turnoff,fix) end
		if modestr ~= "Jump" then makeJumpModeKey(profile,t,"j",curfile,turnoff,path) end
		if modestr ~= "Temp" then makeTempModeKey(profile,t,"r",curfile,turnoff,path) end
		if modestr ~= "QFly" then makeQFlyModeKey(profile,t,"r",curfile,turnoff,modestr) end
	
		sodAutoRunKey(t,bla,curfile,SoD,mobile,sssj)
	
		sodFollowKey(t,blf,curfile,SoD,mobile)
	end
	if (flight == "Fly") and pathbo then
		#  blast off
		curfile = cbOpen(pathbo..t.space..t.X..t.W..t.S..t.A..t.D..".txt","w")

		sodResetKey(curfile,profile,path,actPower_toggle(nil,true,stationary,mobile))

			sodUpKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)
			sodDownKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)
			sodForwardKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)
			sodBackKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)
			sodLeftKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)
			sodRightKey(t,blbo,curfile,SoD,mobile,stationary,flight,nil,nil,"bo",sssj)

			# if modestr ~= "Base" then makeBaseModeKey(profile,t,"r",curfile,turnoff,fix) end
			t.ini = "-down$$"
			if $SoD->{'Default'} == "Fly" then
				local oldflymodekey = t.FlyModeKey
				if $SoD->{'NonSoD'} then
					t.FlyModeKey = t.NonSoDModeKey
					makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
				end
				if $SoD->{'Base'} then
					t.FlyModeKey = t.BaseModeKey
					makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
				end
				if t.canss then
					t.FlyModeKey = t.RunModeKey
					makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
				end
				if t.canjmp then
					t.FlyModeKey = t.JumpModeKey
					makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
				end
				if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
					t.FlyModeKey = t.TempModeKey
					makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
				end
			else
				makeFlyModeKey(profile,t,"a",curfile,turnoff,fix)
			end
			t.ini = ""
			# if modestr ~= "GFly" then makeGFlyModeKey(profile,t,"gbo",curfile,turnoff,fix) end
			# if modestr ~= "Run" then makeSpeedModeKey(profile,t,"s",curfile,turnoff,fix) end
			# if modestr ~= "Jump" then makeJumpModeKey(profile,t,"j",curfile,turnoff,path) end
	
			sodAutoRunKey(t,bla,curfile,SoD,mobile,sssj)
	
			sodFollowKey(t,blf,curfile,SoD,mobile)

		curfile:close()
		# [[curfile = cbOpen(pathsd..t.space..t.X..t.W..t.S..t.A..t.D..".txt","w")

			sodResetKey(curfile,profile,path,actPower_toggle(nil,true,stationary,mobile))

			sodUpKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)
			sodDownKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)
			sodForwardKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)
			sodBackKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)
			sodLeftKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)
			sodRightKey(t,blsd,curfile,SoD,mobile,stationary,flight,nil,nil,"sd",sssj)

			t.ini = "-down$$"
			# if modestr ~= "Base" then makeBaseModeKey(profile,t,"r",curfile,turnoff,fix) end
			# if modestr ~= "Fly" then makeFlyModeKey(profile,t,"a",curfile,turnoff,fix) end
			# if modestr ~= "GFly" then makeGFlyModeKey(profile,t,"gbo",curfile,turnoff,fix) end
			t.ini = ""
			# if modestr ~= "Jump" then makeJumpModeKey(profile,t,"j",curfile,turnoff,path) end
	
			sodAutoRunKey(t,bla,curfile,SoD,mobile,sssj)
	
			sodFollowKey(t,blf,curfile,SoD,mobile)

		curfile:close()# ]]
		#  set down
	end
	curfile = cbOpen(path..t.space..t.X..t.W..t.S..t.A..t.D..".txt","w")

		sodResetKey(curfile,profile,path,actPower_toggle(nil,true,stationary,mobile))

		sodUpKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodDownKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodForwardKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodBackKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodLeftKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)
		sodRightKey(t,bl,curfile,SoD,mobile,stationary,flight,nil,nil,nil,sssj)

		if (flight == "Fly") and pathbo then
			#  Base to set down
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"r",curfile,{mobile,stationary},sodSetDownFix) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"r",curfile,turnoff,sodSetDownFix) end
			# if t.BaseModeKey then
				# cbWriteBind(curfile,t.BaseModeKey,"+down$$down 1"..actPower(nil,true,mobile)..t.detailhi..t.runcamdist..t.blsd..t.space..t.X..t.W..t.S..t.A..t.D..".txt")
			# end
			if Modestr ~= "Run" then makeSpeedModeKey(profile,t,"s",curfile,turnoff,sodSetDownFix) end
			if modestr ~= "Fly" then makeFlyModeKey(profile,t,"bo",curfile,turnoff,fix) end
			if modestr ~= "Jump" then makeJumpModeKey(profile,t,"j",curfile,turnoff,path) end
			if modestr ~= "Temp" then makeTempModeKey(profile,t,"r",curfile,turnoff,path) end
			if modestr ~= "QFly" then makeQFlyModeKey(profile,t,"r",curfile,turnoff,modestr) end
		else
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"r",curfile,{mobile,stationary}) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"r",curfile,turnoff,fix) end
			if flight == "Jump" then
				if modestr ~= "Fly" then makeFlyModeKey(profile,t,"a",curfile,turnoff,fix,nil,true) end
			else
				if modestr ~= "Fly" then makeFlyModeKey(profile,t,"bo",curfile,turnoff,fix) end
			end
			if modestr ~= "Run" then makeSpeedModeKey(profile,t,"s",curfile,turnoff,fix) end
			if modestr ~= "Jump" then makeJumpModeKey(profile,t,"j",curfile,turnoff,path) end
			if modestr ~= "Temp" then makeTempModeKey(profile,t,"r",curfile,turnoff,path) end
			if modestr ~= "QFly" then makeQFlyModeKey(profile,t,"r",curfile,turnoff,modestr) end
		end
	
		sodAutoRunKey(t,bla,curfile,SoD,mobile,sssj)
	
		sodFollowKey(t,blf,curfile,SoD,mobile)

	curfile:close()

# AutoRun Binds
	curfile = cbOpen(patha..t.space..t.X..t.W..t.S..t.A..t.D..".txt","w")
	
		sodResetKey(curfile,profile,path,actPower_toggle(nil,true,stationary,mobile))
	
		sodUpKey(t,bla,curfile,SoD,mobile,stationary,flight,true,nil,nil,sssj)
		sodDownKey(t,bla,curfile,SoD,mobile,stationary,flight,true,nil,nil,sssj)
		sodForwardKey(t,bla,curfile,SoD,mobile,stationary,flight,bl,nil,nil,sssj)
		sodBackKey(t,bla,curfile,SoD,mobile,stationary,flight,bl,nil,nil,sssj)
		sodLeftKey(t,bla,curfile,SoD,mobile,stationary,flight,true,nil,nil,sssj)
		sodRightKey(t,bla,curfile,SoD,mobile,stationary,flight,true,nil,nil,sssj)

		if (flight == "Fly") and pathbo then
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"ar",curfile,{mobile,stationary},sodSetDownFix) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"gr",curfile,turnoff,sodSetDownFix) end
			if modestr ~= "Run" then makeSpeedModeKey(profile,t,"as",curfile,turnoff,sodSetDownFix) end
		else
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"ar",curfile,{mobile,stationary}) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"gr",curfile,turnoff,fix) end
			if modestr ~= "Run" then makeSpeedModeKey(profile,t,"as",curfile,turnoff,fix) end
		end
		if modestr ~= "Fly" then makeFlyModeKey(profile,t,"af",curfile,turnoff,fix) end
		if modestr ~= "Jump" then makeJumpModeKey(profile,t,"aj",curfile,turnoff,patha) end
		if modestr ~= "Temp" then makeTempModeKey(profile,t,"ar",curfile,turnoff,path) end
		if modestr ~= "QFly" then makeQFlyModeKey(profile,t,"ar",curfile,turnoff,modestr) end
	
		sodAutoRunOffKey(t,bl,curfile,SoD,mobile,stationary,flight)

		cbWriteBind(curfile,$SoD->{'FollowKey'},'nop')
	
	curfile:close()

# FollowRun Binds
	curfile = cbOpen(pathf..t.space..t.X..t.W..t.S..t.A..t.D..".txt","w")

		sodResetKey(curfile,profile,path,actPower_toggle(nil,true,stationary,mobile))
	
		sodUpKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
		sodDownKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
		sodForwardKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
		sodBackKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
		sodLeftKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
		sodRightKey(t,blf,curfile,SoD,mobile,stationary,flight,nil,bl,nil,sssj)
	
		if (flight == "Fly") and pathbo then
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"fr",curfile,{mobile,stationary},sodSetDownFix) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"fr",curfile,turnoff,sodSetDownFix) end
			if modestr ~= "Run" then makeSpeedModeKey(profile,t,"fs",curfile,turnoff,sodSetDownFix) end
		else
			if modestr ~= "NonSoD" then makeNonSoDModeKey(profile,t,"fr",curfile,{mobile,stationary}) end
			if modestr ~= "Base" then makeBaseModeKey(profile,t,"fr",curfile,turnoff,fix) end
			if modestr ~= "Run" then makeSpeedModeKey(profile,t,"fs",curfile,turnoff,fix) end
		end
		if modestr ~= "Fly" then makeFlyModeKey(profile,t,"ff",curfile,turnoff,fix) end
		if modestr ~= "Jump" then makeJumpModeKey(profile,t,"fj",curfile,turnoff,pathf) end
		if modestr ~= "Temp" then makeTempModeKey(profile,t,"fr",curfile,turnoff,path) end
		if modestr ~= "QFly" then makeQFlyModeKey(profile,t,"fr",curfile,turnoff,modestr) end
	
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'nop')
	
		sodFollowOffKey(t,bl,curfile,SoD,mobile,stationary,flight)
	
	curfile:close()
end

function module.makebind(profile)
	local resetfile = profile.resetfile
	local SoD = profile.SoD
	local t = {}
	# cbWriteBind(resetfile,petselect.sel5 .. ' "petselect 5')
	if $SoD->{'Default'} == "NonSoD" then
		if not $SoD->{'NonSoD'} then iup.Message("Notice","Enabling NonSoD mode, since it is set as your default mode.") end
		$SoD->{'NonSoD'} = true
	end
	if $SoD->{'Default'} == "Base" and not $SoD->{'Base'} then
		iup.Message("Notice","Enabling NonSoD mode and making it the default, since Sprint SoD, your previous Default mode, is not enabled.")
		$SoD->{'NonSoD'} = true
		$SoD->{'Default'} = "NonSoD"
	end
	if $SoD->{'Default'} == "Fly" and not ($SoD->{'Fly'}->{'Hover'} or $SoD->{'Fly'}->{'Fly'}) then
		iup.Message("Notice","Enabling NonSoD mode and making it the default, since Flight SoD, your previous Default mode, is not enabled.")
		$SoD->{'NonSoD'} = true
		$SoD->{'Default'} = "NonSoD"
	end
	if $SoD->{'Default'} == "Jump" and not ($SoD->{'Jump'}->{'CJ'} or $SoD->{'Jump'}->{'SJ'}) then
		iup.Message("Notice","Enabling NonSoD mode and making it the default, since Superjump SoD, your previous Default mode, is not enabled.")
		$SoD->{'NonSoD'} = true
		$SoD->{'Default'} = "NonSoD"
	end
	if $SoD->{'Default'} == "Run" and $SoD->{'Run'}->{'PrimaryNumber'} == 1 then
		iup.Message("Notice","Enabling NonSoD mode and making it the default, since Superspeed SoD, your previous Default mode, is not enabled.")
		$SoD->{'NonSoD'} = true
		$SoD->{'Default'} = "NonSoD"
	end
	t.hover = ""
	t.fly = ""
	t.flyx = ""
	t.jump = ""
	t.cjmp = ""
	t.canhov = 0
	t.canfly = 0
	t.canqfly = 0
	t.cancj = 0
	t.canjmp = 0
	t.on = "$$powexectoggleon "
	# t.on = "$$powexecname "
	t.off = "$$powexectoggleoff "
	if $SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} == nil then
		t.cancj = 1
		t.canjmp = 0
		t.cjmp = "Combat Jumping"
		t.jump = "Combat Jumping"
		t.jumpifnocj = nil
	end
	if $SoD->{'Jump'}->{'CJ'} == nil and $SoD->{'Jump'}->{'SJ'} then
		t.cancj = 0
		t.canjmp = 1
		t.jump = "Super Jump"
		t.jumpifnocj = "Super Jump"
	end
	if $SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} then
		t.cancj = 1
		t.canjmp = 1
		t.cjmp = "Combat Jumping"
		t.jump = "Super Jump"
		t.jumpifnocj = nil
	end
	t.tphover = ""
	t.ttpgfly = ""
	if profile.archetype == "Peacebringer" then
		if $SoD->{'Fly'}->{'Hover'} then
			t.canhov = 1
			t.canfly = 1
			t.hover = "Combat Flight"
			t.fly = "Energy Flight"
			t.flyx = "Energy Flight"
		else
			t.canhov = 0
			t.canfly = 1
			t.hover = "Energy Flight"
			t.flyx = "Energy Flight"
		end
	elseif not (profile.archetype == "Warshade") then
		if $SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'} == nil then
			t.canhov = 1
			t.canfly = 0
			t.hover = "Hover"
			t.flyx = "Hover"
			if $SoD->{'TP'}->{'TPHover'} then t.tphover = "$$powexectoggleon Hover" end
		end
		if $SoD->{'Fly'}->{'Hover'} == nil and $SoD->{'Fly'}->{'Fly'} then
			t.canhov = 0
			t.canfly = 1
			t.hover = "Fly"
			t.flyx = "Fly"
		end
		if $SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'} then
			t.canhov = 1
			t.canfly = 1
			t.hover = "Hover"
			t.fly = "Fly"
			t.flyx = "Fly"
			if $SoD->{'TP'}->{'TPHover'} then t.tphover = "$$powexectoggleon Hover" end
		end
	end
	if (profile.archetype == "Peacebringer") and $SoD->{'Fly'}->{'QFly'} then
		t.canqfly = 1
	end
	# if $SoD->{'Fly'}->{'GFly'} then
		# t.cangfly = 1
		# t.gfly = "Group Fly"
		# if $SoD->{'TTP'}->{'TPGFly'} then t.ttpgfly = "$$powexectoggleon Group Fly" end
	# else
	t.cangfly = 0
	# end
	t.sprint = ""
	t.speed = ""
	if $SoD->{'Run'}->{'PrimaryNumber'} == 1 then
		t.sprint = $SoD->{'Run'}->{'Secondary'}
		t.speed = $SoD->{'Run'}->{'Secondary'}
		t.canss = 0
	else
		t.sprint = $SoD->{'Run'}->{'Secondary'}
		t.speed = $SoD->{'Run'}->{'Primary'}
		t.canss = 1
	end
	if $SoD->{'Unqueue'} then t.unqueue = "$$powexecunqueue" else t.unqueue = "" end
	t.unqueue = ""
	if $SoD->{'AutoMouseLook'} then
		t.mlon = "$$mouselook 1"
		t.mloff = "$$mouselook 0"
	else
		t.mlon = ""
		t.mloff = ""
	end
	t.runcamdist = ""
	t.flycamdist = ""
	if $SoD->{'Run'}->{'UseCamdist'} then
		t.runcamdist = "$$camdist "..$SoD->{'Run'}->{'Camdist'}
	end
	if $SoD->{'Fly'}->{'UseCamdist'} then
		t.flycamdist = "$$camdist "..$SoD->{'Fly'}->{'Camdist'}
	end
	t.detailhi = ""
	t.detaillo = ""
	if $SoD->{'Detail'} and $SoD->{'Detail'}->{'Enable'} then
		t.detailhi = "$$visscale "..$SoD->{'Detail'}->{'NormalAmt'}.."$$shadowvol 0$$ss 0"
		t.detaillo = "$$visscale "..$SoD->{'Detail'}->{'MovingAmt'}.."$$shadowvol 0$$ss 0"
	end

	local windowhide = "$$windowhide health$$windowhide chat$$windowhide target$$windowhide tray"
	local windowshow = "$$show health$$show chat$$show target$$show tray"
	
	if not $SoD->{'TP'}->{'HideWindows'} then
		windowhide = ""
		windowshow = ""
	end
	
	t.basepath = profile.base

	t.subdirg=t.basepath.."\\R"
	t.subdira=t.basepath.."\\F"
	t.subdirj=t.basepath.."\\J"
	t.subdirs=t.basepath.."\\S"
	t.subdirn=t.basepath.."\\N"
	t.subdirt=t.basepath.."\\T"
	t.subdirq=t.basepath.."\\Q"
	# t.subdirga=t.basepath.."\\GF"
	t.subdirar=t.basepath.."\\AR"
	t.subdiraf=t.basepath.."\\AF"
	t.subdiraj=t.basepath.."\\AJ"
	t.subdiras=t.basepath.."\\AS"
	# t.subdirgaf=t.basepath.."\\GAF"
	t.subdiran=t.basepath.."\\AN"
	t.subdirat=t.basepath.."\\AT"
	t.subdiraq=t.basepath.."\\AQ"
	t.subdirfr=t.basepath.."\\FR"
	t.subdirff=t.basepath.."\\FF"
	t.subdirfj=t.basepath.."\\FJ"
	t.subdirfs=t.basepath.."\\FS"
	# t.subdirgff=t.basepath.."\\GFF"
	t.subdirfn=t.basepath.."\\FN"
	t.subdirft=t.basepath.."\\FT"
	t.subdirfq=t.basepath.."\\FQ"
	#  Special Modes used for Flight: Blastoff mode and setdown mode
	t.subdirbo=t.basepath.."\\BO"
	t.subdirsd=t.basepath.."\\SD"
	# t.subdirgbo=t.basepath.."\\GBO"
	# t.subdirgsd=t.basepath.."\\GSD"
	# local turn="+zoomin$$-zoomin"  # a non functioning bind used only to activate the keydown/keyup functions of +commands
	t.turn="+down"  # a non functioning bind used only to activate the keydown/keyup functions of +commands
	
	t.path=t.subdirg.."\\R" # ground subfolder and base filename.  Keep it shortish
	t.bl="$$bindloadfile "..t.path
	t.patha=t.subdira.."\\F" # air subfolder and base filename
	t.bla="$$bindloadfile "..t.patha
	t.pathj=t.subdirj.."\\J"
	t.blj="$$bindloadfile "..t.pathj
	t.paths=t.subdirs.."\\S"
	t.bls="$$bindloadfile "..t.paths
	# t.pathga=t.subdirga.."\\GF" # air subfolder and base filename
	# t.blga="$$bindloadfile "..t.pathga
	t.pathn=t.subdirn.."\\N" # ground subfolder and base filename.  Keep it shortish
	t.bln="$$bindloadfile "..t.pathn
	t.patht=t.subdirt.."\\T" # ground subfolder and base filename.  Keep it shortish
	t.blt="$$bindloadfile "..t.patht
	t.pathq=t.subdirq.."\\Q" # ground subfolder and base filename.  Keep it shortish
	t.blq="$$bindloadfile "..t.pathq
	t.pathgr=t.subdirar.."\\AR"  # ground autorun subfolder and base filename
	t.blgr="$$bindloadfile "..t.pathgr
	t.pathaf=t.subdiraf.."\\AF"  # air autorun subfolder and base filename
	t.blaf="$$bindloadfile "..t.pathaf
	t.pathaj=t.subdiraj.."\\AJ"
	t.blaj="$$bindloadfile "..t.pathaj
	t.pathas=t.subdiras.."\\AS"
	t.blas="$$bindloadfile "..t.pathas
	# t.pathgaf=t.subdirgaf.."\\GAF"  # air autorun subfolder and base filename
	# t.blgaf="$$bindloadfile "..t.pathgaf
	t.pathan=t.subdiran.."\\AN" # ground subfolder and base filename.  Keep it shortish
	t.blan="$$bindloadfile "..t.pathan
	t.pathat=t.subdirat.."\\AT" # ground subfolder and base filename.  Keep it shortish
	t.blat="$$bindloadfile "..t.pathat
	t.pathaq=t.subdiraq.."\\AQ" # ground subfolder and base filename.  Keep it shortish
	t.blaq="$$bindloadfile "..t.pathaq
	t.pathfr=t.subdirfr.."\\FR"  # Follow Run subfolder and base filename
	t.blfr="$$bindloadfile "..t.pathfr
	t.pathff=t.subdirff.."\\FF"  # Follow Fly subfolder and base filename
	t.blff="$$bindloadfile "..t.pathff
	t.pathfj=t.subdirfj.."\\FJ"
	t.blfj="$$bindloadfile "..t.pathfj
	t.pathfs=t.subdirfs.."\\FS"
	t.blfs="$$bindloadfile "..t.pathfs
	# t.pathgff=t.subdirgff.."\\GFF"  # Follow Fly subfolder and base filename
	# t.blgff="$$bindloadfile "..t.pathgff
	t.pathfn=t.subdirfn.."\\FN" # ground subfolder and base filename.  Keep it shortish
	t.blfn="$$bindloadfile "..t.pathfn
	t.pathft=t.subdirft.."\\FT" # ground subfolder and base filename.  Keep it shortish
	t.blft="$$bindloadfile "..t.pathat
	t.pathfq=t.subdirfq.."\\FQ" # ground subfolder and base filename.  Keep it shortish
	t.blfq="$$bindloadfile "..t.pathfq
	t.pathbo=t.subdirbo.."\\BO"  # Blastoff Fly subfolder and base filename
	t.blbo="$$bindloadfile "..t.pathbo
	t.pathsd=t.subdirsd.."\\SD"  #  SetDown Fly Subfolder and base filename
	t.blsd="$$bindloadfile "..t.pathsd
	# t.pathgbo=t.subdirgbo.."\\GBO"  # Blastoff Fly subfolder and base filename
	# t.blgbo="$$bindloadfile "..t.pathgbo
	# t.pathgsd=t.subdirgsd.."\\GSD"  #  SetDown Fly Subfolder and base filename
	# t.blgsd="$$bindloadfile "..t.pathgsd

	if $SoD->{'Base'} then
		cbMakeDirectory(t.subdirg)
		cbMakeDirectory(t.subdirar)
		cbMakeDirectory(t.subdirfr)
	end

	if t.canhov+t.canfly>0 then
		cbMakeDirectory(t.subdira)
		cbMakeDirectory(t.subdiraf)
		cbMakeDirectory(t.subdirff)
		cbMakeDirectory(t.subdirbo)
	end

	# if t.canqfly>0 then
		# cbMakeDirectory(t.subdirq)
		# cbMakeDirectory(t.subdiraq)
		# cbMakeDirectory(t.subdirfq)
	# end

	if t.canjmp>0 then
		cbMakeDirectory(t.subdirj)
		cbMakeDirectory(t.subdiraj)
		cbMakeDirectory(t.subdirfj)
	end

	if t.canss>0 then
		cbMakeDirectory(t.subdirs)
		cbMakeDirectory(t.subdiras)
		cbMakeDirectory(t.subdirfs)
	end
	
	# [[if t.cangfly>0 then
		cbMakeDirectory(t.subdirga)
		cbMakeDirectory(t.subdirgaf)
		cbMakeDirectory(t.subdirgff)
		cbMakeDirectory(t.subdirgbo)
		cbMakeDirectory(t.subdirgsd)
	end# ]]
	
	if $SoD->{'NonSoD'} or t.canqfly>0 then
		cbMakeDirectory(t.subdirn)
		cbMakeDirectory(t.subdiran)
		cbMakeDirectory(t.subdirfn)
	end
	
	if $SoD->{'Temp'}->{'Enable'} then
		cbMakeDirectory(t.subdirt)
		cbMakeDirectory(t.subdirat)
		cbMakeDirectory(t.subdirft)
	end
	
	#  temporarily set $SoD->{'Default'} to "NonSoD"
	# $SoD->{'Default'} = "Base"
	#  set up the keys to be used.
	if $SoD->{'Default'} ~= "NonSoD" then t.NonSoDModeKey = $SoD->{'NonSoDModeKey'} end
	if $SoD->{'Default'} ~= "Base" then t.BaseModeKey = $SoD->{'BaseModeKey'} end
	if $SoD->{'Default'} ~= "Fly" then t.FlyModeKey = $SoD->{'FlyModeKey'} end
	if $SoD->{'Default'} ~= "Jump" then t.JumpModeKey = $SoD->{'JumpModeKey'} end
	if $SoD->{'Default'} ~= "Run" then t.RunModeKey = $SoD->{'RunModeKey'} end
# 	if $SoD->{'Default'} ~= "GFly" then t.GFlyModeKey = $SoD->{'GFlyModeKey'} end
	t.TempModeKey = $SoD->{'TempModeKey'}
	t.QFlyModeKey = $SoD->{'QFlyModeKey'}
	
	for space = 0, 1 do
		t.space=space
		t.up = "$$up "..space
		t.upx = "$$up "..(1-space)
		for X = 0, 1 do
			t.X=X
			t.dow = "$$down "..X
			t.dowx = "$$down "..(1-X)
			for W = 0, 1 do
				t.W=W
				t.forw = "$$forward "..W
				t.forx = "$$forward "..(1-W)
				for S = 0, 1 do
					t.S=S
					t.bac = "$$backward "..S
					t.bacx = "$$backward "..(1-S)
					for A = 0, 1 do
						t.A=A
						t.lef = "$$left "..A
						t.lefx = "$$left "..(1-A)
						for D = 0, 1 do
							t.D=D
							t.rig = "$$right "..D
							t.rigx = "$$right "..(1-D)

							t.tkeys=space+X+W+S+A+D	# total number of keys down
							t.horizkeys=W+S+A+D	# total # of horizontal move keys.	So Sprint isn't turned on when jumping
							t.vertkeys=space+X
							t.jkeys = t.horizkeys+t.space
							if $SoD->{'NonSoD'} or t.canqfly>0 then
								t[$SoD->{'Default'}.."ModeKey"] = t.NonSoDModeKey
								makeSoDFile(profile,t,t.bln,t.blan,t.blfn,t.pathn,t.pathan,t.pathfn,nil,nil,"NonSoD",nil)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
							if $SoD->{'Base'} then
								t[$SoD->{'Default'}.."ModeKey"] = t.BaseModeKey
								makeSoDFile(profile,t,t.bl,t.blgr,t.blfr,t.path,t.pathgr,t.pathfr,t.sprint,nil,"Base",nil)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
							if t.canss>0 then
								t[$SoD->{'Default'}.."ModeKey"] = t.RunModeKey
								local sssj = nil
								if $SoD->{'SS'}->{'SSSJMode'} then sssj = t.jump end
								if $SoD->{'SS'}->{'MobileOnly'} then
									makeSoDFile(profile,t,t.bls,t.blas,t.blfs,t.paths,t.pathas,t.pathfs,t.speed,nil,"Run",nil,nil,nil,nil,nil,nil,nil,sssj)
								else
									makeSoDFile(profile,t,t.bls,t.blas,t.blfs,t.paths,t.pathas,t.pathfs,t.speed,t.speed,"Run",nil,nil,nil,nil,nil,nil,nil,sssj)
								end
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
							if t.canjmp>0 and not ($SoD->{'Jump'}->{'Simple'}) then
								t[$SoD->{'Default'}.."ModeKey"] = t.JumpModeKey
								local jturnoff
								if t.jump ~= t.cjump then jturnoff = {t.jumpifnocj} end
								makeSoDFile(profile,t,t.blj,t.blaj,t.blfj,t.pathj,t.pathaj,t.pathfj,t.jump,t.cjmp,"Jump","Jump",sodJumpFix,jturnoff)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
							if t.canhov+t.canfly>0 then
								t[$SoD->{'Default'}.."ModeKey"] = t.FlyModeKey
								makeSoDFile(profile,t,t.bla,t.blaf,t.blff,t.patha,t.pathaf,t.pathff,t.flyx,t.hover,"Fly","Fly",nil,nil,t.pathbo,t.pathsd,t.blbo,t.blsd)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
							# if t.canqfly>0 then
								# t[$SoD->{'Default'}.."ModeKey"] = t.QFlyModeKey
								# makeSoDFile(profile,t,t.blq,t.blaq,t.blfq,t.pathq,t.pathaq,t.pathfq,"Quantum Flight","Quantum Flight","QFly","Fly",nil,nil)
								# t[$SoD->{'Default'}.."ModeKey"] = nil
							# end
							# [[if t.cangfly>0 then
								t[$SoD->{'Default'}.."ModeKey"] = t.GFlyModeKey
								makeSoDFile(profile,t,t.blga,t.blgaf,t.blgff,t.pathga,t.pathgaf,t.pathgff,t.gfly,t.gfly,"GFly","GFly",nil,nil,t.pathgbo,t.pathgsd,t.blgbo,t.blgsd)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end# ]]
							if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
								local trayslot = {trayslot = "1 "..$SoD->{'Temp'}->{'Tray'}}
								t[$SoD->{'Default'}.."ModeKey"] = t.TempModeKey
								makeSoDFile(profile,t,t.blt,t.blat,t.blft,t.patht,t.pathat,t.pathft,trayslot,trayslot,"Temp","Fly",nil,nil)
								t[$SoD->{'Default'}.."ModeKey"] = nil
							end
						end
					end
				end
			end
		end
	end
	t.space=0
	t.X=0
	t.W=0
	t.S=0
	t.A=0
	t.D=0
	t.up = "$$up "..t.space
	t.upx = "$$up "..(1-t.space)
	t.dow = "$$down "..t.X
	t.dowx = "$$down "..(1-t.X)
	t.forw = "$$forward "..t.W
	t.forx = "$$forward "..(1-t.W)
	t.bac = "$$backward "..t.S
	t.bacx = "$$backward "..(1-t.S)
	t.lef = "$$left "..t.A
	t.lefx = "$$left "..(1-t.A)
	t.rig = "$$right "..t.D
	t.rigx = "$$right "..(1-t.D)
	
	if $SoD->{'TLeft'} and string.upper($SoD->{'TLeft'}) ~= "UNBOUND" then cbWriteBind(resetfile,$SoD->{'TLeft'},"+turnleft") end
	if $SoD->{'TRight'} and string.upper($SoD->{'TRight'}) ~= "UNBOUND" then cbWriteBind(resetfile,$SoD->{'TRight'},"+turnright") end
	
	if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
		local temptogglefile1 = cbOpen(t.basepath.."\\temptoggle1.txt","w")
		local temptogglefile2 = cbOpen(t.basepath.."\\temptoggle2.txt","w")
		cbWriteBind(temptogglefile2,$SoD->{'Temp'}->{'TraySwitch'},"-down$$gototray 1".."$$bindloadfile "..t.basepath.."\\temptoggle1.txt")
		cbWriteBind(temptogglefile1,$SoD->{'Temp'}->{'TraySwitch'},"+down$$gototray "..$SoD->{'Temp'}->{'Tray'}.."$$bindloadfile "..t.basepath.."\\temptoggle2.txt")
		cbWriteBind(resetfile,$SoD->{'Temp'}->{'TraySwitch'},"+down$$gototray "..$SoD->{'Temp'}->{'Tray'}.."$$bindloadfile "..t.basepath.."\\temptoggle2.txt")
		temptogglefile1:close()
		temptogglefile2:close()
	end

	local dwarfTPPower, normalTPPower, teamTPPower
	if profile.archetype == "Warshade" then
		dwarfTPPower = "powexecname Black Dwarf Step"
		normalTPPower = "powexecname Shadow Step"
	elseif profile.archetype == "Peacebringer" then
		dwarfTPPower = "powexecname White Dwarf Step"
	else
		normalTPPower = "powexecname Teleport"
		teamTPPower = "powexecname Team Teleport"
	end
	local humanBindKey
	local dwarfpbind, novapbind,humanpbind
	if $SoD->{'Human'} and $SoD->{'Human'}->{'Enable'} then
		humanBindKey = $SoD->{'Human'}->{'ModeKey'}
		humanpbind = cbPBindToString($SoD->{'Human'}->{'HumanPBind'},profile)
		novapbind = cbPBindToString($SoD->{'Human'}->{'NovaPBind'},profile)
		dwarfpbind = cbPBindToString($SoD->{'Human'}->{'DwarfPBind'},profile)
	end
	if (profile.archetype == "Peacebringer") or (profile.archetype == "Warshade") then
		if humanBindKey then
			cbWriteBind(resetfile,humanBindKey,humanpbind)
		end
	end
	#  kheldian form support #  create the Nova and Dwarf form support files if enabled.
	if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then
		cbWriteBind(resetfile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '..$SoD->{'Nova'}->{'Nova'}..' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'..t.on..$SoD->{'Nova'}->{'Nova'}.."$$gototray "..$SoD->{'Nova'}->{'PowerTray'}.."$$bindloadfile "..t.basepath.."\\nova.txt")
		local novafile = cbOpen(t.basepath.."\\nova.txt","w")
		if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then
			cbWriteBind(novafile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '..$SoD->{'Dwarf'}->{'Dwarf'}..' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'..t.off..$SoD->{'Nova'}->{'Nova'}..t.on..$SoD->{'Dwarf'}->{'Dwarf'}.."$$gototray "..$SoD->{'Dwarf'}->{'PowerTray'}.."$$bindloadfile "..t.basepath.."\\dwarf.txt")
		end
		if not humanBindKey then humanBindKey = $SoD->{'Nova'}->{'ModeKey'} end
		local humpower = ""
		if $SoD->{'UseHumanFormPower'} then humpower = "$$powexectoggleon "..$SoD->{'HumanFormShield'} end
		cbWriteBind(novafile,humanBindKey,"t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff "..$SoD->{'Nova'}->{'Nova'}..humpower.."$$gototray 1$$bindloadfile "..t.basepath.."\\reset.txt")
		if humanBindKey == $SoD->{'Nova'}->{'ModeKey'} then humanBindKey = nil end
		if novapbind then
			cbWriteBind(novafile,$SoD->{'Nova'}->{'ModeKey'},novapbind)
		end
		if t.canqfly then
			makeQFlyModeKey(profile,t,"r",novafile,$SoD->{'Nova'}->{'Nova'},"Nova")
		end

		cbWriteBind(novafile,$SoD->{'Forward'},"+forward")
		if $SoD->{'MouseChord'} then
			cbWriteBind(novafile,'mousechord "'.."+down$$+forward")
		end
		cbWriteBind(novafile,$SoD->{'Left'},"+left")
		cbWriteBind(novafile,$SoD->{'Right'},"+right")
		cbWriteBind(novafile,$SoD->{'Back'},"+backward")
		cbWriteBind(novafile,$SoD->{'Up'},"+up")
		cbWriteBind(novafile,$SoD->{'Down'},"+down")
		cbWriteBind(novafile,$SoD->{'AutoRunKey'},"++forward")
		cbWriteBind(novafile,$SoD->{'FlyModeKey'},'nop')
		if not ($SoD->{'FlyModeKey'}==$SoD->{'RunModeKey'}) then
			cbWriteBind(novafile,$SoD->{'RunModeKey'},'nop')
		end
		if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} then
			cbWriteBind(novafile,$SoD->{'TP'}->{'ComboKey'},'nop')
			cbWriteBind(novafile,$SoD->{'TP'}->{'BindKey'},'nop')
			cbWriteBind(novafile,$SoD->{'TP'}->{'ResetKey'},'nop')
		end
		cbWriteBind(novafile,$SoD->{'FollowKey'},"follow")
		# cbWriteBind(novafile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '..$SoD->{'Nova'}->{'Nova'}.."$$gototray 1$$bindloadfile "..t.basepath.."\\reset.txt")
		novafile:close()
	end
	if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then
		cbWriteBind(resetfile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '..$SoD->{'Dwarf'}->{'Dwarf'}..' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleon '..$SoD->{'Dwarf'}->{'Dwarf'}.."$$gototray "..$SoD->{'Dwarf'}->{'PowerTray'}.."$$bindloadfile "..t.basepath.."\\dwarf.txt")
		local dwrffile = cbOpen(t.basepath.."\\dwarf.txt","w")
		if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then
			cbWriteBind(dwrffile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '..$SoD->{'Nova'}->{'Nova'}..' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '..$SoD->{'Dwarf'}->{'Dwarf'}..'$$powexectoggleon '..$SoD->{'Nova'}->{'Nova'}.."$$gototray "..$SoD->{'Nova'}->{'PowerTray'}.."$$bindloadfile "..t.basepath.."\\nova.txt")
		end
		if not humanBindKey then humanBindKey = $SoD->{'Dwarf'}->{'ModeKey'} end
		local humpower = ""
		if $SoD->{'UseHumanFormPower'} then humpower = "$$powexectoggleon "..$SoD->{'HumanFormShield'} end
		cbWriteBind(dwrffile,humanBindKey,"t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff "..$SoD->{'Dwarf'}->{'Dwarf'}..humpower.."$$gototray 1$$bindloadfile "..t.basepath.."\\reset.txt")
		if dwarfpbind then
			cbWriteBind(dwrffile,$SoD->{'Dwarf'}->{'ModeKey'},dwarfpbind)
		end
		if t.canqfly then
			makeQFlyModeKey(profile,t,"r",dwrffile,$SoD->{'Dwarf'}->{'Dwarf'},"Dwarf")
		end

		cbWriteBind(dwrffile,$SoD->{'Forward'},"+forward")
		if $SoD->{'MouseChord'} then
			cbWriteBind(dwrffile,'mousechord "'.."+down$$+forward")
		end
		cbWriteBind(dwrffile,$SoD->{'Left'},"+left")
		cbWriteBind(dwrffile,$SoD->{'Right'},"+right")
		cbWriteBind(dwrffile,$SoD->{'Back'},"+backward")
		cbWriteBind(dwrffile,$SoD->{'Up'},"+up")
		cbWriteBind(dwrffile,$SoD->{'Down'},"+down")
		cbWriteBind(dwrffile,$SoD->{'AutoRunKey'},"++forward")
		cbWriteBind(dwrffile,$SoD->{'FlyModeKey'},'nop')
		if not ($SoD->{'FlyModeKey'}==$SoD->{'RunModeKey'}) then
			cbWriteBind(dwrffile,$SoD->{'RunModeKey'},'nop')
		end
		cbWriteBind(dwrffile,$SoD->{'FollowKey'},"follow")
		if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} then
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'ComboKey'},'+down$$'..dwarfTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\dtp\\tp_on1.txt')
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'BindKey'},'nop')
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'ResetKey'},string.sub(t.detailhi,3,string.len(t.detailhi))..t.runcamdist..windowshow..'$$bindloadfile '..t.basepath..'\\dtp\\tp_off.txt')
			#  Create tp directory
			cbMakeDirectory(t.basepath..'\\dtp')
			#  Create tp_off file
			local tp_off = cbOpen(t.basepath..'\\dtp\\tp_off.txt',"w")
			cbWriteBind(tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'..dwarfTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\dtp\\tp_on1.txt')
			cbWriteBind(tp_off,$SoD->{'TP'}->{'BindKey'},'nop')
			tp_off:close()
			local tp_on1 = cbOpen(t.basepath..'\\dtp\\tp_on1.txt',"w")
			cbWriteBind(tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'..t.detailhi..t.runcamdist..windowshow..'$$bindloadfile '..t.basepath..'\\dtp\\tp_off.txt')
			cbWriteBind(tp_on1,$SoD->{'TP'}->{'BindKey'},'+down$$bindloadfile '..t.basepath..'\\dtp\\tp_on2.txt')
			tp_on1:close()
			local tp_on2 = cbOpen(t.basepath..'\\dtp\\tp_on2.txt',"w")
			cbWriteBind(tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'..dwarfTPPower..'$$bindloadfile '..t.basepath..'\\dtp\\tp_on1.txt')
			tp_on2:close()
		end
		# cbWriteBind(dwrffile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '..$SoD->{'Dwarf'}->{'Dwarf'}.."$$gototray 1$$bindloadfile "..t.basepath.."\\reset.txt")
		dwrffile:close()
	end

	if $SoD->{'Jump'}->{'Simple'} then
		if $SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} then
			cbWriteBind(resetfile,$SoD->{'JumpModeKey'},'powexecname Super Jump$$powexecname Combat Jumping')
		elseif $SoD->{'Jump'}->{'SJ'} then
			cbWriteBind(resetfile,$SoD->{'JumpModeKey'},'powexecname Super Jump')
		elseif $SoD->{'Jump'}->{'CJ'} then
			cbWriteBind(resetfile,$SoD->{'JumpModeKey'},'powexecname Combat Jumping')
		end
	end

	if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} and not normalTPPower then
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ComboKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'BindKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ResetKey'},'nop')
	end
	if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} and not (profile.Archetype == "Peacebringer") and normalTPPower then
		local tphovermodeswitch = ""
		if t.tphover ~= "" then
			tphovermodeswitch = t.bla.."000000.txt"
		end
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ComboKey'},'+down$$'..normalTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\tp\\tp_on1.txt')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'BindKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ResetKey'},string.sub(t.detailhi,3,string.len(t.detailhi))..t.runcamdist..windowshow..'$$bindloadfile '..t.basepath..'\\tp\\tp_off.txt'..tphovermodeswitch)
		#  Create tp directory
		cbMakeDirectory(t.basepath..'\\tp')
		#  Create tp_off file
		local tp_off = cbOpen(t.basepath..'\\tp\\tp_off.txt',"w")
		cbWriteBind(tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'..normalTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\tp\\tp_on1.txt')
		cbWriteBind(tp_off,$SoD->{'TP'}->{'BindKey'},'nop')
		tp_off:close()
		local tp_on1 = cbOpen(t.basepath..'\\tp\\tp_on1.txt',"w")
		local zoomin = t.detailhi..t.runcamdist
		if t.tphover then zoomin = "" end
		cbWriteBind(tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'..zoomin..windowshow..'$$bindloadfile '..t.basepath..'\\tp\\tp_off.txt'..tphovermodeswitch)
		cbWriteBind(tp_on1,$SoD->{'TP'}->{'BindKey'},'+down'..t.tphover..'$$bindloadfile '..t.basepath..'\\tp\\tp_on2.txt')
		tp_on1:close()
		local tp_on2 = cbOpen(t.basepath..'\\tp\\tp_on2.txt',"w")
		cbWriteBind(tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'..normalTPPower..'$$bindloadfile '..t.basepath..'\\tp\\tp_on1.txt')
		tp_on2:close()
	end
	if $SoD->{'TTP'} and $SoD->{'TTP'}->{'Enable'} and not (profile.Archetype == "Peacebringer") and teamTPPower then
		local tphovermodeswitch = ""
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'ComboKey'},'+down$$'..teamTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_on1.txt')
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'BindKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'ResetKey'},string.sub(t.detailhi,3,string.len(t.detailhi))..t.runcamdist..windowshow..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_off.txt'..tphovermodeswitch)
		#  Create tp directory
		cbMakeDirectory(t.basepath..'\\ttp')
		#  Create tp_off file
		local ttp_off = cbOpen(t.basepath..'\\ttp\\ttp_off.txt',"w")
		cbWriteBind(ttp_off,$SoD->{'TTP'}->{'ComboKey'},'+down$$'..teamTPPower..t.detaillo..t.flycamdist..windowhide..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_on1.txt')
		cbWriteBind(ttp_off,$SoD->{'TTP'}->{'BindKey'},'nop')
		ttp_off:close()
		local ttp_on1 = cbOpen(t.basepath..'\\ttp\\ttp_on1.txt',"w")
		cbWriteBind(ttp_on1,$SoD->{'TTP'}->{'ComboKey'},'-down$$powexecunqueue'..t.detailhi..t.runcamdist..windowshow..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_off.txt'..tphovermodeswitch)
		cbWriteBind(ttp_on1,$SoD->{'TTP'}->{'BindKey'},'+down'..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_on2.txt')
		ttp_on1:close()
		local ttp_on2 = cbOpen(t.basepath..'\\ttp\\ttp_on2.txt',"w")
		cbWriteBind(ttp_on2,$SoD->{'TTP'}->{'BindKey'},'-down$$'..teamTPPower..'$$bindloadfile '..t.basepath..'\\ttp\\ttp_on1.txt')
		ttp_on2:close()
	end
	
end

function module.findconflicts(profile)
	local SoD = profile.SoD
	cbCheckConflict(SoD,"Up","Up Key")
	cbCheckConflict(SoD,"Down","Down Key")
	cbCheckConflict(SoD,"Forward","Forward Key")
	cbCheckConflict(SoD,"Back","Back Key")
	cbCheckConflict(SoD,"Left","Strafe Left Key")
	cbCheckConflict(SoD,"Right","Strafe Right Key")
	cbCheckConflict(SoD,"TLeft","Turn Left Key")
	cbCheckConflict(SoD,"TRight","Turn Right Key")
	cbCheckConflict(SoD,"AutoRunKey","AutoRun Key")
	cbCheckConflict(SoD,"FollowKey","Follow Key")
	if $SoD->{'NonSoD'} then cbCheckConflict(SoD,"NonSoDModeKey","NonSoD Key") end
	if $SoD->{'Base'} then cbCheckConflict(SoD,"BaseModeKey","Sprint Mode Key") end
	if $SoD->{'SS'}->{'SS'} then cbCheckConflict(SoD,"RunModeKey","Speed Mode Key") end
	if $SoD->{'Jump'}->{'CJ'} or $SoD->{'Jump'}->{'SJ'} then cbCheckConflict(SoD,"JumpModeKey","Jump Mode Key") end
	if $SoD->{'Fly'}->{'Hover'} or $SoD->{'Fly'}->{'Fly'} then cbCheckConflict(SoD,"FlyModeKey","Fly Mode Key") end
	if $SoD->{'Fly'}->{'QFly'} and (profile.archetype == "Peacebringer") then cbCheckConflict(SoD,"QFlyModeKey","Q.Fly Mode Key") end
	if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} then
		cbCheckConflict($SoD->{'TP'},"ComboKey","TP ComboKey")
		cbCheckConflict($SoD->{'TP'},"ResetKey","TP ResetKey")
		local TPQuestion = "Teleport Bind"
		if profile.archetype == "Peacebringer" then
			TPQuestion = "Dwarf Step Bind"
		elseif profile.archetype == "Warshade" then
			TPQuestion = "Shd/Dwf Step Bind"
		end
		cbCheckConflict($SoD->{'TP'},"BindKey",TPQuestion)
	end
	if $SoD->{'Fly'}->{'GFly'} then cbCheckConflict(SoD,"GFlyModeKey","Group Fly Key") end
	if $SoD->{'TTP'} and $SoD->{'TTP'}->{'Enable'} then
		cbCheckConflict($SoD->{'TTP'},"ComboKey","TTP ComboKey")
		cbCheckConflict($SoD->{'TTP'},"ResetKey","TTP ResetKey")
		cbCheckConflict($SoD->{'TTP'},"BindKey","Team TP Bind")
	end
	if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
		cbCheckConflict(SoD,"TempModeKey","Temp Mode Key")
		cbCheckConflict($SoD->{'Temp'},"TraySwitch","Tray Toggle Key")
	end
	if (profile.archetype == "Peacebringer") or (profile.archetype == "Warshade") then
		if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then cbCheckConflict($SoD->{'Nova'},"ModeKey","Nova Form Bind") end
		if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then cbCheckConflict($SoD->{'Dwarf'},"ModeKey","Dwarf Form Bind") end
	end
end

function module.bindisused(profile)
	if profile.SoD == nil then return nil end
	return profile.$SoD->{'enable'}
end

cbAddModule(module,"Speed on Demand","Movement")

1;
