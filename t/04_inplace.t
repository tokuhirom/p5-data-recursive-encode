use strict;
use warnings;
use Test::More;
use Data::Recursive::Encode;
use Encode;

# utility functions
sub U($) { decode_utf8($_[0]) }
sub u($) { encode_utf8($_[0]) }
sub E($) { decode('euc-jp', $_[0]) }
sub e($) { encode('euc-jp', $_[0]) }
sub eU($) { e(U($_[0])) }

# -------------------------------------------------------------------------

our $CONVERTER;

sub check {
    my ($stuff, $expected, $msg) = @_;
    $CONVERTER->($stuff);
    is_deeply($stuff, $expected, $msg);
}

subtest "decode_utf8" => sub {
    local $CONVERTER = sub { Data::Recursive::Encode->inplace_decode_utf8(@_) };

    check(undef, undef, 'undef');
    check('あいう', U('あいう'), 'scalar');
    check(\'あいう', \U('あいう'), 'scalarref');
    check(\undef, \undef, 'scalarref');
    check(['あいう'], [U('あいう')], 'arrayref');
    check({'あいう' => 'えお'}, {U('あいう') => U('えお')}, 'hashref');
    check(['あいう', undef], [U('あいう'), undef], 'undef');
    check(['あいう', \*ok], [U('あいう'), \*ok], 'globref');
    check(['あいう', \&ok], [U('あいう'), \&ok], 'coderef');
    check([\\'あいう'], [\\U('あいう')], 'ref to ref');
    check(\\'あいう', \\U('あいう'), 'ref to ref');

    {
        my $code = sub { };
        check(
            [
                'あいう', $code,
                bless( ['おや'], 'Foo' )
            ],
            [ U('あいう'), $code, bless( ['おや'], 'Foo' ) ],
            'coderef,blessed'
        );
    }
    done_testing;
};

# -------------------------------------------------------------------------

subtest "encode_utf8" => sub {
    local $CONVERTER = sub { Data::Recursive::Encode->inplace_encode_utf8(@_) };

    check(U('あいう'), 'あいう', 'scalar');
    check(\(U 'あいう'), \('あいう'), 'scalarref');
    check([U('あいう')], ['あいう'], 'arrayref');
    check({U('あいう') , U('えお')}, {'あいう' =>  'えお'}, 'hashref');

    {
        my $code = sub { };
        check(
            [
                U('あいう'), $code,
                bless( [U('おや')], 'Foo' )
            ],
            [ 'あいう', $code, bless( [U('おや')], 'Foo' ) ],
            'coderef,blessed'
        );
    }
    done_testing;
};

# -------------------------------------------------------------------------

subtest "decode" => sub {
    local $CONVERTER = sub { Data::Recursive::Encode->inplace_decode('euc-jp', @_) };

    check(eU('あいう'), U('あいう'), 'scalar');
    check(\(eU('あいう')), \(U('あいう')), 'scalarref');
    check([eU('あいう')], [U('あいう')], 'arrayref');
    check({eU('あいう') => eU('えお')}, {U('あいう'), U('えお')}, 'hashref');

    {
        my $code = sub { };
        check(
            [
                eU('あいう'), $code,
                bless( [eU('おや')], 'Foo' )
            ],
            [ U('あいう'), $code, bless( [eU('おや')], 'Foo' ) ],
            'coderef,blessed'
        );
    }
    done_testing;
};

# -------------------------------------------------------------------------

subtest "encode" => sub {
    local $CONVERTER = sub { Data::Recursive::Encode->inplace_encode('euc-jp', @_) };

    check(U('あいう'), eU('あいう'), 'scalar');
    check(\(U 'あいう'), \(eU('あいう')), 'scalarref');
    check([U 'あいう'], [eU('あいう')], 'arrayref');
    check({U('あいう') , U('えお')}, {eU('あいう'),  eU('えお')}, 'hashref');

    {
        my $code = sub { };
        check(
            [
                U('あいう'), $code,
                bless( [U('おや')], 'Foo' )
            ],
            [ eU('あいう'), $code, bless( [U('おや')], 'Foo' ) ],
            'coderef,blessed'
        );
    }
    done_testing;
};

# -------------------------------------------------------------------------

subtest "from_to" => sub {
    my $stuff = e(U('あいう'));
    Data::Recursive::Encode->inplace_from_to($stuff, 'euc-jp', 'utf-8');
    ok !utf8::is_utf8($stuff), 'not flagged';
    is $stuff, 'あいう';

    done_testing;
};

done_testing;
