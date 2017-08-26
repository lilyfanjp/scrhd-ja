#!/usr/bin/perl -w

use strict;
use Encode;
local $_;

print "# -*- coding: utf-8 -*-\ndata = {\n";
while (<>) {
	chomp;
	next unless /^STARTCHAR/;
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
	if ($encoding == 0) {
		print STDERR "No BITMAP found!\n";
		next;
	}
	my $char = chr($encoding);
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
	printf("0x%08X: [%s], #%s\n", $encoding, join(",\n", @glyph), encode('utf-8', $char));
}
print "width = 7\nheight = 7\n";

