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

use base 'Wx::Notebook';

sub new {
	my ($class, $parentpanel, $mainwindow) = @_;

	my $self = $class->SUPER::new($parentpanel);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = General->new($self);
	$self->AddPage($GeneralPanel, "General");

	# walk through the plugins and make them spit up their UI tabs.
	for my $plugin ($mainwindow->plugins) {
		my ($panel, $title) = $plugin->tab($self);
		$self->AddPage($panel, $title);
	}

	return $self;
}

1;
