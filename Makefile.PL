
####
# 
# The module ExtUtils::STDmaker generated this file from the contents of
#
# Docs::Site_SVD::ExtUtils_SVDmaker 
#
# Don't edit this file, edit instead
#
# Docs::Site_SVD::ExtUtils_SVDmaker
#
#	ANY CHANGES MADE HERE WILL BE LOST
#
#       the next time ExtUtils::STDmaker generates it.
#
#

use ExtUtils::MakeMaker;

my $tests = join ' ',unix2os('t/ExtUtils/SVDmaker/SVDmaker.t');
my @exe = unix2os('bin/vmake.pl');

WriteMakefile(
    NAME => 'ExtUtils::SVDmaker',
    DISTNAME => 'ExtUtils-SVDmaker',
    VERSION  => '0.01',
    dist     => {COMPRESS => 'gzip',
                'gz' => 'gz'},
    test     => {TESTS => $tests},
    PREREQ_PM => {'DataPort::DataFile' => '0.02',
                  'DataPort::FileType::FormDB' => '0.02',
                  'DataPort::Maker' => '0',
                  'Test::Tech' => '1.08',
                  'Text::Scrub' => '0',
                  'IO::String' => '0',
                  'Text::Scrub' => '0',
                  'Text::Replace' => '0',
                  'Text::Column' => '0',
                  'File::AnySpec' => '0',
                  'File::TestPath' => '0',
                  'File::SubPM' => '0',
                  'File::PM2File' => '0',
                  'File::SmartNL' => '0',
                  'File::Package' => '0',
                  'File::Data' => '0',},
    EXE_FILES => \@exe,

    ($] >= 5.005 ?     
        (AUTHOR    => 'SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>',
        ABSTRACT  => 'Software to generate Software Version Description (SVD) program modules and 
package modules for CPAN.', ) : ()),
);



use File::Spec;
use File::Spec::Unix;
sub unix2os
{
   my @file = ();
   foreach my $file (@_) {
       my (undef, $dir, $file_unix) = File::Spec::Unix->splitpath( $file );
       my @dir = File::Spec::Unix->splitdir( $dir );
       push @file, File::Spec->catfile( @dir, $file_unix);
   }
   @file;
}

