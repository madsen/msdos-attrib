# $Id: test.pl,v 0.1 1996/10/17 01:55:12 Madsen Exp $
#
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

BEGIN {
    @getTest = (
        'R____',
        '_H___',
        '__S__',
        '___A_',
        '____D',
        'R__A_',
    );

    $last_test_to_print = 1 + scalar @getTest;
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

system('cmd.exe', '/c', 'pretest.cmd');

my $testNum = 2;

foreach (@getTest) { testGet($_) }

sub testGet
{
    my $attrib = shift;

    my $get = getAttribs("$attrib.TST");
    if ($get eq $attrib) {
        print "ok $testNum\n";
    } else {
        print "Expected '$attrib', got '$get'\nnot ok $testNum\n";
    }
    ++$testNum;
}

# Local Variables:
# compile-command: "make test"
# End:
