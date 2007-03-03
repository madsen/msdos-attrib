#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
# Copyright 2007 Christopher J. Madsen
#
# Build.PL for MSDOS-Attrib
#---------------------------------------------------------------------

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
  module_name        => 'MSDOS::Attrib',
  license            => 'perl',
  dist_author        => 'Christopher J. Madsen <perl@cjmweb.net>',
  dist_version_from  => 'lib/MSDOS/Attrib.pm',
  requires => {
      'Test::More' => 0,
  },
  recommends => {
      'XSLoader'   => 0,
  },
  add_to_cleanup     => [ 'MSDOS-Attrib-*' ],
  create_makefile_pl => 'passthrough',
  dynamic_config     => 0,
);

$builder->create_build_script();
