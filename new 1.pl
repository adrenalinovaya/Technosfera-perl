package Local::GetterSetter;

use strict;
use warnings;

my $x = 0;

sub import { 
my @vars = 0;  }

{
    package Local::SomePackage;
	our $x
    use Local::GetterSetter qw(x y);

    set_x(50);
    print our $x; # 50

    our $y = 42;
    print get_y(); # 42
    set_y(11);
    print get_y(); # 11
}



 {
     package Some::Package;
	 our $var = 500;
	 our @var = (1,2,3);
	 our %func = (1 => 2, 3 => 4);
	 sub func {return 400}
}

use Data::Dunmer;
print Dumper #%Some::Package::;

$VAR1 = {
		'var' => *Some::Package::var,
		'func'=> *Some::Package::func
        }; 

Some::Package::func = sub {}
1;
