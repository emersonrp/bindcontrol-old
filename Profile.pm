package Profile;
use strict;

# TODO - make this be like blaster/fire or something adequately generic.
our $default = {
	Archetype => 'Scrapper',
	Origin => "Magic",
	Primary => 'Martial Arts',
	Secondary => 'Super Reflexes',
	Epic => 'Weapon Mastery',

# Mastermind Binds
	PetSelectAll => 'LALT-V',
	PetSelectAllResponse => 'Orders?',
	PetSelectAllResponseMethod => 'Petsay',

	PetSelectMinions => 'LALT-Z',
	PetSelectMinionsResponse => 'Orders?',
	PetSelectMinionsResponseMethod => 'Petsay',

	PetSelectLieutenants => 'LALT-X',
	PetSelectLieutenantsResponse => 'Orders?',
	PetSelectLieutenantsResponseMethod => 'Petsay',

	PetSelectBoss => 'LALT-C',
	PetSelectBossResponse => 'Orders?',
	PetSelectBossResponseMethod => 'Petsay',

	PetBodyguard => 'LALT-G',
	PetBodyguardResponse => 'Bodyguarding.',
	PetBodyguardResponseMethod => 'Petsay',

	PetAggressive => 'LALT-A',
	PetAggressiveResponse => 'Kill On Sight.',
	PetAggressiveResponseMethod => 'Petsay',

	PetDefensive => 'LALT-S',
	PetDefensiveResponse => 'Return Fire Only.',
	PetDefensiveResponseMethod => 'Petsay',

	PetPassive => 'LALT-D',
	PetPassiveResponse => 'At Ease.',
	PetPassiveResponseMethod => 'Petsay',

	PetAttack => 'LALT-Q',
	PetAttackResponse => 'Open Fire!',
	PetAttackResponseMethod => 'Petsay',

	PetFollow => 'LALT-W',
	PetFollowResponse => 'Falling In.',
	PetFollowResponseMethod => 'Petsay',

	PetStay => 'LALT-E',
	PetStayResponse => 'Holding This Position',
	PetStayResponseMethod => 'Petsay',

	PetGoto => 'LALT-LBUTTON',
	PetGotoResponse => 'Moving To Checkpoint.',
	PetGotoResponseMethod => 'Petsay',

	PetBodyguardMode => 1,
	PetBodyguardAttack => '',
	PetBodyguardGoto => '',

	PetChatToggle => 'LALT-M',
	PetSelect1 => 'F1',
	PetSelect2 => 'F2',
	PetSelect3 => 'F3',
	PetSelect4 => 'F4',
	PetSelect5 => 'F5',
	PetSelect6 => 'F6',

	Pet1Name => 'Crow T Robot',
	Pet2Name => 'Tom Servo',
	Pet3Name => 'Cambot',
	Pet4Name => 'Gypsy',
	Pet5Name => 'Mike',
	Pet6Name => 'Joel',

	Pet2Bodyguard => 1,
	Pet5Bodyguard => 1,
};

# TODO TODO TODO XXX -- eventually "current" should be loaded from a file or something
our $current = $default;
# TODO TODO TODO XXX -- eventually "current" should be loaded from a file or something

sub pickArchetype {
	my ($self, $event) = @_;
	my $archetype = $event->GetString();
	$current->{'Archetype'} = $archetype;
	fillPickers($archetype);
}

sub pickPrimaryPowerSet {
	my ($self, $event) = @_;
	my $powerSet = $event->GetString();
	$current->{'Primary'} = $powerSet;
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	my $powerSet = $event->GetString();
	$current->{'Secondary'} = $powerSet;
}


use Wx 'wxNullBitmap';

sub fillPickers {
	# my ($self, $event) = @_;

	my $ArchData = $GameData::Archetypes->{$current->{'Archetype'}};

	my $aPicker = Wx::Window::FindWindowById(General::PICKER_ARCHETYPE);
	$aPicker->SetStringSelection($current->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(General::PICKER_ORIGIN);
	$oPicker->SetStringSelection($current->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(General::PICKER_PRIMARY);
	$pPicker->Clear();
	for (sort keys %{$ArchData->{'Primary'}}) { $pPicker->Append($_, wxNullBitmap); }
	$pPicker->SetStringSelection($current->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(General::PICKER_SECONDARY);
	$sPicker->Clear();
	for (sort keys %{$ArchData->{'Secondary'}}) { $sPicker->Append($_, wxNullBitmap); }
	$sPicker->SetStringSelection($current->{'Secondary'});

}


sub poolPowers { return {} }


1;
