#!/usr/bin/perl

use strict;

package Module::TypingMsg;
use parent "Module::Module";

use Wx qw(wxVERTICAL);

use Utility qw(id);

my $Typingnotifierlimit = { cmdlist => ["Away From Keyboard","Emote"] };

our $ModuleName = 'Typing';

sub InitKeys {
	my $self = shift;

	$self->Profile->Typing ||= {
		Enable             => 1,
		Message            => "afk Typing Message",
		StartChat          => 'ENTER',
		PrimarySlashchat   => '/',
		SecondarySlashchat => ';',
		Autoreply          => 'BACKSPACE',
		TellTarget         => 'COMMA',
		QuickChat          => q|'|,
	};
}

sub FillTab {

	my $self = shift;
	my $Typing = $self->Profile->Typing;

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);
	my $sizer = UI::ControlGroup->new($self, 'Chat Binds');

	$sizer->AddLabeledControl({
		value => 'Enable',
		type => 'checkbox',
		module => $Typing,
		parent => $self,
		tooltip => 'Enable / Disable chat binds',
	});
	for my $b ( (
		['StartChat',     'Choose the key combo that activates the Chat bar'],
		['PrimarySlashchat',  'Choose the key combo that activates the Chat bar with a slash already typed'],
		['SecondarySlashchat','Choose the second key combo that activates the Chat bar with a slash already typed'],
		['Autoreply',      'Choose the key combo that Autoreplies to incoming tells'],
		['TellTarget',    'Choose the key combo that starts a /tell to your current target'],
		['QuickChat',      'Choose the key combo that activates QuickChat'],
	)) {
		$sizer->AddLabeledControl({
			value => $b->[0],
			type => 'keybutton',
			module => $Typing,
			parent => $self,
			tooltip => $b->[1],
		});
	}

# # # TODO -- this is shiny, you can compose a multipart emote etc for typing.  Implement this.

	# cbToolTip("Check this to enable the Typing Notifier");
	# my $Typingenable = cbCheckBox("Enable Typing Notifer?",$Typing->{'enable'},;
		# cbCheckBoxCB(profile,Typing,"enable"));
	# cbToolTip("Choose the message to display when you are typing chat messages or commands");
	# my $msghbox = cbTextBox("Message",$Typing->{'Message'},cbTextBoxCB(profile,Typing,"Message"));

	$topSizer->Add($sizer);
	$self->SetSizer($topSizer);
	$self->TabTitle = 'Typing Message';
	return $self;
}

sub PopulateBindfiles {
	my $profile   = shift->Profile;
	my $ResetFile = $profile->General->{'ResetFile'};
	my $Typing    = $profile->{'Typing'};

	$Typing->{'StartChat'}  ||= "ENTER";
	$Typing->{'SlashChat1'} ||= "/";
	$Typing->{'SlashChat2'} ||= ";";
	$Typing->{'AutoReply'}  ||= "BACKSPACE";
	$Typing->{'TellTarget'} ||= "COMMA";
	$Typing->{'QuickChat'}  ||= "\'";

	my $notifier = cbPBindToString($Typing->{'Message'}) || "";

	$notifier &&= "\$\$$notifier";
	cbWriteBind($ResetFile,$Typing->{'StartChat'},'show chat$$startchat' . $notifier);
	cbWriteBind($ResetFile,$Typing->{'SlashChat1'},'show chat$$slashchat' . $notifier);
	cbWriteBind($ResetFile,$Typing->{'SlashChat2'},'show chat$$slashchat' . $notifier);
	cbWriteBind($ResetFile,$Typing->{'AutoReply'},'autoreply' . $notifier);
	cbWriteBind($ResetFile,$Typing->{'TellTarget'},'show chat$$beginchat /tell $target, ' . $notifier);
	cbWriteBind($ResetFile,$Typing->{'QuickChat'},'quickchat' . $notifier);
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

UI::Labels::Add({
	Enable => 'Enable Chat Binds',
	Message => '"afk typing" message',
	StartChat => 'Start Chat',
	PrimarySlashchat => 'Start Chat with / already supplied',
	SecondarySlashchat => 'Alternate Start Chat with / already supplied',
	AutoReply => 'Auto Reply to incoming /tell',
	TellTarget => 'Send /tell to current target',
	Quickchat => 'QuickChat',
});

1;
