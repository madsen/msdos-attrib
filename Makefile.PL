# $Id: Makefile.PL,v 2.0 1997/09/13 20:41:56 Madsen Rel $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	   => 'MSDOS::Attrib',
    'VERSION_FROM' => 'Attrib.pm', # finds $VERSION
    dist	   => {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
);
