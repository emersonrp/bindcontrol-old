#!/usr/bin/perl

package UI::KeyBindDialog;

use strict;
use Wx qw( :everything );
use parent -norequire, 'Wx::Dialog';

sub makeWindow {
	my $win = UI::KeyBindDialog->new(@_);
	$win->Show();
}

sub new {
	my ($class, $main, $ID, $Current) = @_;

	# Create the Wx dialog
	my $self = $class->SUPER::new( $main, -1, "$UI::Labels::Labels{$ID} Key Binding", wxDefaultPosition, wxDefaultSize, wxWANTS_CHARS);

	# Minimum dialog size
	# $self->SetMinSize( [ 517, 550 ] );

	# Create sizer that will host all controls
	my $sizer = Wx::BoxSizer->new(wxVERTICAL);

	my $a = Wx::StaticText->new( $self, -1, "Press the Key Combo you'd like to use for $UI::Labels::Labels{$ID}" );
	my $b = Wx::StaticText->new( $self, -1, "(Escape to cancel)" );
	my $c = Wx::StaticText->new( $self, Utility::id('KeyBindDialogFeedback'), $Current, wxDefaultPosition, [100,100], wxALIGN_CENTER|wxALIGN_CENTER_VERTICAL|wxEXPAND);

	$sizer->Add( $a, 0, wxALIGN_CENTER );
	$sizer->Add( $b, 0, wxALIGN_CENTER );
	$sizer->Add( $c, 1, wxALIGN_CENTER|wxALIGN_CENTER_VERTICAL|wxEXPAND);


	# Wrap everything in a vbox to add some padding
	my $vbox = Wx::BoxSizer->new(wxVERTICAL);
	$vbox->Add($sizer, 0, wxALL, 10);

	# clearly I'm thinking of this the wrong way.
	for ($a, $b, $c, $self) {
		Wx::Event::EVT_KEY_DOWN   ( $_, \&handleBind );
		Wx::Event::EVT_KEY_UP     ( $_, \&handleBind );
		Wx::Event::EVT_CHAR       ( $_, \&handleBind );

		Wx::Event::EVT_LEFT_DOWN  ( $_, \&handleBind );
		Wx::Event::EVT_MIDDLE_DOWN( $_, \&handleBind );
		Wx::Event::EVT_RIGHT_DOWN ( $_, \&handleBind );
		Wx::Event::EVT_AUX1_DOWN  ( $_, \&handleBind );
		Wx::Event::EVT_AUX2_DOWN  ( $_, \&handleBind );
	}

	$self->SetSizer($vbox);
	$self->Fit;
	$self->CentreOnParent;

	$self->SetKeymap();

	return $self;
}


# Private method to handle on character pressed event
sub handleBind {
	my ($self, $event) = @_;

	return if $self->{'Handling'};  # don't take further input once we've poked a valid key

	$self = $self->GetParent || $self;

	my $evtType = $event->GetEventType;
	my $KeyToBind;

	if ($evtType == wxEVT_KEY_DOWN) {
		my $code = eval { $event->GetKeyCode; };
		# press escape to cancel
		if ($code == Wx::WXK_ESCAPE) { $self->EndModal(wxCANCEL); }
		$KeyToBind = $self->{'keymap'}->{$code};
	} else {
		$KeyToBind = [
			'', # 'button zero'
			'LBUTTON',
			'MBUTTON',
			'RBUTTON',
			'BUTTON4',
			'BUTTON5',
		]->[eval { $event->GetButton }];
	}

	my $keybind;
	# check for each modifier key
	if ($event->ControlDown()) { $keybind .= 'CTRL-'; }
	if ($event->ShiftDown())   { $keybind .= 'SHIFT-'; }
	if ($event->AltDown())     { $keybind .= 'ALT-'; }

	$keybind .= $KeyToBind;

	Wx::Window::FindWindowById(Utility::id('KeyBindDialogFeedback'))->SetLabel("$keybind");
	$self->Layout();

	if ($KeyToBind) {
		# $self->{'Handling'}++; # Don't take further input kthx
		# TODO - blink the selection like a menu selection, then return it.

		# $self->EndModal($keybind);
	}

	$event->Skip(1);

	return;
}

# This keymap code was adapted from PADRE < http://padre.perlide.org/ >.
sub SetKeymap {
	my $self = shift;
	# key choice list
	my %keymap = (
		Wx::WXK_BACK() => 'BACKSPACE',
		Wx::WXK_TAB() => 'TAB',
		Wx::WXK_SPACE() => 'SPACE',
		Wx::WXK_UP() => 'UP',
		Wx::WXK_DOWN() => 'DOWN',
		Wx::WXK_LEFT() => 'LEFT',
		Wx::WXK_RIGHT() => 'RIGHT',
		Wx::WXK_INSERT() => 'INSERT',
		Wx::WXK_DELETE() => 'DELETE',
		Wx::WXK_HOME() => 'HOME',
		Wx::WXK_END() => 'END',
		Wx::WXK_CAPITAL() => 'CAPITAL',
		Wx::WXK_PAGEUP() => 'PAGEUP',
		Wx::WXK_PAGEDOWN() => 'PAGEDOWN',
		Wx::WXK_PRINT() => 'SYSRQ',
		Wx::WXK_SCROLL() => 'SCROLL',
		Wx::WXK_MENU() => 'APPS',
		Wx::WXK_PAUSE() => 'PAUSE',
		Wx::WXK_NUMPAD0() => 'NUMPAD0',
		Wx::WXK_NUMPAD1() => 'NUMPAD1',
		Wx::WXK_NUMPAD2() => 'NUMPAD2',
		Wx::WXK_NUMPAD3() => 'NUMPAD3',
		Wx::WXK_NUMPAD4() => 'NUMPAD4',
		Wx::WXK_NUMPAD5() => 'NUMPAD5',
		Wx::WXK_NUMPAD6() => 'NUMPAD6',
		Wx::WXK_NUMPAD7() => 'NUMPAD7',
		Wx::WXK_NUMPAD8() => 'NUMPAD8',
		Wx::WXK_NUMPAD9() => 'NUMPAD9',
		Wx::WXK_NUMPAD_MULTIPLY() => 'MULTIPLY',
		Wx::WXK_NUMPAD_ADD() => 'ADD',
		Wx::WXK_NUMPAD_SUBTRACT() => 'SUBTRACT',
		Wx::WXK_NUMPAD_DECIMAL() => 'DECIMAL',
		Wx::WXK_NUMPAD_DIVIDE() => 'DIVIDE',
		Wx::WXK_NUMPAD_ENTER() => 'NUMPADENTER',
		Wx::WXK_F1() => 'F1',
		Wx::WXK_F2() => 'F2',
		Wx::WXK_F3() => 'F3',
		Wx::WXK_F4() => 'F4',
		Wx::WXK_F5() => 'F5',
		Wx::WXK_F6() => 'F6',
		Wx::WXK_F7() => 'F7',
		Wx::WXK_F8() => 'F8',
		Wx::WXK_F9() => 'F9',
		Wx::WXK_F10() => 'F10',
		Wx::WXK_F11() => 'F11',
		Wx::WXK_F12() => 'F12',
		Wx::WXK_F13() => 'F13',
		Wx::WXK_F14() => 'F14',
		Wx::WXK_F15() => 'F15',
		Wx::WXK_F16() => 'F16',
		Wx::WXK_F17() => 'F17',
		Wx::WXK_F18() => 'F18',
		Wx::WXK_F19() => 'F19',
		Wx::WXK_F20() => 'F20',
		Wx::WXK_F21() => 'F21',
		Wx::WXK_F22() => 'F22',
		Wx::WXK_F23() => 'F23',
		Wx::WXK_F24() => 'F24',
		ord('~') => 'TILDE',
		ord('-') => '-',
		ord('=') => 'EQUALS',
		ord('[') => '[',
		ord(']') => ']',
		ord("\\") => "\\",
		ord(';') => ';',
		ord("'") => "'",
		ord(',') => 'COMMA',
		ord('.') => '.',
		ord('/') => '/', 
		
	);

	# Add alphanumerics
	for my $alphanum ( 'A' .. 'Z', '0' .. '9' ) {
		$keymap{ord($alphanum)} = $alphanum;
	}

	$self->{'keymap'} = \%keymap;

}
1;
