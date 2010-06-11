package Profile;
use strict;

use Utility qw(id);

# TODO - make this be like blaster/fire or something adequately generic.
our $default = {
	Archetype => 'Scrapper',
	Origin => "Magic",
	Primary => 'Martial Arts',
	Secondary => 'Super Reflexes',
	Epic => 'Weapon Mastery',

};

# TODO TODO TODO XXX -- eventually "current" should be loaded from a file or something
our $current = $default;
# TODO TODO TODO XXX -- eventually "current" should be loaded from a file or something

sub pickArchetype {
	my ($self, $event) = @_;
	$current->{'Archetype'} = $event->GetEventObject->GetValue;
	fillPickers();
}

sub pickOrigin { fillPickers(); }

sub pickPrimaryPowerSet {
	my ($self, $event) = @_;
	$current->{'Primary'} = $event->GetEventObject->GetValue;
	fillPickers();
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	$current->{'Secondary'} = $event->GetEventObject->GetValue;
	fillPickers();
}


use Wx 'wxNullBitmap';

sub fillPickers {
	# my ($self, $event) = @_;

	my $ArchData = $GameData::Archetypes->{$current->{'Archetype'}};

	my $aPicker = Wx::Window::FindWindowById(id('PICKER_ARCHETYPE'));
	$aPicker->SetStringSelection($current->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(id('PICKER_ORIGIN'));
	$oPicker->SetStringSelection($current->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(id('PICKER_PRIMARY'));
	$pPicker->Clear();
	for (sort keys %{$ArchData->{'Primary'}}) { $pPicker->Append($_, wxNullBitmap); }
	$pPicker->SetStringSelection($current->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(id('PICKER_SECONDARY'));
	$sPicker->Clear();
	for (sort keys %{$ArchData->{'Secondary'}}) { $sPicker->Append($_, wxNullBitmap); }
	$sPicker->SetStringSelection($current->{'Secondary'});

}

sub poolPowers { return {} }

1;
