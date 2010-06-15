#!/usr/bin/perl

use strict;
require 5.012;

use Data::Dumper;
use Wx::Perl::Packager;

use About;
use ProfileTabs;
use StdDefault;

use Powerbinder;
use PowerBindCmds;

BCApp->new->MainLoop;

###################
# Application class
###################
package BCApp;
use parent 'Wx::App';

sub OnInit{
	my $self = shift;

	my $frame = BCMainWindow->new;
	$frame->Show(1);
	$self->SetTopWindow($frame);
	return 1;
}




###################
# Main Window Class
###################
package BCMainWindow;

use Wx qw(wxVERTICAL wxHORIZONTAL wxDefaultSize wxDefaultPosition
		wxTAB_TRAVERSAL wxEXPAND wxALL wxLB_SORT :id);

use Wx::Event qw(
	EVT_MENU
);

use parent -norequire, 'Wx::Frame';

use Utility qw(id);
use Module::Pluggable instantiate => 'new', search_path => 'BCPlugins';

sub new {

    my $class = shift;

    my $self = $class->SUPER::new(
        undef,         # No parent means "top-level window".
        -1,            # No need to assign a window ID
        "BindControl",   # Window title
        [-1, -1],      # Let the system assign the window position
        [-1 ,-1],      # Use a default size
        # optionally specify a window style here
    );

    # "Profile" Menu
	my $ProfMenu = Wx::Menu->new();

	$ProfMenu->Append(id('MENUITEM_NEWPROF'), "New Profile...", "Create a new profile");
	$ProfMenu->Append(id('MENUITEM_LOADPROF'), "Load Profile...", "Load an existing profile");
	$ProfMenu->Append(id('MENUITEM_SAVEPROF'), "Save Profile", "Save the current profile");
	$ProfMenu->AppendSeparator();
	$ProfMenu->Append(id('MENUITEM_PREFS'), "Preferences...", "Edit Preferences");
	$ProfMenu->Append(id('MENUITEM_EXIT'), "Exit", "Exit $0");

	$ProfMenu->Enable(id('MENUITEM_SAVEPROF'), 0);
	$ProfMenu->Enable(id('MENUITEM_LOADPROF'), 0);
	$ProfMenu->Enable(id('MENUITEM_SAVEPROF'), 0);
	$ProfMenu->Enable(id('MENUITEM_PREFS'), 0);

	# "Help" Menu
	my $HelpMenu = Wx::Menu->new();

	$HelpMenu->Append(id('MENUITEM_MANUAL'),"Manual","User's Manual");
	$HelpMenu->Append(id('MENUITEM_FAQ'),"FAQ","Frequently Asked Questions");
	$HelpMenu->Append(id('MENUITEM_LICENSE'),"License Info","");
	$HelpMenu->Append(id('MENUITEM_ABOUT'),"About","About");

	$HelpMenu->Enable(id('MENUITEM_MANUAL'), 0);
	$HelpMenu->Enable(id('MENUITEM_FAQ'), 0);
	$HelpMenu->Enable(id('MENUITEM_LICENSE'), 0);

	# cram the separate menus into a menubar
	my $MenuBar = Wx::MenuBar->new();
	$MenuBar->Append($ProfMenu, 'Profile');
	$MenuBar->Append($HelpMenu, 'Help');

	# glue the menubar into the main window
	$self->SetMenuBar($MenuBar);

	# MENUBAR EVENTS
	EVT_MENU( $self, id('MENUITEM_NEWPROF'), \&newProfileWindow );
	EVT_MENU( $self, id('MENUITEM_LOADPROF'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_SAVEPROF'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_PREFS'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_EXIT'), sub {shift->Close(1)} );
	EVT_MENU( $self, id('MENUITEM_MANUAL'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_FAQ'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_LICENSE'), sub {return 1;} );
	EVT_MENU( $self, id('MENUITEM_ABOUT'), \&showAboutBox );


	# TODO - read in the config for the window (size, location, etc)
	# and apply it before ->Show()

# TODO TODO TODO -- remove this once we actually start making and saving profiles
	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);
	my $profWindow = newProfileWindow($self);
	$sizer->Add($profWindow, 1, wxEXPAND |  wxALL, 3);
	$self->SetSizerAndFit($sizer);
# TODO TODO TODO



	return $self;
}

sub newProfileWindow {
	my $self = shift;

	if (my $oldpanel = Wx::Window::FindWindowById(id('PANEL_PROFILETABS'))) {
		$oldpanel->Destroy();
	}

	my $panel = Wx::Panel->new(
		$self,
		id('PANEL_PROFILETABS'),
		wxDefaultPosition,
		wxDefaultSize,
		wxTAB_TRAVERSAL,
	);
	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);

	my $profileTabs = ProfileTabs->new($panel, $self);

	$sizer->Add ($profileTabs, 1, wxEXPAND | wxALL, 3);
	$panel->SetSizerAndFit($sizer);

	return $panel;

}

sub showAboutBox { return Wx::AboutBox(our $aboutDialogInfo); }

1;
