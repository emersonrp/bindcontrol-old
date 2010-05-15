package ProfileTabs;

use strict;
use Wx qw(wxVERTICAL wxHORIZONTAL
		wxTOP wxBOTTOM wxLEFT wxRIGHT wxALL
		wxDefaultSize wxDefaultPosition wxDefaultValidator
		wxTAB_TRAVERSAL wxEXPAND wxCB_READONLY);
use Wx::Event qw( EVT_COMBOBOX );

use BCConstants;
use GameData;
use Profile;


use base 'Wx::Notebook';

sub new {
	my ($class, $parentpanel) = @_;

	my $self = $class->SUPER::new($parentpanel);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = $self->generalPanel();
	$self->AddPage($GeneralPanel, "General");

	# SoD setup
	my $SpeedOnDemandPanel = $self->sodPanel();
	$self->AddPage($SpeedOnDemandPanel, "Speed On Demand");

	# Util:  Inspiration, Team target
	my $UtilPanel = $self->utilPanel();
	$self->AddPage($UtilPanel, "Utility");

	# Chat
	my $SocialPanel = $self->socialPanel();
	$self->AddPage($SocialPanel, "Social and Chat");

	# Custom (man o man that's vague)
	my $CustomPanel = $self->customPanel();
	$self->AddPage($CustomPanel, "Custom Binds");

	# (If Appropriate) Mastermind henchman panel
	my $MastermindPanel = $self->mastermindPanel();
	$self->AddPage($MastermindPanel, "Mastermind Binds");

	return $self;
}


sub generalPanel {
	my $self = shift;
 
	my $a = ($Profile::current->{'Archetype'} ||= $Profile::defaults->{'Archetype'});
	my $o = ($Profile::current->{'Origin'}    ||= $Profile::defaults->{'Origin'});
	my $p = ($Profile::current->{'Primary'}   ||= $Profile::defaults->{'Primary'});
	my $s = ($Profile::current->{'Secondary'} ||= $Profile::defaults->{'Secondary'});
 
	my $panel = Wx::Panel->new($self, -1);
	$panel->SetBackgroundColour( Wx::Colour->new( BCConstants::HERO_COLOUR ) );
	$panel->SetForegroundColour( Wx::Colour->new( 'white' ) );
 
	my $topSizer = Wx::FlexGridSizer->new(0,3,5,5);

	# Name
	$topSizer->Add(
		Wx::StaticText->new( $panel, -1, "Name:")
		0
		wxALL
		10,
	);
	$topSizer->Add(
		Wx::TextCtrl->new( $panel, PROFILE_NAMETEXT, "",),
		0,
		wxALL,
		10,
	) ;
	$topSizer->AddSpacer(1);

	# Archetype
	$topSizer->Add(
		Wx::StaticText->new( $panel, -1, "Archetype:"),
		0,
		wxALL,
		10,
	);
	$topSizer->Add( 
		Wx::BitmapComboBox->new(
			$panel, PICKER_ARCHETYPE, '',
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		),
		0,
		wxALL,
		10,
	);
	$topSizer->AddSpacer(1);

	# Origin
	$topSizer->Add(
		Wx::StaticText->new( $panel, -1, "Origin:"),
		0,
		wxALL,
		10,
	);

	$topSizer->Add(
		Wx::BitmapComboBox->new(
			$panel, PICKER_ORIGIN, '',
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		),
		0,
		wxALL,
		10,
	);
	$topSizer->AddSpacer(1);

	# Primary
	$topSizer->Add(
		Wx::StaticText->new( $panel, -1, "Primary Powerset:"),
		0,
		wxALL,
		10,
	);
 	$topSizer->Add(
		Wx::BitmapComboBox->new(
 			$panel, PICKER_PRIMARY, '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Primary'}}],
			wxCB_READONLY,
 		),
		0,
		wxALL,
		10,
	);
	$topSizer->AddSpacer(1);

	# Secondary
	$topSizer->Add(
		Wx::StaticText->new( $panel, -1, "Secondary Powerset:"),
		0,
		wxALL,
		10,
	);
 	$topSizer->Add(
		Wx::BitmapComboBox->new(
 			$panel, PICKER_SECONDARY, '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Secondary'}}],
			wxCB_READONLY,
 		),
		0,
		wxALL,
		10,
	);
	$topSizer->AddSpacer(1);

	$panel->SetSizerAndFit($topSizer);

	EVT_COMBOBOX( $self, PICKER_ARCHETYPE, \&Profile::pickArchetype );
	EVT_COMBOBOX( $self, PICKER_ORIGIN, \&Profile::pickOrigin );
	EVT_COMBOBOX( $self, PICKER_PRIMARY, \&Profile::pickPrimaryPowerSet );
	EVT_COMBOBOX( $self, PICKER_SECONDARY, \&Profile::pickSecondaryPowerSet );

	Profile::fillPickers();

	return $panel;

}


sub sodPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub utilPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub socialPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub customPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub mastermindPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}




1;
