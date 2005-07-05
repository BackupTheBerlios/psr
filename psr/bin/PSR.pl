#!/usr/bin/perl

use strict;
use Net::OSCAR qw(:standard);
use Net::PSR;

&main;

sub main
{
	my $psr = Net::PSR->new();

	$psr->signon() or die;

	$SIG{INT} = sub { $psr->stop(); };

	$psr->running(1);
	while($psr->running)
	{
		$psr->do_one_loop();
	}
}


