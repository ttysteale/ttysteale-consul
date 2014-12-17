#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Ttysteale::Consul' ) || print "Bail out!\n";
}

diag( "Testing Ttysteale::Consul $Ttysteale::Consul::VERSION, Perl $], $^X" );
