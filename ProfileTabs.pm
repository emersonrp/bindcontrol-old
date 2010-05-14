package ProfileTabs;

use strict;
use Wx qw(wxVERTICAL wxHORIZONTAL wxDefaultSize wxDefaultPosition
		wxTAB_TRAVERSAL wxEXPAND wxALL wxLB_SORT);
use Wx::Event qw( EVT_CHOICE EVT_LISTBOX );

use BCConstants;
use PowerSets;
use Profile;


use base 'Wx::Notebook';

sub new {
	my ($class, $parentpanel) = @_;
print STDERR Data::Dumper::Dumper [@_];
	my $self = $class->SUPER::new($parentpanel);

	# General Panel:  arch / origin / primary / secondary / pools / epic
	my $GeneralPanel = $self->generalPanel();
	$self->AddPage($GeneralPanel, "General");

	# SoD setup
	my $SpeedOnDemandPanel = $self->sodPanel();
	$self->AddPage($SpeedOnDemandPanel, "Speed On Demand");

	# Util:  Inspiration, Team target
	my $UtilPanel = $self->utilPanel();
	$self->AddPage($UtilPanel, "Utility");

	# Chat
	my $SocialPanel = $self->socialPanel();
	$self->AddPage($SocialPanel, "Social and Chat");

	# Custom (man o man that's vague)
	my $CustomPanel = $self->customPanel();
	$self->AddPage($CustomPanel, "Custom Binds");

	# (If Appropriate) Mastermind henchman panel
	my $MastermindPanel = $self->mastermindPanel();
	$self->AddPage($MastermindPanel, "Mastermind Binds");

#	$self->SetSizer($sizer);
#	$self->Layout();

	return $self;
}


sub fillPickers {
	my ($self, $event) = @_;

	my $newArch = (($event && $event->GetString()) || $Profile::current->{'Archetype'});

	my $pPicker = Wx::Window::FindWindowById(PICKER_PRIMARY);
	$pPicker->Clear();
	for (keys %{$PowerSets::powersets->{$newArch}->{'Primary'}}) { $pPicker->Append($_); }
	$pPicker->SetStringSelection($Profile::current->{'Primary'});

	my $sPicker = Wx::Window::FindWindowById(PICKER_SECONDARY);
	$sPicker->Clear();
	for (keys %{$PowerSets::powersets->{$newArch}->{'Secondary'}}) { $sPicker->Append($_); }
	$sPicker->SetStringSelection($Profile::current->{'Secondary'});

}

sub generalPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);
 
my $a = $Profile::current->{'Archetype'} = $Profile::defaults->{'Archetype'};
my $p = $Profile::current->{'Primary'} = $Profile::defaults->{'Primary'};
my $s = $Profile::current->{'Secondary'} = $Profile::defaults->{'Secondary'};

	my $archPicker = Wx::ListBox->new(
		$panel, PICKER_ARCHETYPE,[10,10], [-1, -1],
		[sort keys %$PowerSets::powersets],
	);
	$archPicker->SetStringSelection($a);

 	my $primaryPicker = Wx::ListBox->new(
 		$panel, PICKER_PRIMARY,[120,10], [-1, -1],
 		[keys %{$PowerSets::powersets->{$a}->{'Primary'}}],
		wxLB_SORT,
 	);

 	my $secondaryPicker = Wx::ListBox->new(
 		$panel, PICKER_SECONDARY,[240,10], [-1, -1],
 		[keys %{$PowerSets::powersets->{$a}->{'Secondary'}}],
		wxLB_SORT,
 	);

	# EVT_CHOICE( $self, PICKER_ARCHETYPE, \&fillPickers );
	EVT_LISTBOX( $self, PICKER_ARCHETYPE, \&fillPickers );

	fillPickers();

	return $panel;

}


sub sodPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub utilPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub socialPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub customPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}


sub mastermindPanel {
	my $self = shift;

	my $panel = Wx::Panel->new($self, -1);

	return $panel;
}




1;
