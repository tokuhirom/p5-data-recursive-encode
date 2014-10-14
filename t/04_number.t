use strict;
use warnings;
use Test::More;
use Data::Recursive::Encode;
use JSON;

my $data = { int => 1 };
$data = Data::Recursive::Encode->encode_utf8($data);
is encode_json($data), '{"int":1}';

done_testing;
