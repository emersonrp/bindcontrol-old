# UI / logic for the 'general' panel
package ProfileTabs::General;
use parent "ProfileTabs::ProfileTab";

use strict;
use Wx qw( :everything );
use Wx::Event qw( :everything );

use GameData;
use Profile;

use Utility qw(id);


sub new {
	my ($class, $parent) = @_;

	my $self = $class->SUPER::new($parent);

	my $profile = $Profile::current;

	my $general = $profile->{'General'};

	my $a = $general->{'Archetype'};
	my $o = $general->{'Origin'};
	my $p = $general->{'Primary'};
	my $s = $general->{'Secondary'};

	my $topSizer = Wx::FlexGridSizer->new(0,2,5,5);

	# Name
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Name:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	my $tc = Wx::TextCtrl->new( $self, id('PROFILE_NAMETEXT'), "",);
	# TODO -- suss out what we want the min size to be, and set it someplace sane.
	$tc->SetMinSize([300,-1]);
	$topSizer->Add( $tc, 0, wxALL,) ;

	# Archetype
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Archetype:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, id('PICKER_ARCHETYPE'), '',
			wxDefaultPosition, wxDefaultSize,
			[sort keys %$GameData::Archetypes],
			wxCB_READONLY,
		), 0, wxALL,);

	# Origin
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Origin:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,); 
	$topSizer->Add( Wx::BitmapComboBox->new(
			$self, id('PICKER_ORIGIN'), '',
			wxDefaultPosition, wxDefaultSize,
			[@GameData::Origins],
			wxCB_READONLY,
		), 0, wxALL,);

	# Primary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Primary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_PRIMARY'), '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Primary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	# Secondary
	$topSizer->Add( Wx::StaticText->new( $self, -1, "Secondary Powerset:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
 	$topSizer->Add( Wx::BitmapComboBox->new(
 			$self, id('PICKER_SECONDARY'), '',
			wxDefaultPosition, wxDefaultSize,
 			[sort keys %{$GameData::PowerSets->{$a}->{'Secondary'}}],
			wxCB_READONLY,
 		), 0, wxALL,);

	$topSizer->Add( Wx::StaticText->new( $self, -1, "Binds Directory:"), 0, wxALIGN_CENTER_VERTICAL|wxALIGN_RIGHT,);
	$topSizer->Add( Wx::DirPickerCtrl->new(
			$self, -1, $general->{'BindsDir'}, 
			'Select Binds Directory',
			wxDefaultPosition, wxDefaultSize,
			wxDIRP_USE_TEXTCTRL|wxALL,
		), 0, wxALL|wxEXPAND,);

	$self->addLabeledButton($topSizer, 'Reset Key', '', 'This key is used by certain modules to reset binds to a sane state.');

	$topSizer->Add ( Wx::CheckBox->new($self, id('Enable Reset Feedback'), 'Enable Reset Feedback'), 0, wxALL);
	$topSizer->AddSpacer(5);


	$topSizer->Add( Wx::Button->new( $self, id('Write Binds Button'), 'Write Binds!' ), 0, wxALL|wxEXPAND);

	EVT_BUTTON( $self, id('Write Binds Button'), \&BindFile::WriteBindFiles );


	$self->SetSizer($topSizer);

	EVT_COMBOBOX( $self, id('PICKER_ARCHETYPE'), \&Profile::pickArchetype );
	EVT_COMBOBOX( $self, id('PICKER_ORIGIN'),    \&Profile::pickOrigin );
	EVT_COMBOBOX( $self, id('PICKER_PRIMARY'),   \&Profile::pickPrimaryPowerSet );
	EVT_COMBOBOX( $self, id('PICKER_SECONDARY'), \&Profile::pickSecondaryPowerSet );

	$self->{'TabTitle'} = 'General';

	return $self;

}

1;
