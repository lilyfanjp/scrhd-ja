#!/usr/bin/perl -w

use strict;
use Encode;
local $_;

my $wave_dash = hex("301C");
my $fillwidth_tild = hex("FF5E");

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
			$encoding = $wave_dash if ($encoding == $fillwidth_tild);
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
	printf("0x%08X: [%s], #%s:%s\n", $encoding, join(",\n", @glyph), $startchar, encode('utf-8', $char));
	if ($encoding == $wave_dash) {
		my $grif = join(",\n", @glyph);
		$grif =~ s/0xff/0x7f/mg;
		printf("0x%08X: [%s], #%s:%s\n", $fillwidth_tild, $grif, $startchar, encode('utf-8', chr($fillwidth_tild)));
	}
}
print "}\nwidth = 7\nheight = 7\n";

