#!/usr/bin/perl

package BCPlugins;
use Wx;

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	return bless {}, $class;
}

# override this in your own plugin
sub init {
	my $self = shift;
	print STDERR "new $self here\n";
}

# ditto
sub tab {
	my ($self, $parent) = @_;

	my $panel = Wx::Panel->new($parent, -1);

	(my $title = $self) =~ s/BCPlugins:://;

	return ($panel, $title);
}

1;
