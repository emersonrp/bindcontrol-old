#!/usr/bin/perl

use strict;

package Module::PetSel;
use parent "Module::Module";

use Wx qw( :everything );

use BindFile;
use Utility qw(id);

our $ModuleName = 'PetSel';

sub InitKeys {

	my $self = shift;

	$self->Profile->PetSel ||= {
		selnext => 'UNBOUND',
		selprev => 'UNBOUND',
		sizeup => 'UNBOUND',
		sizedn => 'UNBOUND',
	};
}

sub FillTab {
	my $self = shift;

	$self->TabTitle = 'Single Key Pet Selection';

	my $PetSel = $self->Profile->PetSel;
	my $Tab    = $self->Tab;

	my $sizer = Wx::FlexGridSizer->new(0,2,4,4);


### TODO add credits in, and on/off checkbox
#	local credits = iup.hbox{iup.fill{};iup.vbox{iup.fill{size="5"};iup.label{title="Single Key Pet Selection binds\nbased on binds from Weap0nX."};iup.fill{size="5"};alignment="ACENTER"};iup.fill{};alignment="ACENTER";rastersize="300x"}
#	cbToolTip("Check this to enable the Single Key Pet Select Binds")
#	local petselenable = cbCheckBox("Enable Pet Selector",petsel.enable,cbCheckBoxCB(profile,petsel,"enable"),300)

	my $button;

	$button = Wx::Button->new($Tab, id('selnext'), $PetSel->{'selnext'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will select the next pet from the one currently selected') );
	$sizer->Add( Wx::StaticText->new($Tab, -1, 'Select Next Pet'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($Tab, id('selprev'), $PetSel->{'selprev'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will select the previous pet from the one currently selected') );
	$sizer->Add( Wx::StaticText->new($Tab, -1, 'Select Previous Pet'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($Tab, id('sizeup'), $PetSel->{'sizeup'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will increase the size of your henchman group rotation') );
	$sizer->Add( Wx::StaticText->new($Tab, -1, 'Increase Pet Group Size'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($Tab, id('sizedn'), $PetSel->{'sizedn'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key that will decrease the size of your henchman group rotation') );
	$sizer->Add( Wx::StaticText->new($Tab, -1, 'Decrease Pet Group Size'), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $button, 0, wxEXPAND);

	$Tab->SetSizer($sizer);

	return $self;

}

sub formatPetConfig { "[" . qw( First Second Third Fourth Fifth Sixth Seventh Eighth )[shift() - 1] . " Pet ]" }

sub ts2CreateSet {
	my ($profile,$ts2,$tsize,$tsel,$file) = @_;
	# tsize is the size of the team at the moment
	# tpos is the position of the player at the moment, or 0 if unknown
	# tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	#file->SetBind(ts2.reset,'tell $name, Re-Loaded Single Key Team Select Bind.' . BindFile::BLF($profile, 'petsel', '10.txt');
	if ($tsize < 8) {
		$file->SetBind($ts2->{'sizeup'},'tell $name, ' . formatPetConfig($tsize+1) . BindFile::BLF($profile, 'petsel', ($tsize+1) . "$tsel.txt"));
	} else {
		$file->SetBind($ts2->{'sizeup'},'nop');
	}

	if ($tsize == 1) {
		$file->SetBind($ts2->{'sizedn'},'nop');
		$file->SetBind($ts2->{'selnext'},'petselect 0' . BindFile::BLF($profile, 'petsel', $tsize . '1.txt'));
		$file->SetBind($ts2->{'selprev'},'petselect 0' . BindFile::BLF($profile, 'petsel', $tsize . '1.txt'));
	} else {
		my ($selnext,$selprev) = ($tsel+1,$tsel-1);
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1) { $selprev = $tsize }
		my $newsel = $tsel;
		if ($tsize-1 < $tsel) { $newsel = $tsize-1 }
		if ($tsize == 2) { $newsel = 0 }
		$file->SetBind($ts2->{'sizedn'},'tell $name, ' . formatPetConfig($tsize-1) . BindFile::BLF($profile, 'petsel', ($tsize-1) . $newsel . '.txt'));
		$file->SetBind($ts2->{'selnext'},'petselect ' . ($selnext-1) . BindFile::BLF($profile, 'petsel', $tsize . $selnext . '.txt'));
		$file->SetBind($ts2->{'selprev'},'petselect ' . ($selprev-1) . BindFile::BLF($profile, 'petsel', $tsize . $selprev . '.txt'));
	}
}

sub PopulateBindFiles {
	my $profile = shift->Profile;
	my $PetSel = $profile->PetSel;
	ts2CreateSet($profile,$PetSel,1,0,$profile->General->{'ResetFile'});
	for my $size (1..8) {
		for my $sel (0..$size) {
			my $file = $profile->GetBindFile("petsel","$size$sel.txt");
			ts2CreateSet($profile,$PetSel,$size,$sel,$file);
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $PetSel = $profile->PetSel;
	cbCheckConflict($PetSel,"selnext","Select next henchman");
	cbCheckConflict($PetSel,"selprev","Select previous henchman");
	cbCheckConflict($PetSel,"sizeup","Increase Henchman Group Size");
	cbCheckConflict($PetSel,"sizedn","Decrease Henchman Group Size");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'PetSel'} ? $profile->{'PetSel'}->{'enable'} : undef;
}

1;
