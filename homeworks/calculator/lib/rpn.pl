=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
use feature qw(switch say state);
use DDP;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";
our %prio = (
	'U-' => 4,
	'U+' => 4,

	'^' => 4,

	'*' => 2,
	'/' => 2,
	'+' => 1,
	'-' => 1,

	'(' => 0,
	')' => 0,
	'.' => 0,
);

our %unary = (
	'U-' => 1,
	'U+' => 1,
);

our %assoc = (
	'U-' => 'R',
	'U+' => 'R',
	'^'  => 'R',
	'*'  => 'L',
	'/'  => 'L',
	'+'  => 'L',
	'-'  => 'L',
);


sub rpn {
	my $exp = shift;
	my $source = tokenize($exp);
	push @$source, ".";

	p $source;
	my $nums = 0;
	my $ops = 0;

	my @stack;
	my @rpn;
	while (@$source) {
		my $sym = shift @$source;
		{
			given ($sym) {
				when ('(') {
					push @stack, $sym;
				}
				when (')') {
					while () {
						die "Unbalanced" unless @stack;
						my $pick = pop @stack;
						if ($pick eq '(') {
							last;
						} else {
							push @rpn,$pick;
						}
					}
				}
				when ('.') {
					push @rpn,pop @stack while @stack;
				}
				when (['^','+','-','*','/','U+','U-']) {
					while (@stack and
						$assoc{$sym} eq 'R'
							? $prio{$sym} <  $prio{ $stack[-1] }
							: $prio{$sym} <= $prio{ $stack[-1] }
					) {
						++$ops unless $unary{$stack[-1]};
						die "Bad expression" if $ops > $nums-1;
						push @rpn,pop @stack;
					}
					push @stack, $sym;
				}
				default {
					if (@rpn and !@stack) {
						die "Sequence of numbers";
					}
					++$nums;
					push @rpn, $sym;
				}
			}
		}
	}
	die "Stack left" if @stack;
	return \@rpn;
}


1;
