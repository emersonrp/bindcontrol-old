#!/usr/bin/perl

package Profile;
use parent -norequire, 'Wx::Notebook';

use strict;

our $profile;

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

	$profile = {};

	# TODO -- here's where we'd load a profile from a file or something.

	# Add the individual tabs, in order.
	my $module;
	$module = Profile::General->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::SoD->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::BufferBinds->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::ComplexBinds->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::CustomBinds->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::FPSDisplay->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::InspirationPopper->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::Mastermind->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::PetSel->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::SimpleBinds->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::TeamSel->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::TeamSel2->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	$module = Profile::TypingMsg->new($self);
	$self->AddPage( $module->Tab, $module->TabTitle );

	return $self;
}

# this is the little callback the modules use to register themselves.
sub AddModule {
	my $self = shift;
	my $module = shift;

	no strict 'refs';
	*{ $module } = sub : lvalue { shift->{$module} };

}
1;
