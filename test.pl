# $Id: test.pl,v 1.3 1996/10/19 10:49:54 joseph Exp joseph $
# $Log: test.pl,v $
# Revision 1.3  1996/10/19 10:49:54  joseph
# oops, fixed a stupid bug in the test script
#
# Revision 1.2  1996/10/19 08:07:04  joseph
# now has a real test script, i hope
#
# Revision 1.1  1996/10/15 08:42:55  joseph
# Initial revision
#
#

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..11\n"; }
END {print "not ok 1\n" unless $loaded;}
use File::Cmp;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

use Carp;

$test_num = 2;

$test_dir = "$0-tmp.$$";
print "creating a test directory $test_dir\n";
mkdir $test_dir, 0700 or croak "couldn't create $test_dir: $!";

eval {
	print "creating some test files\n";
	srand();
	for ($i = 0; $i < 10000; $i++) {
		$test_blob .= pack 'S', rand 0xffff;
	}
	chdir $test_dir or croak "couldn't chdir to $test_dir: $!";

	open F, '>xx' or croak "couldn't create: $!";
	print F $test_blob;

	open F, '>xxcopy' or croak "couldn't create: $!";
	print F $test_blob;

	open F, '>xxshort' or croak "couldn't create: $!";
	print F substr $test_blob, 0, 19999;

	(substr $test_blob, 7654, 1) =~ tr/\0-\377/\01-\377\0/;
	open F, '>xx1byte' or croak "couldn't create: $!";
	print F $test_blob;

	(substr $test_blob, -1, 1) =~ tr/\0-\377/\01-\377\0/;
	open F, '>xx2byte' or croak "couldn't create: $!";
	print F $test_blob;
	close F;

	if (cmp_file('xx', 'xx') == 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (same file) ", $test_num++, "\n";
	}

	if (cmp_file('xx', 'xxcopy') == 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (copy of file) ", $test_num++, "\n";
	}

	if (cmp_file('xx', 'xxshort') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (truncated copy of file) ", $test_num++, "\n";
	}

	if (cmp_file('xxshort', 'xx') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (truncated copy of file) ", $test_num++, "\n";
	}

	if (cmp_file('xx', 'xxfrobizz') < 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (file doesn'xx exist)  ", $test_num++, "\n";
	}

	if (cmp_file('xxfrobizz', 'xx') < 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (file doesn'xx exist)  ", $test_num++, "\n";
	}

	if (cmp_file('xx', 'xx1byte') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (1 byte difference) ", $test_num++, "\n";
	}

	if (cmp_file('xx1byte', 'xx') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (1 byte difference) ", $test_num++, "\n";
	}

	if (cmp_file('xx1byte', 'xx2byte') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (1 byte at end) ", $test_num++, "\n";
	}

	if (cmp_file('xx2byte', 'xx1byte') > 0) {
		print "ok ", $test_num++, "\n";
	} else {
		print "NOT ok (1 byte at end) ", $test_num++, "\n";
	}
};

if ($@) {
	print "... something went wrong during the tests.\n";
}

print "tidying up ...\n";
unlink glob 'xx*';
chdir '..';
rmdir $test_dir;

print "... all done\n";

