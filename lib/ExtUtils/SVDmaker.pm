#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  ExtUtils::SVDmaker;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '1.03';
$DATE = '2003/07/08';

use Cwd;
use File::Path;
use Pod::Text;
use Pod::Html;
use File::Copy;
use Text::Scrub;
use Text::Column;
use Text::Replace;
use File::AnySpec;
use File::Package;
use File::Data;

use DataPort::Maker;
use vars qw(@ISA);
@ISA = qw( DataPort::Maker );  # inherit the new and maker methods

######
# Hash of targets
#
my %expand_targets = (
        all => [ qw(clear_all check_svd_db restore_previous auto_revise write_svd_pm makemake build) ],
        check_svd_db => [ qw(clear_all check_svd_db) ],
        restore_previous => [ qw(clear_all check_svd_db restore_previous) ],
        auto_revise => [ qw(clear_all check_svd_db restore_previous auto_revise) ],
        pm => [ qw(clear_all check_svd_db restore_previous auto_revise write_svd_pm) ],
        makemake => [ qw(clear_all check_svd_db restore_previous auto_revise makemake) ],
        build => [ qw(clear_all check_svd_db restore_previous auto_revise makemake build) ],
        clear => [ qw(clear) ],
        readme_html => [ qw(clear_all check_svd_db restore_previous auto_revise write_svd_pm readme_html)],
        makepl => [ qw(clear_all check_svd_db restore_previous auto_revise makemake makepl) ],
        make => [ qw(clear_all check_svd_db restore_previous auto_revise makemake makepl make) ],
        __no_target__ => [ qw(clear_all check_svd_db restore_previous auto_revise write_svd_pm makemake build readme_html) ],
);


######
# Write out files
#
sub vmake
{
     my ($self, @targets) = @_;

     ########
     # Default FormDB program module is "SVD"
     #
     $self->{options}->{pm} = 'SVD' unless $self->{options}->{pm};

     $self->make_pm( \%expand_targets, @targets);
 
}


#####
#
#
sub clear
{
   my ($self) = @_;
   $self->{clear} = 0;

   1
}


####
# Clear all target flags
#
sub clear_all
{
    my ($self ) = (@_);
    if( ref($self->{FormDB}) eq 'ARRAY') {
        my %form_db = @{$self->{FormDB}};
        $self->{FormDB} = \%form_db;
        $self->{FormDB}->{FormDB_File} = $self->{FormDB_File};
        $self->{FormDB}->{FormDB_PM} = $self->{FormDB_PM};
    } 
    return 1 if $self->{clear};
    $self->{clear} = 1;
    $self->{check_svd_db} = 0;
    $self->{restore_previous} = 0;
    $self->{auto_revise} = 0;
    $self->{write_svd_pm} = 0;
    $self->{readme_html} = 0;
    $self->{makepl} = 0;
    $self->{makemake} = 0;
    $self->{build} = 0;

    1
}


######
# 
#  
sub restructure
{
    my ($self ) = (@_);

    #######
    # Evaluate the pre build program
    #
    my $restructure = $self->{FormDB}->{RESTRUCTURE};
    if( $restructure ) {
        print"~~~\nRestructing release:\n$restructure\n" if( $self->{options}->{verbose} ); 
        eval $restructure;
        if ($@) {
            warn "Restructure failed.\n\t$@";
            return undef;
        }
    }

    1
}

######
#
#
sub check_svd_db
{
    my ($self) = @_;
    return 1 if $self->{check_svd_db};
    $self->{check_svd_db} = 1;
 
    my $passed_check = 1;

    my $formDB = $self->{FormDB};

    ######
    # Alias PREVIOUS_RELEASE and PREVIOUS_VERSION
    #
    $formDB->{PREVIOUS_RELEASE} = $formDB->{PREVIOUS_VERSION} if $formDB->{PREVIOUS_VERSION};

    my @required = qw(
       DISTNAME VERSION REVISION AUTHOR
       ABSTRACT TITLE END_USER REPOSITORY
       DOCUMENT_OVERVIEW CAPABILITIES AUTO_REVISE
       INSTALLATION SUPPORT
    );

    foreach my $required (@required) {
         unless ($formDB->{$required}) {
              warn "Required SVD DB field, $required, missing.\n";
              $passed_check = undef;
         }
    }

    my @default = (
        FREEZE => 0,
        END_USER => 'General Public',
        REPOSITORY_DIR => 'packages',
        COPYRIGHT => 'Public Domain',
        CLASSIFICATION => 'None',
        TEMPLATE => '',
        CSS => 'help.css',
        SVD_FSPEC => 'Unix',
        COMPRESS => 'gzip',
        COMPRESS_SUFFIX => 'gz',        
        RESTRUCTURE => '',
        CHANGE2CURRENT => '',
        PREREQ_PM => '',
        EXE_FILES => '',
        LICENSE => 'These files are public domain.',
        PROBLEMS => 'There are no known open issues.',
        SEE_ALSO => '',
        HTML => '', 
        NOTES => 'None.'
    );
    my %default = @default;
   
    foreach my $key (keys %default) {
         $formDB->{$key} = $default{$key} unless $formDB->{$key};
    }


    #########
    # Rule: previous version must be less than the current version
    #
    unless( $formDB->{PREVIOUS_DISTNAME} ) {
        if( $formDB->{PREVIOUS_RELEASE} && !$formDB->{PREVIOUS_DISTNAME} ) {
            unless($formDB->{PREVIOUS_RELEASE} < $formDB->{VERSION}) {
                warn " Previous version, $formDB->{PREVIOUS_RELEASE}, must be less than current version, $formDB->{VERSION}\n"; 
                $passed_check = undef;
            }
        }

        #######
        # There is no previous version so make a best guess
        #
        else {
            if( $formDB->{VERSION} eq '0.01' ) {
                $formDB->{PREVIOUS_RELEASE} = '';
            }
            else {
                $formDB->{PREVIOUS_RELEASE} = $formDB->{VERSION} - 1;
            } 
        }
    }

    #########
    # Clean-up data fields
    #
    foreach my $field qw(PREVIOUS_RELEASE) {

        if($formDB->{$field} ) {

            #####
            # Drop leading and trailing white space
            #
            ($formDB->{$field}) = $formDB->{$field} =~ /^\s*(.*?)\s*$/s;
        }
        else {
            $formDB->{$field} = ''; 
        }
    }

    ##############
    # Create derived fields
    #
    $formDB->{DATE} = get_date();

    $formDB->{NAME} = $formDB->{DISTNAME};
    $formDB->{NAME} =~ s/\-/::/;

    $formDB->{SVD_FSPEC} = 'Unix' unless $formDB->{SVD_FSPEC};


    #########
    # Change to the directory containing the svd_file, 
    # remembering the current working directory in order
    # to restore it after processing
    #
    my $svd_file = $self->{FormDB_File};
    my ($svd_vol, $svd_dir) = File::Spec->splitpath( $svd_file );
    chdir $svd_vol if $svd_vol;
    chdir $svd_dir if $svd_dir;
    $formDB->{SVD_DIR} = cwd();

    ########
    # Determine the top directory.
    #
    my @top_dir = File::Spec->splitdir( $svd_dir );
    while( @top_dir && $top_dir[-1] !~ /lib/) { 
        pop @top_dir;
        chdir File::Spec->updir(); 
    };
    pop @top_dir;
    $formDB->{TOP_DIR} = cwd();

    ######
    # BSD glob the AUTO_REVISE list
    #
    my @auto_revise =  File::AnySpec->fspec_glob($formDB->{SVD_FSPEC}, split "\n", $formDB ->{AUTO_REVISE} );
    my %auto_revise;
    foreach my $file (@auto_revise) {
        $auto_revise{$file} = 1;   
    }
    $formDB->{AUTO_REVISE_LIST} = \@auto_revise;
    $formDB->{AUTO_REVISE_HASH} = \%auto_revise;

    #######
    # BSD Glob test files
    #
    my @tests;
    if($formDB->{TESTS}) {
        @tests = File::AnySpec->fspec_glob($formDB->{SVD_FSPEC}, split "\n", $formDB->{TESTS} );
    }
    else {
        @tests = File::AnySpec->fspec_glob('Unix', ('t/*.t') );
    }

    #######
    # Rule: test script must be included in auto revise
    #
    foreach my $test (@tests) {
        unless( $auto_revise{$test} ) {
            warn( "Test, $test, not included in the distribution\n");
            $passed_check = undef;
        }
    }

    ######
    # Change the test file spec to that of the SVD
    #
    foreach my $test (@tests) {
        $test = File::AnySpec->os2fspec( $formDB->{SVD_FSPEC}, $test );
    }
    $formDB->{TEST_INVENTORY} = ' ' . join "\n ", @tests;
    $formDB->{TEST_LIST} = \@tests;

    #######
    # BSD Glob exe files
    #
    my @exe;
    if($formDB->{EXE_FILES}) {
        @exe = File::AnySpec->fspec_glob($formDB->{SVD_FSPEC}, split "\n", $formDB->{EXE_FILES} );
    }
    else {
        @exe = ();
    }
    foreach my $exe (@exe) {
        $exe = File::AnySpec->os2fspec( $formDB->{SVD_FSPEC}, $exe );
    }
    $formDB->{EXE_LIST} = \@exe;


    ######
    # Determine the SVD file relative to the top directory
    #
    (my $vol, my $dir, $svd_file) = File::Spec->splitpath( $svd_file );
    $dir = File::Spec->abs2rel($dir, $formDB->{TOP_DIR});
    $svd_file = File::Spec->catfile($dir, $svd_file);
    $formDB->{PM_File_Relative} = $svd_file; # relative to TOP_DIR

    ###########
    # Determine repository directory which is relative to the top dir
    #
    my $repository_dir = File::AnySpec->fspec2os($formDB->{SVD_FSPEC}, $formDB->{REPOSITORY_DIR}, 'nofile');
    mkpath( $repository_dir);
    chdir $repository_dir;
    $formDB->{REPOSITORY_DIR} = cwd();

    $passed_check

}


######
# Date with year first
#
sub get_date
{
   my @d = localtime();
   @d = @d[5,4,3];
   $d[0] += 1900;
   $d[1] += 1;
   sprintf( "%04d/%02d/%02d", @d[0,1,2]);

}



######
#
#
sub restore_previous
{
    my ($self) = @_;
    return 1 if $self->{restore_previous};
    $self->{restore_previous} = 1;

    my $formDB = $self->{FormDB};

    ###### 
    # Auto revise the files
    #
    my $previous_release = $formDB->{PREVIOUS_RELEASE};
    my $release_dir;
    chdir $formDB->{REPOSITORY_DIR};
    if( $previous_release ) {

        $formDB->{PREVIOUS_DISTNAME} = $formDB->{DISTNAME}  unless $formDB->{PREVIOUS_DISTNAME}; 
        my $previous_release_dir = "$formDB->{PREVIOUS_DISTNAME}-$previous_release";
        rmtree $previous_release_dir;

        ######
        # Uncompress the file
        #
        my $previous_distribution = "$previous_release_dir.tar.$formDB->{COMPRESS_SUFFIX}";
        my $command = "gunzip -c -f $previous_distribution > package.tar";
        print "    $command\n" if $self->{options}->{verbose};
        `$command`;

        ######
        # Extract files from tape archive
        #
        $command = "tar -xf package.tar";
        print "    $command\n" if $self->{options}->{verbose};
        `$command`;

        unlink 'package.tar';
  
        #######
        # Get a list of the previsous release inventory
        # In order to load it in memory, it must be under one of the library
        # directories in @INC
        #
        my $svd_base_file = $formDB->{PREVIOUS_DISTNAME};
        $svd_base_file =~ s/-/_/g;
        my $svd_file = File::Spec->catfile($previous_release_dir, 'lib', 'Docs', 'Site_SVD', $svd_base_file . '.pm' );

        #######
        # Look at older pass location
        #
        unless( -e $svd_file) {
            $svd_file = File::Spec->catfile($previous_release_dir, 'lib', 'SVD', 'Site', $svd_base_file . '.pm' );
        }
        unless( -e $svd_file) {
            $svd_file = File::Spec->catfile($previous_release_dir, 'lib', 'SVD', $svd_base_file . '.pm' );
        }
        unless( -e $svd_file) {
            $svd_file = File::Spec->catfile($previous_release_dir, 'lib', $svd_base_file . '.pm' );
        }

        unless (open FH, "< $svd_file") {
             warn "Cannot open $svd_file\n";
             return undef;
        }

        my $contents = join '', <FH>;
        close FH;
        my ($inventory) = $contents =~ /%INVENTORY\s*=\s*\((.*?)\);/s;
        my %inventory = ();
        eval "%inventory = ($inventory)" if $inventory;
        $formDB->{PREVIOUS_INVENTORY} = (keys %inventory) ? \%inventory : {};

        #########
        # If there is a name change, move the previous to the new
        #
        if( $formDB->{DISTNAME} ne  $formDB->{PREVIOUS_DISTNAME} ) {
            my $from_dir = File::Spec->catdir(cwd(),$previous_release_dir);
            chdir $formDB->{REPOSITORY_DIR};
            $release_dir = "$formDB->{DISTNAME}-$formDB->{VERSION}";
            rmtree $release_dir;
            mkpath $release_dir;
            chdir $release_dir;
            my ($previous_file, $file);
            my %inventory = ();
            my %previous_inventory = %{$formDB->{PREVIOUS_INVENTORY}};
            foreach $previous_file (keys %previous_inventory ) {

                ########
                # Change previous file name to current file name
                # 
                $file = $previous_file;
                if( $formDB->{CHANGE2CURRENT} ) {
                    eval $formDB->{CHANGE2CURRENT};
                    if($@) {
                         warn "Cannot change work file, $file, to current name\n\t$@\n";
                    }
                }

                #######
                # Copy previous inventory info to new inventory
                #
                $inventory{$file} = $previous_inventory{$previous_file};

                ######
                # Copy file from old distribution to new distribution
                #
                $previous_file = File::AnySpec->fspec2os( $formDB->{SVD_FSPEC}, $previous_file );
                $previous_file = File::Spec->catfile( $from_dir, $previous_file );
                $file = File::AnySpec->fspec2os( $formDB->{SVD_FSPEC}, $file );
                (undef,my $dir,undef) = File::Spec->splitpath($file);
                mkpath $dir if $dir;
                copy $previous_file, $file;
        
            }
            $formDB->{PREVIOUS_INVENTORY} =\%inventory;

        }

        chdir $previous_release_dir;
        return undef unless $self->restructure( );

    }  

    else {
        $release_dir = "$formDB->{DISTNAME}-$formDB->{VERSION}";
        rmtree( $release_dir );
        my $dirs = mkpath( $release_dir );
        unless( 0 < $dirs ) {
            warn "Cannot mkpath $release_dir\n";
            return undef;
        }
        chdir $release_dir;
        $formDB->{PREVIOUS_INVENTORY} = {};
    }

    ######
    # Record the release directory.
    #
    $formDB->{RELEASE_DIR} = cwd();

    if($self->{options}->{verbose}) {
        print "~~~~\nDirectories after restore previous:\n";
        print "Top directory: $formDB->{TOP_DIR}\n";
        print "Repository release : $formDB->{REPOSITORY_DIR}\n"; 
        print "Release directory: $formDB->{RELEASE_DIR}\n";
    }

    1
}


######
#
#
sub auto_revise
{

    my ($self) = @_;
    return 1 if $self->{auto_revise};
    $self->{auto_revise} = 1;

    my $formDB = $self->{FormDB};
    my $fspec_in = $self->{options}->{fspec_in};
    chdir $formDB->{TOP_DIR};

    my @inventory = ();
    my @manifest=();
    my $date = $formDB->{DATE};

    ######
    # Add input and files generated after auto_revise
    #
    my $svd_file = File::AnySpec->os2fspec( $formDB->{SVD_FSPEC}, $formDB->{PM_File_Relative});
    my $comment =  $formDB->{PREVIOUS_RELEASE} ? "revised $formDB->{PREVIOUS_RELEASE}" : 'new';
    push @manifest,$svd_file;
    push @inventory, [$svd_file, $formDB->{VERSION}, $date, $comment];

    ######
    # List automatically generated files after auto revise files
    #
    $comment =  $formDB->{PREVIOUS_RELEASE} ? "generated, replaces $formDB->{PREVIOUS_RELEASE}" : 'generated new';
    foreach my $file ( 
          'MANIFEST', 
          'Makefile.PL',
          'README') {
        push @manifest, $file;
        push @inventory, [$file, $formDB->{VERSION}, $date, $comment];
    }
    $formDB->{MANIFEST} = \@manifest;    
    $formDB->{inventory} = \@inventory;

    my @auto_revise = @{$formDB->{AUTO_REVISE_LIST}};

    #####
    # auto revise each file
    #
    my $release_dir = $formDB->{RELEASE_DIR};
    my ($work_file,$release_file, $temp_file);
    foreach $work_file (@auto_revise) {
        unless( -f $work_file ) {
            next if -d $work_file;
            my $file = File::Spec->catfile( cwd(), $work_file);
            warn "The file $file does not exist\n";
            next;
        }
        $release_file = File::Spec->catfile($release_dir, $work_file);
        $self->auto_revise_file($work_file, $release_file);
    }

    $formDB->{DIST_INVENTORY} =  Text::Column->format_array_table(
                 $formDB->{inventory}, [60,7,10,24], ['file','version','date','comment']);

    1
}




######
#
#
sub auto_revise_file
{
    my($self, $work_file, $release_file ) = @_;

    my $formDB = $self->{FormDB};

    unless($work_file) {
        warn( "No work file\n");
        return undef;
    }

    unless($release_file) {
        warn( "No work file\n");
        return undef;
    }

    if( $formDB->{CHANGE2PREVIOUS} ) {
         eval '$release_file  =~ ' . $formDB->{CHANGE2PREVIOUS};
         if($@) {
            warn "Cannot change work file, $release_file, to previous name\n";
         }
    }

    unless( -e $work_file ) {
        unlink( $release_file );
        return 1;
    }

    return undef unless open( WORK, "< $work_file" );
    binmode WORK;
    my $work_contents = join ( '', <WORK> );
    close WORK;

    ######
    # Try to find the Version and date from the file contents.
    # 
    my ($work_version) = $work_contents =~ /\$VERSION\s*=\s*['"]\s*(\d+\.\d\d)\s*['"]/;
    unless ($work_version) {
        ($work_version) = $work_contents =~ /VERSION\s*:\s*(.*)\s*\^/;
        $work_version = '' unless $work_version;
    }
    my ($work_date) = $work_contents =~ /\$DATE\s*=\s*['"](.*?)['"]/;
    unless ($work_date) {
        ($work_date) = $work_contents =~ /DATE\s*:\s*(.*)\s*\^/;
        $work_date = '' unless $work_date;
    }
 
    ########
    # If there is no work_version try to pick one up from
    # the previous inventory
    #
    my ($inventory_version, $inventory_date, $work_previous);
    my $work_file_fspecin = File::AnySpec->os2fspec($formDB->{SVD_FSPEC}, $work_file );
    unless( $work_version ) {
        $work_previous = $formDB->{PREVIOUS_INVENTORY}->{$work_file_fspecin};
        $inventory_version = ($work_previous && @$work_previous[0]) ? @$work_previous[0] : $formDB->{VERSION};
    }
    unless( $work_date ) {
        $work_previous = $formDB->{PREVIOUS_INVENTORY}->{$work_file_fspecin};
        $inventory_date = ($work_previous && @$work_previous[1]) ? @$work_previous[1] : $formDB->{DATE};
    }

    my $inventory_p = $formDB->{inventory};
    my $manifest_p = $formDB->{MANIFEST};
    my $release_date = $formDB->{DATE};
    unlink $release_file unless $formDB->{PREVIOUS_RELEASE};
    my $changed = 0;
    if ( -f $release_file ) {

        return undef unless open( RELEASE, "< $release_file" );
        binmode RELEASE;
        my $release_contents = join ( '', <RELEASE> );
        close RELEASE;
        
        ######
        # Make sure have an inventory version.
        #
        my ($release_version) = $release_contents =~ /\$VERSION\s*=\s*['"]\s*(\d+\.\d\d)\s*['"]/;
        $inventory_version = $release_version unless $inventory_version;
        $inventory_version = '0.01' unless $inventory_version;
       
        ######
        # Blank out version and date for comparasion
        #
        my $release_contents_scrub = Text::Scrub->scrub_date_version( $release_contents);
        my $work_contents_scrub = Text::Scrub->scrub_date_version( $work_contents);
        
        #####
        # If the files are the same return
        #
        $work_version = ($work_version) ? $work_version : $inventory_version;
        $work_date = ($work_date) ? $work_date : $inventory_date;
        if( $release_contents_scrub eq $work_contents_scrub) {
             push @$inventory_p, [$work_file_fspecin, $work_version, $work_date, 'unchanged'];
             push @$manifest_p, $work_file_fspecin;
             return 1;
        }

        #######
        # The file has changed since the last release.
        #
        $release_version = ($inventory_version < $work_version) ? $work_version : $inventory_version + 0.01;
        push @$inventory_p,[$work_file_fspecin, $release_version, $release_date, "revised $inventory_version"];
        print "Changed: $work_file,    $release_version $release_date\n" if $self->{options}->{verbose};
        $self->{file_changed} = 1;

        #######
        # Update the $VERSION and $DATE variables.
        #
        $work_contents =~ s/\$VERSION\s*=\s*['"]\d+\.\d\d\s*['"]/\$VERSION = '$release_version'/;
        $work_contents =~ s/VERSION\s*:\s*(.*)\s*\^/VERSION\:$release_version^ /;
        $work_contents =~ s/\$DATE\s*=\s*['"].*?['"]/\$DATE = '$release_date'/;
        $work_contents =~ s/DATE\s*:\s*(.*)\s*\^/DATE\:$release_date^ /;
        $changed = 1;
    }
    else {
 
        ########
        # Have a new file
        # 
        $work_version = $inventory_version unless $work_version;
        $work_contents =~ s/\$DATE\s*=\s*['"].*?['"]/\$DATE = '$release_date'/;
        push @$inventory_p, [$work_file_fspecin, $work_version,  $release_date, 'new'];
        print "New    : $work_file,    $work_version $release_date\n" if $self->{options}->{verbose};

    }
    push @$manifest_p, $work_file_fspecin;

    ######
    # Make sure the path exists for the release file
    #
    my ($vol, $dir, undef) = File::Spec->splitpath( $release_file );
    $dir = File::Spec->catdir( $vol, $dir ) if( $vol && $dir );
    mkpath( $dir ) if $dir;

    #######
    # Copy the work file to the release file
    #
    return undef unless open( RELEASE, "> $release_file" );
    binmode RELEASE;
    print RELEASE $work_contents;
    close RELEASE;

    #######
    # If freezing the release, update the work file with any new date and version
    #
    my $freeze = $formDB->{FREEZE};
    $freeze = 0 unless $freeze;
    if( $freeze eq 'YES' || $freeze eq 'yes' || $freeze eq '1') {

        ######
        # Pick up the new version and date in the work copy
        #
        return undef unless open( WORK, "> $work_file" );
        binmode WORK;
        print WORK $work_contents;
        close WORK;
    }

    return 1;
}



######
#
#
sub write_svd_pm
{

    my ($self) = (@_);
    return 1 if $self->{write_svd_pm};
    $self->{write_svd_pm} = 1;
    my $formDB = $self->{FormDB};

    ######
    # Generate the svd program module
    #
    my $svd_file = $self->{FormDB_File};
    unless( $svd_file ) {
        warn "No SVD pm file specified\n";
        return undef;
    }


    chdir $formDB->{TOP_DIR};

    if( $self->{options}->{verbose} ) {
        print "~~~\nGenerating Software Version Description POD\n"; 
        print "Current directory: $formDB->{TOP_DIR}\n";
    }


    ##########
    # Generate some template variables
    #
    my $restructure = $formDB->{RESTRUCTURE};
    my $restructure_formatted;
    if($restructure) {
       $restructure_formatted = << "EOF";
The file structure from release \${PREVIOUS_RELEASE} was restructured as follows:

EOF
        chomp $restructure;
        $restructure =~ s/\n/\n /;
        $restructure_formatted .= ' ' . $restructure . "\n\n";

    }
    else {
       $restructure_formatted = ''
    }
    $formDB->{RESTRUCTURE_CHANGES} = $restructure_formatted;


    ##########
    # Generate add the file name changes
    #
    $restructure = $formDB->{CHANGE2CURRENT};
    if($restructure) {
       $restructure_formatted = << "EOF";
The file names from \${PREVIOUS_RELEASE} were changed as follows:

EOF
        chomp $restructure;
        $restructure =~ s/\n/\n /;
        $restructure_formatted .= ' ' . $restructure . "\n\n";

    }
    else {
       $restructure_formatted = ''
    }
    $formDB->{RESTRUCTURE_CHANGES} .= $restructure_formatted;

    #####
    # Generate the inventory hash
    #
    my $inventory = $formDB->{inventory};
    shift @$inventory;
    shift @$inventory;
    my $inventory_hash=''; 
    my ($file, @file);
    foreach $file (@$inventory) {
       @file = @$file;
       $inventory_hash .= "    '$file[0]' => [qw($file[1] $file[2]), '$file[3]'],\n" 
    }
    $formDB->{INVENTORY_HASH} = $inventory_hash;

    ######
    # Generate repositories
    #
    my @repository = split "\n",$formDB->{REPOSITORY};
    my $repository;
    foreach $repository (@repository) {
        $repository = " $repository$formDB->{DISTNAME}-$formDB->{VERSION}\n"
    }
    $formDB->{REPOSITORY} = join '', @repository;

    #######
    # Determine the PM_NAME
    # 
    $formDB->{PM_NAME} = $formDB->{DISTNAME};
    $formDB->{PM_NAME} =~ s/\-/_/;

    #########
    # Make a table out of this
    #
    my @prereq_pm;
    my $prereq_pm = ($formDB->{PREREQ_PM}) ? $formDB->{PREREQ_PM} : 'None.';
    if( $prereq_pm ) {
        eval( "@prereq_pm = $prereq_pm" );
        chomp $prereq_pm;
        $prereq_pm =~ s/\n/\n /g;
        $prereq_pm = ' ' . $prereq_pm . "\n";
    }
    else {
        $prereq_pm = '';
    }
    $formDB->{PREREQ_PM_TEXT} = $prereq_pm;

    #########
    # Get the SVD template, the templae is data of __DATA__ in a program module
    #
    my $template = '';
    if($formDB->{TEMPLATE}) {
        my $error = File::Package->load_package( $formDB->{TEMPLATE} );
        $template = File::Data->pm2data( $formDB->{TEMPLATE} ) unless ($error);
    }

    ######
    # 
    # Get the default template
    # 
    $template = default_template() unless $template;

    #######
    # Generate the file header
    #
    my $header = << 'EOF';
#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  ${FormDB_PM};

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '${VERSION}';
$DATE = '${DATE}';
$FILE = __FILE__;

use vars qw(%INVENTORY);
%INVENTORY = (
${INVENTORY_HASH}
);

########
# The ExtUtils::SVDmaker module uses the data after the __DATA__ 
# token to automatically generate this file.
#
# Don't edit anything before __DATA_. Edit instead
# the data after the __DATA__ token.
#
# ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
#
# the next time ExtUtils::SVDmaker generates this file.
#
#


EOF

    ########
    # Replace template macros variables
    # 
    $template = $header . $template;
    Text::Replace->replace_variables(\$template, $formDB);
    $template =~ s/\n\\=/\n=/g; # unescape POD directives
    $template .= "1;\n\n__DATA__$self->{FormDB_Record}\n\n";

    ########
    # Print out the SVD file
    #
    my (undef, $svd_file_dirs, undef) = File::Spec->splitpath( $svd_file);
    mkpath( $svd_file_dirs) if $svd_file_dirs;
    unless ( open( SVD, "> $svd_file") ) {
        warn "Cannot open $svd_file\n";
        return undef;      
    }
    print SVD $template;
    close SVD;

    ##########
    # Copy the newly revised PM file to the distribution
    #
    my $svd_file_relative = $formDB->{PM_File_Relative};
    my $release_file = File::Spec->catfile( $formDB->{RELEASE_DIR}, $svd_file_relative);

    ######
    # Make sure the path exists for the release file
    #
    my ($vol, $dir, undef) = File::Spec->splitpath( $release_file );
    $dir = File::Spec->catdir( $vol, $dir ) if( $vol && $dir );
    mkpath( $dir ) if $dir;
    copy $svd_file, $release_file;


    1

}


sub readme_html
{
    my ($self) = (@_);
    return 1 if $self->{readme_html};
    $self->{readme_html} = 1;
    my $formDB = $self->{FormDB};

    #######
    # Generate HTML in the repository directory
    #
    #######
    my $html_file .= $formDB->{DISTNAME} . '-' . $formDB->{VERSION} . '.html';
    $html_file = File::Spec->catfile( $formDB->{REPOSITORY_DIR}, $html_file);
    my $css = File::AnySpec->fspec2fspec($formDB->{SVD_FSPEC}, 'Unix', $formDB->{CSS});
    $css = 'help.css' unless $css;
    my $podpath = join ';',@INC;
    print "Generating $html_file\n" if $self->{options}->{verbose};
    pod2html($self->{FormDB_File},
            "--podpath=$podpath",
            "--podroot=$formDB->{TOP_DIR}",
            "--backlink='Back to Top'",
            "--htmlroot=.",
            "--header",
            "--css=$css",
            "--recurse",
            "--title=Software Version Description for $formDB->{TITLE}",
            "--outfile=$html_file");
    unlink "pod2htmd.x~~";
    unlink "pod2htmi.x~~";

}


######
#
#
sub makemake
{
    my($self, $svd_file) = @_;
    return 1 if $self->{makemake};
    $self->{makemake} = 1;

    my $formDB = $self->{FormDB};

    my $cwd = cwd();
    my $release_dir = $formDB->{RELEASE_DIR};
    chdir $release_dir;
    if ($self->{options}->{verbose}) {
        print "~~~~\nGenerating makemake files:\n";
        print "Current directory: $cwd\n";
        print "Release directory: $release_dir\n";
    }

    ########
    # Generate the manifest file
    #
    ########
    my $manifest_file = File::Spec->catfile($release_dir, 'MANIFEST');
    my $manifest_h;
    print  "Generating $manifest_file\n" if $self->{options}->{verbose};
    unless (open( $manifest_h, "> $manifest_file" )) {
        warn "Cannot open $manifest_file";
        return undef;
    }
    print $manifest_h join "\n", @{$formDB->{MANIFEST}};
    close $manifest_h;
    undef $manifest_h;  # problems with ActivePerl redirecting outputs

    #######
    # Generate README
    #
    ######
    print "Generating README\n" if $self->{options}->{verbose};
    my $pod2text = new Pod::Text;
    my $readme_file = File::Spec->catfile($release_dir, 'README');
    $pod2text->parse_from_file($formDB->{FormDB_File}, $readme_file);

    ######
    # Create the Makefile.PL file
    #
    my $makemaker_file = File::Spec->catfile($release_dir, 'Makefile.PL');
    print "Generating $makemaker_file\n" if $self->{options}->{verbose};
    my $makefile_h;
    unless (open( $makefile_h, "> $makemaker_file" )) {
        warn "Cannot open $makemaker_file";
        return undef;
    }


    my $tests = '\'' . join ('\',\'', @{$formDB->{TEST_LIST}}) . '\'';
 
    my $exe_text = '';
    my $exe_com_text = '';
    if( @{$formDB->{EXE_LIST}} ) {
        my $exe = '\'' . join ('\',\'', @{$formDB->{EXE_LIST}}) . '\'';
        $exe_text = "my \@exe = unix2os($exe);";
        $exe_com_text = 'EXE_FILES => \@exe,'
    }
    
    my $prereq_pm = '';
    if($formDB->{PREREQ_PM}) {
        $prereq_pm = $formDB->{PREREQ_PM};
        while( chomp $prereq_pm ) {};
        $prereq_pm =~ s/\n/\n                  /g;
        $prereq_pm = "PREREQ_PM => {$prereq_pm},";
    }

    print $makefile_h <<"EOF";

####
# 
# The module ExtUtils::STDmaker generated this file from the contents of
#
# $formDB->{FormDB_PM} 
#
# Don't edit this file, edit instead
#
# $formDB->{FormDB_PM}
#
#	ANY CHANGES MADE HERE WILL BE LOST
#
#       the next time ExtUtils::STDmaker generates it.
#
#

use ExtUtils::MakeMaker;

my \$tests = join ' ',unix2os($tests);
$exe_text

WriteMakefile(
    NAME => '$formDB->{NAME}',
    DISTNAME => '$formDB->{DISTNAME}',
    VERSION  => '$formDB->{VERSION}',
    dist     => {COMPRESS => '$formDB->{COMPRESS}',
                '$formDB->{COMPRESS_SUFFIX}' => 'gz'},
    test     => {TESTS => \$tests},
    $prereq_pm
    $exe_com_text

    (\$] >= 5.005 ?     
        (AUTHOR    => '$formDB->{AUTHOR}',
        ABSTRACT  => '$formDB->{ABSTRACT}', ) : ()),
);


EOF


    my $subs = <<'EOF';

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

EOF

    $subs =~ s/Unix/$formDB->{SVD_FSPEC}/g;
    print $makefile_h $subs;

    close $makefile_h;
    undef $makefile_h;  # problems with ActivePerl redirecting outputs


    1

}



######
#
#
sub build
{
    my($self) = @_;
    return 1 if $self->{build};
    $self->{build} = 1;

    my $options = $self->{options};
    if ($^O eq 'MSWin32') {
        $options->{NOLOGO} = 1;
    }   
    
    return undef unless $self->makepl( );
    return undef unless $self->make();
    return undef unless $self->make('test TEST_VERBOSE=1');
    return undef unless $self->make('dist');
    return undef unless $self->make('ppd');

    1

}


######
#
#
sub makepl
{
    my($self) = @_;
    return 1 if $self->{makepl};
    $self->{makepl} = 1;
    my $formDB = $self->{FormDB};
    chdir $formDB->{RELEASE_DIR};
    print `perl Makefile.PL`;
    if ($?) {
       warn( "MakePL failed. Error code $?\n");
       return undef;
    }
 
    1
}


######
#
#
sub make
{
    my($self, $arguments) = @_;
    my $formDB = $self->{FormDB};
    my $options = $self->{options};
    chdir $formDB->{RELEASE_DIR};

    my ($command, @command_options, $option_character);
    if ($^O eq 'MSWin32') {
       @command_options = qw( A B C D E K HELP I N NOLOGO P Q R S T U Y ?);
       $option_character = '/';
       $command = 'nmake';
       $options->{C} = $options->{s};  # nmake /C is same as make -s
       $options->{N} = $options->{n};  # nmake /N is same as make -n
    }
    else {
       @command_options = qw(b C=s debug e i I=s j k l n o p q r R s t v w no-print-directory W=s warn-undefined-variables);
       $option_character = '-';
       $command = 'make';
    }

    my ($option, $option_str, $value) = ('','','');
    foreach $option (@command_options) {
        $value = $options->{$option};
        if(defined $value) {
            if( $option =~ /=s$/ ) {
                $option =~ s/=s$//;
                $option_str .= "$option_character$option=$value ";
            }
            else {
                $option_str .= "$option_character$option ";
            }            
        }      
    }

    unless($arguments) {
        $arguments = $self->{arguments} ;
        $arguments = '' unless $arguments;
    }
    ($arguments) = $arguments =~ /^\s*(.*)\s*$/;

    my $release_file = "$formDB->{DISTNAME}-$formDB->{VERSION}";
    $release_file .=  ".tar.$formDB->{COMPRESS_SUFFIX}";
    unlink( $release_file );

    $command = "$command $option_str$arguments";
    print  "    $command\n" if $options->{verbose};
    print `$command`;
    if( $? ) {
        warn "$command failed. Error code $?\n";
        return undef;
    }

    #######
    # Fill in the code base if a ppd target
    # 
    my $repository_file;
    if( $arguments eq 'ppd') {
        my $ppd_file = $formDB->{DISTNAME} . '.ppd';
        unless( open(PPD, "< $ppd_file") ) {
            warn "Cannot open $ppd_file\n";
            return undef;
        }
        my $ppd_contents = join '',<PPD>;
        close PPD;
        $ppd_contents =~ s|\Q<CODEBASE HREF="" />\E|<CODEBASE HREF="$release_file" />|;
        unless( open(PPD, "> $ppd_file") ) {
            warn "Cannot open $ppd_file\n";
            return undef;
        }
        print PPD $ppd_contents;
        close PPD;   

        $repository_file = File::Spec->catfile($formDB->{REPOSITORY_DIR}, $ppd_file);
        move $ppd_file, $repository_file;

    }

    elsif( $arguments eq 'dist' ) {
        $repository_file = File::Spec->catfile($formDB->{REPOSITORY_DIR}, $release_file);
        move $release_file, $repository_file;
    }

    1

}


######
# 
# Default SVD template
#
sub default_template
{
    << 'EOF';

=head1 Title Page

 Software Version Description

 for

 ${TITLE}

 Revision: ${REVISION}

 Version: ${VERSION}

 Date: ${DATE}

 Prepared for: ${END_USER} 

 Prepared by:  ${AUTHOR}

 Copyright: ${COPYRIGHT}

 Classification: ${CLASSIFICATION}

=head1 1.0 SCOPE

This paragraph identifies and provides an overview
of the released files.

=head2 1.1 Identification

This release,
identified in L<3.2|/3.2 Inventory of software contents>,
is a collection of Perl modules that
extend the capabilities of the Perl language.

=head2 1.2 System overview

${CAPABILITIES}

=head2 1.3 Document overview.

${DOCUMENT_OVERVIEW}

=head1 3.0 VERSION DESCRIPTION

All file specifications in this SVD
use the ${SVD_FSPEC} operating
system file specification.

=head2 3.1 Inventory of materials released.

This document releases the file found
at the following repository(s):

${REPOSITORY}

Restrictions regarding duplication and license provisions
are as follows:

=over 4

=item Copyright.

${COPYRIGHT}

=item Copyright holder contact.

 ${SUPPORT}

=item License.

${LICENSE}

=back

=head2 3.2 Inventory of software contents

The content of the released, compressed, archieve file,
consists of the following files:

${DIST_INVENTORY}

=head2 3.3 Changes

${RESTRUCTURE_CHANGES}${CHANGES}

=head2 3.4 Adaptation data.

This installation requires that the installation site
has the Perl programming language installed.
Installation sites running Microsoft Operating systems require
the installation of Unix utilities. 
An excellent, highly recommended Unix utilities for Microsoft
operating systems is unxutils by Karl M. Syring.
A copy is available at the following web sites:

 http://unxutils.sourceforge.net
 http://packages.SoftwareDiamnds.com

There are no other additional requirements or tailoring needed of 
configurations files, adaptation data or other software needed for this
installation particular to any installation site.

=head2 3.5 Related documents.

There are no related documents needed for the installation and
test of this release.

=head2 3.6 Installation instructions.

Instructions for installation, installation tests
and installation support are as follows:

=over 4

=item Installation Instructions.

${INSTALLATION}

=item Prerequistes.

${PREREQ_PM_TEXT}

=item Security, privacy, or safety precautions.

None.

=item Installation Tests.

Most Perl installation software will run the following test script(s)
as part of the installation:

${TEST_INVENTORY}

=item Installation support.

If there are installation problems or questions with the installation
contact

 ${SUPPORT}

=back

=head2 3.7 Possible problems and known errors

${PROBLEMS}

=head1 4.0 NOTES

${NOTES}

=head1 2.0 SEE ALSO

${SEE_ALSO}

=for html
${HTML}

=cut

EOF

}





1

__END__


=head1 NAME

ExtUtils::SVDmaker - generates CPAN distribution packages and Software Version Descriptions (SVD)

=head1 SYNOPSIS

 use ExtUtils::SVDmaker;

 $svd = new ExtUtils::SVDmaker( @options );
 $svd = new ExtUtils::SVDmaker( \%options );

 $svd->vmake( @targets, \%options ); 
 $svd->vmake( @targets ); 
 $svd->vmake( \%options  ); 

=head1 DESCRIPTION

The "ExtUtils::SVDmaker" 
program module extends the Perl language (Perl is the system).

The input to "ExtUtils::SVDmaker" is the __DATA__
section of Software Version Description (SVD)
program module.
The __DATA__ section must contain SVD
forms text database in the
L<DataPort::FileType::DataDB|DataPort::FileType::DataDB> format.

Use the "vmake.pl" (SVD make) cover script for 
L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> to process a SVD database
module as follows:

  vmake -pm=Docs::Site_SVD::MySVDmodule

The preferred location for SVD program modules is

 Docs::Site_SVD::

The "ExtUtils::SVDmaker" module extends
the automation of releasing a Perl distribution file as
follows:

=over

=item *

The input data for the "ExtUtils::SVDmaker" module
is a form database file in the format of 
L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>.
This is an efficient text database that is very close in
format to hard copy forms and may be edited by text editors

=item *

compares the contents of the current release with the previous
release and automatically updates the version and date for files that
have changed

=item *

generates a SVD program module from the form database data.


=item *

generates MANIFEST, README and Makefile.PL distribution
files from the form database data

=item *

Builds the distribution *.tar.gz file

=item *

Runs the installation tests on the distribution files

=back

The L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> module is one of the
end user, functional interface modules for the US DOD STD2167A bundle.

The dependency of the program modules in the US DOD STD2167A bundle is as follows:

   Text::Scrub File::Package File::TestPath File::SmartNL

     Test::Tech 

        DataPort::FileType::FormDB DataPort::DataFile Text::Replace Text::Column
        File::AnySpec File::Data File::PM2File File::SubPM

            Test::STDmaker ExtUtils::SVDmaker

The top level modules that establish the functional interface of
interest to the end user are the "Test::STDmaker" and "ExtUtils::SVDmaker"
modules.
The rest of the modules in the above dependency tree are design
modules for the US DOD STD2167A bundle. 
They are broken out as separate modules because they may
have uses outside of the US DOD STD2167A bundle.

The L<Test::STDmaker|Test::STDmaker> module has a number of design modules not
shown in the above dependency tree. 
See L<Test::STDmaker|Test::STDmaker> for more detail.

=head2 SVD Program Module Format

The input(s) for the C<fgenerate> method
are Softare Version Description (SVD) Program Modules (PM).

A SVD PM consists of three sections as follows:

=over 4

=item Perl Code Section

The code section contains the following
Perl scalars: $VERSION, $DATE, and $FILE.
The "ExtUtils::STDmaker" automatically generates this section.

=item SVD POD Section

The SVD POD section is a slightly tailored 
United States (US) Department of Defense (DOD)
L<SVD Data Item Description (DID)|Docs::US_DOD::SVD> format.

The tailoring is that
paragraph 2 of the SVD DID is renamed from "REFERENCE DOCUMENTS" to 
"SEE ALSO" and moved to the end.
The content of paragraph, 1.2 System Overview, is changed
to include a brief statement of the software features and
capabilities.
The system is always the same, the Perl language. 
This makes better use of this space.

The "ExtUtils::SVDmaker" module
automatically generates this section.

=item SVD Form Database Section

This section contains a SVD Form Database that
the "ExtUtils::SVDmaker" module uses to generate the
Perl code section and the SVD POD section.

=back

=head2 SVD Form Database Fields

The "ExtUtils::SVDmaker" module uses the
L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>
lenient format to access the data.

This is a very compact database form. 
The fields are a merge of the data required by
the United States (US) Department of Defense (DOD)
L<SVD Data Item Description (DID)|DOCS::US_DOD::SVD>
and the L<ExtUtils::MakeMaker|ExtUtils::MakeMaker> module.

The following are the database file fields:

=over 4

=item ABSTRACT field

This field should be a one line description of the module. 
It Will be included in PPD file.

=item AUTHOR field

This field should contain 
the name (and email address) of package author(s). 
It is used in PPD (Perl Package Description) files for PPM (Perl Package Manager)
and as the "prepared by" entry in the title page of the generated SVD module POD
section.

=item AUTO_REVISE field

This is the list of files
(excluding the generated files 
MANIFEST, Makefile.pl, README and the $SVD.pm)
in the distribution.
The file specification may contain BSD globbing
metacharaters such as the '*'.

=item CAPABILITIES

This paragraph shall briefly state
the purpose the software, its features and
capabilities.

=item CHANGE2CURRENT field

This field is normally left blank. 
This field only comes into play when the previous and current
distribution names are different.
In this case the "ExtUtils::SVDmaker" module,
after it has restored the previous release directory,
will copy each file from the previous release directory 
to the current release directory.

Before the copy,
the "ExtUtils::SVDmaker" module evals for each restored file, 
the "CHANGE2CURRENT" field.
The file name for the current release is contained in the variable $file.
Thus, the Perl statements in the 
"CHANGE2CURRENT" field should be use to change the names of files from a previous
release with different files names for the current release.

For example, to moved the top level from "lib/SVD" to
"lib/ExtUtils", use the following:

  return if $file =~ s=lib/SVD/SVDmaker.pm=lib/ExtUtils/SVDmaker.pm=;^

=item CHANGES field

This field should contain a list
of all changes incorporated into the software version since the
previous version.
It may include a brief history of changes to other versions.

This field should identify, as applicable, 
the problem reports, change proposals, and change
notices associated with each change and the effects, if any, of
each change on system operation and on interfaces with other hardware
and software.

=item CLASSIFICATION field

This field should include security other restrictions 
on the handling of the software.

=item COMPRESS field

This field is the program for compression. Normally this will be "gzip".

=item COMPRESS_SUFFIX field

This field is the default suffix for compressed files.
Normally this is '.gz'.

=item CSS field

The Casscading Style Sheet (css) file for the readme html. 
Normally this is "help.css".

=item DISTNAME field

This is the name for distributing the package (by tar file).
For library modules, this should be the package name
with the '::' characters replaced with the '-' character.

=item DOCUMENT_OVERVIEW field

This field should summarize the
purpose and contents of this document and shall describe any security
or privacy considerations associated with its use.

=item END_USER field

This field is the "prepare for" entry in the title page of 
the generated SVD module POD section.

=item FREEZE field

Normally this field will be set to 0 in order
to make dry-runs of the distribution.
When set to 0, the version of the master library
will not be changed.
Set this field to 1 for the finalized distribution.
The version number for any master library module
that changed since the last distribution will
be updated.

=item HTML field

This field is for HTML code at the end of
the SVD POD section.
For example,

 <hr>
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->

=item INSTALLATION field

This field should include the following information:

=over 4

=item *

Instructions for installing the software version.

=item *

Identification of other changes that have
to be installed for this version to be used, including site-unique
adaptation data not included in the software version

=item *

Security, privacy, or safety precautions relevant
to the installation

=back

=item LICENSE field

This field should contain any
restrictions regarding duplication and license provisions.
Any copyright notice should also be included in this
field.

=item NOTES field

This field should contain any general
information that aids in understanding this document (e.g., background
information, glossary, rationale). This field shall include
an alphabetical listing of all acronyms, abbreviations, and their
meanings as used in this document and a list of any terms and
definitions needed to understand this document. 

=item PREREQ_PM field

This field contains the names of modules that need to be available 
to run this extension (e.g. Fcntl for SDBM_File) followed by
the desired version is the value. 
This field should use Perl array notation.
For examples:

 'Fcntl' => '0',
 'Test::Tech' => '1.09',

If the required version number is 0, 
any installed version is acceptable.

=item PREVIOUS_DISTNAME field

This field is normally left blank.
Supply this field when the 
previous distribution name is different.

=item PREVIOUS_RELEASE field

This field is the version of the previous release.

=item PROBLEMS field

This field should identify any
possible problems or known errors with the software version at
the time of release, any steps being taken to resolve the problems
or errors, and instructions (either directly or by reference)
for recognizing, avoiding, correcting, or otherwise handling each
one. The information presented shall be appropriate to the intended
recipient of the SVD (for example, a user agency may need advice
on avoiding errors, a support agency on correcting them).

=item REPOSITORY field

This field is the repositories that the current distribution will 
be released.

For example,

 http://www.softwarediamonds/packages/
 http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/

=item REPOSITORY_DIR field

The value for the REPOSITORY_DIR is normally "packages".
This is the directory where all release files are found.
The "ExtUtils::SVDmaker" module uses the REPOSITORY_DIR
as follows:

=over 4

=item *

First it locates the $TOP_DIR of the package specified
by the -pm option. 

=item *

It locates the repository directory by using REPOSITORY_DIR field
as a sub directory of the $TOP_DIR.

=back

The directory structure assumed by the "ExtUtils::SVDmaker" 
module is, thus, as follows:

 $TOP_DIR -+- lib -- * -- $svd.pm
           |
           +- bin
           |
           +- $REPOSITORY_DIR -+- $DISTNAME-$PREVIOUS_VERSION -+- lib
                               |                               +- bin
                               |                               +- blib 
                               |                               +- Makefile.PL
                               |                               +- README
                               |                               +- MANIFEST
                               |
                               +- $DISTNAME-$VERSION.tar.gz
                                  $DISTNAME-$VERSION.ppd
                                  $DISTNAME-$VERSION.html

 $RELEASE_DIR = $TOPDIR $REPOSITORY_DIR $DISTNAME-$PREVIOUS_VERSION

When the PREVIOUS_DISTNAME field is different than the DISTNAME field, the
directory structure is as follows:

 $TOP_DIR -+- lib -- * -- $svd.pm
           |
           +- bin
           |
           +- $REPOSITORY_DIR -+- $PREVIOUS_DISTNAME-$PREVIOUS_VERSION -+- lib
                               |                                        +- bin
                               |                                        +- blib 
                               |                                        +- Makefile.PL
                               |                                        +- README
                               |                                        +- MANIFEST
                               |
                               +- $DISTNAME-$VERSION -+- lib
                               |                      +- bin
                               |                      +- blib 
                               |                      +- Makefile.PL
                               |                      +- README
                               |                      +- MANIFEST
                               |
                               +- $DISTNAME-$VERSION.tar.gz
                                  $DISTNAME-$VERSION.ppd
                                  $DISTNAME-$VERSION.html

 $RELEASE_DIR = $TOPDIR $REPOSITORY_DIR $DISTNAME-$VERSION

=item RESTRUCTURE field

This field is Perl statements that the
"ExtUtils::SVDmaker" uses to rearrange
the directory tree of the release directory.

For example, to eliminate the "lib\SVD"
subtree, enter the following:

 use File::Path;
 rmtree 'lib\SVD';

The evaluation takes place after all "CHANGE2CURRENT" field
processing and with the cwd the current release directory,
not the previous release directory if they are different.

See also L<CHANGE2CURRENT field|/CHANGE2CURRENT field>;

=item REVISION field

Enter the revision for the STD POD.
The revision field, in accordance
with standard engineering drawing
practices are letters A .. B AA .. ZZ
except for the orginal revision which
is -.

=item SEE_ALSO field

This field shall list the number,
title, revision, and date of all referenced and related documents.  
This field shall also identify the source for all
documents.
A simple POD link, when applicable, will satisfy these
requirements.

=item SUPPORT field

Point of contact to be consulted if there
are problems or questions with the installation

=item TITLE field

This field is the "title" entry in the title page of the generated SVD module POD
section.

=item TEMPLATE field

This is the template that the
C<$svd->gen> method uses to generate
the SVD POD file.

=item TESTS field

List of tests for determining whether the version
has been installed properly and
meets its requirements.

=item VERSION field

This field is the version of the release. 
The version should be a decimal number of the
format "\d\.\d\d" starting with "0.01".

=back

=head2 Options

=over 4

=item verbose option

=item pm option

=back

=head2 targets

For this discussion of the targets, the
directory structure shown in the
L<REPOSITORY_DIR field|/REPOSITORY_DIR field>
item applies.

=over 4

=item all

This target executes the following target sequence 

 "check_svd_db restore_previous auto_revise write_svd_pm makemake build"

=item auto_revise target

This target uses the relative files specified in the 
L<AUTO_REVISE field|/AUTO_REVISE field>.
FOr each of the these files, $file, it will
compare ($TOP_DIR $file) with ($RELEASE_DIR $file),
scrubing any date and version so they are not compared.

If the contents of ($TOP_DIR $file) is different
than the ($RELEASE_DIR $file), this target will
update the ($RELEASE_DIR $file) to the ($TOP_DIR $file)
and appropriately change the version and date.

The $TOP_DIR and $RELEASE_DIR used in this description is
as established by L<REPOSITORY_DIR field|/REPOSITORY_DIR field>
item.

Before performing the above sequence,
this target will ensure that the following
sequence of targets have been executed once

 "check_svd_db restore_previous"

=item build target

This is the same as 

 makepl
 make
 make test TEST_VERBOSE=1
 make dist
 make ppd

Before performing the above sequence,
this target will ensure that the following
sequence targets have been executed once 

 "check_svd_db restore_previous auto_revise makemake"

=item check_svd_db target

This target checks the integrity of the 
SVD database and creates derived fields
such as "TOP_DIR" helpful in processing
other targets.

=item clear target

The following targets are executed only once no matter
how many times they are specified. 
The target "clear" will clear the block and allow them
to be executed again.

 check_svd_db
 restore_previous
 auto_revise
 write_svd_pm
 readme_html
 makepl
 makemake
 build

=item make target

This targe executes the appropriate "make" for
the site operating system. For "$^O eq 'MSWin32'",
this will be the "nmake" application.

=item makemake target

This target generates the following 
files:

 README
 MANIFEST
 Makefile.PL

Before generating the above files,
this target will ensure that the following
sequence targets have been executed once

 "check_svd_db restore_previous auto_revise"

=item makepl target

This target generates the following file:

 Makefile.PL

Before generating the above files,
this target will ensure that the following
sequence targets have been executed once

 "check_svd_db restore_previous auto_revise"

=item pm target

This target generates the Perl and POD section
of the SVD program module from the __DATA__ section.
It updates both the copy in the $TOP_DIR subtree and the
$RELEASE_DIR subtree.

The $TOP_DIR and $RELEASE_DIR used in this description is
as established by L<REPOSITORY_DIR field|/REPOSITORY_DIR field>
item.

Before generating the above files,
this target will ensure that the following
sequence targets have been executed once

 "check_svd_db restore_previous auto_revise"

=item readme_html target

This target generates the file

 $REPOSITORY_DIR $DISTNAME-$VERSION.html

The $REPOSITORY_DIR scalar used in this description is
as established by L<REPOSITORY_DIR field|/REPOSITORY_DIR field>
item.

Before generating the above files,
this target will ensure that the following
sequence targets have been executed once

 "check_svd_db restore_previous auto_revise write_svd_pm"

=item restore_previous target

=item # no target

A lack of a target is the same as 

 "all readme_html"

=back

=head1 REQUIREMENTS

Requirements are coming soon.

=head1 DEMONSTRATION

 ~~~~~~ Demonstration overview ~~~~~

Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

 =>     use vars qw($loaded);
 =>     use File::Glob ':glob';
 =>     use File::Copy;
 =>     use File::Path;
 =>     use File::Package;
 =>     use File::SmartNL;
 =>     use Text::Scrub;
 =>     use IO::String;

 =>     my $loaded = 0;
 =>     my $snl = 'File::SmartNL';
 =>     my $fp = 'File::Package';
 =>     my $s = 'Text::Scrub';
 => $fp->is_package_loaded('ExtUtils::SVDmaker')
 ''

 => my $errors = $fp->load_package( 'ExtUtils::SVDmaker' )
 => $errors
 ''

 =>     ######
 =>     # Add the SVDmaker test lib and test t directories onto @INC
 =>     #
 =>     unshift @INC, File::Spec->catdir( cwd(), 't');
 =>     unshift @INC, File::Spec->catdir( cwd(), 'lib');
 =>     my $script_dir = cwd();
 =>     chdir 'lib';
 =>     unlink 'SVDtest1.pm','module1.pm';
 =>     copy 'SVDtest0.pm','SVDtest1.pm';
 =>     copy 'module0.pm','module1.pm';
 =>     chdir $script_dir;
 =>     chdir 't';
 =>     unlink 'SVDtest1.t';
 =>     copy 'SVDtest0.t','SVDtest1.t';
 =>     chdir $script_dir; 
 =>     rmtree 'packages';
 => $snl->fin( File::Spec->catfile('lib', 'module1.pm'))
 '#!perl
 #
 # Documentation, copyright and license is at the end of this file.
 #
 package  module1;

 use 5.001;
 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE $FILE);
 $VERSION = '0.01';
 $DATE = '2003/06/15';
 $FILE = __FILE__;

 ####
 # Using an object to pass localized object data
 # between functions. Makes the functions reentrant
 # where out right globals can be clobbered when
 # used with different threads (processes??)
 #
 sub new
 {
     my ($class, $test_log) = @_;
     $class = ref($class) if ref($class);
     bless {}, $class;

 }

 #####
 # Test method
 #
 sub hello 
 {
    "hello world"

 }

 1

 __END__

 =head1 NAME

 module1 - SVDmaker test module

 =cut

 ### end of file ###'

 => $snl->fin( File::Spec->catfile('lib', 'SVDtest1.pm'))
 '#!perl
 #
 # The copyright notice and plain old documentation (POD)
 # are at the end of this file.
 #
 package SVDtest1;

 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE $FILE );
 $VERSION = '0.01';
 $DATE = '2003/06/11';
 $FILE = __FILE__;

 1

 __DATA__

 DISTNAME: SVDtest1^
 VERSION:1.03^ 
 REPOSITORY_DIR: packages^
 FREEZE: 0^

 PREVIOUS_DISTNAME:  ^
 PREVIOUS_RELEASE: ^
 REVISION: -^
 AUTHOR  : SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>^

 ABSTRACT: 
 Objectify the Test module,
 adds the skip_test method to the Test module, and 
 adds the ability to compare complex data structures to the Test module.
 ^

 TITLE   : ExtUtils::SVDmaker::SVDtest - Test SVDmaker^
 END_USER: General Public^
 COPYRIGHT: copyright © 2003 Software Diamonds^
 CLASSIFICATION: NONE^
 TEMPLATE:  ^
 CSS: help.css^
 SVD_FSPEC: Unix^

 REPOSITORY: 
   http://www.softwarediamonds/packages/
   http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/
 ^

 COMPRESS: gzip^
 COMPRESS_SUFFIX: gz^

 CHANGE2CURRENT:  ^

 RESTRUCTURE:  ^

 AUTO_REVISE: 
 lib/SVDtest1.pm
 lib/module1.pm
 t/SVDtest1.t
 ^

 PREREQ_PM: 'File::Basename' => 0^

 TESTS: t/SVDtest1.t^
 EXE_FILES:  ^

 CHANGES: 
 This is the original release. There are no preivious releases to change.
 ^

 CAPABILITIES: The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module. ^

 PROBLEMS: There are no open issues.^

 DOCUMENT_OVERVIEW:
 This document releases ${NAME} version ${VERSION}
 providing description of the inventory, installation
 instructions and other information necessary to
 utilize and track this release.
 ^

 LICENSE:
 Software Diamonds permits the redistribution
 and use in source and binary forms, with or
 without modification, provided that the 
 following conditions are met: 

 \=over 4

 \=item 1

 Redistributions of source code, modified or unmodified
 must retain the above copyright notice, this list of
 conditions and the following disclaimer. 

 \=item 2

 Redistributions in binary form must 
 reproduce the above copyright notice,
 this list of conditions and the following 
 disclaimer in the documentation and/or
 other materials provided with the
 distribution.

 \=back

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

 INSTALLATION:
 To installed the release file, use the CPAN module in the Perl release
 or the INSTALL.PL script at the following web site:

  http://packages.SoftwareDiamonds.com

 Follow the instructions for the the chosen installation software.

 The distribution file is at the following respositories:

 ${REPOSITORY}
 ^

 SUPPORT: 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>^

 NOTES:
 The following are useful acronyms:

 \=over 4

 \=item .d

 extension for a Perl demo script file

 \=item .pm

 extension for a Perl Library Module

 \=item .t

 extension for a Perl test script file

 \=item DID

 Data Item Description

 \=item POD

 Plain Old Documentation

 \=item STD

 Software Test Description

 \=item SVD

 Software Version Description

 \=back
 ^

 SEE_ALSO:

 \=over 4

 \=item L<ExtUtils::SVDmake|ExtUtils::SVDmaker>

 \=back

 ^

 HTML:
 <hr>
 <p><br>
 <!-- BLK ID="PROJECT_MANAGEMENT" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->
 <p><br>
 ^
 ~-~

 '

 => $snl->fin( File::Spec->catfile('t', 'SVDtest1.t'))
 '#!perl
 #
 #
 use 5.001;
 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE);
 $VERSION = '0.01';
 $DATE = '2003/07/06';

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

 '

 =>     unlink 'SVDtest1.log';
 =>     no warnings;
 =>     open SAVE_OUT, ">&STDOUT";
 =>     open SAVE_ERR, ">&STDERR";
 =>     use warnings;
 =>     open STDOUT,'> SVDtest1.log';
 =>     open STDERR, ">&STDOUT";
 =>     my $svd = new ExtUtils::SVDmaker( );
 =>     skip_tests(1) unless $svd->vmake( {pm => 'SVDtest1'} );
 =>     close STDOUT;
 =>     close STDERR;
 =>     open STDOUT, ">&SAVE_OUT";
 =>     open STDERR, ">&SAVE_ERR";
 =>     my $output = $snl->fin( 'SVDtest1.log' );
 => $output
 'Checking if your kit is complete...
 Looks good
 Writing Makefile for SVDtest1
 cp lib/module1.pm blib\lib\module1.pm
 cp lib/SVDtest1.pm blib\lib\SVDtest1.pm
 Using E:/User/SoftwareDiamonds/installation/t/ExtUtils/SVDmaker/packages/SVDtest1-0.01/blib
 	D:\Perl\bin\perl.exe -Mblib -ID:\Perl\lib -ID:\Perl\lib -e "use Test::Harness qw(&runtests $verbose); $verbose=1; runtests @ARGV;" t\SVDtest1.t
 t\SVDtest1..........1..3
 # OS            : MSWin32
 # Perl          : 5.006001 Win32 Build 631
 # Local Time    : Mon Jul  7 05:51:34 2003
 # GMT Time      : Mon Jul  7 09:51:34 2003 GMT
 # Test          : 1.15
 # Number Storage: string
 # Test::Tech    : 1.09
 # Data::Dumper  : 2.102
 # =cut 
 # UUT not loaded
 ok 1
 # Load UUT
 ok 2
 # test hello world
 ok 3
 ok
 All tests successful.
 Files=1, Tests=3,  1 wallclock secs ( 0.00 cusr +  0.00 csys =  0.00 CPU)
 	D:\Perl\bin\perl.exe -ID:\Perl\lib -ID:\Perl\lib -MExtUtils::Command -e rm_rf SVDtest1-0.01
 	D:\Perl\bin\perl.exe -ID:\Perl\lib -ID:\Perl\lib -MExtUtils::Manifest=manicopy,maniread  -e "manicopy(maniread(),'SVDtest1-0.01', 'best');"
 mkdir SVDtest1-0.01
 mkdir SVDtest1-0.01/lib
 mkdir SVDtest1-0.01/t
 	tar cvf SVDtest1-0.01.tar SVDtest1-0.01
 SVDtest1-0.01/
 SVDtest1-0.01/lib/
 SVDtest1-0.01/lib/module1.pm
 SVDtest1-0.01/lib/SVDtest1.pm
 SVDtest1-0.01/Makefile.PL
 SVDtest1-0.01/MANIFEST
 SVDtest1-0.01/README
 SVDtest1-0.01/t/
 SVDtest1-0.01/t/SVDtest1.t
 	D:\Perl\bin\perl.exe -ID:\Perl\lib -ID:\Perl\lib -MExtUtils::Command -e rm_rf SVDtest1-0.01
 	gzip SVDtest1-0.01.tar
 '

 => $output =~ /All tests successful/
 '1'

 => $s->scrub_date( $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' ) ) )
 '#!perl
 #
 # The copyright notice and plain old documentation (POD)
 # are at the end of this file.
 #
 package  SVDtest1;

 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE $FILE );
 $VERSION = '0.01';
 $DATE = '1969/02/06';
 $FILE = __FILE__;

 use vars qw(%INVENTORY);
 %INVENTORY = (
     'lib/SVDtest1.pm' => [qw(0.01 1969/02/06), 'new'],
     'MANIFEST' => [qw(0.01 1969/02/06), 'generated new'],
     'Makefile.PL' => [qw(0.01 1969/02/06), 'generated new'],
     'README' => [qw(0.01 1969/02/06), 'generated new'],
     'lib/SVDtest1.pm' => [qw(0.01 1969/02/06), 'new'],
     'lib/module1.pm' => [qw(0.01 1969/02/06), 'new'],
     't/SVDtest1.t' => [qw(0.01 1969/02/06), 'new'],

 );

 ########
 # The ExtUtils::SVDmaker module uses the data after the __DATA__ 
 # token to generate this file.
 #
 # Don't edit anything before __DATA_. Edit instead
 # the data after the __DATA__ token.
 #
 # ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
 #
 # the next time ExtUtils::SVDmaker generates this file.
 #
 #

 =head1 Title Page

  Software Version Description

  for

  ExtUtils::SVDmaker::SVDtest - Test SVDmaker

  Revision: -

  Version: 0.01

  Date: 1969/02/06

  Prepared for: General Public 

  Prepared by:  SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>

  Copyright: copyright © 2003 Software Diamonds

  Classification: NONE

 =head1 1.0 SCOPE

 This paragraph identifies and provides an overview
 of the released files.

 =head2 1.1 Identification

 This release,
 identified in L<3.2|/3.2 Inventory of software contents>,
 is a collection of Perl modules that
 extend the capabilities of the Perl language.

 =head2 1.2 System overview

 The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module.

 =head2 1.3 Document overview.

 This document releases SVDtest1 version 0.01
 providing description of the inventory, installation
 instructions and other information necessary to
 utilize and track this release.

 =head1 3.0 VERSION DESCRIPTION

 All file specifications in this SVD
 use the Unix operating
 system file specification.

 =head2 3.1 Inventory of materials released.

 This document releases the file found
 at the following repository(s):

    http://www.softwarediamonds/packages/SVDtest1-0.01
    http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

 Restrictions regarding duplication and license provisions
 are as follows:

 =over 4

 =item Copyright.

 copyright © 2003 Software Diamonds

 =item Copyright holder contact.

  603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

 =item License.

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

 =back

 =head2 3.2 Inventory of software contents

 The content of the released, compressed, archieve file,
 consists of the following files:

  file                                                         version date       comment
  ------------------------------------------------------------ ------- ---------- ------------------------
  lib/SVDtest1.pm                                              0.01    1969/02/06 new
  MANIFEST                                                     0.01    1969/02/06 generated new
  Makefile.PL                                                  0.01    1969/02/06 generated new
  README                                                       0.01    1969/02/06 generated new
  lib/SVDtest1.pm                                              0.01    1969/02/06 new
  lib/module1.pm                                               0.01    1969/02/06 new
  t/SVDtest1.t                                                 0.01    1969/02/06 new

 =head2 3.3 Changes

 This is the original release. There are no preivious releases to change.

 =head2 3.4 Adaptation data.

 This installation requires that the installation site
 has the Perl programming language installed.
 Installation sites running Microsoft Operating systems require
 the installation of Unix utilities. 
 An excellent, highly recommended Unix utilities for Microsoft
 operating systems is unxutils by Karl M. Syring.
 A copy is available at the following web sites:

  http://unxutils.sourceforge.net
  http://packages.SoftwareDiamnds.com

 There are no other additional requirements or tailoring needed of 
 configurations files, adaptation data or other software needed for this
 installation particular to any installation site.

 =head2 3.5 Related documents.

 There are no related documents needed for the installation and
 test of this release.

 =head2 3.6 Installation instructions.

 Instructions for installation, installation tests
 and installation support are as follows:

 =over 4

 =item Installation Instructions.

 To installed the release file, use the CPAN module in the Perl release
 or the INSTALL.PL script at the following web site:

  http://packages.SoftwareDiamonds.com

 Follow the instructions for the the chosen installation software.

 The distribution file is at the following respositories:

    http://www.softwarediamonds/packages/SVDtest1-0.01
    http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

 =item Prerequistes.

  'File::Basename' => 0

 =item Security, privacy, or safety precautions.

 None.

 =item Installation Tests.

 Most Perl installation software will run the following test script(s)
 as part of the installation:

  t/SVDtest1.t

 =item Installation support.

 If there are installation problems or questions with the installation
 contact

  603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

 =back

 =head2 3.7 Possible problems and known errors

 There are no open issues.

 =head1 4.0 NOTES

 The following are useful acronyms:

 =over 4

 =item .d

 extension for a Perl demo script file

 =item .pm

 extension for a Perl Library Module

 =item .t

 extension for a Perl test script file

 =item DID

 Data Item Description

 =item POD

 Plain Old Documentation

 =item STD

 Software Test Description

 =item SVD

 Software Version Description

 =back

 =head1 2.0 SEE ALSO

 =over 4

 =item L<ExtUtils::SVDmake|ExtUtils::SVDmaker>

 =back

 =for html
 <hr>
 <p><br>
 <!-- BLK ID="PROJECT_MANAGEMENT" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->
 <p><br>

 =cut

 1;

 __DATA__

 DISTNAME: SVDtest1^
 VERSION : 0.01^
 REPOSITORY_DIR: packages^
 FREEZE: 0^

 PREVIOUS_DISTNAME:  ^
 PREVIOUS_RELEASE:  ^
 REVISION: -^
 AUTHOR  : SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>^

 ABSTRACT: 
 Objectify the Test module,
 adds the skip_test method to the Test module, and 
 adds the ability to compare complex data structures to the Test module.
 ^

 TITLE   : ExtUtils::SVDmaker::SVDtest - Test SVDmaker^
 END_USER: General Public^
 COPYRIGHT: copyright © 2003 Software Diamonds^
 CLASSIFICATION: NONE^
 TEMPLATE:  ^
 CSS: help.css^
 SVD_FSPEC: Unix^

 REPOSITORY: 
   http://www.softwarediamonds/packages/
   http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/
 ^

 COMPRESS: gzip^
 COMPRESS_SUFFIX: gz^

 CHANGE2CURRENT:  ^

 RESTRUCTURE:  ^

 AUTO_REVISE: 
 lib/SVDtest1.pm
 lib/module1.pm
 t/SVDtest1.t
 ^

 PREREQ_PM: 'File::Basename' => 0^

 TESTS: t/SVDtest1.t^
 EXE_FILES:  ^

 CHANGES: 
 This is the original release. There are no preivious releases to change.
 ^

 CAPABILITIES: The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module. ^

 PROBLEMS: There are no open issues.^

 DOCUMENT_OVERVIEW:
 This document releases ${NAME} version ${VERSION}
 providing description of the inventory, installation
 instructions and other information necessary to
 utilize and track this release.
 ^

 LICENSE:
 Software Diamonds permits the redistribution
 and use in source and binary forms, with or
 without modification, provided that the 
 following conditions are met: 

 \=over 4

 \=item 1

 Redistributions of source code, modified or unmodified
 must retain the above copyright notice, this list of
 conditions and the following disclaimer. 

 \=item 2

 Redistributions in binary form must 
 reproduce the above copyright notice,
 this list of conditions and the following 
 disclaimer in the documentation and/or
 other materials provided with the
 distribution.

 \=back

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

 INSTALLATION:
 To installed the release file, use the CPAN module in the Perl release
 or the INSTALL.PL script at the following web site:

  http://packages.SoftwareDiamonds.com

 Follow the instructions for the the chosen installation software.

 The distribution file is at the following respositories:

 ${REPOSITORY}
 ^

 SUPPORT: 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>^

 NOTES:
 The following are useful acronyms:

 \=over 4

 \=item .d

 extension for a Perl demo script file

 \=item .pm

 extension for a Perl Library Module

 \=item .t

 extension for a Perl test script file

 \=item DID

 Data Item Description

 \=item POD

 Plain Old Documentation

 \=item STD

 Software Test Description

 \=item SVD

 Software Version Description

 \=back
 ^

 SEE_ALSO:

 \=over 4

 \=item L<ExtUtils::SVDmake|ExtUtils::SVDmaker>

 \=back

 ^

 HTML:
 <hr>
 <p><br>
 <!-- BLK ID="PROJECT_MANAGEMENT" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->
 <p><br>
 ^
 ~-~

 '

 => $s->scrub_date( $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'lib', 'SVDtest1.pm' ) ) )
 '#!perl
 #
 # The copyright notice and plain old documentation (POD)
 # are at the end of this file.
 #
 package  SVDtest1;

 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE $FILE );
 $VERSION = '0.01';
 $DATE = '1969/02/06';
 $FILE = __FILE__;

 use vars qw(%INVENTORY);
 %INVENTORY = (
     'lib/SVDtest1.pm' => [qw(0.01 1969/02/06), 'new'],
     'MANIFEST' => [qw(0.01 1969/02/06), 'generated new'],
     'Makefile.PL' => [qw(0.01 1969/02/06), 'generated new'],
     'README' => [qw(0.01 1969/02/06), 'generated new'],
     'lib/SVDtest1.pm' => [qw(0.01 1969/02/06), 'new'],
     'lib/module1.pm' => [qw(0.01 1969/02/06), 'new'],
     't/SVDtest1.t' => [qw(0.01 1969/02/06), 'new'],

 );

 ########
 # The ExtUtils::SVDmaker module uses the data after the __DATA__ 
 # token to generate this file.
 #
 # Don't edit anything before __DATA_. Edit instead
 # the data after the __DATA__ token.
 #
 # ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
 #
 # the next time ExtUtils::SVDmaker generates this file.
 #
 #

 =head1 Title Page

  Software Version Description

  for

  ExtUtils::SVDmaker::SVDtest - Test SVDmaker

  Revision: -

  Version: 0.01

  Date: 1969/02/06

  Prepared for: General Public 

  Prepared by:  SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>

  Copyright: copyright © 2003 Software Diamonds

  Classification: NONE

 =head1 1.0 SCOPE

 This paragraph identifies and provides an overview
 of the released files.

 =head2 1.1 Identification

 This release,
 identified in L<3.2|/3.2 Inventory of software contents>,
 is a collection of Perl modules that
 extend the capabilities of the Perl language.

 =head2 1.2 System overview

 The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module.

 =head2 1.3 Document overview.

 This document releases SVDtest1 version 0.01
 providing description of the inventory, installation
 instructions and other information necessary to
 utilize and track this release.

 =head1 3.0 VERSION DESCRIPTION

 All file specifications in this SVD
 use the Unix operating
 system file specification.

 =head2 3.1 Inventory of materials released.

 This document releases the file found
 at the following repository(s):

    http://www.softwarediamonds/packages/SVDtest1-0.01
    http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

 Restrictions regarding duplication and license provisions
 are as follows:

 =over 4

 =item Copyright.

 copyright © 2003 Software Diamonds

 =item Copyright holder contact.

  603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

 =item License.

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

 =back

 =head2 3.2 Inventory of software contents

 The content of the released, compressed, archieve file,
 consists of the following files:

  file                                                         version date       comment
  ------------------------------------------------------------ ------- ---------- ------------------------
  lib/SVDtest1.pm                                              0.01    1969/02/06 new
  MANIFEST                                                     0.01    1969/02/06 generated new
  Makefile.PL                                                  0.01    1969/02/06 generated new
  README                                                       0.01    1969/02/06 generated new
  lib/SVDtest1.pm                                              0.01    1969/02/06 new
  lib/module1.pm                                               0.01    1969/02/06 new
  t/SVDtest1.t                                                 0.01    1969/02/06 new

 =head2 3.3 Changes

 This is the original release. There are no preivious releases to change.

 =head2 3.4 Adaptation data.

 This installation requires that the installation site
 has the Perl programming language installed.
 Installation sites running Microsoft Operating systems require
 the installation of Unix utilities. 
 An excellent, highly recommended Unix utilities for Microsoft
 operating systems is unxutils by Karl M. Syring.
 A copy is available at the following web sites:

  http://unxutils.sourceforge.net
  http://packages.SoftwareDiamnds.com

 There are no other additional requirements or tailoring needed of 
 configurations files, adaptation data or other software needed for this
 installation particular to any installation site.

 =head2 3.5 Related documents.

 There are no related documents needed for the installation and
 test of this release.

 =head2 3.6 Installation instructions.

 Instructions for installation, installation tests
 and installation support are as follows:

 =over 4

 =item Installation Instructions.

 To installed the release file, use the CPAN module in the Perl release
 or the INSTALL.PL script at the following web site:

  http://packages.SoftwareDiamonds.com

 Follow the instructions for the the chosen installation software.

 The distribution file is at the following respositories:

    http://www.softwarediamonds/packages/SVDtest1-0.01
    http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

 =item Prerequistes.

  'File::Basename' => 0

 =item Security, privacy, or safety precautions.

 None.

 =item Installation Tests.

 Most Perl installation software will run the following test script(s)
 as part of the installation:

  t/SVDtest1.t

 =item Installation support.

 If there are installation problems or questions with the installation
 contact

  603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

 =back

 =head2 3.7 Possible problems and known errors

 There are no open issues.

 =head1 4.0 NOTES

 The following are useful acronyms:

 =over 4

 =item .d

 extension for a Perl demo script file

 =item .pm

 extension for a Perl Library Module

 =item .t

 extension for a Perl test script file

 =item DID

 Data Item Description

 =item POD

 Plain Old Documentation

 =item STD

 Software Test Description

 =item SVD

 Software Version Description

 =back

 =head1 2.0 SEE ALSO

 =over 4

 =item L<ExtUtils::SVDmake|ExtUtils::SVDmaker>

 =back

 =for html
 <hr>
 <p><br>
 <!-- BLK ID="PROJECT_MANAGEMENT" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->
 <p><br>

 =cut

 1;

 __DATA__

 DISTNAME: SVDtest1^
 VERSION : 0.01^
 REPOSITORY_DIR: packages^
 FREEZE: 0^

 PREVIOUS_DISTNAME:  ^
 PREVIOUS_RELEASE:  ^
 REVISION: -^
 AUTHOR  : SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>^

 ABSTRACT: 
 Objectify the Test module,
 adds the skip_test method to the Test module, and 
 adds the ability to compare complex data structures to the Test module.
 ^

 TITLE   : ExtUtils::SVDmaker::SVDtest - Test SVDmaker^
 END_USER: General Public^
 COPYRIGHT: copyright © 2003 Software Diamonds^
 CLASSIFICATION: NONE^
 TEMPLATE:  ^
 CSS: help.css^
 SVD_FSPEC: Unix^

 REPOSITORY: 
   http://www.softwarediamonds/packages/
   http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/
 ^

 COMPRESS: gzip^
 COMPRESS_SUFFIX: gz^

 CHANGE2CURRENT:  ^

 RESTRUCTURE:  ^

 AUTO_REVISE: 
 lib/SVDtest1.pm
 lib/module1.pm
 t/SVDtest1.t
 ^

 PREREQ_PM: 'File::Basename' => 0^

 TESTS: t/SVDtest1.t^
 EXE_FILES:  ^

 CHANGES: 
 This is the original release. There are no preivious releases to change.
 ^

 CAPABILITIES: The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module. ^

 PROBLEMS: There are no open issues.^

 DOCUMENT_OVERVIEW:
 This document releases ${NAME} version ${VERSION}
 providing description of the inventory, installation
 instructions and other information necessary to
 utilize and track this release.
 ^

 LICENSE:
 Software Diamonds permits the redistribution
 and use in source and binary forms, with or
 without modification, provided that the 
 following conditions are met: 

 \=over 4

 \=item 1

 Redistributions of source code, modified or unmodified
 must retain the above copyright notice, this list of
 conditions and the following disclaimer. 

 \=item 2

 Redistributions in binary form must 
 reproduce the above copyright notice,
 this list of conditions and the following 
 disclaimer in the documentation and/or
 other materials provided with the
 distribution.

 \=back

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

 INSTALLATION:
 To installed the release file, use the CPAN module in the Perl release
 or the INSTALL.PL script at the following web site:

  http://packages.SoftwareDiamonds.com

 Follow the instructions for the the chosen installation software.

 The distribution file is at the following respositories:

 ${REPOSITORY}
 ^

 SUPPORT: 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>^

 NOTES:
 The following are useful acronyms:

 \=over 4

 \=item .d

 extension for a Perl demo script file

 \=item .pm

 extension for a Perl Library Module

 \=item .t

 extension for a Perl test script file

 \=item DID

 Data Item Description

 \=item POD

 Plain Old Documentation

 \=item STD

 Software Test Description

 \=item SVD

 Software Version Description

 \=back
 ^

 SEE_ALSO:

 \=over 4

 \=item L<ExtUtils::SVDmake|ExtUtils::SVDmaker>

 \=back

 ^

 HTML:
 <hr>
 <p><br>
 <!-- BLK ID="PROJECT_MANAGEMENT" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="NOTICE" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="OPT-IN" -->
 <!-- /BLK -->
 <p><br>
 <!-- BLK ID="LOG_CGI" -->
 <!-- /BLK -->
 <p><br>
 ^
 ~-~

 '

 => $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'MANIFEST' ) )
 'lib/SVDtest1.pm
 MANIFEST
 Makefile.PL
 README
 lib/SVDtest1.pm
 lib/module1.pm
 t/SVDtest1.t'

 => $snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'Makefile.PL' ) )
 '
 ####
 # 
 # The module ExtUtils::STDmaker generated this file from the contents of
 #
 # SVDtest1 
 #
 # Don't edit this file, edit instead
 #
 # SVDtest1
 #
 #	ANY CHANGES MADE HERE WILL BE LOST
 #
 #       the next time ExtUtils::STDmaker generates it.
 #
 #

 use ExtUtils::MakeMaker;

 my $tests = join ' ',unix2os('t/SVDtest1.t');

 WriteMakefile(
     NAME => 'SVDtest1',
     DISTNAME => 'SVDtest1',
     VERSION  => '0.01',
     dist     => {COMPRESS => 'gzip',
                 'gz' => 'gz'},
     test     => {TESTS => $tests},
     PREREQ_PM => {'File::Basename' => 0},

     ($] >= 5.005 ?     
         (AUTHOR    => 'SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>',
         ABSTRACT  => 'Objectify the Test module,
 adds the skip_test method to the Test module, and 
 adds the ability to compare complex data structures to the Test module.', ) : ()),
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

 '

 => $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1-0.01', 'README' ) ))
 'Title Page
      Software Version Description

      for

      ExtUtils::SVDmaker::SVDtest - Test SVDmaker

      Revision: -

      Version: 0.01

      Date: 1969/02/06

      Prepared for: General Public 

      Prepared by:  SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>

      Copyright: copyright © 2003 Software Diamonds

      Classification: NONE

 1.0 SCOPE
     This paragraph identifies and provides an overview of the released
     files.

   1.1 Identification

     This release, identified in 3.2, is a collection of Perl modules that
     extend the capabilities of the Perl language.

   1.2 System overview

     The ExtUtils::SVDmaker::SVDtest module is a SVDmaker test module.

   1.3 Document overview.

     This document releases SVDtest1 version 0.01 providing description of
     the inventory, installation instructions and other information necessary
     to utilize and track this release.

 3.0 VERSION DESCRIPTION
     All file specifications in this SVD use the Unix operating system file
     specification.

   3.1 Inventory of materials released.

     This document releases the file found at the following repository(s):

        http://www.softwarediamonds/packages/SVDtest1-0.01
        http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

     Restrictions regarding duplication and license provisions are as
     follows:

     Copyright.
         copyright © 2003 Software Diamonds

     Copyright holder contact.
          603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

     License.
         Software Diamonds permits the redistribution and use in source and
         binary forms, with or without modification, provided that the
         following conditions are met:

         1   Redistributions of source code, modified or unmodified must
             retain the above copyright notice, this list of conditions and
             the following disclaimer.

         2   Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

         SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com, PROVIDES THIS
         SOFTWARE 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
         BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
         FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
         SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
         SPECIAL,EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
         LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
         USE,DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
         ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
         OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF ADVISED OF
         NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE POSSIBILITY
         OF SUCH DAMAGE.

   3.2 Inventory of software contents

     The content of the released, compressed, archieve file, consists of the
     following files:

      file                                                         version date       comment
      ------------------------------------------------------------ ------- ---------- ------------------------
      lib/SVDtest1.pm                                              0.01    1969/02/06 new
      MANIFEST                                                     0.01    1969/02/06 generated new
      Makefile.PL                                                  0.01    1969/02/06 generated new
      README                                                       0.01    1969/02/06 generated new
      lib/SVDtest1.pm                                              0.01    1969/02/06 new
      lib/module1.pm                                               0.01    1969/02/06 new
      t/SVDtest1.t                                                 0.01    1969/02/06 new

   3.3 Changes

     This is the original release. There are no preivious releases to change.

   3.4 Adaptation data.

     This installation requires that the installation site has the Perl
     programming language installed. Installation sites running Microsoft
     Operating systems require the installation of Unix utilities. An
     excellent, highly recommended Unix utilities for Microsoft operating
     systems is unxutils by Karl M. Syring. A copy is available at the
     following web sites:

      http://unxutils.sourceforge.net
      http://packages.SoftwareDiamnds.com

     There are no other additional requirements or tailoring needed of
     configurations files, adaptation data or other software needed for this
     installation particular to any installation site.

   3.5 Related documents.

     There are no related documents needed for the installation and test of
     this release.

   3.6 Installation instructions.

     Instructions for installation, installation tests and installation
     support are as follows:

     Installation Instructions.
         To installed the release file, use the CPAN module in the Perl
         release or the INSTALL.PL script at the following web site:

          http://packages.SoftwareDiamonds.com

         Follow the instructions for the the chosen installation software.

         The distribution file is at the following respositories:

            http://www.softwarediamonds/packages/SVDtest1-0.01
            http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/SVDtest1-0.01

     Prerequistes.
          'File::Basename' => 0

     Security, privacy, or safety precautions.
         None.

     Installation Tests.
         Most Perl installation software will run the following test
         script(s) as part of the installation:

          t/SVDtest1.t

     Installation support.
         If there are installation problems or questions with the
         installation contact

          603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

   3.7 Possible problems and known errors

     There are no open issues.

 4.0 NOTES
     The following are useful acronyms:

     .d  extension for a Perl demo script file

     .pm extension for a Perl Library Module

     .t  extension for a Perl test script file

     DID Data Item Description

     POD Plain Old Documentation

     STD Software Test Description

     SVD Software Version Description

 2.0 SEE ALSO
     ExtUtils::SVDmake
 '

 => $s->scrub_date($snl->fin( File::Spec->catfile( 'packages', 'SVDtest1.ppd' ) ))
 '<SOFTPKG NAME="SVDtest1" VERSION="0,01,0,0">
 	<TITLE>SVDtest1</TITLE>
 	<ABSTRACT>Objectify the Test module,
 adds the skip_test method to the Test module, and 
 adds the ability to compare complex data structures to the Test module.</ABSTRACT>
 	<AUTHOR>SoftwareDiamonds.com E&lt;lt&gt;support@SoftwareDiamonds.comE&lt;gt&gt;</AUTHOR>
 	<IMPLEMENTATION>
 		<DEPENDENCY NAME="File-Basename" VERSION="0,0,0,0" />
 		<OS NAME="MSWin32" />
 		<ARCHITECTURE NAME="MSWin32-x86-multi-thread" />
 		<CODEBASE HREF="SVDtest1-0.01.tar.gz" />
 	</IMPLEMENTATION>
 </SOFTPKG>
 '

 => -e File::Spec->catfile( 'packages', 'SVDtest1-0.01.tar.gz' )
 '1'

 =>     skip_tests(0);

 =>     #######
 =>     # Freeze version based on previous version
 =>     #
 =>     rmtree (File::Spec->catdir( 'packages', 'SVDtest1-0.01'));
 =>     my $contents = $snl->fin( File::Spec->catfile( 'lib', 'SVDtest1.pm' )); 
 =>     $contents =~ s/PREVIOUS_RELEASE\s*:\s+\^/PREVIOUS_RELEASE  : 0.01^/;
 =>     $contents =~ s/FREEZE\s*:\s+.*?\^/FREEZE  : 1^/;
 =>     $contents =~ s/VERSION\s*:\s+.*?\^/VERSION  : 0.02^/;
 =>     $snl->fout( File::Spec->catfile( 'lib', 'SVDtest1.pm' ), $contents );
 =>  

 =>     unlink 'SVDtest1.log';
 =>     no warnings;
 =>     open SAVE_OUT, ">&STDOUT";
 =>     open SAVE_ERR, ">&STDERR";
 =>     use warnings;
 =>     open STDOUT,'> SVDtest1.log';
 =>     open STDERR, ">&STDOUT";
 =>     $svd = new ExtUtils::SVDmaker( );
 =>     skip_tests(1) unless $svd->vmake( {pm => 'SVDtest1'} );
 =>     close STDOUT;
 =>     close STDERR;
 =>     open STDOUT, ">&SAVE_OUT";
 =>     open STDERR, ">&SAVE_ERR";
 =>     $output = $snl->fin( 'SVDtest1.log' );

=head1 QUALITY ASSURANCE

The module "t::ExtUtils::SVDmaker::SVDmaker" is the Software
Test Description(STD) module for the "ExtUtils::SVDmaker".
module. 

To generate all the test output files, 
run the generated test script, and
run the demonstration script,
execute the following in any directory:

 tmake -verbose -replace -run -pm=t::ExtUtils::SVDmaker::SVDmaker

Note that F<tmake.pl> must be in the execution path C<$ENV{PATH}>
and the "t" directory on the same level as the "lib" that
contains the "ExtUtils::SVDmaker" module.

=head1 NOTES

=head2 COPYRIGHT HOLDER

The holder of the copyright and maintainer is

 E<lt>support@SoftwareDiamonds.comE<gt>

=head2 COPYRIGHT NOTICE

copyright © 2003 Software Diamonds.

All Rights Reserved

=head2 BINDING REQUIREMENTS NOTICE

Binding requirements are indexed with the
pharse 'shall[dd]' where dd is an unique number
for each header section.
This conforms to standard federal
government practices, 490A (L<STD490A/3.2.3.6>).
In accordance with the License, Software Diamonds
is not liable for any requirement, binding or otherwise.

=head2 LICENSE

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code must retain
the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS PROVIDES THIS SOFTWARE 
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

=head1 SEE ALSO

The 2167A bundle functional program modules that contain
an end-user interface are as follows:

=over 4 

=item L<Test::STDmaker|Test::STDmaker>

=item L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>

=item L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>

=item L<DataPort::DataFile|DataPort::DataFile>

=item L<Test::Tech|Test::Tech> 

=item L<File::FileUtil|File::FileUtil>

=item L<Test::STD::TestUtil|Test::STD::TestUtil>

=back

The 2167A bundle design program modules that support
the functional program modules are so specific
that they have value only for support of the
function program modules are as follows:

=over 4

=item L<Test::STD::Check|Test::STD::Check>

=item L<Test::STD::FileGen|Test::STD::FileGen>

=item L<Test::STD::STD2167|Test::STD::STD2167>

=item L<Test::STD::STDgen|Test::STD::STDgen>

=item L<Test::STDtype::Demo|Test::STDtype::Demo>

=item L<Test::STDtype::STD|Test::STDtype::STD>

=item L<Test::STDtype::Verify|Test::STDtype::Verify>

=back

The L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> and 
L<Test::STDmaker|Test::STDmaker> 
automate of some of the US DOD
2167A Software Development Standard as established
by the following US DOD documents:

=over 4

=item L<US DOD Software Development Standard|Docs::US_DOD::STD2167A>

=item L<US DOD Specification Practices|Docs::US_DOD::STD490A>

=item L<Computer Operation Manual (COM) DID|Docs::US_DOD::COM>

=item L<Computer Programming Manual (CPM) DID)|Docs::US_DOD::CPM>

=item L<Computer Resources Integrated Support Document (CRISD) DID|Docs::US_DOD::CRISD>

=item L<Computer System Operator's Manual (CSOM) DID|Docs::US_DOD::CSOM>

=item L<Database Design Description (DBDD) DID|Docs::US_DOD::DBDD>

=item L<Engineering Change Proposal (ECP) DID|Docs::US_DOD::ECP>

=item L<Firmware support Manual (FSM) DID|Docs::US_DOD::FSM>

=item L<Interface Design Document (IDD) DID|Docs::US_DOD::IDD>

=item L<Interface Requirements Specification (IRS) DID|Docs::US_DOD::IRS>

=item L<Operation Concept Description (OCD) DID|Docs::US_DOD::OCD>

=item L<Specification Change Notice (SCN) DID|Docs::US_DOD::SCN>

=item L<Software Design Specification (SDD) DID|Docs::US_DOD::SDD>

=item L<Software Development Plan (SDP) DID|Docs::US_DOD::SDP> 

=item L<Software Input and Output Manual (SIOM) DID|Docs::US_DOD::SIOM>

=item L<Software Installation Plan (SIP) DID|Docs::US_DOD::SIP>

=item L<Software Programmer's Manual (SPM) DID|Docs::US_DOD::SPM>

=item L<Software Product Specification (SPS) DID|Docs::US_DOD::SPS>

=item L<Software Requirements Specification (SRS) DID|Docs::US_DOD::SRS>

=item L<System or Segment Design Document (SSDD) DID|Docs::US_DOD::SSDD>

=item L<System or Subsystem Specification (SSS) DID|Docs::US_DOD::SSS>

=item L<Software Test Description (STD) DID|Docs::US_DOD::STD>

=item L<Software Test Plan (STP) DID|Docs::US_DOD::STP>

=item L<Software Test Report (STR) DID|Docs::US_DOD::STR>

=item L<Software Transition Plan (STrP) DID|Docs::US_DOD::STrP>

=item L<Software User Manual (SUM) DID|Docs::US_DOD::SUM>

=item L<Software Version Description (SVD) DID|Docs::US_DOD::SVD>

=item L<Version Description Document (VDD) DID|Docs::US_DOD::VDD>

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
<!-- BLK ID="COPYRIGHT" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut


#######
## E N D   O F   F I L E
#######

