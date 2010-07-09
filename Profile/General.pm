# UI / logic for the 'general' panel
package Profile::General;
use parent "Profile::ProfileTab";

use strict;
use Wx qw( :everything );
use Wx::Event qw( :everything );

use GameData;
use Utility qw(id);

sub InitKeys {
	my $self = shift;

	$self->Profile->AddModule('General');

	$self->Profile->General ||= {
		Archetype => 'Scrapper',
		Origin => "Magic",
		Primary => 'Martial Arts',
		Secondary => 'Super Reflexes',
		Epic => 'Weapon Mastery',
		BindsDir => "c:\\CoHTest\\",
		ResetFile => BindFile->new('reset.txt'),
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
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Name:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	my $tc = Wx::TextCtrl->new( $Tab, id('PROFILE_NAMETEXT'), "",);
	# TODO -- suss out what we want the min size to be, and set it someplace sane.
	$tc->SetMinSize([300,-1]);
	$topSizer->Add( $tc, 0, wxALL,) ;

	# Archetype
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Archetype:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::BitmapComboBox->new(
			$Tab, id('PICKER_ARCHETYPE'), $General->{'Archetype'},
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		), 0, wxALL,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Origin:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,); 
	$topSizer->Add( Wx::BitmapComboBox->new(
			$Tab, id('PICKER_ORIGIN'), $General->{'Origin'},
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		), 0, wxALL,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Primary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$Tab, id('PICKER_PRIMARY'), $General->{'Primary'},
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$General->{'Archetype'}}->{'Primary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Secondary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$Tab, id('PICKER_SECONDARY'), $General->{'Secondary'},
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$General->{'Archetype'}}->{'Secondary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	$topSizer->Add( Wx::StaticText->new( $Tab, -1, "Binds Directory:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::DirPickerCtrl->new(
			$Tab, -1, $General->{'BindsDir'}, 
			'Select Binds Directory',
			wxDefaultPosition, wxDefaultSize,
			wxDIRP_USE_TEXTCTRL|wxALL,
		), 0, wxALL|wxEXPAND,);

	$self->addLabeledButton($topSizer, $General, 'Reset Key', 'This key is used by certain modules to reset binds to a sane state.');

	$topSizer->Add ( Wx::CheckBox->new($Tab, id('Enable Reset Feedback'), 'Enable Reset Feedback'), 0, wxALL);
	$topSizer->AddSpacer(5);


	$topSizer->Add( Wx::Button->new( $Tab, id('Write Binds Button'), 'Write Binds!' ), 0, wxALL|wxEXPAND);

	EVT_BUTTON( $Tab, id('Write Binds Button'), \&BindFile::WriteBindFiles );


	$Tab->SetSizer($topSizer);

	EVT_COMBOBOX( $Tab, id('PICKER_ARCHETYPE'), \&pickArchetype );
	EVT_COMBOBOX( $Tab, id('PICKER_ORIGIN'),    \&pickOrigin );
	EVT_COMBOBOX( $Tab, id('PICKER_PRIMARY'),   \&pickPrimaryPowerSet );
	EVT_COMBOBOX( $Tab, id('PICKER_SECONDARY'), \&pickSecondaryPowerSet );

	return $self;

}

sub pickArchetype {
	my ($self, $event) = @_;
	$self->profile->{'General'}->{'Archetype'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickOrigin { shift()->fillPickers; }

sub pickPrimaryPowerSet {
	my ($self, $event) = @_;
	$self->profile->{'General'}->{'Primary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub pickSecondaryPowerSet {
	my ($self, $event) = @_;
	$self->profile->{'General'}->{'Secondary'} = $event->GetEventObject->GetValue;
	$self->fillPickers;
}

sub fillPickers {
	my $self = shift;

	my $g = $self->profile->{'General'};

	my $ArchData = $GameData::Archetypes->{$g->{'Archetype'}};

	my $aPicker = Wx::Window::FindWindowById(id('PICKER_ARCHETYPE'));
	$aPicker->SetStringSelection($g->{'Archetype'});

	my $oPicker = Wx::Window::FindWindowById(id('PICKER_ORIGIN'));
	$oPicker->SetStringSelection($g->{'Origin'});

	my $pPicker = Wx::Window::FindWindowById(id('PICKER_PRIMARY'));
	$pPicker->Clear();
	for (sort keys %{$ArchData->{'Primary'}}) { $pPicker->Append($_, wxNullBitmap); }
	$pPicker->SetStringSelection($g->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(id('PICKER_SECONDARY'));
	$sPicker->Clear();
	for (sort keys %{$ArchData->{'Secondary'}}) { $sPicker->Append($_, wxNullBitmap); }
	$sPicker->SetStringSelection($g->{'Secondary'});

}

1;
