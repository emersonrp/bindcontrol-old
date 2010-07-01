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
	my $c = Wx::StaticText->new( $self, -1, $Current, wxDefaultPosition, [100, 100], wxALIGN_CENTER|wxST_NO_AUTORESIZE);

	$sizer->Add( $a, 0, wxALIGN_CENTER );
	$sizer->Add( $b, 0, wxALIGN_CENTER );
	$sizer->Add( $c );


	# Wrap everything in a vbox to add some padding
	my $vbox = Wx::BoxSizer->new(wxVERTICAL);
	$vbox->Add($sizer, 0, wxALL, 10);

	# clearly I'm thinking of this the wrong way.
	for ($a, $b, $c, $self) {
		Wx::Event::EVT_KEY_DOWN   ( $_, \&handleKey    );
		Wx::Event::EVT_KEY_UP     ( $_, \&handleKey    );
		Wx::Event::EVT_CHAR       ( $_, \&handleKey    );

		Wx::Event::EVT_LEFT_DOWN  ( $_, \&handleButton );
		Wx::Event::EVT_MIDDLE_DOWN( $_, \&handleButton );
		Wx::Event::EVT_RIGHT_DOWN ( $_, \&handleButton );
		Wx::Event::EVT_AUX1_DOWN  ( $_, \&handleButton );
		Wx::Event::EVT_AUX2_DOWN  ( $_, \&handleButton );
	}

	$self->SetSizer($vbox);
	$self->Fit;
	$self->CentreOnParent;

	return $self;
}


# Private method to handle on character pressed event
sub handleKey {
	my ($self, $event) = @_;
	my $code  = $event->GetKeyCode;

	if ($code == Wx::WXK_ESCAPE) {
		my $target = $self->GetParent || $self;
		$target->EndModal(wxCANCEL);
	}

	$event->Skip(1);

	return;
}

sub handleButton {
	my ($self, $event) = @_;
	my $button = $event->GetButton;

	$event->Skip(1);

	return;
}

sub keymap {
	my ( $self, $sizer, $ID, $Current ) = @_;

	# key choice list
	my %keymap = (
		'00None'      => -1,
		'01Backspace' => Wx::WXK_BACK,
		'02Tab'       => Wx::WXK_TAB,
		'03Space'     => Wx::WXK_SPACE,
		'04Up'        => Wx::WXK_UP,
		'05Down'      => Wx::WXK_DOWN,
		'06Left'      => Wx::WXK_LEFT,
		'07Right'     => Wx::WXK_RIGHT,
		'08Insert'    => Wx::WXK_INSERT,
		'09Delete'    => Wx::WXK_DELETE,
		'10Home'      => Wx::WXK_HOME,
		'11End'       => Wx::WXK_END,
		'12Page up'   => Wx::WXK_PAGEUP,
		'13Page down' => Wx::WXK_PAGEDOWN,
		'14Enter'     => Wx::WXK_RETURN,
		'15Escape'    => Wx::WXK_ESCAPE,
		'21Numpad 0'  => Wx::WXK_NUMPAD0,
		'22Numpad 1'  => Wx::WXK_NUMPAD1,
		'23Numpad 2'  => Wx::WXK_NUMPAD2,
		'24Numpad 3'  => Wx::WXK_NUMPAD3,
		'25Numpad 4'  => Wx::WXK_NUMPAD4,
		'26Numpad 5'  => Wx::WXK_NUMPAD5,
		'27Numpad 6'  => Wx::WXK_NUMPAD6,
		'28Numpad 7'  => Wx::WXK_NUMPAD7,
		'29Numpad 8'  => Wx::WXK_NUMPAD8,
		'30Numpad 9'  => Wx::WXK_NUMPAD9,
		'31Numpad *'  => Wx::WXK_MULTIPLY,
		'32Numpad +'  => Wx::WXK_ADD,
		'33Numpad -'  => Wx::WXK_SUBTRACT,
		'34Numpad .'  => Wx::WXK_DECIMAL,
		'35Numpad /'  => Wx::WXK_DIVIDE,
		'36F1'        => Wx::WXK_F1,
		'37F2'        => Wx::WXK_F2,
		'38F3'        => Wx::WXK_F3,
		'39F4'        => Wx::WXK_F4,
		'40F5'        => Wx::WXK_F5,
		'41F6'        => Wx::WXK_F6,
		'42F7'        => Wx::WXK_F7,
		'43F8'        => Wx::WXK_F8,
		'44F9'        => Wx::WXK_F9,
		'45F10'       => Wx::WXK_F10,
		'46F11'       => Wx::WXK_F11,
		'47F12'       => Wx::WXK_F12,
	);

	# Add alphanumerics
	for my $alphanum ( 'A' .. 'Z', '0' .. '9' ) {
		$keymap{ '20' . $alphanum } = ord($alphanum);
	}

	# Add symbols
	for my $symbol ( '~', '-', '=', '[', ']', ';', '\'', ',', '.', '/' ) {
		$keymap{ '50' . $symbol } = ord($symbol);
	}

	my @keys = sort keys %keymap;
	for my $key (@keys) {
		$key =~ s/^\d{2}//;
	}

	# Store it for later usage
	$self->{keys} = \@keys;

	return;
}
1;
