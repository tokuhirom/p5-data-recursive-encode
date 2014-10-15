requires 'perl', '5.008001';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.59';
    requires 'JSON';
    requires 'Test::More', '0.94';
};
