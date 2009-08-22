package Hash::Lazy::Tie;
use strict;
use warnings;
use Carp qw(confess);
use parent 'Tie::Hash';
use self;

use constant USAGE => 'my %h; tie %h, "Hash::Lazy::Tie", $builder, \%h;';

sub TIEHASH {
    my ($builder, $tied) = @args;

    confess "The use of Hash::Lazy::Tie requires passing the hash variable that it's tying to. Usage: " . USAGE
        unless defined($tied);

    return bless {
        builder => $builder,
        tied     => $tied,
        storage  => {}
    }, $self;
}

sub STORE {
    my ($key, $value) = @args;
    $self->{storage}{$key} = $value;
}

sub FETCH {
    my ($key) = @args;

    return $self->{storage}{$key} if exists $self->{storage}{$key};

    my $ret = $self->{builder}->($self->{tied}, $key);
    $self->{storage}{$key} = $ret unless exists $self->{storage}{$key};
    return $self->{storage}{$key};
}

sub DELETE {
    my ($key) = @args;

    delete $self->{storage}{$key};
}

sub CLEAR {
    for my $key (keys %{$self->{storage}}) {
        delete $self->{storage}{$key};
    }
}

1;
