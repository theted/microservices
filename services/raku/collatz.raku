# One hailstone step in Raku (née Perl 6), with a socket from the core language.
sub step(Int $n --> Int) { $n %% 2 ?? $n div 2 !! 3 * $n + 1 }

my $server = IO::Socket::INET.new(:listen, :localhost<0.0.0.0>, :localport(8000));
say "Raku is listening on :8000";

loop {
    my $client = $server.accept;
    my $request = $client.get // '';
    while ($client.get // '') ne '' { }

    my ($status, $body) = $request ~~ / <[?&]> 'n=' (\d+) <[\ &]> / && +$0 > 0
        ?? ('200 OK', ~step(+$0))
        !! ('400 Bad Request', 'need ?n=<positive integer>');
    $client.print: "HTTP/1.0 $status\r\nContent-Type: text/plain\r\nContent-Length: {$body.encode.bytes}\r\n\r\n$body";
    $client.close;
}
