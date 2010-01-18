use inc::Module::Install;
name 'Data-Recursive-Encode';
all_from 'lib/Data/Recursive/Encode.pm';

# requires '';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests 'xt';
use_test_base;
auto_include;
WriteAll;
