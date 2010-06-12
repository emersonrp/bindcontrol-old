#!/usr/bin/perl

use strict;

package BCPlugins::TypingMsg;
use parent 'BCPlugins';

use Wx qw( wxALIGN_RIGHT wxALIGN_CENTER_VERTICAL wxEXPAND );

use Utility qw(id);

my $Typingnotifierlimit = { cmdlist => ["Away From Keyboard","Emote"] };

sub tab {

	my ($self, $parent) = @_;

	my $profile = $Profile::current;

	my $Typing = $profile->{'Typing'};
	unless ($Typing) {
		$profile->{'Typing'} = $Typing = { Enable => undef };
		# $Typing->{'Message'} = "Typing...";
	}
	$Typing->{'Message'} &&= "afk $Typing->{'Message'}";
	$Typing->{'StartChat'} ||= "ENTER";
	$Typing->{'SlashChat1'} ||= "/";
	$Typing->{'SlashChat2'} ||= ";";
	$Typing->{'AutoReply'} ||= "BACKSPACE";
	$Typing->{'TellTarget'} ||= "COMMA";
	$Typing->{'QuickChat'} ||= "\'";

	my $tab = Wx::Panel->new($parent);

	my $sizer = Wx::FlexGridSizer->new(0,2,10,10);

	my $button;
	$button = Wx::Button->new($tab, id('StartChatKey'), $Typing->{'StartChat'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key combo that activates the Chat bar'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Start Chat Key"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);


	$button = Wx::Button->new($tab, id('SlashChat1'), $Typing->{'SlashChat1'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key combo that activates the Chat bar with a slash already typed'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Primary Slashchat"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($tab, id('SlashChat2'), $Typing->{'SlashChat2'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the second key combo that activates the Chat bar with a slash already typed'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Secondary Slashchat"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($tab, id('AutoReply'), $Typing->{'AutoReply'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key combo that Autoreplies to incoming tells'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Autoreply Key"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($tab, id('TellTarget'), $Typing->{'TellTarget'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key combo that starts a /tell to your current target'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Start Chat Key"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);

	$button = Wx::Button->new($tab, id('QuickChat'), $Typing->{'QuickChat'});
	$button->SetToolTip( Wx::ToolTip->new('Choose the key combo that activates Quickchat'));
	$sizer->Add( Wx::StaticText->new($tab, -1, "Quickchat Key"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $button, 0, wxEXPAND);

# # # TODO -- this is shiny, you can compose a multipart emote etc for typing.  Implement this.

	# cbToolTip("Check this to enable the Typing Notifier");
	# my $Typingenable = cbCheckBox("Enable Typing Notifer?",$Typing->{'enable'},;
		# cbCheckBoxCB(profile,Typing,"enable"));
	# cbToolTip("Choose the message to display when you are typing chat messages or commands");
	# my $msghbox = cbTextBox("Message",$Typing->{'Message'},cbTextBoxCB(profile,Typing,"Message"));

	$tab->SetSizer($sizer);

	return ($tab, 'Typing Message');
}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $Typing = $profile->{'Typing'};

	$Typing->{'StartChat'}  ||= "ENTER";
	$Typing->{'SlashChat1'} ||= "/";
	$Typing->{'SlashChat2'} ||= ";";
	$Typing->{'AutoReply'}  ||= "BACKSPACE";
	$Typing->{'TellTarget'} ||= "COMMA";
	$Typing->{'QuickChat'}  ||= "\'";

	my $notifier = cbPBindToString($Typing->{'Message'}) || "";

	$notifier &&= "\$\$$notifier";
	cbWriteBind($resetfile,$Typing->{'StartChat'},'show chat$$startchat' . $notifier);
	cbWriteBind($resetfile,$Typing->{'SlashChat1'},'show chat$$slashchat' . $notifier);
	cbWriteBind($resetfile,$Typing->{'SlashChat2'},'show chat$$slashchat' . $notifier);
	cbWriteBind($resetfile,$Typing->{'AutoReply'},'autoreply' . $notifier);
	cbWriteBind($resetfile,$Typing->{'TellTarget'},'show chat$$beginchat /tell $target, ' . $notifier);
	cbWriteBind($resetfile,$Typing->{'QuickChat'},'quickchat' . $notifier);
}

sub findconflicts {
	my ($profile) = @_;
	my $Typing = $profile->{'Typing'};
	cbCheckConflict($Typing,"StartChat","Start Chat Key");
	cbCheckConflict($Typing,"SlashChat1","Primary Slashchat Key");
	cbCheckConflict($Typing,"SlashChat2","Secondary Slashchat Key");
	cbCheckConflict($Typing,"AutoReply","Autoreply Key");
	cbCheckConflict($Typing,"TellTarget","Tell Target Key");
	cbCheckConflict($Typing,"QuickChat","Quickchat Key");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'Typing'} ? $profile->{'Typing'}->{'enable'} : undef;
}

1;
