# UI / logic for the 'general' panel
package General;

use strict;
use Wx qw(wxVERTICAL wxHORIZONTAL
		wxTOP wxBOTTOM wxLEFT wxRIGHT wxALL
		wxALIGN_LEFT wxALIGN_RIGHT wxALIGN_CENTER wxALIGN_CENTER_VERTICAL
		wxDefaultSize wxDefaultPosition wxDefaultValidator
		wxTAB_TRAVERSAL wxEXPAND wxCB_READONLY
		wxDIRP_USE_TEXTCTRL
);
use Wx::Event qw( EVT_COMBOBOX );

use GameData;
use Profile;

use Utility qw(id);

use parent -norequire, 'Wx::Panel';

sub new {
	my ($class, $parentwindow) = @_;

	my $self = $class->SUPER::new($parentwindow);

	my $profile = $Profile::current;

	my $a = $profile->{'Archetype'};
	my $o = $profile->{'Origin'};
	my $p = $profile->{'Primary'};
	my $s = $profile->{'Secondary'};
 
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
			$self, id('PICKER_ARCHETYPE'), '',
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		), 0, wxALL,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Origin:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,); 
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, id('PICKER_ORIGIN'), '',
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		), 0, wxALL,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Primary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_PRIMARY'), '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Primary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Secondary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_SECONDARY'), '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Secondary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	$topSizer->Add( Wx::StaticText->new( $self, -1, "Binds Directory:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	my $dirPicker = Wx::DirPickerCtrl->new(
			$self, -1, $profile->{'BindsDir'}, 
			'Select Binds Directory',
			wxDefaultPosition, wxDefaultSize,
			wxDIRP_USE_TEXTCTRL|wxALL,
		);
	$topSizer->Add($dirPicker, 0, wxALL|wxEXPAND,);


	$self->SetSizerAndFit($topSizer);

	EVT_COMBOBOX( $self, id('PICKER_ARCHETYPE'), \&Profile::pickArchetype );
	EVT_COMBOBOX( $self, id('PICKER_ORIGIN'),    \&Profile::pickOrigin );
	EVT_COMBOBOX( $self, id('PICKER_PRIMARY'),   \&Profile::pickPrimaryPowerSet );
	EVT_COMBOBOX( $self, id('PICKER_SECONDARY'), \&Profile::pickSecondaryPowerSet );

	Profile::fillPickers();

	return $self;

}

1;
