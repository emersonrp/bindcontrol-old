package Profile;
use strict;

# TODO - make this be like blaster/fire or something adequately generic.
our $defaults = {
	Archetype => 'Scrapper',
	Origin => "Magic",
	Primary => 'Martial Arts',
	Secondary => 'Super Reflexes',
	Epic => 'Weapon Mastery',
};

our $current = {};

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




sub fillPickers {
	# my ($self, $event) = @_;

	my $ArchData = $GameData::Archetypes->{$current->{'Archetype'}};

	my $aPicker = Wx::Window::FindWindowById(ProfileTabs::PICKER_ARCHETYPE);
	$aPicker->SetStringSelection($current->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(ProfileTabs::PICKER_ORIGIN);
	$oPicker->SetStringSelection($current->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(ProfileTabs::PICKER_PRIMARY);
	$pPicker->Clear();
	for (sort keys %{$ArchData->{'Primary'}}) { $pPicker->Append($_); }
	$pPicker->SetStringSelection($current->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(ProfileTabs::PICKER_SECONDARY);
	$sPicker->Clear();
	for (sort keys %{$ArchData->{'Secondary'}}) { $sPicker->Append($_); }
	$sPicker->SetStringSelection($current->{'Secondary'});

}




1;
