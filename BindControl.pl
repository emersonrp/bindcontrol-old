use strict;

use Wx::Perl::Packager;
use Data::Dumper;

use About;
use ProfileTabs;
use StdDefault;

use Powerbinder;
use PowerBindCmds;
use PetSel;
use SimpleBinds;

use BCConstants;

my $app = BCApp->new();
$app->MainLoop;



###################
# Application class
###################
package BCApp;
use base 'Wx::App';

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

use base 'Wx::Frame';

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

	$ProfMenu->Append(MENUITEM_NEWPROF, "New Profile...", "Create a new profile");
	$ProfMenu->Append(MENUITEM_LOADPROF, "Load Profile...", "Load an existing profile");
	$ProfMenu->Append(MENUITEM_SAVEPROF, "Save Profile", "Save the current profile");
	$ProfMenu->AppendSeparator();
	$ProfMenu->Append(MENUITEM_PREFS, "Preferences...", "Edit Preferences");
	$ProfMenu->Append(MENUITEM_EXIT, "Exit", "Exit $0");

	$ProfMenu->Enable(MENUITEM_SAVEPROF, 0);
	$ProfMenu->Enable(MENUITEM_LOADPROF, 0);
	$ProfMenu->Enable(MENUITEM_SAVEPROF, 0);
	$ProfMenu->Enable(MENUITEM_PREFS, 0);

	# "Help" Menu
	my $HelpMenu = Wx::Menu->new();

	$HelpMenu->Append(MENUITEM_MANUAL,"Manual","User's Manual");
	$HelpMenu->Append(MENUITEM_FAQ,"FAQ","Frequently Asked Questions");
	$HelpMenu->Append(MENUITEM_LICENSE,"License Info","");
	$HelpMenu->Append(MENUITEM_ABOUT,"About","About");

	$HelpMenu->Enable(MENUITEM_MANUAL, 0);
	$HelpMenu->Enable(MENUITEM_FAQ, 0);
	$HelpMenu->Enable(MENUITEM_LICENSE, 0);

	# cram the separate menus into a menubar
	my $MenuBar = Wx::MenuBar->new();
	$MenuBar->Append($ProfMenu, 'Profile');
	$MenuBar->Append($HelpMenu, 'Help');

	# glue the menubar into the main window
	$self->SetMenuBar($MenuBar);

	# MENUBAR EVENTS
	EVT_MENU( $self, MENUITEM_NEWPROF, \&newProfileWindow );
	EVT_MENU( $self, MENUITEM_LOADPROF, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_SAVEPROF, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_PREFS, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_EXIT, sub {shift->Close(1)} );
	EVT_MENU( $self, MENUITEM_MANUAL, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_FAQ, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_LICENSE, sub {return 1;} );
	EVT_MENU( $self, MENUITEM_ABOUT, \&showAboutBox );


	# TODO - read in the config for the window (size, location, etc)
	# and apply it before ->Show()

# TODO TODO TODO -- remove this once we actually start making and saving profiles
newProfileWindow($self);
# TODO TODO TODO


	return $self;
}

sub newProfileWindow {
	my $self = shift;

	if (my $oldpanel = Wx::Window::FindWindowById(PANEL_PROFILETABS)) {
		$oldpanel->Destroy();
	}


	my $panel = Wx::Panel->new(
		$self,
		PANEL_PROFILETABS,
		wxDefaultPosition,
		wxDefaultSize,
		wxTAB_TRAVERSAL,
	);
	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);

	my $profileTabs = ProfileTabs->new($panel);

	$sizer->Add ($profileTabs, 1, wxEXPAND | wxALL, 3);
	$panel->SetSizerAndFit($sizer);

}

sub showAboutBox { return Wx::AboutBox(our $aboutDialogInfo); }

1;
