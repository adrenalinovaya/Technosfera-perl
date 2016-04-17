=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
use DDP;
use feature qw(switch say state);

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub tokenize {
	chomp(my $expr = shift);
	my @res;
	my $num = 0;
	my $oper    = 1;
	my $unar  = 0;
	my @source = split m{((?<!e)[-+]|[()/*^]|\s+)}, $expr;
    p @source;
	for (@source) {
		given ($_) {
			when (/\d/) {
				die "Sequence of numbers" if $num++;
				undef $oper;
				undef $unar;
				if (/^(\d+(\.\d*)?|\.\d+)([eE][+-]?\d*)?$/) {
					push @res, 0+$_;
				} else {
					die "Incorrect number: $_";
				}
			}
			when (/^\s*$/) {}
			when ('(') {
				die "$_ in incorrect place" unless $oper;
				push @res, $_;
			}
			when (')') {
				die "$_ after operator" if $oper or $unar;
				push @res, $_;
			}
			when (['-','+']) {
				if ($num) {
					continue;
				} else {
					$unar = 1;
					push @res, "U$_";
				}
			}
			when (m{[-+*/^]}) {
				die "Several ops" if $oper++;
				undef $num;
				push @res, $_;
			}
			default {
				die "Bad symbol '$_'";
			}
		}
	}
	die "No number after unary" if $unar;
	die "No number after operator" if $oper;

	return \@res;

}

1;
