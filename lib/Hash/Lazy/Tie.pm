package Hash::Lazy::Tie;
use strict;
use warnings;
use Carp qw(confess);
use parent 'Tie::Hash';

use constant USAGE => 'my %h; tie %h, "Hash::Lazy::Tie", $builder, \%h;';

sub TIEHASH {
    my $class = shift;
    my $builder = shift;
    my $tied = shift;

    confess "The use of Hash::Lazy::Tie requires passing the hash variable that it's tying to. Usage: " . USAGE
        unless defined($tied);

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

    my $ret = $self->{builder}->($self->{tied}, $key);
    $self->{storage}{$key} = $ret unless exists $self->{storage}{$key};
    return $self->{storage}{$key};
}

1;
