#!/usr/bin/perl

use strict;

package BCPlugins::TeamSel;
use parent "BCPlugins";

sub bindsettings {
	my ($profile) = @_;
	my $teamsel = $profile->{'teamsel'};
	unless ($teamsel) {
		$profile->{'teamsel'} = $teamsel = {};
	}
	$teamsel->{'mode'} ||= 1;
	for (1..8) { $teamsel->{"sel$_"} ||= 'unbound' }
	if ($teamsel->{'dialog'}) {
#		$teamsel->{'dialog'}:show()
	} else {
#		my $credits = iup.hbox{iup.fill{};iup.vbox{iup.fill{size="5"};iup.label{title="Team/Pet Selection binds contributed by ShieldBearer."};iup.fill{size="5"};alignment="ACENTER"};iup.fill{};alignment="ACENTER";rastersize="300x"}
#		cbToolTip("Check this to enable the Team/Pet Select Binds")
#		my $teamselenable = cbCheckBox("Enable Team/Pet Selector",$teamsel->{'enable'},cbCheckBoxCB(profile,teamsel,"enable"),300)
#		cbToolTip("Choose the order in which teammates and pets are selected with sequential keypresses")
#		my $tsmode = cbListBox("Select Order",{"Teammates, then Pets","Pets, then Teammates","Teammates Only","Pets Only"},4,
#			$teamsel->{'mode'},cbListBoxCB(profile,teamsel,"mode"),200)
#		cbToolTip("Choose the Key Combo that will select your first Teammate/Pet")
#		my $sel1hbox = cbBindBox("Team/Pet 1 Key",teamsel,"sel1","Team/Pet 1 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your second Teammate/Pet")
#		my $sel2hbox = cbBindBox("Team/Pet 2 Key",teamsel,"sel2","Team/Pet 2 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your third Teammate/Pet")
#		my $sel3hbox = cbBindBox("Team/Pet 3 Key",teamsel,"sel3","Team/Pet 3 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your fourth Teammate/Pet")
#		my $sel4hbox = cbBindBox("Team/Pet 4 Key",teamsel,"sel4","Team/Pet 4 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your fifth Teammate/Pet")
#		my $sel5hbox = cbBindBox("Team/Pet 5 Key",teamsel,"sel5","Team/Pet 5 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your sixth Teammate/Pet")
#		my $sel6hbox = cbBindBox("Team/Pet 6 Key",teamsel,"sel6","Team/Pet 6 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your seventh Teammate/Pet")
#		my $sel7hbox = cbBindBox("Team/Pet 7 Key",teamsel,"sel7","Team/Pet 7 Key",profile,100,nil,200)
#		cbToolTip("Choose the Key Combo that will select your eighth Teammate/Pet")
#		my $sel8hbox = cbBindBox("Team/Pet 8 Key",teamsel,"sel8","Team/Pet 8 Key",profile,100,nil,200)
#		my $expimpbtn = cbImportExportButtons(profile,"teamsel",module.bindsettings,150,nil,150,nil)
#	
#		my $typdlg = iup.dialog{iup.vbox{credits,teamselenable,tsmode,sel1hbox,sel2hbox,sel3hbox,sel4hbox,sel5hbox,sel6hbox,sel7hbox,sel8hbox,expimpbtn};title = "Gameplay : Team/Pet Selector",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#		cbShowDialog(typdlg,218,10,profile,function(self) $teamsel->{'dialog'} = nil end)
#		$teamsel->{'dialog'} = typdlg
	}
}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $teamsel = $profile->{'teamsel'};
	cbMakeDirectory($profile->{'base'}.'\\teamsel');
	if ($teamsel->{'mode'} < 3) {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		my $selmethod1 = "petselect";
		my $selnummod1 = 1;
		if ($teamsel->{'mode'} == 2) {
			$selmethod = "petselect";
			$selnummod = 1;
			$selmethod1 = "teamselect";
			$selnummod1 = 0;
		}
		my $selresetfile = cbOpen($profile->{'base'}..'\\teamsel\\reset.txt','w');
		my @selfile;
		for my $i (1..8) {
			$selfile[$i] = cbOpen($profile->{'base'}.."\\teamsel\\sel${i}.txt",'w');
			cbWriteBind($resetfile,   $teamsel->{"sel$i"},"$selmethod " . ($i - $selnummod) . '$$bindloadfile '.$profile->{'base'}."\\teamsel\\sel${i}.txt");
			cbWriteBind($selresetfile,$teamsel->{"sel$i"},"$selmethod " . ($i - $selnummod) . '$$bindloadfile '.$profile->{'base'}."\\teamsel\\sel${i}.txt");
		}
		for my $i (1..8) {
			for my $j (1..8) {
				if ($i == $j) {
					cbWriteBind($selfile[$i],$teamsel->{"sel$j"},"$selmethod1 " . ($j - $selnummod1) . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\reset.txt");
				} else {
					cbWriteBind($selfile[$i],$teamsel->{"sel$j"},"$selmethod " .  ($j - $selnummod)  . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\sel$j.txt");
				}
			}
		}
		close $selresetfile;
		for (1..8) { close $selfile[$_]; }
	} else {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		if ($teamsel->{'mode'} == 4) {
			$selmethod = "petselect";
			$selnummod = 1;
		}
		for my $i (1..8) {
			cbWriteBind($resetfile,$teamsel->{'sel1'},"$selmethod " . ($i - $selnummod));
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $teamsel = $profile->{'teamsel'};
	for my $i (1..8) { cbCheckConflict($teamsel,"sel$i","Team/Pet $i Key") }
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'teamsel'} ? $profile->{'teamsel'}->{'enable'} : undef;
}

1;
