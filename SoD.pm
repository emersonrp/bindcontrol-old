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
	my $pathr = $params->{'pathr'};
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

	# TODO TODO TODO hmm what?
	# if $modestr == "QFly" then return end

	my $SoD = $Profile::SoD;
	my $curfile;

	# this wants to be $turnoff ||= $mobile, $stationary once we know what those are.  arrays?  hashes?
	# $turnoff ||= {mobile,stationary}

	if (($SoD->{'Default'} eq $modestr) and ($t->{'totalkeys'} == 0)) {

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

		# if ($modestr eq "Base") { makeBaseModeKey($profile,$t,"r",$curfile,$turnoff,$fix); }
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
		# if ($modestr eq "GFly") { makeGFlyModeKey($profile,$t,"gbo",$curfile,$turnoff,$fix); }
		# if ($modestr eq "Run") { makeRunModeKey($profile,$t,"s",$curfile,$turnoff,$fix); }
		# if ($modestr eq "Jump") { makeJumpModeKey($profile,$t,"j",$curfile,$turnoff,$path); }

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
		# if ($modestr eq "Base") { makeBaseModeKey($profile,$t,"r",$curfile,$turnoff,$fix); }
		# if ($modestr eq "Fly") { makeFlyModeKey($profile,$t,"a",$curfile,$turnoff,$fix); }
		# if ($modestr eq "GFly") { makeGFlyModeKey($profile,$t,"gbo",$curfile,$turnoff,$fix); }
		$t->{'ini'} = "";
		# if ($modestr eq "Jump") { makeJumpModeKey($profile,$t,"j",$curfile,$turnoff,$path); }

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
	$curfile = cbOpen($pathr.$t->{'space'} . XWSAD($t) . ".txt","w");

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
	if ($modestr eq "Jump")       { makeJumpModeKey  ($profile,$t,"aj",$curfile,$turnoff,$pathr); }
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

	my $feedback;
	my $SoD = $profile->{'SoD'};

	return if (not $t->{$keytype} or $t->{$keytype} eq "UNBOUND");

	my $key = $t->{$keytype};

	# fetch out some bits to make it more compact down there.
	my $txtend =  $t->{'space'} . XWSAD($t) . ".txt";
	my $jtxtend = $t->{'space'} . XWSAD($t) . "j.txt";
	my $ttxtend = $t->{'space'} . XWSAD($t) . ".$t->{'txt'}";
	my $qtxtend = $t->{'space'} . XWSAD($t) . "_q.txt";
	my $stxtend = $t->{'space'} . XWSAD($t) . "_s.txt";

	my $up = $t->{'up'};
	my $dow = $t->{'dow'};
	my $for = $t->{'forw'};
	my $bac = $t->{'bac'};
	my $lef = $t->{'lef'};
	my $rig = $t->{'rig'};

	my $blfn = $t->{'blfn'};

	my $dethi = $t->{'detailhi'};
	my $detlo = $t->{'detaillo'};
	my $runcam = $t->{'runcamdist'};
	my $flycam = $t->{'flycamdist'};

	my $ini = $t->{'ini'};

	# I'm gonna come right out and say that this is stupid
	my $bl = $t->{'bl'};
	my $blt = $t->{'blt'};
	my $bln = $t->{'bln'};
	my $blan = $t->{'blan'};
	my $blfn = $t->{'blfn'};
	my $blft = $t->{'blft'};
	my $blfr = $t->{'blfr'};
	my $blfs = $t->{'blfs'};
	my $blgr = $t->{'blgr'};
	my $bls = $t->{'bls'};
	my $blas = $t->{'blas'};
	my $blj = $t->{'blj'};
	my $blaj = $t->{'blaj'};
	my $blfj = $t->{'blfj'};
	my $blbo = $t->{'blbo'};
	my $blr = $t->{'blr'};
	my $blaf = $t->{'blaf'};
	my $blff = $t->{'blff'};
	my $blgbo = $t->{'blgbo'};
	my $blgaf = $t->{'blgaf'};
	my $blgff = $t->{'blgff'};

	my $sprint = $t->{'sprint'};
	my $speed = $t->{'speed'};
	my $flyx = $t->{'flyx'};

	my $pathat = $t->{'pathat'};
	my $pathan = $t->{'pathan'};
	my $pathn = $t->{'pathn'};
	my $pathas = $t->{'pathas'};

	if ($keytype eq 'NonSoDModeKey') {

		my $actpower = actPower_toggle(nil,true,nil,$turnoff);

		if (not $fb and $SoD->{'Feedback'}) { $feedback = '$$t $name, Non-SoD Mode'; }

		if ($bl eq"r") {
			my $bindload = $bln.$txtend;

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$for.$bac.$lef.$rig.$dethi.$runcam.$feedback.$bindload)
			}

		} elsif ($bl eq"ar") {

			my $bindload = $blan.$txtend;

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"a",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$dethi.$runcam.'$$up 0'.$dow.$lef.$rig.$feedback.$bindload)
			}
		} else {

			if ($fix) {
				&$fix($profile,$t,$key,&makeNonSoDModeKey,"n",$bl,$curfile,$turnoff,"f",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$dethi.$runcam.'$$up 0'.$feedback.$blfn.$txtend)
			}
		}
		$t->{'ini'} = "";
	} elsif ($keytype eq 'TempModeKey') {

		my $trayslot = "1 ".$SoD->{'Temp'}->{'Tray'};
		my $actpower = actPower(nil,true,$trayslot,$turnoff);

		if ($SoD->{'Feedback'}) { $feedback='$$t $name, Temp Mode' }

		if ($bl eq"r") {
			my $bindload = $blt.$txtend;
			cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$for.$bac.$lef.$rig.$detlo.$flycam.$feedback.$bindload);
		} elsif ($bl eq"ar") {
			my $bindload =   $pathat.$txtend;
			my $bl2 =        $pathat.$ttxtend;
			my $togglefile = cbOpen($bl2,"w");
			cbWriteToggleBind($curfile,$togglefile,$key,$ini.$actpower.$detlo.$flycam.'$$up 0'.$dow.$lef.$rig,$feedback,$bindload,$bl2);
			close $togglefile;
		} else {
			cbWriteBind($curfile,$key,$ini.$actpower.$detlo.$flycam.'$$up 0'.$feedback.$blft.$txtend);
		}
	} elsif ($keytype eq 'QFlyModeKey') {

		my $actpower = actPower_toggle(nil,true,"Quantum Flight",$turnoff);

		if ($modestr eq "NonSoD") { cbWriteBind($curfile,$t->{'QFlyModeKey'},"powexecname Quantum Flight"); return; }

		if ($SoD->{'Feedback'}) { $feedback='$$t $name, QFlight Mode'; }

		if ($bl eq "r") {
			my $bindload =   $pathn.$txtend;
			my $bl2 =        $pathn.$qtxtend;
			my $togglefile = cbOpen($bl2,"w");
			my $tray = ($modestr eq "Nova" or $modestr eq "Dwarf") ? '$$gototray 1' : '';
			cbWriteToggleBind($curfile,$togglefile,$key,$ini.$actpower.$tray.$up.$dow.$for.$bac.$lef.$rig.$detlo.$flycam,$feedback,$bindload,$bl2);
			close $togglefile;
		} elsif ($bl eq "ar") {
			my $bindload = $pathan.$txtend;
			my $bl2 = $pathan.$qtxtend;
			my $togglefile = cbOpen($bl2,"w");
			cbWriteToggleBind($curfile,$togglefile,$key,$ini.$actpower.$detlo.$flycam.'$$up 0'.$dow.$lef.$rig,$feedback,$bindload,$bl2);
			close $togglefile;
		} else {
			# my $bindload = $pathfn.$txtend;
			# my $bl2 = $pathfn.$qtxtend;
			# my $togglefile = cbOpen($bl2,"w");
			cbWriteBind($curfile,$t->{'QFlyModeKey'},$ini.$actpower.$detlo.$flycam.'$$up 0'.$feedback.$blfn.$txtend);
			# close $togglefile;
		}
	} elsif ($keytype eq 'BaseModeKey') {

		my $actpower = actPower_toggle(true,true,$sprint,$turnoff);

		if (not $fb and $SoD->{'Feedback'}) { $feedback='$$t $name, Sprint-SoD Mode' }
		if ($bl eq "r") {
			my $bindload = $bl.$txtend;
			my $turnon;
			# if ($t->{'horizkeys'} > 0) { $turnon = "+down".substr($t->{'on'},2).$sprint.$turnoff } else { $turnon = "+down" }
			if ($t->{'horizkeys'} <= 0) { $actpower = actPower_toggle(true,true,nil,$turnoff) }
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$for.$bac.$lef.$rig.$dethi.$runcam.$feedback.$bindload);
			}
		} elsif ($bl eq "ar") {
			my $bindload = $blgr.$txtend;
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"a",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$dethi.$runcam.'$$up 0'.$dow.$lef.$rig.$feedback.$bindload);
			}
		} else {
			if ($fix) {
				&$fix($profile,$t,$key,&makeBaseModeKey,"r",$bl,$curfile,$turnoff,"f",$feedback);
			} else {
				cbWriteBind($curfile,$key,$ini.$actpower.$dethi.$runcam.'$$up 0'.$feedback.$blfr.$txtend);
			}
		}
	} elsif ($keytype eq 'RunModeKey') {

		my $actpower = actPower_toggle(true,true,$speed,$turnoff);

		if (not $fb and $SoD->{'Feedback'}) { $feedback='$$t $name, Superspeed Mode' }
		if ($t->{'canss'} > 0) {
			if ($bl eq "s") {
				my $bindload = $bls.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$for.$bac.$lef.$rig.$detlo.$flycam.$feedback.$bindload);
				}
			} elsif ($bl eq "as") {
				my $bindload = $blas.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"a",$feedback);
				} elsif ($feedback == "") {
					cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$lef.$rig.$detlo.$flycam.$feedback.$bindload);
				} else {
					my $bindload = $pathas.$txtend;
					my $bl2 = $pathas.$stxtend;
					my $togglefile = cbOpen($bl2,"w");
					cbWriteToggleBind($curfile,$togglefile,$t->{'RunModeKey'},$ini.$actpower.$up.$dow.$lef.$rig.$detlo.$flycam,$feedback,$bindload,$bl2);
					close $togglefile;
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeRunModeKey,"s",$bl,$curfile,$turnoff,"f",$feedback);
				} else {
					cbWriteBind($curfile,$key,$ini.$actpower.'$$up 0'.$detlo.$flycam.$feedback.$blfs.$txtend);
				}
			}
		}
	} elsif ($keytype eq 'JumpModeKey') {

		my $actpower = actPower(nil,true,$t->{'jump'},$turnoff).'$$up 1';

		if ($t->{'canjmp'} > 0 and not $SoD->{'Jump'}->{'Simple'}) {

			if ($SoD->{'Feedback'}) { $feedback='$$t $name, Superjump Mode' }
			if ($bl eq "j") {
				my $bindload = $blj.$txtend;
				my $a;
				if (($t->{'horizkeys'} + $t->{'space'}) <= 0) { $actpower = actPower(nil,true,$t->{'cjmp'},$turnoff) }
				my $filename = $fbl.$jtxtend;
				my $togglefile = cbOpen($fbl.$jtxtend,"w");
				cbWriteBind($togglefile,$key,'-down'.$actpower.$detlo.$flycam.$bindload);
				close $togglefile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'$$bindloadfile '.$filename);
			} elsif ($bl eq "aj") {
				my $bindload = $blaj.$txtend;
				my $filename = $fbl.$jtxtend;
				my $togglefile = cbOpen($filename,"w");
				cbWriteBind($togglefile,$key,'-down'.$actpower.$detlo.$flycam.$dow.$lef.$rig.$bindload);
				close $togglefile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'$$bindloadfile '.$filename);
			} else {
				my $filename = $fbl.$jtxtend;
				my $togglefile = cbOpen($filename,"w");
				cbWriteBind($togglefile,$key,'-down'.$actpower.$detlo.$flycam.$blfj.$txtend);
				close $togglefile;
				cbWriteBind($curfile,$key,'+down'.$feedback.'$$bindloadfile '.$filename);
			}
		}
	} elsif ($keytype eq 'FlyModeKey') {

		my $actpower = actPower_toggle(true,true,$flyx,$turnoff);

		if (not $t->{'FlyModeKey'}) { error("invalid Fly Mode Key",2) }

		if (not $fb and $SoD->{'Feedback'}) { $feedback='$$t $name, Flight Mode' }
		if ($t->{'canhov'}+$t->{'canfly'} > 0) {
			if ($bl eq "bo") {
				my $bindload = $blbo.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,'+down$$'.$actpower.'$$up 1$$down 0'.$for.$bac.$lef.$rig.$detlo.$flycam.$feedback.$bindload);
				}
			} elsif ($bl eq "a") {
				if (not $fb_on_a) { $feedback = "" }
				my $bindload = $blr.$txtend;
				if ($t->{'totalkeys'} == 0) { $actpower = actPower_toggle(true,true,$t->{'hover'},$turnoff); }
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"",$feedback);
				} else {
					cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$lef.$rig.$detlo.$flycam.$feedback.$bindload);
				}
			} elsif ($bl eq "af") {
				my $bindload = $blaf.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"a",$feedback);
				} else {
					cbWriteBind($curfile,$key,$ini.$actpower.$detlo.$flycam.$dow.$lef.$rig.$feedback.$bindload);
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeFlyModeKey,"f",$bl,$curfile,$turnoff,"f",$feedback);
				} else {
					cbWriteBind($curfile,$key,$ini.$actpower.$up.$dow.$for.$bac.$lef.$rig.$detlo.$flycam.$feedback.$blff.$txtend);
				}
			}
		}
	} elsif ($keytype eq 'GFlyModeKey') {

		my $actpower = actPower_toggle(nil,true,$t->{'gfly'},$turnoff);

		if ($t->{'cangfly'} > 0) {
			if ($bl eq "gbo") {
				my $bindload = $blgbo.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"");
				} else {
					cbWriteBind($curfile,$key,$ini.'$$up 1$$down 0'.$actpower.$for.$bac.$lef.$rig.$detlo.$flycam.$bindload);
				}
			} elsif ($bl eq "gaf") {
				my $bindload = $blgaf.$txtend;
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"a");
				} else {
					cbWriteBind($curfile,$key,$ini.$detlo.$flycam.$up.$dow.$lef.$rig.$bindload);
				}
			} else {
				if ($fix) {
					&$fix($profile,$t,$key,&makeGFlyModeKey,"gf",$bl,$curfile,$turnoff,"f");
				} else {
					if ($bl eq "gf") {
						cbWriteBind($curfile,$key,$ini.$actpower.$detlo.$flycam.$blgff.$txtend);
					} else {
						cbWriteBind($curfile,$key,$ini.$detlo.$flycam.$blgff.$txtend);
					}
				}
			}
		}
	}
	$t->{'ini'} = "";
}


sub iupMessage { print STDERR "ZOMG SOMEBODY IMPLEMENT A WARNING DIALOG!!!\n"; }

sub makebind {
	my $profile = shift;
	my $resetfile = $profile->{'resetfile'};
	my $SoD = $profile->{'SoD'};

	# cbWriteBind($resetfile,petselec$t->{'sel5'} . ' "petselect 5')
	if ($SoD->{'Default'} eq "NonSoD") {
		if (not $SoD->{'NonSoD'}) { iupMessage("Notice","Enabling NonSoD mode, since it is set as your default mode.") }
		$SoD->{'NonSoD'} = true;
	}
	if ($SoD->{'Default'} eq "Base" and not $SoD->{'Base'}) {
		iupMessage("Notice","Enabling NonSoD mode and making it the default, since Sprint SoD, your previous Default mode, is not enabled.");
		$SoD->{'NonSoD'} = true;
		$SoD->{'Default'} = "NonSoD";
	}
	if ($SoD->{'Default'} eq "Fly" and not ($SoD->{'Fly'}->{'Hover'} or $SoD->{'Fly'}->{'Fly'})) {
		iupMessage("Notice","Enabling NonSoD mode and making it the default, since Flight SoD, your previous Default mode, is not enabled.");
		$SoD->{'NonSoD'} = true;
		$SoD->{'Default'} = "NonSoD";
	}
	if ($SoD->{'Default'} eq "Jump" and not ($SoD->{'Jump'}->{'CJ'} or $SoD->{'Jump'}->{'SJ'})) {
		iupMessage("Notice","Enabling NonSoD mode and making it the default, since Superjump SoD, your previous Default mode, is not enabled.");
		$SoD->{'NonSoD'} = true;
		$SoD->{'Default'} = "NonSoD";
	}
	if ($SoD->{'Default'} eq "Run" and $SoD->{'Run'}->{'PrimaryNumber'} == 1) {
		iupMessage("Notice","Enabling NonSoD mode and making it the default, since Superspeed SoD, your previous Default mode, is not enabled.");
		$SoD->{'NonSoD'} = true;
		$SoD->{'Default'} = "NonSoD";
	}

	my $t = {
		sprint => "",
		speed => "",
		hover => "",
		fly => "",
		flyx => "",
		jump => "",
		cjmp => "",
		canhov => 0,
		canfly => 0,
		canqfly => 0,
		cangfly => 0,
		cancj => 0,
		canjmp => 0,
		canss => 0,
		tphover => "",
		ttpgrpfly => "",
		on => '$$powexectoggleon ',
		# on => '$$powexecname ',
		off => '$$powexectoggleoff ',
		mlon => "",
		mloff => "",
		runcamdist => "",
		flycamdist => "",
		detailhi => "",
		detaillo => "",
	};

	if ($SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'} == nil) {
		$t->{'cancj'} = 1;
		$t->{'cjmp'} = "Combat Jumping";
		$t->{'jump'} = "Combat Jumping";
	}
	if ($SoD->{'Jump'}->{'CJ'} == nil and $SoD->{'Jump'}->{'SJ'}) {
		$t->{'canjmp'} = 1;
		$t->{'jump'} = "Super Jump";
		$t->{'jumpifnocj'} = "Super Jump";
	}
	if ($SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'}) {
		$t->{'cancj'} = 1;
		$t->{'canjmp'} = 1;
		$t->{'cjmp'} = "Combat Jumping";
		$t->{'jump'} = "Super Jump";
	}
	if ($profile->{'archetype'} eq "Peacebringer") {
		if ($SoD->{'Fly'}->{'Hover'}) {
			$t->{'canhov'} = 1;
			$t->{'canfly'} = 1;
			$t->{'hover'} = "Combat Flight";
			$t->{'fly'} = "Energy Flight";
			$t->{'flyx'} = "Energy Flight";
		 } else {
			$t->{'canfly'} = 1;
			$t->{'hover'} = "Energy Flight";
			$t->{'flyx'} = "Energy Flight";
		}
	 } elsif (not ($profile->{'archetype'} eq "Warshade")) {
		if ($SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'} == nil) {
			$t->{'canhov'} = 1;
			$t->{'hover'} = "Hover";
			$t->{'flyx'} = "Hover";
			if ($SoD->{'TP'}->{'TPHover'}) { $t->{'tphover'} = '$$powexectoggleon Hover' }
		}
		if ($SoD->{'Fly'}->{'Hover'} == nil and $SoD->{'Fly'}->{'Fly'}) {
			$t->{'canfly'} = 1;
			$t->{'hover'} = "Fly";
			$t->{'flyx'} = "Fly";
		}
		if ($SoD->{'Fly'}->{'Hover'} and $SoD->{'Fly'}->{'Fly'}) {
			$t->{'canhov'} = 1;
			$t->{'canfly'} = 1;
			$t->{'hover'} = "Hover";
			$t->{'fly'} = "Fly";
			$t->{'flyx'} = "Fly";
			if ($SoD->{'TP'}->{'TPHover'}) { $t->{'tphover'} = '$$powexectoggleon Hover' }
		}
	}
	if (($profile->{'archetype'} eq "Peacebringer") and $SoD->{'Fly'}->{'QFly'}) {
		$t->{'canqfly'} = 1;
	}
	# if ($SoD->{'Fly'}->{'GFly'}) {
		# $t->{'cangfly'} = 1;
		# $t->{'gfly'} = "Group Fly";
		# if ($SoD->{'TTP'}->{'TPGFly'}) { $t->{'ttpgfly'} = '$$powexectoggleon Group Fly' }
	# } else {
	# }
	if ($SoD->{'Run'}->{'PrimaryNumber'} == 1) {
		$t->{'sprint'} = $SoD->{'Run'}->{'Secondary'};
		$t->{'speed'} = $SoD->{'Run'}->{'Secondary'};
	} else {
		$t->{'sprint'} = $SoD->{'Run'}->{'Secondary'};
		$t->{'speed'} = $SoD->{'Run'}->{'Primary'};
		$t->{'canss'} = 1;
	}
	$t->{'unqueue'} = $SoD->{'Unqueue'} ? '$$powexecunqueue' : "";
	$t->{'unqueue'} = "";
	if ($SoD->{'AutoMouseLook'}) {
		$t->{'mlon'} = '$$mouselook 1';
		$t->{'mloff'} = '$$mouselook 0';
	}
	if ($SoD->{'Run'}->{'UseCamdist'}) {
		$t->{'runcamdist'} = '$$camdist '.$SoD->{'Run'}->{'Camdist'};
	}
	if ($SoD->{'Fly'}->{'UseCamdist'}) {
		$t->{'flycamdist'} = '$$camdist '.$SoD->{'Fly'}->{'Camdist'};
	}
	if ($SoD->{'Detail'} and $SoD->{'Detail'}->{'Enable'}) {
		$t->{'detailhi'} = '$$visscale '.$SoD->{'Detail'}->{'NormalAmt'}.'$$shadowvol 0$$ss 0';
		$t->{'detaillo'} = '$$visscale '.$SoD->{'Detail'}->{'MovingAmt'}.'$$shadowvol 0$$ss 0';
	}

	my $windowhide = $SoD->{'TP'}->{'HideWindows'} ? '$$windowhide health$$windowhide chat$$windowhide target$$windowhide tray' : '';
	my $windowshow = $SoD->{'TP'}->{'HideWindows'} ? '$$show health$$show chat$$show target$$show tray' : '';

	# ZOMG wtb foreach kthx
	for (qw( R F J S N T Q GA AR AF AJ AS GAF AN AT AQ FR FF FJ FS GFF FN FT FQ BO SD GBO GSD )) {

		my $sdname = 'subdir' . lc $_;
		my $pathname = 'path' . lc $_;
		$t->{$sdname} = "$Profile::basepath\\$_";
		$t->{$pathname} = "$t->{$sdname}\\$_";
		$t->{'bl' . lc $_} = '$$bindloadfile ' . $t->{$pathname};

	}

	# my $turn="+zoomin$$-zoomin"  # a non functioning bind used only to activate the keydown/keyup functions of +commands;
	$t->{'turn'}="+down";  # a non functioning bind used only to activate the keydown/keyup functions of +commands;
	
	if ($SoD->{'Base'}) {
		cbMakeDirectory($t->{'subdirr'});
		cbMakeDirectory($t->{'subdirar'});
		cbMakeDirectory($t->{'subdirfr'});
	}

	if ($t->{'canhov'}+$t->{'canfly'}>0) {
		cbMakeDirectory($t->{'subdirf'});
		cbMakeDirectory($t->{'subdiraf'});
		cbMakeDirectory($t->{'subdirff'});
		cbMakeDirectory($t->{'subdirbo'});
	}

	# if ($t->{'canqfly'}>0) {
		# cbMakeDirectory($t->{'subdirq'});
		# cbMakeDirectory($t->{'subdiraq'});
		# cbMakeDirectory($t->{'subdirfq'});
	# }

	if ($t->{'canjmp'}>0) {
		cbMakeDirectory($t->{'subdirj'});
		cbMakeDirectory($t->{'subdiraj'});
		cbMakeDirectory($t->{'subdirfj'});
	}

	if ($t->{'canss'}>0) {
		cbMakeDirectory($t->{'subdirs'});
		cbMakeDirectory($t->{'subdiras'});
		cbMakeDirectory($t->{'subdirfs'});
	}
	
	# [[if ($t->{'cangfly'}>0) {
	#	cbMakeDirectory($t->{'subdirga'});
	#	cbMakeDirectory($t->{'subdirgaf'});
	#	cbMakeDirectory($t->{'subdirgff'});
	#	cbMakeDirectory($t->{'subdirgbo'});
	#	cbMakeDirectory($t->{'subdirgsd'});
	#} ]]
	
	if ($SoD->{'NonSoD'} or $t->{'canqfly'} > 0) {
		cbMakeDirectory($t->{'subdirn'});
		cbMakeDirectory($t->{'subdiran'});
		cbMakeDirectory($t->{'subdirfn'});
	}
	
	if ($SoD->{'Temp'}->{'Enable'}) {
		cbMakeDirectory($t->{'subdirt'});
		cbMakeDirectory($t->{'subdirat'});
		cbMakeDirectory($t->{'subdirft'});
	}
	
	#  temporarily set $SoD->{'Default'} to "NonSoD"
	# $SoD->{'Default'} = "Base"
	#  set up the keys to be used.
	if ($SoD->{'Default'} eq "NonSoD") { $t->{'NonSoDModeKey'} = $SoD->{'NonSoDModeKey'} }
	if ($SoD->{'Default'} eq "Base") { $t->{'BaseModeKey'} = $SoD->{'BaseModeKey'} }
	if ($SoD->{'Default'} eq "Fly") { $t->{'FlyModeKey'} = $SoD->{'FlyModeKey'} }
	if ($SoD->{'Default'} eq "Jump") { $t->{'JumpModeKey'} = $SoD->{'JumpModeKey'} }
	if ($SoD->{'Default'} eq "Run") { $t->{'RunModeKey'} = $SoD->{'RunModeKey'} }
# 	if ($SoD->{'Default'} eq "GFly") { $t->{'GFlyModeKey'} = $SoD->{'GFlyModeKey'} }
	$t->{'TempModeKey'} = $SoD->{'TempModeKey'};
	$t->{'QFlyModeKey'} = $SoD->{'QFlyModeKey'};
	
	for my $space (0..1) {
		$t->{'space'} = $space;
		$t->{'up'} = '$$up '.$space;
		$t->{'upx'} = '$$up '.(1-$space);

		for my $X (0..1) {
			$t->{'X'} = $X;
			$t->{'dow'} = '$$down '.$X;
			$t->{'dowx'} = '$$down '.(1-$X);

			for my $W (0..1) {
				$t->{'W'} = $W;
				$t->{'forw'} = '$$forward '.$W;
				$t->{'forx'} = '$$forward '.(1-$W);

				for my $S (0..1) {
					$t->{'S'} = $S;
					$t->{'bac'} = '$$backward '.$S;
					$t->{'bacx'} = '$$backward '.(1-$S);

					for my $A (0..1) {
						$t->{'A'} = $A;
						$t->{'lef'} = '$$left '.$A;
						$t->{'lefx'} = '$$left '.(1-$A);

						for my $D (0..1) {
							$t->{'D'} = $D;
							$t->{'rig'} = '$$right '.$D;
							$t->{'rigx'} = '$$right '.(1-$D);

							$t->{'totalkeys'} = $space+$X+$W+$S+$A+$D;	# total number of keys down
							$t->{'horizkeys'} = $W+$S+$A+$D;	# total # of horizontal move keys.	So Sprint isn't turned on when jumping
							$t->{'vertkeys'} = $space+$X;
							$t->{'jkeys'} = $t->{'horizkeys'}+$t->{'space'};

							if ($SoD->{'NonSoD'} or $t->{'canqfly'}) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'NonSoDModeKey'};
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'bln'},
									bla => $t->{'blan'},
									blf => $t->{'blfn'},
									path => $t->{'pathn'},
									pathr => $t->{'pathan'},
									pathf => $t->{'pathfn'},
									modestr => "NonSoD",
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
							if ($SoD->{'Base'}) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'BaseModeKey'};
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'bl'},
									bla => $t->{'blgr'},
									blf => $t->{'blfr'},
									path => $t->{'pathr'},
									pathr => $t->{'pathgr'},
									pathf => $t->{'pathfr'},
									mobile => $t->{'sprint'},
									modestr => "Base",
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
							if ($t->{'canss'}>0) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'RunModeKey'};
								my $sssj = nil;
								if ($SoD->{'SS'}->{'SSSJMode'}) { $sssj = $t->{'jump'} }
								if ($SoD->{'SS'}->{'MobileOnly'}) {
									makeSoDFile({
										profile => $profile,
										t => $t,
										bl => $t->{'bls'},
										bla => $t->{'blas'},
										blf => $t->{'blfs'},
										path => $t->{'paths'},
										pathr => $t->{'pathas'},
										pathf => $t->{'pathfs'},
										mobile => $t->{'speed'},
										modestr => "Run",
										sssj => $sssj,
									});
								 } else {
									makeSoDFile({
										profile => $profile,
										t => $t,
										bl => $t->{'bls'},
										bla => $t->{'blas'},
										blf => $t->{'blfs'},
										path => $t->{'paths'},
										pathr => $t->{'pathas'},
										pathf => $t->{'pathfs'},
										mobile => $t->{'speed'},
										stationary => $t->{'speed'},
										modestr => "Run",
										sssj => $sssj,
									});
								}
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
							if ($t->{'canjmp'}>0 and not ($SoD->{'Jump'}->{'Simple'})) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'JumpModeKey'};
								my $jturnoff;
								if ($t->{'jump'} eq $t->{'cjump'}) { $jturnoff = {$t->{'jumpifnocj'}} }
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'blj'},
									bla => $t->{'blaj'},
									blf => $t->{'blfj'},
									path => $t->{'pathj'},
									pathr => $t->{'pathaj'},
									pathf => $t->{'pathfj'},
									mobile => $t->{'jump'},
									stationary => $t->{'cjmp'},
									modestr => "Jump",
									flight => "Jump",
									fix => &sodJumpFix,
									turnoff => $jturnoff,
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
							if ($t->{'canhov'}+$t->{'canfly'}>0) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'FlyModeKey'};
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'blr'},
									bla => $t->{'blaf'},
									blf => $t->{'blff'},
									path => $t->{'pathr'},
									pathr => $t->{'pathaf'},
									pathf => $t->{'pathff'},
									mobile => $t->{'flyx'},
									stationary => $t->{'hover'},
									modestr => "Fly",
									flight => "Fly",
									pathbo => $t->{'pathbo'},
									pathsd => $t->{'pathsd'},
									blbo => $t->{'blbo'},
									blsd => $t->{'blsd'},
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
							# if ($t->{'canqfly'}>0) {
								# $t->{$SoD->{'Default'}."ModeKey"} = $t->{'QFlyModeKey'};
								# makeSoDFile({
								# 	profile => $profile,
								# 	t => $t,
								# 	bl => $t->{'blq'},
								# 	bla => $t->{'blaq'},
								# 	blf => $t->{'blfq'},
								# 	path => $t->{'pathq'},
								# 	pathr => $t->{'pathaq'},
								# 	pathf => $t->{'pathfq'},
								# 	mobile => "Quantum Flight",
								# 	stationary => "Quantum Flight",
								# 	modestr => "QFly",
								# 	flight => "Fly",
								# });
								# $t->{$SoD->{'Default'}."ModeKey"} = nil;
							# }
							# [[if ($t->{'cangfly'}>0) {
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'GFlyModeKey'};
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'blga'},
									bla => $t->{'blgaf'},
									blf => $t->{'blgff'},
									path => $t->{'pathga'},
									pathr => $t->{'pathgaf'},
									pathf => $t->{'pathgff'},
									mobile => $t->{'gfly'},
									stationary => $t->{'gfly'},
									modestr => "GFly",
									flight => "GFly",
									pathbo => $t->{'pathgbo'},
									pathsd => $t->{'pathgsd'},
									blbo => $t->{'blgbo'},
									blsd => $t->{'blgsd'},
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							#} ]]
							if ($SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'}) {
								my $trayslot = "1 ".$SoD->{'Temp'}->{'Tray'};
								$t->{$SoD->{'Default'}."ModeKey"} = $t->{'TempModeKey'};
								makeSoDFile({
									profile => $profile,
									t => $t,
									bl => $t->{'blt'},
									bla => $t->{'blat'},
									blf => $t->{'blft'},
									path => $t->{'patht'},
									pathr => $t->{'pathat'},
									pathf => $t->{'pathft'},
									mobile => $trayslot,
									stationary => $trayslot,
									modestr => "Temp",
									flight => "Fly",
								});
								$t->{$SoD->{'Default'}."ModeKey"} = nil;
							}
						}
					}
				}
			}
		}
	}
	$t->{'space'} = 0;
	$t->{'X'} = 0;
	$t->{'W'} = 0;
	$t->{'S'} = 0;
	$t->{'A'} = 0;
	$t->{'D'} = 0;
	$t->{'up'} = '$$up '.$t->{'space'};
	$t->{'upx'} = '$$up '.(1-$t->{'space'});
	$t->{'dow'} = '$$down '.$t->{'X'};
	$t->{'dowx'} = '$$down '.(1-$t->{'X'});
	$t->{'forw'} = '$$forward '.$t->{'W'};
	$t->{'forx'} = '$$forward '.(1-$t->{'W'});
	$t->{'bac'} = '$$backward '.$t->{'S'};
	$t->{'bacx'} = '$$backward '.(1-$t->{'S'});
	$t->{'lef'} = '$$left '.$t->{'A'};
	$t->{'lefx'} = '$$left '.(1-$t->{'A'});
	$t->{'rig'} = '$$right '.$t->{'D'};
	$t->{'rigx'} = '$$right '.(1-$t->{'D'});
	
	if ($SoD->{'TLeft'} and uc $SoD->{'TLeft'} eq "UNBOUND") { cbWriteBind($resetfile,$SoD->{'TLeft'},"+turnleft") }
	if ($SoD->{'TRight'} and uc $SoD->{'TRight'} eq "UNBOUND") { cbWriteBind($resetfile,$SoD->{'TRight'},"+turnright") }
	
	if ($SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'}) {
		my $temptogglefile1 = cbOpen($Profile::basepath."\\temptoggle1.txt","w");
		my $temptogglefile2 = cbOpen($Profile::basepath."\\temptoggle2.txt","w");
		cbWriteBind($temptogglefile2,$SoD->{'Temp'}->{'TraySwitch'},'-down$$gototray 1'.'$$bindloadfile '.$Profile::basepath."\\temptoggle1.txt");
		cbWriteBind($temptogglefile1,$SoD->{'Temp'}->{'TraySwitch'},'+down$$gototray '.$SoD->{'Temp'}->{'Tray'}.'$$bindloadfile '.$Profile::basepath."\\temptoggle2.txt");
		cbWriteBind($resetfile,$SoD->{'Temp'}->{'TraySwitch'},'+down$$gototray '.$SoD->{'Temp'}->{'Tray'}.'$$bindloadfile '.$Profile::basepath."\\temptoggle2.txt");
		close $temptogglefile1;
		close $temptogglefile2;
	}

	my ($dwarfTPPower, $normalTPPower, $teamTPPower);
	if ($profile->{'archetype'} eq "Warshade") {
		$dwarfTPPower = "powexecname Black Dwarf Step";
		$normalTPPower = "powexecname Shadow Step";
	 } elsif ($profile->{'archetype'} eq "Peacebringer") {
		$dwarfTPPower = "powexecname White Dwarf Step";
	 } else {
		$normalTPPower = "powexecname Teleport";
		$teamTPPower = "powexecname Team Teleport";
	}

	my ($dwarfpbind, $novapbind, $humanpbind, $humanBindKey);
	if ($SoD->{'Human'} and $SoD->{'Human'}->{'Enable'}) {
		$humanBindKey = $SoD->{'Human'}->{'ModeKey'};
		$humanpbind = cbPBindToString($SoD->{'Human'}->{'HumanPBind'},$profile);
		$novapbind = cbPBindToString($SoD->{'Human'}->{'NovaPBind'},$profile);
		$dwarfpbind = cbPBindToString($SoD->{'Human'}->{'DwarfPBind'},$profile);
	}
	if (($profile->{'archetype'} eq "Peacebringer") or ($profile->{'archetype'} eq "Warshade")) {
		if ($humanBindKey) {
			cbWriteBind($resetfile,$humanBindKey,$humanpbind);
		}
	}
	#  kheldian form support #  create the Nova and Dwarf form support files if enabled.
	if ($SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'}) {
		cbWriteBind($resetfile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Nova'}->{'Nova'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.$t->{'on'}.$SoD->{'Nova'}->{'Nova'}.'$$gototray '.$SoD->{'Nova'}->{'PowerTray'}.'$$bindloadfile '.$Profile::basepath."\\nova.txt");
		my $novafile = cbOpen($Profile::basepath."\\nova.txt","w");
		if ($SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'}) {
			cbWriteBind($novafile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Dwarf'}->{'Dwarf'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0'.$t->{'off'}.$SoD->{'Nova'}->{'Nova'}.$t->{'on'}.$SoD->{'Dwarf'}->{'Dwarf'}.'$$gototray '.$SoD->{'Dwarf'}->{'PowerTray'}.'$$bindloadfile '.$Profile::basepath."\\dwarf.txt");
		}
		$humanBindKey ||= $SoD->{'Nova'}->{'ModeKey'};
		my $humpower = "";
		if ($SoD->{'UseHumanFormPower'}) { $humpower = '$$powexectoggleon '.$SoD->{'HumanFormShield'} }
		cbWriteBind($novafile,$humanBindKey,'t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Nova'}->{'Nova'}.$humpower.'$$gototray 1$$bindloadfile '.$Profile::basepath."\\rese$t->{'txt'}");
		if ($humanBindKey eq $SoD->{'Nova'}->{'ModeKey'}) { $humanBindKey = nil }
		if ($novapbind) {
			cbWriteBind($novafile,$SoD->{'Nova'}->{'ModeKey'},$novapbind);
		}
		if ($t->{'canqfly'}) {
			makeQFlyModeKey($profile,$t,"r",$novafile,$SoD->{'Nova'}->{'Nova'},"Nova");
		}

		cbWriteBind($novafile,$SoD->{'Forward'},"+forward");
		if ($SoD->{'MouseChord'}) {
			cbWriteBind($novafile,'mousechord "'."+down$$+forward");
		}
		cbWriteBind($novafile,$SoD->{'Left'},"+left");
		cbWriteBind($novafile,$SoD->{'Right'},"+right");
		cbWriteBind($novafile,$SoD->{'Back'},"+backward");
		cbWriteBind($novafile,$SoD->{'Up'},"+up");
		cbWriteBind($novafile,$SoD->{'Down'},"+down");
		cbWriteBind($novafile,$SoD->{'AutoRunKey'},"++forward");
		cbWriteBind($novafile,$SoD->{'FlyModeKey'},'nop');
		if (not ($SoD->{'FlyModeKey'} eq $SoD->{'RunModeKey'})) {
			cbWriteBind($novafile,$SoD->{'RunModeKey'},'nop');
		}
		if ($SoD->{'TP'} and $SoD->{'TP'}->{'Enable'}) {
			cbWriteBind($novafile,$SoD->{'TP'}->{'ComboKey'},'nop');
			cbWriteBind($novafile,$SoD->{'TP'}->{'BindKey'},'nop');
			cbWriteBind($novafile,$SoD->{'TP'}->{'ResetKey'},'nop');
		}
		cbWriteBind($novafile,$SoD->{'FollowKey'},"follow");
		# cbWriteBind($novafile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Nova'}->{'Nova'}.'$$gototray 1$$bindloadfile '.$Profile::basepath."\\rese$t->{'txt'}")
		close $novafile;
	}
	if ($SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'}) {
		cbWriteBind($resetfile,$SoD->{'Dwarf'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Dwarf'}->{'Dwarf'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleon '.$SoD->{'Dwarf'}->{'Dwarf'}.'$$gototray '.$SoD->{'Dwarf'}->{'PowerTray'}.'$$bindloadfile '.$Profile::basepath."\\dwarf.txt");
		my $dwrffile = cbOpen($Profile::basepath."\\dwarf.txt","w");
		if ($SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'}) {
			cbWriteBind($dwrffile,$SoD->{'Nova'}->{'ModeKey'},'t $name, Changing to '.$SoD->{'Nova'}->{'Nova'}.' Form$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Dwarf'}->{'Dwarf'}.'$$powexectoggleon '.$SoD->{'Nova'}->{'Nova'}.'$$gototray '.$SoD->{'Nova'}->{'PowerTray'}.'$$bindloadfile '.$Profile::basepath."\\nova.txt");
		}
		if (not $humanBindKey) { $humanBindKey = $SoD->{'Dwarf'}->{'ModeKey'} }
		my $humpower = "";
		if ($SoD->{'UseHumanFormPower'}) { $humpower = '$$powexectoggleon '.$SoD->{'HumanFormShield'} }
		cbWriteBind($dwrffile,$humanBindKey,'t $name, Changing to Human Form, SoD Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Dwarf'}->{'Dwarf'}.$humpower.'$$gototray 1$$bindloadfile '.$Profile::basepath."\\rese$t->{'txt'}");
		if ($dwarfpbind) {
			cbWriteBind($dwrffile,$SoD->{'Dwarf'}->{'ModeKey'},$dwarfpbind);
		}
		if ($t->{'canqfly'}) {
			makeQFlyModeKey($profile,$t,"r",$dwrffile,$SoD->{'Dwarf'}->{'Dwarf'},"Dwarf");
		}

		cbWriteBind($dwrffile,$SoD->{'Forward'},"+forward");
		if ($SoD->{'MouseChord'}) {
			cbWriteBind($dwrffile,'mousechord "'."+down$$+forward");
		}
		cbWriteBind($dwrffile,$SoD->{'Left'},"+left");
		cbWriteBind($dwrffile,$SoD->{'Right'},"+right");
		cbWriteBind($dwrffile,$SoD->{'Back'},"+backward");
		cbWriteBind($dwrffile,$SoD->{'Up'},"+up");
		cbWriteBind($dwrffile,$SoD->{'Down'},"+down");
		cbWriteBind($dwrffile,$SoD->{'AutoRunKey'},"++forward");
		cbWriteBind($dwrffile,$SoD->{'FlyModeKey'},'nop');
		if (not ($SoD->{'FlyModeKey'} eq $SoD->{'RunModeKey'})) {
			cbWriteBind($dwrffile,$SoD->{'RunModeKey'},'nop');
		}
		cbWriteBind($dwrffile,$SoD->{'FollowKey'},"follow");
		if ($SoD->{'TP'} and $SoD->{'TP'}->{'Enable'}) {
			cbWriteBind($dwrffile,$SoD->{'TP'}->{'ComboKey'},'+down$$'.$dwarfTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_on1.txt');
			cbWriteBind($dwrffile,$SoD->{'TP'}->{'BindKey'},'nop');
			cbWriteBind($dwrffile,$SoD->{'TP'}->{'ResetKey'},substr($t->{'detailhi'},2).$t->{'runcamdist'}.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_off.txt');
			#  Create tp directory
			cbMakeDirectory($Profile::basepath.'\\dtp');
			#  Create tp_off file
			my $tp_off = cbOpen($Profile::basepath.'\\dtp\\tp_off.txt',"w");
			cbWriteBind($tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'.$dwarfTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_on1.txt');
			cbWriteBind($tp_off,$SoD->{'TP'}->{'BindKey'},'nop');
			close $tp_off;
			my $tp_on1 = cbOpen($Profile::basepath.'\\dtp\\tp_on1.txt',"w");
			cbWriteBind($tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'.$t->{'detailhi'}.$t->{'runcamdist'}.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_off.txt');
			cbWriteBind($tp_on1,$SoD->{'TP'}->{'BindKey'},'+down$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_on2.txt');
			close $tp_on1;
			my $tp_on2 = cbOpen($Profile::basepath.'\\dtp\\tp_on2.txt',"w");
			cbWriteBind($tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'.$dwarfTPPower.'$$bindloadfile '.$Profile::basepath.'\\dtp\\tp_on1.txt');
			close $tp_on2;
		}
		# cbWriteBind($dwrffile,$SoD->{'ToggleKey'},'t $name, Changing to Human Form, Normal Mode$$up 0$$down 0$$forward 0$$backward 0$$left 0$$right 0$$powexectoggleoff '.$SoD->{'Dwarf'}->{'Dwarf'}.'$$gototray 1$$bindloadfile '.$Profile::basepath."\\rese$t->{'txt'}");
		close $dwrffile;
	}

	if ($SoD->{'Jump'}->{'Simple'}) {
		if ($SoD->{'Jump'}->{'CJ'} and $SoD->{'Jump'}->{'SJ'}) {
			cbWriteBind($resetfile,$SoD->{'JumpModeKey'},'powexecname Super Jump$$powexecname Combat Jumping');
		 } elsif ($SoD->{'Jump'}->{'SJ'}) {
			cbWriteBind($resetfile,$SoD->{'JumpModeKey'},'powexecname Super Jump');
		 } elsif ($SoD->{'Jump'}->{'CJ'}) {
			cbWriteBind($resetfile,$SoD->{'JumpModeKey'},'powexecname Combat Jumping');
		}
	}

	if ($SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} and not $normalTPPower) {
		cbWriteBind($resetfile,$SoD->{'TP'}->{'ComboKey'},'nop');
		cbWriteBind($resetfile,$SoD->{'TP'}->{'BindKey'},'nop');
		cbWriteBind($resetfile,$SoD->{'TP'}->{'ResetKey'},'nop');
	}
	if ($SoD->{'TP'} and $SoD->{'TP'}->{'Enable'} and not ($profile->{'Archetype'} eq "Peacebringer") and $normalTPPower) {
		my $tphovermodeswitch = "";
		if ($t->{'tphover'} eq "") {
			$tphovermodeswitch = $t->{'blr'}."000000.txt";
		}
		cbWriteBind($resetfile,$SoD->{'TP'}->{'ComboKey'},'+down$$'.$normalTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_on1.txt');
		cbWriteBind($resetfile,$SoD->{'TP'}->{'BindKey'},'nop');
		cbWriteBind($resetfile,$SoD->{'TP'}->{'ResetKey'},substr($t->{'detailhi'},2).$t->{'runcamdist'}.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_off.txt'.$tphovermodeswitch);
		#  Create tp directory
		cbMakeDirectory($Profile::basepath.'\\tp');
		#  Create tp_off file
		my $tp_off = cbOpen($Profile::basepath.'\\tp\\tp_off.txt',"w");
		cbWriteBind($tp_off,$SoD->{'TP'}->{'ComboKey'},'+down$$'.$normalTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_on1.txt');
		cbWriteBind($tp_off,$SoD->{'TP'}->{'BindKey'},'nop');
		close $tp_off;
		my $tp_on1 = cbOpen($Profile::basepath.'\\tp\\tp_on1.txt',"w");
		my $zoomin = $t->{'detailhi'}.$t->{'runcamdist'};
		if ($t->{'tphover'}) { $zoomin = "" }
		cbWriteBind($tp_on1,$SoD->{'TP'}->{'ComboKey'},'-down$$powexecunqueue'.$zoomin.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_off.txt'.$tphovermodeswitch);
		cbWriteBind($tp_on1,$SoD->{'TP'}->{'BindKey'},'+down'.$t->{'tphover'}.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_on2.txt');
		close $tp_on1;
		my $tp_on2 = cbOpen($Profile::basepath.'\\tp\\tp_on2.txt',"w");
		cbWriteBind($tp_on2,$SoD->{'TP'}->{'BindKey'},'-down$$'.$normalTPPower.'$$bindloadfile '.$Profile::basepath.'\\tp\\tp_on1.txt');
		close $tp_on2;
	}
	if ($SoD->{'TTP'} and $SoD->{'TTP'}->{'Enable'} and not ($profile->{'Archetype'} eq "Peacebringer") and $teamTPPower) {
		my $tphovermodeswitch = "";
		cbWriteBind($resetfile,$SoD->{'TTP'}->{'ComboKey'},'+down$$'.$teamTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_on1.txt');
		cbWriteBind($resetfile,$SoD->{'TTP'}->{'BindKey'},'nop');
		cbWriteBind($resetfile,$SoD->{'TTP'}->{'ResetKey'},substr($t->{'detailhi'},2).$t->{'runcamdist'}.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_off.txt'.$tphovermodeswitch);
		#  Create tp directory
		cbMakeDirectory($Profile::basepath.'\\ttp');
		#  Create tp_off file
		my $ttp_off = cbOpen($Profile::basepath.'\\ttp\\ttp_off.txt',"w");
		cbWriteBind($ttp_off,$SoD->{'TTP'}->{'ComboKey'},'+down$$'.$teamTPPower.$t->{'detaillo'}.$t->{'flycamdist'}.$windowhide.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_on1.txt');
		cbWriteBind($ttp_off,$SoD->{'TTP'}->{'BindKey'},'nop');
		close $ttp_off;
		my $ttp_on1 = cbOpen($Profile::basepath.'\\ttp\\ttp_on1.txt',"w");
		cbWriteBind($ttp_on1,$SoD->{'TTP'}->{'ComboKey'},'-down$$powexecunqueue'.$t->{'detailhi'}.$t->{'runcamdist'}.$windowshow.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_off.txt'.$tphovermodeswitch);
		cbWriteBind($ttp_on1,$SoD->{'TTP'}->{'BindKey'},'+down'.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_on2.txt');
		close $ttp_on1;
		my $ttp_on2 = cbOpen($Profile::basepath.'\\ttp\\ttp_on2.txt',"w");
		cbWriteBind($ttp_on2,$SoD->{'TTP'}->{'BindKey'},'-down$$'.$teamTPPower.'$$bindloadfile '.$Profile::basepath.'\\ttp\\ttp_on1.txt');
		close $ttp_on2;
	}
}


1;
__DATA__
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
	if ($SoD->{'NonSoD'}) { cbCheckConflict(SoD,"NonSoDModeKey","NonSoD Key") }
	if ($SoD->{'Base'}) { cbCheckConflict(SoD,"BaseModeKey","Sprint Mode Key") }
	if ($SoD->{'SS'}->{'SS'}) { cbCheckConflict(SoD,"RunModeKey","Speed Mode Key") }
	if ($SoD->{'Jump'}->{'CJ'} or $SoD->{'Jump'}->{'SJ'}) { cbCheckConflict(SoD,"JumpModeKey","Jump Mode Key") }
	if ($SoD->{'Fly'}->{'Hover'} or $SoD->{'Fly'}->{'Fly'}) { cbCheckConflict(SoD,"FlyModeKey","Fly Mode Key") }
	if ($SoD->{'Fly'}->{'QFly'} and ($profile->{'archetype'} eq "Peacebringer")) { cbCheckConflict(SoD,"QFlyModeKey","Q.Fly Mode Key") }
	if ($SoD->{'TP'} and $SoD->{'TP'}->{'Enable'}) {
		cbCheckConflict($SoD->{'TP'},"ComboKey","TP ComboKey")
		cbCheckConflict($SoD->{'TP'},"ResetKey","TP ResetKey")
		local TPQuestion = "Teleport Bind"
		if ($profile->{'archetype'} eq "Peacebringer") {
			TPQuestion = "Dwarf Step Bind"
		 } elsif ($profile->{'archetype'} eq "Warshade") {
			TPQuestion = "Shd/Dwf Step Bind"
		}
		cbCheckConflict($SoD->{'TP'},"BindKey",TPQuestion)
	}
	if ($SoD->{'Fly'}->{'GFly'}) { cbCheckConflict(SoD,"GFlyModeKey","Group Fly Key") }
	if ($SoD->{'TTP'} and $SoD->{'TTP'}->{'Enable'}) {
		cbCheckConflict($SoD->{'TTP'},"ComboKey","TTP ComboKey")
		cbCheckConflict($SoD->{'TTP'},"ResetKey","TTP ResetKey")
		cbCheckConflict($SoD->{'TTP'},"BindKey","Team TP Bind")
	}
	if ($SoD->{'Temp'} and $SoD->{'Temp'}->{'Enable'}) {
		cbCheckConflict(SoD,"TempModeKey","Temp Mode Key")
		cbCheckConflict($SoD->{'Temp'},"TraySwitch","Tray Toggle Key")
	}
	if ($profile->{'archetype'} eq "Peacebringer") or ($profile->{'archetype'} eq "Warshade")) {
		if ($SoD->{'Nova'} and $SoD->{'Nova'}->{'Enable'}) { cbCheckConflict($SoD->{'Nova'},"ModeKey","Nova Form Bind") }
		if ($SoD->{'Dwarf'} and $SoD->{'Dwarf'}->{'Enable'}) { cbCheckConflict($SoD->{'Dwarf'},"ModeKey","Dwarf Form Bind") }
	}
end


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
						if w.trayslot eq traytest then
							s = s."$$powexectray ".w.trayslot
							unq = true
						end
					else
						offpower[w] = true
						s = s."$$powexectoggleoff ".w
					end
				end
			end
			if v.trayslot and v.trayslot eq traytest then
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
			if not (v == "") and v eq on then
				s = s."$$powexecname ".v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w eq on then
					if type(w) == "table" then
						if w.trayslot eq traytest then
							s = s."$$powexectray ".w.trayslot
						end
					else
						s = s."$$powexecname ".w
					end
				end
			end
			if v.trayslot and v.trayslot eq traytest then
				s = s."$$powexectray ".v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on eq "" then
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
			if not (v == "") and v eq on then
				s = s."$$powexecname ".v
			end
		elseif type(v) == "table" then
			for j,w in ipairs(v) do
				if not (w == "") and w eq on then
					if type(w) == "table" then
						if w.trayslot eq traytest then
							s = s."$$powexectray ".w.trayslot
						end
					else
						s = s."$$powexecname ".w
					end
				end
			end
			if v.trayslot and v.trayslot eq traytest then
				s = s."$$powexectray ".v.trayslot
			end
		end
	end
	if unq and not (s == "") then
		s = s."$$powexecunqueue"
	end
	if type(on)=="boolean" then error("boolean",2) end
	if on and on eq "" then
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
function sodJumpFix(profile,$t,key,makeModeKey,suffix,bl,curfile,$turnoff,autofollowmode,feedback)
	local filename=t["path".autofollowmode."j"].$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.suffix.".txt"
	local tglfile = cbOpen(filename,"w")
	$t->{'ini'} = "-down$$"
	makeModeKey(profile,$t,bl,$tglfile,$turnoff,nil,$true)
	tglfile:close()
	cbWriteBind(curfile,key,"+down".feedback.actPower(nil,true,$t->{'cjmp'}).'$$bindloadfile '.filename)
end

function sodSetDownFix(profile,$t,key,makeModeKey,suffix,bl,curfile,$turnoff,autofollowmode,feedback)
	local pathsuffix = "f"
	if autofollowmode == "" then pathsuffix = "a" end
	# iupMessage("",tostring($t->{'space'}).tostring($t->{'X'}).tostring($t->{'W'}).tostring($t->{'S'}).tostring($t->{'A'}).tostring($t->{'D'}).tostring("path".autofollowmode.pathsuffix).tostring(suffix))
	local filename=t["path".autofollowmode.pathsuffix].$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.suffix.".txt"
	local tglfile = cbOpen(filename,"w")
	$t->{'ini'} = "-down$$"
	makeModeKey(profile,$t,bl,$tglfile,$turnoff,nil,true)
	tglfile:close()
	cbWriteBind(curfile,key,'+down'.feedback.'$$bindloadfile '.filename)
end

function sodResetKey(curfile,profile,path,$turnoff,moddir)
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

function sodUpKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,$sssj)
	local ml# , aj
	local upx, dow, forw, bac, lef, rig = $t->{'upx'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
	if not flight and not $sssj then mobile = nil stationary = nil end
	if bo == "bo" then upx = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then upx = "$$up 0" dow = "$$down 1" end
	
	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'totalkeys'} == 1 and $t->{'space'} == 1 then upx="$$up 0" else upx="$$up 1" end
		if $t->{'X'} == 1 then upx="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary  then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if $t->{'totalkeys'} == 1 and $t->{'space'} == 1 then
		ml = $t->{'mloff'}
		if not stationary and mobile eq stationary  then
			toggleoff = mobile
		end
		toggleon = stationary
	else
		toggleoff = nil
	end
	
	local toggleoff2 = nil
	if $sssj then
		if $t->{'space'} == 0 then #  if we are hitting the space bar rather than releasing its..
			toggleon = $sssj
			toggleoff = mobile
			if stationary and stationary eq mobile then
				toggleoff2 = stationary
			end
		elseif $t->{'space'} == 1 then #  if we are releasing the space bar ..
			toggleoff = $sssj
			if $t->{'horizkeys'} > 0 or autorun then #  and we are moving laterally, or in autorun..
				toggleon = mobile
			else #  otherwise turn on the stationary power..
				toggleon = stationary
			end
		end
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff,$toggleoff2)
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
		if not $sssj then toggle = "" end #  returns the following line to the way it was before $sssj
		cbWriteBind(curfile,$SoD->{'Up'},ini.upx.dow."$$backward 0".lef.rig.toggle.$t->{'mlon'}.bindload)
	end
end

function sodDownKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,$sssj)
	local ml# , aj
	local up, dowx, forw, bac, lef, rig = $t->{'up'}, $t->{'dowx'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
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
		if $t->{'X'} == 1 and $t->{'totalkeys'} > 1 then up="$$up 1" else up="$$up 0" end
	end

	toggleon = mobile
	if actkeys == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary then
			toggleoff = stationary
		end
	else
		toggleon = nil
	end

	if $t->{'totalkeys'} == 1 and $t->{'X'} == 1 then
		ml = $t->{'mloff'}
		if not stationary and mobile eq stationary  then
			toggleoff = mobile
		end
		toggleon = stationary
	else
		toggleoff = nil
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff)
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

function sodForwardKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,$sssj)
	local ml
	local up, dow, forx, bac, lef, rig = $t->{'up'}, $t->{'dow'}, $t->{'forx'}, $t->{'bac'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'totalkeys'} == 1 and $t->{'W'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'totalkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'totalkeys'} == 1 and $t->{'W'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'W'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'totalkeys'} == 1 and $t->{'W'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if $sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = $sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff)
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
			if $t->{'W'}eq1 then move = ini.up.dow.forx.bac.rig.lef end
			cbWriteBind(curfile,'mousechord',move.bindload)
		end
	elseif not autorunbl then
		cbWriteBind(curfile,$SoD->{'Forward'},ini.up.dow.forx.bac.lef.rig.ml.toggle.bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini.up.dow.forx.bac.rig.lef.ml.toggle.bindload)
		end
	else
		if $t->{'W'} eq 1 then
			bindload = autorunbl.$t->{'space'}.$t->{'X'}.(1-$t->{'W'}).$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
		end
		cbWriteBind(curfile,$SoD->{'Forward'},ini.up.dow.'$$forward 1$$backward 0'.lef.rig.$t->{'mlon'}.bindload)
		if $SoD->{'MouseChord'} then
			cbWriteBind(curfile,'mousechord',ini.up.dow.'$$forward 1$$backward 0'.rig.lef.$t->{'mlon'}.bindload)
		end
	end
end

function sodBackKey(t,bl,curfile,SoD,mobile,stationary,flight,autorunbl,followbl,bo,$sssj)
	local ml
	local up, dow, forw, bacx, lef, rig = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bacx'}, $t->{'lef'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'totalkeys'} == 1 and $t->{'S'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'totalkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'totalkeys'} == 1 and $t->{'S'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'S'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'totalkeys'} == 1 and $t->{'S'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if $sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = $sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff)
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

function sodLeftKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,$sssj)
	local ml
	local up, dow, forw, bac, lefx, rig = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lefx'}, $t->{'rig'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'totalkeys'} == 1 and $t->{'A'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'totalkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'totalkeys'} == 1 and $t->{'A'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'A'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'totalkeys'} == 1 and $t->{'A'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if $sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = $sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff)
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

function sodRightKey(t,bl,curfile,SoD,mobile,stationary,flight,autorun,followbl,bo,$sssj)
	local ml
	local up, dow, forw, bac, lef, rigx = $t->{'up'}, $t->{'dow'}, $t->{'forw'}, $t->{'bac'}, $t->{'lef'}, $t->{'rigx'}
	local toggle=""
	local toggleon
	local toggleoff
	local actkeys = $t->{'totalkeys'}
	if bo == "bo" then up = "$$up 1" dow = "$$down 0" end
	if bo == "sd" then up = "$$up 0" dow = "$$down 1" end

	if mobile == "Group Fly" then mobile = nil end
	if stationary == "Group Fly" then stationary = nil end

	if flight == "Jump" then
		dow = "$$down 0"
		actkeys = $t->{'jkeys'}
		if $t->{'totalkeys'} == 1 and $t->{'D'} == 1 then up="$$up 0" else up="$$up 1" end
		if $t->{'X'} == 1 then up="$$up 0" end
	end

	toggleon = mobile
	if $t->{'totalkeys'} == 0 then
		ml = $t->{'mlon'}
		toggleon = mobile
		if not mobile and mobile eq stationary  then
			toggleoff = stationary
		end
	end
		
	if $t->{'totalkeys'} == 1 and $t->{'D'} == 1 then
		ml = $t->{'mloff'}
	end
		
	if not flight then
		if $t->{'horizkeys'} == 1 and $t->{'D'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	else
		if $t->{'totalkeys'} == 1 and $t->{'D'} == 1 then
			if not stationary and mobile eq stationary  then
				toggleoff = mobile
			end
			toggleon = stationary
		end
	end

	if $sssj and $t->{'space'} == 1 then #  if we are jumping with SS+SJ mode enabled
		toggleon = $sssj
		toggleoff = mobile
	end
	
	if toggleon or toggleoff then
		toggle = actPower(nil,true,$toggleon,$toggleoff)
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

function sodAutoRunKey(t,bl,curfile,SoD,mobile,$sssj)
	local bindload
	bindload = bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt"
	if $sssj and $t->{'space'} == 1 then
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'.$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'mlon'}.actPower(nil,true,$sssj,mobile).bindload)
	else
		cbWriteBind(curfile,$SoD->{'AutoRunKey'},'forward 1$$backward 0'.$t->{'up'}.$t->{'dow'}.$t->{'lef'}.$t->{'rig'}.$t->{'mlon'}.actPower(nil,true,mobile).bindload)
	end
end

function sodAutoRunOffKey(t,bl,curfile,SoD,mobile,stationary,flight,$sssj)
	local toggleon=""
	local toggleoff
	if $sssj and $t->{'space'} == 1 then toggleoff = mobile mobile = $sssj end
	if not flight and not $sssj then
		if $t->{'horizkeys'} > 0 then
			toggleon=$t->{'mlon'}.actPower(nil,true,mobile)
		else
			toggleon=$t->{'mloff'}.actPower(nil,true,stationary,mobile)
		end
	elseif $sssj then
		if $t->{'horizkeys'} > 0 or $t->{'space'} == 1 then
			toggleon=$t->{'mlon'}.actPower(nil,true,mobile,$toggleoff)
		else
			toggleon=$t->{'mloff'}.actPower(nil,true,stationary,mobile,$toggleoff)
		end
	else
		if $t->{'totalkeys'} > 0 then
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
			if stationary eq mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	else
		if $t->{'totalkeys'}==0 then
			if stationary eq mobile then
				toggle = actPower(nil,true,stationary,mobile)
			else
				toggle = actPower(nil,true,stationary)
			end
		end
	end
	cbWriteBind(curfile,$SoD->{'FollowKey'},"follow".toggle.$t->{'up'}.$t->{'dow'}.$t->{'forw'}.$t->{'bac'}.$t->{'lef'}.$t->{'rig'}.bl.$t->{'space'}.$t->{'X'}.$t->{'W'}.$t->{'S'}.$t->{'A'}.$t->{'D'}.".txt")
end

function module.bindisused(profile)
	if $profile->{'SoD'} == nil then return nil end
	return profile.$SoD->{'enable'}
end

cbAddModule(module,"Speed on Demand","Movement")

1;
