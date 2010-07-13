#!/usr/bin/perl

# base class for all the individual tabs
package Module::Module;

use strict;
use Wx qw();
use Wx::Event;
use parent -norequire, "Wx::Panel";

use BindFile;
use UI::KeyBindDialog;
use UI::Labels;
use Utility;

sub new {
	my ($proto, $parent) = @_;
	my $class = ref $proto || $proto;

	my $self = $class->SUPER::new($parent);
	bless $self, $class;

	no strict 'refs';
	$self->Name = ${"${class}::ModuleName"};
	use strict;

	$self->Profile = $parent;

	return $self;
}

sub help {
	my ($self, $event) = @_;

	unless ($self->{'HelpWindow'}) {
		my $HelpWindow = Wx::MiniFrame ->new( undef, -1, $self->TabTitle . " Help",);
		my $BoxSizer   = Wx::BoxSizer  ->new( Wx::wxVERTICAL );
		my $Panel      = Wx::Panel     ->new( $HelpWindow, -1 );
		my $HelpText   = Wx::StaticText->new( $Panel, -1, $self->HelpText, [10,10] );

		$BoxSizer->Add( $Panel, 1, Wx::wxEXPAND );

		$HelpWindow->SetSizer($BoxSizer);

		$self->{'HelpWindow'} = $HelpWindow;
	}

	$self->{'HelpWindow'}->Show(not $self->{'HelpWindow'}->IsShown);

	return $self->{'HelpWindow'};
}

# Accessors
sub Name       : lvalue { shift->{'Name'} }
sub TabTitle   : lvalue { shift->{'TabTitle'} }
sub Profile    : lvalue { shift->{'Profile'} }

# stubs
sub InitKeys          { 1; }
sub PopulateBindFiles {print STDERR "stub PopBindFiles\n"; 1; }
sub FillTab           { my $self = shift; ($self->TabTitle = ref $self) =~ s/Module:://; }
sub HelpText          { qq|Help not currently implemented here.|; }

1;
