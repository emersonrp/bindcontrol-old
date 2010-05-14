package BindsWindow;

use strict;
use Wx qw( wxHORIZONTAL wxEXPAND wxALL wxLB_SORT );
use Wx::Event qw( EVT_CHOICE EVT_LISTBOX );

use BCConstants;
use PowerSets;
use Profile;


sub NewProfilePanel {
	my ($self, $event) = @_;

	my $sizer = Wx::BoxSizer->new(wxHORIZONTAL);
	my $panel = Wx::Panel->new($self);

	$sizer->Add ($panel, 1, wxEXPAND | wxALL, 3);


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

	$self->SetSizer($sizer);
	$self->Layout();
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

1;
