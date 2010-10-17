#!perl
use warnings;
use utf8;
use Encode;
use Benchmark qw(:all);
use Data::Visitor::Encode;
use Data::Recursive::Encode;
use Data::Rmap ();
use Deep::Encode qw/deep_utf8_decode/;
 
my $sample = sub { { key => [("これはサンプルです") x 300] } };
 
my $cmp = timethese(
    -1,
    {
        data_recursive => sub {
            my $input = $sample->();
            my ($s) = Data::Recursive::Encode->encode('utf8', $input);
        },
        data_recursive_inplace => sub {
            my $input = $sample->();
            Data::Recursive::Encode->inplace_encode('utf8', $input);
        },
        data_visitor => sub {
            my $input = $sample->();
            Data::Visitor::Encode->encode('utf8', $input);
        },
        data_rmap => sub {
            my $input = $sample->();
            Data::Rmap::rmap { $_ = Encode::encode_utf8($_) } $input;
        },
        deep_encode => sub {
            my $input = $sample->();
            Deep::Encode::deep_encode($input, 'utf8');
        },
    }
);
 
cmpthese $cmp;
