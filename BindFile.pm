#!/usr/bin/perl

use strict;
package BindFile;
use File::Spec;
use File::Path;

my %BindFiles; # keep all created objects here so we can iterate them when it's time to write them out.

sub new {
	my ($proto, @filename) = @_;

	my $filename = File::Spec->catfile(@filename);

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
		# $resetfile2->{$key} = $s;
	# }

	$self->{$key} = $bindtext;
}

sub BaseReset {
	my $profile = shift;
	return '$$bind_load_file' . $profile->{'General'}->{'BindsDir'} . "\\subreset.txt";
}

sub BLF {
	my ($profile, @bits) = @_;
	my $file = pop @bits;
	my ($vol, $bdir, undef) = File::Spec->splitpath( $profile->{'General'}->{'BindsDir'}, 1 );
	my $dirpath = File::Spec->catdir($bdir, @bits);
	return '$$bindloadfile ' . File::Spec->catpath($vol, $dirpath, $file);
}


sub WriteBindFiles {
	my ($target, $event) = @_;

	my $profile = $target->profile;

# TODO this wants not to happen here, this is just for testing.
Profile::SoD::makebind($profile);

	# Pick apart the BindsDir so that we get volume name, if appropriate
	my ($vol, $bdir, undef) = File::Spec->splitpath( $profile->{'General'}->{'BindsDir'}, 1 );

	while (my ($filename, $binds) = each %BindFiles) {

		# Pick apart the filename into component bits.
		# TODO - we should make sure we're sticking them into here all File::Spec happy
		# instead of raw "X\\X111111.txt"
		my (undef, $dir, $file) = File::Spec->splitpath( $filename );

		# mash together the two 'directory' parts:
		$dir = File::Spec->catdir($bdir, $dir);

		# now we want the fully-qualified dir name so we can make sure it exists...
		my $newpath = File::Spec->catpath( $vol, $dir, '' );
		# and the fully-qualified filename so we can write to it.
		my $fullname = File::Spec->catpath( $vol, $dir, $file );

		# Make the dir if it doesn't exist already.
		if ( ! -d $newpath ) {
			File::Path::make_path( $newpath, {verbose=>1} ) or warn "can't make dir $newpath: $!";
		}

		# open the file and blast the poop into it.  whee!
		open (my $fh, '>', $fullname ) or warn "can't write to $fullname: $!";
		for my $k (sort keys %$binds) {
			print $fh qq|$k "$binds->{$k}"\n|;
		}
	}
	print STDERR "Done!\n";
}

1;
