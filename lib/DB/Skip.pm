package DB::Skip;

use strict;
use warnings;

{
    my $old_db;

    sub old_db {
        my ( $class, $ref ) = @_;
        $old_db = $ref if $ref;
        return $old_db;
    }
}

sub import {
    my ( $class, %opts ) = @_;

    $opts{$_} ||= [] for qw( pkgs subs );

    my @pkg_regex = grep { ref and ref eq "Regexp" } @{ $opts{pkgs} };
    my @sub_regex = grep { ref and ref eq "Regexp" } @{ $opts{subs} };

    my %pkg_skip = map { $_ => 1 } grep { !ref } @{ $opts{pkgs} };
    my %sub_skip = map { $_ => 1 } grep { !ref } @{ $opts{subs} };

    $class->_old_db( \&DB::DB ) if !$class->old_db;

    my $new_DB = sub {
        my $lvl = 0;
        while ( my ( $pkg ) = caller( $lvl++ ) ) {
            return if $pkg eq "DB" or $pkg =~ /^DB::/;
        }

        my ( $pkg ) = caller;
        return if $pkg_skip{$pkg};

        my ( undef, undef, undef, $sub ) = caller( 1 );
        return if $sub and $sub_skip{$sub};

        for my $pkg_re ( @pkg_regex ) {
            return if $pkg =~ $pkg_re;
        }

        for my $sub_re ( @sub_regex ) {
            return if $sub =~ $sub_re;
        }

        goto &{ $class->_old_db };
    };

    {
        no warnings 'redefine';
        *DB::DB = $new_DB;
    }

    return;
}

1;
