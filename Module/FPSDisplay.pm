#!/usr/bin/perl

use strict;

package Module::FPSDisplay;
use parent "Module::Module";

use Wx qw();

use Utility qw(id);

our $ModuleName = 'FPS';

sub InitKeys {
	my $self = shift;

	$self->Profile->FPS ||= {
		Enable => 1,
		Bindkey => "P",
	};
}

sub FillTab {

	my $self = shift;

	$self->TabTitle = "FPS / Netgraph";

	my $FPS = $self->Profile->FPS;

	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);

	my $useCB = Wx::CheckBox->new( $self, id('EnableFPSBind'), 'Enable FPS Binds');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the FPS and Netgraph Toggle Binds'));
	$sizer->Add($useCB, 0, Wx::wxALL, 10);

	my $minisizer = Wx::FlexGridSizer->new(0,2,5,5);
	$minisizer->Add( Wx::StaticText->new($self, -1, 'Toggle FPS/Netgraph'), 0, Wx::wxALIGN_RIGHT|Wx::wxALIGN_CENTER_VERTICAL);
	$minisizer->Add( Wx::Button->    new($self, id('FPSKeySelect'), $FPS->{'Bindkey'}));

	$sizer->Add($minisizer);

	$self->SetSizerAndFit($sizer);

	return $self;
}


sub PopulateBindFiles {
	my $profile = shift->Profile;
	my $ResetFile = $profile->General->{'ResetFile'};
	$ResetFile->SetBind($profile->FPS->{'Bindkey'},'++showfps$$++netgraph');
}

sub findconflicts {
	my $profile = shift->Profile;
	cbCheckConflict($profile->FPS,"Bindkey","FPS Display Toggle")
}

sub bindisused {
	my $profile -> shift->Profile;
	return $profile->FPS ? $profile->FPS->{'Enable'} : undef;
}

1;
