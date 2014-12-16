package Ttysteale::Consul::KV;

use strict;
use warnings;

use JSON;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    my %args = @_;
    my %ua_args = ();


    $self->{consul_server} = $args{consul_server} || 'localhost';
    $self->{proto} = $args{proto} || 'http';
    $self->{consul_port} = $args{port} || 8500;
    $self->{prefix} = $args{prefix} || '/';

    $ua_args{ssl_opts} = $args{ssl_opts} if $args{ssl_opts};
    $self->{ua} = LWP::UserAgent->new(%ua_args);

    return $self;

}

sub _send_req {
    my $self = shift;
    my $req  = shift;
    my %req_params = @_;
    
    my $ret = $self->{ua}->request($req, %req_params);
    
    if (not defined($ret->is_success)) { return $ret->status_code }

    return 0;
}

sub gen_url {
    my $self = shift;
    my $key  = shift;

    return $self->{proto} . '://' . $self->{consul_server} . ':' . $self->{consul_port} . '/v1/kv' . $self->{prefix} . $key;
}

sub KVdelete {
    my $self = shift;
    my $key  = shift;
    
    die 'KVdelete: key required as first argument' unless defined $key;

    my $url = $self->gen_url($key);

    my $res = $self->_send_req(
	    HTTP::Request::Common::_simple_req(
                'DELETE',
		$url
            )
	);

    return $res;
}

sub KVget {
    my $self = shift;
    my $key = shift;
    my %args = @_;

    die 'KVget: key required as first argument' unless defined $key;
  
    my @entries = ();

    eval {
        my $url = $self->gen_url($key);
        my $res = $self->_send_req(GET $url);
        my $content = $res->content;
        my $values = JSON::decode_json($content);
        @entries = @$values;
    };

    my @ret;
    foreach my $entry (@entries) {
        $entry->{Value} = MIME::Base64::decode_base64($entry->{Value});
	my $value;
	eval {
            $value = JSON::decode_json($entry->{Value});
	};
	$value = $entry->{Value} unless $value;
	$entry->{Value} = $value;
	push @ret, $entry;
    }

    return @ret;

}

sub KVput {
    my $self = shift;
    my $key = shift;
    my $value = shift;

    die 'KVput: key required as first argument' unless defined $key;
    die 'KVput: value required as sec argument' unless defined $value;

    $value = JSON::encode_json($value);

    my $res = $self->_send_req(PUT $self->gen_url($key), Content => $value);
    return $res;

}

1;
