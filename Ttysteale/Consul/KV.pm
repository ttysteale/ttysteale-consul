package Ttysteale::Consul::KV;

use strict;
use warnings;

use JSON;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use HTTP::Request::Common;

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

    print $key;

    return $self->{proto} . '://' . $self->{consul_server} . ':' . $self->{consul_port} . '/v1/kv' . $self->{prefix} . $key;
}

sub KVdelete {
    my $self = shift;
    my $key  = shift;
    
    die 'KVdelete: key required as first argument' unless defined $key;

    my $url = gen_url($key);

    my $res = $self->_send_req(
	    HTTP::Request::Common::_simple_req(
                'DELETE',
		$url
            )
	);

    return $res;
}

sub KVget {}

sub KVput {}

1;
