package Hash::Lazy::Tie;
use strict;
use warnings;

use parent 'Tie::Hash';

sub TIEHASH {
    my $class = shift;
    my $builder = shift;
    my $tied = shift;

    return bless {
        builder => $builder,
        tied     => $tied,
        storage  => {}
    }, __PACKAGE__;
}

sub STORE {
    my $self = shift;
    my $key = shift;
    my $value = shift;
    $self->{storage}{$key} = $value;
}

sub FETCH {
    my $self = shift;
    my $key = shift;

    return $self->{storage}{$key} if exists $self->{storage}{$key};

    $self->{builder}->($self->{tied}, $key);
    return $self->{storage}{$key};
}

1;
