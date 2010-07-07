# UI / logic for the 'general' panel
package Profile::General;
use parent "Profile::ProfileTab";

use strict;
use Wx qw( :everything );
use Wx::Event qw( :everything );

use GameData;
use Utility qw(id);

sub new {
	my ($class, $profile) = @_;

	my $self = $class->SUPER::new($profile);

	$profile->{'General'} ||= {
		Archetype => 'Scrapper',
		Origin => "Magic",
		Primary => 'Martial Arts',
		Secondary => 'Super Reflexes',
		Epic => 'Weapon Mastery',
		BindsDir => "c:\\CoHTest\\",
		ResetFile => BindFile->new('reset.txt'),
		ResetKey => 'CTRL-M',
	};
	my $general = $profile->{'General'};

	my $topSizer = Wx::FlexGridSizer->new(0,2,5,5);

	# Name
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Name:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	my $tc = Wx::TextCtrl->new( $self, id('PROFILE_NAMETEXT'), "",);
	# TODO -- suss out what we want the min size to be, and set it someplace sane.
	$tc->SetMinSize([300,-1]);
	$topSizer->Add( $tc, 0, wxALL,) ;

	# Archetype
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Archetype:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, id('PICKER_ARCHETYPE'), $general->{'Archetype'},
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		), 0, wxALL,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Origin:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,); 
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, id('PICKER_ORIGIN'), $general->{'Origin'},
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		), 0, wxALL,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Primary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_PRIMARY'), $general->{'Primary'},
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$general->{'Archetype'}}->{'Primary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Secondary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_SECONDARY'), $general->{'Secondary'},
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$general->{'Archetype'}}->{'Secondary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	$topSizer->Add( Wx::StaticText->new( $self, -1, "Binds Directory:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::DirPickerCtrl->new(
			$self, -1, $general->{'BindsDir'}, 
			'Select Binds Directory',
			wxDefaultPosition, wxDefaultSize,
			wxDIRP_USE_TEXTCTRL|wxALL,
		), 0, wxALL|wxEXPAND,);

	$self->addLabeledButton($topSizer, 'Reset Key', $general->{'ResetKey'}, 'This key is used by certain modules to reset binds to a sane state.');

	$topSizer->Add ( Wx::CheckBox->new($self, id('Enable Reset Feedback'), 'Enable Reset Feedback'), 0, wxALL);
	$topSizer->AddSpacer(5);


	$topSizer->Add( Wx::Button->new( $self, id('Write Binds Button'), 'Write Binds!' ), 0, wxALL|wxEXPAND);

	EVT_BUTTON( $self, id('Write Binds Button'), \&BindFile::WriteBindFiles );


	$self->SetSizer($topSizer);

	EVT_COMBOBOX( $self, id('PICKER_ARCHETYPE'), \&pickArchetype );
	EVT_COMBOBOX( $self, id('PICKER_ORIGIN'),    \&pickOrigin );
	EVT_COMBOBOX( $self, id('PICKER_PRIMARY'),   \&pickPrimaryPowerSet );
	EVT_COMBOBOX( $self, id('PICKER_SECONDARY'), \&pickSecondaryPowerSet );

	$self->{'TabTitle'} = 'General';

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
