# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################
use Test::More tests => 2;
#########################

eval {
    require Net::PSR;
};
is($@, '', 'loading module');

eval {
    import Net::PSR;
};
is($@, '', 'running import');


