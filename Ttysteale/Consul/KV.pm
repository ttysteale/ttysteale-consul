package Ttysteale::Consul::KV;

use strict;
use warnings;

use JSON;
use Data::Dumper;
use HTTP::Request;

sub new {
    my %args = @_;
    my %ua_args = ();
    my $self = {};

    $self->{consul_server} = $args{consul_server} || 'localhost';
    $self->{proto} = $args{proto} || 'http';
    $self->{consul_port} = $args{port} || 8500;

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

sub _gen_url {
    my $self = shift;
    my $key  = shift;
 
    return $self->{proto} . '://' . $self->{consul_server} . ':' . $self->{consul_port} . '/v1/kv' . $key;
}

sub KVdelete {
    my $self = shift;
    my $key  = shift;
    
    die 'KVdelete: key required as first argument' unless defined $key;

    my $url = _gen_url($key);

    my $req = HTTP::Request->new(DELETE => $url);
    my $res = $ua->request($req);

    return $res;
}

sub KVget {}

sub KVput {}

1;
