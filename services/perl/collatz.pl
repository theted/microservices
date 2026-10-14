# One hailstone step in Perl.
use strict;
use warnings;

sub step { my $n = shift; $n % 2 ? 3 * $n + 1 : $n / 2 }

chomp(my $n = <STDIN>);
print step($n), "\n";
