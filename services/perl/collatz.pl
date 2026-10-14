#!/usr/bin/env perl
# One hailstone step, served the way the internet was held together in 1999.
use strict;
use warnings;
use IO::Socket::INET;

$| = 1;
my $server = IO::Socket::INET->new(LocalPort => 8000, Listen => 128, ReuseAddr => 1)
    or die "can't listen: $@";
print "Perl is listening on :8000\n";

sub step { my $n = shift; $n % 2 ? 3 * $n + 1 : $n / 2 }

while (my $client = $server->accept) {
    my $request = <$client> // '';
    while (my $header = <$client>) { last if $header eq "\r\n" }

    my ($status, $body) = $request =~ m{[?&]n=(\d+)[ &]} && $1 > 0
        ? ('200 OK', step($1))
        : ('400 Bad Request', 'need ?n=<positive integer>');
    print $client "HTTP/1.0 $status\r\nContent-Type: text/plain\r\n"
        . 'Content-Length: ' . length($body) . "\r\n\r\n$body";
    close $client;
}
