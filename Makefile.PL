# $Id: Makefile.PL,v 1.2 1996/10/17 16:19:37 Madsen Rel $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'OS2::Attrib',
    'VERSION_FROM' => 'Attrib.pm', # finds $VERSION
    dist	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz',
# This next line is just for my own use, you can comment it out if you want:
		    TO_UNIX => 'cjm_fixup $(DISTVNAME)' # Converts CRLF to LF
		},
);
