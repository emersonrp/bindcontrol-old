#!/usr/bin/perl

use strict;

package BCPlugins::TeamSel2;
use parent 'BCPlugins';

sub bindsettings {
	my ($profile) = @_;
	my $teamsel2 = $profile->{'teamsel2'};
	unless ($teamsel2) {
		$profile->{'teamsel2'} = $teamsel2 = {};
	}
	if ($teamsel2->{'dialog'}) {
#		teamsel2.dialog:show()
	} else {
#		my $credits = iup.hbox{iup.fill{};iup.vbox{iup.fill{size="5"};iup.label{title="Single Key Team Selection binds\nbased on binds from Weap0nX."};iup.fill{size="5"};alignment="ACENTER"};iup.fill{};alignment="ACENTER";rastersize="300x"}
#		cbToolTip("Check this to enable the Single Key Team Select Binds")
#		my $teamselenable = cbCheckBox("Enable Team Selector",teamsel2.enable,cbCheckBoxCB(profile,teamsel2,"enable"),300)
#		my $selnext = cbBindBox("Select next team member",teamsel2,"selnext",nil,profile,nil,nil,200)
#		my $selprev = cbBindBox("Select previous team member",teamsel2,"selprev",nil,profile,nil,nil,200)
#		my $sizeup = cbBindBox("Increase Team Size",teamsel2,"sizeup",nil,profile,nil,nil,200)
#		my $sizedn = cbBindBox("Decrease Team Size",teamsel2,"sizedn",nil,profile,nil,nil,200)
#		my $posup = cbBindBox("Increase Team Position",teamsel2,"posup",nil,profile,nil,nil,200)
#		my $posdn = cbBindBox("Decrease Team Position",teamsel2,"posdn",nil,profile,nil,nil,200)
#		my $reset = cbBindBox("Reset to Solo Key",teamsel2,"reset",nil,profile,nil,nil,200)
#		my $expimpbtn = cbImportExportButtons(profile,"teamsel2",module.bindsettings,150,nil,150,nil)
#	
#		my $typdlg = iup.dialog{iup.vbox{credits,teamselenable,selnext,selprev,sizeup,sizedn,posup,posdn,reset,expimpbtn};title = "Gameplay : Single Key Team Selector",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#		cbShowDialog(typdlg,218,10,profile,function(self) teamsel2.dialog = nil })
#		teamsel2.dialog = typdlg
	}
}

my @post = qw( First Second Third Fourth Fifth Sixth Seventh Eighth );

sub formatTeamConfig {
	my ($size,$pos) = @_;
	my $sizetext = "$size-Man";
	my $postext = ", No Spot";
	if ($pos > 0) { $postext = ", $post[$pos] Spot" }
	if ($size == 1) { $sizetext = "Solo"; $postext = "" }
	if ($size == 2) { $sizetext = "Duo" }
	if ($size == 3) { $sizetext = "Trio" }
	return "[$sizetext$postext]";
}

sub ts2CreateSet {
	my ($profile,$ts2,$tsize,$tpos,$tsel,$file) = @_;
	#  tsize is the size of the team at the moment
	#  tpos is the position of the player at the moment, or 0 if unknown
	#  tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	$file->SetBind($ts2->{'reset'},'tell $name, Re-Loaded Single Key Team Select Bind.$$bindloadfile ' . $profile->{'base'} . '\\teamsel2\\100.txt');
	if ($tsize < 8) {
		$file->SetBind($ts2->{'sizeup'},'tell $name, ' . formatTeamConfig($tsize+1,$tpos) . '$$bindloadfile ' . $profile->{'base'} . '\\teamsel2\\' . ($tsize+1) . $tpos . $tsel . '.txt');
	} else {
		$file->SetBind($ts2->{'sizeup'},'nop');
	}
	if ($tsize == 1) {
		$file->SetBind($ts2->{'sizedn'}, 'nop');
		$file->SetBind($ts2->{'posup'},  'nop');
		$file->SetBind($ts2->{'posdn'},  'nop');
		$file->SetBind($ts2->{'selnext'},'nop');
		$file->SetBind($ts2->{'selprev'},'nop');
	} else {
		my ($selnext,$selprev) = ($tsel+1,$tsel-1);
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1)      { $selprev = $tsize }
		if ($selnext == $tpos) { $selnext = $selnext + 1 }
		if ($selprev == $tpos) { $selprev = $selprev - 1 }
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1) { $selprev = $tsize }

		my ($tposup,$tposdn) = ($tpos+1,$tpos-1);
		if ($tposup > $tsize) { $tposup = 0 }
		if ($tposdn < 0)      { $tposdn = $tsize }

		my ($newpos,$newsel) = ($tpos,$tsel);
		if ($tsize-1 < $tpos) { $newpos = $tsize-1 }
		if ($tsize-1 < $tsel) { $newsel = $tsize-1 }
		if ($tsize == 2)      { $newpos = $newsel = 0 }

		$file->SetBind($ts2->{'sizedn'},'tell $name, ' . formatTeamConfig($tsize-1,$newpos) . '$$bindloadfile ' . $profile->{'base'} . "\\teamsel2\\" . ($tsize-1) . $newpos . $newsel . '.txt');
		$file->SetBind($ts2->{'posup'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposup) . '$$bindloadfile ' . $profile->{'base'} . "\\teamsel2\\" . $tsize . $tposup . $tsel . '.txt');
		$file->SetBind($ts2->{'posdn'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposdn) . '$$bindloadfile ' . $profile->{'base'} . "\\teamsel2\\" . $tsize . $tposdn . $tsel . '.txt');

		$file->SetBind($ts2->{'selnext'},'teamselect ' . $selnext . '$$bindloadfile ' . $profile->{'base'} . "\\teamsel2\\" . $tsize . $tpos . $selnext . '.txt');
		$file->SetBind($ts2->{'selprev'},'teamselect ' . $selprev . '$$bindloadfile ' . $profile->{'base'} . "\\teamsel2\\" . $tsize . $tpos . $selprev . '.txt');
	}
}

sub makebind {
	my ($profile) = @_;
	my $teamsel2 = $profile->{'teamsel2'};
	cbMakeDirectory($profile->{'base'} . '\\teamsel2');
	ts2CreateSet($profile,$teamsel2,1,0,0,$profile->{'resetfile'});
	for my $size (1..8) {
		for my $pos (0..$size) {
			for my $sel (0..$size) {
				unless (($sel != pos) or ($sel == 0)) {
					my $file = BindFile->new($profile->{'base'} . '\\teamsel2\\' . $size . $pos . $sel . '.txt');
					ts2CreateSet($profile,$teamsel2,$size,$pos,$sel,$file);
				}
			}
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $teamsel2 = $profile->{'teamsel2'};
	cbCheckConflict($teamsel2,"selnext","Select next team member");
	cbCheckConflict($teamsel2,"selprev","Select previous team member");
	cbCheckConflict($teamsel2,"sizeup","Increase Team Size");
	cbCheckConflict($teamsel2,"sizedn","Decrease Team Size");
	cbCheckConflict($teamsel2,"posup","Increase Team Position");
	cbCheckConflict($teamsel2,"posdn","Decrease Team Position");
	cbCheckConflict($teamsel2,"reset","Reset to Solo Key");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'teamsel2'} ? $profile->{'teamsel2'}->{'enable'} : undef;
}

1;
