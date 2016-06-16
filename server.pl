#!/usr/bin/perl


#	This code comes with NO LICENSE and NO WARRANTY
#
#	The following code implements a simple perl script that
#	serve data collected from a file aimed to look
#   for specific MAC addresses catched from airodump-ng tool.
#   The server opens a socket and listen for a connection.
#
#	Usage: ./server.pl [-a <server_address>] [-p <server_port>]
#
#	AUTHOR: Andrea Galloni andreagalloni92@gmail.com

#use strict;
use warnings;
use JSON;
use IO::Socket::INET;

my $inputFile='tmpfile0-01.csv';
my $port="7777";
my $address="0.0.0.0";
my @drone_macs = qw/90:03:B7 A0:14:3D 00:12:1C 00:26:7E/;
my @macs=qw/A4:56:30 AC:A0:16:BB/;
@macs=qw/84:B2:61 00:24:89:C5 FA:DE:27:95 A4:56:30 AC:A0:16:BB/;
#my $dev = "A4:56:30";

while (@ARGV) {
    local $_ = shift @ARGV;
    ($_ eq '-a' || $_ eq '--address') && do { $address = shift @ARGV; next; };
    ($_ eq '-p' || $_ eq '--port') && do { $port = shift @ARGV; next; };
    ($_ =~ /^-./) && do { print STDERR "Unknown option: $_\n"; die "Wrong Parameters"};
}

# auto-flush on socket;
$| = 1;

# creating a listening socket;
my $socket = new IO::Socket::INET (
    LocalHost => $address,
    LocalPort => $port,
    Proto => 'tcp',
    Listen => 10,
    Reuse => 1
);

die "cannot create socket $!\n" unless $socket;
$json = JSON->new->allow_nonref;

print "server waiting for client connection on port $port\n";
while(1)
{
    # waiting for a new client connection;
    my $client_socket = $socket->accept();

    # get information about a newly connected client;
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print "connection from $client_address:$client_port\n";

    my $data = "";
    my @response;

    # Read up to 1024 characters from the connected client;
    $client_socket->recv($data, 1024);
    print "received data: $data\n";
    
    # read from the file
    open(FILE,"<",$inputFile) || print "Can't read tmp file $inputFile: $!";
  	my @fileArr = <FILE>;
  	close (FILE);
    
    # Filter MACS and creates  a pretty response with necessary information;
  	foreach (@fileArr){
  	  for my $dev (@drone_macs){
        s/[\0\r\h]//g;
        my @arr = split(",",$_);
        if (/^($dev)/){
          my %hash =
            (
              "mac"  => $arr[0],
              "power" => $arr[8]+0, # cast to scalar;
              "essid"  => $arr[13],
            );
            push @response , \%hash;
        }
	    }
   }  
  # send response JSON data to the connected client;
	$data = $json->pretty->encode(\@response);
	$client_socket->send($data);
  # notify client that response has been sent;
  shutdown($client_socket, 1);

}

$socket->close();
