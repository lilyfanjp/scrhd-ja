#!/usr/bin/perl -w

use strict;
use Encode;
## use Encode::JIS2K;
local $_;

print "# -*- coding: utf-8 -*-\ndata = {\n";
while (<>) {
	chomp;
	next unless /^STARTCHAR ([a-fA-F\d]+)/;
	my $startchar = $1;
	my $encoding = 0;
	my @bitmap = ();
	CHAR: while (<>) {
		chomp;
		if (/^ENCODING (\d+)/) {
			$encoding = $1;
		}
		next unless /^BITMAP/;
		while (<>) {
			chomp;
			last CHAR if /^ENDCHAR/;
			push @bitmap, hex($_);
		}
	}
	if ($encoding == 0 || scalar(@bitmap) < 1) {
		print STDERR "No BITMAP found!\n";
		next;
	}
	my $jis_char = chr(int($encoding / 256)) . chr($encoding % 256);
	my $char = decode('jis0208-raw', $jis_char);
##	my $char = decode('jis0213-1-raw', $jis_char);
	if (pop(@bitmap)) {
		printf(STDERR "No clear bottom line at %s\n", encode('utf-8', $char));
	}
	my @glyph = ();
	foreach (@bitmap) {
		my @line = ();
		if ($_ % 2) {
			printf(STDERR "LSB found at %s: %02X\n", encode('utf-8', $char), $_);
		}
		$_ >>= 1;
		for (my $j = 0 ; $j < 7 ; $j++) {
			unshift @line, ($_ % 2 ? '0xff' : '0x00');
			$_ >>= 1;
		}
		push @glyph, sprintf('[%s]', join(',', @line));
	}
	printf("0x%08X: [%s], #%s:%s\n", ord($char), join(",\n", @glyph), $startchar, encode('utf-8', $char));
}
print "}\nwidth = 7\nheight = 7\n";

