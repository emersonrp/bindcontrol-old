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
use General;

# use BCModules::InspirationPopper;
# use BCModules::Mastermind;
# use BCModules::PetSel;
# use BCModules::SimpleBinds;
# use BCModules::SoD;


use base 'Wx::Notebook';

sub new {
	my ($class, $parentpanel) = @_;

	my $self = $class->SUPER::new($parentpanel);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = General->new($self);
	$self->AddPage($GeneralPanel, "General");

	# TODO -- iterate modules here, adding pages as they request it.

	# SoD setup
	my $SpeedOnDemandPanel = BCModules::SoD->new($self);
	$self->AddPage($SpeedOnDemandPanel, "Speed On Demand");

	# Util:  Inspiration, Team target
	my $UtilPanel = $self->utilPanel();
	$self->AddPage($UtilPanel, "Utility");

	# Chat / costume / pets / emotes / etc
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
