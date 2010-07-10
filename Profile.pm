#!/usr/bin/perl

package Profile;
use parent -norequire, 'Wx::Notebook';

use strict;
use feature 'state';
use File::HomeDir;  # for when we start actually saving profiles

# This all used to be auto-detecty-pluginny, but
# PAR didn't want to package up anything that wasn't
# explicitly 'use'd.  There's probably a better solution.
use Profile::BufferBinds;
use Profile::ComplexBinds;
use Profile::CustomBinds;
use Profile::FPSDisplay;
use Profile::General;
use Profile::InspirationPopper;
use Profile::Mastermind;
use Profile::PetSel;
use Profile::SimpleBinds;
use Profile::SoD;
use Profile::TeamSel;
use Profile::TeamSel2;
use Profile::TypingMsg;

sub new {
	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	# TODO -- here's where we'd load a profile from a file or something.

	# Add the individual tabs, in order.
	$self->AddModule(Profile::General->new($self));
	$self->AddModule(Profile::SoD->new($self));
	$self->AddModule(Profile::BufferBinds->new($self));
	$self->AddModule(Profile::ComplexBinds->new($self));
	$self->AddModule(Profile::CustomBinds->new($self));
	$self->AddModule(Profile::FPSDisplay->new($self));
	$self->AddModule(Profile::InspirationPopper->new($self));
	$self->AddModule(Profile::Mastermind->new($self));
	$self->AddModule(Profile::PetSel->new($self));
	$self->AddModule(Profile::SimpleBinds->new($self));
	$self->AddModule(Profile::TeamSel->new($self));
	$self->AddModule(Profile::TeamSel2->new($self));
	$self->AddModule(Profile::TypingMsg->new($self));

	return $self;
}

my @Modules;
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
sub Modules { @Modules }

sub GetBindFile {
	my ($self, $filename) = @_;

	$self->{'BindFiles'}->{$filename} ||= BindFile->new($filename);
}

sub WriteBindFiles {
	my ($self) = @_;

	for my $Module ($self->Modules) {
		my $moduleBindFiles = $Module->PopulateBindFiles;
	}

	for my $bindfile (values %{$self->{'BindFiles'}}) {
		$bindfile->Write($self);
	}
}

1;
