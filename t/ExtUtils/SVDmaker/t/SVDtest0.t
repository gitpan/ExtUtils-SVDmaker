#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.01';
$DATE = '2003/07/08';


######
#
# T:
#
# use a BEGIN block so we print our plan before Module Under Test is loaded
#
BEGIN { 
   use Cwd;
   use File::Spec;
   use Test::Tech qw(plan ok skip skip_tests);
   use File::Package;
   use File::TestPath;

   use vars qw($__restore_dir__ @__restore_inc__ $__tests__);

   ########
   # Create the test plan by supplying the number of tests
   # and the todo tests
   #
   $__tests__ = 3;
   plan(tests => $__tests__);

   ########
   # Working directory is that of the script file
   #
   $__restore_dir__ = cwd();
   my ($vol, $dirs, undef) = File::Spec->splitpath( $0 );
   chdir $vol if $vol;
   chdir $dirs if $dirs;

   #######
   # Add the library of the unit under test (UUT) to @INC
   #
   @__restore_inc__ = File::TestPath->test_lib2inc;

}

END {

    #########
    # Restore working directory and @INC back to when enter script
    #
    @INC = @__restore_inc__;
    chdir $__restore_dir__;
}


#######
#
# ok: 1 
#
use File::Package;
my $fp = 'File::Package';
my $loaded;
print "# UUT not loaded\n";
ok( [$loaded = $fp->is_package_loaded('module1')], 
    ['']); #expected results

#######
# 
# ok:  2
# 
print "# Load UUT\n";
my $errors = $fp->load_package( 'module1' );
skip_tests(1) unless skip(
    $loaded, # condition to skip test   
    [$errors], # actual results
    ['']);  # expected results



my $m = new module1;
print "# test hello world\n";
ok($m->hello, 'hello world', 'hello world');


__END__

=head1 NAME

SVDmaker.t - test script for Test::tech

=head1 SYNOPSIS

 SVDmaker.t 

=head1 NOTES

=head2 Copyright

copyright © 2003 Software Diamonds.

head2 License

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

