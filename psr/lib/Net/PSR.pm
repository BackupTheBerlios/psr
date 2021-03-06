#!/usr/bin/perl

######################################################################
#### documentation {{{1

=head1 NAME

Net::PSR - Pimp Sound Robot

=head1 SYNOPSIS

Edit PSR.ini and configure to suit your installation.

    sh -c "PSR.pl" &
    sh -c "PSR_play_deamon.pl" &
    sh -c "PSR_bgplay_deamon.pl" &
    sh -c "PSR_speak_deamon.pl" &
    sh -c "PSR_save_deamon.pl" &

Send an IM to your PSR user containing only the text "/help" or "\help".

=head1 ABSTRACT

PSR is a sound playing bot. It can connect to various chat/IM networks, and also has a web front end in the works. Clients can send it commands via any chat/IM client, and it will run them. It's ideally suited for a small room full of office workers, where each can play serious of sound effects off a central PSR.

It accepts commands such as:

/play bushism1.wav ndynamite_idiot.wav

...which would play those sound clips in order, which can be a lot of fun for everyone within earshot of the PSR :-)

It can also speak any text you send it, ans has some rudimentary file management commands built in as well.

Work has also begun on tying it into icecast, so that the PSR sounds can be streamed to anyone anywhere.

=head1 INSTALLATION

Installation is by standard perl Makefile.PL. You can tell it where you want it to install the files via command line options. See perldoc ExtUtils::MakeMaker for details.

By default, Net::PSR.pm is installed in your perl site libs directory; PSR.ini abbreviations config files are stored under the "PSR" directory in your perl site libs; the programs ( PSR.pl, PSR_play_deamon.pl, PSR_bgplay_deamon.pl, PSR_save_deamon.pl, PSR_speak_deamon.pl ) are installed to /usr/local/bin; documentation is installed to  your system "man" directory.

The PSR.ini can be overridden by creating a ".PSR.ini" in the home directory of the user running PSR.pl.

  perl Makefile.PL
  make
  make test
  make install

Requirements (all file/directory locations are configurable via the PSR.ini file):

=over 4

=item *
An aol instant messanger(r) user name and password to be used by the PSR.

=item *
Edit the PSR.ini file to suit your needs.

=item *
Read access to files within the "sounds" directory.

=item *
Write access to the "sounds" directory itself (for /save capability).

=item *
Read access to files within the "system_sounds" directory.

=item *
Write access to the "log_file" (if enabled).

=item *
Write access to each of the queue directories.

=back

=head1 CONFIGURATION

The "abbreviations" file is used by the PSR's text to speach engine. It will expand any abbreviations listed into their full length words (or whatever you want). You could also use this as a rudimentary way to block swear words or whatever. The format of this file should be self explanitory.

The PSR.ini file controls the configuration of the PSR.

=head2 PSR.ini [account] section

These settings are used to connect to the AOL Instant Messenger network.

=over 4

=item * name

AOL Instant Messenger user name to be used by the PSR.

=item * password

AOL Instant Messenger user name to be used by the PSR.

=item * server

AOL Instant Messenger login server.

=item * port

AOL Instant Messenger login server port.

=back

=head2 PSR.ini [authed_users] section

List of users allowed to access your PSR installation, because you probably don't want the whole world to be able to play sounds in your office.

Each entry should have the username in all lower case, no spaces, on the left, and the value set to "1". eg:

    my7337username76=1

=head2 PSR.ini [settings] section

This section configures how the PSR will opperate, and where all its files will be stored and such.

=over 4

=item * abbr_file

Full path to file containing a List of abbreviations to expand for text to speach stuff.

=item * unmute_program

Command to run to unmute the sound sub system.

Default: /bin/aumix-minimal -v 50

=item * mute_program

Command to run to mute the sound sub system.

Default: /bin/aumix-minimal -v 0

=item * festival

Text to be spoken (text to speach) will be piped to this command/program.

Default: /usr/bin/festival -b --tts

=item * mplayer

Command to run to play a sound file (full path to sound file will be appended to the end of this command line).

Default: /usr/local/bin/mplayer -quiet -really-quiet

=item * fetcher

Command to run to fetch a file from a URL (URL will be appened to the end of this command line).

Default: /usr/bin/wget -U PimpSoundRobot -q -O

=item * queue_dir

Directory where queue files will be written. Must be writable by the PSR user.

=item * sounds_dir

Directory where you want sounds stored. Must be writable by the PSR user for /save capability, but read only files can be placed here if desired.

=item * log_file

File name to write log of commands. Must be writable by the PSR user if "enable_logging" is turned on.

=item * enable_logging

Boolean value, whether or not you want to log all command sent to the PSR.

=item * send_command_confirmation_messages

Boolean value, whether or not to send confirmation messages back once actions have been taken (eg. after playing requested sound files).

=item * send_command_receipt_messages

Boolean value, whether or not to send acknowledgement that command was recieved and is good, and is going to be processed (ex. File queued for playback).

=item * system_sounds

Directory where system sounds will be stored. If you would like a certain sound played every time some specific command is passed to PSR, you can place a .wav file in this directory and it will be played before the command is executed.

Currently, the following are supported:

  help
  list
  listlog
  move
  mute
  play
  bgplay
  randplay
  randbgplay
  proxy_msg
  save
  speak
  status
  unmute

For example, my personal installation has the Clapper "clap clap" sound in this directory named "mute.wav" and "unmute.wav", and people tend to get a kick out of that.

=back

=head1 USAGE

PSR is currently just an instant messanger bot. So, to use it, send it an IM from another account.

Commands may be combined together using the "&&" operator. This does not always do what you think it should do. For example, the command:

    /play siren && /mute

Does NOT play that sound file until completion then mute the system. It DOES queue the sound for to play, then mute the system. Whether or not the sound file begins to be played or not depends upon outside processing by the PSR_play_deamon.

Combining comands is, nonetheless, still useful. For example:

    /play http://some.site.com/soundclip.mp3 && /play fart.wav && /bgplay i_like_cheese.wav

Command list, and explaination:

=over 4

=item /help

Will send you back an IM with the text:

 /help
 /say    text to speak aloud
 /save   http://url.to/sound/file.mp3
 /play   http://url.to/sound/file.mp3
 /play   sound_file.mp3
 /bgplay http://url.to/sound/file.mp3
 /bgplay sound_file.mp3
 /randplay number_of_entries
 /randbgplay number_of_entries
 /mvsnd  [origfile] [newfile]
 /list                (to list all available sound files)
 /list   [perl regex] (only those matching the regex)
 /status              (lists the status of the system)
 /log    [nback] [count] (prints out last N lines of the log)
 /msg    [rcpt] [text](proxy a message off to someone)
 /mute                (mutes the system)
 /unmute              (unmutes the system)

=item /say [text]

Run the given text through a text to speach engine (say it). (actually, it queues it to be spoken).

=item /save [some url]

Save the given URL. It can only accept a single URL, and URL's can't be mixed with file names. (actually, it queues it to be saved).

=item /play [some url]

Play the given URL. It can only accept a single URL, and URL's can't be mixed with file names.

=item /play filename1.wav [filename2.mp3 ... filenameN.wav]

Play one or more sound clips in series (actually, it queues them to be played).

=item /bgplay [some url]

Play the given URL in the background thread. It can only accept a single URL, and URL's can't be mixed with file names.

=item /bgplay filename1.wav [filename2.mp3 ... filenameN.wav]

Play one or more sound clips in series in the background thread (actually, it queues them to be played).

=item /randplay 1-5

Randomly pick sounds to play.

=item /randbgplay 1-5

Randomly pick sounds to play... in the background track.

=item /mvsnd [origfile] [newfile]

Rename a sound clip.

=item /list [regex]

With no arguement, it lists all the available sound clips.

Given an arguement, the arguement is used as a perl regex, and matching clip names are returned.

=item /status

Displays the "mute" status of the system (whether or not it is currently muted).

=item /log [###] [###]

Displays the last 10 lines of the log file, or however many lines back you specify.

=item /msg [rcpt] [text]

Sends a message to user "rcpt" (basically, an IM proxy).

=item /mute

VERY IMPORTANT COMMAND TO KNOW (incase the boss comes by, or a phone call comes in). Mutes the entire PSR system.

=item /unmute

un-Mutes the system (restores volume/mixer settings).

=back

=head1 TODO

Web frontend.

More inteligent command parsing (especially multiple URL support, and mixed URL/Filename support).

=head1 SEE ALSO

Net::OSCAR

Net::AIM

=head1 AUTHORS

Josh I. Miller

=head1 COPYRIGHT AND LICENSE

PSR is Copyright (c) 2004-2005 Josh I. Miller. All rights reserved.

You may distribute under the terms of either the GNU General Public License or the Artistic License, as specified in the Perl README file.

=item WARRANTY

The PSR is free Open Source software. IT COMES WITHOUT WARRANTY OF ANY KIND.

=cut

######################################################################
#### library use statements {{{1
package Net::PSR;
use strict;

my $aim_module = 'AIM'; # AIM or OSCAR
use Net::AIM qw(:standard);

use Carp qw(carp croak);
use Config::Tiny;
use File::Basename();
use File::Spec;
use Fcntl qw(:flock); # import LOCK_* constants

######################################################################
#### new() constructor {{{1
sub new
{
	my $this = shift;
	my $class = ref($this) || $this;

	my $self = { };

	bless( $self, $class );

	$self->load_cfg();
	$self->check_dirs();
	$self->load_abbr();

	return $self;
}

######################################################################
#### genernal stuff {{{1
## check_dirs {{{2
sub check_dirs
{
	my $self = shift;

	my $queue       = $self->cfg->{settings}{queue_dir};
	my $log_file    = $self->cfg->{settings}{log_file};
	my @log_dir     = File::Spec->splitdir($log_file);
	pop(@log_dir);
	my $log_dir     = File::Spec->catfile( @log_dir );
	my $music_queue = File::Spec->catfile($queue,'music');
	my $speak_queue = File::Spec->catfile($queue,'speak');
	my $play_queue  = File::Spec->catfile($queue,'play');
	my $bgplay_queue= File::Spec->catfile($queue,'bgplay');
	my $save_queue  = File::Spec->catfile($queue,'save');
	my $sounds_dir  = $self->cfg->{settings}{sounds_dir};
	foreach my $dir ( ($queue, $music_queue, $speak_queue, $play_queue,
	                   $bgplay_queue, $save_queue, $sounds_dir, $log_dir) )
	{
		unless ($self->create_dir($dir)) {
			warn "Unable to create dir: $dir\n";
			exit(1);
		}
	}

	unless (-e $log_file)
	{
		if (open(LOG,"> $log_file"))
		{
			close LOG;
		} else {
			warn "Unable to open log file[$log_file] $!\n";
			exit(1);
		}
	}

	$self->log_file($log_file);
	$self->music_queue($music_queue);
	$self->speak_queue($speak_queue);
	$self->play_queue($play_queue);
	$self->bgplay_queue($bgplay_queue);
	$self->save_queue($save_queue);
	$self->sounds_dir($sounds_dir);
	return 1;
}

## check_auth {{{2
sub check_auth
{
	my $self = shift;
	my $name = shift;
	my $strip_name = $name;
	$strip_name =~ s/\s//g;
	return 0 unless $self->cfg->{authed_users}{lc($strip_name)};
}

## system_event_sound {{{2
sub system_event_sound
{
	my $self = shift;
	my $event = shift;

	# play sound if it exists in system_sounds directory
	# if file doesn't exist, silently return.

	my $dir = $self->cfg->{settings}{system_sounds};

	if (-d $dir)
	{
		my $file = File::Spec->catfile($dir, $event.".wav");

		if (-e $file && -r $file)
		{
			my $mplayer = $self->cfg->{settings}{mplayer};

			if ($mplayer)
			{
				# split $mplayer on spaces, so we can pass to
				# system in the non-shell type multi arguement way
				my @mplayer = split /\s+/, $mplayer;
				my $item = $self->cmd_line_strip($file);
				my $rv = system(@mplayer, $item);
				unless ($rv == 0)
				{
					warn "Unable to play file [$file]\n";
					last;
				}
				## XXX HACK TODO : have to sleep, because if the
				##          command was "mute", it mute immediately
				##          after the system() fork, so you don't
				##          get a chance to hear the sound.
				sleep 1;

			} else {
				warn "mplayer program not configured!!!\n";
				warn "NOT playing urls\n";
			}
		}
	}
}

######################################################################
## handle_incoming_event {{{2
sub handle_incoming_event
{
	my $self = shift;
	my ($sender, $stripped_message) = @_;

	my $first_url = $self->extract_url($stripped_message);

	# help: if it begins w/ non-slash or non-backslash command
	if ($stripped_message =~ /^[^\/\\]/) {
		$self->send_msg($sender, 'Invalid command. For help, send /help');

	} elsif ($stripped_message =~ /^[\/\\](\S+)/) {
		my $cmd = $self->normalize_cmd($1);
		$stripped_message =~ s/^[\/\\]\S+\s*//;
		# a case: would be handy here :-)
		($cmd eq 'rtfm') ?
			$self->help($sender)                      :
		($cmd eq 'help') ?
			$self->help($sender)                      :
		($cmd eq 'say')  ?
			$self->speak($sender, $stripped_message)  :
		($cmd eq 'play' && $first_url) ?
			$self->play($sender, $first_url)          :
		($cmd eq 'play') ?
			$self->play($sender, $stripped_message)   :
		($cmd eq 'bgplay' && $first_url) ?
			$self->bgplay($sender, $first_url)        :
		($cmd eq 'bgplay') ?
			$self->bgplay($sender, $stripped_message) :
		($cmd eq 'randplay') ?
			$self->randplay($sender, $stripped_message) :
		($cmd eq 'randbgplay') ?
			$self->randbgplay($sender, $stripped_message) :
		($cmd eq 'list') ?
			$self->list($sender, $stripped_message)   :
		($cmd eq 'log') ?
			$self->listlog($sender, $stripped_message):
		($cmd eq 'mvsnd') ?
			$self->move($sender, $stripped_message, 'play')   :
		($cmd eq 'save') ?
			$self->save($sender, $first_url)          :
		($cmd eq 'status') ?
			$self->status($sender, $stripped_message) :
		($cmd eq 'mute') ?
			$self->mute($sender,0)                    :
		($cmd eq 'unmute') ?
			$self->mute($sender,1)                    :
		($cmd eq 'msg') ?
			$self->proxy_msg($sender, $stripped_message) :
		$self->send_msg($sender,
			'Invalid command. For help, send /help') ;
	}

	return 1;
}

######################################################################
#### aim specific stuff {{{1
## im_in {{{2
sub im_in
{
	my $self = shift;
	my ($aim, $sender, $message, $is_away);
	if ($aim_module eq 'AIM')
	{
		my ($evt, $to, $nick, $auto_msg, $msg);
		($aim, $evt, $sender, $to) = @_;
		my $args = $evt->args();
		($nick,  $auto_msg, $message) = @$args;
	} else {
		($aim, $sender, $message, $is_away) = @_;
	}

	unless ($self->check_auth($sender))
	{
		$self->log($sender, '[401] UNAUTHORIZED ACCESS');
		return;
	}

	$self->log($sender, $message);

	# message may be multipart (eg. /play thing && /bgplay foo)
	# must first get rid of html tags,
	# then we were going to unescape html encoded data (such as &amp;),
	# but they can pass in anything that way (like &192; for chr(192)),
	# so that's not safe.
	# So, we then split on && or &amp;&amp; or any combination of those,
	# then handle each sub-message.
	my $stripped_message = $self->strip_msg($message);
	foreach my $msg (split /\s+(?:\&|\&amp;)(?:\&|\&amp;)\s+/, $stripped_message)
	{
		$msg =~ s/^\s+//; $msg =~ s/\s+$//;
		$self->handle_incoming_event($sender, $msg);
	}

	return 1;
}

## mute {{{2
sub mute
{
	my $self = shift;
	my $sender = shift;
	my $status = shift;

	my @prog = ($status) ?
		split /\s+/, $self->cfg->{settings}{unmute_program} :
		split /\s+/, $self->cfg->{settings}{mute_program}   ;
	my $action = $status ? 'unmute' : 'mute';

	$self->system_event_sound('mute') if $action eq 'mute';

	if (@prog)
	{
		my $rv = system(@prog);
		if ($rv == 0)
		{
			$self->muted(  ( $status ? 0 : 1 ) );
			$self->send_msg($sender, "OK. System is $action");
		} else {
			$self->send_msg($sender, "FAILED. Unable to $action system.");
			warn "Unable to $action system.\n";
		}

	} else {
		$self->send_msg($sender, "ERROR. $action program not configured!!!");
		warn "$action program not configured!!!\n";
		warn "NOT ".$action."ing system\n";
	}

	$self->system_event_sound('unmute') if $action eq 'unmute';
}

## set_callbacks {{{2
sub set_callbacks
{
	my $self = shift;
	my $aim = $self->aim;

	my $sub = sub { my @opt = @_; $self->im_in(@opt) };
	# use OSCAR or TOC
	if ($aim_module eq 'AIM')
	{
		my $conn = $aim->getconn();
		$conn->set_handler('im_in', $sub);
	} else {
		$aim->set_callback_im_in( $sub );
	}
	return 1;
}

## signon {{{2
sub signon
{
	my $self = shift;

	my $server = $self->cfg->{account}{server} || 'login.oscar.aol.com';
	my $port   = $self->cfg->{account}{port}   || '5190';
	my $name   = $self->cfg->{account}{name};
	my $passwd = $self->cfg->{account}{password};

	unless ($name && $passwd) {
		warn "Required config values 'name' and 'password' are not set.\n";
		exit 1;
	}

	# use OSCAR or TOC
	if ($aim_module eq 'AIM')
	{
		my $aim = Net::AIM->new();

		$self->aim($aim);

		## connect, then set callbacks
		my $rv = $aim->newconn(
		               Screenname => $name,
		               Password   => $passwd,
		               TocServer  => 'toc.oscar.aol.com',
		               TocPort    => '9898',
		               AuthServer => $server,
		               AuthPort	  => $port,
		               AutoReconnect => 1
		               );
		unless ($rv) {
			warn "Unable to signon with login $name\n";
			exit 1;
		}
		$aim->timeout('0.01');

		$self->set_callbacks();

	} else {
		my $aim = Net::OSCAR->new();

		$self->aim($aim);

		## set callbacks, then connect
		$self->set_callbacks();

		my $rv = $aim->signon(
		               screenname => $name,
		               password   => $passwd,
		               host       => $server,
		               port       => $port
		               );
		unless ($rv) {
			warn "Unable to signon with login $name\n";
			exit 1;
		}
		$aim->timeout('0.01');
	}

	return 1;
}

## do_one_loop {{{2
sub do_one_loop
{
	my $self = shift;

	my $loop_count = $self->loop_count() || '1';
	$self->loop_count( $loop_count +1 );
	unless ($loop_count % 100) {
		$self->send_acks();
	}

	$self->aim->do_one_loop();
}

## stop {{{2
sub stop
{
	my $self = shift;
	$self->running(0);

	# use OSCAR or TOC
	if ($aim_module eq 'AIM')
	{
		# Net::AIM doesn't do anything in quit() (nd it's broken)
		# $self->aim->getconn->quit() if $self->aim;
	} else {
		$self->aim->signoff if $self->aim;
	}
}

## send_msg {{{2
sub send_msg
{
	my $self = shift;
	my $to = shift;
	my $msg = shift;

	# TOC will drop the connection if a command exceeds the maximum
	# length, which is currently 2048 bytes.
	my $maxlength = 1800;
	if (length($msg) > $maxlength)
	{
		for (my $i = 0; $i < length($msg); $i += $maxlength)
		{
			$self->send_msg($to, substr($msg,$i,$maxlength) );
		}

	} else {
		my $rv = $self->aim->send_im($to, $msg);
		if ($rv == 0)
		{	# message too large
			warn "Message to large to send: $msg\n";
			$self->aim->send_im($to, "Error: msg too large to send");
		}
	}
}

## send_acks {{{2
sub send_acks
{
	my $self = shift;

	foreach my $type (qw(speak play bgplay music save))
	{
		my $dir = $self->get_queue_dir_by_type($type);

		opendir(QDIR, $dir) or die "Unable to open queue dir[$dir]: $!\n";
		my @files = map { File::Spec->catfile($dir, $_) }
		            grep { (!/^\./) && (/^\D/) && -f File::Spec->catfile($dir,$_) }
		            readdir(QDIR);
		closedir QDIR;

		foreach my $file (@files)
		{
			open(QFILE,"< $file") or die "Unable to open queue file [$file]: $!\n";
			flock(QFILE,LOCK_EX);
			my $user = <QFILE>;
			my @items = <QFILE>;
			flock(QFILE,LOCK_UN);
			close QFILE;

			unlink $file;

			chomp(@items);

			if ($self->cfg->{settings}{send_command_confirmation_messages})
			{
				($type eq 'save')  ?
					$self->send_msg($user, "OK. Saved: \n\t".join("\n\t",@items)."\n") :
				($type eq 'play')  ?
					$self->send_msg($user, "OK. Played: \n\t".join("\n\t",@items)."\n") :
				($type eq 'bgplay')?
					$self->send_msg($user, "OK. Played: \n\t".join("\n\t",@items)."\n") :
				($type eq 'speak') ?
					$self->send_msg($user, "OK. Said: \n\t".join("\n\t",@items)."\n")   :
				($type eq 'music') ?
					$self->send_msg($user, "OK. Played: \n\t".join("\n\t",@items)."\n") :
				croak "Unknown type[$type]\n"       ;
			}
		}
	}
}

## help {{{2
sub help
{
	my $self = shift;
	my $sender = shift;

	$self->system_event_sound('help');

	my $message = "/help
/say    text to speak aloud
/save   http://url.to/sound/file.mp3
/play   http://url.to/sound/file.mp3
/play   sound_file.mp3
/bgplay http://url.to/sound/file.mp3
/bgplay sound_file.mp3
/randplay [number or entries to play]
/randbgplay [number or entries to play]
/mvsnd  [origfile] [newfile]
/list                (to list all available sound files)
/list   [perl regex] (only those matching the regex)
/status              (lists the status of the system)
/log    [nback] [count] (prints out last N lines of the log)
/msg    [rcpt] [text](proxy a message off to someone)
/mute                (mutes the system)
/unmute              (unmutes the system)";
	$self->send_msg($sender, $message);
}

######################################################################
## speak {{{2
sub speak
{
	my $self = shift;
	my $sender = shift;
	my $message = shift;
	my $abbr = $self->abbr;

	$self->system_event_sound('speak');

	$_ = $message;
	s/\bhttp:\/\/\S+/ ghetto url /g;
	s/\bftp:\/\/\S+/ ghetto url /g;
	s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;  #Parse out most HTML.  See note 1.
	s/\'//g;  #These lines remove characters that cannot be sent to festival
	s/\"//g;  #  via the command line
	s/\(//g;
	s/\)//g;
	s/\>//g;
	s/\<//g;
	s/\;//g;
	s/(\.+)/$1 /;
	#run through the message and substitute out any abbreviations found
	foreach my $key (keys %{$abbr}) {
		$_ =~ s/\b$key\b/$$abbr{$key}/ig;
	}
	$message = $_;
	if ($message)
	{
		my $stripped = $self->strip_msg($message);
		$self->queue('speak', $sender, "$sender said $stripped");
	}
}

######################################################################
## randplay {{{2
sub randplay
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;
	$self->_randplay($sender, $msg, 'gg');
}

######################################################################
## randbgplay {{{2
sub randbgplay
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;
	$self->_randplay($sender, $msg, 'bg');
}

######################################################################
## _randplay {{{2
sub _randplay
{
	my $self = shift;
	my $sender = shift;
	my $msg    = shift;
	my $fgbg   = shift;

	$msg =~ s/\D//;
	$msg = 1 unless $msg;
	$msg = 5 if $msg > 10; # check for max limit

	my @sounds;
	opendir(SNDS, $self->sounds_dir()) or return;
	while (my $file = readdir SNDS)
	{
		my $abs_file = File::Spec->catfile($self->sounds_dir(), $file);
		next if -d $abs_file;
		next if $file =~ /^\./;
		next unless -r $abs_file;
		push(@sounds, $file);
	}
	closedir SNDS;

	my $max_snd = @sounds;
	my @new_msg;
	for (1 .. $msg)
	{
		push(@new_msg, $sounds[ int(rand($max_snd + 1)) ] );
	}
	my $new_msg = join(' ', @new_msg);

	my $playtype = ($fgbg eq 'bg') ? 'bgplay' : 'play';
	$self->_play($sender, $new_msg, $playtype);
}

######################################################################
## play {{{2
sub play
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	return $self->_play($sender, $msg, 'play');
}

######################################################################
## bgplay {{{2
sub bgplay
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	return $self->_play($sender, $msg, 'bgplay');
}

######################################################################
## _play {{{2
sub _play
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;
	my $queue = shift; # play or bgplay

	$self->system_event_sound($queue);

	if ($self->extract_url($msg))
	{
		my $url = $self->extract_url($msg);
		$self->queue($queue,$sender,$url);
		if ($self->cfg->{settings}{send_command_receipt_messages}) {
			$self->send_msg($sender, "URL queued for playback.");
		}

	} else {
		# message assumed to be a file name in $sounds_dir
		my $found_one = 0;
		foreach my $filename (split /\s+/, $msg)
		{
			my $file = File::Spec->catfile($self->sounds_dir(), $filename);
			# split into individual parts
			my @parts = File::Spec->splitdir($file);
			# remove ., .., and equivilants
			@parts = File::Spec->no_upwards(@parts);
			# rebuild name
			my $newfile = File::Spec->catfile(@parts);
			# check for existing files, appending various extensions
			$newfile = (-e $newfile)        ? $newfile        :
			           (-e $newfile.'.wav') ? $newfile.'.wav' :
			           (-e $newfile.'.WAV') ? $newfile.'.WAV' :
			           (-e $newfile.'.mp3') ? $newfile.'.mp3' :
			           (-e $newfile.'.MP3') ? $newfile.'.MP3' :
			           (-e $newfile.'.asf') ? $newfile.'.asf' :
			           (-e $newfile.'.ASF') ? $newfile.'.ASF' :
			                                  $newfile        ;

			if (! -e $newfile) {
				$self->send_msg($sender, "FAILED! File doesn't exist: $newfile");
			} else {
				$self->queue($queue, $sender, $newfile);
				$found_one++;
			}
		}
		if ($self->cfg->{settings}{send_command_receipt_messages}) {
			$self->send_msg($sender, "File queued for playback.") if $found_one;
		}
	}
}

######################################################################
## proxy_msg {{{2
sub proxy_msg
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	$self->system_event_sound('proxy_msg');

	if ($msg =~ /^\s*(\S+)\s+(\S.*)$/)
	{
		my $rcpt = $1;
		my $text = $2;
		$self->send_msg($rcpt, $sender.' says: '.$text);
	} else {
		$self->send_msg($sender, "USAGE: /msg [recipient] [message text]");
	}
}

######################################################################
## list {{{2
sub list
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	$self->system_event_sound('list');

	$msg =~ s/^\s+//;
	$msg =~ s/\s.*$//;
	my $q_msg = qr/$msg/i;

	my $dir = $self->sounds_dir();
	if (opendir(DIR,$dir))
	{
		my @files = sort {lc($a) cmp lc($b)} grep { (!/^\./) } readdir(DIR);
		@files = grep { /$q_msg/ } @files if $msg;
		closedir DIR;

		$self->send_msg($sender, "Directory listing:\n".join("\n",@files) );

	} else {
		$self->send_msg($sender, "FAILED! Unable to read from sound directory: $dir");
		return;
	}
}
######################################################################

######################################################################
## listlog {{{2
sub listlog
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	$self->system_event_sound('listlog');

	my ($lines_back,$n_lines);
	if ($msg =~ /(\d+)[-\s]+(\d+)/)
	{
		$lines_back = $1;
		$n_lines    = $2;
	} elsif ($msg =~ /(\d+)/) {
		$lines_back = $1;
		$n_lines    = $1;
	} else {
		$lines_back = 5;
		$n_lines    = 5;
	}

	my $log_file = $self->log_file;
	if (open(LOG,"< $log_file"))
	{
		my $log_message;
		my @lines = <LOG>;
		close LOG;
		my $last = @lines;
		my $start = ($last - $lines_back);
		for (my $i = $start; $i < ($start + $n_lines); $i++)
		{
			$log_message .= $lines[$i];
		}
		$self->send_msg($sender, $log_message);
	} else {
		$self->send_msg($sender, "ERROR: Unable to read log file.");
	}
}
######################################################################

######################################################################
## status {{{2
sub status
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	$self->system_event_sound('status');

	my $status = "Status:\n";
	$status   .= ($self->muted) ? "[Muted]\n" : "NOT Muted\n";

	$self->send_msg($sender, $status);
}
######################################################################

######################################################################
## save {{{2
sub save
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;

	$self->system_event_sound('save');

	$msg =~ s/[^A-Za-z0-9\s,\.\?\/\]\[\&\^\%\#\@\\_:-]//g;

	if ($self->extract_url($msg))
	{
		my $url = $self->extract_url($msg);
		my $sounds_dir = $self->sounds_dir();
		# determine relative file name
		my $relative = $url;
		$relative =~ s/^http:\/\/|ftp:\/\///i;
		my $basename = File::Basename::basename($relative);
		my $newfile = File::Spec->catfile($sounds_dir,$basename);

		my $dir = $self->sounds_dir();
		if (opendir(DIR,$dir))
		{
			my %files = map { $_ => 1 } readdir(DIR);
			closedir DIR;

			if ($files{$basename})
			{
				$self->send_msg($sender, "ERROR: file already exists [$basename].");
				return;
			}

			$self->queue('save',$sender,$url);
			if ($self->cfg->{settings}{send_command_receipt_messages}) {
				$self->send_msg($sender, "URL queued for saving.");
			}

		} else {
			$self->send_msg($sender, "FAILED! Unable to read from sound directory: $dir");
			return;
		}
	} else {
		$self->send_msg($sender, "ERROR: must be either http or ftp file.\n($msg)\nusage: /save http://something.com/file.ext");
		return;
	}
}

######################################################################
## move {{{2
sub move
{
	my $self = shift;
	my $sender = shift;
	my $msg = shift;
	my $type = shift;

	$self->system_event_sound('move');

	$msg =~ s/[^A-Za-z0-9\s,\.\?\/\]\[\&\^\%\#\@\\_:-]//g;

	my $basedir = ($type eq 'play') ?
	                  $self->sounds_dir()  :
	                  $self->sounds_dir()  ;

	# message assumed to be a file name in $basedir
	my ($orig,$new) = split /\s+/, $msg;
	unless ($orig && $new)
	{
		$self->send_msg($sender, "Usage: [cmd] [origfile] [newfile]");
		return;
	}

	# determine relative file names
	my $origbase = File::Basename::basename($orig);
	my $origfile = File::Spec->catfile($basedir,$origbase);
	$origfile = $self->cmd_line_strip($origfile);
	my $newbase  = File::Basename::basename($new);
	my $newfile  = File::Spec->catfile($basedir,$newbase );
	$newfile = $self->cmd_line_strip($newfile);

	if (opendir(DIR,$basedir))
	{
		my %files = map { $_ => 1 } readdir(DIR);
		closedir DIR;

		if ($files{$newbase})
		{
			$self->send_msg($sender, "ERROR: file already exists [$newbase].");
			return;
		}
		unless ($files{$origbase})
		{
			$self->send_msg($sender, "ERROR: orig file doesn't exist [$origbase].");
			return;
		}

		if (rename $origfile, $newfile)
		{
			if ($self->cfg->{settings}{send_command_receipt_messages}) {
				$self->send_msg($sender, "OK. Moved: $origbase $newbase");
			}
			return 1;
		} else {
			$self->send_msg($sender, "FAILED! Unable to rename file '$origbase' to '$newbase'");
			return;
		}
	} else {
		$self->send_msg($sender, "FAILED! Unable to read from sound directory: $basedir");
		return;
	}
}

######################################################################

#### aim listener stuff - no connection needed {{{1
## queue {{{2
sub queue
{
	my $self = shift;
	my $type = shift;
	my $user = shift;
	my @rest = @_;

	my $file = $self->get_queue_file($type,$user);

	$user =~ s/\n//g;
	open (QFILE, "> $file") or die "Unable to open queue file $file: $!\n";
	print QFILE "$user\n";
	print QFILE "$_\n" foreach @rest;
	close QFILE;
}

## get_queue_file {{{2
sub get_queue_file
{
	my $self = shift;
	my $type = shift;
	my $user = shift;
	my $dir = $self->get_queue_dir_by_type($type);
	$user   =~ s/\.\.//g;
	$user =~ s/[^A-Za-z0-9,\.]//g;
	my $now = $self->get_last_queue_run();
	my $file = File::Spec->catfile($dir,"$now-$user");
}

## get_last_queue_run {{{2
# each time something is queued, a counter get's incremented for that second,
# unless it's on a second that we hadn't run before.
sub get_last_queue_run
{
	my $self = shift;
	my $now = time;
	my $last = $self->last_queue_time();
	my $front = substr($last,0,-3);
	if ($now eq $front)
	{
		my $tail = substr($last,-3);
		$tail++;
		$self->last_queue_time($now . sprintf('%03d',$tail) );
		return $self->last_queue_time();
	} else {
		$self->last_queue_time($now . sprintf('%03d','000') );
		return $self->last_queue_time();
	}
}

#### queue processing stuff {{{1
## process_queue {{{2
sub process_queue
{
	my $self = shift;
	my $type = shift;

	my $dir = $self->get_queue_dir_by_type($type);

	opendir(QDIR, $dir) or die "Unable to open queue dir[$dir]: $!\n";
	my @files = grep { (!/^\./) && (/^\d/) && -f File::Spec->catfile($dir,$_) } readdir(QDIR);
	closedir QDIR;

	foreach my $file (sort {$a cmp $b} @files)
	{
		my $full_file = File::Spec->catfile($dir,$file);
		($type eq 'save')   ?
			$self->save_queue_file($full_file)  :
		($type eq 'play')   ?
			$self->play_queue_file($full_file)  :
		($type eq 'bgplay') ?
			$self->play_queue_file($full_file)  :
		($type eq 'speak')  ?
			$self->speak_queue_file($full_file) :
		($type eq 'music')  ?
			$self->play_queue_file($full_file)  :
		croak "Unknown type[$type]\n"       ;
	}
}

## save_queue_file {{{2
sub save_queue_file
{
	my $self = shift;
	my $file = shift;
	my $fetcher = $self->cfg->{settings}{fetcher};

	open (QFILE,"< $file") or die "Unable to open queue file [$file]: $!\n";
	flock(QFILE,LOCK_EX);
	my $user = <QFILE>;
	my @files = <QFILE>;
	flock(QFILE,LOCK_UN);
	close QFILE;

	chomp(@files);

	if ($fetcher)
	{
		# split $fetcher on spaces, so we can pass to
		# system in the non-shell type multi arguement way
		my @fetcher = split /\s+/, $fetcher;
		my $saved = 1;
		while (my $item = shift(@files))
		{
			if ($self->extract_url($item))
			{
				my $url = $self->extract_url($item);
				my $sounds_dir = $self->sounds_dir();
				# determine relative file name
				my $relative = $url;
				$relative =~ s/^http:\/\/|ftp:\/\///i;
				my $basename = File::Basename::basename($relative);
				my $newfile = File::Spec->catfile($sounds_dir,$basename);

				my $dir = $self->sounds_dir();
				if (opendir(DIR,$dir))
				{
					my %files = map { $_ => 1 } readdir(DIR);
					closedir DIR;

					if ($files{$basename})
					{
						warn "Unable to download file [$url]\n";

					} else {
						$newfile = $self->cmd_line_strip($newfile);
						$url     = $self->cmd_line_strip($url);
						my $rv = system(@fetcher, $newfile, $url);
						unless ($rv == 0)
						{
							warn "Error saving file via: ".(join(" ",(@fetcher, $newfile, $url)))."\n";
							$saved = 0;
						}
					}
				} else {
					warn "Unable to open sounds dir [$dir]\n";
				}
			} # item isn't a url?
		} # end foreach @files

		if ($saved)
		{
			# remove file
			my @parts   = File::Spec->splitdir($file);
			$parts[-1]  = "saved-".$parts[-1];
			my $newfile = File::Spec->catfile(@parts);
			rename $file, $newfile;
		} else {
			warn "ERROR fetching file!!!\n";
		}

	} else {
		warn "fetcher program not configured!!!\n";
		warn "NOT playing urls\n";
	}
}

## play_queue_file {{{2
sub play_queue_file
{
	my $self = shift;
	my $file = shift;
	my $mplayer = $self->cfg->{settings}{mplayer};

	open (QFILE,"< $file") or die "Unable to open queue file [$file]: $!\n";
	flock(QFILE,LOCK_EX);
	my $user = <QFILE>;
	my @files = <QFILE>;
	flock(QFILE,LOCK_UN);
	close QFILE;

	chomp(@files);

	if ($mplayer)
	{
		# split $mplayer on spaces, so we can pass to
		# system in the non-shell type multi arguement way
		my @mplayer = split /\s+/, $mplayer;
		while (my $item = shift(@files))
		{
			$item = $self->cmd_line_strip($item);
			my $rv = system(@mplayer, $item);
			unless ($rv == 0)
			{
				warn "Unable to play file [$file]\n";
				last;
			}
		}
		my @parts   = File::Spec->splitdir($file);
		$parts[-1]  = "played-".$parts[-1];
		my $newfile = File::Spec->catfile(@parts);
		rename $file, $newfile;

	} else {
		warn "mplayer program not configured!!!\n";
		warn "NOT playing urls\n";
	}
}

## speak_queue_file {{{2
sub speak_queue_file
{
	my $self = shift;
	my $file = shift;
	my $festival = $self->cfg->{settings}{festival};

	open (QFILE,"< $file") or die "Unable to open queue file [$file]: $!\n";
	flock(QFILE,LOCK_EX);
	my $user = <QFILE>;
	my @items = <QFILE>;
	flock(QFILE,LOCK_UN);
	close QFILE;

	chomp(@items);

	if ($festival)
	{
		# split $festival on spaces, so we can pass to
		# system in the non-shell type multi arguement way
		my @festival = split /\s+/, $festival;
		while (my $item = shift(@items))
		{
			$item = $self->cmd_line_strip($item);
			my $rv = $self->pipe_system($item, @festival);
			unless ($rv == 0)
			{
				warn "Error speak file via: ".(join(" ",($item,@festival)))."\n";
				warn "Unable to speak file [$file]\n";
				last;
			}
		}
		my @parts   = File::Spec->splitdir($file);
		$parts[-1]  = "played-".$parts[-1];
		my $newfile = File::Spec->catfile(@parts);
		rename $file, $newfile;

	} else {
		warn "Text to speech program not configured!!!\n";
		warn "NOT speaking text file $file\n";
	}
}


######################################################################
#### plain jane utility stuff {{{1
## pipe_system($data_to_pipe, @program) {{{2
## this works like system(@prog_and_opts) (safe exec), but allows you 
## to pipe stuff to that program. It does this by forking, using
## perl open icp, and exec() in the child process.
## $data_to_pipe may be an array ref, a subroutine ref, or a scalar.
sub pipe_system
{
	my $self = shift;
	my $data = shift;
	my @program = @_;

	# fork a new process... try 6 times.
	my $die_count = 0;
	my $pid;
	do {
		$pid = open(KID, "|-");
		unless (defined $pid)
		{
			warn "Unable to fork: $!";
			die "Bailing out" if $die_count++ > 6;
			sleep 10;
		}
	} until defined $pid;

	my $pipe_broken = 0;
	my $saved_sig_pipe = $SIG{PIPE};
	my $saved_sig_chld = $SIG{CHLD};
	$SIG{PIPE} = sub { $pipe_broken = 1; };
	$SIG{CHLD} = 'IGNORE';

	if ($pid) # parent
	{
		# dump data to the child, depending on what type of data
		if (ref($data) eq 'ARRAY')
		{
			foreach my $line (@{$data})
			{
				print KID $line unless $pipe_broken;
			}
		} elsif (ref($data) eq 'CODE') {
			print KID &{$data} unless $pipe_broken;
		} elsif ( ! ref($data) ) {
			print KID $data unless $pipe_broken;
		} else {
			croak "Invalid data structure passed to pipe_system(): ".ref($data)."\n";
		}
		close KID;

		# restore sig handlers
		$SIG{PIPE} = $saved_sig_pipe;
		$SIG{CHLD} = $saved_sig_chld;

		# system returns 0 on success, 1 or more on failure.
		return $pipe_broken ? 1 : 0;

	} else {  # child
		# setup our effective uid/gid
		$> = $<; # $EUID = $UID
		$) = $(; # $EGID = $GID
		exec(@program) or die "Can't exec program: @program: $!";
		exit;
	}
}
## log {{{2
sub log
{
	my $self = shift;
	my $from = shift;
	my $message = shift;

	return unless $self->cfg->{settings}{enable_logging};

	# remove spaces, and lc() the sender
	$from =~ s/\s+//g;
	$from = lc($from);
	# remove new lines that may foul up our log message.
	$message =~ s/[\r\n]+/ /g;

	my ($sec,$min,$hr,$day,$mon,$year) = localtime();
	my $month = (qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec))[$mon];

	my $log_file = $self->log_file;
	if (open(LOG,">> $log_file"))
	{
		printf LOG '%s %02d %02d:%02d:%02d %s PSR.pl[%d]: %s%s', $month, $day, $hr, $min, $sec, $from, $$, $message,"\n";
		close LOG;
	} else {
		warn "Unable to open log file[$log_file] $!\n";
		exit(1);
	}
}

## strip_msg (strips text to make it parseable) {{{2
sub strip_msg
{
	my $self = shift;
	my $msg  = shift;
	# Parse out most HTML. (taken from http://www.rocketaware.com/perl/perlfaq9/How_do_I_remove_HTML_from_a_stri.htm)
	$msg =~ s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;
	# remove bad stuff
        $msg =~ s/[^A-Za-z0-9\s,\.\?\/\]\[\&\^\%\#\@\!\`\\_:;-]//g;
	return $msg;
}

## cmd_line_strip (strips text so it's command line safe) {{{2
sub cmd_line_strip
{
	my $self = shift;
	my $msg  = shift;
	$msg =~ s/[^A-Za-z0-9\s,\.\?\/\]\[\&\^\%\#\@\!_:-]//g;
	return $msg;
}

## create_dir {{{2
sub create_dir
{
	my $self = shift;
	my $dir  = shift;
	my @parts   = File::Spec->splitdir($dir);
	for (my $i=0; $i<@parts; $i++)
	{
		# take array slice of parts to build dir from base up
		my $fulldir = File::Spec->catdir(@parts[0 .. $i]);
		# only create it if it doesn't already exist
		unless(-e $fulldir && -d $fulldir)
		{
			unless (mkdir($fulldir))
			{
				croak "Can't create directory $fulldir";
				return undef;
			}
		}
	}
	return 1;
}

## load_cfg {{{2
sub load_cfg
{
	my $self = shift;

	# find config file location
	my $cfg_file;
	my $dot_cfg_file  = File::Spec->catfile($ENV{HOME},'.PSR.ini');
	if (-e $dot_cfg_file)
	{
		$cfg_file = $dot_cfg_file;

	} else {
		my $this_file = __FILE__;
		my $dirname   = File::Basename::dirname($this_file);
		my @dir       = File::Spec->splitdir($dirname);
		$cfg_file  = File::Spec->catfile(@dir,'PSR','PSR.ini');
		if (! -e $cfg_file)
		{
			warn "Unable to locate config file. Tried '$cfg_file' and '$dot_cfg_file'.\n";
			exit 1;
		}
	}

	my $config    = Config::Tiny->read( $cfg_file );

	unless (ref $config)
	{
		warn "Unable to parse config file[$cfg_file]\n";
		exit 1;
	}

	$self->cfg( $config );
	return $config;
}

## dump_config {{{2
sub dump_config
{
	my $self = shift;
	my $config = $self->cfg;
	foreach my $key (keys %{$config}){
		print "[$key]\n";
		foreach my $item (keys %{$config->{$key}}){
			print "$item=$config->{$key}{$item}\n";
		}
		print "\n\n";
	}
}

## load_abbr {{{2
sub load_abbr
{
	my $self = shift;
	my %abbr;

	# find abbr file location
	my $abbr_file;
	if (-e $self->cfg->{settings}{abbr_file})
	{
		$abbr_file = $self->cfg->{settings}{abbr_file};
	} else {
		my $this_file  = __FILE__;
		my $dirname    = File::Basename::dirname($this_file);
		my @dir        = File::Spec->splitdir($dirname);
		$abbr_file  = File::Spec->catfile(@dir,'PSR','abbreviations');
	}

	#open up abbr_file and read in any abbreviations
	#and their matching full words or sentances
	if (-e $abbr_file)
	{
		if(open (F, $abbr_file))
		{
			while(<F>) {
				my @temp = split(":");
				$abbr{$temp[0]} = $temp[1];
			}
			close F;
		}
	}

	$self->abbr( \%abbr );
	return \%abbr;
}

## get_queue_dir_by_type {{{2
sub get_queue_dir_by_type
{
	my $self = shift;
	my $type = shift;
	my $dir  = ($type eq 'play')   ? $self->play_queue()  :
	           ($type eq 'bgplay') ? $self->bgplay_queue()  :
	           ($type eq 'speak')  ? $self->speak_queue() :
	           ($type eq 'music')  ? $self->music_queue() :
	           ($type eq 'save')   ? $self->save_queue()  :
	                                 ''                   ;
	unless (-d $dir)
	{
		croak "queue dir doesn't exist: $dir\n";
	}
	return $dir;
}

## extract_url {{{2
sub extract_url
{
	my $self = shift;
	my $msg  = shift;

	if ($msg =~ /((http|ftp):\/\/\S+?)['"<]/i)
	{
		return $1;
	} elsif ($msg =~ /((http|ftp):\/\/\S+)/i) {
		return $1;
	} else {
		return;
	}
}

######################################################################
## normalize_cmd (takes command, or abbreviation, and returns full name) {{{2
sub normalize_cmd
{
	my $self = shift;
	my $cmd  = shift;

	my @cmds = qw(rtfm help say play bgplay randplay randbgplay list log mvsnd save status mute unmute msg);
	foreach my $c (@cmds)
	{
		return $c if $c =~ /^\Q$cmd\E/i;
	}
	return $cmd;
}

######################################################################
## unescapeHTML (pulled from CGI.pm, takes string, returns string) {{{2
## This is borrowed almost directly from CGI.pm, so that we don't have
## to pull in that entire library just for this one method.
sub unescapeHTML 
{
	my $self = shift;
	my $string = shift;

	return undef unless defined($string);
	# we don't handle other character sets yet
	my $latin = 1;
	#my $latin = defined $self->{'.charset'} ? $self->{'.charset'} =~ /^(ISO-8859-1|WINDOWS-1252)$/i
	#                                        : 1;

	# thanks to Randal Schwartz for the correct solution to this one
	$string=~ s[&(.*?);]{
	local $_ = $1;
	/^amp$/i    ? "&" :
	/^quot$/i   ? '"' :
	/^gt$/i     ? ">" :
	/^lt$/i     ? "<" :
	/^#(\d+)$/ && $latin         ? chr($1) :
	/^#x([0-9a-f]+)$/i && $latin ? chr(hex($1)) :
	$_
	}gex;
	return $string;
}

######################################################################
#### Stupid accessor methods {{{1
sub last_queue_time { my $s=shift; return $s->_accessor('_last_queue_time', @_); }
sub sounds_dir { my $s=shift; return $s->_accessor('_sounds_dir', @_); }
sub cfg { my $s=shift; return $s->_accessor('_cfg', @_); }
sub abbr { my $s=shift; return $s->_accessor('_abbr', @_); }
sub log_file { my $s=shift; return $s->_accessor('_log_file', @_); }
sub save_queue { my $s=shift; return $s->_accessor('_save_queue', @_); }
sub play_queue { my $s=shift; return $s->_accessor('_play_queue', @_); }
sub bgplay_queue { my $s=shift; return $s->_accessor('_bgplay_queue', @_); }
sub speak_queue { my $s=shift; return $s->_accessor('_speak_queue', @_); }
sub music_queue { my $s=shift; return $s->_accessor('_music_queue', @_); }
sub aim { my $s=shift; return $s->_accessor('_aim', @_); }
sub running { my $s=shift; return $s->_accessor('_running', @_); }
sub loop_count { my $s=shift; return $s->_accessor('_loop_count', @_); }
sub muted { my $s=shift; return $s->_accessor('_muted', @_); }
#sub sounds_dir { my $s=shift; return $s->_accessor('_sounds_dir', @_); }
## _accessor {{{2
sub _accessor
{
	my $self = shift;
	my $field = shift;
	if (@_)
	{
		$self->{$field} = $_[0];
		return $_[0];
	} else {
		return $self->{$field};
	}
}

1;
