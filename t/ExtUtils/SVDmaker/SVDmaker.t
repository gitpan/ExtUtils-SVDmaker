#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2003/07/08';
$FILE = __FILE__;

use Test::Tech;
use Getopt::Long;
use Cwd;
use File::Spec;
use File::TestPath;

##### Test Script ####
#
# Name: SVDmaker.t
#
# UUT: ExtUtils::SVDmaker
#
# The module Test::STDmaker generated this test script from the contents of
#
# t::ExtUtils::SVDmaker::SVDmaker;
#
# Don't edit this test script file, edit instead
#
# t::ExtUtils::SVDmaker::SVDmaker;
#
#	ANY CHANGES MADE HERE TO THIS SCRIPT FILE WILL BE LOST
#
#       the next time Test::STDmaker generates this script file.
#
#

######
#
# T:
#
# use a BEGIN block so we print our plan before Module Under Test is loaded
#
BEGIN { 
   use vars qw( $__restore_dir__ @__restore_inc__);

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

   ##########
   # Pick up a output redirection file and tests to skip
   # from the command line.
   #
   my $test_log = '';
   GetOptions('log=s' => \$test_log);

   ########
   # Create the test plan by supplying the number of tests
   # and the todo tests
   #
   require Test::Tech;
   Test::Tech->import( qw(plan ok skip skip_tests tech_config) );
   plan(tests => 18);

}



END {

   #########
   # Restore working directory and @INC back to when enter script
   #
   @INC = @__restore_inc__;
   chdir $__restore_dir__;
}

   # Perl code from C:
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
    my $s = 'Text::Scrub';

ok(  $fp->is_package_loaded('ExtUtils::SVDmaker'), # actual results
      '', # expected results
     '',
     'UUT not loaded');

#  ok:  1

   # Perl code from C:
my $errors = $fp->load_package( 'ExtUtils::SVDmaker' );


####
# verifies requirement(s):
# L<ExtUtils::SVDmaker/load [1]>
# 

#####
skip_tests( 1 ) unless skip(
      $loaded, # condition to skip test   
      $errors, # actual results
      '',  # expected results
      '',
      'Load UUT');
 
#  ok:  2

   # Perl code from C:
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
    rmtree 'packages';

   # Perl code from C:
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
    my $output = $snl->fin( 'SVDtest1.log' );

ok(  $output =~ /All tests successful/, # actual results
     1, # expected results
     '',
     'All tests successful');

#  ok:  3

ok(  $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) ), # actual results
     $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) ), # expected results
     '',
     'generated SVD POD');

#  ok:  4

ok(  $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) ), # actual results
     $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) ), # expected results
     '',
     'generated packages SVD POD');

#  ok:  5

ok(  $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) ), # actual results
     $snl->fin( 'MANIFEST2' ), # expected results
     '',
     'generated MANIFEST');

#  ok:  6

ok(  $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) ), # actual results
     $snl->fin( 'Makefile2.PL' ), # expected results
     '',
     'generated Makefile.PL');

#  ok:  7

ok(  $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) )), # actual results
     $s->scrub_date($snl->fin( 'README2' )), # expected results
     '',
     'generated README');

#  ok:  8

ok(  $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) )), # actual results
     $s->scrub_date($snl->fin( 'SVDtest2.ppd' )), # expected results
     '',
     'generated ppd');

#  ok:  9

ok(  -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' ), # actual results
     1, # expected results
     '',
     'generated distribution');

#  ok:  10

   # Perl code from C:
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
    $output = $snl->fin( 'SVDtest1.log' );

ok(  $output =~ /All tests successful/, # actual results
     1, # expected results
     '',
     'All tests successful');

#  ok:  11

ok(  $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) ), # actual results
     $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) ), # expected results
     '',
     'generated SVD POD');

#  ok:  12

ok(  $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) ), # actual results
     $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) ), # expected results
     '',
     'generated packages SVD POD');

#  ok:  13

ok(  $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) ), # actual results
     $snl->fin( 'MANIFEST2' ), # expected results
     '',
     'generated MANIFEST');

#  ok:  14

ok(  $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) ), # actual results
     $snl->fin( 'Makefile3.PL' ), # expected results
     '',
     'generated Makefile.PL');

#  ok:  15

ok(  $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) )), # actual results
     $s->scrub_date($snl->fin( 'README3' )), # expected results
     '',
     'generated README');

#  ok:  16

ok(  $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) )), # actual results
     $s->scrub_date($snl->fin( 'SVDtest3.ppd' )), # expected results
     '',
     'generated ppd');

#  ok:  17

ok(  -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' ), # actual results
     1, # expected results
     '',
     'generated distribution');

#  ok:  18

   # Perl code from C:
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
  rmtree 'packages';


=head1 NAME

SVDmaker.t - test script for ExtUtils::SVDmaker

=head1 SYNOPSIS

 SVDmaker.t -log=I<string>

=head1 OPTIONS

All options may be abbreviated with enough leading characters
to distinguish it from the other options.

=over 4

=item C<-log>

SVDmaker.t uses this option to redirect the test results 
from the standard output to a log file.

=back

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

=cut

## end of test script file ##

