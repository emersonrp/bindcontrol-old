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
my ($generalSizer, $sprintSizer, $superSpeedSizer, $superJumpSizer, $flySizer, $teleportSizer, $tempSizer, $kheldianSizer);
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
		$generalSizer->AddSpacer(1);

		# TODO!  fill this picker with only the appropriate bits.
		$generalSizer->Add( Wx::StaticText->new($panel, -1, "Default Movement Mode:"), 0, wxALL,);
		$generalSizer->Add( Wx::ComboBox->new(
				$panel, DEFAULT_MOVEMENT_MODE, '',
				wxDefaultPosition, wxDefaultSize,
				['No SoD','Sprint','Super Speed','Jump','Fly'],
				wxCB_READONLY,
			), 0, wxALL,);

		$overallSizer->Add($generalSizer);
	}

	$generalSizer->Show($cb->IsChecked());


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




	my $poolPowers = Profile::poolPowers();

	# OK, now find all the movement powers
	for ( sort keys %$poolPowers ) {

		# TODO!
	}

	##### SuperSpeed
	if (!$superSpeedSizer) {

		$superSpeedSizer = Wx::FlexGridSizer->new(0,2,3,3);

		$superSpeedSizer->Add( Wx::StaticText->new($panel, -1, "Toggle Super Speed"), 0, wxALL,);
		$superSpeedSizer->Add( Wx::TextCtrl->  new($panel, SS_KEY, ""), 0, wxALL,);

		$superSpeedSizer->Add( Wx::CheckBox->new($panel, SS_ONLY_WHEN_MOVING, "Only Super Speed When Moving"), 0, wxALL,);
		$superSpeedSizer->AddSpacer(1);

		$superSpeedSizer->Add( Wx::CheckBox->new($panel, SS_SJ_MODE, "Enable Super Speed + Super Jump Mode"), 0, wxALL,);
		$superSpeedSizer->AddSpacer(1);

		$overallSizer->Add($superSpeedSizer);
	}

	$superSpeedSizer->Show($cb->IsChecked());

	##### SuperJump
	if (!$superJumpSizer) {

		$superJumpSizer = Wx::FlexGridSizer->new(0,2,3,3);

		$superJumpSizer->Add( Wx::StaticText->new($panel, -1, "Toggle Jump Mode"), 0, wxALL,);
		$superJumpSizer->Add( Wx::TextCtrl->  new($panel, SJ_KEY, ""), 0, wxALL,);

		$superJumpSizer->Add( Wx::CheckBox->new($panel, SJ_SIMPLE_TOGGLE, "Use Simple CJ / SJ Mode Toggle"), 0, wxALL,);
		$superJumpSizer->AddSpacer(1);

		$overallSizer->Add($superJumpSizer);
	}

	$superJumpSizer->Show($cb->IsChecked());


	##### Fly
	if (!$flySizer) {

		$flySizer = Wx::FlexGridSizer->new(0,2,3,3);

		$flySizer->Add( Wx::StaticText->new($panel, -1, "Toggle Fly Mode"), 0, wxALL,);
		$flySizer->Add( Wx::TextCtrl->  new($panel, FLY_KEY, ""), 0, wxALL,);

		$flySizer->Add( Wx::StaticText->new($panel, -1, "Toggle Group Fly Mode"), 0, wxALL,);
		$flySizer->Add( Wx::TextCtrl->  new($panel, FLY_GROUPFLY_KEY, ""), 0, wxALL,);

		$overallSizer->Add($flySizer);
	}

	$flySizer->Show($cb->IsChecked());

	##### Teleport
	if (!$teleportSizer) {

		$teleportSizer = Wx::FlexGridSizer->new(0,2,3,3);

		my $teleportPowerName = 'Teleport';
		# if (at == peacebringer) "Dwarf Step Key"
		# if (at == warshade) "Shadow Step / Dwarf Step Key"

		$teleportSizer->Add( Wx::StaticText->new($panel, -1, "$teleportPowerName Combo Key"), 0, wxALL,);
		$teleportSizer->Add( Wx::TextCtrl->  new($panel, TP_COMBO_KEY, ""), 0, wxALL,);

		$teleportSizer->Add( Wx::StaticText->new($panel, -1, "$teleportPowerName Reset Key"), 0, wxALL,);
		$teleportSizer->Add( Wx::TextCtrl->  new($panel, TP_RESET_KEY, ""), 0, wxALL,);

		$teleportSizer->Add( Wx::StaticText->new($panel, -1, "$teleportPowerName Mode"), 0, wxALL,);
		$teleportSizer->Add( Wx::TextCtrl->  new($panel, TP_KEY, ""), 0, wxALL,);

		# if (player has hover): {
			$teleportSizer->Add( Wx::CheckBox->new($panel, TP_HOVER_WHEN_TP, "Auto-Hover When Teleporting"), 0, wxALL,);
			$teleportSizer->AddSpacer(1);
		# }

		# if (player has team-tp) {
			$teleportSizer->Add( Wx::StaticText->new($panel, -1, "Team Teleport Combo Key"), 0, wxALL,);
			$teleportSizer->Add( Wx::TextCtrl->  new($panel, TP_TEAM_COMBO_KEY, ""), 0, wxALL,);

			$teleportSizer->Add( Wx::StaticText->new($panel, -1, "Team Teleport Reset Key"), 0, wxALL,);
			$teleportSizer->Add( Wx::TextCtrl->  new($panel, TP_TEAM_RESET_KEY, ""), 0, wxALL,);

			# if (player has group fly) {
				$teleportSizer->Add( Wx::CheckBox->new($panel, TP_GROUP_FLY_WHEN_TP_TEAM, "Auto-Group-Fly When Team Teleporting"), 0, wxALL,);
				$teleportSizer->AddSpacer(1);

			# }
		# }
		$overallSizer->Add($teleportSizer);
	}

	$teleportSizer->Show($cb->IsChecked());

	##### Fly
	if (!$tempSizer) {

		$tempSizer = Wx::FlexGridSizer->new(0,2,3,3);

		# if (temp travel powers exist)?  Should this be "custom"?
		$tempSizer->Add( Wx::StaticText->new($panel, -1, "Toggle Temp Mode"), 0, wxALL,);
		$tempSizer->Add( Wx::TextCtrl->  new($panel, TEMP_KEY, ""), 0, wxALL,);

		$tempSizer->Add( Wx::StaticText->new($panel, -1, "Temp Travel Power Tray"), 0, wxALL,);
		$tempSizer->Add( Wx::TextCtrl->  new($panel, TEMP_POWERTRAY, ""), 0, wxALL,);

		$overallSizer->Add($tempSizer);
	}

	$tempSizer->Show($cb->IsChecked());

	if (!$kheldianSizer) {

		$kheldianSizer = Wx::FlexGridSizer->new(0,2,3,3);

		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Toggle Nova Form"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_NOVA_KEY, ""), 0, wxALL,);

		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Nova Powertray"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_NOVA_POWERTRAY, ""), 0, wxALL,);

		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Toggle Dwarf Form"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_DWARF_KEY, ""), 0, wxALL,);

		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Dwarf Powertray"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_DWARF_POWERTRAY, ""), 0, wxALL,);

		# do we want a key to change directly to human form, instead of toggles?
		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Human Form"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_HUMAN_KEY, ""), 0, wxALL,);

		$kheldianSizer->Add( Wx::StaticText->new($panel, -1, "Human Powertray"), 0, wxALL,);
		$kheldianSizer->Add( Wx::TextCtrl->  new($panel, KHELD_HUMAN_POWERTRAY, ""), 0, wxALL,);

		$overallSizer->Add($kheldianSizer);
	}

	$kheldianSizer->Show($cb->IsChecked());

	$overallSizer->Fit($panel);
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

sub makeSoDFile {
	my $params = shift;

	my $profile = $params->{'profile'};
	my $t = $params->{'t'};
	my $bl = $params->{'bl'};
	my $bla = $params->{'bla'};
	my $blf = $params->{'blf'};
	my $path = $params->{'path'};
	my $patha = $params->{'patha'};
	my $pathf = $params->{'pathf'};
	my $mobile = $params->{'mobile'};
	my $stationary = $params->{'stationary'};
	my $modestr = $params->{'modestr'};
	my $flight = $params->{'flight'};
	my $fix = $params->{'fix'};
	my $turnoff = $params->{'turnoff'};
	my $pathbo = $params->{'pathbo'};
	my $pathsd = $params->{'pathsd'};
	my $blbo = $params->{'blbo'};
	my $blsd = $params->{'blsd'};
	my $sssj = $params->{'sssj'};

	# hmm what?
	# if $modestr == "QFly" then return end

	my $SoD = $Profile::SoD;
	my $curfile;

	# this wants to be $turnoff ||= $mobile, $stationary once we know what those are.  arrays?  hashes?
	# $turnoff ||= {mobile,stationary}

	if (($SoD->{'Default'} eq $modestr) and ($t->{'tkeys'} == 0)) {

		$curfile = $profile->{'resetfile'};
		sodDefaultResetKey($mobile,$stationary);

		sodUpKey     ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
		sodDownKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
		sodForwardKey($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
		sodBackKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
		sodLeftKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
		sodRightKey  ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);

		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"r", $curfile,{$mobile,$stationary}); }
		if ($modestr eq "Base")   { makeBaseModeKey  ($profile,$t,"r", $curfile,$turnoff,$fix); }
		if ($modestr eq "Fly")    { makeFlyModeKey   ($profile,$t,"bo",$curfile,$turnoff,$fix); }
		# if ($modestr eq "GFly") { makeGFlyModeKey  ($profile,$t,"gf",$curfile,$turnoff,$fix); }
		if ($modestr eq "Run")    { makeRunModeKey   ($profile,$t,"s", $curfile,$turnoff,$fix); }
		if ($modestr eq "Jump")   { makeJumpModeKey  ($profile,$t,"j", $curfile,$turnoff,$path); }
		if ($modestr eq "Temp")   { makeTempModeKey  ($profile,$t,"r", $curfile,$turnoff,$path); }
		if ($modestr eq "QFly")   { makeQFlyModeKey  ($profile,$t,"r", $curfile,$turnoff,$modestr); }
	
		sodAutoRunKey($t,$bla,$curfile,$SoD,$mobile,$sssj);
	
		sodFollowKey($t,$blf,$curfile,$SoD,$mobile);
	}

	if (($flight eq "Fly") and $pathbo) {
		#  blast off
		my $curfile = cbOpen($pathbo.$t->{'space'} . XWSAD($t) . ".txt","w");

		sodResetKey($curfile,$profile,$path,actPower_toggle(nil,true,$stationary,$mobile));

		sodUpKey     ($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);
		sodDownKey   ($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);
		sodForwardKey($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);
		sodBackKey   ($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);
		sodLeftKey   ($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);
		sodRightKey  ($t,$blbo,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"bo",$sssj);

		# if ($modestr ~= "Base") { makeBaseModeKey($profile,$t,"r",$curfile,$turnoff,$fix); }
		$t->{'ini'} = "-down$$";

		if ($SoD->{'Default'} eq "Fly") {

			my $oldflymodekey = $t->{'FlyModeKey'};

			if ($SoD->{'NonSoD'}) {
				$t->{'FlyModeKey'} = $t->{'NonSoDModeKey'};
				makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
			}
			if ($SoD->{'Base'}) {
				$t->{'FlyModeKey'} = $t->{'BaseModeKey'};
				makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
			}
			if ($t->{'canss'}) {
				$t->{'FlyModeKey'} = $t->{'RunModeKey'};
				makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
			}
			if ($t->{'canjmp'}) {
				$t->{'FlyModeKey'} = $t->{'JumpModeKey'};
				makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
			}
			if ($SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'}) {
				$t->{'FlyModeKey'} = $t->{'TempModeKey'};
				makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
			}
		} else {
			makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix);
		}

		$t->{'ini'} = "";
		# if ($modestr ~= "GFly") { makeGFlyModeKey($profile,$t,"gbo",$curfile,$turnoff,$fix); }
		# if ($modestr ~= "Run") { makeRunModeKey($profile,$t,"s",$curfile,$turnoff,$fix); }
		# if ($modestr ~= "Jump") { makeJumpModeKey($profile,$t,"j",$curfile,$turnoff,$path); }

		sodAutoRunKey($t,$bla,$curfile,$SoD,$mobile,$sssj);

		sodFollowKey($t,$blf,$curfile,$SoD,$mobile);

		close $curfile;
		# $curfile = cbOpen($pathsd.$t->{'space'} . XWSAD($t) . ".txt","w");

		sodResetKey($curfile,$profile,$path,actPower_toggle(nil,true,$stationary,$mobile));

		sodUpKey     ($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);
		sodDownKey   ($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);
		sodForwardKey($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);
		sodBackKey   ($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);
		sodLeftKey   ($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);
		sodRightKey  ($t,$blsd,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,"sd",$sssj);

		$t->{'ini'} = "-down$$";
		# if ($modestr ~= "Base") { makeBaseModeKey($profile,$t,"r",$curfile,$turnoff,$fix); }
		# if ($modestr ~= "Fly") { makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix); }
		# if ($modestr ~= "GFly") { makeGFlyModeKey($profile,$t,"gbo",$curfile,$turnoff,$fix); }
		$t->{'ini'} = "";
		# if ($modestr ~= "Jump") { makeJumpModeKey($profile,$t,"j",$curfile,$turnoff,$path); }

		sodAutoRunKey($t,$bla,$curfile,$SoD,$mobile,$sssj);

		sodFollowKey($t,$blf,$curfile,$SoD,$mobile);

		close $curfile;
		#  set down
	}

	$curfile = cbOpen($path.$t->{'space'} . XWSAD($t) . ".txt","w");

	sodResetKey($curfile,$profile,$path,actPower_toggle(nil,true,$stationary,$mobile));

	sodUpKey     ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
	sodDownKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
	sodForwardKey($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
	sodBackKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
	sodLeftKey   ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);
	sodRightKey  ($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight,nil,nil,nil,$sssj);

	if (($flight eq "Fly") and $pathbo) {
		#  Base to set down
		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"r",$curfile,{$mobile,$stationary},&sodSetDownFix); }
		if ($modestr eq "Base")   { makeBaseModeKey($profile,$t,"r",$curfile,$turnoff,&sodSetDownFix); }
		# if ($t->{'BaseModeKey'}) {
			# cbWriteBind($curfile,$t->{'BaseModeKey'},"+down$$down 1".actPower(nil,true,$mobile).$t->{'detailhi'}.$t->{'runcamdist'}.$t->{'blsd'}.$t->{'space'} . XWSAD($t) . ".txt")
		#}
		if ($modestr eq "Run")     { makeRunModeKey   ($profile,$t,"s", $curfile,$turnoff,&sodSetDownFix); }
		if ($modestr eq "Fly")     { makeFlyModeKey   ($profile,$t,"bo",$curfile,$turnoff,$fix); }
		if ($modestr eq "Jump")    { makeJumpModeKey  ($profile,$t,"j", $curfile,$turnoff,$path); }
		if ($modestr eq "Temp")    { makeTempModeKey  ($profile,$t,"r", $curfile,$turnoff,$path); }
		if ($modestr eq "QFly")    { makeQFlyModeKey  ($profile,$t,"r", $curfile,$turnoff,$modestr); }
	} else {
		if ($modestr eq "NonSoD")  { makeNonSoDModeKey($profile,$t,"r", $curfile,{$mobile,$stationary}); }
		if ($modestr eq "Base")    { makeBaseModeKey  ($profile,$t,"r", $curfile,$turnoff,$fix); }
		if ($flight eq "Jump") {
			if ($modestr eq "Fly") { makeFlyModeKey   ($profile,$t,"a", $curfile,$turnoff,$fix,nil,true); }
		} else {
			if ($modestr eq "Fly") { makeFlyModeKey   ($profile,$t,"bo",$curfile,$turnoff,$fix); }
		}
		if ($modestr eq "Run")    { makeRunModeKey    ($profile,$t,"s", $curfile,$turnoff,$fix); }
		if ($modestr eq "Jump")   { makeJumpModeKey   ($profile,$t,"j", $curfile,$turnoff,$path); }
		if ($modestr eq "Temp")   { makeTempModeKey   ($profile,$t,"r", $curfile,$turnoff,$path); }
		if ($modestr eq "QFly")   { makeQFlyModeKey   ($profile,$t,"r", $curfile,$turnoff,$modestr); }
	}

	sodAutoRunKey($t,$bla,$curfile,$SoD,$mobile,$sssj);

	sodFollowKey($t,$blf,$curfile,$SoD,$mobile);

	close $curfile;

# AutoRun Binds
	$curfile = cbOpen($patha.$t->{'space'} . XWSAD($t) . ".txt","w");

	sodResetKey($curfile,$profile,$path,actPower_toggle(nil,true,$stationary,$mobile));

	sodUpKey     ($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,true,nil,nil,$sssj);
	sodDownKey   ($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,true,nil,nil,$sssj);
	sodForwardKey($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,$bl, nil,nil,$sssj);
	sodBackKey   ($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,$bl, nil,nil,$sssj);
	sodLeftKey   ($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,true,nil,nil,$sssj);
	sodRightKey  ($t,$bla,$curfile,$SoD,$mobile,$stationary,$flight,true,nil,nil,$sssj);

	if (($flight eq "Fly") and $pathbo) {
		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"ar",$curfile,{$mobile,$stationary},&sodSetDownFix); }
		if ($modestr eq "Base")   { makeBaseModeKey  ($profile,$t,"gr",$curfile,$turnoff,&sodSetDownFix); }
		if ($modestr eq "Run")    { makeRunModeKey   ($profile,$t,"as",$curfile,$turnoff,&sodSetDownFix); }
	} else {
		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"ar",$curfile,{$mobile,$stationary}); }
		if ($modestr eq "Base")   { makeBaseModeKey  ($profile,$t,"gr",$curfile,$turnoff,$fix); }
		if ($modestr eq "Run")    { makeRunModeKey   ($profile,$t,"as",$curfile,$turnoff,$fix); }
	}
	if ($modestr eq "Fly")        { makeFlyModeKey   ($profile,$t,"af",$curfile,$turnoff,$fix); }
	if ($modestr eq "Jump")       { makeJumpModeKey  ($profile,$t,"aj",$curfile,$turnoff,$patha); }
	if ($modestr eq "Temp")       { makeTempModeKey  ($profile,$t,"ar",$curfile,$turnoff,$path); }
	if ($modestr eq "QFly")       { makeQFlyModeKey  ($profile,$t,"ar",$curfile,$turnoff,$modestr); }

	sodAutoRunOffKey($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight);

	cbWriteBind($curfile,$SoD->{'FollowKey'},'nop');

	close $curfile;

# FollowRun Binds
	$curfile = cbOpen($pathf.$t->{'space'} . XWSAD($t) . ".txt","w");

   	sodResetKey($curfile,$profile,$path,actPower_toggle(nil,true,$stationary,$mobile));
   
   	sodUpKey     ($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   	sodDownKey   ($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   	sodForwardKey($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   	sodBackKey   ($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   	sodLeftKey   ($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   	sodRightKey  ($t,$blf,$curfile,$SoD,$mobile,$stationary,$flight,nil,$bl,nil,$sssj);
   
   	if (($flight eq "Fly") and $pathbo) {
   		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"fr",$curfile,{$mobile,$stationary},&sodSetDownFix); }
   		if ($modestr eq "Base")   { makeBaseModeKey  ($profile,$t,"fr",$curfile,$turnoff,&sodSetDownFix); }
   		if ($modestr eq "Run")    { makeRunModeKey   ($profile,$t,"fs",$curfile,$turnoff,&sodSetDownFix); }
   	} else {
   		if ($modestr eq "NonSoD") { makeNonSoDModeKey($profile,$t,"fr",$curfile,{$mobile,$stationary}); }
   		if ($modestr eq "Base")   { makeBaseModeKey  ($profile,$t,"fr",$curfile,$turnoff,$fix); }
   		if ($modestr eq "Run")    { makeRunModeKey   ($profile,$t,"fs",$curfile,$turnoff,$fix); }
   	}
   	if ($modestr eq "Fly")        { makeFlyModeKey   ($profile,$t,"ff",$curfile,$turnoff,$fix); }
   	if ($modestr eq "Jump")       { makeJumpModeKey  ($profile,$t,"fj",$curfile,$turnoff,$pathf); }
   	if ($modestr eq "Temp")       { makeTempModeKey  ($profile,$t,"fr",$curfile,$turnoff,$path); }
   	if ($modestr eq "QFly")       { makeQFlyModeKey  ($profile,$t,"fr",$curfile,$turnoff,$modestr); }

   	cbWriteBind($curfile,$SoD->{'AutoRunKey'},'nop');

   	sodFollowOffKey($t,$bl,$curfile,$SoD,$mobile,$stationary,$flight);

	close $curfile;
}

sub XWSAD { my $t = shift;  return "$t->{'X'}$t->{'W'}$t->{'S'}$t->{'A'}$t->{'D'}"; }

sub makeModeKey {
	my $params = shift;

	my $keytype = $params->{'keytype'};

	my $profile = $params->{'profile'};
	my $t = $params->{'t'};
	my $bl = $params->{'bl'};
	my $curfile = $params->{'curfile'};
	my $turnon = $params->{'turnon'};
	my $turnoff = $params->{'turnoff'};
	my $fix = $params->{'fix'};
	my $fb = $params->{'fb'};
	my $fbl = $params->{'fbl'};
	my $fb_on_a = $params->{'fb_on_a'};
	my $modestr = $params->{'modestr'};

	my ($bindload, $feedback, $filename, $tglfile);
	my $SoD = $profile->{'SoD'};

	return if (not $t->{$keytype} or $t->{$keytype} eq "UNBOUND");

	my $key = $t->{$keytype};

	if ($keytype eq 'NonSoDModeKey') {

		if (not $fb and $SoD->{'Feedback'}) { $feedback = '$$t $name, Non-SoD Mode'; }

		if ($bl eq"r") {
			$bindload = $t->{'bln'}.$t->{'space'} . XWSAD($t) . ".txt";

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(nil,true,nil,$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detailhi'}.$t->{'runcamdist'}.$feedback.$bindload)
			}

		} elsif ($bl eq"ar") {

			$bindload = $t->{'blan'}.$t->{'space'} . XWSAD($t) . ".txt";

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"a",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(nil,true,nil,$turnoff).$t->{'detailhi'}.$t->{'runcamdist'}."\$\$up 0".$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$feedback.$bindload)
			}
		} else {

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"f",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(nil,true,nil,$turnoff).$t->{'detailhi'}.$t->{'runcamdist'}."\$\$up 0".$feedback.$t->{'blfn'}.$t->{'space'} . XWSAD($t) . ".txt")
			}
		}
		$t->{'ini'} = "";
	} elsif ($keytype eq 'TempModeKey') {

		if ($SoD->{'Feedback'}) { $feedback="\$\$t \$name, Temp Mode" }
# TODO TODO TODO wtf is this doing?
	# local trayslot = {trayslot = "1 ".$SoD->{'Temp'}->{'Tray'}}
my $trayslot;
# end TODO TODO TODO
		if ($bl eq"r") {
			$bindload = $t->{'blt'}.$t->{'space'} . XWSAD($t) . ".txt";
			cbWriteBind($curfile,$key,$t->{'ini'}.actPower(nil,true,$trayslot,$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$bindload);
		} elsif ($bl eq"ar") {
			$bindload = $t->{'pathat'}.$t->{'space'} . XWSAD($t) . ".txt";
			my $bl2 = $t->{'pathat'}.$t->{'space'} . XWSAD($t) . "_$t->{'txt'}";
			my $tglfile = cbOpen($bl2,"w");
			cbWriteToggleBind($curfile,$tglfile,$key,$t->{'ini'}.actPower(nil,true,$trayslot,$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}."\$\$up 0".$t->{'dow'}.$t->{'lef'}.$t->{'rig'},$feedback,$bindload,$bl2);
			close $tglfile;
		} else {
			cbWriteBind($curfile,$key,$t->{'ini'}.actPower(nil,true,$trayslot,$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}."\$\$up 0".$feedback.$t->{'blft'}.$t->{'space'} . XWSAD($t) . ".txt");
		}
	} elsif ($keytype eq 'QFlyModeKey') {

		if ($modestr eq "NonSoD") { cbWriteBind($curfile,$t->{'QFlyModeKey'},"powexecname Quantum Flight"); return; }

		if ($SoD->{'Feedback'}) { $feedback="\$\$t \$name, QFlight Mode" }
		if ($bl eq "r") {
			$bindload = $t->{'pathn'}.$t->{'space'} . XWSAD($t) . ".txt";
			my $bl2 = $t->{'pathn'}.$t->{'space'} . XWSAD($t) . "_q.txt";
			my $tglfile = cbOpen($bl2,"w");
			my $tray;
			if ($modestr eq "Nova" or $modestr eq "Dwarf") { $tray = "\$\$gototray 1" }
			cbWriteToggleBind($curfile,$tglfile,$key,$t->{'ini'}.actPower_toggle(nil,true,"Quantum Flight",$turnoff).$tray.$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'},$feedback,$bindload,$bl2);
			close $tglfile;
		} elsif ($bl eq "ar") {
			$bindload = $t->{'pathan'}.$t->{'space'} . XWSAD($t) . ".txt";
			my $bl2 = $t->{'pathan'}.$t->{'space'} . XWSAD($t) . "_q.txt";
			my $tglfile = cbOpen($bl2,"w");
			cbWriteToggleBind($curfile,$tglfile,$key,$t->{'ini'}.actPower_toggle(nil,true,"Quantum Flight",$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}."\$\$up 0".$t->{'dow'}.$t->{'lef'}.$t->{'rig'},$feedback,$bindload,$bl2);
			close $tglfile;
		} else {
			# $bindload = $t->{'pathfn'}.$t->{'space'} . XWSAD($t) . ".txt";
			# my $bl2 = $t->{'pathfn'}.$t->{'space'} . XWSAD($t) . "_q.txt";
			# my $tglfile = cbOpen($bl2,"w");
			cbWriteBind($curfile,$t->{'QFlyModeKey'},$t->{'ini'}.actPower_toggle(nil,true,"Quantum Flight",$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}."\$\$up 0".$feedback.$t->{'blfn'}.$t->{'space'} . XWSAD($t) . ".txt");
			# close $tglfile;
		}
	} elsif ($keytype eq 'BaseModeKey') {

		if (not $fb and $SoD->{'Feedback'}) { $feedback="\$\$t \$name, Sprint-SoD Mode" }
		if ($bl eq "r") {
			$bindload = $t->{'bl'}.$t->{'space'} . XWSAD($t) . ".txt";
			my $turnon;
			# if ($t->{'horizkeys'} > 0) { $turnon = "+down".string.sub($t->{'on'},3,string.len($t->{'on'})).$t->{'sprint'}.$turnoff } else { $turnon = "+down" }
			if ($t->{'horizkeys'} > 0) { $turnon = actPower_toggle(true,true,$t->{'sprint'},$turnoff) } else { $turnon = actPower_toggle(true,true,nil,$turnoff) }
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.$turnon.$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detailhi'}.$t->{'runcamdist'}.$feedback.$bindload);
			}
		} elsif ($bl eq "ar") {
			$bindload = $t->{'blgr'}.$t->{'space'} . XWSAD($t) . ".txt";
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"a",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'sprint'},$turnoff).$t->{'detailhi'}.$t->{'runcamdist'}."\$\$up 0".$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$feedback.$bindload);
			}
		} else {
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"f",$feedback);
			} else {
				cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'sprint'},$turnoff).$t->{'detailhi'}.$t->{'runcamdist'}."\$\$up 0".$feedback.$t->{'blfr'}.$t->{'space'} . XWSAD($t) . ".txt");
			}
		}
	} elsif ($keytype eq 'RunModeKey') {

		if (not $fb and $SoD->{'Feedback'}) { $feedback="\$\$t \$name, Superspeed Mode" }
		if ($t->{'canss'} > 0) {
			if ($bl eq "s") {
				$bindload = $t->{'bls'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'speed'},$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$bindload);
				}
			} elsif ($bl eq "as") {
				$bindload = $t->{'blas'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"a",$feedback);
				} elsif ($feedback == "") {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'speed'},$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$bindload);
				} else {
					$bindload = $t->{'pathas'}.$t->{'space'} . XWSAD($t) . ".txt";
					my $bl2=$t->{'pathas'}.$t->{'space'} . XWSAD($t) . "_s.txt";
					my $tglfile = cbOpen($bl2,"w");
					cbWriteToggleBind($curfile,$tglfile,$t->{'RunModeKey'},$t->{'ini'}.actPower_toggle(true,true,$t->{'speed'},$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'},$feedback,$bindload,$bl2);
					close $tglfile;
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"f",$feedback);
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'speed'},$turnoff).'$$up 0'.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$t->{'blfs'}.$t->{'space'} . XWSAD($t) . ".txt");
				}
			}
		}
	} elsif ($keytype eq 'JumpModeKey') {

		if ($t->{'canjmp'} > 0 and not $SoD->{'Jump'}->{'Simple'}) {

			if ($SoD->{'Feedback'}) { $feedback="\$\$t \$name, Superjump Mode" }
			if ($bl eq "j") {
				$bindload = $t->{'blj'}.$t->{'space'} . XWSAD($t) . ".txt";
				my $a;
				if (($t->{'horizkeys'} + $t->{'space'}) > 0) { $a = actPower(nil,true,$t->{'jump'},$turnoff)."\$\$up 1" } else { $a = actPower(nil,true,$t->{'cjmp'},$turnoff) }
				$filename = $fbl.$t->{'space'} . XWSAD($t) . "j.txt";
				$tglfile = cbOpen($filename,"w");
				cbWriteBind($tglfile,$key,'-down'.$a.$t->{'detaillo'}.$t->{'flycamdist'}.$bindload);
				close $tglfile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'$$bindloadfile '.$filename);
			} elsif ($bl eq "aj") {
				$bindload = $t->{'blaj'}.$t->{'space'} . XWSAD($t) . ".txt";
				$filename = $fbl.$t->{'space'} . XWSAD($t) . "j.txt";
				$tglfile = cbOpen($filename,"w");
				cbWriteBind($tglfile,$key,'-down'.actPower(nil,true,$t->{'jump'},$turnoff)."\$\$up 1".$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$bindload);
				close $tglfile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'\$\$bindloadfile '.$filename);
			} else {
				$filename = $fbl.$t->{'space'} . XWSAD($t) . "j.txt";
				$tglfile = cbOpen($filename,"w");
				cbWriteBind($tglfile,$key,'-down'.actPower(nil,true,$t->{'jump'},$turnoff)."\$\$up 1".$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'blfj'}.$t->{'space'} . XWSAD($t) . ".txt");
				close $tglfile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'$$bindloadfile '.$filename);
			}
		}
	} elsif ($keytype eq 'FlyModeKey') {

		if (not $t->{'FlyModeKey'}) { error("invalid Fly Mode Key",2) }

		if (not $fb and $SoD->{'Feedback'}) { $feedback="\$\$t \$name, Flight Mode" }
		if ($t->{'canhov'}+$t->{'canfly'} > 0) {
			if ($bl eq "bo") {
				$bindload = $t->{'blbo'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,"+down\$\$".actPower_toggle(true,true,$t->{'flyx'},$turnoff)."\$\$up 1\$\$down 0".$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$bindload);
				}
			} elsif ($bl eq "a") {
				if (not $fb_on_a) { $feedback = "" }
				$bindload = $t->{'bla'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($t->{'tkeys'}==0) { $turnon=$t->{'hover'} } else { $turnon=$t->{'flyx'} }
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$turnon,$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$bindload);
				}
			} elsif ($bl eq "af") {
				$bindload = $t->{'blaf'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"a",$feedback);
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'flyx'},$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$feedback.$bindload);
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"f",$feedback);
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'flyx'},$turnoff).$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$feedback.$t->{'blff'}.$t->{'space'} . XWSAD($t) . ".txt");
				}
			}
		}
	} elsif ($keytype eq 'GFlyModeKey') {

		if ($t->{'cangfly'} > 0) {
			if ($bl eq "gbo") {
				$bindload = $t->{'blgbo'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"");
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.'$$up 1$$down 0'.actPower_toggle(nil,true,$t->{'gfly'},$turnoff).$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.$t->{'detaillo'}.$t->{'flycamdist'}.$bindload);
				}
			} elsif ($bl eq "gaf") {
				$bindload = $t->{'blgaf'}.$t->{'space'} . XWSAD($t) . ".txt";
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"a");
				} else {
					cbWriteBind($curfile,$key,$t->{'ini'}.$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$bindload);
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"f");
				} else {
					if ($bl eq "gf") {
						cbWriteBind($curfile,$key,$t->{'ini'}.actPower_toggle(true,true,$t->{'gfly'},$turnoff).$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'blgff'}.$t->{'space'} . XWSAD($t) . ".txt");
					} else {
						cbWriteBind($curfile,$key,$t->{'ini'}.$t->{'detaillo'}.$t->{'flycamdist'}.$t->{'blgff'}.$t->{'space'} . XWSAD($t) . ".txt");
					}
				}
			}
		}
	}
	$t->{'ini'} = "";
}


1;
__DATA__

sub actPower_toggle {
	my ($start, $unqueue, $on, @rest) = @_;

	my ($s, $traytest);

	if (ref $on) { $traytest = $on->{'trayslot'}; )

}


#  toggleon variation
function actPower_toggle(start,unq,on,..)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff..
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
							s = s."$$powexectray ".w.trayslot
							unq = true
						end
					else
						offpower[w] = true
						s = s."$$powexectoggleoff ".w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s."$$powexectray ".v.trayslot
				unq = true
			end
		else
			if not (v == "") and not (w == on) and not offpower[v] then
				offpower[v] = true
				s = s."$$powexectoggleoff ".v
			end
		end
	end
	if unq and not (s == "") then
		s = s."$$powexecunqueue"
	end
	# if start then s = string.sub(s,3,string.len(s)) end
	if on and not (on == "") then
		if type(on) == "table" then
			#  deal with power slot stuff..
			s = s."$$powexectray ".on.trayslot."$$powexectray ".on.trayslot
		else
			s = s."$$powexectoggleon ".on
		end
	end
	return s
end



function actPower_name(start,unq,on,..)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff..
		traytest = on.trayslot
	end
	for i,v in ipairs(arg) do
		if type(v) == "string" then
			if not (v == "") and v ~= on then
				s = s."$$powexecname ".v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w ~= on then
					if type(w) == "table" then
						if w.trayslot ~= traytest then
							s = s."$$powexectray ".w.trayslot
						end
					else
						s = s."$$powexecname ".w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s."$$powexectray ".v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on ~= "" then
		if type(on) == "table" then
			#  deal with power slot stuff..
			s = s."$$powexectray ".on.trayslot."$$powexectray ".on.trayslot
		else
			s = s."$$powexecname ".on."$$powexecname ".on
		end
	end
	if start then s = string.sub(s,3,string.len(s)) end
	return s
end

#  updated hybrid binds can reduce the space used in SoD Bindfiles by more than 40KB per SoD mode generated
function actPower_hybrid(start,unq,on,..)
	local s = ""
	local traytest = ""
	if type(on) == "table" then
		#  deal with power slot stuff..
		traytest = on.trayslot
	end
	for i,v in ipairs(arg) do
		if type(v) == "string" then
			if not (v == "") and v ~= on then
				s = s."$$powexecname ".v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w ~= on then
					if type(w) == "table" then
						if w.trayslot ~= traytest then
							s = s."$$powexectray ".w.trayslot
						end
					else
						s = s."$$powexecname ".w
					end
				end
			end
			if v.trayslot and v.trayslot ~= traytest then
				s = s."$$powexectray ".v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on ~= "" then
		if type(on) == "table" then
			#  deal with power slot stuff..
			s = s."$$powexectray ".on.trayslot."$$powexectray ".on.trayslot
		else
			s = s."$$powexectoggleon ".on
		end
	end
	if start then s = string.sub(s,3,string.len(s)) end
	return s
end

local actPower = actPower_name
# local actPower = actPower_toggle
function sodJumpFix(profile,t,key,makeModeKey,suffix,bl,curfile,turnoff,autofollowmode,feedback)
	local filename=t["path".autofollowmode."j"].$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.suffix.".txt"
	local tglfile = cbOpen(filename,"w")
	$t->{'ini'} = "-down$$"
	makeModeKey(profile,t,bl,tglfile,turnoff,nil,true)
	tglfile:close()
	cbWriteBind(curfile,key,"+down".feedback.actPower(nil,true,$t->{'cjmp'}).'$$bindloadfile '.filename)
end

function sodSetDownFix(profile,t,key,makeModeKey,suffix,bl,curfile,turnoff,autofollowmode,feedback)
	local pathsuffix = "f"
	if autofollowmode == "" then pathsuffix = "a" end
	# iup.Message("",tostring($t->{'space'}).tostring($t->{'X'}).tostring($t->{'W'}).tostring($t->{'S'}).tostring($t->{'A'}).tostring($t->{'D'}).tostring("path".autofollowmode.pathsuffix).tostring(suffix))
	local filename=t["path".autofollowmode.pathsuffix].$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.suffix.".txt"
	local tglfile = cbOpen(filename,"w")
	$t->{'ini'} = "-down$$"
	makeModeKey(profile,t,bl,tglfile,turnoff,nil,true)
	tglfile:close()
	cbWriteBind(curfile,key,'+down'.feedback.'$$bindloadfile '.filename)
end

function sodResetKey(curfile,profile,path,turnoff,moddir)
	if not moddir then
		cbWriteBind(curfile,$profile->{'ResetKey'},'up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.turnoff.'$$t $name, SoD Binds Reset'.cbGetBaseReset(profile).'$$bindloadfile '.path.'000000.txt')
	elseif moddir == "up" then
		cbWriteBind(curfile,$profile->{'ResetKey'},'up 1$$down 0$$forward 0$$backward 0$$left 0$$right 0'.turnoff.'$$t $name, SoD Binds Reset'.cbGetBaseReset(profile).'$$bindloadfile '.path.'000000.txt')
	elseif moddir == "down" then
		cbWriteBind(curfile,$profile->{'ResetKey'},'up 0$$down 1$$forward 0$$backward 0$$left 0$$right 0'.turnoff.'$$t $name, SoD Binds Reset'.cbGetBaseReset(profile).'$$bindloadfile '.path.'000000.txt')
	end
end

function sodDefaultResetKey(mobile,stationary)
	cbAddReset('up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.actPower(nil,true,stationary,mobile).'$$t $name, SoD Binds Reset')
end

function sodUpKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml# , aj
	local upx, dow, forw, bac, lef, rig = $t->{'upx'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if not flight and not sssj then mobile = nil stationary = nil end
	if bo == "bo" then upx = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then upx = "$$up 0" dow = "$$down 1" end
	
	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'tkeys'} == 1 and $t->{'space'} == 1 then upx="$$up 0" else upx="$$up 1" end
		if $t->{'X'} == 1 then upx="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if $t->{'tkeys'} == 1 and $t->{'space'} == 1 then
		ml = $t->{'mloff'}
		if not stationary and mobile ~= stationary  then
			toggleoff = mobile
		end
		toggleon = stationary
	else
		toggleoff = nil
	end
	
	local toggleoff2 = nil
	if sssj then
		if $t->{'space'} == 0 then #  if we are hitting the space bar rather than releasing its..
			toggleon = sssj
			toggleoff = mobile
			if stationary and stationary ~= mobile then
				toggleoff2 = stationary
			end
		elseif $t->{'space'} == 1 then #  if we are releasing the space bar ..
			toggleoff = sssj
			if $t->{'horizkeys'} > 0 or autorun then #  and we are moving laterally, or in autorun..
				toggleon = mobile
			else #  otherwise turn on the stationary power..
				toggleon = stationary
			end
		end
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff,toggleoff2)
	end

	bindload = bl.(1-$t->{'space'}).$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	ml = ml or ""
	
	local ini = "+down"
	if $t->{'space'} == 1 then
		ini = "-down"
	end

	if followbl then
		local move
		if $t->{'space'}==1 then
			move = ""
		else
			bindload = followbl.(1-$t->{'space'}).$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
			move = upx.dow.forw.bac.lef.rig
		end
		cbWriteBind(curfile,$SoD->{'Up'},ini.move.bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Up'},ini.upx.dow.forw.bac.lef.rig.ml.toggle.bindload)
	else
		if not sssj then toggle = "" end #  returns the following line to the way it was before sssj
		cbWriteBind(curfile,$SoD->{'Up'},ini.upx.dow."$$backward 0".lef.rig.toggle.$t->{'mlon'}.bindload)
	end
end

function sodDownKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml# , aj
	local up, dowx, forw, bac, lef, rig = $t->{'up'}, $t->{'dowx'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if not flight then mobile = nil stationary = nil end
	if bo == "bo" then up = "$$up 1" dowx = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dowx = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dowx = "$$down 0"
		# if $t->{'cancj'} == 1 then aj=$t->{'cjmp'} end
		# if $t->{'canjmp'} == 1 then aj=$t->{'jump'} end
		actkeys = $t->{'jkeys'}
		if $t->{'X'} == 1 and $t->{'tkeys'} > 1 then up="$$up 1" else up="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if $t->{'tkeys'} == 1 and $t->{'X'} == 1 then
		ml = $t->{'mloff'}
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

	bindload = bl.$t->{'space'}.(1-$t->{'X'}).$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	ml = ml or ""

	local ini = "+down"
	if $t->{'X'} == 1 then
		ini = "-down"
	end

	if followbl then
		local move
		if $t->{'X'}==1 then
			move = ""
		else
			bindload = followbl.$t->{'space'}."1".$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
			move = up.dowx.forw.bac.lef.rig
		end
		cbWriteBind(curfile,$SoD->{'Down'},ini.move.bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Down'},ini.up.dowx.forw.bac.lef.rig.ml.toggle.bindload)
	else
		cbWriteBind(curfile,$SoD->{'Down'},ini.up.dowx."$$backward 0".lef.rig.$t->{'mlon'}.bindload)
	end
end

function sodForwardKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,sssj)
	local ml
	local up, dow, forx, bac, lef, rig = $t->{'up'}, $t->{'dow'}, $t->{'forx'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'tkeys'} == 1 and $t->{'W'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'tkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'tkeys'} == 1 and $t->{'W'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'W'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'tkeys'} == 1 and $t->{'W'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl.$t->{'space'}.$t->{'X'}.(1-$t->{'W'}).$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	ml = ml or ""

	local ini = "+down"
	if $t->{'W'} == 1 then
		ini = "-down"
	end

	if followbl then
		if $t->{'W'}==1 then
			move = ini
		else
			bindload = followbl.$t->{'space'}.$t->{'X'}.(1-$t->{'W'}).$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
			move = ini.up.dow.forx.bac.lef.rig
		end
		cbWriteBind(curfile,$SoD->{'Forward'},move.bindload)
		if $SoD->{'MouseChord'} then
			if $t->{'W'}~=1 then move = ini.up.dow.forx.bac.rig.lef end
			cbWriteBind(curfile,'mousechord',move.bindload)
		end
	elseif not autorunbl then
		cbWriteBind(curfile,$SoD->{'Forward'},ini.up.dow.forx.bac.lef.rig.ml.toggle.bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini.up.dow.forx.bac.rig.lef.ml.toggle.bindload)
		end
	else
		if $t->{'W'} ~= 1 then
			bindload = autorunbl.$t->{'space'}.$t->{'X'}.(1-$t->{'W'}).$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
		end
		cbWriteBind(curfile,$SoD->{'Forward'},ini.up.dow.'$$forward 1$$backward 0'.lef.rig.$t->{'mlon'}.bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini.up.dow.'$$forward 1$$backward 0'.rig.lef.$t->{'mlon'}.bindload)
		end
	end
end

function sodBackKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,sssj)
	local ml
	local up, dow, forw, bacx, lef, rig = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bacx'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'tkeys'} == 1 and $t->{'S'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'tkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'tkeys'} == 1 and $t->{'S'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'S'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'tkeys'} == 1 and $t->{'S'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.(1-$t->{'S'}).$t->{'A'}.$t->{'D'}.".txt"
	ml = ml or ""

	local ini = "+down"
	if $t->{'S'} == 1 then
		ini = "-down"
	end

	if followbl then
		if $t->{'S'}==1 then
			move = ini
		else
			bindload = followbl.$t->{'space'}.$t->{'X'}.$t->{'W'}.(1-$t->{'S'}).$t->{'A'}.$t->{'D'}.".txt"
			move = ini.up.dow.forw.bacx.lef.rig
		end
		cbWriteBind(curfile,$SoD->{'Back'},move.bindload)
	elseif not autorunbl then
		cbWriteBind(curfile,$SoD->{'Back'},ini.up.dow.forw.bacx.lef.rig.ml.toggle.bindload)
	else
		local move
		if $t->{'S'}==1 then
			move = "$$forward 1$$backward 0"
		else
			move = "$$forward 0$$backward 1"
			bindload = autorunbl.$t->{'space'}.$t->{'X'}.$t->{'W'}.(1-$t->{'S'}).$t->{'A'}.$t->{'D'}.".txt"
		end
		cbWriteBind(curfile,$SoD->{'Back'},ini.up.dow.move.lef.rig.$t->{'mlon'}.bindload)
	end
end

function sodLeftKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml
	local up, dow, forw, bac, lefx, rig = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lefx'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'tkeys'} == 1 and $t->{'A'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'tkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'tkeys'} == 1 and $t->{'A'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'A'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'tkeys'} == 1 and $t->{'A'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.(1-$t->{'A'}).$t->{'D'}.".txt"
	ml = ml or ""

	local ini = "+down"
	if $t->{'A'} == 1 then
		ini = "-down"
	end

	if followbl then
		if $t->{'A'}==1 then
			move = ini
		else
			bindload = followbl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.(1-$t->{'A'}).$t->{'D'}.".txt"
			move = ini.up.dow.forw.bac.lefx.rig
		end
		cbWriteBind(curfile,$SoD->{'Left'},move.bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Left'},ini.up.dow.forw.bac.lefx.rig.ml.toggle.bindload)
	else
		cbWriteBind(curfile,$SoD->{'Left'},ini.up.dow."$$backward 0".lefx.rig.$t->{'mlon'}.bindload)
	end
end

function sodRightKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,sssj)
	local ml
	local up, dow, forw, bac, lef, rigx = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rigx'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'tkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'tkeys'} == 1 and $t->{'D'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'tkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile ~= stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'tkeys'} == 1 and $t->{'D'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'D'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'tkeys'} == 1 and $t->{'D'} == 1 then
			if not stationary and mobile ~= stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,toggleon,toggleoff)
	end

	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.(1-$t->{'D'}).".txt"
	ml = ml or ""

	local ini = "+down"
	if $t->{'D'} == 1 then
		ini = "-down"
	end

	if followbl then
		if $t->{'D'}==1 then
			move = ini
		else
			bindload = followbl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.(1-$t->{'D'}).".txt"
			move = ini.up.dow.forw.bac.lef.rigx
		end
		cbWriteBind(curfile,$SoD->{'Right'},move.bindload)
	elseif not autorun then
		cbWriteBind(curfile,$SoD->{'Right'},ini.up.dow.forw.bac.lef.rigx.ml.toggle.bindload)
	else
		cbWriteBind(curfile,$SoD->{'Right'},ini.up.dow."$$forward 1$$backward 0".lef.rigx.$t->{'mlon'}.bindload)
	end
end

function sodAutoRunKey(t,bl,curfile,SoD,mobile,sssj)
	local bindload
	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	if sssj and $t->{'space'} == 1 then
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'.$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'mlon'}.actPower(nil,true,sssj,mobile).bindload)
	else
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'.$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'mlon'}.actPower(nil,true,mobile).bindload)
	end
end

function sodAutoRunOffKey(t,bl,curfile,SoD,mobile,stationary,flight,sssj)
	local toggleon=""
	local toggleoff
	if sssj and $t->{'space'} == 1 then toggleoff = mobile mobile = sssj end
	if not flight and not sssj then
		if $t->{'horizkeys'} > 0 then
			toggleon=$t->{'mlon'}.actPower(nil,true,mobile)
		else
			toggleon=$t->{'mloff'}.actPower(nil,true,stationary,mobile)
		end
	elseif sssj then
		if $t->{'horizkeys'} > 0 or $t->{'space'} == 1 then
			toggleon=$t->{'mlon'}.actPower(nil,true,mobile,toggleoff)
		else
			toggleon=$t->{'mloff'}.actPower(nil,true,stationary,mobile,toggleoff)
		end
	else
		if $t->{'tkeys'} > 0 then
			toggleon=$t->{'mlon'}.actPower(nil,true,mobile)
		else
			toggleon=$t->{'mloff'}.actPower(nil,true,stationary,mobile)
		end
	end
	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	cbWriteBind(curfile,$SoD->{'AutoRunKey'},$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.toggleon.bindload)
end

function sodFollowKey(t,bl,curfile,SoD,mobile)
	cbWriteBind(curfile,$SoD->{'FollowKey'},'follow'.actPower(nil,true,mobile).bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.'.txt')
end

function sodFollowOffKey(t,bl,curfile,SoD,mobile,stationary,flight)
	local toggle = ""
	if not flight then
		if $t->{'horizkeys'}==0 then
			if stationary ~= mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	else
		if $t->{'tkeys'}==0 then
			if stationary ~= mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	end
	cbWriteBind(curfile,$SoD->{'FollowKey'},"follow".toggle.$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt")
end

function module.makebind(profile)
	local resetfile = $profile->{'resetfile'}
	local SoD = $profile->{'SoD'}
	local t = {}
	# cbWriteBind(resetfile,petselec$t->{'sel5'} . ' "petselect 5')
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
	$t->{'hover'} = ""
	$t->{'fly'} = ""
	$t->{'flyx'} = ""
	$t->{'jump'} = ""
	$t->{'cjmp'} = ""
	$t->{'canhov'} = 0
	$t->{'canfly'} = 0
	$t->{'canqfly'} = 0
	$t->{'cancj'} = 0
	$t->{'canjmp'} = 0
	$t->{'on'} = "$$powexectoggleon "
	# $t->{'on'} = "$$powexecname "
	$t->{'off'} = "$$powexectoggleoff "
	if $SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} == nil then
		$t->{'cancj'} = 1
		$t->{'canjmp'} = 0
		$t->{'cjmp'} = "Combat Jumping"
		$t->{'jump'} = "Combat Jumping"
		$t->{'jumpifnocj'} = nil
	end
	if $SoD->{'Jump'}->{'CJ'} == nil and $SoD->{'Jump'}->{'SJ'} then
		$t->{'cancj'} = 0
		$t->{'canjmp'} = 1
		$t->{'jump'} = "Super Jump"
		$t->{'jumpifnocj'} = "Super Jump"
	end
	if $SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} then
		$t->{'cancj'} = 1
		$t->{'canjmp'} = 1
		$t->{'cjmp'} = "Combat Jumping"
		$t->{'jump'} = "Super Jump"
		$t->{'jumpifnocj'} = nil
	end
	$t->{'tphover'} = ""
	$t->{'ttpgfly'} = ""
	if $profile->{'archetype'} == "Peacebringer" then
		if $SoD->{'Fly'}->{'Hover'} then
			$t->{'canhov'} = 1
			$t->{'canfly'} = 1
			$t->{'hover'} = "Combat Flight"
			$t->{'fly'} = "Energy Flight"
			$t->{'flyx'} = "Energy Flight"
		else
			$t->{'canhov'} = 0
			$t->{'canfly'} = 1
			$t->{'hover'} = "Energy Flight"
			$t->{'flyx'} = "Energy Flight"
		end
	elseif not ($profile->{'archetype'} == "Warshade") then
		if $SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'} == nil then
			$t->{'canhov'} = 1
			$t->{'canfly'} = 0
			$t->{'hover'} = "Hover"
			$t->{'flyx'} = "Hover"
			if $SoD->{'TP'}->{'TPHover'} then $t->{'tphover'} = "$$powexectoggleon Hover" end
		end
		if $SoD->{'Fly'}->{'Hover'} == nil and $SoD->{'Fly'}->{'Fly'} then
			$t->{'canhov'} = 0
			$t->{'canfly'} = 1
			$t->{'hover'} = "Fly"
			$t->{'flyx'} = "Fly"
		end
		if $SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'} then
			$t->{'canhov'} = 1
			$t->{'canfly'} = 1
			$t->{'hover'} = "Hover"
			$t->{'fly'} = "Fly"
			$t->{'flyx'} = "Fly"
			if $SoD->{'TP'}->{'TPHover'} then $t->{'tphover'} = "$$powexectoggleon Hover" end
		end
	end
	if ($profile->{'archetype'} == "Peacebringer") and $SoD->{'Fly'}->{'QFly'} then
		$t->{'canqfly'} = 1
	end
	# if $SoD->{'Fly'}->{'GFly'} then
		# $t->{'cangfly'} = 1
		# $t->{'gfly'} = "Group Fly"
		# if $SoD->{'TTP'}->{'TPGFly'} then $t->{'ttpgfly'} = "$$powexectoggleon Group Fly" end
	# else
	$t->{'cangfly'} = 0
	# end
	$t->{'sprint'} = ""
	$t->{'speed'} = ""
	if $SoD->{'Run'}->{'PrimaryNumber'} == 1 then
		$t->{'sprint'} = $SoD->{'Run'}->{'Secondary'}
		$t->{'speed'} = $SoD->{'Run'}->{'Secondary'}
		$t->{'canss'} = 0
	else
		$t->{'sprint'} = $SoD->{'Run'}->{'Secondary'}
		$t->{'speed'} = $SoD->{'Run'}->{'Primary'}
		$t->{'canss'} = 1
	end
	if $SoD->{'Unqueue'} then $t->{'unqueue'} = "$$powexecunqueue" else $t->{'unqueue'} = "" end
	$t->{'unqueue'} = ""
	if $SoD->{'AutoMouseLook'} then
		$t->{'mlon'} = "$$mouselook 1"
		$t->{'mloff'} = "$$mouselook 0"
	else
		$t->{'mlon'} = ""
		$t->{'mloff'} = ""
	end
	$t->{'runcamdist'} = ""
	$t->{'flycamdist'} = ""
	if $SoD->{'Run'}->{'UseCamdist'} then
		$t->{'runcamdist'} = "$$camdist ".$SoD->{'Run'}->{'Camdist'}
	end
	if $SoD->{'Fly'}->{'UseCamdist'} then
		$t->{'flycamdist'} = "$$camdist ".$SoD->{'Fly'}->{'Camdist'}
	end
	$t->{'detailhi'} = ""
	$t->{'detaillo'} = ""
	if $SoD->{'Detail'} and $SoD->{'Detail'}->{'Enable'} then
		$t->{'detailhi'} = "$$visscale ".$SoD->{'Detail'}->{'NormalAmt'}."$$shadowvol 0$$ss 0"
		$t->{'detaillo'} = "$$visscale ".$SoD->{'Detail'}->{'MovingAmt'}."$$shadowvol 0$$ss 0"
	end

	local windowhide = "$$windowhide health$$windowhide chat$$windowhide target$$windowhide tray"
	local windowshow = "$$show health$$show chat$$show target$$show tray"
	
	if not $SoD->{'TP'}->{'HideWindows'} then
		windowhide = ""
		windowshow = ""
	end
	
	$t->{'basepath'} = $profile->{'base'}

	$t->{'subdirg'}=$t->{'basepath'}."\\R"
	$t->{'subdira'}=$t->{'basepath'}."\\F"
	$t->{'subdirj'}=$t->{'basepath'}."\\J"
	$t->{'subdirs'}=$t->{'basepath'}."\\S"
	$t->{'subdirn'}=$t->{'basepath'}."\\N"
	$t->{'subdirt'}=$t->{'basepath'}."\\T"
	$t->{'subdirq'}=$t->{'basepath'}."\\Q"
	# $t->{'subdirga'}=$t->{'basepath'}."\\GF"
	$t->{'subdirar'}=$t->{'basepath'}."\\AR"
	$t->{'subdiraf'}=$t->{'basepath'}."\\AF"
	$t->{'subdiraj'}=$t->{'basepath'}."\\AJ"
	$t->{'subdiras'}=$t->{'basepath'}."\\AS"
	# $t->{'subdirgaf'}=$t->{'basepath'}."\\GAF"
	$t->{'subdiran'}=$t->{'basepath'}."\\AN"
	$t->{'subdirat'}=$t->{'basepath'}."\\AT"
	$t->{'subdiraq'}=$t->{'basepath'}."\\AQ"
	$t->{'subdirfr'}=$t->{'basepath'}."\\FR"
	$t->{'subdirff'}=$t->{'basepath'}."\\FF"
	$t->{'subdirfj'}=$t->{'basepath'}."\\FJ"
	$t->{'subdirfs'}=$t->{'basepath'}."\\FS"
	# $t->{'subdirgff'}=$t->{'basepath'}."\\GFF"
	$t->{'subdirfn'}=$t->{'basepath'}."\\FN"
	$t->{'subdirft'}=$t->{'basepath'}."\\FT"
	$t->{'subdirfq'}=$t->{'basepath'}."\\FQ"
	#  Special Modes used for Flight: Blastoff mode and setdown mode
	$t->{'subdirbo'}=$t->{'basepath'}."\\BO"
	$t->{'subdirsd'}=$t->{'basepath'}."\\SD"
	# $t->{'subdirgbo'}=$t->{'basepath'}."\\GBO"
	# $t->{'subdirgsd'}=$t->{'basepath'}."\\GSD"
	# local turn="+zoomin$$-zoomin"  # a non functioning bind used only to activate the keydown/keyup functions of +commands
	$t->{'turn'}="+down"  # a non functioning bind used only to activate the keydown/keyup functions of +commands
	
	$t->{'path'}=$t->{'subdirg'}."\\R" # ground subfolder and base filename.  Keep it shortish
	$t->{'bl'}="$$bindloadfile ".$t->{'path'}
	$t->{'patha'}=$t->{'subdira'}."\\F" # air subfolder and base filename
	$t->{'bla'}="$$bindloadfile ".$t->{'patha'}
	$t->{'pathj'}=$t->{'subdirj'}."\\J"
	$t->{'blj'}="$$bindloadfile ".$t->{'pathj'}
	$t->{'paths'}=$t->{'subdirs'}."\\S"
	$t->{'bls'}="$$bindloadfile ".$t->{'paths'}
	# $t->{'pathga'}=$t->{'subdirga'}."\\GF" # air subfolder and base filename
	# $t->{'blga'}="$$bindloadfile ".$t->{'pathga'}
	$t->{'pathn'}=$t->{'subdirn'}."\\N" # ground subfolder and base filename.  Keep it shortish
	$t->{'bln'}="$$bindloadfile ".$t->{'pathn'}
	$t->{'patht'}=$t->{'subdirt'}."\\T" # ground subfolder and base filename.  Keep it shortish
	$t->{'blt'}="$$bindloadfile ".$t->{'patht'}
	$t->{'pathq'}=$t->{'subdirq'}."\\Q" # ground subfolder and base filename.  Keep it shortish
	$t->{'blq'}="$$bindloadfile ".$t->{'pathq'}
	$t->{'pathgr'}=$t->{'subdirar'}."\\AR"  # ground autorun subfolder and base filename
	$t->{'blgr'}="$$bindloadfile ".$t->{'pathgr'}
	$t->{'pathaf'}=$t->{'subdiraf'}."\\AF"  # air autorun subfolder and base filename
	$t->{'blaf'}="$$bindloadfile ".$t->{'pathaf'}
	$t->{'pathaj'}=$t->{'subdiraj'}."\\AJ"
	$t->{'blaj'}="$$bindloadfile ".$t->{'pathaj'}
	$t->{'pathas'}=$t->{'subdiras'}."\\AS"
	$t->{'blas'}="$$bindloadfile ".$t->{'pathas'}
	# $t->{'pathgaf'}=$t->{'subdirgaf'}."\\GAF"  # air autorun subfolder and base filename
	# $t->{'blgaf'}="$$bindloadfile ".$t->{'pathgaf'}
	$t->{'pathan'}=$t->{'subdiran'}."\\AN" # ground subfolder and base filename.  Keep it shortish
	$t->{'blan'}="$$bindloadfile ".$t->{'pathan'}
	$t->{'pathat'}=$t->{'subdirat'}."\\AT" # ground subfolder and base filename.  Keep it shortish
	$t->{'blat'}="$$bindloadfile ".$t->{'pathat'}
	$t->{'pathaq'}=$t->{'subdiraq'}."\\AQ" # ground subfolder and base filename.  Keep it shortish
	$t->{'blaq'}="$$bindloadfile ".$t->{'pathaq'}
	$t->{'pathfr'}=$t->{'subdirfr'}."\\FR"  # Follow Run subfolder and base filename
	$t->{'blfr'}="$$bindloadfile ".$t->{'pathfr'}
	$t->{'pathff'}=$t->{'subdirff'}."\\FF"  # Follow Fly subfolder and base filename
	$t->{'blff'}="$$bindloadfile ".$t->{'pathff'}
	$t->{'pathfj'}=$t->{'subdirfj'}."\\FJ"
	$t->{'blfj'}="$$bindloadfile ".$t->{'pathfj'}
	$t->{'pathfs'}=$t->{'subdirfs'}."\\FS"
	$t->{'blfs'}="$$bindloadfile ".$t->{'pathfs'}
	# $t->{'pathgff'}=$t->{'subdirgff'}."\\GFF"  # Follow Fly subfolder and base filename
	# $t->{'blgff'}="$$bindloadfile ".$t->{'pathgff'}
	$t->{'pathfn'}=$t->{'subdirfn'}."\\FN" # ground subfolder and base filename.  Keep it shortish
	$t->{'blfn'}="$$bindloadfile ".$t->{'pathfn'}
	$t->{'pathft'}=$t->{'subdirft'}."\\FT" # ground subfolder and base filename.  Keep it shortish
	$t->{'blft'}="$$bindloadfile ".$t->{'pathat'}
	$t->{'pathfq'}=$t->{'subdirfq'}."\\FQ" # ground subfolder and base filename.  Keep it shortish
	$t->{'blfq'}="$$bindloadfile ".$t->{'pathfq'}
	$t->{'pathbo'}=$t->{'subdirbo'}."\\BO"  # Blastoff Fly subfolder and base filename
	$t->{'blbo'}="$$bindloadfile ".$t->{'pathbo'}
	$t->{'pathsd'}=$t->{'subdirsd'}."\\SD"  #  SetDown Fly Subfolder and base filename
	$t->{'blsd'}="$$bindloadfile ".$t->{'pathsd'}
	# $t->{'pathgbo'}=$t->{'subdirgbo'}."\\GBO"  # Blastoff Fly subfolder and base filename
	# $t->{'blgbo'}="$$bindloadfile ".$t->{'pathgbo'}
	# $t->{'pathgsd'}=$t->{'subdirgsd'}."\\GSD"  #  SetDown Fly Subfolder and base filename
	# $t->{'blgsd'}="$$bindloadfile ".$t->{'pathgsd'}

	if $SoD->{'Base'} then
		cbMakeDirectory($t->{'subdirg'})
		cbMakeDirectory($t->{'subdirar'})
		cbMakeDirectory($t->{'subdirfr'})
	end

	if $t->{'canhov'}+$t->{'canfly'}>0 then
		cbMakeDirectory($t->{'subdira'})
		cbMakeDirectory($t->{'subdiraf'})
		cbMakeDirectory($t->{'subdirff'})
		cbMakeDirectory($t->{'subdirbo'})
	end

	# if $t->{'canqfly'}>0 then
		# cbMakeDirectory($t->{'subdirq'})
		# cbMakeDirectory($t->{'subdiraq'})
		# cbMakeDirectory($t->{'subdirfq'})
	# end

	if $t->{'canjmp'}>0 then
		cbMakeDirectory($t->{'subdirj'})
		cbMakeDirectory($t->{'subdiraj'})
		cbMakeDirectory($t->{'subdirfj'})
	end

	if $t->{'canss'}>0 then
		cbMakeDirectory($t->{'subdirs'})
		cbMakeDirectory($t->{'subdiras'})
		cbMakeDirectory($t->{'subdirfs'})
	end
	
	# [[if $t->{'cangfly'}>0 then
		cbMakeDirectory($t->{'subdirga'})
		cbMakeDirectory($t->{'subdirgaf'})
		cbMakeDirectory($t->{'subdirgff'})
		cbMakeDirectory($t->{'subdirgbo'})
		cbMakeDirectory($t->{'subdirgsd'})
	end# ]]
	
	if $SoD->{'NonSoD'} or $t->{'canqfly'}>0 then
		cbMakeDirectory($t->{'subdirn'})
		cbMakeDirectory($t->{'subdiran'})
		cbMakeDirectory($t->{'subdirfn'})
	end
	
	if $SoD->{'Temp'}->{'Enable'} then
		cbMakeDirectory($t->{'subdirt'})
		cbMakeDirectory($t->{'subdirat'})
		cbMakeDirectory($t->{'subdirft'})
	end
	
	#  temporarily set $SoD->{'Default'} to "NonSoD"
	# $SoD->{'Default'} = "Base"
	#  set up the keys to be used.
	if $SoD->{'Default'} ~= "NonSoD" then $t->{'NonSoDModeKey'} = $SoD->{'NonSoDModeKey'} end
	if $SoD->{'Default'} ~= "Base" then $t->{'BaseModeKey'} = $SoD->{'BaseModeKey'} end
	if $SoD->{'Default'} ~= "Fly" then $t->{'FlyModeKey'} = $SoD->{'FlyModeKey'} end
	if $SoD->{'Default'} ~= "Jump" then $t->{'JumpModeKey'} = $SoD->{'JumpModeKey'} end
	if $SoD->{'Default'} ~= "Run" then $t->{'RunModeKey'} = $SoD->{'RunModeKey'} end
# 	if $SoD->{'Default'} ~= "GFly" then $t->{'GFlyModeKey'} = $SoD->{'GFlyModeKey'} end
	$t->{'TempModeKey'} = $SoD->{'TempModeKey'}
	$t->{'QFlyModeKey'} = $SoD->{'QFlyModeKey'}
	
	for space = 0, 1 do
		$t->{'space'}=space
		$t->{'up'} = "$$up ".space
		$t->{'upx'} = "$$up ".(1-space)
		for X = 0, 1 do
			$t->{'X'}=X
			$t->{'dow'} = "$$down ".X
			$t->{'dowx'} = "$$down ".(1-X)
			for W = 0, 1 do
				$t->{'W'}=W
				$t->{'forw'} = "$$forward ".W
				$t->{'forx'} = "$$forward ".(1-W)
				for S = 0, 1 do
					$t->{'S'}=S
					$t->{'bac'} = "$$backward ".S
					$t->{'bacx'} = "$$backward ".(1-S)
					for A = 0, 1 do
						$t->{'A'}=A
						$t->{'lef'} = "$$left ".A
						$t->{'lefx'} = "$$left ".(1-A)
						for D = 0, 1 do
							$t->{'D'}=D
							$t->{'rig'} = "$$right ".D
							$t->{'rigx'} = "$$right ".(1-D)

							$t->{'tkeys'}=space+X+W+S+A+D	# total number of keys down
							$t->{'horizkeys'}=W+S+A+D	# total # of horizontal move keys.	So Sprint isn't turned on when jumping
							$t->{'vertkeys'}=space+X
							$t->{'jkeys'} = $t->{'horizkeys'}+$t->{'space'}
							if $SoD->{'NonSoD'} or $t->{'canqfly'}>0 then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'NonSoDModeKey'}
								makeSoDFile(profile,t,$t->{'bln'},$t->{'blan'},$t->{'blfn'},$t->{'pathn'},$t->{'pathan'},$t->{'pathfn'},nil,nil,"NonSoD",nil)
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
							if $SoD->{'Base'} then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'BaseModeKey'}
								makeSoDFile(profile,t,$t->{'bl'},$t->{'blgr'},$t->{'blfr'},$t->{'path'},$t->{'pathgr'},$t->{'pathfr'},$t->{'sprint'},nil,"Base",nil)
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
							if $t->{'canss'}>0 then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'RunModeKey'}
								local sssj = nil
								if $SoD->{'SS'}->{'SSSJMode'} then sssj = $t->{'jump'} end
								if $SoD->{'SS'}->{'MobileOnly'} then
									makeSoDFile(profile,t,$t->{'bls'},$t->{'blas'},$t->{'blfs'},$t->{'paths'},$t->{'pathas'},$t->{'pathfs'},$t->{'speed'},nil,"Run",nil,nil,nil,nil,nil,nil,nil,sssj)
								else
									makeSoDFile(profile,t,$t->{'bls'},$t->{'blas'},$t->{'blfs'},$t->{'paths'},$t->{'pathas'},$t->{'pathfs'},$t->{'speed'},$t->{'speed'},"Run",nil,nil,nil,nil,nil,nil,nil,sssj)
								end
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
							if $t->{'canjmp'}>0 and not ($SoD->{'Jump'}->{'Simple'}) then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'JumpModeKey'}
								local jturnoff
								if $t->{'jump'} ~= $t->{'cjump'} then jturnoff = {$t->{'jumpifnocj'}} end
								makeSoDFile(profile,t,$t->{'blj'},$t->{'blaj'},$t->{'blfj'},$t->{'pathj'},$t->{'pathaj'},$t->{'pathfj'},$t->{'jump'},$t->{'cjmp'},"Jump","Jump",sodJumpFix,jturnoff)
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
							if $t->{'canhov'}+$t->{'canfly'}>0 then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'FlyModeKey'}
								makeSoDFile(profile,t,$t->{'bla'},$t->{'blaf'},$t->{'blff'},$t->{'patha'},$t->{'pathaf'},$t->{'pathff'},$t->{'flyx'},$t->{'hover'},"Fly","Fly",nil,nil,$t->{'pathbo'},$t->{'pathsd'},$t->{'blbo'},$t->{'blsd'})
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
							# if $t->{'canqfly'}>0 then
								# t[$SoD->{'Default'}."ModeKey"] = $t->{'QFlyModeKey'}
								# makeSoDFile(profile,t,$t->{'blq'},$t->{'blaq'},$t->{'blfq'},$t->{'pathq'},$t->{'pathaq'},$t->{'pathfq'},"Quantum Flight","Quantum Flight","QFly","Fly",nil,nil)
								# t[$SoD->{'Default'}."ModeKey"] = nil
							# end
							# [[if $t->{'cangfly'}>0 then
								t[$SoD->{'Default'}."ModeKey"] = $t->{'GFlyModeKey'}
								makeSoDFile(profile,t,$t->{'blga'},$t->{'blgaf'},$t->{'blgff'},$t->{'pathga'},$t->{'pathgaf'},$t->{'pathgff'},$t->{'gfly'},$t->{'gfly'},"GFly","GFly",nil,nil,$t->{'pathgbo'},$t->{'pathgsd'},$t->{'blgbo'},$t->{'blgsd'})
								t[$SoD->{'Default'}."ModeKey"] = nil
							end# ]]
							if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
								local trayslot = {trayslot = "1 ".$SoD->{'Temp'}->{'Tray'}}
								t[$SoD->{'Default'}."ModeKey"] = $t->{'TempModeKey'}
								makeSoDFile(profile,t,$t->{'blt'},$t->{'blat'},$t->{'blft'},$t->{'patht'},$t->{'pathat'},$t->{'pathft'},trayslot,trayslot,"Temp","Fly",nil,nil)
								t[$SoD->{'Default'}."ModeKey"] = nil
							end
						end
					end
				end
			end
		end
	end
	$t->{'space'}=0
	$t->{'X'}=0
	$t->{'W'}=0
	$t->{'S'}=0
	$t->{'A'}=0
	$t->{'D'}=0
	$t->{'up'} = "$$up ".$t->{'space'}
	$t->{'upx'} = "$$up ".(1-$t->{'space'})
	$t->{'dow'} = "$$down ".$t->{'X'}
	$t->{'dowx'} = "$$down ".(1-$t->{'X'})
	$t->{'forw'} = "$$forward ".$t->{'W'}
	$t->{'forx'} = "$$forward ".(1-$t->{'W'})
	$t->{'bac'} = "$$backward ".$t->{'S'}
	$t->{'bacx'} = "$$backward ".(1-$t->{'S'})
	$t->{'lef'} = "$$left ".$t->{'A'}
	$t->{'lefx'} = "$$left ".(1-$t->{'A'})
	$t->{'rig'} = "$$right ".$t->{'D'}
	$t->{'rigx'} = "$$right ".(1-$t->{'D'})
	
	if $SoD->{'TLeft'} and string.upper($SoD->{'TLeft'}) ~= "UNBOUND" then cbWriteBind(resetfile,$SoD->{'TLeft'},"+turnleft") end
	if $SoD->{'TRight'} and string.upper($SoD->{'TRight'}) ~= "UNBOUND" then cbWriteBind(resetfile,$SoD->{'TRight'},"+turnright") end
	
	if $SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'} then
		local temptogglefile1 = cbOpen($t->{'basepath'}."\\temptoggle1.txt","w")
		local temptogglefile2 = cbOpen($t->{'basepath'}."\\temptoggle2.txt","w")
		cbWriteBind(temptogglefile2,$SoD->{'Temp'}->{'TraySwitch'},"-down$$gototray 1"."$$bindloadfile ".$t->{'basepath'}."\\temptoggle1.txt")
		cbWriteBind(temptogglefile1,$SoD->{'Temp'}->{'TraySwitch'},"+down$$gototray ".$SoD->{'Temp'}->{'Tray'}."$$bindloadfile ".$t->{'basepath'}."\\temptoggle2.txt")
		cbWriteBind(resetfile,$SoD->{'Temp'}->{'TraySwitch'},"+down$$gototray ".$SoD->{'Temp'}->{'Tray'}."$$bindloadfile ".$t->{'basepath'}."\\temptoggle2.txt")
		temptogglefile1:close()
		temptogglefile2:close()
	end

	local dwarfTPPower, normalTPPower, teamTPPower
	if $profile->{'archetype'} == "Warshade" then
		dwarfTPPower = "powexecname Black Dwarf Step"
		normalTPPower = "powexecname Shadow Step"
	elseif $profile->{'archetype'} == "Peacebringer" then
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
	if ($profile->{'archetype'} == "Peacebringer") or ($profile->{'archetype'} == "Warshade") then
		if humanBindKey then
			cbWriteBind(resetfile,humanBindKey,humanpbind)
		end
	end
	#  kheldian form support #  create the Nova and Dwarf form support files if enabled.
	if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then
		cbWriteBind(resetfile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Nova'}->{'Nova'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.$t->{'on'}.$SoD->{'Nova'}->{'Nova'}."$$gototray ".$SoD->{'Nova'}->{'PowerTray'}."$$bindloadfile ".$t->{'basepath'}."\\nova.txt")
		local novafile = cbOpen($t->{'basepath'}."\\nova.txt","w")
		if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then
			cbWriteBind(novafile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Dwarf'}->{'Dwarf'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.$t->{'off'}.$SoD->{'Nova'}->{'Nova'}.$t->{'on'}.$SoD->{'Dwarf'}->{'Dwarf'}."$$gototray ".$SoD->{'Dwarf'}->{'PowerTray'}."$$bindloadfile ".$t->{'basepath'}."\\dwarf.txt")
		end
		if not humanBindKey then humanBindKey = $SoD->{'Nova'}->{'ModeKey'} end
		local humpower = ""
		if $SoD->{'UseHumanFormPower'} then humpower = "$$powexectoggleon ".$SoD->{'HumanFormShield'} end
		cbWriteBind(novafile,humanBindKey,"t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff ".$SoD->{'Nova'}->{'Nova'}.humpower."$$gototray 1$$bindloadfile ".$t->{'basepath'}."\\rese$t->{'txt'}")
		if humanBindKey == $SoD->{'Nova'}->{'ModeKey'} then humanBindKey = nil end
		if novapbind then
			cbWriteBind(novafile,$SoD->{'Nova'}->{'ModeKey'},novapbind)
		end
		if $t->{'canqfly'} then
			makeQFlyModeKey(profile,t,"r",novafile,$SoD->{'Nova'}->{'Nova'},"Nova")
		end

		cbWriteBind(novafile,$SoD->{'Forward'},"+forward")
		if $SoD->{'MouseChord'} then
			cbWriteBind(novafile,'mousechord "'."+down$$+forward")
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
		# cbWriteBind(novafile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Nova'}->{'Nova'}."$$gototray 1$$bindloadfile ".$t->{'basepath'}."\\rese$t->{'txt'}")
		novafile:close()
	end
	if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then
		cbWriteBind(resetfile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Dwarf'}->{'Dwarf'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleon '.$SoD->{'Dwarf'}->{'Dwarf'}."$$gototray ".$SoD->{'Dwarf'}->{'PowerTray'}."$$bindloadfile ".$t->{'basepath'}."\\dwarf.txt")
		local dwrffile = cbOpen($t->{'basepath'}."\\dwarf.txt","w")
		if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then
			cbWriteBind(dwrffile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Nova'}->{'Nova'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Dwarf'}->{'Dwarf'}.'$$powexectoggleon '.$SoD->{'Nova'}->{'Nova'}."$$gototray ".$SoD->{'Nova'}->{'PowerTray'}."$$bindloadfile ".$t->{'basepath'}."\\nova.txt")
		end
		if not humanBindKey then humanBindKey = $SoD->{'Dwarf'}->{'ModeKey'} end
		local humpower = ""
		if $SoD->{'UseHumanFormPower'} then humpower = "$$powexectoggleon ".$SoD->{'HumanFormShield'} end
		cbWriteBind(dwrffile,humanBindKey,"t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff ".$SoD->{'Dwarf'}->{'Dwarf'}.humpower."$$gototray 1$$bindloadfile ".$t->{'basepath'}."\\rese$t->{'txt'}")
		if dwarfpbind then
			cbWriteBind(dwrffile,$SoD->{'Dwarf'}->{'ModeKey'},dwarfpbind)
		end
		if $t->{'canqfly'} then
			makeQFlyModeKey(profile,t,"r",dwrffile,$SoD->{'Dwarf'}->{'Dwarf'},"Dwarf")
		end

		cbWriteBind(dwrffile,$SoD->{'Forward'},"+forward")
		if $SoD->{'MouseChord'} then
			cbWriteBind(dwrffile,'mousechord "'."+down$$+forward")
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
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'ComboKey'},'+down$$'.dwarfTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_on1.txt')
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'BindKey'},'nop')
			cbWriteBind(dwrffile,$SoD->{'TP'}->{'ResetKey'},string.sub($t->{'detailhi'},3,string.len($t->{'detailhi'})).$t->{'runcamdist'}.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_off.txt')
			#  Create tp directory
			cbMakeDirectory($t->{'basepath'}.'\\dtp')
			#  Create tp_off file
			local tp_off = cbOpen($t->{'basepath'}.'\\dtp\\tp_off.txt',"w")
			cbWriteBind(tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'.dwarfTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_on1.txt')
			cbWriteBind(tp_off,$SoD->{'TP'}->{'BindKey'},'nop')
			tp_off:close()
			local tp_on1 = cbOpen($t->{'basepath'}.'\\dtp\\tp_on1.txt',"w")
			cbWriteBind(tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'.$t->{'detailhi'}.$t->{'runcamdist'}.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_off.txt')
			cbWriteBind(tp_on1,$SoD->{'TP'}->{'BindKey'},'+down$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_on2.txt')
			tp_on1:close()
			local tp_on2 = cbOpen($t->{'basepath'}.'\\dtp\\tp_on2.txt',"w")
			cbWriteBind(tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'.dwarfTPPower.'$$bindloadfile '.$t->{'basepath'}.'\\dtp\\tp_on1.txt')
			tp_on2:close()
		end
		# cbWriteBind(dwrffile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Dwarf'}->{'Dwarf'}."$$gototray 1$$bindloadfile ".$t->{'basepath'}."\\rese$t->{'txt'}")
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
	if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} and not ($profile->{'Archetype'} == "Peacebringer") and normalTPPower then
		local tphovermodeswitch = ""
		if $t->{'tphover'} ~= "" then
			tphovermodeswitch = $t->{'bla'}."000000.txt"
		end
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ComboKey'},'+down$$'.normalTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_on1.txt')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'BindKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TP'}->{'ResetKey'},string.sub($t->{'detailhi'},3,string.len($t->{'detailhi'})).$t->{'runcamdist'}.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_off.txt'.tphovermodeswitch)
		#  Create tp directory
		cbMakeDirectory($t->{'basepath'}.'\\tp')
		#  Create tp_off file
		local tp_off = cbOpen($t->{'basepath'}.'\\tp\\tp_off.txt',"w")
		cbWriteBind(tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'.normalTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_on1.txt')
		cbWriteBind(tp_off,$SoD->{'TP'}->{'BindKey'},'nop')
		tp_off:close()
		local tp_on1 = cbOpen($t->{'basepath'}.'\\tp\\tp_on1.txt',"w")
		local zoomin = $t->{'detailhi'}.$t->{'runcamdist'}
		if $t->{'tphover'} then zoomin = "" end
		cbWriteBind(tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'.zoomin.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_off.txt'.tphovermodeswitch)
		cbWriteBind(tp_on1,$SoD->{'TP'}->{'BindKey'},'+down'.$t->{'tphover'}.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_on2.txt')
		tp_on1:close()
		local tp_on2 = cbOpen($t->{'basepath'}.'\\tp\\tp_on2.txt',"w")
		cbWriteBind(tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'.normalTPPower.'$$bindloadfile '.$t->{'basepath'}.'\\tp\\tp_on1.txt')
		tp_on2:close()
	end
	if $SoD->{'TTP'} and $SoD->{'TTP'}->{'Enable'} and not ($profile->{'Archetype'} == "Peacebringer") and teamTPPower then
		local tphovermodeswitch = ""
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'ComboKey'},'+down$$'.teamTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_on1.txt')
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'BindKey'},'nop')
		cbWriteBind(resetfile,$SoD->{'TTP'}->{'ResetKey'},string.sub($t->{'detailhi'},3,string.len($t->{'detailhi'})).$t->{'runcamdist'}.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_off.txt'.tphovermodeswitch)
		#  Create tp directory
		cbMakeDirectory($t->{'basepath'}.'\\ttp')
		#  Create tp_off file
		local ttp_off = cbOpen($t->{'basepath'}.'\\ttp\\ttp_off.txt',"w")
		cbWriteBind(ttp_off,$SoD->{'TTP'}->{'ComboKey'},'+down$$'.teamTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.windowhide.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_on1.txt')
		cbWriteBind(ttp_off,$SoD->{'TTP'}->{'BindKey'},'nop')
		ttp_off:close()
		local ttp_on1 = cbOpen($t->{'basepath'}.'\\ttp\\ttp_on1.txt',"w")
		cbWriteBind(ttp_on1,$SoD->{'TTP'}->{'ComboKey'},'-down$$powexecunqueue'.$t->{'detailhi'}.$t->{'runcamdist'}.windowshow.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_off.txt'.tphovermodeswitch)
		cbWriteBind(ttp_on1,$SoD->{'TTP'}->{'BindKey'},'+down'.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_on2.txt')
		ttp_on1:close()
		local ttp_on2 = cbOpen($t->{'basepath'}.'\\ttp\\ttp_on2.txt',"w")
		cbWriteBind(ttp_on2,$SoD->{'TTP'}->{'BindKey'},'-down$$'.teamTPPower.'$$bindloadfile '.$t->{'basepath'}.'\\ttp\\ttp_on1.txt')
		ttp_on2:close()
	end
	
end

function module.findconflicts(profile)
	local SoD = $profile->{'SoD'}
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
	if $SoD->{'Fly'}->{'QFly'} and ($profile->{'archetype'} == "Peacebringer") then cbCheckConflict(SoD,"QFlyModeKey","Q.Fly Mode Key") end
	if $SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} then
		cbCheckConflict($SoD->{'TP'},"ComboKey","TP ComboKey")
		cbCheckConflict($SoD->{'TP'},"ResetKey","TP ResetKey")
		local TPQuestion = "Teleport Bind"
		if $profile->{'archetype'} == "Peacebringer" then
			TPQuestion = "Dwarf Step Bind"
		elseif $profile->{'archetype'} == "Warshade" then
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
	if ($profile->{'archetype'} == "Peacebringer") or ($profile->{'archetype'} == "Warshade") then
		if $SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'} then cbCheckConflict($SoD->{'Nova'},"ModeKey","Nova Form Bind") end
		if $SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'} then cbCheckConflict($SoD->{'Dwarf'},"ModeKey","Dwarf Form Bind") end
	end
end

function module.bindisused(profile)
	if $profile->{'SoD'} == nil then return nil end
	return profile.$SoD->{'enable'}
end

cbAddModule(module,"Speed on Demand","Movement")

1;
