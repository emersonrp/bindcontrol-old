#!/usr/bin/perl

use strict;
package BindFile;
use File::Spec;
use File::Path;

my %BindFiles; # cache of file objects so we only ever create one object per filename.

sub new {
	my ($class, @filename) = @_;

	my $filename = File::Spec->catfile(@filename);

	unless ($BindFiles{$filename}) {
		$BindFiles{$filename} =  bless {filename => $filename, binds => {}}, $class;
	}
	return $BindFiles{$filename};
}

sub SetBind {
	my ($self,$key,$bindtext) = @_;
	if (not $key)  {
		my @c = caller();
		$key = ''; print STDERR "invalid key: $key, bindtext $bindtext from file $c[1] line $c[2]\n" and return;
	}

	$bindtext =~ s/^ +//;
	$bindtext =~ s/ +$//;

	# TODO -- how to call out the 'reset file' object as special?
	# if ($file eq $resetfile1 and $key eq $resetkey) {
		# $resetfile2->{$key} = $s;
	# }

	$self->{'binds'}->{$key} = $bindtext;
}

sub BaseReset {
	my $profile = shift;
	return '$$bindloadfilesilent ' . $profile->General->{'BindsDir'} . "\\subreset.txt";
}

# BLF == full "$$bindloadfilesilent path/to/file/kthx"
sub BLF  { return '$$' . BLFs(@_); }
# BLFs == same as above but no '$$' for use at start of binds.  Unnecessary?
sub BLFs { return 'bindloadfilesilent ' . BLFPath(@_); }
# BLFPath == just the path to the file
sub BLFPath {
	my ($profile, @bits) = @_;
	my $file = pop @bits;
	my ($vol, $bdir, undef) = File::Spec->splitpath( $profile->General->{'BindsDir'}, 1 );
	my $dirpath = File::Spec->catdir($bdir, @bits);
	return File::Spec->catpath($vol, $dirpath, $file);
}

sub Write {
	my ($self, $profile) = @_;

	# Pick apart the binds directory
	my ($vol, $bdir, undef) = File::Spec->splitpath( $profile->General->{'BindsDir'}, 1 );

	# Pick apart the filename into component bits.
	my (undef, $dir, $file) = File::Spec->splitpath( $self->{'filename'} );

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
	for my $k (sort keys %{ $self->{'binds'} }) {
		print $fh qq|$k "$self->{'binds'}->{$k}"\n|;
	}
	# print STDERR "Done $fullname!\n";
}

1;
