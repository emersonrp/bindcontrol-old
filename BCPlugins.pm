#!/usr/bin/perl

package BCPlugins;
use strict;
use Wx qw( :everything );

use parent -norequire, 'Wx::Panel';

use Utility;

my $Labels = Labels(); # TODO do we want a more general place for ID<->Label mapping?

sub new {
	my ($proto, $parent) = @_;
	my $class = ref $proto || $proto;
	my $self = $class->SUPER::new($parent);

	($self->{'TabTitle'} = ref $self) =~ s/BCPlugins:://;

	return $self;
}

sub help {
	my ($self, $event) = @_;

	unless ($self->{'HelpWindow'}) {
		my $HelpWindow = Wx::MiniFrame ->new( undef, -1, "$self->{'TabTitle'} Help",);
		my $BoxSizer   = Wx::BoxSizer  ->new( wxVERTICAL );
		my $HelpText   = Wx::StaticText->new( $HelpWindow, -1, $self->HelpText );

		$BoxSizer->Add( $HelpText, 0, wxALIGN_CENTER_VERTICAL, );

		$HelpWindow->SetSizer($BoxSizer);

		$self->{'HelpWindow'} = $HelpWindow;
	}

	$self->{'HelpWindow'}->Show(not $self->{'HelpWindow'}->IsShown);

	return $self->{'HelpWindow'};
}

sub HelpText { qq|Help not currently implemented here.|; }

sub addLabeledButton {
    my ($self, $sizer, $label, $value, $tooltip) = @_;


    my $button = Wx::Button->new($self, Utility::id($label), $value);
    $button->SetToolTip( Wx::ToolTip->new($tooltip)) if $tooltip;

    $sizer->Add( Wx::StaticText->new($self, -1, ($Labels->{$label} || $label)), 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL);
    $sizer->Add( $button, 0, wxEXPAND );
}




sub Labels { 
	return  {
		Left => 'Strafe Left',
		Right => 'Strafe Right',
		AutoRun => 'Auto Run',
		Follow => 'Follow Target',
		NonSoDMode => 'Non-SoD Mode',
		Toggle => 'SoD Mode Toggle',
		JumpMode => 'Toggle Jump Mode',
		SSMode => 'Toggle Super Speed Mode',
		FlyMode => 'Toggle Fly Mode',
		GFlyMode => 'Toggle Group Fly Mode',

		TPMode  => 'Teleport Bind',
		TPCombo => 'Teleport Combo Key',
		TPReset => 'Teleport Reset Key',

		TTPMode  => 'Team Teleport Bind',
		TTPCombo => 'Team Teleport Combo Key',
		TTPReset => 'Team Teleport Reset Key',

		TempMode => 'Toggle Temp Mode',

		NovaMode => 'Toggle Nova Form',
		DwarfMode => 'Toggle Dwarf Form',
		HumanMode => 'Human Form',
	};
}


1;
