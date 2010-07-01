#!/usr/bin/perl

use strict;
package BindFile;

my %BindFiles; # keep all created objects here so we can iterate them when it's time to write them out.

sub new {
	my ($proto, $filename) = @_;

	unless ($BindFiles{$filename}) {

		my $class = ref $proto || $proto;

		my $self = {
			filename => $filename, # TODO - want to be all File::Spec crossplatformy.
			binds => {},
		};

		bless $self, $class;

		$BindFiles{$filename} = $self;
	}

	return $BindFiles{$filename};

}

sub SetBind {
	my ($self,$key,$bindtext) = @_;

	if (not $key)  { die("invalid key: $key"); }

	$bindtext =~ s/^ +//;
	$bindtext =~ s/ +$//;

	# TODO -- how to call out the 'reset file' object as special?
	# if ($file eq $resetfile1 and $key eq $resetkey) {
		# $resetfile2->{'binds'}->{$key} = $s;
	# }

	$self->{'binds'}->{$key} = $bindtext;
}

1;
