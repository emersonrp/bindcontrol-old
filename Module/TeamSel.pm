#!/usr/bin/perl

use strict;

package Module::TeamSel;
use parent "Module::Module";

use BindFile;

use Wx qw( :everything );

use Wx::Event qw(EVT_BUTTON);
use Utility qw(id);

our $ModuleName = 'TeamSelect';

sub InitKeys {

	my $self = shift;
	$self->Profile->TeamSelect ||= {};
}


sub FillTab {
	my $self = shift;

	$self->TabTitle = 'One-Key Team/Pet Select';

	my $TeamSelect = $self->Profile->{'TeamSelect'};
	my $Tab        = $self->Tab;

	$TeamSelect->{'mode'} ||= 1;
	for (1..8) { $TeamSelect->{"sel$_"} ||= 'UNBOUND' }

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);

	my $headerSizer = Wx::FlexGridSizer->new(0,2,10,10);

	my $enablecb = Wx::CheckBox->new( $Tab, id('TeamSel Enable'), 'Enable Team/Pet Select');
	$enablecb->SetToolTip( Wx::ToolTip->new('Check this to enable the Team/Pet Select Binds') );

	my $helpbutton = Wx::BitmapButton->new($Tab, -1, Utility::Icon('Help'));
	EVT_BUTTON($Tab, $helpbutton, sub { shift && $self->help(@_) }); 

	$headerSizer->Add($enablecb, 0, wxALIGN_CENTER_VERTICAL);
	$headerSizer->Add($helpbutton, wxALIGN_RIGHT, 0);

	$topSizer->Add($headerSizer);

	my $sizer = Wx::FlexGridSizer->new(0,2,4,4);

	my $picker = Wx::ComboBox->new(
		$Tab, id('TeamPetMode'), '',
		wxDefaultPosition, wxDefaultSize, 
		['Teammates, then pets','Pets, then teammates','Teammates Only','Pets Only'],
		wxCB_READONLY,
	);
	$picker->SetToolTip( Wx::ToolTip->new('Choose the order in which teammates and pets are selected with sequential keypresses') );
	$sizer->Add( Wx::StaticText->new($Tab, -1, "Select Order"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$sizer->Add( $picker, 0, wxALL, 10 );

	for my $selectid (1..8) {

		my $button = Wx::Button->new($Tab, id("TeamSelect$selectid"), $TeamSelect->{"sel$selectid"});
		$button->SetToolTip( Wx::ToolTip->new("Choose the key that will select team member / pet $selectid") );
		$sizer->Add( Wx::StaticText->new($Tab, -1, "Select Teammate/Pet $selectid"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
		$sizer->Add( $button, 0, wxEXPAND);
	}

	$topSizer->Add($sizer);

	$Tab->SetSizer($topSizer);

	return $self;
}

sub PopulateBindFiles {
	my $profile    = shift->Profile;
	my $ResetFile  = $profile->General->{'ResetFile'};
	my $TeamSelect = $profile->{'TeamSelect'};
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
		my $selresetfile = $profile->GetBindFile("teamsel","reset.txt");
		for my $i (1..8) {
			my $selfile = $profile->GetBindFile("teamsel","sel${i}.txt");
			$ResetFile->   SetBind($TeamSelect->{"sel$i"},"$selmethod " . ($i - $selnummod) . BindFile::BLF($profile,'teamsel',"sel${i}.txt"));
			$selresetfile->SetBind($TeamSelect->{"sel$i"},"$selmethod " . ($i - $selnummod) . BindFile::BLF($profile,'teamsel',"sel${i}.txt"));
			for my $j (1..8) {
				if ($i == $j) {
					$selfile->SetBind($TeamSelect->{"sel$j"},"$selmethod1 " . ($j - $selnummod1) . BindFile::BLF($profile,'teamsel',"reset.txt"));
				} else {
					$selfile->SetBind($TeamSelect->{"sel$j"},"$selmethod " .  ($j - $selnummod)  . BindFile::BLF($profile,'teamsel',"sel$j.txt"));
				}
			}
		}
	} else {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		if ($TeamSelect->{'mode'} == 4) {
			$selmethod = "petselect";
			$selnummod = 1;
		}
		for my $i (1..8) {
			$ResetFile->SetBind($TeamSelect->{'sel1'},"$selmethod " . ($i - $selnummod));
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
