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
		Name => '',
		Archetype => 'Scrapper',
		Origin => "Magic",
		Primary => 'Martial Arts',
		Secondary => 'Super Reflexes',
		Epic => 'Weapon Mastery',
		BindsDir => "c:\\CoHTest\\",
		ResetFile => $self->Profile->GetBindFile('reset.txt'),
		ResetKey => 'CTRL-M',
		ResetFeedback => 1,
		Pool1 => '',
		Pool2 => '',
		Pool3 => '',
		Pool4 => '',
	};
}

sub FillTab {

	my $self = shift;
	my $General = $self->Profile->General;

	my $ArchData = $GameData::Archetypes->{$General->{'Archetype'}};

	my $topSizer = Wx::BoxSizer->new(Wx::wxVERTICAL);

	my $powersBox = UI::ControlGroup->new($self, 'Powers and Info');
	$powersBox->AddLabeledControl({
		value => 'Name',
		type => 'text',
		parent => $self,
		module => $General,
	});
	$powersBox->AddLabeledControl({
		value => 'Archetype',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %$GameData::Archetypes],
		tooltip => '',
		callback => \&pickArchetype,
	});
	$powersBox->AddLabeledControl({
		value => 'Origin',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [@GameData::Origins],
		tooltip => '',
		callback => \&pickOrigin,
	});
	$powersBox->AddLabeledControl({
		value => 'Primary',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Primary'}}],
		tooltip => '',
		callback => \&pickPrimaryPowerSet,
	});
	$powersBox->AddLabeledControl({
		value => 'Secondary',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Secondary'}}],
		tooltip => '',
		callback => \&pickSecondaryPowerSet,
	});
	$powersBox->AddLabeledControl({
		value => 'Epic',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$ArchData->{'Epic'}}],
		tooltip => '',
		callback => \&pickEpicPowerSet,
	});
	$powersBox->AddLabeledControl({
		value => 'Pool1',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$powersBox->AddLabeledControl({
		value => 'Pool2',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$powersBox->AddLabeledControl({
		value => 'Pool3',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$powersBox->AddLabeledControl({
		value => 'Pool4',
		type => 'combo',
		parent => $self,
		module => $General,
		contents => [sort keys %{$GameData::MiscPowers->{'Pool'}}],
		tooltip => '',
		callback => \&pickPoolPower,
	});
	$powersBox->AddLabeledControl({
		value => 'BindsDir',
		type => 'dirpicker',
		parent => $self,
		module => $General,
	});
	$powersBox->AddLabeledControl({
		value => 'ResetKey',
		type => 'keybutton',
		parent => $self,
		module => $General,
		tooltip => 'This key is used by certain modules to reset binds to a sane state.',
	});

	$powersBox->AddLabeledControl({
		value => 'ResetFeedback',
		type => 'checkbox',
		parent => $self,
		module => $General,
	});


	$powersBox->Add( Wx::Button->new( $self, id('Write Binds Button'), 'Write Binds!' ), 0, Wx::wxALL);
	Wx::Event::EVT_BUTTON( $self, id('Write Binds Button'), sub { $self->Profile->WriteBindFiles() } );

	$topSizer->Add($powersBox);
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
	$self->Profile->General->{'Primary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	$self->Profile->General->{'Secondary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickEpicPowerSet {
	my ($self, $event) = @_;
	$self->Profile->General->{'Epic'} = $event->GetEventObject->GetValue;
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

	my $pPicker = Wx::Window::FindWindowById(id('Primary'));
	$pPicker->Clear();
	$pPicker->Append([sort keys %{$ArchData->{'Primary'}}]);
	$pPicker->SetStringSelection($g->{'Primary'}) or $pPicker->SetSelection(1);

	my $sPicker = Wx::Window::FindWindowById(id('Secondary'));
	$sPicker->Clear();
	$sPicker->Append([sort keys %{$ArchData->{'Secondary'}}]);
	$sPicker->SetStringSelection($g->{'Secondary'}) or $sPicker->SetSelection(1);

	my $ePicker = Wx::Window::FindWindowById(id('Epic'));
	$ePicker->Clear();
	$ePicker->Append([sort keys %{$ArchData->{'Epic'}}]);
	$ePicker->SetStringSelection($g->{'Epic'}) or $sPicker->SetSelection(1);

	for my $i (1..4) {
		my $ppPicker = Wx::Window::FindWindowById(id("Pool$i"));
		$ppPicker->Clear();
		$ppPicker->Append([sort keys %{$GameData::MiscPowers->{'Pool'}}]);
		$ppPicker->SetStringSelection($g->{"Pool$i"}) or $ppPicker->SetSelection(1);
	}
}

UI::Labels::Add({
	Name => 'Name',
	Archetype => 'Archetype',
	Origin => 'Origin',
	Primary => 'Primary Powerset',
	Secondary => 'Secondary Powerset',
	Epic => 'Epic / Patron Powerset',
	Pool1 => 'Power Pool 1',
	Pool2 => 'Power Pool 2',
	Pool3 => 'Power Pool 3',
	Pool4 => 'Power Pool 4',
	BindsDir => 'Binds Directory',
	ResetKey => 'Reset Key',
	ResetFeedback => 'Give Feedback on Reset',
});


1;
