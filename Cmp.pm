# $Id: Cmp.pm,v 1.7 1996/10/19 10:50:34 joseph Exp joseph $
# $Log: Cmp.pm,v $
# Revision 1.7  1996/10/19 10:50:34  joseph
# ver 0.03
#
# Revision 1.6  1996/10/19 08:21:35  joseph
# oops, put the open in the wrong spot ... don't want to return
# without closing the files!
#
# Revision 1.5  1996/10/19 08:10:30  joseph
# duplicate version number removed
# (how'd it get there???)
#
# Revision 1.4  1996/10/19 08:08:35  joseph
# v0.02
#
# Revision 1.3  1996/10/19 08:05:48  joseph
# reordered some of the tests so that file not found returns -1
# like it oughta
#
# Revision 1.2  1996/10/15 08:50:21  joseph
# fixed HEAD of doc
#
# Revision 1.1  1996/10/15 08:42:55  joseph
# Initial revision
#
#
package File::Cmp;
require 5.002;
require Exporter;

use strict;
use vars qw($VERSION @ISA @EXPORT
			$unixish);

@ISA = qw(Exporter);
@EXPORT = qw(cmp_file);
$VERSION = '0.03';

BEGIN {
	require Config;
	# if blah blah figure out some way to identify systems with inodes
	$unixish = 1;
}

sub cmp_file {
	my ($file1, $file2) = @_;
	local(*FH1, *FH2);

	if ($unixish) {
		(my ($dev1, $inode1, $size1) = (stat $file1)[0, 1, 7]) or return -1;
		(my ($dev2, $inode2, $size2) = (stat $file2)[0, 1, 7]) or return -1;
		return 1 if $size1 != $size2;
		return 0 if $dev1 == $dev2 and $inode1 == $inode2;
	} else {
		return -1 if !-e $file1 or !-e $file2;
		return 0 if $file1 eq $file2;
		return 1 if -s FH1 != -s FH2;
	}

	open FH1, $file1 or return -1;
	open FH2, $file2 or close(FH1), return -1;

	my $chunk = 4096;
	my ($bytes, $buf1, $buf2, $diff);
	CHUNK: while ($bytes = sysread FH1, $buf1, $chunk) {
		sysread FH2, $buf2, $chunk;
		$diff++, last CHUNK if $buf1 ne $buf2;
	}

	close FH1;
	close FH2;
	$diff;
}

1;
__END__

=head1 NAME

File::Cmp - compare files

=head1 SYNOPSIS

  use File::Cmp;

  $status = cmp_file "filename1", "filename2";

=head1 DESCRIPTION

cmp_file() compares the contents of two files.  If they are identical
cmp_file() return a value of 0.  Otherwise it returns a positive nonzero
value.

If one of the two files cannot be opened, cmp_file() returns -1.

=head1 BUGS

cmp_file() checks to see if files have identical filenames, but maybe 
it should also check inode numbers?

It might be nice to have a version that would return the location of
the first difference found.

=head1 AUTHOR

Joseph N. Hall, joseph@5sigma.com

=cut

