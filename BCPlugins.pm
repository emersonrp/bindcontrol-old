#!/usr/bin/perl

package BCPlugins;
use Wx qw( wxVERTICAL wxSTAY_ON_TOP );

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
	my $self = shift;

	unless ($self->{'helpwindow'}) {
		my $helpwindow = Wx::MiniFrame->new(undef, -1, "$self->{'TabTitle'} Help");
		my $sizer = Wx::FlexGridSizer->new(0,1,0,0);
		my $st = Wx::StaticText->new( $helpwindow, -1, "love!");
		# my $st = Wx::StaticText->new( $helpwindow, -1, $self->HelpText() );
		$sizer->Add( $st, 0, wxALL );

		$helpwindow->SetSizer($sizer);

		$self->{'helpwindow'} = $helpwindow;
	}

	$self->{'helpwindow'}->Show(1);

	return $self->{'helpwindow'};
}

sub HelpText { qw|Help not currently implemented here.|; }

1;
