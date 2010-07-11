# UI / logic for the 'general' panel
package Module::General;
use parent "Module::Module";

use strict;
use Wx qw( wxCB_READONLY wxDIRP_USE_TEXTCTRL );

use GameData;
use Utility qw(id);

our $ModuleName = 'General';

sub InitKeys {
	my $self = shift;

	$self->Profile->General ||= {
		Archetype => 'Scrapper',
		Origin => "Magic",
		Primary => 'Martial Arts',
		Secondary => 'Super Reflexes',
		Epic => 'Weapon Mastery',
		BindsDir => "c:\\CoHTest\\",
		ResetFile => $self->Profile->GetBindFile('reset.txt'),
		'Reset Key' => 'CTRL-M',
	};
}

sub FillTab {

	my $self = shift;

	$self->TabTitle = 'General';

	my $General = $self->Profile->General;
	my $Tab = $self->Tab;

	my $topSizer = Wx::FlexGridSizer->new(0,2,5,5);

	# Name
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Name:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,);
	my $tc = Wx::TextCtrl->new( $Tab, id('PROFILE_NAMETEXT'), "",);
	# TODO -- suss out what we want the min size to be, and set it someplace sane.
	$tc->SetMinSize([300,-1]);
	$topSizer->Add( $tc, 0, Wx::wxALL,) ;

	# Archetype
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Archetype:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,);
	$topSizer->Add( Wx::ComboBox->new(
			$Tab, id('PICKER_ARCHETYPE'), $General->{'Archetype'},
			Wx::wxDefaultPosition, Wx::wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			Wx::wxCB_READONLY,
		), 0, Wx::wxALL,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Origin:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,); 
	$topSizer->Add( Wx::ComboBox->new(
			$Tab, id('PICKER_ORIGIN'), $General->{'Origin'},
			Wx::wxDefaultPosition, Wx::wxDefaultSize,
			[@GameData::Origins],
			Wx::wxCB_READONLY,
		), 0, Wx::wxALL,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Primary Powerset:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::ComboBox->new(
 			$Tab, id('PICKER_PRIMARY'), $General->{'Primary'},
			Wx::wxDefaultPosition, Wx::wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$General->{'Archetype'}}->{'Primary'}}],
			Wx::wxCB_READONLY,
 		), 0, Wx::wxALL,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Secondary Powerset:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::ComboBox->new(
 			$Tab, id('PICKER_SECONDARY'), $General->{'Secondary'},
			Wx::wxDefaultPosition, Wx::wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$General->{'Archetype'}}->{'Secondary'}}],
			Wx::wxCB_READONLY,
 		), 0, Wx::wxALL,);

	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Binds Directory:"), 0, Wx::wxALIGN_CENTER_VERTICAL|Wx::wxALIGN_RIGHT,);
	$topSizer->Add( Wx::DirPickerCtrl->new(
			$Tab, -1, $General->{'BindsDir'}, 
			'Select Binds Directory',
			Wx::wxDefaultPosition, Wx::wxDefaultSize,
			Wx::wxDIRP_USE_TEXTCTRL|Wx::wxALL,
		), 0, Wx::wxALL|Wx::wxEXPAND,);

	$self->addLabeledButton($topSizer, $General, 'Reset Key', 'This key is used by certain modules to reset binds to a sane state.');

	$topSizer->Add ( Wx::CheckBox->new($Tab, id('Enable Reset Feedback'), 'Enable Reset Feedback'), 0, Wx::wxALL);
	$topSizer->AddSpacer(5);


	$topSizer->Add( Wx::Button->new( $Tab, id('Write Binds Button'), 'Write Binds!' ), 0, Wx::wxALL|Wx::wxEXPAND);

	Wx::Event::EVT_BUTTON( $Tab, id('Write Binds Button'), sub { $self->Profile->WriteBindFiles() } );


	$Tab->SetSizer($topSizer);

	Wx::Event::EVT_COMBOBOX( $Tab, id('PICKER_ARCHETYPE'), \&pickArchetype );
	Wx::Event::EVT_COMBOBOX( $Tab, id('PICKER_ORIGIN'),    \&pickOrigin );
	Wx::Event::EVT_COMBOBOX( $Tab, id('PICKER_PRIMARY'),   \&pickPrimaryPowerSet );
	Wx::Event::EVT_COMBOBOX( $Tab, id('PICKER_SECONDARY'), \&pickSecondaryPowerSet );

	return $self;
}

sub pickArchetype {
	my ($self, $event) = @_;

	$self->GetParent->General->{'Archetype'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickOrigin { shift()->fillPickers; }

sub pickPrimaryPowerSet {
	my ($self, $event) = @_;
	$self->GetParent->General->{'Primary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	$self->GetParent->General->{'Secondary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub fillPickers {
	my $self = shift;

	my $g = $self->GetParent->General;

	my $ArchData = $GameData::Archetypes->{$g->{'Archetype'}};

	my $aPicker = Wx::Window::FindWindowById(id('PICKER_ARCHETYPE'));
	$aPicker->SetStringSelection($g->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(id('PICKER_ORIGIN'));
	$oPicker->SetStringSelection($g->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(id('PICKER_PRIMARY'));
	$pPicker->Clear();
	$pPicker->SetStringSelection($g->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(id('PICKER_SECONDARY'));
	$sPicker->Clear();
	$sPicker->SetStringSelection($g->{'Secondary'});

}

1;
