package Ttysteale::Consul::KV;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Ttysteale::Consul::KV ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

use JSON;
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
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Ttysteale::Consul::KV - Perl extension for KV Consul API

=head1 SYNOPSIS

  use Ttysteale::Consul::KV;
  

=head1 DESCRIPTION

Ttysteale::Consul::KV - Perl extension for KV Consul API

=head1 SEE ALSO

Consul Documentation E<lt>http://www.consul.io/docs/agent/http.htmlE<gt>

=head1 AUTHOR

Sam Teale, E<lt>sam_teale@trendmicro.co.ukE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
