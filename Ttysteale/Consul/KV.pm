package Ttysteale::Consul::KV;

use strict;
use warnings;

use JSON;
use Data::Dumper;

sub new {

    my %args = @_;
    $self->{consul_server} = $args{consul_server} || 'localhost';
    $self->{proto} = $args{proto} || 'http';
    $self->{consul_port} = $args{port} || 8500;

    my %ua_args = ();
    $ua_args{ssl_opts} = $args{ssl_opts} if $args{ssl_opts};
    $self->{ua} = LWP::UserAgent->new(%ua_args);

    return $self;

}


