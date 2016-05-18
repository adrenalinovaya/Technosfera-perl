package Local::App::GenCalc;

use strict;
use IO::Socket;

$SIG{ALRM} = sub {
    Local::App::GenCalc::new_one();
};


my $file_path = 'D:\Perl\Technosfera-perl-master_new\Technosfera-perl-master\homeworks\multi_worker\calcs.txt';

sub new_one {
    # Функция вызывается по таймеру каждые 100
    my $new_row = join $/, int(rand(5)).' + '.int(rand(5)), 
                  int(rand(2)).' + '.int(rand(5)).' * '.int(int(rand(10))), 
                  '('.int(rand(10)).' + '.int(rand(8)).') * '.int(rand(7)), 
                  int(rand(5)).' + '.int(rand(6)).' * '.int(rand(8)).' ^ '.int(rand(12)), 
                  int(rand(20)).' + '.int(rand(40)).' * '.int(rand(45)).' ^ '.int(rand(12)), 
                  (int(rand(12))/(int(rand(17))+1)).' * ('.(int(rand(14))/(int(rand(30))+1)).' - '.int(rand(10)).') / '.rand(10).'.0 ^ 0.'.int(rand(6)),  
                  int(rand(8)).' + 0.'.int(rand(10)), 
                  int(rand(10)).' + .5',
                  int(rand(10)).' + .5e0',
                  int(rand(10)).' + .5e1',
                  int(rand(10)).' + .5e+1', 
                  int(rand(10)).' + .5e-1', 
                  int(rand(10)).' + .5e+1 * 2';
    print "new_row " . $new_row;
	# Далее происходить запись в файл очередь
	
	open(my $fh, '>>', $file_path) or die "Не могу открыть '$file_path' $!";
    print $fh $new_row;
	close($fh);
    return;
}

#Определение обрабатываемых сигналов
#$SIG{INT} = sub{exit};#\&prog;
                                                                                                                                     
#sub prog {
#  $SIG{INT} = \&prog;
#  my $signame = shift;
#  die "прерывание по Ctrl+c SIG $signame";
#}

sub start_server {

    # На вход приходит номер порта который будет слушат сервер для обработки запросов на получение данных
    my $port = shift;
	
	print "port " . $port;
	
    # Создание сервера и обработка входящих соединений, форки не нужны 
    # Входящее сообщение это 2-х байтовый инт (кол-во сообщений которое надо отдать в ответ)
    # Исходящее сообщение: ROWS_CNT ROW; ROW := ROW [ROW]; ROW := LEN MESS; LEN - 4-х байтовый инт; MESS - сообщение указанной длины

	my $server = IO::Socket::INET->new(
		  LocalPort => $port,
		  Type      => SOCK_STREAM,
		  ReuseAddr => 1,
		  Listen    => 10) 
	or die "Can't create server on port $port : $@ $/";

	 alarm(100);
	 while(my $client = $server->accept()){
	 # #$client->autoflush(1);
		  alarm(0);
		  my $msg_len;
		  if (sysread($client, $msg_len, 2) == 2){
			  my $limit = unpack 'S', $msg_len;
			  my $ex = Local::App::GenCalc::get($limit);
			  syswrite($client, pack('L', scalar($ex)), 4);
			  while (@$ex) {
				  syswrite($client, pack('v/a*', $_));
			  }
		  }
		  close( $client );
		  alarm(100);
	 }
	 close( $server );
}

sub get {
    # На вход получаем кол-во запрашиваемых сообщений
    my $limit = shift;
	
    # Открытие файла, чтение N записей
	open(my $fh_,'<',$file_path) or die "Не могу открыть '$file_path' $!";
	my $ret = [];
	my $i = 0;
	while (my $row = <$fh_>) {
		$ret[$i] = $row;
		#print "$row\n";
		$i++;
		last if ($i=$limit);
	}
    # Надо предусмотреть, что файла может не быть, а так же в файле может быть меньше сообщений чем запрошено
     # Возвращаем ссылку на массив строк

    return $ret;
}

END{
#close($fh);
#unlink($fh);
}

1;


#-r -w -x чтение запись исполнение -o принадлежность файла пользователю -e существование -z файл ненулевой длины -s Размер файла -f,-d,-l,-S,-p файл каталог ссылка сокет канал
#my $fname = 'file.txt';
#my $fh;
#if (-e $fname and -f $fname and -r $fname and !-z $fname) {open($fh,'<',$fname) or die $!;}

# my $temp_directory = "/tmp/myprog.$$"; # Каталог для временных файлов
# mkdir $temp_directory, 0700 or die "Cannot create $temp_directory: $!";
# sub clean_up {
# unlink glob "$temp_directory/*";
# rmdir $temp_directory;
# }
# sub my_int_handler {
# &clean_up;
# die "interrupted, exiting...\n";
# }
# $SIG{'INT'} = 'my_int_handler';
# .
# . # Время идет, программа работает, в каталоге создаются
# . # временные файлы. Потом кто-то нажимает Control-C.
# .
# # Конец нормального выполнения
# &clean_up;
# my $int_count;
# sub my_int_handler { $int_count++ }
# $SIG{'INT'} = 'my_int_handler';
# ...
# $int_count = 0;
# while (<SOMEFILE>) {
# ... Обработка в течение нескольких секунд ...
# if ($int_count) {
# # Получен сигнал прерывания !
# print "[processing interrupted...]\n";
# last;
# }
# }
                                                                                                                                    
# $SIG{INT} = \&prog;
                                                                                                                                     
# sub prog {
  # $SIG{INT} = \&prog;
  # my $signame = shift;
  
  # die "перывание по Ctrl+c SIG $signame";
# }
                                                                                                                                     
# while (<STDIN>){
  # print "$_ ";
# }
                                                                                                                                     

# вот как ALRM (ожидание по таймауту) обрабатывать(программа, реализующая функции будильника):

# #!/usr/bin/perl -w
                                                                                                                                     
# use strict;
                                                                                                                                     
# $SIG{ALRM}= sub{die "timeout"};
                                                                                                                                     
# eval{
  # alarm(5); # можно спать 5 секунд, или поставить число 7200 = 2 часа.
  # while (1){
    # sleep 1;
    # print "sleeping... ";
  # }
# };
                                                                                                                                     
# if($@ and $@=~/timeout/){
  # print "music \n";
  # qx[play vstavaj.mp3];
  # qx[play vstavaj.mp3];
  # qx[play vstavaj.mp3];
  # qx[play vstavaj.mp3];
  # qx[play vstavaj.mp3];
# }

   # eval {
        # local $SIG{ALRM} = sub { die "alarm clock restart" };
        # alarm 10;
        # flock(FH, 2);   # блокирующая операция, запрос блокировки на запись
        # alarm 0;
    # };
    # if ($@ and $@ !~ /alarm clock restart/) { die }


	   # local $SIG{ALRM} = sub { die "alarm" };
# попробуйте что-нибудь вроде:

    # use POSIX qw(SIGALRM);
    # POSIX::sigaction(SIGALRM,
                     # POSIX::SigAction->new(sub { die "alarm" }))
          # or die "Ошибка в установке обработчика SIGALRM: $!\n";
		  
 # my $ALARM_EXCEPTION = "alarm clock restart";
    # eval {
        # local $SIG{ALRM} = sub { die $ALARM_EXCEPTION };
        # alarm 10;
        # flock(FH, 2)    # blocking write lock
                        # || die "cannot flock: $!";
        # alarm 0;
    # };
    # if ($@ && $@ !~ quotemeta($ALARM_EXCEPTION)) { die }		  
		  
		  
	# open DATA, "text/news/$year/$mon.news" || die "404";

     # while (<DATA>) {
           # chomp;
           # ($chislo, $vremya, $id,$link,$author,$title,$text) = split(/::/); 
           # print ("$chislo\n");
           # ++$i;
     # }	  
	 # last if ($i>5);
	 # for ($i=0;$i<$N;&i++) {
	 # print "$i ";}
