#!/usr/bin/perl

package UI::Labels;

use strict;

our %Labels;

sub Add {
	%Labels = (
		%Labels,
		%{shift()},
	);
}

1;
