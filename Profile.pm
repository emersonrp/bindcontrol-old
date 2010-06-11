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
	PetSelectMinion => 'LALT-Z',
	PetSelectLieutenant => 'LALT-X',
	PetSelectBoss => 'LALT-C',
	PetBodyguard => 'LALT-G',
	PetAggressive => 'LALT-A',
	PetDefensive => 'LALT-S',
	PetPassive => 'LALT-D',
	PetAttack => 'LALT-Q',
	PetFollow => 'LALT-W',
	PetStay => 'LALT-E',
	PetGoto => 'LALT-LBUTTON',
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
