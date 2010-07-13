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
		Enable      => 1,
		Message     => "afk Typing Message",
		StartChat   => 'ENTER',
		SlashChat   => '/',
		StartEmote  => ';',
		AutoReply   => 'BACKSPACE',
		TellTarget  => 'COMMA',
		QuickChat   => q|'|,
		TypingNotifierEnable => 1,
		TypingNotifier => '',
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
		['StartChat',  'Choose the key combo that activates the Chat bar'],
		['SlashChat',  'Choose the key combo that activates the Chat bar with a slash already typed'],
		['StartEmote', 'Choose the key combo that activates the Chat bar with "/em" already typed'],
		['AutoReply',  'Choose the key combo that AutoReplies to incoming tells'],
		['TellTarget', 'Choose the key combo that starts a /tell to your current target'],
		['QuickChat',  'Choose the key combo that activates QuickChat'],
	)) {
		$sizer->AddLabeledControl({
			value => $b->[0],
			type => 'keybutton',
			module => $Typing,
			parent => $self,
			tooltip => $b->[1],
		});
	}
	$sizer->AddLabeledControl({
		value => 'TypingNotifierEnable',
		type => 'checkbox',
		module => $Typing,
		parent => $self,
		tooltip => "Check this to enable the Typing Notifier",
	});
	$sizer->AddLabeledControl({
		value => 'TypingNotifier',
		type => 'text',
		module => $Typing,
		parent => $self,
		tooltip => "Choose the message to display when you are typing chat messages or commands",
	});

	$topSizer->Add($sizer);
	$self->SetSizer($topSizer);
	$self->TabTitle = 'Typing Message';
	return $self;
}

sub PopulateBindfiles {
	my $profile   = shift->Profile;
	my $ResetFile = $profile->General->{'ResetFile'};
	my $Typing    = $profile->{'Typing'};

	my $Notifier = $Typing->{'TypingNotifier'};
	$Notifier &&= "\$\$$Notifier";

	$ResetFile->SetBind($Typing->{'StartChat'}, 'show chat$$startchat' . $Notifier);
	$ResetFile->SetBind($Typing->{'SlashChat'}, 'show chat$$slashchat' . $Notifier);
	$ResetFile->SetBind($Typing->{'StartEmote'},'show chat$$em ' . $Notifier);
	$ResetFile->SetBind($Typing->{'AutoReply'}, 'autoreply' . $Notifier);
	$ResetFile->SetBind($Typing->{'TellTarget'},'show chat$$beginchat /tell $target, ' . $Notifier);
	$ResetFile->SetBind($Typing->{'QuickChat'}, 'quickchat' . $Notifier);
}

sub findconflicts {
	my ($profile) = @_;
	my $Typing = $profile->{'Typing'};
	cbCheckConflict($Typing,"StartChat", "Start Chat Key");
	cbCheckConflict($Typing,"SlashChat", "Slashchat Key");
	cbCheckConflict($Typing,"StartEmote","Emote Key");
	cbCheckConflict($Typing,"AutoReply", "Autoreply Key");
	cbCheckConflict($Typing,"TellTarget","Tell Target Key");
	cbCheckConflict($Typing,"QuickChat", "Quickchat Key");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'Typing'} ? $profile->{'Typing'}->{'enable'} : undef;
}

UI::Labels::Add({
	Enable => 'Enable Chat Binds',
	Message => '"afk typing" message',
	StartChat => 'Start Chat (no "/")',
	SlashChat => 'Start Chat (with "/")',
	StartEmote => 'Begin emote (types "/em")',
	AutoReply => 'AutoReply to incoming /tell',
	TellTarget => 'Send /tell to current target',
	QuickChat => 'QuickChat',
	TypingNotifierEnable => 'Enable Typing Notifier',
	TypingNotifier => 'Typing Notifier',
});

1;
