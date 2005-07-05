#!/usr/bin/perl

# this plays stuff out of the PSR queue.

use strict;
use Net::PSR;

&main;

sub main
{
	my $psr = Net::PSR->new();

	my $running = 1;
	$SIG{INT} = sub { $running = 0; };
	while ($running)
	{
		$psr->process_queue('play');
		sleep 1;
	}
}

