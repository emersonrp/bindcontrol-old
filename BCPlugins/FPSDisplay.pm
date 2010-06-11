#!/usr/bin/perl

use strict;

package BCPlugins::FPSDisplay;
use parent "BCPlugins";

use Wx qw( wxDefaultSize wxDefaultPosition wxID_OK wxID_CANCEL wxID_YES wxID_ANY );
use Wx qw( wxVERTICAL wxHORIZONTAL wxALL wxLEFT wxRIGHT wxTOP wxBOTTOM wxCENTER wxEXPAND );
use Wx qw( wxALIGN_RIGHT wxALIGN_BOTTOM wxALIGN_CENTER wxALIGN_CENTER_VERTICAL wxALIGN_CENTER_HORIZONTAL )    ;

use Utility qw(id);



sub tab {

	my ($self, $parent) = @_;

	my $profile = $Profile::current;
	my $FPS = $profile->{'FPS'};
	unless ($FPS) {
		$FPS = {
			Enable => undef,
			Bindkey => "P",
		};
		$profile->{'FPS'} = $FPS;
	}
	my $tab = Wx::Panel->new($parent);

	my $sizer = Wx::BoxSizer->new(wxVERTICAL);

	my $useCB = Wx::CheckBox->new( $tab, id('EnableFPSBind'), 'Enable FPS Binds');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the FPS and Netgraph Toggle Binds'));
	$sizer->Add($useCB, 0, wxALL);

	my $minisizer = Wx::FlexGridSizer->new(0,2,5,5);
	$minisizer->Add( Wx::StaticText->new($tab, -1, 'Toggle FPS/Netgraph'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$minisizer->Add( Wx::Button->    new($tab, id('FPSKeySelect'), $FPS->{'Bindkey'}));

	$sizer->Add($minisizer);

	$tab->SetSizerAndFit($sizer);

	return ($tab, 'FPS / Netgraph');
}


sub makebind {
	my ($profile) = @_;
	my $FPS = $profile->{'FPS'};
	cbWriteBind($profile->{'resetfile'},$FPS->{'Bindkey'},'++showfps$$++netgraph');
}

sub findconflicts {
	my ($profile) = @_;
	my $FPS = $profile->{'FPS'};
	cbCheckConflict($FPS,"Bindkey","FPS Display Toggle")
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'FPS'} ? $profile->{'FPS'}->{'Enable'} : undef;
}

1;
