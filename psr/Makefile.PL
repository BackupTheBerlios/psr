use strict;
use 5.00503;
use ExtUtils::MakeMaker;
use Config();

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	'NAME'           => 'Net::PSR',
	'VERSION'        => '0.32',
	'PREREQ_PM'      => {
		'Test::More'    => 0,
		'Config::Tiny'  => 0,
		'File::Spec'    => 0,
		'Net::AIM'      => 0,
	},
	'EXE_FILES'      => [ qw( bin/PSR.pl
	                          bin/PSR_play_deamon.pl
	                          bin/PSR_bgplay_deamon.pl
	                          bin/PSR_save_deamon.pl
	                          bin/PSR_speak_deamon.pl ) ],
	($] >= 5.005 ?    ## Add these new keywords supported since 5.005
	  (ABSTRACT_FROM => 'lib/Net/PSR.pm', # retrieve abstract from module
	   AUTHOR        => 'Josh I. Miller <jmiller@purifieddata.net>') : ()),
);

