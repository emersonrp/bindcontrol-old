#!/usr/bin/perl

use strict;

package Module::TeamPetSelect;
use parent "Module::Module";

use BindFile;

use Wx qw( :everything );

use Wx::Event qw(EVT_BUTTON);
use Utility qw(id);

our $ModuleName = 'TeamPetSelect';

sub InitKeys {

	my $self = shift;
	$self->Profile->TeamPetSelect ||= {
		EnableDirTeamSel => 1,
		TeamSelect1 => 'UNBOUND',
		TeamSelect2 => 'UNBOUND',
		TeamSelect3 => 'UNBOUND',
		TeamSelect4 => 'UNBOUND',
		TeamSelect5 => 'UNBOUND',
		TeamSelect6 => 'UNBOUND',
		TeamSelect7 => 'UNBOUND',
		TeamSelect8 => 'UNBOUND',
		EnablePet => 1,
		SelNextPet => 'UNBOUND',
		SelPrevPet => 'UNBOUND',
		IncPetSize => 'UNBOUND',
		DecPetSize => 'UNBOUND',
		EnableTeam => 1,
		SelNextTeam => 'A',
		SelPrevTeam => 'G',
		IncTeamSize => 'P',
		DecTeamSize => 'H',
		IncTeamPos  => '4',
		DecTeamPos  => '8',
	};
}


sub FillTab {
	my $self = shift;


	my $TPS = $self->Profile->TeamPetSelect;
	my $Tab = $self->Tab;

	$TPS->{'mode'} ||= 1;
	for (1..8) { $TPS->{"sel$_"} ||= 'UNBOUND' }

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);

	##### header
	my $headerSizer = Wx::FlexGridSizer->new(0,2,10,10);

	my $enablecb = Wx::CheckBox->new( $Tab, id('TPS Enable'), 'Enable Team/Pet Select');
	$enablecb->SetToolTip( Wx::ToolTip->new('Check this to enable the Team/Pet Select Binds') );

	my $helpbutton = Wx::BitmapButton->new($Tab, -1, Utility::Icon('Help'));
	EVT_BUTTON($Tab, $helpbutton, sub { shift && $self->help(@_) }); 

	$headerSizer->Add($enablecb, 0, wxALIGN_CENTER_VERTICAL);
	$headerSizer->Add($helpbutton, wxALIGN_RIGHT, 0);

	$topSizer->Add($headerSizer);

	##### direct-select keys
	my $TPSDirectBox = Wx::StaticBoxSizer->new(Wx::StaticBox->new($Tab, -1, 'Direct Team/Pet Select'), wxVERTICAL);
	my $TPSDirectSizer = Wx::FlexGridSizer->new(0,2,4,4);

	my $picker = Wx::ComboBox->new(
		$Tab, id('TeamPetMode'), '',
		wxDefaultPosition, wxDefaultSize, 
		['Teammates, then pets','Pets, then teammates','Teammates Only','Pets Only'],
		wxCB_READONLY,
	);
	$picker->SetToolTip( Wx::ToolTip->new('Choose the order in which teammates and pets are selected with sequential keypresses') );
	$TPSDirectSizer->Add( Wx::StaticText->new($Tab, -1, "Select Order"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL );
	$TPSDirectSizer->Add( $picker, 0, wxALL, 10 );

	for my $selectid (1..8) {

		$self->addLabeledButton($TPSDirectSizer, $TPS, "TeamSelect$selectid",
			"Choose the key that will select team member / pet $selectid");
	}

	$TPSDirectBox->Add($TPSDirectSizer);
	$topSizer->Add($TPSDirectBox);


	##### Pet Select Binds
	my $PetSelBox =  Wx::StaticBoxSizer->new(Wx::StaticBox->new($Tab, -1, 'Pet Select'), wxVERTICAL); 
	my $PetSelSizer = Wx::FlexGridSizer->new(0,2,4,4);

	$self->addLabeledButton($PetSelSizer, $TPS, 'SelNextPet',
		'Choose the key that will select the next pet from the currently selected one');
	$self->addLabeledButton($PetSelSizer, $TPS, 'SelPrevPet',
		'Choose the key that will select the previous pet from the currently selected one');
	$self->addLabeledButton($PetSelSizer, $TPS, 'IncPetSize',
		'Choose the key that will increase the size of your pet/henchman group rotation');
	$self->addLabeledButton($PetSelSizer, $TPS, 'DecPetSize',
		'Choose the key that will decrease the size of your pet/henchman group rotation');

	$PetSelBox->Add($PetSelSizer);
	$topSizer->Add($PetSelBox);

	##### Team Select Binds
	my $TeamSelBox =  Wx::StaticBoxSizer->new(Wx::StaticBox->new($Tab, -1, 'Team Select'), wxVERTICAL); 
	my $TeamSelSizer = Wx::FlexGridSizer->new(0,2,4,4);
	$self->addLabeledButton($TeamSelSizer, $TPS, 'SelNextTeam',
		'Choose the key that will select the next teammate from the currently selected one');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'SelPrevTeam',
		'Choose the key that will select the previous teammate from the currently selected one');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'IncTeamSize',
		'Choose the key that will increase the size of your teammate rotation');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'DecTeamSize',
		'Choose the key that will decrease the size of your teammate rotation');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'IncTeamPos',
		'Choose the key that will move you to the next higher slot in the team rotation');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'DecTeamPos',
		'Choose the key that will move you to the next lower slot in the team rotation');
	$self->addLabeledButton($TeamSelSizer, $TPS, 'Reset',
		'Choose the key that will reset your team rotation to solo');

	$TeamSelBox->Add($TeamSelSizer);
	$topSizer->Add($TeamSelBox);

	$self->TabTitle = 'Team / Pet Selection';

	$Tab->SetSizer($topSizer);

	return $self;
}

sub PopulateBindFiles {
	my $profile    = shift->Profile;
	my $ResetFile  = $profile->General->{'ResetFile'};
	my $TPS = $profile->TeamPetSelect;
	if ($TPS->{'TeamPetMode'} < 3) {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		my $selmethod1 = "petselect";
		my $selnummod1 = 1;
		if ($TPS->{'TeamPetMode'} == 2) {
			$selmethod = "petselect";
			$selnummod = 1;
			$selmethod1 = "teamselect";
			$selnummod1 = 0;
		}
		my $selresetfile = $profile->GetBindFile("tps","reset.txt");
		for my $i (1..8) {
			my $selfile = $profile->GetBindFile("tps","sel${i}.txt");
			$ResetFile->   SetBind($TPS->{"TeamSelect$i"},"$selmethod " . ($i - $selnummod) . BindFile::BLF($profile,'tps',"sel${i}.txt"));
			$selresetfile->SetBind($TPS->{"TeamSelect$i"},"$selmethod " . ($i - $selnummod) . BindFile::BLF($profile,'tps',"sel${i}.txt"));
			for my $j (1..8) {
				if ($i == $j) {
					$selfile->SetBind($TPS->{"TeamSelect$j"},"$selmethod1 " . ($j - $selnummod1) . BindFile::BLF($profile,'tps',"reset.txt"));
				} else {
					$selfile->SetBind($TPS->{"TeamSelect$j"},"$selmethod " .  ($j - $selnummod)  . BindFile::BLF($profile,'tps',"sel$j.txt"));
				}
			}
		}
	} else {
		my $selmethod = "teamselect";
		my $selnummod = 0;
		if ($TPS->{'TeamPetMode'} == 4) {
			$selmethod = "petselect";
			$selnummod = 1;
		}
		for my $i (1..8) {
			$ResetFile->SetBind($TPS->{'sel1'},"$selmethod " . ($i - $selnummod));
		}
	}

	if ($TPS->{'PetSelEnable'}) {
		tpsCreatePetSet($profile,1,0,$profile->General->{'ResetFile'});
		for my $size (1..8) {
			for my $sel (0..$size) {
				my $file = $profile->GetBindFile("tps","pet$size$sel.txt");
				tpsCreatePetSet($profile,$size,$sel,$file);
			}
		}
	}


	if ($TPS->{'TeamSelEnable'}) {
		tpsCreateTeamSet($profile,1,0,0,$profile->General->{'ResetFile'});
		for my $size (1..8) {
			for my $pos (0..$size) {
				for my $sel (0..$size) {
					if ($sel != $pos or $sel == 0) {
						my $file = $profile->GetBindFile("tps", "team$size$pos$sel.txt");
						tpsCreateTeamSet($profile,$size,$pos,$sel,$file);
					}
				}
			}
		}
	}

}


sub tpsCreatePetSet {
	my ($profile,$tsize,$tsel,$file) = @_;
	my $TPS = $profile->TeamPetSelection;
	# tsize is the size of the team at the moment
	# tpos is the position of the player at the moment, or 0 if unknown
	# tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	#file->SetBind(TPS.reset,'tell $name, Re-Loaded Single Key Team Select Bind.' . BindFile::BLF($profile, 'petsel', '10.txt');
	if ($tsize < 8) {
		$file->SetBind($TPS->{'IncPetSize'},'tell $name, ' . formatPetConfig($tsize+1) . BindFile::BLF($profile, 'tps', ($tsize+1) . "$tsel.txt"));
	} else {
		$file->SetBind($TPS->{'DecPetSize'},'nop');
	}

	if ($tsize == 1) {
		$file->SetBind($TPS->{'DecPetSize'},'nop');
		$file->SetBind($TPS->{'SelNextPet'},'petselect 0' . BindFile::BLF($profile, 'tps', $tsize . '1.txt'));
		$file->SetBind($TPS->{'SelPrevPet'},'petselect 0' . BindFile::BLF($profile, 'tps', $tsize . '1.txt'));
	} else {
		my ($selnext,$selprev) = ($tsel+1,$tsel-1);
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1) { $selprev = $tsize }
		my $newsel = $tsel;
		if ($tsize-1 < $tsel) { $newsel = $tsize-1 }
		if ($tsize == 2) { $newsel = 0 }
		$file->SetBind($TPS->{'DecPetSize'},'tell $name, ' . formatPetConfig($tsize-1) . BindFile::BLF($profile, 'tps', ($tsize-1) . $newsel . '.txt'));
		$file->SetBind($TPS->{'SelNextPet'},'petselect ' . ($selnext-1) . BindFile::BLF($profile, 'tps', $tsize . $selnext . '.txt'));
		$file->SetBind($TPS->{'SelPrevPet'},'petselect ' . ($selprev-1) . BindFile::BLF($profile, 'tps', $tsize . $selprev . '.txt'));
	}
}

sub formatPetConfig { "[" . qw( First Second Third Fourth Fifth Sixth Seventh Eighth )[shift() - 1] . " Pet ]" }

sub tpsCreateTeamSet {
	my ($profile,$tsize,$tpos,$tsel,$file) = @_;
	my $TPS = $profile->TeamPetSelect;
	#  tsize is the size of the team at the moment
	#  tpos is the position of the player at the moment, or 0 if unknown
	#  tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	$file->SetBind($TPS->{'Reset'},'tell $name, Re-Loaded Single Key Team Select Bind' . BindFile::BLF($profile, 'teamsel2', '100.txt'));
	if ($tsize < 8) {
		$file->SetBind($TPS->{'IncTeamSize'},'tell $name, ' . formatTeamConfig($tsize+1,$tpos) . BindFile::BLF($profile, 'teamsel2',($tsize+1) . $tpos . $tsel . '.txt'));
	} else {
		$file->SetBind($TPS->{'IncTeamSize'},'nop');
	}
	if ($tsize == 1) {
		$file->SetBind($TPS->{'DecTeamSize'},'nop');
		$file->SetBind($TPS->{'IncTeamPos'}, 'nop');
		$file->SetBind($TPS->{'DecTeamPos'}, 'nop');
		$file->SetBind($TPS->{'SelNextTeam'},'nop');
		$file->SetBind($TPS->{'SelPrevTeam'},'nop');
	} else {
		my ($selnext,$selprev) = ($tsel+1,$tsel-1);
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1)      { $selprev = $tsize }
		if ($selnext == $tpos) { $selnext = $selnext + 1 }
		if ($selprev == $tpos) { $selprev = $selprev - 1 }
		if ($selnext > $tsize) { $selnext = 1 }
		if ($selprev < 1) { $selprev = $tsize }

		my ($tposup,$tposdn) = ($tpos+1,$tpos-1);
		if ($tposup > $tsize) { $tposup = 0 }
		if ($tposdn < 0)      { $tposdn = $tsize }

		my ($newpos,$newsel) = ($tpos,$tsel);
		if ($tsize-1 < $tpos) { $newpos = $tsize-1 }
		if ($tsize-1 < $tsel) { $newsel = $tsize-1 }
		if ($tsize == 2)      { $newpos = $newsel = 0 }

		$file->SetBind($TPS->{'DecTeamSize'},'tell $name, ' . formatTeamConfig($tsize-1,$newpos) . BindFile::BLF($profile, 'teamsel2', ($tsize-1) . $newpos . $newsel . '.txt'));
		$file->SetBind($TPS->{'IncTeamPos'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposup) . BindFile::BLF($profile, 'teamsel2', $tsize . $tposup . $tsel . '.txt'));
		$file->SetBind($TPS->{'DecTeamPos'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposdn) . BindFile::BLF($profile, 'teamsel2', $tsize . $tposdn . $tsel . '.txt'));

		$file->SetBind($TPS->{'SelNextTeam'},'teamselect ' . $selnext . BindFile::BLF($profile, 'teamsel2', $tsize . $tpos . $selnext . '.txt'));
		$file->SetBind($TPS->{'SelPrevTeam'},'teamselect ' . $selprev . BindFile::BLF($profile, 'teamsel2', $tsize . $tpos . $selprev . '.txt'));
	}
}

my @post = qw( Zeroth First Second Third Fourth Fifth Sixth Seventh Eighth ); # damn zero-based arrays
sub formatTeamConfig {
	my ($size,$pos) = @_;
	my $sizetext = "$size-Man";
	my $postext = ", No Spot";
	if ($pos > 0) { $postext = ", $post[$pos] Spot" }
	if ($size == 1) { $sizetext = "Solo"; $postext = "" }
	if ($size == 2) { $sizetext = "Duo" }
	if ($size == 3) { $sizetext = "Trio" }
	return "[$sizetext$postext]";
}

sub findconflicts {
	my ($profile) = @_;
	my $TPS = $profile->TeamPetSelect;
	for my $i (1..8) { cbCheckConflict($TPS,"TeamSelect$i","Team/Pet $i Key") }
	cbCheckConflict($TPS,"SelNextPet","Select next henchman");
	cbCheckConflict($TPS,"SelPrevPet","Select previous henchman");
	cbCheckConflict($TPS,"IncPetSize","Increase Henchman Group Size");
	cbCheckConflict($TPS,"DecPetSize","Decrease Henchman Group Size");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->TeamPetSelect ? $profile->TeamPetSelect->{'Enable'} : undef;
}

sub HelpText {qq|

Team/Pet Direct Selection binds contributed by ShieldBearer.

Single Key Team Selection binds based on binds from Weap0nX.

|}


UI::Labels::Add({
	TeamSelect1 => "Select First Team Member/Pet",
	TeamSelect2 => "Select Second Team Member/Pet",
	TeamSelect3 => "Select Third Team Member/Pet",
	TeamSelect4 => "Select Fourth Team Member/Pet",
	TeamSelect5 => "Select Fifth Team Member/Pet",
	TeamSelect6 => "Select Sixth Team Member/Pet",
	TeamSelect7 => "Select Seventh Team Member/Pet",
	TeamSelect8 => "Select Eighth Team Member/Pet",
	SelNextPet => 'Select Next Pet',
	SelPrevPet => 'Select Previous Pet',
	IncPetSize => 'Increase Pet Group Size',
	DecPetSize => 'Decrease Pet Group Size',
	SelNextTeam => 'Select Next Team Member',
	SelPrevTeam => 'Select Previous Team Member',
	IncTeamSize => 'Increase Team Size',
	DecTeamSize => 'Decrease Team Size',
	IncTeamPos  => 'Increase Team Position',
	DecTeamPos  => 'Decrease Team Position',
	Reset       => 'Reset to Solo',
});


1;
