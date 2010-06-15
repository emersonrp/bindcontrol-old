#!/usr/bin/perl

package BCPlugins;
use Wx qw( :everything);

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
print STDERR Data::Dumper::Dumper $event;
	unless ($self->{'helpwindow'}) {
		my $helpwindow = Wx::MiniFrame->new(
				undef, -1,
				"$self->{'TabTitle'} Help",
				wxDefaultPosition, # TODO 'under mouse' when we do hover
				wxDefaultSize,
		);
		my $sizer = Wx::BoxSizer->new(wxVERTICAL);
		my $st = Wx::StaticText->new( $helpwindow, -1, $self->HelpText );
		$sizer->Add( $st, 0, wxALIGN_CENTER_VERTICAL, );

		$helpwindow->SetSizer($sizer);

		$self->{'helpwindow'} = $helpwindow;
	}

	$self->{'helpwindow'}->Show(1);

	return $self->{'helpwindow'};
}

sub HelpText { qq|Help not currently implemented here.|; }

1;
