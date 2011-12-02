use strict;
use warnings;

use Test::InDistDir;

use Capture::Tiny 'capture';

use Test::More;

my @includes = map { "-I$_" } @INC;
my ( $out, $err, $res ) = capture {
    system( $^X, @includes, "-It/lib", "-d:Caller", "t/bin/example.pl" );
};

unlike $out, qr/main::skip/, "main::skip is skipped";
unlike $out, qr/Marp::skip/, "Marp::skip is skipped";
unlike $out, qr/Moop::skip/, "Moop::skip is skipped";
like $out, qr/main::debug/, "main::debug is not skipped";
is $err, "", "no errors";
is $res, undef, "script didn't crash";

done_testing;
