#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.05';   # automatically generated file
$DATE = '2004/05/11';


##### Demonstration Script ####
#
# Name: SVDmaker.d
#
# UUT: ExtUtils::SVDmaker
#
# The module Test::STDmaker generated this demo script from the contents of
#
# t::ExtUtils::SVDmaker::SVDmaker 
#
# Don't edit this test script file, edit instead
#
# t::ExtUtils::SVDmaker::SVDmaker
#
#	ANY CHANGES MADE HERE TO THIS SCRIPT FILE WILL BE LOST
#
#       the next time Test::STDmaker generates this script file.
#
#

######
#
# The working directory is the directory of the generated file
#
use vars qw($__restore_dir__ @__restore_inc__ );

BEGIN {
    use Cwd;
    use File::Spec;
    use FindBin;
    use Test::Tech qw(demo is_skip plan skip_tests tech_config );

    ########
    # The working directory for this script file is the directory where
    # the test script resides. Thus, any relative files written or read
    # by this test script are located relative to this test script.
    #
    use vars qw( $__restore_dir__ );
    $__restore_dir__ = cwd();
    my ($vol, $dirs) = File::Spec->splitpath($FindBin::Bin,'nofile');
    chdir $vol if $vol;
    chdir $dirs if $dirs;

    #######
    # Pick up any testing program modules off this test script.
    #
    # When testing on a target site before installation, place any test
    # program modules that should not be installed in the same directory
    # as this test script. Likewise, when testing on a host with a @INC
    # restricted to just raw Perl distribution, place any test program
    # modules in the same directory as this test script.
    #
    use lib $FindBin::Bin;

    unshift @INC, File::Spec->catdir( cwd(), 'lib' ); 

}

END {

    #########
    # Restore working directory and @INC back to when enter script
    #
    @INC = @lib::ORIG_INC;
    chdir $__restore_dir__;

}

print << 'MSG';

~~~~~~ Demonstration overview ~~~~~
 
The results from executing the Perl Code 
follow on the next lines as comments. For example,

 2 + 2
 # 4

~~~~~~ The demonstration follows ~~~~~

MSG

demo( "\ \ \ \ use\ vars\ qw\(\$loaded\)\;\
\ \ \ \ use\ File\:\:Glob\ \'\:glob\'\;\
\ \ \ \ use\ File\:\:Copy\;\
\ \ \ \ use\ File\:\:Path\;\
\ \ \ \ use\ File\:\:Spec\;\
\
\ \ \ \ use\ File\:\:Package\;\
\ \ \ \ use\ File\:\:SmartNL\;\
\ \ \ \ use\ Text\:\:Scrub\;\
\
\ \ \ \ my\ \$loaded\ \=\ 0\;\
\ \ \ \ my\ \$snl\ \=\ \'File\:\:SmartNL\'\;\
\ \ \ \ my\ \$fp\ \=\ \'File\:\:Package\'\;\
\ \ \ \ my\ \$s\ \=\ \'Text\:\:Scrub\'\;\
\ \ \ \ my\ \$w\ \=\ \'File\:\:Where\'\;\
\ \ \ \ my\ \$fs\ \=\ \'File\:\:Spec\'\;"); # typed in command           
          use vars qw($loaded);
    use File::Glob ':glob';
    use File::Copy;
    use File::Path;
    use File::Spec;

    use File::Package;
    use File::SmartNL;
    use Text::Scrub;

    my $loaded = 0;
    my $snl = 'File::SmartNL';
    my $fp = 'File::Package';
    my $s = 'Text::Scrub';
    my $w = 'File::Where';
    my $fs = 'File::Spec';; # execution

print << "EOF";

 ##################
 # UUT not loaded
 # 
 
EOF

demo( "\$fp\-\>is_package_loaded\(\'ExtUtils\:\:SVDmaker\'\)", # typed in command           
      $fp->is_package_loaded('ExtUtils::SVDmaker')); # execution


print << "EOF";

 ##################
 # Load UUT
 # 
 
EOF

demo( "my\ \$errors\ \=\ \$fp\-\>load_package\(\ \'ExtUtils\:\:SVDmaker\'\ \)"); # typed in command           
      my $errors = $fp->load_package( 'ExtUtils::SVDmaker' ); # execution

demo( "\$errors", # typed in command           
      $errors # execution
) unless     $loaded; # condition for execution                            

demo( "\ \ \ \ \#\#\#\#\#\#\
\ \ \ \ \#\ Add\ the\ SVDmaker\ test\ lib\ and\ test\ t\ directories\ onto\ \@INC\
\ \ \ \ \#\
\ \ \ \ unshift\ \@INC\,\ File\:\:Spec\-\>catdir\(\ cwd\(\)\,\ \'t\'\)\;\
\ \ \ \ unshift\ \@INC\,\ File\:\:Spec\-\>catdir\(\ cwd\(\)\,\ \'lib\'\)\;\
\ \ \ \ rmtree\(\ \'t\'\ \)\;\
\ \ \ \ rmtree\(\ \'lib\'\ \)\;\
\ \ \ \ mkpath\(\ \'t\'\ \)\;\
\ \ \ \ mkpath\(\ \'lib\'\ \)\;\
\ \ \ \ mkpath\(\ \$fs\-\>catfile\(\ \'t\'\,\ \'Test\'\ \)\)\;\
\ \ \ \ mkpath\(\ \$fs\-\>catfile\(\ \'t\'\,\ \'Data\'\ \)\)\;\
\ \ \ \ mkpath\(\ \$fs\-\>catfile\(\ \'t\'\,\ \'File\'\ \)\)\;\
\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'SVDtest0A\.pm\'\)\,\$fs\-\>catfile\(\'lib\'\,\'SVDtest1\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'module0A\.pm\'\)\,\$fs\-\>catfile\(\'lib\'\,\'module1\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'SVDtest0A\.t\'\)\,\$fs\-\>catfile\(\'t\'\,\'SVDtest1\.t\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'SVDtest0A\.t\'\)\,\$fs\-\>catfile\(\'t\'\,\'SVDtest1\.t\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'Test\'\,\'Tech\.pm\'\)\,\$fs\-\>catfile\(\'t\'\,\'Test\'\,\'Tech\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'Data\'\,\'Startup\.pm\'\)\,\$fs\-\>catfile\(\'t\'\,\'Data\'\,\'Startup\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'Data\'\,\'Secs2\.pm\'\)\,\$fs\-\>catfile\(\'t\'\,\'Data\'\,\'Secs2\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'Data\'\,\'SecsPack\.pm\'\)\,\$fs\-\>catfile\(\'t\'\,\'Data\'\,\'SecsPack\.pm\'\)\)\;\
\ \ \ \ copy\ \(\$fs\-\>catfile\(\'expected\'\,\'File\'\,\'Package\.pm\'\)\,\$fs\-\>catfile\(\'t\'\,\'File\'\,\'Package\.pm\'\)\)\;\
\
\ \ \ \ rmtree\ \'packages\'\;"); # typed in command           
          ######
    # Add the SVDmaker test lib and test t directories onto @INC
    #
    unshift @INC, File::Spec->catdir( cwd(), 't');
    unshift @INC, File::Spec->catdir( cwd(), 'lib');
    rmtree( 't' );
    rmtree( 'lib' );
    mkpath( 't' );
    mkpath( 'lib' );
    mkpath( $fs->catfile( 't', 'Test' ));
    mkpath( $fs->catfile( 't', 'Data' ));
    mkpath( $fs->catfile( 't', 'File' ));

    copy ($fs->catfile('expected','SVDtest0A.pm'),$fs->catfile('lib','SVDtest1.pm'));
    copy ($fs->catfile('expected','module0A.pm'),$fs->catfile('lib','module1.pm'));
    copy ($fs->catfile('expected','SVDtest0A.t'),$fs->catfile('t','SVDtest1.t'));
    copy ($fs->catfile('expected','SVDtest0A.t'),$fs->catfile('t','SVDtest1.t'));
    copy ($fs->catfile('expected','Test','Tech.pm'),$fs->catfile('t','Test','Tech.pm'));
    copy ($fs->catfile('expected','Data','Startup.pm'),$fs->catfile('t','Data','Startup.pm'));
    copy ($fs->catfile('expected','Data','Secs2.pm'),$fs->catfile('t','Data','Secs2.pm'));
    copy ($fs->catfile('expected','Data','SecsPack.pm'),$fs->catfile('t','Data','SecsPack.pm'));
    copy ($fs->catfile('expected','File','Package.pm'),$fs->catfile('t','File','Package.pm'));

    rmtree 'packages';; # execution

demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\'lib\'\,\ \'module1\.pm\'\)\)", # typed in command           
      $snl->fin( File::Spec->catfile('lib', 'module1.pm'))); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\'lib\'\,\ \'SVDtest1\.pm\'\)\)", # typed in command           
      $snl->fin( File::Spec->catfile('lib', 'SVDtest1.pm'))); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\'t\'\,\ \'SVDtest1\.t\'\)\)", # typed in command           
      $snl->fin( File::Spec->catfile('t', 'SVDtest1.t'))); # execution


demo( "\ \ \ \ unlink\ \'SVDtest1\.log\'\;\
\ \ \ \ no\ warnings\;\
\ \ \ \ open\ SAVE_OUT\,\ \"\>\&STDOUT\"\;\
\ \ \ \ open\ SAVE_ERR\,\ \"\>\&STDERR\"\;\
\ \ \ \ use\ warnings\;\
\ \ \ \ open\ STDOUT\,\'\>\ SVDtest1\.log\'\;\
\ \ \ \ open\ STDERR\,\ \"\>\&STDOUT\"\;\
\ \ \ \ my\ \$svd\ \=\ new\ ExtUtils\:\:SVDmaker\(\ \)\;\
\ \ \ \ my\ \ \$success\ \=\ \$svd\-\>vmake\(\ \{pm\ \=\>\ \'SVDtest1\'\}\ \)\;\
\ \ \ \ close\ STDOUT\;\
\ \ \ \ close\ STDERR\;\
\ \ \ \ open\ STDOUT\,\ \"\>\&SAVE_OUT\"\;\
\ \ \ \ open\ STDERR\,\ \"\>\&SAVE_ERR\"\;\
\ \ \ \ my\ \$output\ \=\ \$snl\-\>fin\(\ \'SVDtest1\.log\'\ \)\;"); # typed in command           
          unlink 'SVDtest1.log';
    no warnings;
    open SAVE_OUT, ">&STDOUT";
    open SAVE_ERR, ">&STDERR";
    use warnings;
    open STDOUT,'> SVDtest1.log';
    open STDERR, ">&STDOUT";
    my $svd = new ExtUtils::SVDmaker( );
    my  $success = $svd->vmake( {pm => 'SVDtest1'} );
    close STDOUT;
    close STDERR;
    open STDOUT, ">&SAVE_OUT";
    open STDERR, ">&SAVE_ERR";
    my $output = $snl->fin( 'SVDtest1.log' );; # execution

demo( "\$output", # typed in command           
      $output); # execution


print << "EOF";

 ##################
 # All tests successful
 # 
 
EOF

demo( "\$output\ \=\~\ \/All\ tests\ successful\/", # typed in command           
      $output =~ /All tests successful/); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )); # execution


print << "EOF";

 ##################
 # generated SVD POD
 # 
 
EOF

demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )); # execution


print << "EOF";

 ##################
 # generated packages SVD POD
 # 
 
EOF

demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'MANIFEST\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )); # execution


print << "EOF";

 ##################
 # generated MANIFEST
 # 
 
EOF

demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'Makefile\.PL\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )); # execution


print << "EOF";

 ##################
 # generated Makefile.PL
 # 
 
EOF

demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'README\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))); # execution


print << "EOF";

 ##################
 # generated README
 # 
 
EOF

demo( "\$s\-\>scrub_architect\(\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\.ppd\'\ \)\ \)\)\)", # typed in command           
      $s->scrub_architect($s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) )))); # execution


print << "EOF";

 ##################
 # generated ppd
 # 
 
EOF

demo( "\-e\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\.tar\.gz\'\ \)", # typed in command           
      -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )); # execution


print << "EOF";

 ##################
 # generated distribution
 # 
 
EOF

demo( "\ \ \ \ skip_tests\(0\)\;\
\
\ \ \ \ \#\#\#\#\#\#\#\
\ \ \ \ \#\ Freeze\ version\ based\ on\ previous\ version\
\ \ \ \ \#\
\ \ \ \ unlink\ File\:\:Spec\-\>catfile\(\'t\'\,\'SVDtest1\.t\'\)\;\
\ \ \ \ unlink\ File\:\:Spec\-\>catfile\(\'lib\'\,\'SVDtest1\.pm\'\)\,File\:\:Spec\-\>catfile\(\'lib\'\,\ \'module1\.pm\'\)\;\
\ \ \ \ copy\ \(File\:\:Spec\-\>catfile\(\'expected\'\,\'SVDtest0B\.pm\'\)\,File\:\:Spec\-\>catfile\(\'lib\'\,\'SVDtest1\.pm\'\)\)\;\
\ \ \ \ copy\ \(File\:\:Spec\-\>catfile\(\'expected\'\,\'module0B\.pm\'\)\,File\:\:Spec\-\>catfile\(\'lib\'\,\'module1\.pm\'\)\)\;\
\ \ \ \ copy\ \(File\:\:Spec\-\>catfile\(\'expected\'\,\'SVDtest0B\.t\'\)\,File\:\:Spec\-\>catfile\(\'t\'\,\'SVDtest1\.t\'\)\)\;\
\
\ \ \ \ rmtree\ \(File\:\:Spec\-\>catdir\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\)\)\;\ \
\
\ \ \ \ unlink\ \'SVDtest1\.log\'\;\
\ \ \ \ no\ warnings\;\
\ \ \ \ open\ SAVE_OUT\,\ \"\>\&STDOUT\"\;\
\ \ \ \ open\ SAVE_ERR\,\ \"\>\&STDERR\"\;\
\ \ \ \ use\ warnings\;\
\ \ \ \ open\ STDOUT\,\'\>\ SVDtest1\.log\'\;\
\ \ \ \ open\ STDERR\,\ \"\>\&STDOUT\"\;\
\ \ \ \ \$svd\ \=\ new\ ExtUtils\:\:SVDmaker\(\ \)\;\
\ \ \ \ \$success\ \=\ \$svd\-\>vmake\(\ \{pm\ \=\>\ \'SVDtest1\'\}\ \)\;\
\ \ \ \ close\ STDOUT\;\
\ \ \ \ close\ STDERR\;\
\ \ \ \ open\ STDOUT\,\ \"\>\&SAVE_OUT\"\;\
\ \ \ \ open\ STDERR\,\ \"\>\&SAVE_ERR\"\;\
\ \ \ \ \$output\ \=\ \$snl\-\>fin\(\ \'SVDtest1\.log\'\ \)\;"); # typed in command           
          skip_tests(0);

    #######
    # Freeze version based on previous version
    #
    unlink File::Spec->catfile('t','SVDtest1.t');
    unlink File::Spec->catfile('lib','SVDtest1.pm'),File::Spec->catfile('lib', 'module1.pm');
    copy (File::Spec->catfile('expected','SVDtest0B.pm'),File::Spec->catfile('lib','SVDtest1.pm'));
    copy (File::Spec->catfile('expected','module0B.pm'),File::Spec->catfile('lib','module1.pm'));
    copy (File::Spec->catfile('expected','SVDtest0B.t'),File::Spec->catfile('t','SVDtest1.t'));

    rmtree (File::Spec->catdir( 'packages', 'SVDtest1-0.01')); 

    unlink 'SVDtest1.log';
    no warnings;
    open SAVE_OUT, ">&STDOUT";
    open SAVE_ERR, ">&STDERR";
    use warnings;
    open STDOUT,'> SVDtest1.log';
    open STDERR, ">&STDOUT";
    $svd = new ExtUtils::SVDmaker( );
    $success = $svd->vmake( {pm => 'SVDtest1'} );
    close STDOUT;
    close STDERR;
    open STDOUT, ">&SAVE_OUT";
    open STDERR, ">&SAVE_ERR";
    $output = $snl->fin( 'SVDtest1.log' );; # execution

demo( "\$output", # typed in command           
      $output); # execution


print << "EOF";

 ##################
 # All tests successful
 # 
 
EOF

demo( "\$output\ \=\~\ \/All\ tests\ successful\/", # typed in command           
      $output =~ /All tests successful/); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )); # execution


print << "EOF";

 ##################
 # generated SVD POD
 # 
 
EOF

demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )); # execution


print << "EOF";

 ##################
 # generated packages SVD POD
 # 
 
EOF

demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'MANIFEST\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )); # execution


print << "EOF";

 ##################
 # generated MANIFEST
 # 
 
EOF

demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'Makefile\.PL\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )); # execution


print << "EOF";

 ##################
 # generated Makefile.PL
 # 
 
EOF

demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'README\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))); # execution


print << "EOF";

 ##################
 # generated README
 # 
 
EOF

demo( "\$s\-\>scrub_architect\(\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\.ppd\'\ \)\ \)\)\)", # typed in command           
      $s->scrub_architect($s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) )))); # execution


print << "EOF";

 ##################
 # generated ppd
 # 
 
EOF

demo( "\-e\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\.tar\.gz\'\ \)", # typed in command           
      -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )); # execution


print << "EOF";

 ##################
 # generated distribution
 # 
 
EOF

demo( "\ \ \ \ \#\#\#\#\#\
\ \ \ \ \#\ Clean\ up\
\ \ \ \ \#\
\ \ \ \ unlink\ \'SVDtest1\.log\'\;\
\ \ \ \ unlink\ File\:\:Spec\-\>catfile\(\'lib\'\,\'SVDtest1\.pm\'\)\,File\:\:Spec\-\>catfile\(\'lib\'\,\ \'module1\.pm\'\)\;\
\ \ \ \ rmtree\ \'packages\'\;\
\ \ \ \ rmtree\ \'t\'\;"); # typed in command           
          #####
    # Clean up
    #
    unlink 'SVDtest1.log';
    unlink File::Spec->catfile('lib','SVDtest1.pm'),File::Spec->catfile('lib', 'module1.pm');
    rmtree 'packages';
    rmtree 't';; # execution


=head1 NAME

SVDmaker.d - demostration script for ExtUtils::SVDmaker

=head1 SYNOPSIS

 SVDmaker.d

=head1 OPTIONS

None.

=head1 COPYRIGHT

copyright � 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com,
PROVIDES THIS SOFTWARE 
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE,DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF
ADVISED OF NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE POSSIBILITY OF SUCH DAMAGE.

## end of test script file ##

=cut

