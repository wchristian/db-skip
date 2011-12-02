use strict;
use warnings;

use Test::InDistDir;

use Capture::Tiny 'capture';

use Test::More;

my @includes = map { "-I$_" } @INC;
my ( $out, $err, $res ) = capture {
    system( $^X, @includes, "-It/lib", "-d:Caller", "t/bin/example.pl" );
};

unlike $out, qr/main::meep/, "main::meep is skipped";
unlike $out, qr/Marp::meep/, "Marp::meep is skipped";
unlike $out, qr/Moop::meep/, "Moop::meep is skipped";
like $out, qr/main::marp/, "main::marp is not skipped";
is $err, "", "no errors";
is $res, undef, "script didn't crash";

done_testing;
