#!/usr/bin/perl

use strict;

package Profile::FPSDisplay;
use parent "Profile::ProfileTab";

use Wx qw( :everything );

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
	my $Tab = $self->Tab;

	my $sizer = Wx::BoxSizer->new(wxVERTICAL);

	my $useCB = Wx::CheckBox->new( $Tab, id('EnableFPSBind'), 'Enable FPS Binds');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the FPS and Netgraph Toggle Binds'));
	$sizer->Add($useCB, 0, wxALL, 10);

	my $minisizer = Wx::FlexGridSizer->new(0,2,5,5);
	$minisizer->Add( Wx::StaticText->new($Tab, -1, 'Toggle FPS/Netgraph'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$minisizer->Add( Wx::Button->    new($Tab, id('FPSKeySelect'), $FPS->{'Bindkey'}));

	$sizer->Add($minisizer);

	$Tab->SetSizerAndFit($sizer);

	return $self;
}


sub PopulateBindFiles {
	my $profile = shift->Profile;
	my $ResetFile = $profile->GetBindFile($profile->General->{'ResetFile'});
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
