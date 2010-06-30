#!/usr/bin/perl

package BCPlugins::InspirationPopper;

use strict;
use parent "BCPlugins";

use Wx qw( :everything );

use Utility qw(id);

sub new {

	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	$self->{'TabTitle'} = 'Inspiration Popper';

	my $profile = $Profile::current;
	my $InspPop = $profile->{'InspPop'};
	unless ($InspPop) {
		$InspPop = {
			Enable => undef,
			AccuracyKey     => "LSHIFT+A",
			HealthKey       => "LSHIFT+S",
			DamageKey       => "LSHIFT+D",
			EnduranceKey    => "LSHIFT+Q",
			DefenseKey      => "LSHIFT+W",
			BreakFreeKey    => "LSHIFT+E",
			ResistDamageKey => "LSHIFT+SPACE",
		};
		$profile->{'InspPop'} = $InspPop;
	}

	my $sizer = Wx::BoxSizer->new(wxVERTICAL);

	my $InspRows =    Wx::FlexGridSizer->new(0,10,2,2);
	my $RevInspRows = Wx::FlexGridSizer->new(0,10,2,2);

	for my $Insp (sort keys %GameData::Inspirations) {

		$InspPop->{"Rev${Insp}Key"}    ||= 'UNBOUND';
		$InspPop->{"${Insp}Colors"}    ||= Utility::ColorDefault();
		$InspPop->{"Rev${Insp}Colors"} ||= Utility::ColorDefault();

		for my $order ('', 'Rev') {

			my $RowSet = $order ? $RevInspRows : $InspRows;

			$RowSet->Add ( Wx::StaticText->new($self, -1, "$order $Insp Key"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);

			my $KeyPicker =  Wx::Button->    new($self, id("${order}${Insp}Key"), $InspPop->{"${order}${Insp}Key"});
			$KeyPicker->SetToolTip( Wx::ToolTip->new("Choose the key combo to activate a $Insp inspiration") );
			$RowSet->Add ( $KeyPicker, 0, wxEXPAND);

			$RowSet->AddStretchSpacer(wxEXPAND);

			my $ColorsCB = Wx::CheckBox->    new($self, id("${order}${Insp}Colors"), '');
			$ColorsCB->SetToolTip( Wx::ToolTip->new("Colorize Inspiration-Popper chat feedback") );
			$RowSet->Add ( $ColorsCB, 0, wxALIGN_CENTER_VERTICAL);

			$RowSet->Add( Wx::StaticText->new($self, -1, "Border"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
			my $bc = $InspPop->{"${order}${Insp}Colors"}->{'border'};
			$RowSet->Add( Wx::ColourPickerCtrl->new(
					$self, id("${order}${Insp}BorderColor"),
					Wx::Colour->new($bc->{'r'}, $bc->{'g'}, $bc->{'b'}),
					wxDefaultPosition, wxDefaultSize,
				)
			);

			$RowSet->Add( Wx::StaticText->new($self, -1, "Background"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
			my $bc = $InspPop->{"${order}${Insp}Colors"}->{'background'};
			$RowSet->Add( Wx::ColourPickerCtrl->new(
					$self, id("${order}${Insp}BackgroundColor"),
					Wx::Colour->new($bc->{'r'}, $bc->{'g'}, $bc->{'b'}),
					wxDefaultPosition, wxDefaultSize,
				)
			);
			$RowSet->Add( Wx::StaticText->new($self, -1, "Text"), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
			my $fc = $InspPop->{"${order}${Insp}Colors"}->{'foreground'};
			$RowSet->Add( Wx::ColourPickerCtrl->new(
					$self, id("${order}${Insp}ForegroundColor"),
					Wx::Colour->new($fc->{'r'}, $fc->{'g'}, $fc->{'b'}),
					wxDefaultPosition, wxDefaultSize,
				)
			);
		}
	}

	my $useCB = Wx::CheckBox->new( $self, -1, 'Enable Inspiration Popper Binds (prefer largest)');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the Inspiration Popper Binds, (largest used first)'));
	$sizer->Add($useCB, 0, wxALL, 10);

	$sizer->Add($InspRows);

	my $useRevCB = Wx::CheckBox->new( $self, -1, 'Enable Reverse Inspiration Popper Binds (prefer smallest)');
	$useCB->SetToolTip(Wx::ToolTip->new('Check this to enable the Reverse Inspiration Popper Binds, (smallest used first)'));
	$sizer->Add($useRevCB, 0, wxALL, 10);

	$sizer->Add($RevInspRows);

	$self->SetSizerAndFit($sizer);

	return $self;
}

sub makebind {
	my $profile = $Profile::current;
	my $resetfile = $profile->{'resetfile'};
	my $InspPop = $profile->{'InspPop'};

	for my $Insp (sort keys %GameData::Inspirations) {

		my $forwardOrder = join '$$', map { "inspexecname $_" }         @{$GameData::Inspirations{$Insp}};
		my $reverseOrder = join '$$', map { "inspexecname $_" } reverse @{$GameData::Inspirations{$Insp}};

		if ($InspPop->{'Feedback'}) {
			$forwardOrder = cbChatColorOutput($InspPop->{"${Insp}Colors"})    . $Insp . '$$' . $forwardOrder;
			$reverseOrder = cbChatColorOutput($InspPop->{"Rev${Insp}Colors"}) . $Insp . '$$' . $reverseOrder;
		}

		cbWriteBind($resetfile, $InspPop->{"${Insp}Key"},    $forwardOrder) if $InspPop->{'Enable'};
		cbWriteBind($resetfile, $InspPop->{"Rev${Insp}Key"}, $reverseOrder) if $InspPop->{'Reverse'};
	}
}

sub findconflicts {
	my ($profile) = @_;
	my $InspPop = $profile->{'InspPop'};
	if ($InspPop->{'enable'}) {
		cbCheckConflict($InspPop,'acckey',"Accuracy Key");
		cbCheckConflict($InspPop,'hpkey',"Healing Key");
		cbCheckConflict($InspPop,'damkey',"Damage Key");
		cbCheckConflict($InspPop,'endkey',"Endurance Key");
		cbCheckConflict($InspPop,'defkey',"Defense Key");
		cbCheckConflict($InspPop,'bfkey',"Breakfree Key");
		cbCheckConflict($InspPop,'reskey',"Resistance Key");
	}
	if ($InspPop->{'reverse'}) {
		cbCheckConflict($InspPop,'racckey',"Reverse Accuracy Key");
		cbCheckConflict($InspPop,'rhpkey',"Reverse Healing Key");
		cbCheckConflict($InspPop,'rdamkey',"Reverse Damage Key");
		cbCheckConflict($InspPop,'rendkey',"Reverse Endurance Key");
		cbCheckConflict($InspPop,'rdefkey',"Reverse Defense Key");
		cbCheckConflict($InspPop,'rbfkey',"Reverse Breakfree Key");
		cbCheckConflict($InspPop,'rreskey',"Reverse Resistance Key");
	}
}

sub bindisused {
	my ($profile) = @_;
	return unless $profile->{'InspPop'};
	return $profile-{'InspPop'}->{'enable'} || $profile->{'InspPop'}->{'reverse'};
}

1;
