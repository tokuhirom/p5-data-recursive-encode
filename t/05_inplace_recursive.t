use strict;
use warnings;
use Test::More;
use Data::Recursive::Encode;
use Encode;
use Scalar::Util qw/refaddr/;

# utility functions
sub U($) { decode_utf8($_[0]) }
sub u($) { encode_utf8($_[0]) }
sub E($) { decode('euc-jp', $_[0]) }
sub e($) { encode('euc-jp', $_[0]) }
sub eU($) { e(U($_[0])) }

# -------------------------------------------------------------------------

my $E = sub { Data::Recursive::Encode->inplace_encode_utf8(@_) };

my $data = {
    'foo' => { key => U('あいう'), qux => 42 }
};
$data->{bar} = $data->{foo};

Data::Recursive::Encode->inplace_encode_utf8($data);

is $data->{bar}->{qux}, 42;
is $data->{bar}->{key}, 'あいう';

$data->{foo}->{qux}++;
is $data->{bar}->{qux}, 43, 'cyclic refs';

ok !utf8::is_utf8($data->{foo}->{key});

done_testing;
