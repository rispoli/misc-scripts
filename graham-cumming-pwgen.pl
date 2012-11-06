# http://blog.jgc.org/2010/12/write-your-passwords-down.html

use strict;
use warnings;

use Crypt::Random qw(makerandom_itv);
use HTML::Entities;

print "<pre>\n  ";
print join( ' ', ('A'..'Z') );
print "\n +-", '--' x 25, "\n";

foreach my $x ('A'..'Z') {
	print "$x|";
	foreach my $y (0..25) {
		print encode_entities(
			chr(makerandom_itv( Strength => 1,
					Uniform  => 1,
					Lower    = >ord('!'),
					Upper    => ord('~')))), ' ';
	}
	print "\n";
}
print '</pre>';
