#!/usr/bin/perl

package BCPlugins;
use Wx qw( :everything );

use parent -norequire, 'Wx::Panel';

use Layout;

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

1;
