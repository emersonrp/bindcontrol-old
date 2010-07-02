#!/usr/bin/perl

use strict;

package ProfileTabs::TeamSel;
use parent "ProfileTabs::ProfileTab";

use BindFile;

use Wx qw( :everything );

use Wx::Event qw(EVT_BUTTON);
use Utility qw(id);


sub new {

	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	$self->{'TabTitle'} = 'One-Key Team/Pet Select';

	my $profile = $Profile::current;
	my $TeamSelect = $profile->{'TeamSelect'};
	unless ($TeamSelect) {
		$profile->{'TeamSelect'} = $TeamSelect = {};
	}
	$TeamSelect->{'mode'} ||= 1;
	for (1..8) { $TeamSelect->{"sel$_"} ||= 'UNBOUND' }

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);

	my $headerSizer = Wx::FlexGridSizer->new(0,2,10,10);

	my $enablecb = Wx::CheckBox->new( $self, id('TeamSel Enable'), 'Enable Team/Pet Select');
	$enablecb->SetToolTip( Wx::ToolTip->new('Check this to enable the Team/Pet Select Binds') );

	my $helpbutton = Wx::BitmapButton->new($self, -1, Utility::Icon('Help'));
	EVT_BUTTON($self, $helpbutton, sub { shift && $self->help(@_) }); 

	$headerSizer->Add($enablecb, 0, wxALIGN_CENTER_VERTICAL);
	$headerSizer->Add($helpbutton, wxALIGN_RIGHT, 0);

	$topSizer->Add($headerSizer);

	my $sizer = Wx::FlexGridSizer->new(0,2,4,4);

	my $picker = Wx::ComboBox->new(
		$self, id('TeamPetMode'), '',
		wxDefaultPosition, wxDefaultSize, 
		['Teammates, then pets','Pets, then teammates','Teammates Only','Pets Only'],
		wxCB_READONLY,
	);
	$picker->SetToolTip( Wx::ToolTip->new('Choose the order in which teammates and pets are selected with sequential keypresses') );
	$sizer->Add( Wx::StaticText->new($self, -1, "Select Order"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $picker, 0, wxALL, 10 );

	for my $selectid (1..8) {

		my $button = Wx::Button->new($self, id("TeamSelect$selectid"), $TeamSelect->{"sel$selectid"});
		$button->SetToolTip( Wx::ToolTip->new("Choose the key that will select team member / pet $selectid") );
		$sizer->Add( Wx::StaticText->new($self, -1, "Select Teammate/Pet $selectid"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
		$sizer->Add( $button, 0, wxEXPAND);
	}

	$topSizer->Add($sizer);

	$self->SetSizer($topSizer);

	return $self;

}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $TeamSelect = $profile->{'TeamSelect'};
	cbMakeDirectory($profile->{'base'}.'\\TeamSelect');
	if ($TeamSelect->{'mode'} < 3) {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		my $selmethod1 = "petselect";
		my $selnummod1 = 1;
		if ($TeamSelect->{'mode'} == 2) {
			$selmethod = "petselect";
			$selnummod = 1;
			$selmethod1 = "teamselect";
			$selnummod1 = 0;
		}
		my $selresetfile = BindFile->new("$profile->{'base'}\\teamsel\\reset.txt");
		for my $i (1..8) {
			my $selfile = BindFile->new("$profile->{'base'}\\teamsel\\sel${i}.txt");
			$resetfile->   SetBind($TeamSelect->{"sel$i"},"$selmethod " . ($i - $selnummod) . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\sel${i}.txt");
			$selresetfile->SetBind($TeamSelect->{"sel$i"},"$selmethod " . ($i - $selnummod) . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\sel${i}.txt");
			for my $j (1..8) {
				if ($i == $j) {
					$selfile->SetBind($TeamSelect->{"sel$j"},"$selmethod1 " . ($j - $selnummod1) . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\reset.txt");
				} else {
					$selfile->SetBind($TeamSelect->{"sel$j"},"$selmethod " .  ($j - $selnummod)  . '$$bindloadfile ' . "$profile->{'base'}\\teamsel\\sel$j.txt");
				}
			}
			close $selfile;
		}
		close $selresetfile;
	} else {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		if ($TeamSelect->{'mode'} == 4) {
			$selmethod = "petselect";
			$selnummod = 1;
		}
		for my $i (1..8) {
			$resetfile->SetBind($TeamSelect->{'sel1'},"$selmethod " . ($i - $selnummod));
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $TeamSelect = $profile->{'TeamSelect'};
	for my $i (1..8) { cbCheckConflict($TeamSelect,"sel$i","Team/Pet $i Key") }
}

sub bindisused {
	my ($profile) = @_;
	return $profile->{'TeamSelect'} ? $profile->{'TeamSelect'}->{'enable'} : undef;
}

sub HelpText {qq|

Team/Pet Selection binds contributed by ShieldBearer.

|}


1;
