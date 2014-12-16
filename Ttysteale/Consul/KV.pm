package Ttysteale::Consul::KV;

use strict;
use warnings;

use JSON;
use Data::Dumper;

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
    
    if (not defined($ret->is_success)) { return 'http request failed with ' . 
$ret->status_line; }

    return 0;
}

sub KVdelete {

    

}

sub KVget {}

sub KVput {}

1;
