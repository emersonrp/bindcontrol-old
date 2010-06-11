#!/usr/bin/perl

use strict;

package BCPlugins::Mastermind;
use parent "BCPlugins";

use Wx qw(
	wxDefaultPosition wxDefaultSize
	wxALIGN_CENTER wxHORIZONTAL wxVERTICAL wxALL wxID_ANY wxEXPAND
	wxCB_READONLY
);

sub bindsettings {
	my ($profile) = @_;
	my $petaction = $profile->{'petaction'};
	if (not defined $petaction) {
		# iup.Message("Notice","Creating Default Pet Action Bindings")
		$petaction = {
			enable => undef,
			primnumber => 1,
			primary => "Mercenaries",
		};
		$profile->{'petaction'} = $petaction;
	}
	$petaction->{'selbgm'} ||= "UNBOUND";
	$petaction->{'saybg'} ||= "Bodyguarding.";
	$petaction->{'sayallmethod'} ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'sayminmethod'} ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'sayltsmethod'} ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'saybosmethod'} ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'saybgmethod'}  ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'saynbgmethod'} ||= ($petaction->{'selmethod'} or 3);
	$petaction->{'sayaggmethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'saydefmethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'saypasmethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'sayatkmethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'sayfolmethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'saystymethod'} ||= ($petaction->{'cmdmethod'} or 3);
	$petaction->{'saygomethod'}  ||= ($petaction->{'cmdmethod'} or 3);
	if ($profile->{'archetype'} eq "Mastermind") {
		# TODO "GameData::ATPrimaries" can probably be replaced with nice hashes.
		$petaction->{'primary'} = $Gamedata::ATPrimaries[$profile->{'atnumber'}][$profile->{'primaryset'}];
		$petaction->{'primnumber'} = $profile->{'primaryset'};
	} else {
		$petaction->{'primary'} = "Mercenaries";
	}
}

sub tab {

	my ($self, $parent) = @_;

	my $profile = $Profile::current;

	my $tab = Wx::Panel->new($parent);

	my $topSizer = Wx::BoxSizer->new(wxHORIZONTAL);

	my $sizer = Wx::BoxSizer->new(wxVERTICAL);

	$sizer->Add(
		Wx::StaticText->new(
			$tab, -1,
			"The Original Mastermind Control Binds\n" .
			"were created in CoV Beta by Khaiba\n" .
			"a.k.a. Sandolphan\n" .
			"Bodyguard code inspired directly from\n" .
			"Sandolphan's Bodyguard binds.\n" .
			"Thugs added by Konoko!\n")
			#wxDefaultPosition, wxDefaultSize, wxALIGN_CENTER)
	);

	my $useCB = Wx::CheckBox->new( $tab, -1, 'Enable Mastermind Pet Binds');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the Mastermind Pet Action Binds'));
	$sizer->Add($useCB, 0, wxALL);

# TODO - add checkbox handler to hide/show (enable/disable?) the bodyguard options
	my $bgCB = Wx::CheckBox->new( $tab, -1, 'Enable Bodyguard Mode Binds');
	$bgCB->SetToolTip(Wx::ToolTip->new('Check this to enable the Bodyguard Mode Binds'));
	$bgCB->SetValue($profile->{'PetBodyguardMode'});
	$sizer->Add($bgCB, 0, wxALL);

	$sizer->AddSpacer(10);

	my $PetCommandKeys = Wx::FlexGridSizer->new(0,5,2,2);

	for my $keydef (getPetCommandKeyDefinitions()) {
		for my $cell(buildCommandKeyRow($keydef, $tab, $profile)) {
			$PetCommandKeys->Add($cell);
		}
	}

	$sizer->Add($PetCommandKeys);
#
#   #  pet name fields, as well as pet bodyguard status.
#   my $pet1name = cbToggleText("First Pet's Name (required for pet selection)",$petaction->{'pet1nameenabled'},$petaction->{'pet1name'},
#   	cbCheckBoxCB(profile,petaction,"pet1nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet1name"))
#   my $pet1isbguard = cbCheckBox("Bodyguard",$petaction->{'pet1isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet1isbguard"))
#   my $pet2name = cbToggleText("Second Pet's Name (required for pet selection)",$petaction->{'pet2nameenabled'},$petaction->{'pet2name'},
#   	cbCheckBoxCB(profile,petaction,"pet2nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet2name"))
#   my $pet2isbguard = cbCheckBox("Bodyguard",$petaction->{'pet2isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet2isbguard"))
#   my $pet3name = cbToggleText("Third Pet's Name (required for pet selection)",$petaction->{'pet3nameenabled'},$petaction->{'pet3name'},
#   	cbCheckBoxCB(profile,petaction,"pet3nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet3name"))
#   my $pet3isbguard = cbCheckBox("Bodyguard",$petaction->{'pet3isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet3isbguard"))
#   my $pet4name = cbToggleText("Fourth Pet's Name (required for pet selection)",$petaction->{'pet4nameenabled'},$petaction->{'pet4name'},
#   	cbCheckBoxCB(profile,petaction,"pet4nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet4name"))
#   my $pet4isbguard = cbCheckBox("Bodyguard",$petaction->{'pet4isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet4isbguard"))
#   my $pet5name = cbToggleText("Fifth Pet's Name (required for pet selection)",$petaction->{'pet5nameenabled'},$petaction->{'pet5name'},
#   	cbCheckBoxCB(profile,petaction,"pet5nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet5name"))
#   my $pet5isbguard = cbCheckBox("Bodyguard",$petaction->{'pet5isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet5isbguard"))
#   my $pet6name = cbToggleText("Sixth Pet's Name (required for pet selection)",$petaction->{'pet6nameenabled'},$petaction->{'pet6name'},
#   	cbCheckBoxCB(profile,petaction,"pet6nameenabled"),
#   	cbTextBoxCB(profile,petaction,"pet6name"))
#   my $pet6isbguard = cbCheckBox("Bodyguard",$petaction->{'pet6isbguard'},
#   	cbCheckBoxCB(profile,petaction,"pet6isbguard"))
#   my $petbgbox = iup.vbox{
#   	iup.hbox{pet1name,pet1isbguard},
#   	iup.hbox{pet2name,pet2isbguard},
#   	iup.hbox{pet3name,pet3isbguard},
#   	iup.hbox{pet4name,pet4isbguard},
#   	iup.hbox{pet5name,pet5isbguard},
#   	iup.hbox{pet6name,pet6isbguard}}
#
#   cbToolTip("Check this to Enable the Pet Selection Binds using Pet Names")
#   my $petselenable = cbCheckBox("Enable Pet Selection Binds (by Name)",$petaction->{'petselenable'},cbCheckBoxCB(profile,petaction,"petselenable"))
#   cbToolTip("Choose the Key Combo that will select your First Pet")
#   my $petsel0hbox = cbBindBox("Select First Pet",petaction,"sel0",undef,profile)
#   cbToolTip("Choose the Key Combo that will select your Second Pet")
#   my $petsel1hbox = cbBindBox("Select Second Pet",petaction,"sel1",undef,profile)
#   cbToolTip("Choose the Key Combo that will select your Third Pet")
#   my $petsel2hbox = cbBindBox("Select Third Pet",petaction,"sel2",undef,profile)
#   cbToolTip("Choose the Key Combo that will select your Fourth Pet")
#   my $petsel3hbox = cbBindBox("Select Fourth Pet",petaction,"sel3",undef,profile)
#   cbToolTip("Choose the Key Combo that will select your Fifth Pet")
#   my $petsel4hbox = cbBindBox("Select Fifth Pet",petaction,"sel4",undef,profile)
#   cbToolTip("Choose the Key Combo that will select your Sixth Pet")
#   my $petsel5hbox = cbBindBox("Select Sixth Pet",petaction,"sel5",undef,profile)
#
#   my $expimpbtn = cbImportExportButtons(profile,"petaction",module2.bindsettings)
#
#   my $petactdlg = iup.dialog{iup.vbox{iup.hbox{credits,iup.fill{},petbgbox,iup.fill{},iup.vbox{petselenable,petsel0hbox,petsel1hbox,petsel2hbox,petsel3hbox,petsel4hbox,petsel5hbox}},
#   	iup.hbox{iup.vbox{petactenable,mmprimhbox,petselallhbox,petselminhbox,petselltshbox,petselboshbox,petselbghbox,
#   	petsetagghbox,petsetdefhbox,petsetpashbox,petcmdatkhbox,petcmdfolhbox,petcmdstyhbox,petcmdgotohbox,bgcmdatkhbox,bgcmdgotohbox},
#   	iup.vbox{bguardenable,petchattytgl,petsayallhbox,petsayminhbox,petsayltshbox,petsayboshbox,petsaybghbox,# petsaynbghbox,
#   	petsayagghbox,petsaydefhbox,petsaypashbox,petsayatkhbox,petsayfolhbox,petsaystyhbox,petsaygotohbox,expimpbtn}}},
#   	title = "Mastermind : Henchman Binds",maxbox="NO",resize="NO",mdichild="YES",mdiclient=mdiClient}
#   cbShowDialog(petactdlg,218,10,profile,function(self) $petaction->{'dialog'} = undef end)
#   $petaction->{'dialog'} = petactdlg
	$topSizer->Add($sizer);

	$tab->SetSizerAndFit($topSizer);

	return ($tab, 'Mastermind Pet Binds');
}

# The ids of the rows and such are in a data structure at the end of the file;  they're passed in here as $k.
# The current profile is in $p, and we fetch bits out of it as needed, as defined by fields in $k.
my $ChatOptions = [ qw( Local Self-Tell Petsay None ) ];
sub buildCommandKeyRow {
	my ($k, $tab, $p) = @_;

	my $basename = $k->{'basename'};  # all of the fieldnames we look up in the profile are based on this value

	my $al = Wx::StaticText->new($tab, -1, $k->{'actlabel'});
	my $ab = Wx::Button->    new($tab, $k->{'buttonid'}, $p->{$basename});

	my $cl = Wx::StaticText->new($tab, -1, $k->{'chatlabel'});
	my $cm = Wx::ComboBox->  new($tab, $k->{'comboid'},    $p->{"${basename}ResponseMethod"}, wxDefaultPosition, wxDefaultSize, $ChatOptions, wxCB_READONLY);
	my $cr = Wx::TextCtrl->  new($tab, $k->{'textctrlid'}, $p->{"${basename}Response"});

	my $tip = $k->{'tooltipdetail'};
	$ab->SetToolTip( Wx::ToolTip->new("Choose the key combo that will $tip"));
	$cm->SetToolTip( Wx::ToolTip->new("Choose the method your pets will use to respond when they are in chatty mode and you $tip"));
	$cr->SetToolTip( Wx::ToolTip->new("Choose the chat response your pets will give when you $tip"));

	return ($al, $ab, $cl, $cm, $cr);
}

sub mmBGSelBind {
	my ($profile,$file,$petaction,$saybg,$minpow,$ltspow,$bospow) = @_;
	if ($petaction->{'bg_enable'}) {
		my ($bgsay, $bgset, $tier1bg, $tier2bg, $tier3bg);
		#  fill bgsay with the right commands to have bodyguards say saybg
		#  first check if any full tier groups are bodyguards.  full tier groups are either All BG or all NBG.
		if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
		if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
		if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
		#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
		#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
		#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
		#  so, add all fullgroups into the bgsay command.
		#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
		if ((($tier1bg + $tier2bg + $tier3bg) == 6) or ($petaction->{'saybgmethod'} != 3)) {
			my @saymethall = ("local ",'tell, $name ',"petsayall ","");
			$bgsay = $saymethall[$petaction->{'saybgmethod'}] . $saybg;
		} else {
			if ($tier1bg == 3) {
				$bgsay .= '$$petsaypow ' . "$minpow $saybg";
			} else {
				#  use petsayname commands for those $tier1s that are bodyguards.
				if ($petaction->{'pet1isbguard'}) {
					$bgsay .= '$$petsayname ' . "$petaction->{'pet1name'} $saybg";
				}
				if ($petaction->{'pet2isbguard'}) {
					$bgsay .= '$$petsayname ' . "$petaction->{'pet2name'} $saybg";
				}
				if ($petaction->{'pet3isbguard'}) {
					$bgsay .= '$$petsayname ' . "$petaction->{'pet3name'} $saybg";
				}
			}
			if ($tier2bg == 2) {
				$bgsay .= '$$petsaypow ' . "ltspow $saybg";
			} else {
				if ($petaction->{'pet4isbguard'}) {
					$bgsay .= '$$petsayname ' . "$petaction->{'pet4name'} $saybg";
				}
				if ($petaction->{'pet5isbguard'}) {
					$bgsay .= '$$petsayname ' . "$petaction->{'pet5name'} $saybg";
				}
			}
			if ($tier3bg == 1) {
				$bgsay .= '$$petsaypow ' . "$bospow $saybg";
			}
		}
		if (($tier1bg + $tier2bg + $tier3bg) == 6) {
			$bgset = '$$petcomall def fol';
		} else {
			if ($tier1bg == 3) {
				$bgset .= '$$petcompow ' . "$minpow def fol";
			} else {
				#  use petsayname commands for those $tier1s that are bodyguards.
				if ($petaction->{'pet1isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet1name'} def fol";
				}
				if ($petaction->{'pet2isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet2name'} def fol";
				}
				if ($petaction->{'pet3isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet3name'} def fol";
				}
			}
			if ($tier2bg == 2) {
				$bgset .= '$$petcompow ' . "$ltspow def fol";
			} else {
				if ($petaction->{'pet4isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet4name'} def fol";
				}
				if ($petaction->{'pet5isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet5name'} def fol";
				}
			}
			if ($tier3bg == 1) {
				$bgset .= '$$petcompow ' . "$bospow def fol";
			}
		}
		cbWriteBind($file,$petaction->{'selbgm'},$bgsay.$bgset.'$$bindloadfile ' . $profile->{'base'} . '\mmbinds\cbguarda.txt');
	}
}

sub mmBGActBind {
	my ($profile,$filedn,$fileup,$petaction,$key,$action,$say,$method,$minpow,$ltspow,$bospow,$fnamedn,$fnameup) = @_;

	my ($bgact, $bgsay, $tier1bg, $tier2bg, $tier3bg);
	#  fill bgsay with the right commands to have bodyguards say saybg
	#  first check if any full tier groups are bodyguards.  full tier groups are eaither All BG or all NBG.
	if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
	#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
	#  so, add all fullgroups into the bgsay command.
	#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
	if ((($tier1bg + $tier2bg + $tier3bg) == 0) or ($method != 3)) {
		my @saymethall = ("local ",'tell, $name ',"petsayall ","");
		$bgsay = $saymethall[$method] . $say;
	} else {
		if ($tier1bg == 0) {
			$bgsay .= '$$petsaypow ' . "$minpow $say";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if (not $petaction->{'pet1isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet1name'} $say";
			}
			if (not $petaction->{'pet2isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet2name'} $say";
			}
			if (not $petaction->{'pet3isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet3name'} $say";
			}
		}
		if ($tier2bg == 0) {
			$bgsay .= '$$petsaypow ' . "$ltspow $say";
		} else {
			if (not $petaction->{'pet4isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet4name'} $say";
			}
			if (not $petaction->{'pet5isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet5name'} $say";
			}
		}
		if ($tier3bg == 0) {
			$bgsay .= '$$petsaypow ' . "$bospow $say";
		}
	}
	if (($tier1bg + $tier2bg + $tier3bg) == 0) {
		$bgact = '$$petcomall ' . $action;
	} else {
		if ($tier1bg == 0) {
			$bgact .= '$$petcompow ' . "$minpow $action";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if (not $petaction->{'pet1isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet1name'} $action";
			}
			if (not $petaction->{'pet2isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet2name'} $action";
			}
			if (not $petaction->{'pet3isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet3name'} $action";
			}
		}
		if ($tier2bg == 0) {
			$bgact .= '$$petcompow ' . "$ltspow $action";
		} else {
			if (not $petaction->{'pet4isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet4name'} $action";
			}
			if (not $petaction->{'pet5isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet5name'} $action";
			}
		}
		if ($tier3bg == 0) {
			$bgact .= '$$petcompow ' . "$bospow $action";
		}
	}
	cbWriteToggleBind($filedn,$fileup,$key,$bgsay,$bgact,$fnamedn,$fnameup);
}

sub mmBGActBGBind {
	my ($profile,$filedn,$fileup,$petaction,$key,$action,$say,$method,$minpow,$ltspow,$bospow,$fnamedn,$fnameup) = @_;
	my ($bgact, $bgsay, $tier1bg, $tier2bg, $tier3bg);
	#  fill bgsay with the right commands to have bodyguards say saybg
	#  first check if any full tier groups are bodyguards.  full tier groups are eaither All BG or all NBG.
	if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
	#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
	#  so, add all fullgroups into the bgsay command.
	#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
	if ((($tier1bg + $tier2bg + $tier3bg) == 6) or ($method != 3)) {
		my @saymethall = ("local ",'tell, $name ',"petsayall ","");
		$bgsay = $saymethall[$method] . $say;
	} else {
		if ($tier1bg == 3) {
			$bgsay .= '$$petsaypow ' . "$minpow $say";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if ($petaction->{'pet1isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet1name'} $say";
			}
			if ($petaction->{'pet2isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet2name'} $say";
			}
			if ($petaction->{'pet3isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet3name'} $say";
			}
		}
		if ($tier2bg == 2) {
			$bgsay .= '$$petsaypow ' / "$ltspow $say";
		} else {
			if ($petaction->{'pet4isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet4name'} $say";
			}
			if ($petaction->{'pet5isbguard'}) {
				$bgsay .= '$$petsayname ' . "$petaction->{'pet5name'} $say";
			}
		}
		if ($tier3bg == 1) {
			$bgsay .= '$$petsaypow ' . "$bospow $say";
		}
	}
	if (($tier1bg + $tier2bg + $tier3bg) == 6) {
		$bgact = '$$petcomall ' . $action;
	} else {
		if ($tier1bg == 3) {
			$bgact .= '$$petcompow ' . "$minpow $action";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if ($petaction->{'pet1isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet1name'} $action";
			}
			if ($petaction->{'pet2isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet2name'} $action";
			}
			if ($petaction->{'pet3isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet3name'} $action";
			}
		}
		if ($tier2bg == 2) {
			$bgact .= '$$petcompow ' . "$ltspow $action";
		} else {
			if ($petaction->{'pet4isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet4name'} $action";
			}
			if ($petaction->{'pet5isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet5name'} $action";
			}
		}
		if ($tier3bg == 1) {
			$bgact .= '$$petcompow ' . "$bospow $action";
		}
	}
	# cbWriteBind(file,$petaction->{'selbgm'},bgsay.$bgset.'$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\cbguarda.txt')
	cbWriteToggleBind($filedn,$fileup,$key,$bgsay,$bgact,$fnamedn,$fnameup);
}

sub mmQuietBGSelBind {
	my ($profile,$file,$petaction,$minpow,$ltspow,$bospow) = @_;
	if ($petaction->{'bg_enable'}) {
		my ($bgset, $tier1bg, $tier2bg, $tier3bg);
		#  fill bgsay with the right commands to have bodyguards say saybg
		#  first check if any full tier groups are bodyguards.  full tier groups are eaither All BG or all NBG.
		if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
		if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
		if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
		if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
		#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
		#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
		#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
		#  so, add all fullgroups into the bgsay command.
		#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
		if (($tier1bg + $tier2bg + $tier3bg) == 6) {
			$bgset = "petcomall def fol";
		} else {
			if ($tier1bg == 3) {
				$bgset .= '$$petcompow ' . "$minpow def fol";
			} else {
				#  use petsayname commands for those $tier1s that are bodyguards.
				if ($petaction->{'pet1isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet1name'} def fol";
				}
				if ($petaction->{'pet2isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet2name'} def fol";
				}
				if ($petaction->{'pet3isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet3name'} def fol";
				}
			}
			if ($tier2bg == 2) {
				$bgset .= '$$petcompow ' . "$ltspow def fol";
			} else {
				if ($petaction->{'pet4isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet4name'} def fol";
				}
				if ($petaction->{'pet5isbguard'}) {
					$bgset .= '$$petcomname ' . "$petaction->{'pet5name'} def fol";
				}
			}
			if ($tier3bg == 1) {
				$bgset .= '$$petcompow ' . "$bospow def fol";
			}
		}
		cbWriteBind($file,$petaction->{'selbgm'},$bgset . '$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\bguarda.txt')
	}
}

sub mmQuietBGActBind {
	my ($profile,$filedn,$fileup,$petaction,$key,$action,$minpow,$ltspow,$bospow) = @_;
	my ($bgact, $tier1bg, $tier2bg, $tier3bg);
	#  fill bgsay with the right commands to have bodyguards say saybg
	#  first check if any full tier groups are bodyguards.  full tier groups are eaither All BG or all NBG.
	if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
	#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
	#  so, add all fullgroups into the bgsay command.
	#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
	if (($tier1bg + $tier2bg + $tier3bg) == 0) {
		$bgact = "petcomall $action";
	} else {
		if ($tier1bg == 0) {
			$bgact .= '$$petcompow ' . "$minpow $action";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if (not $petaction->{'pet1isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet1name'} $action";
			}
			if (not $petaction->{'pet2isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet2name'} $action";
			}
			if (not $petaction->{'pet3isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet3name'} $action";
			}
		}
		if ($tier2bg == 0) {
			$bgact .= '$$petcompow ' . "$ltspow $action";
		} else {
			if (not $petaction->{'pet4isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet4name'} $action";
			}
			if (not $petaction->{'pet5isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet5name'} $action";
			}
		}
		if ($tier3bg == 0) {
			$bgact .= '$$petcompow ' . "$bospow $action";
		}
	}
	# 'petcompow ',,grp.' Stay'
	cbWriteBind($filedn,$key,$bgact);
}

sub mmQuietBGActBGBind {
	my ($profile,$filedn,$fileup,$petaction,$key,$action,$minpow,$ltspow,$bospow) = @_;
	my ($bgact, $tier1bg, $tier2bg, $tier3bg);
	#  fill bgsay with the right commands to have bodyguards say saybg
	#  first check if any full tier groups are bodyguards.  full tier groups are eaither All BG or all NBG.
	if ($petaction->{'pet1isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet2isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet3isbguard'}) { $tier1bg++; }
	if ($petaction->{'pet4isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet5isbguard'}) { $tier2bg++; }
	if ($petaction->{'pet6isbguard'}) { $tier3bg++; }
	#  if $tier1bg is 3 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  if $tier2bg is 2 or 0 then it is a full bg or full nbg group.  otherwise we have to call them by name.
	#  $tier3bg is ALWAYS a full group, with only one member, he is either BG or NBG
	#  so, add all fullgroups into the bgsay command.
	#  first check if $tier1bg + $tier2bg + $tier3bg == 6, if so, we can get away with petsayall.
	if (($tier1bg + $tier2bg + $tier3bg) == 6) {
		$bgact = "petcomall $action";
	} else {
		if ($tier1bg == 3) {
			$bgact .= '$$petcompow ' . "$minpow $action";
		} else {
			#  use petsayname commands for those $tier1s that are bodyguards.
			if ($petaction->{'pet1isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet1name'} $action";
			}
			if ($petaction->{'pet2isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet2name'} $action";
			}
			if ($petaction->{'pet3isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet3name'} $action";
			}
		}
		if ($tier2bg == 2) {
			$bgact .= '$$petcompow ' . "$ltspow $action";
		} else {
			if ($petaction->{'pet4isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet4name'} $action";
			}
			if ($petaction->{'pet5isbguard'}) {
				$bgact .= '$$petcomname ' . "$petaction->{'pet5name'} $action";
			}
		}
		if ($tier3bg == 1) {
			$bgact .= '$$petcompow ' . "$bospow $action";
		}
	}
	# 'petcompow ',,grp.' Stay'
	cbWriteBind($filedn,$key,$bgact);
}

sub mmSubBind {
	my ($profile,$file,$petaction,$fn,$grp,$minpow,$ltspow,$bospow) = @_;
	my ($sayall, $saymin, $saylts, $saybos, $sayagg, $saydef, $saypas, $sayatk, $sayfol, $saysty, $saygo, $saybg);
	if ($petaction->{'sayallmethod'} < 4) { $sayall = $petaction->{'sayall'} . '$$' } else { $sayall = ""; }
	if ($petaction->{'sayminmethod'} < 4) { $saymin = $petaction->{'saymin'} . '$$' } else { $saymin = ""; }
	if ($petaction->{'sayltsmethod'} < 4) { $saylts = $petaction->{'saylts'} . '$$' } else { $saylts = ""; }
	if ($petaction->{'saybosmethod'} < 4) { $saybos = $petaction->{'saybos'} . '$$' } else { $saybos = ""; }
	if ($petaction->{'saybgmethod'}  < 4) { $saybg  = $petaction->{'saybg'}  . '$$' } else { $saybg  = ""; }
	if ($petaction->{'sayaggmethod'} < 4) { $sayagg = $petaction->{'sayagg'} . '$$' } else { $sayagg = ""; }
	if ($petaction->{'saydefmethod'} < 4) { $saydef = $petaction->{'saydef'} . '$$' } else { $saydef = ""; }
	if ($petaction->{'saypasmethod'} < 4) { $saypas = $petaction->{'saypas'} . '$$' } else { $saypas = ""; }
	if ($petaction->{'sayatkmethod'} < 4) { $sayatk = $petaction->{'sayatk'} . '$$' } else { $sayatk = ""; }
	if ($petaction->{'sayfolmethod'} < 4) { $sayfol = $petaction->{'sayfol'} . '$$' } else { $sayfol = ""; }
	if ($petaction->{'saystymethod'} < 4) { $saysty = $petaction->{'saysty'} . '$$' } else { $saysty = ""; }
	if ($petaction->{'saygomethod'}  < 4) { $saygo  = $petaction->{'saygo'}  . '$$' } else { $saygo  = ""; }
	my @saymethall = ("local ",'tell, $name ',"petsayall ","");
	my @saymethmin = ("local ",'tell, $name ',"petsaypow $minpow ","");
	my @saymethlts = ("local ",'tell, $name ',"petsaypow $ltspow ","");
	my @saymethbos = ("local ",'tell, $name ',"petsaypow $bospow ","");

	cbWriteBind($file,$petaction->{'selall'},$saymethall[$petaction->{'sayallmethod'}] . $sayall . '$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\call.txt");
	cbWriteBind($file,$petaction->{'selmin'},$saymethmin[$petaction->{'sayminmethod'}] . $saymin . '$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\ctier1.txt");
	cbWriteBind($file,$petaction->{'sellts'},$saymethlts[$petaction->{'sayltsmethod'}] . $saylts . '$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\ctier2.txt");
	cbWriteBind($file,$petaction->{'selbos'},$saymethbos[$petaction->{'saybosmethod'}] . $saybos . '$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\ctier3.txt");
	mmBGSelBind($profile,$file,$petaction,$saybg,$minpow,$ltspow,$bospow);
	if ($grp) {
		cbWriteBind($file,$petaction->{'setagg'},$saymethall[$petaction->{'sayaggmethod'}] . $sayagg . '$$petcompow ' . "$grp Aggressive");
		cbWriteBind($file,$petaction->{'setdef'},$saymethall[$petaction->{'saydefmethod'}] . $saydef . '$$petcompow ' . "$grp Defensive");
		cbWriteBind($file,$petaction->{'setpas'},$saymethall[$petaction->{'saypasmethod'}] . $saypas . '$$petcompow ' . "$grp Passive");
		cbWriteBind($file,$petaction->{'cmdatk'},$saymethall[$petaction->{'sayatkmethod'}] . $sayatk . '$$petcompow ' . "$grp Attack");
		cbWriteBind($file,$petaction->{'cmdfol'},$saymethall[$petaction->{'sayfolmethod'}] . $sayfol . '$$petcompow ' . "$grp Follow");
		cbWriteBind($file,$petaction->{'cmdsty'},$saymethall[$petaction->{'saystymethod'}] . $saysty . '$$petcompow ' . "$grp Stay");
		cbWriteBind($file,$petaction->{'cmdgoto'},$saymethall[$petaction->{'saygomethod'}] . $saygo . '$$petcompow ' . "$grp Goto");
	} else {
		cbWriteBind($file,$petaction->{'setagg'},$saymethall[$petaction->{'sayaggmethod'}] . $sayagg . '$$petcomall Aggressive');
		cbWriteBind($file,$petaction->{'setdef'},$saymethall[$petaction->{'saydefmethod'}] . $saydef . '$$petcomall Defensive');
		cbWriteBind($file,$petaction->{'setpas'},$saymethall[$petaction->{'saypasmethod'}] . $saypas . '$$petcomall Passive');
		cbWriteBind($file,$petaction->{'cmdatk'},$saymethall[$petaction->{'sayatkmethod'}] . $sayatk . '$$petcomall Attack');
		cbWriteBind($file,$petaction->{'cmdfol'},$saymethall[$petaction->{'sayfolmethod'}] . $sayfol . '$$petcomall Follow');
		cbWriteBind($file,$petaction->{'cmdsty'},$saymethall[$petaction->{'saystymethod'}] . $saysty . '$$petcomall Stay');
		cbWriteBind($file,$petaction->{'cmdgoto'},$saymethall[$petaction->{'saygomethod'}] . $saygo . '$$petcomall Goto');
	}
	if ($petaction->{'bgatkenabled'}) {
		cbWriteBind($file,$petaction->{'bgatk'},'nop');
	}
	if ($petaction->{'bggotoenabled'}) {
		cbWriteBind($file,$petaction->{'bggoto'},'nop');
	}
	cbWriteBind($file,$petaction->{'chattykey'},'tell $name, Non-Chatty Mode$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\$fn.txt");
}

sub mmBGSubBind {
	my ($profile,$filedn,$fileup,$petaction,$fn,$minpow,$ltspow,$bospow) = @_;
	my ($sayall, $saymin, $saylts, $saybos, $sayagg, $saydef, $saypas, $sayatk, $sayfol, $saysty, $saygo, $saybg);
	if ($petaction->{'sayallmethod'} < 4) { $sayall = $petaction->{'sayall'} . '$$' } else { $sayall = ""; }
	if ($petaction->{'sayminmethod'} < 4) { $saymin = $petaction->{'saymin'} . '$$' } else { $saymin = ""; }
	if ($petaction->{'sayltsmethod'} < 4) { $saylts = $petaction->{'saylts'} . '$$' } else { $saylts = ""; }
	if ($petaction->{'saybosmethod'} < 4) { $saybos = $petaction->{'saybos'} . '$$' } else { $saybos = ""; }
	if ($petaction->{'saybgmethod'}  < 4) { $saybg  = $petaction->{'saybg'}  . '$$' } else { $saybg =  ""; }
	if ($petaction->{'sayaggmethod'} < 4) { $sayagg = $petaction->{'sayagg'} . '$$' } else { $sayagg = ""; }
	if ($petaction->{'saydefmethod'} < 4) { $saydef = $petaction->{'saydef'} . '$$' } else { $saydef = ""; }
	if ($petaction->{'saypasmethod'} < 4) { $saypas = $petaction->{'saypas'} . '$$' } else { $saypas = ""; }
	if ($petaction->{'sayatkmethod'} < 4) { $sayatk = $petaction->{'sayatk'} . '$$' } else { $sayatk = ""; }
	if ($petaction->{'sayfolmethod'} < 4) { $sayfol = $petaction->{'sayfol'} . '$$' } else { $sayfol = ""; }
	if ($petaction->{'saystymethod'} < 4) { $saysty = $petaction->{'saysty'} . '$$' } else { $saysty = ""; }
	if ($petaction->{'saygomethod'}  < 4) { $saygo  = $petaction->{'saygo'}  . '$$' } else { $saygo =  ""; }
	my @saymethall = ("local ",'tell, $name ',"petsayall ","");
	my @saymethmin = ("local ",'tell, $name ',"petsaypow $minpow ","");
	my @saymethlts = ("local ",'tell, $name ',"petsaypow $ltspow ","");
	my @saymethbos = ("local ",'tell, $name ',"petsaypow $bospow ","");

	cbWriteBind($filedn,$petaction->{'selall'},$saymethall[$petaction->{'sayallmethod'}] . $sayall . '$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\call.txt');
	cbWriteBind($filedn,$petaction->{'selmin'},$saymethmin[$petaction->{'sayminmethod'}] . $saymin . '$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\ctier1.txt');
	cbWriteBind($filedn,$petaction->{'sellts'},$saymethlts[$petaction->{'sayltsmethod'}] . $saylts . '$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\ctier2.txt');
	cbWriteBind($filedn,$petaction->{'selbos'},$saymethbos[$petaction->{'saybosmethod'}] . $saybos . '$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\ctier3.txt');
	mmBGSelBind($profile,$filedn,$petaction,$saybg,$minpow,$ltspow,$bospow);

	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setagg'},'Aggressive',$sayagg,$petaction->{'sayaggmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setdef'},'Defensive',$saydef,$petaction->{'saydefmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setpas'},'Passive',$saypas,$petaction->{'saypasmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdatk'},'Attack',$sayatk,$petaction->{'sayatkmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	if ($petaction->{'bgatkenabled'}) {
		mmBGActBGBind($profile,$filedn,$fileup,$petaction,$petaction->{'bgatk'},'Attack',$sayatk,$petaction->{'sayatkmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	}
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdfol'},'Follow',$sayfol,$petaction->{'sayfolmethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdsty'},'Stay',$saysty,$petaction->{'saystymethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	mmBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdgoto'},'Goto',$saygo,$petaction->{'saygomethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	if ($petaction->{'bggotoenabled'}) {
		mmBGActBGBind($profile,$filedn,$fileup,$petaction,$petaction->{'bggoto'},'Goto',$saygo,$petaction->{'saygomethod'},$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\cbguarda.txt',$profile->{'base'}.'\\mmbinds\\cbguardb.txt');
	}
	cbWriteBind($filedn,$petaction->{'chattykey'},'tell $name, Non-Chatty Mode$$bindloadfile ' . "$profile->{'base'}\\mmbinds\\${fn}a.txt");
}

sub mmQuietSubBind {
	my ($profile,$file,$petaction,$fn,$grp,$minpow,$ltspow,$bospow) = @_;
	cbWriteBind($file,$petaction->{'selall'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\all.txt');
	cbWriteBind($file,$petaction->{'selmin'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier1.txt');
	cbWriteBind($file,$petaction->{'sellts'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier2.txt');
	cbWriteBind($file,$petaction->{'selbos'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier3.txt');
	mmQuietBGSelBind($profile,$file,$petaction,$minpow,$ltspow,$bospow);
	if ($grp) {
		cbWriteBind($file,$petaction->{'setagg'},'petcompow ' . "$grp Aggressive");
		cbWriteBind($file,$petaction->{'setdef'},'petcompow ' . "$grp Defensive");
		cbWriteBind($file,$petaction->{'setpas'},'petcompow ' . "$grp Passive");
		cbWriteBind($file,$petaction->{'cmdatk'},'petcompow ' . "$grp Attack");
		cbWriteBind($file,$petaction->{'cmdfol'},'petcompow ' . "$grp Follow");
		cbWriteBind($file,$petaction->{'cmdsty'},'petcompow ' . "$grp Stay");
		cbWriteBind($file,$petaction->{'cmdgoto'},'petcompow ' . "$grp Goto");
	} else {
		cbWriteBind($file,$petaction->{'setagg'},'petcomall Aggressive');
		cbWriteBind($file,$petaction->{'setdef'},'petcomall Defensive');
		cbWriteBind($file,$petaction->{'setpas'},'petcomall Passive');
		cbWriteBind($file,$petaction->{'cmdatk'},'petcomall Attack');
		cbWriteBind($file,$petaction->{'cmdfol'},'petcomall Follow');
		cbWriteBind($file,$petaction->{'cmdsty'},'petcomall Stay');
		cbWriteBind($file,$petaction->{'cmdgoto'},'petcomall Goto');
	}
	if ($petaction->{'bgatkenabled'}) {
		cbWriteBind($file,$petaction->{'bgatk'},'nop');
	}
	if ($petaction->{'bggotoenabled'}) {
		cbWriteBind($file,$petaction->{'bggoto'},'nop');
	}
	cbWriteBind($file,$petaction->{'chattykey'},'tell $name, Chatty Mode$$bindloadfile ' . $profile->{'base'} . '\\mmbinds\\c' . $fn . '.txt');
}

sub mmQuietBGSubBind {
	my ($profile,$filedn,$fileup,$petaction,$fn,$minpow,$ltspow,$bospow) = @_;
	cbWriteBind($filedn,$petaction->{'selall'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\all.txt');
	cbWriteBind($filedn,$petaction->{'selmin'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier1.txt');
	cbWriteBind($filedn,$petaction->{'sellts'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier2.txt');
	cbWriteBind($filedn,$petaction->{'selbos'},'bindloadfile ' . $profile->{'base'} . '\\mmbinds\\tier3.txt');
	mmQuietBGSelBind($profile,$filedn,$petaction,$minpow,$ltspow,$bospow);
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setagg'},'Aggressive',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setdef'},'Defensive',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'setpas'},'Passive',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdatk'},'Attack',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	if ($petaction->{'bgatkenabled'}) {
		mmQuietBGActBGBind($profile,$filedn,$fileup,$petaction,$petaction->{'bgatk'},'Attack',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	}
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdfol'},'Follow',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdsty'},'Stay',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	mmQuietBGActBind($profile,$filedn,$fileup,$petaction,$petaction->{'cmdgoto'},'Goto',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	if ($petaction->{'bggotoenabled'}) {
		mmQuietBGActBGBind($profile,$filedn,$fileup,$petaction,$petaction->{'bggoto'},'Goto',$minpow,$ltspow,$bospow,$profile->{'base'}.'\\mmbinds\\bguarda.txt',$profile->{'base'}.'\\mmbinds\\bguardb.txt');
	}
	cbWriteBind($filedn,$petaction->{'chattykey'},'tell $name, Chatty Mode$$bindloadfile '.$profile->{'base'}.'\\mmbinds\\c' . $fn . 'a.txt');
}

sub makebind {
	my ($profile) = @_;
	my $resetfile = $profile->{'resetfile'};
	my $petaction = $profile->{'petaction'};
	if ($petaction->{'petselenable'}) {
		if ($petaction->{'pet1nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel0'},'petselectname ' . $petaction->{'pet1name'});
		}
		if ($petaction->{'pet2nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel1'},'petselectname ' . $petaction->{'pet2name'});
		}
		if ($petaction->{'pet3nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel2'},'petselectname ' . $petaction->{'pet3name'});
		}
		if ($petaction->{'pet4nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel3'},'petselectname ' . $petaction->{'pet4name'});
		}
		if ($petaction->{'pet5nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel4'},'petselectname ' . $petaction->{'pet5name'});
		}
		if ($petaction->{'pet6nameenabled'}) {
			cbWriteBind($resetfile,$petaction->{'sel5'},'petselectname ' . $petaction->{'pet6name'});
		}
	}
	cbMakeDirectory($profile->{'base'}."\\mmbinds");
	my $allfile = cbOpen($profile->{'base'} . "\\mmbinds\\all.txt","w");
	my $minfile = cbOpen($profile->{'base'} . "\\mmbinds\\tier1.txt","w");
	my $ltsfile = cbOpen($profile->{'base'} . "\\mmbinds\\tier2.txt","w");
	my $bosfile = cbOpen($profile->{'base'} . "\\mmbinds\\tier3.txt","w");
	my $bgfiledn;
	my $bgfileup;
	if ($petaction->{'bg_enable'}) {
		$bgfiledn = cbOpen($profile->{'base'} . "\\mmbinds\\bguarda.txt","w");
		#  since we never need to split lines up in this fashion
		#  comment the next line out so an empty file is not created.
		# bgfileup = cbOpen($profile->{'base'} . "\\mmbinds\\bguardb.txt","w")
	}
	my $callfile = cbOpen($profile->{'base'} . "\\mmbinds\\call.txt","w");
	my $cminfile = cbOpen($profile->{'base'} . "\\mmbinds\\ctier1.txt","w");
	my $cltsfile = cbOpen($profile->{'base'} . "\\mmbinds\\ctier2.txt","w");
	my $cbosfile = cbOpen($profile->{'base'} . "\\mmbinds\\ctier3.txt","w");
	my $cbgfiledn;
	my $cbgfileup;
	if ($petaction->{'bg_enable'}) {
		$cbgfiledn = cbOpen($profile->{'base'} . "\\mmbinds\\cbguarda.txt","w");
		$cbgfileup = cbOpen($profile->{'base'} . "\\mmbinds\\cbguardb.txt","w");
	}
	my $minpow;
	my $ltspow;
	my $bospow;
	if ($petaction->{'primary'} eq "Mercenaries") {
		$minpow = "sol";
		$ltspow = "spec";
		$bospow = "com";
	} elsif ($petaction->{'primary'} eq "Ninjas") {
		$minpow = "gen";
		$ltspow = "joun";
		$bospow = "oni";
	} elsif ($petaction->{'primary'} eq "Robotics") {
		$minpow = "dron";
		$ltspow = "prot";
		$bospow = "ass";
	} elsif ($petaction->{'primary'} eq "Necromancy") {
		$minpow = "zom";
		$ltspow = "grav";
		$bospow = "lich";
	} elsif ($petaction->{'primary'} eq "Thugs") {
		$minpow = "thu";
		$ltspow = "enf";
		$bospow = "bru";
	}
	# "Local","Self-Tell","Petsay","None";
	mmSubBind($profile,$resetfile,$petaction,"all",undef,$minpow,$ltspow,$bospow);
	mmQuietSubBind($profile,$allfile,$petaction,"all",undef,$minpow,$ltspow,$bospow);
	mmQuietSubBind($profile,$minfile,$petaction,"tier1",$minpow,$minpow,$ltspow,$bospow);
	mmQuietSubBind($profile,$ltsfile,$petaction,"tier2",$ltspow,$minpow,$ltspow,$bospow);
	mmQuietSubBind($profile,$bosfile,$petaction,"tier3",$bospow,$minpow,$ltspow,$bospow);
	if ($petaction->{'bg_enable'}) {
		mmQuietBGSubBind($profile,$bgfiledn,$bgfileup,$petaction,"bguard",$minpow,$ltspow,$bospow);
	}
	mmSubBind($profile,$callfile,$petaction,"all",undef,$minpow,$ltspow,$bospow);
	mmSubBind($profile,$cminfile,$petaction,"tier1",$minpow,$minpow,$ltspow,$bospow);
	mmSubBind($profile,$cltsfile,$petaction,"tier2",$ltspow,$minpow,$ltspow,$bospow);
	mmSubBind($profile,$cbosfile,$petaction,"tier3",$bospow,$minpow,$ltspow,$bospow);
	if ($petaction->{'bg_enable'}) {
		mmBGSubBind($profile,$cbgfiledn,$cbgfileup,$petaction,"bguard",$minpow,$ltspow,$bospow);
	}
	close $allfile;
	close $minfile;
	close $ltsfile;
	close $bosfile;
	if ($petaction->{'bg_enable'}) {
		close $bgfiledn;
		# close $bgfileup;
	}
	close $callfile;
	close $cminfile;
	close $cltsfile;
	close $cbosfile;
	if ($petaction->{'bg_enable'}) {
		close $cbgfiledn;
		close $cbgfileup;
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $petaction = $profile->{'petaction'};
	if ($petaction->{'petselenable'}) {
		for my $i (1..6) {
			if ($petaction->{'pet'.$i.'nameenabled'}) {
				cbCheckConflict($petaction,"sel".($i-1),"Select Pet ".$i)
			}
		}
	}
	cbCheckConflict($petaction,"selall","Select All Pets");
	cbCheckConflict($petaction,"selmin","Select Minions");
	cbCheckConflict($petaction,"sellts","Select Lieutenants");
	cbCheckConflict($petaction,"selbos","Select Boss Pet");
	cbCheckConflict($petaction,"setagg","Set Pets Aggressive");
	cbCheckConflict($petaction,"setdef","Set Pets Defensive");
	cbCheckConflict($petaction,"setpas","Set Pets Passive");
	cbCheckConflict($petaction,"cmdatk","Pet Order: Attack");
	cbCheckConflict($petaction,"cmdfol","Pet Order: Follow");
	cbCheckConflict($petaction,"cmdsty","Pet Order: Stay");
	cbCheckConflict($petaction,"cmdgoto","Pet Order: Goto");
	cbCheckConflict($petaction,"chattykey","Pet Action Bind Chatty Mode Toggle");
	if ($petaction->{'bg_enable'}) {
		cbCheckConflict($petaction,"selbgm","Bodyguard Mode");
		if ($petaction->{'bgatkenabled'})  { cbCheckConflict($petaction,"bgatk","Pet Order: BG Attack"); }
		if ($petaction->{'bggotoenabled'}) { cbCheckConflict($petaction,"bggoto","Pet Order: BG Goto"); }
	}
}

sub bindisused {
	my ($profile) = @_;
	if ($profile->{'petaction'} == undef) { return undef; }
	return $profile->{'petaction'}->{'enable'}
}


sub getPetCommandKeyDefinitions {
	(
		{
			actlabel      => 'Select All',
			basename      => 'PetSelectAll',
			chatlabel     => 'Response to Select All',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'select all of your pets',
		},
		{
			actlabel      => 'Select Minions',
			basename      => 'PetSelectMinions',
			chatlabel     => 'Response to Select Minions',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'select your "minion" pets',
		},
		{
			actlabel      => 'Select Lieutenants',
			basename      => 'PetSelectLieutenants',
			chatlabel     => 'Response to Select Lieutenants',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'select your "lieutenant" pets',
		},
		{
			actlabel      => 'Select Boss',
			basename      => 'PetSelectBoss',
			chatlabel     => 'Response to Select Boss',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'select your "boss" pet',
		},
		{
			actlabel      => 'Bodyguard',
			basename      => 'PetBodyguard',
			chatlabel     => 'Response to Bodyguard',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'put your selected pets into Bodyguard mode',
		},
		{
			actlabel      => 'Aggressive',
			basename      => 'PetAggressive',
			chatlabel     => 'Response to Set Aggressive',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'set your selected pets to "Aggressive" mode',
		},
		{
			actlabel      => 'Defensive',
			basename      => 'PetDefensive',
			chatlabel     => 'Response to Set Defensive',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'set your selected pets to "Defensive" mode',
		},
		{
			actlabel      => 'Passive',
			basename      => 'PetPassive',
			chatlabel     => 'Response to Set Passive',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'set your selected pets to "Passive" mode',
		},
		{
			actlabel      => 'Attack',
			basename      => 'PetAttack',
			chatlabel     => 'Response to Attack',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'order your selected pets to Attack your target',
		},
		{
			actlabel      => 'Follow',
			basename      => 'PetFollow',
			chatlabel     => 'Response to Follow',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'order your selected pets to Follow you',
		},
		{
			actlabel      => 'Stay',
			basename      => 'PetStay',
			chatlabel     => 'Response to Stay',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'order your selected pets to Stay at their current location',
		},
		{
			actlabel      => 'Go To',
			basename      => 'PetGoto',
			chatlabel     => 'Response to Go To',
			buttonid      => wxID_ANY,
			comboid       => wxID_ANY,
			textctrlid    => wxID_ANY,
			tooltipdetail => 'order your selected pets to Go To a targeted location',
		},
	);
}

1;
