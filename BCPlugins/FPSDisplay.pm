#!/usr/bin/perl

use strict;

package BCPlugins::FPSDisplay;

sub bindsettings {
	my ($profile) = @_;
	my $fps = $profile->{'fps'};
	unless ($fps) {
		$fps = {
			enable => undef,
			bindkey => "P",
		};
		$profile->{'fps'} = $fps;
	;
	if ($fps->{'dialog'}) {
#		fps.dialog:show()
	} else {
#		cbToolTip("Check this to enable a Frame Per Second and Network Usage Graph Toggle Bind")
#		local fpsenable = cbCheckBox("Enable FPS and Netgraph Toggle Bind?",fps.enable,cbCheckBoxCB(profile,fps,"enable"))
#		cbToolTip("Choose the Key Combo to toggle the FPS and Netgraph displays")
#		local bindhbox = cbBindBox("Bindkey",fps,"bindkey","FPS Display Toggle",profile)
#		local expimpbtn = cbImportExportButtons(profile,"fps",module.bindsettings,100,nil,100,nil)
#
#		local typdlg = iup.dialog{iup.vbox{fpsenable,bindhbox,expimpbtn};title = "Net : FPS Display Toggle",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#		cbShowDialog(typdlg,218,10,profile,function(self) fps.dialog = nil end)
#		fps.dialog = typdlg
	}
}

sub makebind {
	my ($profile) = @_;
	my $fps = $profile->{'fps'};
	cbWriteBind($profile->{'resetfile'},$fps->{'bindkey'},'++showfps$$++netgraph');
}

sub findconflicts {
	my ($profile) = @_;
	my $fps = $profile->{'fps'};
	cbCheckConflict($fps,"bindkey","FPS Display Toggle")
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'fps'} ? $profile->{'fps'}->{'enable'} : undef;
}

# cbAddModule(module,"FPS Display Toggle","Net")

1;
