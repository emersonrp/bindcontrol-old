#!/usr/bin/perl

use strict;

package BCPlugins::PetSel;


sub bindsettings {
	my ($profile) = @_;
	my $petsel = $profile->{'petsel'};
	if (not $petsel) {
		$petsel = {};
		$profile->{'petsel'} = $petsel;
	}
	if ($petsel->{'dialog'}) {
#		petsel.dialog:show()
	} else {
#		local credits = iup.hbox{iup.fill{};iup.vbox{iup.fill{size="5"};iup.label{title="Single Key Pet Selection binds\nbased on binds from Weap0nX."};iup.fill{size="5"};alignment="ACENTER"};iup.fill{};alignment="ACENTER";rastersize="300x"}
#		cbToolTip("Check this to enable the Single Key Pet Select Binds")
#		local petselenable = cbCheckBox("Enable Pet Selector",petsel.enable,cbCheckBoxCB(profile,petsel,"enable"),300)
#		local selnext = cbBindBox("Select next henchman",petsel,"selnext",nil,profile,nil,nil,200)
#		local selprev = cbBindBox("Select previous henchman",petsel,"selprev",nil,profile,nil,nil,200)
#		local sizeup = cbBindBox("Increase Henchman Group Size",petsel,"sizeup",nil,profile,nil,nil,200)
#		local sizedn = cbBindBox("Decrease Henchman Group Size",petsel,"sizedn",nil,profile,nil,nil,200)
#		local expimpbtn = cbImportExportButtons(profile,"petsel",module.bindsettings,150,nil,150,nil)
#	
#		local typdlg = iup.dialog{iup.vbox{credits,petselenable,selnext,selprev,sizeup,sizedn,reset,expimpbtn};title = "Mastermind : Single Key Pet Selector",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#		cbShowDialog(typdlg,218,10,profile,function(self) petsel.dialog = nil })
#		petsel.dialog = typdlg
	}
}

my @post = qw( First Second Third Fourth Fifth Sixth Seventh Eighth );

sub formatPetConfig { "[" . shift() . " Pet ]" }

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
	for my $size (1,8) {
		for my $sel (0, $size) {
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

# cbAddModule(module,"Single Key Pet Selector","Mastermind");
