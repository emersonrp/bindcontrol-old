#!/usr/bin/perl

package UI::Labels;

use strict;

our %Labels;

sub Add {
	%Labels = (
		%Labels,
		%{shift()},
	);
print STDERR Data::Dumper::Dumper \%Labels;
}


sub Label : lvalue {
	my $label = shift;

	unless ($Labels{$label}) {
		my @c = caller();
		print STDERR "No label for '$label' at $c[1] $c[2]\n";
		return $label;
	}
	return $Labels{$label};
}

1;
