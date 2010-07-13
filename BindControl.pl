#!/usr/bin/perl

use strict;
require 5.012;

#use Data::Dumper;
use Wx::Perl::Packager;

use Data::Dumper;

use About;
use Profile;
use StdDefault;

use Powerbinder;
use PowerBindCmds;

our $profile;

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
use parent -norequire, 'Wx::Frame';

use Wx qw();

use Utility qw(id);

sub new {

    my $class = shift;

    my $self = $class->SUPER::new( undef, -1, "BindControl" );

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
	Wx::Event::EVT_MENU( $self, id('MENUITEM_NEWPROF'),  \&newProfileWindow );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_LOADPROF'), sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_SAVEPROF'), sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_PREFS'),    sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_EXIT'),     \&exitApplication );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_MANUAL'),   sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_FAQ'),      sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_LICENSE'),  sub {1} );
	Wx::Event::EVT_MENU( $self, id('MENUITEM_ABOUT'),    \&showAboutBox );


	my $AppIcon = Wx::Icon->new();
	$AppIcon->LoadFile('BindControl.ico', Wx::wxBITMAP_TYPE_ICO);
	$self->SetIcon($AppIcon);

	# TODO - read in the config for the window (size, location, etc)
	# and apply it before ->Show()

# TODO TODO TODO -- remove this once we actually start making and saving profiles
	my $sizer = Wx::BoxSizer->new(Wx::wxVERTICAL);
	my $profile = Profile->new($self);
	$sizer->Add($profile, 1, Wx::wxEXPAND |  Wx::wxALL, 3);
	$self->SetSizerAndFit($sizer);
# TODO TODO TODO

	return $self;
}

sub showAboutBox { return Wx::AboutBox(our $aboutDialogInfo); }

sub exitApplication { shift->Close(1); }

1;
