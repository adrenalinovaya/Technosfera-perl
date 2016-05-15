use Mojolicious::Lite;

use Local::Hackathon::Client;
my $STATUS = 'done';

get '/' => {template => 'index'};

websocket '/ws' => sub {
  my ($c) = @_;

  $c->on(drain => sub {
    my ($c, $msg) = @_;

    eval {
        my $client = Local::Hackathon::Client->new(
          host => '192.168.0.65',
          port => '3456',
        );
        local $SIG{ALRM} = sub { die "TIMEOUT\n" };
        alarm(2);
        my $data = $client->take($STATUS);
	#$client->requeue($data->{id}, 'og', $data->{task}) if defined $data->{id};
	$client->release($data->{id}) if defined $data->{id} && $STATUS ne 'done';
	$client->ack($data->{id}) if defined $data->{id} && $STATUS eq 'done';
        alarm(0);
	if (exists $data->{task}){
		delete $data->{task}->{$_} for grep {!$data->{task}->{$_}} keys %{$data->{task}};
	}
	sleep(1) unless exists $data->{id};
        $c->send({json => (
            $data ? {data => $data} : {skip => 1}
        )}) if $data->{task};
    } or do {
        $c->send({json => {error => $@}});
    };
  });
};

app->start;

__DATA__

@@ index.html.ep
% my $url = url_for 'ws';

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>

<style>
div {
  margin: 10px;
  padding: 5px;
  float: left;
  width: 90%;
  display: none;
}

div.error {
  font-size: 4em;
  color: red;
}

span.green {
  margin: 10px;
  font-size: 2em;
  color: green;
}

span.red {
  margin: 10px;
  font-size: 3em;
  color: red;
}
</style>

<script>
$(document).ready(function() {
  var ws = new WebSocket('<%= $url->to_abs %>');
  ws.onmessage = function (event) {
    var data = JSON.parse(event.data);
    console.log(data);
    var result;
    var error;
    var skip;

    if (data['skip']) {
        skip = true;
    }
    else if (data['error']) {
      result = data['error'];
      error = true;
    }
    else {
      result = data['data'];
      error = false;
    }

    var div = $('<div class="ui-corner-all ui-widget-content"></div>');
    var fields = [
        'URL',
        'HTML',
	'og',
        'comments',
        'comments_info',
        'title',
        'links',
        'images',
    ];

    if (skip) {
        div.append('...');
    }
    else if (error) {
        div.addClass('error');
        div.append(result);
    }
    else {
      div.append('[' + result.id + '] ' + result.task.URL + '<br>');
      $.each(fields, function(index, field) {
        var status = $('<span>' + field + '</span>');
        if (field in result.task && result[field] !== '') {
          status.addClass('green');
        }
        else {
          status.addClass('red');
        }
        div.append(status);
      });
    }

    $(document.body).prepend(div);
    $(document.body).find('div').show('slide', '', 800);
  };
});
</script>

<body></body>
