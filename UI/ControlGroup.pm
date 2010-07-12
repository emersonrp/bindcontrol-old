#!/usr/bin/perl

use strict;
use feature 'switch';
use feature 'state';

package UI::ControlGroup;
use parent -norequire, "Wx::StaticBoxSizer";

use Wx qw(wxCB_READONLY wxDIRP_USE_TEXTCTRL);
use UI::Labels;
use Utility 'id';

use constant PADDING => 5;

sub new {
	my ($class, $parent, $name) = @_;

	my $self = $class->SUPER::new(Wx::StaticBox->new( $parent, -1, $name), Wx::wxVERTICAL);

	bless $self, $class;

	$self->InnerSizer = Wx::FlexGridSizer->new(0,2,PADDING, PADDING);
	$self->Add($self->InnerSizer);

	return $self;

}
sub InnerSizer : lvalue { state $InnerSizer; }

sub AddLabeledControl {
	my ($self, $p) = @_;

	my $sizer = $self->InnerSizer;

	my $type = $p->{'type'};
	my $parent = $p->{'parent'};
	my $module = $p->{'module'};
	my $value = $p->{'value'};
	my $contents = $p->{'contents'};
	my $tooltip = $p->{'tooltip'};
	my $callback = $p->{'callback'};


	my $text = Wx::StaticText->new($parent, -1, ($UI::Labels::Labels{$value} || $value) . ':');

	my $control;
	given ($type) {
		when (/keybutton/) {
			$control = Wx::Button->new( $parent, id($value), $module->{$value});
			Wx::Event::EVT_BUTTON( $parent, $control, sub { $self->KeyPickerDialog($p) } );
		}
		when (/combo/) {
			$control = Wx::ComboBox->new(
				$parent, id($value), $module->{$value},
				Wx::wxDefaultPosition, Wx::wxDefaultSize,
				$contents,
				Wx::wxCB_READONLY);
			Wx::Event::EVT_COMBOBOX( $parent, $control, $callback );
		}
		when (/text/) {
			$control = Wx::TextCtrl->new($parent, id($value), $module->{$value});
		}
		when (/checkbox/) {
			$control = Wx::CheckBox->new($parent, id($value), $UI::Labels::Labels{$value} || $value);
			$text->SetLabel('');
		}
		when (/dirpicker/) {
			$control = Wx::DirPickerCtrl->new(
				$parent, -1, $module->{$value}, $value, 
				Wx::wxDefaultPosition, Wx::wxDefaultSize,
				Wx::wxDIRP_USE_TEXTCTRL|Wx::wxALL,
			);
		}
	}
	$control->SetToolTip( Wx::ToolTip->new($tooltip)) if $tooltip;

	$sizer->Add( $text,    0, Wx::wxALIGN_RIGHT|Wx::wxALIGN_CENTER_VERTICAL);
	$sizer->Add( $control, 0, Wx::wxALL|Wx::wxEXPAND );
}

sub KeyPickerDialog {
	my ($self, $p) = @_;
	my $parent = $p->{'parent'};
	my $value = $p->{'value'};

	my $newKey = UI::KeyBindDialog::showWindow($parent, $value, $parent->{$value});

	# TODO -- check for conflicts
	# my $otherThingWithThatBind = checkConflicts($newKey);

	# update the associated profile var
	$parent->{$value} = $newKey;

	# re-label the button
	Wx::Window::FindWindowById(Utility::id($value))->SetLabel($newKey);
}

1;
