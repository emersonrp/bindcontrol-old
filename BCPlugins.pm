#!/usr/bin/perl

package BCPlugins;
use Wx;

use Layout;

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	return bless {}, $class;
}

# plugins will want to override this method.
# it needs to return a wxPanel to pack into a notebook tab, and the title of the tab
sub tab {
	my ($self, $parent) = @_;

	my $panel = Wx::Panel->new($parent, -1);

	(my $title = $self) =~ s/BCPlugins:://;

	return ($panel, $title);
}

1;
