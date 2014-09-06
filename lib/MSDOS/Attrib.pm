#---------------------------------------------------------------------
package MSDOS::Attrib;
#
# Copyright 1996,2008 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 13 Mar 1996
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Get or set MS-DOS file attributes
#           under OS/2 or Win32
#---------------------------------------------------------------------

use 5.005;
use strict;
use Carp;
#use warnings;         # Wasn't core until 5.6.0
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK @constants);

BEGIN
{
  $VERSION = '1.06';

  require Exporter;

  @constants = qw(
      FILE_READONLY FILE_HIDDEN FILE_SYSTEM FILE_ARCHIVED FILE_DIRECTORY
      FILE_CHANGEABLE
  );

  @ISA = qw(Exporter);
  @EXPORT = ();
  @EXPORT_OK = (qw(get_attribs set_attribs), @constants);

  #-------------------------------------------------------------------
  # Use XSLoader if available, otherwise DynaLoader:

  eval {
    require XSLoader;
    XSLoader::load('MSDOS::Attrib', $VERSION);
    1;
  } or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    bootstrap MSDOS::Attrib $VERSION;
  };

  #-------------------------------------------------------------------
  # Generate constant functions:

  foreach my $constname (@constants) {
    my $val = constant($constname);
    die "Our DLL does not define $constname" if $! != 0;
    eval "sub $constname () { $val } 1" or die;
  } # end foreach @constants

} # end BEGIN bootstrap

#---------------------------------------------------------------------
sub set_attribs ($@)
{
    my $attribs = shift;
    my $set = 0;
    my $clear = 0;

    for ($attribs) {
        if (/[-+]/) {
            $clear |= FILE_READONLY if /-[a-z_]*R/i;
            $clear |= FILE_HIDDEN   if /-[a-z_]*H/i;
            $clear |= FILE_SYSTEM   if /-[a-z_]*S/i;
            $clear |= FILE_ARCHIVED if /-[a-z_]*A/i;
        } else {
            $clear = FILE_CHANGEABLE; # Clear all attributes
            $_ = "+$_";                # except those specified
        }
        $set |= FILE_READONLY if /\+[a-z_]*R/i;
        $set |= FILE_HIDDEN   if /\+[a-z_]*H/i;
        $set |= FILE_SYSTEM   if /\+[a-z_]*S/i;
        $set |= FILE_ARCHIVED if /\+[a-z_]*A/i;
    } # end for $attribs

    carp("No change specified") if $clear == 0 and $set == 0;

    my $changed = 0;
    foreach (@_) { _set_attribs($_,$clear,$set) or last; ++$changed }
    $changed;
} # end set_attribs

1;
__END__

=head1 SYNOPSIS

  use MSDOS::Attrib qw(get_attribs set_attribs);
  $attribs = get_attribs($path);
  set_attribs($attribs, $path1, $path2, ...);

=head1 DESCRIPTION

MSDOS::Attrib provides access to MS-DOS file attributes.  While the
read-only attribute can be handled by C<chmod> and C<stat>, the
hidden, system, and archive attributes cannot.

=over 4

=item $attribs = get_attribs($path)

Returns the attributes of C<$path>, or the empty string if C<$path>
does not exist.  Attributes are returned as a five-character string in
this format: "RHSAD".  Each letter is replaced by an underscore (C<_>)
if the file does not have the corresponding attribute.  (This is the
same format as a 4DOS directory listing.)  The attributes are:

  R  The file is read-only (not writable)
  H  The file is hidden (does not appear in directory listings)
  S  The file is a system file (does not appear in directory listings)
  A  The file needs to be archived (it has changed since last backup)
  D  The file is a directory

=item $count = set_attribs($attribs, $path1, [$path2, ...])

Sets the attributes of C<$path1>, C<$path2>, etc.  You can either
specify the complete set of attributes, or add and subtract attributes
by using C<+> and C<->.  The case and order of the attributes is not
important.  For example, '-s+ra' will remove the system attribute and
add the read-only and archive attributes.  You should not use
whitespace between attributes, although underscores are OK.  See
C<get_attribs> for an explanation of the attribute values.  You cannot
change the directory attribute; if you specify it, it is ignored.
Returns the number of files successfully changed.

=back


=head1 SEE ALSO

The L<OS2::ExtAttr> module provides access to extended attributes under OS/2.

The L<Win32::FileSecurity> module provides access to Discretionary
Access Control Lists under Windows NT.

The L<Win32::File> module provides similar functionality to
MSDOS::Attrib, but with a different (and in my opinion clunkier)
interface.

=for Pod::Coverage
FILE_.*
constant

=cut
