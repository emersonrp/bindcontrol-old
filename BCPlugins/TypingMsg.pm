#!/usr/bin/perl

use strict;

package BCPlugins::TypingMsg;
use parent 'BCPlugins';


my $typingnotifierlimit = { cmdlist => ["Away From Keyboard","Emote"] };

sub bindsettings {
	my ($profile) = @_;
	my $typing = $profile->{'typing'};
	unless ($typing) {
		$profile->{'typing'} = $typing = { enable => undef };
		# $typing->{'Message'} = "Typing...";
	}
	$typing->{'Message'} &&= "afk $typing->{'Message'}";
	$typing->{'startchat'} ||= "enter";
	$typing->{'slashchat1'} ||= "/";
	$typing->{'slashchat2'} ||= ";";
	$typing->{'autoreply'} ||= "backspace";
	$typing->{'telltarget'} ||= "comma";
	$typing->{'quickchat'} ||= "\'";
	if ($typing->{'dialog'}) {
#		$typing->{'dialog'}:show();
	} else {
#		cbToolTip("Check this to enable the Typing Notifier");
#		my $typingenable = cbCheckBox("Enable Typing Notifer?",$typing->{'enable'},;
#			cbCheckBoxCB(profile,typing,"enable"));
#		# cbToolTip("Choose the message to display when you are typing chat messages or commands");
#		# my $msghbox = cbTextBox("Message",$typing->{'Message'},cbTextBoxCB(profile,typing,"Message"));
#		cbToolTip("Choose the notifier to use when you are typing chat messages or commands");
#		# my $bindcmd = cbTextBox("Bind Command",sbind.Command,cbTextBoxCB(profile,sbind,"Command"),200,nil,100);
#		my $msghbox = cbPowerBindBtn("Notifier",typing,"Message",typingnotifierlimit,nil,nil,profile);
#		cbToolTip("Choose the Key Combo that activates the chat bar");
#		my $starthbox = cbBindBox("Start Chat Key",typing,"startchat",nil,profile);
#		cbToolTip("Choose the first Key Combo that activates the chat bar with a slash already typed");
#		my $slash1hbox = cbBindBox("Primary Slashchat Key",typing,"slashchat1",nil,profile);
#		cbToolTip("Choose the second Key Combo that activates the chat bar with a slash already typed");
#		my $slash2hbox = cbBindBox("Secondary Slashchat Key",typing,"slashchat2",nil,profile);
#		cbToolTip("Choose the Key Combo that autoreplies to incoming tells");
#		my $replyhbox = cbBindBox("Autoreply Key",typing,"autoreply",nil,profile);
#		cbToolTip("Choose the Key Combo that starts a /tell to your current target");
#		my $tellthbox = cbBindBox("Tell Target Key",typing,"telltarget",nil,profile);
#		cbToolTip("Choose the Key Combo that activates quickchat");
#		my $quickhbox = cbBindBox("Quickchat Key",typing,"quickchat",nil,profile);
#		my $expimpbtn = cbImportExportButtons(profile,"typing",module.bindsettings,100,nil,100,nil);
#
#		my $typdlg = iup.dialog{iup.vbox{typingenable,msghbox,starthbox,slash1hbox,slash2hbox,replyhbox,tellthbox,quickhbox,expimpbtn};title = "Chat : Typing Message",mdichild="YES",mdiclient=mdiClient};
#		cbShowDialog(typdlg,218,10,profile,function(self) $typing->{'dialog'} = nil });
#		$typing->{'dialog'} = typdlg;
	}
}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $typing = $profile->{'typing'};

	$typing->{'startchat'}  ||= "enter";
	$typing->{'slashchat1'} ||= "/";
	$typing->{'slashchat2'} ||= ";";
	$typing->{'autoreply'}  ||= "backspace";
	$typing->{'telltarget'} ||= "comma";
	$typing->{'quickchat'}  ||= "\'";

	my $notifier = cbPBindToString($typing->{'Message'}) || "";

	$notifier &&= "\$\$$notifier";
	cbWriteBind($resetfile,$typing->{'startchat'},'show chat$$startchat' . $notifier);
	cbWriteBind($resetfile,$typing->{'slashchat1'},'show chat$$slashchat' . $notifier);
	cbWriteBind($resetfile,$typing->{'slashchat2'},'show chat$$slashchat' . $notifier);
	cbWriteBind($resetfile,$typing->{'autoreply'},'autoreply' . $notifier);
	cbWriteBind($resetfile,$typing->{'telltarget'},'show chat$$beginchat /tell $target, ' . $notifier);
	cbWriteBind($resetfile,$typing->{'quickchat'},'quickchat' . $notifier);
}

sub findconflicts {
	my ($profile) = @_;
	my $typing = $profile->{'typing'};
	cbCheckConflict($typing,"startchat","Start Chat Key");
	cbCheckConflict($typing,"slashchat1","Primary Slashchat Key");
	cbCheckConflict($typing,"slashchat2","Secondary Slashchat Key");
	cbCheckConflict($typing,"autoreply","Autoreply Key");
	cbCheckConflict($typing,"telltarget","Tell Target Key");
	cbCheckConflict($typing,"quickchat","Quickchat Key");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'typing'} ? $profile->{'typing'}->{'enable'} : undef;
}

1;
