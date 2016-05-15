=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
use feature qw(switch say state);
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub evaluate {
	my $rpn = shift;
		return '' unless @$rpn;
		my @stack;
		for (@$rpn) {
				# say "'$_' - [@stack]";
			given ($_) {
				when ('U+') { }
				when ('U-') { push @stack, -pop(@stack) }
				when ('+')  { push @stack, pop(@stack) + pop @stack }
				when ('-')  { push @stack, - pop(@stack) + pop @stack }
				when ('*')  { push @stack, pop(@stack) * pop @stack }
				when ('/')  { push @stack, do { my ($x,$y) = splice @stack,-2,2; $x/$y } }
				when ('^')  { push @stack, do { my ($x,$y) = splice @stack,-2,2; $x**$y } }
				default     { push @stack, $_ }  # number
			}
		}
		return 0+pop @stack;

}

1;
