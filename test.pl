# $Id: test.pl,v 0.2 1996/10/17 04:24:05 Madsen Exp $
#
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

BEGIN {
    @tests = (
        [ '',      '____' ],
        [ '+r',    'R___' ],
        [ '-r+h',  '_H__' ],
        [ '+S-H',  '__S_' ],
        [ '-s +A', '___A' ],    # Spaces are OK between groups
        [ '+R',    'R__A' ],
        [ 'H_S',   '_HS_' ],    # Underscores are OK,
        [ 'h sar', '_H__' ],    # but don't use spaces in attribute list
        [ 'ar',    'R__A' ],
        [ '-ra',   '____' ]
    );

    $last_test_to_print = 3 + 2 * scalar @tests;
}

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..$last_test_to_print\n"; }
END {print "not ok 1\n" unless $loaded;}
use OS2::Attrib qw(getAttribs setAttribs);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $failed  = 0;
my $testNum = 2;

my $testfile = 'DELETE.ME';
unlink $testfile if -e $testfile;

open(OUT,">$testfile") or die "Unable to create $testfile";
close OUT;
runTests($testfile, '_');       # Run tests on plain file
unlink $testfile;

mkdir($testfile, 0666) or die "Unable to create $testfile";
runTests($testfile, 'D');       # Run tests on directory
rmdir $testfile;

# Make sure it fails for nonexistent path:
if (getAttribs($testfile) || not $!) {
    print "not ok $testNum\n";
    ++$failed;
} else {
    $! = 0;
    print "ok $testNum\n";
}
++$testNum;

if (setAttribs('',$testfile) || not $!) {
    print "not ok $testNum\n";
    ++$failed;
} else {
    $! = 0;
    print "ok $testNum\n";
}

if ($failed) { print "Failed $failed tests.\a\n" }
else         { print "Passed.\n"                 }

exit $failed;

sub runTests
{
    my ($testfile, $type) = @_;

    foreach (@tests) {
        my $get;
        $get = getAttribs($testfile) if setAttribs($$_[0], $testfile);

        if ($get eq "$$_[1]$type") {
            print "ok $testNum\n";
        } else {
            print "Expected '$$_[1]$type', got '$get'\nnot ok $testNum\n";
            ++$failed;
        }
        ++$testNum;
    }
} # end runTests

# Local Variables:
# compile-command: "make test"
# End:
