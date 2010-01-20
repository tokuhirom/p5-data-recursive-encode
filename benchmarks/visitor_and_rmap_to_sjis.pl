#!perl
use warnings;
use utf8;
use Encode;
use Benchmark qw(:all);
use Data::Visitor::Encode;
use Data::Recursive::Encode;
use Data::Rmap ();
 
my $sample = sub {
    return { key => [("これはサンプルです") x 3] }
};

 
my $cmp = timethese(
    -1,
    {
        data_recursive => sub {
            my $sample = $sample->();
            my ($s) = Data::Recursive::Encode->encode('Shift_JIS', $sample);
        },
        data_visitor => sub {
            my $sample = $sample->();
            Data::Visitor::Encode->encode('Shift_JIS', $sample);
        },
        data_rmap => sub {
            my $sample = $sample->();
            Data::Rmap::rmap { $_ = Encode::encode('Shift_JIS', $_) } $sample;
        },
    }
);
 
cmpthese $cmp;
