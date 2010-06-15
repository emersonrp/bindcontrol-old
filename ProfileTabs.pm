package ProfileTabs;

use strict;
use Wx qw(wxVERTICAL wxHORIZONTAL
		wxTOP wxBOTTOM wxLEFT wxRIGHT wxALL
		wxDefaultSize wxDefaultPosition wxDefaultValidator
		wxTAB_TRAVERSAL wxEXPAND wxCB_READONLY);
use Wx::Event qw( EVT_COMBOBOX );

use GameData;
use Profile;
use General;

use parent -norequire, 'Wx::Notebook';

sub new {
	my ($class, $parentpanel, $mainwindow) = @_;

	my $self = $class->SUPER::new($parentpanel);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = General->new($self);
	$self->AddPage($GeneralPanel, "General");

	# walk through the plugins and make them spit up their UI tabs.
	for my $plugin ($mainwindow->plugins($self)) {
		my $tab = $plugin->tab;
		$self->AddPage($tab, $tab->{'TabTitle'});
	}

	return $self;
}

1;
