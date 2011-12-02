use strict;
use warnings;

use DB::Skip pkgs => [ qw( Marp ), qr/^Mo/ ], subs => [qw( main::meep )];

my $meep = meep();
print $meep;
$meep = Marp::meep();
print $meep;
$meep = Moop::meep();
print $meep;
$meep = Moop::meep();
print $meep;
$meep = marp();
print $meep;
exit;

sub meep {
    return 1;
}

sub marp {
    return 4;
}

package Marp;

sub meep {
    return 2;
}

package Moop;

sub meep {
    return 3;
}
