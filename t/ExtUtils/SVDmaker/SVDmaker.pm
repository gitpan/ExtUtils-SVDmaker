#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  t::ExtUtils::SVDmaker::SVDmaker;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '0.01';
$DATE = '2003/07/08';
$FILE = __FILE__;

########
# The Test::STDmaker module uses the data after the __DATA__ 
# token to automatically generate the this file.
#
# Don't edit anything before __DATA_. Edit instead
# the data after the __DATA__ token.
#
# ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
#
# the next time Test::STDmaker generates this file.
#
#


=head1 TITLE PAGE

 Detailed Software Test Description (STD)

 for

 Perl ExtUtils::SVDmaker Program Module

 Revision: -

 Version: 

 Date: 2003/07/07

 Prepared for: General Public 

 Prepared by:  http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com

 Classification: None

=head1 SCOPE

This detail STD and the 
L<General Perl Program Module (PM) STD|Test::STD::PerlSTD>
establishes the tests to verify the
requirements of Perl Program Module (PM) L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>

The format of this STD is a tailored L<2167A STD DID|Docs::US_DOD::STD>.
in accordance with 
L<Detail STD Format|Test::STDmaker/Detail STD Format>.

#######
#  
#  4. TEST DESCRIPTIONS
#
#  4.1 Test 001
#
#  ..
#
#  4.x Test x
#
#

=head1 TEST DESCRIPTIONS

The test descriptions uses a legend to
identify different aspects of a test description
in accordance with
L<STD FormDB Test Description Fields|Test::STDmaker/STD FormDB Test Description Fields>.

=head2 Test Plan

 T: 18^

=head2 ok: 1


  C:
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
 ^
  N: UUT not loaded^
  A: $fp->is_package_loaded('ExtUtils::SVDmaker')^
  E:  ''^
 ok: 1^

=head2 ok: 2

  N: Load UUT^
  R: L<ExtUtils::SVDmaker/load [1]>^
  S: $loaded^
  C: my $errors = $fp->load_package( 'ExtUtils::SVDmaker' )^
  A: $errors^
 SE: ''^
 ok: 2^

=head2 ok: 3


  C:
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
 ^
 DO: ^
  A: $snl->fin( File::Spec->catfile('lib', 'module1.pm'))^
 DO: ^
  A: $snl->fin( File::Spec->catfile('lib', 'SVDtest1.pm'))^
 DO: ^
  A: $snl->fin( File::Spec->catfile('t', 'SVDtest1.t'))^

  C:
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
 ^
 DO: ^
  A: $output^
  N: All tests successful^
  A: $output =~ /All tests successful/^
  E: 1^
 ok: 3^

=head2 ok: 4

  A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )^
  N: generated SVD POD^
  E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) )^
 ok: 4^

=head2 ok: 5

  A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )^
  N: generated packages SVD POD^
  E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) )^
 ok: 5^

=head2 ok: 6

  A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )^
  N: generated MANIFEST^
  E: $snl->fin( 'MANIFEST2' )^
 ok: 6^

=head2 ok: 7

  A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )^
  N: generated Makefile.PL^
  E: $snl->fin( 'Makefile2.PL' )^
 ok: 7^

=head2 ok: 8

  A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))^
  N: generated README^
  E: $s->scrub_date($snl->fin( 'README2' ))^
 ok: 8^

=head2 ok: 9

  A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))^
  N: generated ppd^
  E: $s->scrub_date($snl->fin( 'SVDtest2.ppd' ))^
 ok: 9^

=head2 ok: 10

  A: -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )^
  N: generated distribution^
  E: 1^
 ok: 10^

=head2 ok: 11


  C:
     skip_tests(0);
     #######
     # Freeze version based on previous version
     #
     rmtree (File::Spec->catdir( 'packages', 'SVDtest1-0.01'));
     my $contents = $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' )); 
     $contents =~ s/PREVIOUS_RELEASE\s*:\s+\^^/PREVIOUS_RELEASE  : 0.01^^/;
     $contents =~ s/FREEZE\s*:\s+.*?\^^/FREEZE  : 1^^/;
     $contents =~ s/VERSION\s*:\s+.*?\^^/VERSION  : 0.02^^/;
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
 ^
 DO: ^
  A: $output^
  N: All tests successful^
  A: $output =~ /All tests successful/^
  E: 1^
 ok: 11^

=head2 ok: 12

  A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )^
  N: generated SVD POD^
  E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) )^
 ok: 12^

=head2 ok: 13

  A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )^
  N: generated packages SVD POD^
  E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) )^
 ok: 13^

=head2 ok: 14

  A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )^
  N: generated MANIFEST^
  E: $snl->fin( 'MANIFEST2' )^
 ok: 14^

=head2 ok: 15

  A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )^
  N: generated Makefile.PL^
  E: $snl->fin( 'Makefile3.PL' )^
 ok: 15^

=head2 ok: 16

  A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))^
  N: generated README^
  E: $s->scrub_date($snl->fin( 'README3' ))^
 ok: 16^

=head2 ok: 17

  A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))^
  N: generated ppd^
  E: $s->scrub_date($snl->fin( 'SVDtest3.ppd' ))^
 ok: 17^

=head2 ok: 18

  A: -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )^
  N: generated distribution^
  E: 1^
 ok: 18^



#######
#  
#  5. REQUIREMENTS TRACEABILITY
#
#

=head1 REQUIREMENTS TRACEABILITY

  Requirement                                                      Test
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<ExtUtils::SVDmaker/load [1]>                                   L<t::ExtUtils::SVDmaker::SVDmaker/ok: 2>


  Test                                                             Requirement
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<t::ExtUtils::SVDmaker::SVDmaker/ok: 2>                         L<ExtUtils::SVDmaker/load [1]>


=cut

#######
#  
#  6. NOTES
#
#

=head1 NOTES

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

#######
#
#  2. REFERENCED DOCUMENTS
#
#
#

=head1 SEE ALSO

=over 4

=item L<SVD Automated Generation|ExtUtils::SVDmaker>

=item L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>

=item L<File::FileUtil|Test::FileUtil>

=item L<Test::STD::TestUtil|Test::STD::TestUtil>

=item L<Software Development Standard|Docs::US_DOD::STD2167A>

=item L<Specification Practices|Docs::US_DOD::STD490A>

=item L<SVD DID|US_DOD::SVD>

=back 

The web page http://perl.SoftwareDiamonds.com provides a list of educational
and reference litature on the Perl Programming Language including
Plain Old Documentation (POD)s

=back

=for html
<hr>
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

__DATA__

File_Spec: Unix^
UUT: ExtUtils::SVDmaker^
Revision: -^
End_User: General Public^
Author: http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com^
Detail_Template: ^
STD2167_Template: ^
Version: ^
Classification: None^
Temp: temp.pl^
Demo: SVDmaker.d^
Verify: SVDmaker.t^


 T: 18^


 C:
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
^

 N: UUT not loaded^
 A: $fp->is_package_loaded('ExtUtils::SVDmaker')^
 E:  ''^
ok: 1^

 N: Load UUT^
 R: L<ExtUtils::SVDmaker/load [1]>^
 S: $loaded^
 C: my $errors = $fp->load_package( 'ExtUtils::SVDmaker' )^
 A: $errors^
SE: ''^
ok: 2^


 C:
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
^

DO: ^
 A: $snl->fin( File::Spec->catfile('lib', 'module1.pm'))^
DO: ^
 A: $snl->fin( File::Spec->catfile('lib', 'SVDtest1.pm'))^
DO: ^
 A: $snl->fin( File::Spec->catfile('t', 'SVDtest1.t'))^

 C:
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
^

DO: ^
 A: $output^
 N: All tests successful^
 A: $output =~ /All tests successful/^
 E: 1^
ok: 3^

 A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )^
 N: generated SVD POD^
 E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) )^
ok: 4^

 A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )^
 N: generated packages SVD POD^
 E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest2.pm' ) ) )^
ok: 5^

 A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )^
 N: generated MANIFEST^
 E: $snl->fin( 'MANIFEST2' )^
ok: 6^

 A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )^
 N: generated Makefile.PL^
 E: $snl->fin( 'Makefile2.PL' )^
ok: 7^

 A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))^
 N: generated README^
 E: $s->scrub_date($snl->fin( 'README2' ))^
ok: 8^

 A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))^
 N: generated ppd^
 E: $s->scrub_date($snl->fin( 'SVDtest2.ppd' ))^
ok: 9^

 A: -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )^
 N: generated distribution^
 E: 1^
ok: 10^


 C:
    skip_tests(0);

    #######
    # Freeze version based on previous version
    #
    rmtree (File::Spec->catdir( 'packages', 'SVDtest1-0.01'));
    my $contents = $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' )); 
    $contents =~ s/PREVIOUS_RELEASE\s*:\s+\^^/PREVIOUS_RELEASE  : 0.01^^/;
    $contents =~ s/FREEZE\s*:\s+.*?\^^/FREEZE  : 1^^/;
    $contents =~ s/VERSION\s*:\s+.*?\^^/VERSION  : 0.02^^/;
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
^

DO: ^
 A: $output^
 N: All tests successful^
 A: $output =~ /All tests successful/^
 E: 1^
ok: 11^

 A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )^
 N: generated SVD POD^
 E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) )^
ok: 12^

 A: $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )^
 N: generated packages SVD POD^
 E: $s->scrub_date( $snl->fin( File::Spec->catfile( 'SVDtest3.pm' ) ) )^
ok: 13^

 A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )^
 N: generated MANIFEST^
 E: $snl->fin( 'MANIFEST2' )^
ok: 14^

 A: $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )^
 N: generated Makefile.PL^
 E: $snl->fin( 'Makefile3.PL' )^
ok: 15^

 A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))^
 N: generated README^
 E: $s->scrub_date($snl->fin( 'README3' ))^
ok: 16^

 A: $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))^
 N: generated ppd^
 E: $s->scrub_date($snl->fin( 'SVDtest3.ppd' ))^
ok: 17^

 A: -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )^
 N: generated distribution^
 E: 1^
ok: 18^


 C:
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
^



See_Also:
\=over 4

=item L<SVD Automated Generation|ExtUtils::SVDmaker>

=item L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>

=item L<File::FileUtil|Test::FileUtil>

=item L<Test::STD::TestUtil|Test::STD::TestUtil>

=item L<Software Development Standard|Docs::US_DOD::STD2167A>

=item L<Specification Practices|Docs::US_DOD::STD490A>

=item L<SVD DID|US_DOD::SVD>

=back 

The web page http://perl.SoftwareDiamonds.com provides a list of educational
and reference litature on the Perl Programming Language including
Plain Old Documentation (POD)s
^


Copyright:
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
^


HTML:
<hr>
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>
^



~-~
