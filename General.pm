# UI / logic for the 'general' panel
package General;

use strict;
use Wx qw(wxVERTICAL wxHORIZONTAL
		wxTOP wxBOTTOM wxLEFT wxRIGHT wxALL
		wxDefaultSize wxDefaultPosition wxDefaultValidator
		wxTAB_TRAVERSAL wxEXPAND wxCB_READONLY);
use Wx::Event qw( EVT_COMBOBOX );

use BCConstants;
use GameData;
use Profile;

use base 'Wx::Panel';

sub new {
	my ($class, $parentwindow) = @_;

	my $self = $class->SUPER::new($parentwindow);

	my $a = $Profile::current->{'Archetype'};
	my $o = $Profile::current->{'Origin'};
	my $p = $Profile::current->{'Primary'};
	my $s = $Profile::current->{'Secondary'};
 
	my $topSizer = Wx::FlexGridSizer->new(0,2,5,5);

	my $PAD = 10;

	# Name
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Name:"), 0, wxALL, $PAD,);
	$topSizer->Add( Wx::TextCtrl->new( $self, PROFILE_NAMETEXT, "",), 0, wxALL, $PAD,) ;

	# Archetype
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Archetype:"), 0, wxALL, $PAD,);
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, PICKER_ARCHETYPE, '',
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		), 0, wxALL, $PAD,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Origin:"), 0, wxALL, $PAD,); 
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, PICKER_ORIGIN, '',
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		), 0, wxALL, $PAD,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Primary Powerset:"), 0, wxALL, $PAD,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, PICKER_PRIMARY, '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Primary'}}],
			wxCB_READONLY,
 		), 0, wxALL, $PAD,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Secondary Powerset:"), 0, wxALL, $PAD,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, PICKER_SECONDARY, '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Secondary'}}],
			wxCB_READONLY,
 		), 0, wxALL, $PAD,);

	$self->SetSizerAndFit($topSizer);

	EVT_COMBOBOX( $self, PICKER_ARCHETYPE, \&Profile::pickArchetype );
	EVT_COMBOBOX( $self, PICKER_ORIGIN, \&Profile::pickOrigin );
	EVT_COMBOBOX( $self, PICKER_PRIMARY, \&Profile::pickPrimaryPowerSet );
	EVT_COMBOBOX( $self, PICKER_SECONDARY, \&Profile::pickSecondaryPowerSet );

	Profile::fillPickers();

	return $self;

}

1;
