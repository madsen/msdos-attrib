# $Id: Makefile.PL,v 1.1 1996/10/17 04:13:47 Madsen Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'OS2::Attrib',
    'VERSION_FROM' => 'Attrib.pm', # finds $VERSION
);
