#!perl
use warnings;
use utf8;
use Encode;
use Benchmark qw(:all);
use Data::Visitor::Encode;
use Data::Recursive::Encode;
use Data::Rmap ();
 
my $sample = sub { { key => [("これはサンプルです") x 3] } };
 
my $cmp = timethese(
    -1,
    {
        data_recursive => sub {
            my $sample = $sample->();
            my ($s) = Data::Recursive::Encode->encode_utf8($sample);
        },
        data_visitor => sub {
            my $sample = $sample->();
            Data::Visitor::Encode->encode('utf8', $sample);
        },
        data_rmap => sub {
            my $sample = $sample->();
            Data::Rmap::rmap { $_ = Encode::encode_utf8($_) } $sample;
        },
    }
);
 
cmpthese $cmp;
