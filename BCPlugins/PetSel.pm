#!/usr/bin/perl

use strict;

package BCPlugins::PetSel;
use parent "BCPlugins";

use Wx qw( wxALIGN_RIGHT wxALIGN_CENTER_VERTICAL wxEXPAND );
use Utility qw(id);

sub tab {

	my ($self) = @_;

	$self->{'TabTitle'} = 'Single Key Pet Selection';

	my $profile = $Profile::current;
	my $petsel = $profile->{'petsel'};
	unless ($petsel) { $profile->{'petsel'} = $petsel = {}; }

	my $sizer = Wx::FlexGridSizer->new(0,2,4,4);


### TODO add credits in, and on/off checkbox
#	local credits = iup.hbox{iup.fill{};iup.vbox{iup.fill{size="5"};iup.label{title="Single Key Pet Selection binds\nbased on binds from Weap0nX."};iup.fill{size="5"};alignment="ACENTER"};iup.fill{};alignment="ACENTER";rastersize="300x"}
#	cbToolTip("Check this to enable the Single Key Pet Select Binds")
#	local petselenable = cbCheckBox("Enable Pet Selector",petsel.enable,cbCheckBoxCB(profile,petsel,"enable"),300)

	my $button;

	$button = Wx::Button->new($self, id('selnext'), $petsel->{'selnext'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will select the next pet from the one currently selected') );
	$sizer->Add( Wx::StaticText->new($self, -1, 'Select Next Pet'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($self, id('selprev'), $petsel->{'selprev'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will select the previous pet from the one currently selected') );
	$sizer->Add( Wx::StaticText->new($self, -1, 'Select Previous Pet'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($self, id('sizeup'), $petsel->{'sizeup'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will increase the size of your henchman group rotation') );
	$sizer->Add( Wx::StaticText->new($self, -1, 'Increase Pet Group Size'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($self, id('sizedn'), $petsel->{'sizedn'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will decrease the size of your henchman group rotation') );
	$sizer->Add( Wx::StaticText->new($self, -1, 'Decrease Pet Group Size'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$self->SetSizer($sizer);

	return $self;

}

sub formatPetConfig { "[" . qw( First Second Third Fourth Fifth Sixth Seventh Eighth )[shift()] . " Pet ]" }

sub ts2CreateSet {
	my ($profile,$ts2,$tsize,$tsel,$file) = @_;
	# tsize is the size of the team at the moment
	# tpos is the position of the player at the moment, or 0 if unknown
	# tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	#cbWriteBind(file,ts2.reset,'tell $name, Re-Loaded Single Key Team Select Bind.$$bindloadfile '..profile.base..'\\petsel\\10.txt')
	if ($tsize < 8) {
		cbWriteBind($file,$ts2->{'sizeup'},'tell $name, ' . formatPetConfig($tsize+1) . '$$bindloadfile ' . $profile->{'base'} . '\\petsel\\'.($tsize+1) . "$tsel.txt");
	} else {
		cbWriteBind($file,$ts2->{'sizeup'},'nop');
	}

	if ($tsize == 1) {
		cbWriteBind($file,$ts2->{'sizedn'},'nop');
		cbWriteBind($file,$ts2->{'selnext'},'petselect 0$$bindloadfile ' . $profile->{'base'} . '\\petsel\\' . $tsize . '1.txt');
		cbWriteBind($file,$ts2->{'selprev'},'petselect 0$$bindloadfile ' . $profile->{'base'} . '\\petsel\\' . $tsize . '1.txt');
	} else {
		my ($selnext,$selprev) = ($tsel+1,$tsel-1);
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1) { $selprev = $tsize }
		my $newsel = $tsel;
		if ($tsize-1 < $tsel) { $newsel = $tsize-1 }
		if ($tsize == 2) { $newsel = 0 }
		cbWriteBind($file,$ts2->{'sizedn'},'tell $name, ' . formatPetConfig($tsize-1) . '$$bindloadfile ' . $profile->{'base'} . '\\petsel\\' . ($tsize-1) . $newsel . '.txt');
		cbWriteBind($file,$ts2->{'selnext'},'petselect ' . ($selnext-1) . '$$bindloadfile ' . $profile->{'base'} . '\\petsel\\' . $tsize . $selnext . '.txt');
		cbWriteBind($file,$ts2->{'selprev'},'petselect ' . ($selprev-1) . '$$bindloadfile ' . $profile->{'base'} . '\\petsel\\' . $tsize . $selprev . '.txt');
	}
}

sub makebind {
	my ($profile) = @_;
	my $petsel = $profile->{'petsel'};
	cbMakeDirectory("$profile->{'base'}\\petsel");
	ts2CreateSet($profile->{'petsel'},1,0,$profile->{'resetfile'});
	for my $size (1..8) {
		for my $sel (0..$size) {
			my $file = cbOpen("$profile.base\\petsel\\$size$sel.txt",'w');
			ts2CreateSet($profile,$petsel,$size,$sel,$file);
			close $file;
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $petsel = $profile->{'petsel'};
	cbCheckConflict($petsel,"selnext","Select next henchman");
	cbCheckConflict($petsel,"selprev","Select previous henchman");
	cbCheckConflict($petsel,"sizeup","Increase Henchman Group Size");
	cbCheckConflict($petsel,"sizedn","Decrease Henchman Group Size");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'petsel'} ? $profile->{'petsel'}->{'enable'} : undef;
}

1;
