#!/usr/bin/perl

package BCPlugins::InspirationPopper;

use strict;
use parent "BCPlugins";

sub bindsettings {
	my ($profile) = @_;
	my $inspop = $profile->{'inspop'};
	unless ($inspop) {
		$inspop = {
			enable => undef,
			acckey => "lshift+a",
			hpkey => "lshift+s",
			damkey => "lshift+d",
			endkey => "lshift+q",
			defkey => "lshift+w",
			bfkey => "lshift+e",
			reskey => "lshift+space",
		};
		$profile->{'inspop'} = $inspop;
	}
	$inspop->{'racckey'} ||= 'unbound';
	$inspop->{'rhpkey'}  ||= 'unbound';
	$inspop->{'rdamkey'} ||= 'unbound';
	$inspop->{'rendkey'} ||= 'unbound';
	$inspop->{'rdefkey'} ||= 'unbound';
	$inspop->{'rbfkey'}  ||= 'unbound';
	$inspop->{'rreskey'} ||= 'unbound';

	$inspop->{'acccolors'} = cbChatColorInit($inspop->{'acccolors'});
	$inspop->{'hpcolors'} = cbChatColorInit($inspop->{'hpcolors'});
	$inspop->{'damcolors'} = cbChatColorInit($inspop->{'damcolors'});
	$inspop->{'endcolors'} = cbChatColorInit($inspop->{'endcolors'});
	$inspop->{'defcolors'} = cbChatColorInit($inspop->{'defcolors'});
	$inspop->{'bfcolors'} = cbChatColorInit($inspop->{'bfcolors'});
	$inspop->{'rescolors'} = cbChatColorInit($inspop->{'rescolors'});
	$inspop->{'racccolors'} = cbChatColorInit($inspop->{'racccolors'});
	$inspop->{'rhpcolors'} = cbChatColorInit($inspop->{'rhpcolors'});
	$inspop->{'rdamcolors'} = cbChatColorInit($inspop->{'rdamcolors'});
	$inspop->{'rendcolors'} = cbChatColorInit($inspop->{'rendcolors'});
	$inspop->{'rdefcolors'} = cbChatColorInit($inspop->{'rdefcolors'});
	$inspop->{'rbfcolors'} = cbChatColorInit($inspop->{'rbfcolors'});
	$inspop->{'rrescolors'} = cbChatColorInit($inspop->{'rrescolors'});
	if ($inspop->{'dialog'}) {
#		$inspop->{'dialog'}:show();
	} else {
#		cbToolTip("Check this to enable the standard Inspiration Popper Binds");
#		my $inspopenable = cbCheckBox("Enable Inspiration Popper (Big Insps Used First)",$inspop->{'enable'},cbCheckBoxCB(profile,$inspop,"enable"),300);
#		cbToolTip("Choose the Key Combo that will activate an Accuracy Inspiration");
#		my $acchbox = cbBindBox("Accuracy Key",$inspop,"acckey","Accuracy Key",profile,100,nil,150);
#		my $acccolors = cbChatColors(profile,$inspop->{'acccolors'});
#		cbToolTip("Choose the Key Combo that will activate a Healing Inspiration");
#		my $hphbox = cbBindBox("Healing Key",$inspop,"hpkey","Healing Key",profile,100,nil,150);
#		my $hpcolors = cbChatColors(profile,$inspop->{'hpcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Damage Inspiration");
#		my $damhbox = cbBindBox("Damage Key",$inspop,"damkey","Damage Key",profile,100,nil,150);
#		my $damcolors = cbChatColors(profile,$inspop->{'damcolors'});
#		cbToolTip("Choose the Key Combo that will activate an Endurance Inspiration");
#		my $endhbox = cbBindBox("Endurance Key",$inspop,"endkey","Endurance Key",profile,100,nil,150);
#		my $endcolors = cbChatColors(profile,$inspop->{'endcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Defense Inspiration");
#		my $defhbox = cbBindBox("Defense Key",$inspop,"defkey","Defense Key",profile,100,nil,150);
#		my $defcolors = cbChatColors(profile,$inspop->{'defcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Breakfree Inspiration");
#		my $bfhbox = cbBindBox("Breakfree Key",$inspop,"bfkey","Breakfree Key",profile,100,nil,150);
#		my $bfcolors = cbChatColors(profile,$inspop->{'bfcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Resistance Inspiration");
#		my $reshbox = cbBindBox("Resistance Key",$inspop,"reskey","Resistance Key",profile,100,nil,150);
#		my $rescolors = cbChatColors(profile,$inspop->{'rescolors'});
#		cbToolTip("Check this to use Smaller Inspirations before Using Bigger Inspirations");
#		my $inspopreverse = cbCheckBox("Enable Reverse Inspiration Popper (Small Insps Used First)",$inspop->{'reverse'},cbCheckBoxCB(profile,$inspop,"reverse"),300);
#		cbToolTip("Choose the Key Combo that will activate an Accuracy Inspiration");
#		my $racchbox = cbBindBox("Reverse Accuracy Key",$inspop,"racckey","Accuracy Key",profile,100,nil,150);
#		my $racccolors = cbChatColors(profile,$inspop->{'racccolors'});
#		cbToolTip("Choose the Key Combo that will activate a Healing Inspiration");
#		my $rhphbox = cbBindBox("Reverse Healing Key",$inspop,"rhpkey","Healing Key",profile,100,nil,150);
#		my $rhpcolors = cbChatColors(profile,$inspop->{'rhpcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Damage Inspiration");
#		my $rdamhbox = cbBindBox("Reverse Damage Key",$inspop,"rdamkey","Damage Key",profile,100,nil,150);
#		my $rdamcolors = cbChatColors(profile,$inspop->{'rdamcolors'});
#		cbToolTip("Choose the Key Combo that will activate an Endurance Inspiration");
#		my $rendhbox = cbBindBox("Reverse Endurance Key",$inspop,"rendkey","Endurance Key",profile,100,nil,150);
#		my $rendcolors = cbChatColors(profile,$inspop->{'rendcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Defense Inspiration");
#		my $rdefhbox = cbBindBox("Reverse Defense Key",$inspop,"rdefkey","Defense Key",profile,100,nil,150);
#		my $rdefcolors = cbChatColors(profile,$inspop->{'rdefcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Breakfree Inspiration");
#		my $rbfhbox = cbBindBox("Reverse Breakfree Key",$inspop,"rbfkey","Breakfree Key",profile,100,nil,150);
#		my $rbfcolors = cbChatColors(profile,$inspop->{'rbfcolors'});
#		cbToolTip("Choose the Key Combo that will activate a Resistance Inspiration");
#		my $rreshbox = cbBindBox("Reverse Resistance Key",$inspop,"rreskey","Resistance Key",profile,100,nil,150);
#		my $rrescolors = cbChatColors(profile,$inspop->{'rrescolors'});
#		cbToolTip("Check this to Disable Self tells when using inspiration popper");
#		my $inspopdisablefeedback = cbCheckBox("Disable Self-tells",$inspop->{'turnofffeedback'},cbCheckBoxCB(profile,$inspop,"turnofffeedback"),300);
#		my $expimpbtn = cbImportExportButtons(profile,"inspop",module.bindsettings,150,nil,150,nil);
#	
#		my $typdlg = iup.dialog{iup.vbox{
#			inspopenable,
#			iup.hbox{acchbox,acccolors},
#			iup.hbox{hphbox,hpcolors},
#			iup.hbox{damhbox,damcolors},
#			iup.hbox{endhbox,endcolors},
#			iup.hbox{defhbox,defcolors},
#			iup.hbox{bfhbox,bfcolors},
#			iup.hbox{reshbox,rescolors},
#			inspopreverse,
#			iup.hbox{racchbox,racccolors},
#			iup.hbox{rhphbox,rhpcolors},
#			iup.hbox{rdamhbox,rdamcolors},
#			iup.hbox{rendhbox,rendcolors},
#			iup.hbox{rdefhbox,rdefcolors},
#			iup.hbox{rbfhbox,rbfcolors},
#			iup.hbox{rreshbox,rrescolors},
#			inspopdisablefeedback,
#			expimpbtn};
#			title = "Gameplay : Inspiration Popper",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#		cbShowDialog(typdlg,218,10,profile,function(self) inspop->{'dialog'} = nil end);
#		$inspop->{'dialog'} = typdlg;
	}
}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $inspop = $profile->{'inspop'};
	if ($inspop->{'turnofffeedback'}) {
		if ($inspop->{'enable'}) {
			cbWriteBind($resetfile,$inspop->{'acckey'},'inspexecname Insight$$inspexecname Keen Insight$$inspexecname Uncanny Insight');
			cbWriteBind($resetfile,$inspop->{'hpkey'},'inspexecname Respite$$inspexecname Dramatic Improvement$$inspexecname Resurgance');
			cbWriteBind($resetfile,$inspop->{'damkey'},'inspexecname Enrage$$inspexecname Focused Rage$$inspexecname Righteous Rage');
			cbWriteBind($resetfile,$inspop->{'endkey'},'inspexecname Catch a Breath$$inspexecname Take a Breather$$inspexecname Second Wind');
			cbWriteBind($resetfile,$inspop->{'defkey'},'inspexecname Luck$$inspexecname Good Luck$$inspexecname Phenomenal Luck');
			cbWriteBind($resetfile,$inspop->{'bfkey'},'inspexecname Break Free$$inspexecname Emerge$$inspexecname Escape');
			cbWriteBind($resetfile,$inspop->{'reskey'},'inspexecname Sturdy$$inspexecname Rugged$$inspexecname Robust');
		}
		if ($inspop->{'reverse'}) {
			cbWriteBind($resetfile,$inspop->{'racckey'},'inspexecname Uncanny Insight$$inspexecname Keen Insight$$inspexecname Insight');
			cbWriteBind($resetfile,$inspop->{'rhpkey'},'inspexecname Resurgance$$inspexecname Dramatic Improvement$$inspexecname Respite');
			cbWriteBind($resetfile,$inspop->{'rdamkey'},'inspexecname Righteous Rage$$inspexecname Focused Rage$$inspexecname Enrage');
			cbWriteBind($resetfile,$inspop->{'rendkey'},'inspexecname Second Wind$$inspexecname Take a Breather$$inspexecname Catch a Breath');
			cbWriteBind($resetfile,$inspop->{'rdefkey'},'inspexecname Phenomenal Luck$$inspexecname Good Luck$$inspexecname Luck');
			cbWriteBind($resetfile,$inspop->{'rbfkey'},'inspexecname Escape$$inspexecname Emerge$$inspexecname Break Free');
			cbWriteBind($resetfile,$inspop->{'rreskey'},'inspexecname Robust$$inspexecname Rugged$$inspexecname Sturdy');
		}
	} else {
		if ($inspop->{'enable'}) {
			cbWriteBind($resetfile,$inspop->{'acckey'},'tell $name, '.cbChatColorOutput($inspop->{'acccolors'}).'ACC$$inspexecname Insight$$inspexecname Keen Insight$$inspexecname Uncanny Insight');
			cbWriteBind($resetfile,$inspop->{'hpkey'},'tell $name, '.cbChatColorOutput($inspop->{'hpcolors'}).'HP$$inspexecname Respite$$inspexecname Dramatic Improvement$$inspexecname Resurgance');
			cbWriteBind($resetfile,$inspop->{'damkey'},'tell $name, '.cbChatColorOutput($inspop->{'damcolors'}).'DAM$$inspexecname Enrage$$inspexecname Focused Rage$$inspexecname Righteous Rage');
			cbWriteBind($resetfile,$inspop->{'endkey'},'tell $name, '.cbChatColorOutput($inspop->{'endcolors'}).'END$$inspexecname Catch a Breath$$inspexecname Take a Breather$$inspexecname Second Wind');
			cbWriteBind($resetfile,$inspop->{'defkey'},'tell $name, '.cbChatColorOutput($inspop->{'defcolors'}).'DEF$$inspexecname Luck$$inspexecname Good Luck$$inspexecname Phenomenal Luck');
			cbWriteBind($resetfile,$inspop->{'bfkey'},'tell $name, '.cbChatColorOutput($inspop->{'bfcolors'}).'BF$$inspexecname Break Free$$inspexecname Emerge$$inspexecname Escape');
			cbWriteBind($resetfile,$inspop->{'reskey'},'tell $name, '.cbChatColorOutput($inspop->{'rescolors'}).'RES$$inspexecname Sturdy$$inspexecname Rugged$$inspexecname Robust');
		}
		if ($inspop->{'reverse'}) {
			cbWriteBind($resetfile,$inspop->{'racckey'},'tell $name, '.cbChatColorOutput($inspop->{'racccolors'}).'acc$$inspexecname Uncanny Insight$$inspexecname Keen Insight$$inspexecname Insight');
			cbWriteBind($resetfile,$inspop->{'rhpkey'},'tell $name, '.cbChatColorOutput($inspop->{'rhpcolors'}).'hp$$inspexecname Resurgance$$inspexecname Dramatic Improvement$$inspexecname Respite');
			cbWriteBind($resetfile,$inspop->{'rdamkey'},'tell $name, '.cbChatColorOutput($inspop->{'rdamcolors'}).'dam$$inspexecname Righteous Rage$$inspexecname Focused Rage$$inspexecname Enrage');
			cbWriteBind($resetfile,$inspop->{'rendkey'},'tell $name, '.cbChatColorOutput($inspop->{'rendcolors'}).'end$$inspexecname Second Wind$$inspexecname Take a Breather$$inspexecname Catch a Breath');
			cbWriteBind($resetfile,$inspop->{'rdefkey'},'tell $name, '.cbChatColorOutput($inspop->{'rdefcolors'}).'def$$inspexecname Phenomenal Luck$$inspexecname Good Luck$$inspexecname Luck');
			cbWriteBind($resetfile,$inspop->{'rbfkey'},'tell $name, '.cbChatColorOutput($inspop->{'rbfcolors'}).'bf$$inspexecname Escape$$inspexecname Emerge$$inspexecname Break Free');
			cbWriteBind($resetfile,$inspop->{'rreskey'},'tell $name, '.cbChatColorOutput($inspop->{'rrescolors'}).'res$$inspexecname Robust$$inspexecname Rugged$$inspexecname Sturdy');
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $inspop = $profile->{'inspop'};
	if ($inspop->{'enable'}) {
		cbCheckConflict($inspop,'acckey',"Accuracy Key");
		cbCheckConflict($inspop,'hpkey',"Healing Key");
		cbCheckConflict($inspop,'damkey',"Damage Key");
		cbCheckConflict($inspop,'endkey',"Endurance Key");
		cbCheckConflict($inspop,'defkey',"Defense Key");
		cbCheckConflict($inspop,'bfkey',"Breakfree Key");
		cbCheckConflict($inspop,'reskey',"Resistance Key");
	}
	if ($inspop->{'reverse'}) {
		cbCheckConflict($inspop,'racckey',"Reverse Accuracy Key");
		cbCheckConflict($inspop,'rhpkey',"Reverse Healing Key");
		cbCheckConflict($inspop,'rdamkey',"Reverse Damage Key");
		cbCheckConflict($inspop,'rendkey',"Reverse Endurance Key");
		cbCheckConflict($inspop,'rdefkey',"Reverse Defense Key");
		cbCheckConflict($inspop,'rbfkey',"Reverse Breakfree Key");
		cbCheckConflict($inspop,'rreskey',"Reverse Resistance Key");
	}
}

sub bindisused {
	my ($profile) = @_;
	return unless $profile->{'inspop'};
	return $profile-{'inspop'}->{'enable'} || $profile->{'inspop'}->{'reverse'};
}

1;
