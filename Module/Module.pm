#!/usr/bin/perl

# base class for all the individual tabs
package Module::Module;

use strict;
use Wx qw();
use Wx::Event;

use BindFile;
use UI::KeyBindDialog;
use UI::Labels;
use Utility;

sub new {
	my ($proto, $parent) = @_;
	my $class = ref $proto || $proto;

	my $self = {};
	bless $self, $class;

	no strict 'refs';
	$self->Name = ${"${class}::ModuleName"};
	use strict;

	$self->Profile = $parent;
	$self->Tab = Wx::Panel->new($parent);

	return $self;
}

sub help {
	my ($self, $event) = @_;

	unless ($self->{'HelpWindow'}) {
		my $HelpWindow = Wx::MiniFrame ->new( undef, -1, "$self->{'TabTitle'} Help",);
		my $BoxSizer   = Wx::BoxSizer  ->new( Wx::wxVERTICAL );
		my $HelpText   = Wx::StaticText->new( $HelpWindow, -1, $self->HelpText );

		$BoxSizer->Add( $HelpText, 0, Wx::wxALIGN_CENTER_VERTICAL, );

		$HelpWindow->SetSizer($BoxSizer);

		$self->{'HelpWindow'} = $HelpWindow;
	}

	$self->{'HelpWindow'}->Show(not $self->{'HelpWindow'}->IsShown);

	return $self->{'HelpWindow'};
}

# Accessors
sub Tab        : lvalue { shift->{'Tab'} }
sub Name       : lvalue { shift->{'Name'} }
sub TabTitle   : lvalue { shift->{'TabTitle'} }
sub Profile    : lvalue { shift->{'Profile'} }

# stubs
sub InitKeys          { 1; }
sub PopulateBindFiles {print STDERR "stub PopBindFiles\n"; 1; }
sub FillTab           { my $self = shift; ($self->TabTitle   = ref $self) =~ s/Module:://; }
sub HelpText          { qq|Help not currently implemented here.|; }


# TODO this really doesn't completely belong here, hmm.
sub addLabeledButton {
    my ($self, $sizer, $module, $value, $tooltip) = @_;

    my $button = Wx::Button->new($self->Tab, Utility::id($value), $module->{$value});
    $button->SetToolTip( Wx::ToolTip->new($tooltip)) if $tooltip;

    $sizer->Add( Wx::StaticText->new($self->Tab, -1, ($UI::Labels::Labels{$value} || $value)), 0, Wx::wxALIGN_RIGHT|Wx::wxALIGN_CENTER_VERTICAL);
    $sizer->Add( $button, 0, Wx::wxEXPAND );

	Wx::Event::EVT_BUTTON( $self->Tab, Utility::id($value),
		sub {
			my $newKey = UI::KeyBindDialog::showWindow($self->Tab, $value, $module->{$value});

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
