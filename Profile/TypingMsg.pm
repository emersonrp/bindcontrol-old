#!/usr/bin/perl

use strict;

package Profile::TypingMsg;
use parent "Profile::ProfileTab";

use Wx qw( :everything );

use Utility qw(id);

my $Typingnotifierlimit = { cmdlist => ["Away From Keyboard","Emote"] };

sub InitKeys {
	my $self = shift;

	$self->Profile->AddModule('Typing');

	$self->Profile->Typing ||= {
		'Enable'              => 0,
		'Message'             => "afk Typing Message",
		'Start Chat'          => 'ENTER',
		'Primary Slashchat'   => '/',
		'Secondary Slashchat' => ';',
		'Autoreply'           => 'BACKSPACE',
		'Tell Target'         => 'COMMA',
		'QuickChat'           => q|'|,
	};
}

sub FillTab {

	my $self = shift;

	$self->TabTitle = 'Typing Message';

	my $Typing = $self->Profile->Typing;
	my $Tab    = $self->Tab;

	my $sizer = Wx::FlexGridSizer->new(0,2,10,10);

	for my $b ( (
		['Start Chat',     'Choose the key combo that activates the Chat bar'],
		['Primary Slashchat',  'Choose the key combo that activates the Chat bar with a slash already typed'],
		['Secondary Slashchat','Choose the second key combo that activates the Chat bar with a slash already typed'],
		['Autoreply',      'Choose the key combo that Autoreplies to incoming tells'],
		['Tell Target',    'Choose the key combo that starts a /tell to your current target'],
		['QuickChat',      'Choose the key combo that activates QuickChat'],
	)) {
		$self->addLabeledButton($sizer, $Typing, @$b);
	}

# # # TODO -- this is shiny, you can compose a multipart emote etc for typing.  Implement this.

	# cbToolTip("Check this to enable the Typing Notifier");
	# my $Typingenable = cbCheckBox("Enable Typing Notifer?",$Typing->{'enable'},;
		# cbCheckBoxCB(profile,Typing,"enable"));
	# cbToolTip("Choose the message to display when you are typing chat messages or commands");
	# my $msghbox = cbTextBox("Message",$Typing->{'Message'},cbTextBoxCB(profile,Typing,"Message"));

	$Tab->SetSizer($sizer);

	return $self;
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
