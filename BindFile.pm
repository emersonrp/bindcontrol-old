#!/usr/bin/perl

use strict;
package BindFile;
use File::Spec;
use File::Path;

my %BindFiles; # keep all created objects here so we can iterate them when it's time to write them out.

sub new {
	my ($proto, $filename) = @_;
print STDERR Data::Dumper::Dumper [caller()] if $filename !~ /CoHTest/; 
	unless ($BindFiles{$filename}) {

		my $class = ref $proto || $proto;

		my $self = {};

		bless $self, $class;

		$BindFiles{$filename} = $self;
	}

	return $BindFiles{$filename};
}

sub SetBind {
	my ($self,$key,$bindtext) = @_;
	if (not $key)  {
		my @c = caller();
		# $key = ''; print STDERR "invalid key: $key, bindtext $bindtext from file $c[1] line $c[2]\n" and return;
	}

	$bindtext =~ s/^ +//;
	$bindtext =~ s/ +$//;

	# TODO -- how to call out the 'reset file' object as special?
	# if ($file eq $resetfile1 and $key eq $resetkey) {
		# $resetfile2->{'binds'}->{$key} = $s;
	# }

	$self->{$key} = $bindtext;
}

sub BaseReset {
	my $profile = shift;
	return '$$bind_load_file' . $profile->{'General'}->{'BindsDir'} . "\\subreset.txt";
}

sub WriteBindFiles {
	my ($target, $event) = @_;

	my $profile = $target->profile;

# TODO this wants not to happen here, this is just for testing.
Profile::SoD::makebind($profile);

	while (my ($filename, $binds) = each %BindFiles) {

		print STDERR "Found filename $filename... \n";

		my ($v, $d, $f) = File::Spec->splitpath( $filename );
		$d = File::Spec->catdir( $profile->{'General'}->{'BindsDir'}, $d );
		my $newpath = File::Spec->catpath( $v, $d, '' );
		if ( ! -d $newpath ) {
			File::Path::make_path( $newpath, {verbose=>1} ) or warn "can't make dir $newpath: $!";
		}
		my $fullname = File::Spec->catpath( $v, $d, $f );
		open (my $fh, '>', $fullname ) or warn "can't write to $fullname: $!";
		for my $k (sort keys %$binds) {
			print $fh qq|$k "$binds->{$k}"\n|;
		}
	}
}

1;
