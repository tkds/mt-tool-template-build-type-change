#!/usr/bin/perl
package MT::Tool::TemplateBuildTypeChange;
use Encode;
use strict;
use warnings;
use File::Spec;
use FindBin;
use lib map File::Spec->catdir( $FindBin::Bin, File::Spec->updir, $_ ), qw/lib extlib/;
use base qw( MT::Tool );

binmode(STDOUT, ":utf8");

sub usage { '--debug 1' }

sub help {
    return q {
        Description Foo.
        --debug 1
    };
}

my ( $debug, $blog_id, $build_type );

sub options {
    return (
        'debug=s'   => \$debug,
        'blog_id=s' => \$blog_id,
        'build_type=s' => \$build_type,
    );
}

sub main {
    my $class = shift;
    my ( $verbose ) = $class->SUPER::main( @_ );

    # perl template-build-type-change.pl --blog_id 1 --build_type 1
    # $build_type 0: 非公開 1: スタティック 2: 手動 

    if ( $blog_id && $build_type ) {
        my @tmpl = MT->model('template')->load({ blog_id => $blog_id, type => ["index", "individual", "archive"] });
        
        foreach my $t (@tmpl) {
            print $t->name. ":". $t->build_type ."\n";
            $t->build_type($build_type);
            $t->save()
                or die $t->errstr;
            print "build_type changed -> ". $t->name. ":". $t->build_type ."\n";
        }
    }

    if ( $debug ) {
        print 'Some debug message.' ."\n";
    }

    1;
}

__PACKAGE__->main() unless caller;
