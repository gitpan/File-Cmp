# $Id: Makefile.PL,v 1.1 1996/10/15 08:42:55 joseph Exp $
# $Log: Makefile.PL,v $
# Revision 1.1  1996/10/15 08:42:55  joseph
# Initial revision
#
#
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'File::Cmp',
    'VERSION_FROM' => 'Cmp.pm', # finds $VERSION
);
