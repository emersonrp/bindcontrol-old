#!/usr/bin/perl

use strict;

package Module::TeamSel2;
use parent "Module::Module";

use Wx qw(:everything);

our $ModuleName = 'TeamSel2';

sub InitKeys {
	my $Profile = shift->Profile;
	$Profile->TeamSel2 ||= {
		'Enable' => 1,
		'SelNextTeam' => 'A',
		'SelPrevTeam' => 'G',
		'IncTeamSize' => 'P',
		'DecTeamSize' => 'H',
		'IncTeamPos'  => '4',
		'DecTeamPos'  => '8',
		'Reset'       => '0',
	}
}


sub FillTab {
	my $self = shift;

	my $Tab = $self->Tab;
	my $TeamSel2 = $self->Profile->TeamSel2;

	my $buttonSizer = Wx::FlexGridSizer->new(0,2,3,3);

	$self->addLabeledButton($buttonSizer, $TeamSel2, 'SelNextTeam');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'SelPrevTeam');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'IncTeamSize');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'DecTeamSize');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'IncTeamPos');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'DecTeamPos');
	$self->addLabeledButton($buttonSizer, $TeamSel2, 'Reset');

	$self->TabTitle = "Single Key Team Select";

	$Tab->SetSizerAndFit($buttonSizer);

	return $self;

}

sub HelpText { "Single Key Team Selection binds\nbased on binds from Weap0nX." }

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

sub ts2CreateSet {
	my ($profile,$tsize,$tpos,$tsel,$file) = @_;
	my $ts2 = $profile->TeamSel2;
	#  tsize is the size of the team at the moment
	#  tpos is the position of the player at the moment, or 0 if unknown
	#  tsel is the currently selected team member as far as the bind knows, or 0 if unknown
	$file->SetBind($ts2->{'Reset'},'tell $name, Re-Loaded Single Key Team Select Bind' . BindFile::BLF($profile, 'teamsel2', '100.txt'));
	if ($tsize < 8) {
		$file->SetBind($ts2->{'IncTeamSize'},'tell $name, ' . formatTeamConfig($tsize+1,$tpos) . BindFile::BLF($profile, 'teamsel2',($tsize+1) . $tpos . $tsel . '.txt'));
	} else {
		$file->SetBind($ts2->{'IncTeamSize'},'nop');
	}
	if ($tsize == 1) {
		$file->SetBind($ts2->{'DecTeamSize'},'nop');
		$file->SetBind($ts2->{'IncTeamPos'}, 'nop');
		$file->SetBind($ts2->{'DecTeamPos'}, 'nop');
		$file->SetBind($ts2->{'SelNextTeam'},'nop');
		$file->SetBind($ts2->{'SelPrevTeam'},'nop');
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

		$file->SetBind($ts2->{'DecTeamSize'},'tell $name, ' . formatTeamConfig($tsize-1,$newpos) . BindFile::BLF($profile, 'teamsel2', ($tsize-1) . $newpos . $newsel . '.txt'));
		$file->SetBind($ts2->{'IncTeamPos'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposup) . BindFile::BLF($profile, 'teamsel2', $tsize . $tposup . $tsel . '.txt'));
		$file->SetBind($ts2->{'DecTeamPos'}, 'tell $name, ' . formatTeamConfig($tsize,  $tposdn) . BindFile::BLF($profile, 'teamsel2', $tsize . $tposdn . $tsel . '.txt'));

		$file->SetBind($ts2->{'SelNextTeam'},'teamselect ' . $selnext . BindFile::BLF($profile, 'teamsel2', $tsize . $tpos . $selnext . '.txt'));
		$file->SetBind($ts2->{'SelPrevTeam'},'teamselect ' . $selprev . BindFile::BLF($profile, 'teamsel2', $tsize . $tpos . $selprev . '.txt'));
	}
}

sub PopulateBindFiles {
	my $profile = shift->Profile;
	my $TeamSel2 = $profile->TeamSel2;

	return unless $TeamSel2->{'Enable'};

	ts2CreateSet($profile,1,0,0,$profile->General->{'ResetFile'});
	for my $size (1..8) {
		for my $pos (0..$size) {
			for my $sel (0..$size) {
				if ($sel != $pos or $sel == 0) {
					my $file = $profile->GetBindFile("teamsel2", $size . $pos . $sel . '.txt');
					ts2CreateSet($profile,$size,$pos,$sel,$file);
				}
			}
		}
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $TeamSel2 = $profile->TeamSel2;
	cbCheckConflict($TeamSel2,"SelNextTeam","Select next team member");
	cbCheckConflict($TeamSel2,"SelPrevTeam","Select previous team member");
	cbCheckConflict($TeamSel2,"IncTeamSize","Increase Team Size");
	cbCheckConflict($TeamSel2,"DecTeamSize","Decrease Team Size");
	cbCheckConflict($TeamSel2,"IncTeamPos","Increase Team Position");
	cbCheckConflict($TeamSel2,"DecTeamPos","Decrease Team Position");
	cbCheckConflict($TeamSel2,"Reset","Reset to Solo Key");
}

sub bindisused {
	my ($profile) = @_;
	return $profile->TeamSel2 ? $profile->TeamSel2->{'Enable'} : undef;
}

UI::Labels::Add({
	SelNextTeam => 'Select Next Team Member',
	SelPrevTeam => 'Select Previous Team Member',
	IncTeamSize => 'Increase Team Size',
	DecTeamSize => 'Decrease Team Size',
	IncTeamPos  => 'Increase Team Position',
	DecTeamPos  => 'Decrease Team Position',
	Reset       => 'Reset to Solo',
});

1;
