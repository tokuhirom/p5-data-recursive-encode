package Data::Recursive::Encode;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';
use Encode ();
use Carp ();
use Scalar::Util qw(blessed);

sub _apply {
    my $code = shift;

    do { use Data::Dumper; warn Dumper(\@_) } if $ENV{DEBUG};
    my @retval;
    for my $arg (@_) {
        my $class = ref $arg;
        my $val =
            !$class ? 
                $code->($arg) :
            blessed($arg) ?
                $arg : # through
            UNIVERSAL::isa($arg, 'ARRAY') ? 
                +[ _apply($code, @$arg) ] :
            UNIVERSAL::isa($arg, 'HASH')  ? 
                +{
                    map { $code->($_) => _apply($code, $arg->{$_}) }
                    keys %$arg
                } :
            UNIVERSAL::isa($arg, 'SCALAR') ? 
                \do{ _apply($code, $$arg) } :
            UNIVERSAL::isa($arg, 'GLOB')  ? 
                $arg : # through
            UNIVERSAL::isa($arg, 'CODE') ? 
                $arg : # through
            Carp::croak("I don't know how to apply to $class");
        push @retval, $val;
    }
    do { use Data::Dumper; warn Dumper(\@retval) } if $ENV{DEBUG};
    return @retval;
}

sub decode {
    my ($class, $encoding, $stuff) = @_;
    _apply(sub { Encode::decode $encoding, $_[0] }, $stuff);
}

sub encode {
    my ($class, $encoding, $stuff) = @_;
    _apply(sub { Encode::encode $encoding, $_[0] }, $stuff);
}

sub decode_utf8 {
    my ($class, @args) = @_;
    _apply(sub { Encode::decode_utf8($_[0]) }, @args);
}

sub encode_utf8 {
    my ($class, @args) = @_;
    _apply(sub { Encode::encode_utf8($_[0]) }, @args);
}

1;
__END__

=encoding utf8

=head1 NAME

Data::Recursive::Encode -

=head1 SYNOPSIS

  use Data::Recursive::Encode;

=head1 DESCRIPTION

Data::Recursive::Encode is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) 2009 Tokuhiro Matsuno.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
