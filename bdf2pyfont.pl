#!/usr/bin/perl -w

use strict;
use Encode;
local $_;

print "data = {\n";
while ($_ = <>) {
	chomp;
	next unless /^STARTCHAR /;
	my $encoding = 0;
	my @bitmap = ();
	while ($_ = <>) {
		chomp;
		if (/^ENCODING (\d+)/) {
			$encoding = $1;
		}
		if (/^BITMAP/) {
			for (my $i = 0 ; $i < 8 ; $i++) {
				$_ = <>;
				chomp;
				push @bitmap, hex($_);
			}
		}
		last if (/^ENDCHAR/);
	}
	if ($encoding == 0) {
		print STDERR "No BITMAP found!\n";
		next;
	}
	my $char = chr($encoding);
	my $last = pop(@bitmap);
	if ($last != 0) {
		printf(STDERR "No clear line at bottom: %s\n", encode('utf-8', $char));
	}
	my @lines = ();
	foreach (@bitmap) {
		my @bits = ();
		if ($_ % 2) {
			print(STDERR "LSB found: %X at %s\n", $_, encode('utf-8', $char));
		}
		$_ >>= 1;
		for (my $i = 0 ; $i < 7 ; $i++) {
			unshift @bits, ($_ % 2 ? '0xff' : '0x00');
			$_ >>= 1;
		}
		push @lines, sprintf("[%s]", join(",", @bits));
	}
	printf("0x%08X: [%s], #%s\n", $encoding, join(",\n", @lines), encode('UTF-8', $char));
}
print "width = 7\nheight = 7\n";

