#!/usr/bin/perl

package ProfileTabs;
use parent -norequire, 'Wx::Notebook';

use strict;

# This all used to be auto-detecty-pluginny, but
# PAR didn't want to package up anything that wasn't
# explicitly 'use'd.  There's probably a better solution.
use ProfileTabs::BufferBinds;
use ProfileTabs::ComplexBinds;
use ProfileTabs::CustomBinds;
use ProfileTabs::FPSDisplay;
use ProfileTabs::General;
use ProfileTabs::InspirationPopper;
use ProfileTabs::Mastermind;
use ProfileTabs::PetSel;
use ProfileTabs::SimpleBinds;
use ProfileTabs::SoD;
use ProfileTabs::TeamSel;
use ProfileTabs::TeamSel2;
use ProfileTabs::TypingMsg;


sub new {
	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	# Add the individual tabs, in order.
	my $tab;
	$tab = ProfileTabs::General->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::SoD->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::BufferBinds->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::ComplexBinds->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::CustomBinds->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::FPSDisplay->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::InspirationPopper->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::Mastermind->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::PetSel->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::SimpleBinds->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::TeamSel->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::TeamSel2->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$tab = ProfileTabs::TypingMsg->new($self);
	$self->AddPage( $tab, $tab->{'TabTitle'} );

	$self->SetSelection(1);

	return $self;
}

1;
