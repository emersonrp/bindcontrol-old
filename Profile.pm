#!/usr/bin/perl

package Profile;
use parent -norequire, 'Wx::Notebook';

use strict;
use feature 'state';
use File::HomeDir;  # for when we start actually saving profiles

# This all used to be auto-detecty-pluginny, but
# PAR didn't want to package up anything that wasn't
# explicitly 'use'd.  There's probably a better solution.
use Module::BufferBinds;
use Module::ComplexBinds;
use Module::CustomBinds;
use Module::FPSDisplay;
use Module::General;
use Module::InspirationPopper;
use Module::Mastermind;
use Module::PetSel;
use Module::SimpleBinds;
use Module::SoD;
use Module::TeamSel;
use Module::TeamSel2;
use Module::TypingMsg;

sub new {
	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	# TODO -- here's where we'd load a profile from a file or something.

	# Add the individual tabs, in order.
	$self->AddModule(Module::General->new($self));
	$self->AddModule(Module::SoD->new($self));
	$self->AddModule(Module::BufferBinds->new($self));
	$self->AddModule(Module::ComplexBinds->new($self));
	$self->AddModule(Module::CustomBinds->new($self));
	$self->AddModule(Module::FPSDisplay->new($self));
	$self->AddModule(Module::InspirationPopper->new($self));
	$self->AddModule(Module::Mastermind->new($self));
	$self->AddModule(Module::PetSel->new($self));
	$self->AddModule(Module::SimpleBinds->new($self));
	$self->AddModule(Module::TeamSel->new($self));
	$self->AddModule(Module::TeamSel2->new($self));
	$self->AddModule(Module::TypingMsg->new($self));

	return $self;
}

my @Modules;
sub Modules { @Modules }
sub AddModule {
	my ($self, $module) = @_;

	push @Modules, $module;

	no strict 'refs';
	*{ $module->Name } = sub : lvalue { shift->{$module->Name} };
	use strict;

	$module->InitKeys;
	$module->FillTab;

	$self->AddPage( $module->Tab, $module->TabTitle );
}

# TODO - hacking together the catfile() by hand here seems ugly.
sub GetBindFile {
	my ($self, @filename) = @_;

	my $filename = File::Spec->catfile(@filename);
	$self->{'BindFiles'}->{$filename} ||= BindFile->new(@filename);
}

sub WriteBindFiles {
	my ($self) = @_;

	for my $Module ($self->Modules) {print STDERR $Module->Name . "\n"; $Module->PopulateBindFiles; }

	for my $bindfile (values %{$self->{'BindFiles'}}) { $bindfile->Write($self); }
}

1;
