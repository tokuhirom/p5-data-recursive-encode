use inc::Module::Install;
name 'Data-Recursive-Encode';
all_from 'lib/Data/Recursive/Encode.pm';

test_requires 'Test::More' => 0.94; # subtests()

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
author_tests 'xt';

WriteAll;
