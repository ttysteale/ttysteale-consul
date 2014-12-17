use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Ttysteale::Consul',
    AUTHOR              => q{Sam Teale <sam_teale@trendmicro.co.uk>},
    VERSION_FROM        => 'lib/Ttysteale/Consul.pm',
    ABSTRACT_FROM       => 'lib/Ttysteale/Consul.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Ttysteale-Consul-*' },
);
