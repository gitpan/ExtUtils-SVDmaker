#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2003/07/08';


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
    use File::TestPath;
    use Test::Tech qw(tech_config plan demo);

    ########
    # Working directory is that of the script file
    #
    $__restore_dir__ = cwd();
    my ($vol, $dirs, undef) = File::Spec->splitpath(__FILE__);
    chdir $vol if $vol;
    chdir $dirs if $dirs;

    #######
    # Add the library of the unit under test (UUT) to @INC
    #
    @__restore_inc__ = File::TestPath->test_lib2inc();

    unshift @INC, File::Spec->catdir( cwd(), 'lib' ); 

}

END {

   #########
   # Restore working directory and @INC back to when enter script
   #
   @INC = @__restore_inc__;
   chdir $__restore_dir__;

}

print << 'MSG';

 ~~~~~~ Demonstration overview ~~~~~
 
Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

MSG

demo( "\ \ \ \ use\ vars\ qw\(\$loaded\)\;\
\ \ \ \ use\ File\:\:Glob\ \'\:glob\'\;\
\ \ \ \ use\ File\:\:Copy\;\
\ \ \ \ use\ File\:\:Path\;\
\ \ \ \ use\ File\:\:Package\;\
\ \ \ \ use\ File\:\:SmartNL\;\
\ \ \ \ use\ Text\:\:Scrub\;\
\ \ \ \ use\ IO\:\:String\;\
\
\ \ \ \ my\ \$loaded\ \=\ 0\;\
\ \ \ \ my\ \$snl\ \=\ \'File\:\:SmartNL\'\;\
\ \ \ \ my\ \$fp\ \=\ \'File\:\:Package\'\;\
\ \ \ \ my\ \$s\ \=\ \'Text\:\:Scrub\'\;"); # typed in command           
          use vars qw($loaded);
    use File::Glob ':glob';
    use File::Copy;
    use File::Path;
    use File::Package;
    use File::SmartNL;
    use Text::Scrub;
    use IO::String;

    my $loaded = 0;
    my $snl = 'File::SmartNL';
    my $fp = 'File::Package';
    my $s = 'Text::Scrub';; # execution

demo( "\$fp\-\>is_package_loaded\(\'ExtUtils\:\:SVDmaker\'\)", # typed in command           
      $fp->is_package_loaded('ExtUtils::SVDmaker')); # execution


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
\ \ \ \ my\ \$script_dir\ \=\ cwd\(\)\;\
\ \ \ \ chdir\ \'lib\'\;\
\ \ \ \ unlink\ \'SVDtest1\.pm\'\,\'module1\.pm\'\;\
\ \ \ \ copy\ \'SVDtest0\.pm\'\,\'SVDtest1\.pm\'\;\
\ \ \ \ copy\ \'module0\.pm\'\,\'module1\.pm\'\;\
\ \ \ \ chdir\ \$script_dir\;\
\ \ \ \ chdir\ \'t\'\;\
\ \ \ \ unlink\ \'SVDtest1\.t\'\;\
\ \ \ \ copy\ \'SVDtest0\.t\'\,\'SVDtest1\.t\'\;\
\ \ \ \ chdir\ \$script_dir\;\ \
\ \ \ \ rmtree\ \'packages\'\;"); # typed in command           
          ######
    # Add the SVDmaker test lib and test t directories onto @INC
    #
    unshift @INC, File::Spec->catdir( cwd(), 't');
    unshift @INC, File::Spec->catdir( cwd(), 'lib');
    my $script_dir = cwd();
    chdir 'lib';
    unlink 'SVDtest1.pm','module1.pm';
    copy 'SVDtest0.pm','SVDtest1.pm';
    copy 'module0.pm','module1.pm';
    chdir $script_dir;
    chdir 't';
    unlink 'SVDtest1.t';
    copy 'SVDtest0.t','SVDtest1.t';
    chdir $script_dir; 
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
\ \ \ \ skip_tests\(1\)\ unless\ \$svd\-\>vmake\(\ \{pm\ \=\>\ \'SVDtest1\'\}\ \)\;\
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
    skip_tests(1) unless $svd->vmake( {pm => 'SVDtest1'} );
    close STDOUT;
    close STDERR;
    open STDOUT, ">&SAVE_OUT";
    open STDERR, ">&SAVE_ERR";
    my $output = $snl->fin( 'SVDtest1.log' );; # execution

demo( "\$output", # typed in command           
      $output); # execution


demo( "\$output\ \=\~\ \/All\ tests\ successful\/", # typed in command           
      $output =~ /All tests successful/); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'MANIFEST\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'Makefile\.PL\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )); # execution


demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'README\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))); # execution


demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\.ppd\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))); # execution


demo( "\-e\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\.tar\.gz\'\ \)", # typed in command           
      -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )); # execution


demo( "\ \ \ \ skip_tests\(0\)\;\
\
\ \ \ \ \#\#\#\#\#\#\#\
\ \ \ \ \#\ Freeze\ version\ based\ on\ previous\ version\
\ \ \ \ \#\
\ \ \ \ rmtree\ \(File\:\:Spec\-\>catdir\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\)\)\;\
\ \ \ \ my\ \$contents\ \=\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\)\;\ \
\ \ \ \ \$contents\ \=\~\ s\/PREVIOUS_RELEASE\\s\*\:\\s\+\\\^\/PREVIOUS_RELEASE\ \ \:\ 0\.01\^\/\;\
\ \ \ \ \$contents\ \=\~\ s\/FREEZE\\s\*\:\\s\+\.\*\?\\\^\/FREEZE\ \ \:\ 1\^\/\;\
\ \ \ \ \$contents\ \=\~\ s\/VERSION\\s\*\:\\s\+\.\*\?\\\^\/VERSION\ \ \:\ 0\.02\^\/\;\
\ \ \ \ \$snl\-\>fout\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\,\ \$contents\ \)\;\
\ \
\
\ \ \ \ unlink\ \'SVDtest1\.log\'\;\
\ \ \ \ no\ warnings\;\
\ \ \ \ open\ SAVE_OUT\,\ \"\>\&STDOUT\"\;\
\ \ \ \ open\ SAVE_ERR\,\ \"\>\&STDERR\"\;\
\ \ \ \ use\ warnings\;\
\ \ \ \ open\ STDOUT\,\'\>\ SVDtest1\.log\'\;\
\ \ \ \ open\ STDERR\,\ \"\>\&STDOUT\"\;\
\ \ \ \ \$svd\ \=\ new\ ExtUtils\:\:SVDmaker\(\ \)\;\
\ \ \ \ skip_tests\(1\)\ unless\ \$svd\-\>vmake\(\ \{pm\ \=\>\ \'SVDtest1\'\}\ \)\;\
\ \ \ \ close\ STDOUT\;\
\ \ \ \ close\ STDERR\;\
\ \ \ \ open\ STDOUT\,\ \"\>\&SAVE_OUT\"\;\
\ \ \ \ open\ STDERR\,\ \"\>\&SAVE_ERR\"\;\
\ \ \ \ \$output\ \=\ \$snl\-\>fin\(\ \'SVDtest1\.log\'\ \)\;"); # typed in command           
          skip_tests(0);

    #######
    # Freeze version based on previous version
    #
    rmtree (File::Spec->catdir( 'packages', 'SVDtest1-0.01'));
    my $contents = $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' )); 
    $contents =~ s/PREVIOUS_RELEASE\s*:\s+\^/PREVIOUS_RELEASE  : 0.01^/;
    $contents =~ s/FREEZE\s*:\s+.*?\^/FREEZE  : 1^/;
    $contents =~ s/VERSION\s*:\s+.*?\^/VERSION  : 0.02^/;
    $snl->fout( File::Spec->catfile( 'lib', 'SVDtest1.pm' ), $contents );
 

    unlink 'SVDtest1.log';
    no warnings;
    open SAVE_OUT, ">&STDOUT";
    open SAVE_ERR, ">&STDERR";
    use warnings;
    open STDOUT,'> SVDtest1.log';
    open STDERR, ">&STDOUT";
    $svd = new ExtUtils::SVDmaker( );
    skip_tests(1) unless $svd->vmake( {pm => 'SVDtest1'} );
    close STDOUT;
    close STDERR;
    open STDOUT, ">&SAVE_OUT";
    open STDERR, ">&SAVE_ERR";
    $output = $snl->fin( 'SVDtest1.log' );; # execution

demo( "\$output", # typed in command           
      $output); # execution


demo( "\$output\ \=\~\ \/All\ tests\ successful\/", # typed in command           
      $output =~ /All tests successful/); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )); # execution


demo( "\$s\-\>scrub_date\(\ \$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'lib\'\,\ \'SVDtest1\.pm\'\ \)\ \)\ \)", # typed in command           
      $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'MANIFEST\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )); # execution


demo( "\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'Makefile\.PL\'\ \)\ \)", # typed in command           
      $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )); # execution


demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\'\,\ \'README\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))); # execution


demo( "\$s\-\>scrub_date\(\$snl\-\>fin\(\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\.ppd\'\ \)\ \)\)", # typed in command           
      $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))); # execution


demo( "\-e\ File\:\:Spec\-\>catfile\(\ \'packages\'\,\ \'SVDtest1\-0\.01\.tar\.gz\'\ \)", # typed in command           
      -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )); # execution


demo( "\ \ \#\#\#\#\#\
\ \ \#\ Clean\ up\
\ \ \#\
\ \ chdir\ \'lib\'\;\
\ \ unlink\ \'SVDTest1\.pm\'\,\'module1\.pm\'\;\
\ \ chdir\ \$script_dir\;\
\ \ chdir\ \'t\'\;\
\ \ unlink\ \'SVDtest1\.t\'\;\
\ \ chdir\ \$script_dir\;\
\ \ unlink\ \'SVDtest1\.log\'\;\
\ \ rmtree\ \'packages\'\;"); # typed in command           
        #####
  # Clean up
  #
  chdir 'lib';
  unlink 'SVDTest1.pm','module1.pm';
  chdir $script_dir;
  chdir 't';
  unlink 'SVDtest1.t';
  chdir $script_dir;
  unlink 'SVDtest1.log';
  rmtree 'packages';; # execution


=head1 NAME

SVDmaker.d - demostration script for ExtUtils::SVDmaker

=head1 SYNOPSIS

 SVDmaker.d

=head1 OPTIONS

None.

=head1 COPYRIGHT

copyright © 2003 Software Diamonds.

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

