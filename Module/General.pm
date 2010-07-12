# UI / logic for the 'general' panel
package Module::General;
use parent "Module::Module";

use strict;
use Wx qw();

use GameData;
use Utility qw(id);
use UI::ControlGroup;

our $ModuleName = 'General';

sub InitKeys {
	my $self = shift;

	$self->Profile->General ||= {
		'Archetype' => 'Scrapper',
		'Origin' => "Magic",
		'Primary Powerset' => 'Martial Arts',
		'Secondary Powerset' => 'Super Reflexes',
		'Epic Powerset' => 'Weapon Mastery',
		'Binds Directory' => "c:\\CoHTest\\",
		'Reset File' => $self->Profile->GetBindFile('reset.txt'),
		'Reset Key' => 'CTRL-M',
	};
}

sub FillTab {

	my $self = shift;
	my $General = $self->Profile->General;

	my $topSizer = UI::ControlGroup->new($self, 'Powers and Info');

	my $ArchData = $GameData::Archetypes->{$General->{'Archetype'}};

	$topSizer->AddLabeledControl({
		value => 'Name',
		type => 'text',
		parent => $self,
		module => $General,
	});
	$topSizer->AddLabeledControl({
		value => 'Archetype',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %$GameData::Archetypes],
		tooltip => '',
		callback => \&pickArchetype,
	});
	$topSizer->AddLabeledControl({
		value => 'Origin',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [@GameData::Origins],
		tooltip => '',
		callback => \&pickOrigin,
	});
	$topSizer->AddLabeledControl({
		value => 'Primary Powerset',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Primary Powerset'}}],
		tooltip => '',
		callback => \&pickPrimaryPowerSet,
	});
	$topSizer->AddLabeledControl({
		value => 'Secondary Powerset',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Secondary Powerset'}}],
		tooltip => '',
		callback => \&pickSecondaryPowerSet,
	});
	$topSizer->AddLabeledControl({
		value => 'Epic Powerset',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Epic Powerset'}}],
		tooltip => '',
		callback => \&pickEpicPowerSet,
	});
	$topSizer->AddLabeledControl({
		value => 'Power Pool 1',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$topSizer->AddLabeledControl({
		value => 'Power Pool 2',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$topSizer->AddLabeledControl({
		value => 'Power Pool 3',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$topSizer->AddLabeledControl({
		value => 'Power Pool 4',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$topSizer->AddLabeledControl({
		value => 'Binds Directory',
		type => 'dirpicker',
		parent => $self,
		module => $General,
	});
	$topSizer->AddLabeledControl({
		value => 'Reset Key',
		type => 'keybutton',
		parent => $self,
		module => $General,
		tooltip => 'This key is used by certain modules to reset binds to a sane state.',
	});

	$topSizer->AddLabeledControl({
		value => 'Reset Feedback',
		type => 'checkbox',
		parent => $self,
		module => $General,
	});


	$topSizer->Add( Wx::Button->new( $self, id('Write Binds Button'), 'Write Binds!' ), 0, Wx::wxALL|Wx::wxEXPAND);
	Wx::Event::EVT_BUTTON( $self, id('Write Binds Button'), sub { $self->Profile->WriteBindFiles() } );


	$self->TabTitle = 'General';
	$self->SetSizer($topSizer);
	return $self;
}

sub pickArchetype {
	my ($self, $event) = @_;
	$self->Profile->General->{'Archetype'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickOrigin { shift()->fillPickers; }

sub pickPrimaryPowerSet {
	my ($self, $event) = @_;
	$self->Profile->General->{'Primary Powerset'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	$self->Profile->General->{'Secondary Powerset'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickEpicPowerSet {
	my ($self, $event) = @_;
	$self->Profile->General->{'Epic Powerset'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub fillPickers {
	my $self = shift;

	my $g = $self->Profile->General;

	my $ArchData = $GameData::Archetypes->{$g->{'Archetype'}};
	my $aPicker = Wx::Window::FindWindowById(id('Archetype'));
	$aPicker->SetStringSelection($g->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(id('Origin'));
	$oPicker->SetStringSelection($g->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(id('Primary Powerset'));
	$pPicker->Clear();
	$pPicker->Append([sort keys %{$ArchData->{'Primary Powerset'}}]);
	$pPicker->SetStringSelection($g->{'Primary Powerset'}) or $pPicker->SetSelection(1);

	my $sPicker = Wx::Window::FindWindowById(id('Secondary Powerset'));
	$sPicker->Clear();
	$sPicker->Append([sort keys %{$ArchData->{'Secondary Powerset'}}]);
	$sPicker->SetStringSelection($g->{'Secondary Powerset'}) or $sPicker->SetSelection(1);

	my $ePicker = Wx::Window::FindWindowById(id('Epic Powerset'));
	$ePicker->Clear();
	$ePicker->Append([sort keys %{$ArchData->{'Epic Powerset'}}]);
	$ePicker->SetStringSelection($g->{'Epic Powerset'}) or $sPicker->SetSelection(1);

	for my $i (1..4) {
		my $ppPicker = Wx::Window::FindWindowById(id("Power Pool $i"));
		$ppPicker->Clear();
		$ppPicker->Append([sort keys %{$GameData::MiscPowers->{'Pool'}}]);
		$ppPicker->SetStringSelection($g->{"Power Pool $i"}) or $ppPicker->SetSelection(1);
	}
}

1;
