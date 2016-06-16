#!/usr/bin/perl

#
#	This code comes with NO LICENSE and NO WARRANTY
#
#	The following code implements a Simple Perl script that
#	runs airodump-ng and kill the process when SIGINT or SIGTERM
#   	are spawned.
#	Usage: ./dump.pl
#
#	AUTHOR: Andrea Galloni andreagalloni92@gmail.com
#

 use warnings;
 use strict;
 use English;

 if ($>!=0){
	die "This script has to be runned as root. $! \n";
 }

 my $iFace='wlan1';
 my $p1 = $PID;

 $SIG{INT} = sub { kkillit(); die "Caught a sigint $!" };
 $SIG{TERM} = sub { kkillit(); die "Caught a sigterm $!" };

 print "Process ID: ",$PID,"\n";

 $p1=open(DUMP1,"|sudo airodump-ng --output-format csv -w tmpfile0 $iFace --write-interval 1 >>/dev/null 2>> /dev/null");
 print $p1,"\n";

 print "Press Enter to Close\n";

 my $input = <STDIN>;
 kkillit();

 sub kkillit {
 	sudo("kill",$p1);
 	sudo("killall", "-9","airodump-ng");

 	close(DUMP1);
 	sudo("rm","tmpfile0-01.csv");
  exit 0;

}
 sub sudo {
	 print "Running: @_\n";
	 system("sudo", @_);
 }
