#!/usr/bin/perl

# base class for all the individual tabs
package Profile::ProfileTab;

use strict;
use Wx qw( :everything );
use Wx::Event;

use parent -norequire, 'Wx::Panel';

use BindFile;
use UI::KeyBindDialog;
use UI::Labels;
use Utility;

sub new {
	my ($proto, $parent) = @_;
	my $class = ref $proto || $proto;
	my $self = $class->SUPER::new($parent);

	($self->{'TabTitle'} = ref $self) =~ s/Profile:://;

	$self->{'Profile'} = $parent;

	return $self;
}

sub help {
	my ($self, $event) = @_;

	unless ($self->{'HelpWindow'}) {
		my $HelpWindow = Wx::MiniFrame ->new( undef, -1, "$self->{'TabTitle'} Help",);
		my $BoxSizer   = Wx::BoxSizer  ->new( wxVERTICAL );
		my $HelpText   = Wx::StaticText->new( $HelpWindow, -1, $self->HelpText );

		$BoxSizer->Add( $HelpText, 0, wxALIGN_CENTER_VERTICAL, );

		$HelpWindow->SetSizer($BoxSizer);

		$self->{'HelpWindow'} = $HelpWindow;
	}

	$self->{'HelpWindow'}->Show(not $self->{'HelpWindow'}->IsShown);

	return $self->{'HelpWindow'};
}

sub profile { shift()->{'Profile'} }

sub HelpText { qq|Help not currently implemented here.|; }

sub addLabeledButton {
    my ($self, $sizer, $module, $value, $tooltip) = @_;

    my $button = Wx::Button->new($self, Utility::id($value), $module->{$value});
    $button->SetToolTip( Wx::ToolTip->new($tooltip)) if $tooltip;

    $sizer->Add( Wx::StaticText->new($self, -1, ($UI::Labels::Labels{$value} || $value)), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
    $sizer->Add( $button, 0, wxEXPAND );

	Wx::Event::EVT_BUTTON( $self, Utility::id($value),
		sub {
			my $newKey = UI::KeyBindDialog::showWindow($self, $value, $module->{$value});

			# TODO -- check for conflicts
			# my $otherThingWithThatBind = checkConflicts($newKey);

			# update the associated profile var
			$module->{$value} = $newKey;

			# re-label the button
			Wx::Window::FindWindowById(Utility::id($value))->SetLabel($newKey);
		}
	);
}

1;
