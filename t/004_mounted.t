#!/usr/bin/perl


use Test::More;
use Test::Virtual::Filesystem;


if( !$ENV{PERLSSH_TEST_MOUNTED} ){
	plan tests => 1;

	print STDERR "\n";
	print STDERR "###########################################################################\n";
	print STDERR "# This script performs tests against a live mounted filesystem.           #\n";
	print STDERR "#                                                                         #\n";
	print STDERR "# To enable this test, set the environment variable PERLSSH_TEST_MOUNTED  #\n";
	print STDERR "# to a local path which is a remotely mounted filesys and a subdir        #\n";
	print STDERR "# where it is okay to create a testdir. For example:                      #\n";
	print STDERR "# make test PERLSSH_TEST_MOUNTED=/path/to/mountpoint/emptydir             #\n";
	print STDERR "###########################################################################\n";

	ok( 1, "skipping" );
}else {
	plan tests => Test::Virtual::Filesystem->expected_tests();

	die "Test path '$ENV{PERLSSH_TEST_MOUNTED}' is not a dir" if !-d $ENV{PERLSSH_TEST_MOUNTED};

	my $dir = $ENV{PERLSSH_TEST_MOUNTED} .'/test-perlsshfs-'.time();
	print STDERR "Testing in dir '$dir'\n";
	mkdir($dir) or die "Could not make test dir '$dir': $!";

	my $tvf = Test::Virtual::Filesystem->new({ mountdir => $dir });

	$tvf->enable_test_xattr(1);
	$tvf->enable_test_time(1);
	$tvf->enable_test_atime(1);
	$tvf->enable_test_mtime(1);
	$tvf->enable_test_ctime(1);

	$tvf->enable_test_chown(0);
	$tvf->enable_test_permissions(0);
	$tvf->enable_test_special(0);
	$tvf->enable_test_nlink(0);
	$tvf->enable_test_hardlink(0);

	$tvf->runtests;
}
