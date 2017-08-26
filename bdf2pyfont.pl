#!/usr/bin/perl -w

use strict;
use Encode;
local $_;

print "# -*- coding: utf-8 -*-\ndata = {\n";
while ($_ = <>) {
	chomp;
	next unless /^STARTCHAR/;
	my $encoding = 0;
	my @bitmap = ();
	CHAR: while ($_ = <>) {
		chomp;
		if (/^ENCODING (\d+)/) {
			$encoding = $1;
		}
		next unless /^BITMAP/;
		while ($_ = <>) {
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
	for (my $i = 0 ; $i < $#bitmap ; $i++) {
		my $bits = $bitmap[$i];
		my @line = ();
		if ($bits % 2) {
			printf(STDERR "LSB found at line %d of %s: %02X\n", $i, encode('utf-8', $char), $bits);
		}
		$bits >>= 1;
		for (my $j = 0 ; $j < 7 ; $j++) {
			unshift @line, ($bits % 2 ? '0xff' : '0x00');
			$bits >>= 1;
		}
		push @glyph, sprintf('[%s]', join(',', @line));
	}
	printf("0x%08X: [%s], #%s\n", $encoding, join(",\n", @glyph), encode('utf-8', $char));
}
print "width = 7\nheight = 7\n";

