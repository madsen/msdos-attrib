#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
# Copyright 2007 Christopher J. Madsen
#
# Build.PL for MSDOS-Attrib
#---------------------------------------------------------------------

use strict;
#use warnings;         # Wasn't core until 5.6.0

unless ($^O eq "MSWin32" || $^O eq "cygwin" || $^O eq 'os2') {
  die "OS unsupported\n";
}

use Module::Build;
eval 'use Module::Build::DistVersion;';
my $class = ($@ ? Module::Build->subclass(code => q{
    sub ACTION_distdir {
      print STDERR <<"END";
\a\a\a\n
This module uses Module::Build::DistVersion to automatically copy
version numbers to the appropriate places.  You might want to install
that and re-run Build.PL if you intend to create a distribution.
\n
END
      (shift @_)->SUPER::ACTION_distdir(@_);
    } })
             : 'Module::Build::DistVersion'); # if we found it

my $builder = $class->new(
  module_name        => 'MSDOS::Attrib',
  license            => 'perl',
  dist_author        => 'Christopher J. Madsen <perl@cjmweb.net>',
  dist_version_from  => 'lib/MSDOS/Attrib.pm',
  requires => {
      'perl'       => '5.005',
  },
  recommends => {
      'XSLoader'   => 0,
  },
  build_requires => {
      'File::Spec'    => 0,
      'Module::Build' => 0.21,
      'Test::More'    => 0,
  },
  create_makefile_pl => 'passthrough',
  dynamic_config     => 0,
  meta_merge         => { no_index  => { directory => [ 'tools' ] }},
);

$builder->create_build_script();
