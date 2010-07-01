package ProfileTabs;

use strict;
use General;

use parent -norequire, 'Wx::Notebook';

sub new {
	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = General->new($self);
	$self->AddPage($GeneralPanel, "General");

	# walk through the plugins and make them spit up their UI tabs.
	for my $plugin ($parent->plugins($self)) {
		$self->AddPage($plugin, $plugin->{'TabTitle'});
	}

	$self->SetSelection(1);

	return $self;
}

1;
