#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  Docs::Site_SVD::ExtUtils_SVDmaker;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '0.01';
$DATE = '2003/07/08';
$FILE = __FILE__;

use vars qw(%INVENTORY);
%INVENTORY = (
    'lib/Docs/Site_SVD/ExtUtils_SVDmaker.pm' => [qw(0.01 2003/07/08), 'revised 0.01'],
    'MANIFEST' => [qw(0.01 2003/07/08), 'generated, replaces 0.01'],
    'Makefile.PL' => [qw(0.01 2003/07/08), 'generated, replaces 0.01'],
    'README' => [qw(0.01 2003/07/08), 'generated, replaces 0.01'],
    'lib/ExtUtils/SVDmaker.pm' => [qw(1.03 2003/07/08), 'revised 1.02'],
    'bin/vmake.pl' => [qw(1.02 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/Makefile2.PL' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/Makefile3.PL' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/MANIFEST2' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/README2' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/README3' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDmaker.d' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDmaker.pm' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDmaker.t' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDmaker0.pm' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDtest.ppd' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDtest2.pm' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDtest2.ppd' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDtest3.pm' => [qw(0.02 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/SVDtest3.ppd' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/lib/module0.pm' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/lib/SVDtest0.pm' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/lib/SVDtest1.pm' => [qw(0.02 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/t/SVDtest0.t' => [qw(0.01 2003/07/08), 'new'],
    't/ExtUtils/SVDmaker/t/SVDtest2.t' => [qw(0.06 2003/07/08), 'new'],

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



=head1 Title Page

 Software Version Description

 for

 ExtUtil::SVDmaker - Packaging modules for CPAN and Software Version Description (SVD) Automation

 Revision: -

 Version: 0.01

 Date: 2003/07/08

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

The system is the Perl programming language software.
As established by the L<Perl referenced documents|/2.0 SEE ALSO>,
the "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" 
program module extends the Perl language.


The input to "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" is the __DATA__
section of Software Test Description (STD)
program module.
The __DATA__ section must contain STD
forms text database in the
L<DataPort::FileType::DataDB|DataPort::FileType::DataDB> format.

Use the "vmake.pl" (version make) cover script for 
L<Test::STDmaker|Test::STDmaker> to process a SVD program
module as follows:

  vmake Docs::Site_SVD::MySVDmodule

The "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" module
will then provide some automation of releaseing a Perl distribution file as
follows:

=over

=item *

The input data for the L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>
is a form database file in the format of 
L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>.
This is a efficient text database that is very close in
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
Two STD2167A bundle end user modules are as follows:

=over 4

=item L<Test::STDmaker|Test::STDmaker> module

generates Test script, demo script and STD document POD from
a text database in the Data::Port::FileTYpe::FormDB format.

=item L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> module

generates SVD document POD and distribution *.tar.gz file including
a generated Makefile.PL README and MANIFEST file from 
a text database in the Data::Port::FileTYpe::FormDB format.

=back

The dependency of the program modules in the US DOD STD2167A bundle is as follows:

 File::TestPath File::Package File::SmartNL
   Text::Scrub
     Test::Tech

        DataPort::FileType::FormDB DataPort::DataFile DataPort::Maker Text::Replace
        Text::Column File::PM2File File::Data File::AnySpec File::SubPM

            Test::STDmaker ExtUtils::SVDmaker

The top level modules that establish the functional interface of
interest to the end user are the 
L<Test::STDmaker|Test::STDmaker> and the 
L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> modules.
The rest of the modules in the above dependency tree are design
modules for the US DOD STD2167A bundle. 
They are broken out as separate modules because they may be
of use outside of the US DOD STD2167A bundle.

Note the 
L<File::FileUtil|File::FileUtil>, 
L<Test::STD::STDutil|Test::STD::STDutil> 
L<Test::STD::Scrub|Test::STD::Scrub> 
program modules breaks up 
the Test::TestUtil program module
and Test::TestUtil has disappeared.

=head2 1.3 Document overview.

This document releases ExtUtils::SVDmaker version 0.01
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

   http://www.softwarediamonds/packages/ExtUtils-SVDmaker-0.01
   http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/ExtUtils-SVDmaker-0.01


Restrictions regarding duplication and license provisions
are as follows:

=over 4

=item Copyright.

copyright © 2003 Software Diamonds

=item Copyright holder contact.

 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

=item License.

These files are a POD derived works from the hard copy public domain version
freely distributed by the United States Federal Government.

The original hardcopy version is always the authoritative document
and any conflict between the original hardcopy version governs whenever
there is any conflict. In more explicit terms, any conflict is a 
transcription error in converting the origninal hard-copy version to
this POD format. Software Diamonds assumes no responsible for such errors.

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
 lib/Docs/Site_SVD/ExtUtils_SVDmaker.pm                       0.01    2003/07/08 revised 0.01
 MANIFEST                                                     0.01    2003/07/08 generated, replaces 0.01
 Makefile.PL                                                  0.01    2003/07/08 generated, replaces 0.01
 README                                                       0.01    2003/07/08 generated, replaces 0.01
 lib/ExtUtils/SVDmaker.pm                                     1.03    2003/07/08 revised 1.02
 bin/vmake.pl                                                 1.02    2003/07/08 new
 t/ExtUtils/SVDmaker/Makefile2.PL                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/Makefile3.PL                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/MANIFEST2                                0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/README2                                  0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/README3                                  0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDmaker.d                               0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDmaker.pm                              0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDmaker.t                               0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDmaker0.pm                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDtest.ppd                              0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDtest2.pm                              0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDtest2.ppd                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDtest3.pm                              0.02    2003/07/08 new
 t/ExtUtils/SVDmaker/SVDtest3.ppd                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/lib/module0.pm                           0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/lib/SVDtest0.pm                          0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/lib/SVDtest1.pm                          0.02    2003/07/08 new
 t/ExtUtils/SVDmaker/t/SVDtest0.t                             0.01    2003/07/08 new
 t/ExtUtils/SVDmaker/t/SVDtest2.t                             0.06    2003/07/08 new


=head2 3.3 Changes

The file names from 0.01 were changed as follows:

  return if $file =~ s=lib/SVD/SVDgen.pm=lib/ExtUtils/SVDmaker.pm=;

Changes are as follows:

=over 4

=item ExtUtils::SVDmaker 0.1

Change the name from SVD::SVDmaker to ExtUtils::SVDmaker. 
The CPAN keepers have a no new top levels unless absolutely necessary policy.

Added tests.
=back

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

The files may be installed under many different operating systems.
The compresssed, archived, distribution file containing all installation
files is at the following respository:

    http://www.softwarediamonds/packages/ExtUtils-SVDmaker-0.01
   http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/ExtUtils-SVDmaker-0.01
/ExtUtils-SVDmaker-0.01.tar.gz 

Follow the general Perl software installation procedure
to install the files contained in this distribution file.

The distribution name for and version are as follows:

 distribution name: ExtUtils-SVDmaker
 version          : 0.01

=item Prerequistes.

 'DataPort::DataFile' => '0.02',
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
 'File::Data' => '0',


=item Security, privacy, or safety precautions.

None.

=item Installation Tests.

Most Perl installation software will run the following test script(s)
as part of the installation:

 t/ExtUtils/SVDmaker/SVDmaker.t

=item Installation support.

If there are installation problems or questions with the installation
contact

 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

=back

=head2 3.7 Possible problems and known errors

Open issues are as follows:

=over 4

=item *

Should format $svd->{PREREQ_PM_TEXT} into a table.

=item *

Need to generted the requirements and add the
addressed requirements to the tests.

=back

=head1 4.0 NOTES

This document uses the following acronyms:

=over 4

=item .d

extension for a Perl demo script file

=item .pm

extension for a Perl Library Module

=item .t

extension for a test file

=item DID

Data Item Description

=item DOD

Department of Defense

=item POD

Plain Old Documentation

=item SVD

Software Version Description

=item STD

Software Test Description

=item US

United States

=back

=head1 2.0 SEE ALSO

Modules with end-user functional interfaces 
relating to US DOD 2167A automation are
as follows:

=over 4

=item L<Test::STDmaker|Test::STDmaker>

=item L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>

=item L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>

=item L<DataPort::DataFile|DataPort::DataFile>

=item L<Test::Tech|Test::Tech>

=item L<Test|Test>

=item L<Data::Dumper|Data::Dumper>

=item L<Test::STD::Scrub|Test::STD::Scrub>

=item L<Test::STD::STDutil|Test::STD::STDutil>

=item L<File::FileUtil|File::FileUtil>

=back

The design modules for L<Test::STDmaker|Test::STDmaker>
have no other conceivable use then to support the
L<Test::STDmaker|Test::STDmaker> functional interface. 
The  L<Test::STDmaker|Test::STDmaker>
design module are as follows:

=over 4

=item L<Test::STD::Check|Test::STD::Check>

=item L<Test::STD::FileGen|Test::STD::FileGen>

=item L<Test::STD::STD2167|Test::STD::STD2167>

=item L<Test::STD::STDgen|Test::STD::STDgen>

=item L<Test::STDtype::Demo|Test::STDtype::Demo>

=item L<Test::STDtype::STD|Test::STDtype::STD>

=item L<Test::STDtype::Verify|Test::STDtype::Verify>

=back


Some US DOD 2167A Software Development Standard, DIDs and
other related documents that complement the 
US DOD 2167A automation are as follows:

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

DISTNAME: ExtUtils-SVDmaker^
REPOSITORY_DIR: packages^

VERSION : 0.01^
FREEZE: 1^
PREVIOUS_DISTNAME: SVD-SVDgen^
PREVIOUS_RELEASE: 0.01^
REVISION: -^

AUTHOR  : SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>^
ABSTRACT: 
Software to generate Software Version Description (SVD) program modules and 
package modules for CPAN.
^

TITLE: ExtUtil::SVDmaker - Packaging modules for CPAN and Software Version Description (SVD) Automation^
END_USER: General Public^
COPYRIGHT: copyright © 2003 Software Diamonds^
CLASSIFICATION: NONE^

CSS: help.css^
TEMPLATE:  ^
SVD_FSPEC: Unix^ 

COMPRESS: gzip^
COMPRESS_SUFFIX: gz^

REPOSITORY: 
  http://www.softwarediamonds/packages/
  http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/
^

CHANGE2CURRENT: 
 return if $file =~ s=lib/SVD/SVDgen.pm=lib/ExtUtils/SVDmaker.pm=;

^

RESTRUCTURE:  ^

AUTO_REVISE:
lib/ExtUtils/SVDmaker.pm
bin/vmake.pl
t/ExtUtils/SVDmaker/*
t/ExtUtils/SVDmaker/lib/*
t/ExtUtils/SVDmaker/t/*
^

PREREQ_PM:
'DataPort::DataFile' => '0.02',
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
'File::Data' => '0',
^

TESTS: t/ExtUtils/SVDmaker/SVDmaker.t^
EXE_FILES: bin/vmake.pl^

CHANGES:
Changes are as follows:

\=over 4

\=item ExtUtils::SVDmaker 0.1

Change the name from SVD::SVDmaker to ExtUtils::SVDmaker. 
The CPAN keepers have a no new top levels unless absolutely necessary policy.

Added tests.
\=back
^

CAPABILITIES:
The system is the Perl programming language software.
As established by the L<Perl referenced documents|/2.0 SEE ALSO>,
the "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" 
program module extends the Perl language.


The input to "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" is the __DATA__
section of Software Test Description (STD)
program module.
The __DATA__ section must contain STD
forms text database in the
L<DataPort::FileType::DataDB|DataPort::FileType::DataDB> format.

Use the "vmake.pl" (version make) cover script for 
L<Test::STDmaker|Test::STDmaker> to process a SVD program
module as follows:

  vmake Docs::Site_SVD::MySVDmodule

The "L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>" module
will then provide some automation of releaseing a Perl distribution file as
follows:

\=over

\=item *

The input data for the L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>
is a form database file in the format of 
L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>.
This is a efficient text database that is very close in
format to hard copy forms and may be edited by text editors

\=item *

compares the contents of the current release with the previous
release and automatically updates the version and date for files that
have changed

\=item *

generates a SVD program module from the form database data.


\=item *

generates MANIFEST, README and Makefile.PL distribution
files from the form database data

\=item *

Builds the distribution *.tar.gz file

\=item *

Runs the installation tests on the distribution files

\=back

The L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> module is one of the
end user, functional interface modules for the US DOD STD2167A bundle.
Two STD2167A bundle end user modules are as follows:

=over 4

=item L<Test::STDmaker|Test::STDmaker> module

generates Test script, demo script and STD document POD from
a text database in the Data::Port::FileTYpe::FormDB format.

=item L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> module

generates SVD document POD and distribution *.tar.gz file including
a generated Makefile.PL README and MANIFEST file from 
a text database in the Data::Port::FileTYpe::FormDB format.

=back

The dependency of the program modules in the US DOD STD2167A bundle is as follows:

 File::TestPath File::Package File::SmartNL
   Text::Scrub
     Test::Tech

        DataPort::FileType::FormDB DataPort::DataFile DataPort::Maker Text::Replace
        Text::Column File::PM2File File::Data File::AnySpec File::SubPM

            Test::STDmaker ExtUtils::SVDmaker

The top level modules that establish the functional interface of
interest to the end user are the 
L<Test::STDmaker|Test::STDmaker> and the 
L<ExtUtils::SVDmaker|ExtUtils::SVDmaker> modules.
The rest of the modules in the above dependency tree are design
modules for the US DOD STD2167A bundle. 
They are broken out as separate modules because they may be
of use outside of the US DOD STD2167A bundle.

Note the 
L<File::FileUtil|File::FileUtil>, 
L<Test::STD::STDutil|Test::STD::STDutil> 
L<Test::STD::Scrub|Test::STD::Scrub> 
program modules breaks up 
the Test::TestUtil program module
and Test::TestUtil has disappeared.
^


DOCUMENT_OVERVIEW:
This document releases ${NAME} version ${VERSION}
providing description of the inventory, installation
instructions and other information necessary to
utilize and track this release.
^

LICENSE:
These files are a POD derived works from the hard copy public domain version
freely distributed by the United States Federal Government.

The original hardcopy version is always the authoritative document
and any conflict between the original hardcopy version governs whenever
there is any conflict. In more explicit terms, any conflict is a 
transcription error in converting the origninal hard-copy version to
this POD format. Software Diamonds assumes no responsible for such errors.

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
The files may be installed under many different operating systems.
The compresssed, archived, distribution file containing all installation
files is at the following respository:

 ${REPOSITORY}/${DISTNAME}-${VERSION}.tar.gz 

Follow the general Perl software installation procedure
to install the files contained in this distribution file.

The distribution name for and version are as follows:

 distribution name: ${DISTNAME}
 version          : ${VERSION}

^


PROBLEMS:
Open issues are as follows:

\=over 4

\=item *

Should format $svd->{PREREQ_PM_TEXT} into a table.

\=item *

Need to generted the requirements and add the
addressed requirements to the tests.

\=back
^

SUPPORT:
603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>
^

NOTES:
This document uses the following acronyms:

\=over 4

\=item .d

extension for a Perl demo script file

\=item .pm

extension for a Perl Library Module

\=item .t

extension for a test file

\=item DID

Data Item Description

\=item DOD

Department of Defense

\=item POD

Plain Old Documentation

\=item SVD

Software Version Description

\=item STD

Software Test Description

\=item US

United States

\=back
^
SEE_ALSO:

Modules with end-user functional interfaces 
relating to US DOD 2167A automation are
as follows:

\=over 4

\=item L<Test::STDmaker|Test::STDmaker>

\=item L<ExtUtils::SVDmaker|ExtUtils::SVDmaker>

\=item L<DataPort::FileType::FormDB|DataPort::FileType::FormDB>

\=item L<DataPort::DataFile|DataPort::DataFile>

\=item L<Test::Tech|Test::Tech>

\=item L<Test|Test>

\=item L<Data::Dumper|Data::Dumper>

\=item L<Test::STD::Scrub|Test::STD::Scrub>

\=item L<Test::STD::STDutil|Test::STD::STDutil>

\=item L<File::FileUtil|File::FileUtil>

\=back

The design modules for L<Test::STDmaker|Test::STDmaker>
have no other conceivable use then to support the
L<Test::STDmaker|Test::STDmaker> functional interface. 
The  L<Test::STDmaker|Test::STDmaker>
design module are as follows:

\=over 4

\=item L<Test::STD::Check|Test::STD::Check>

\=item L<Test::STD::FileGen|Test::STD::FileGen>

\=item L<Test::STD::STD2167|Test::STD::STD2167>

\=item L<Test::STD::STDgen|Test::STD::STDgen>

\=item L<Test::STDtype::Demo|Test::STDtype::Demo>

\=item L<Test::STDtype::STD|Test::STDtype::STD>

\=item L<Test::STDtype::Verify|Test::STDtype::Verify>

\=back


Some US DOD 2167A Software Development Standard, DIDs and
other related documents that complement the 
US DOD 2167A automation are as follows:

\=over 4

\=item L<US DOD Software Development Standard|Docs::US_DOD::STD2167A>

\=item L<US DOD Specification Practices|Docs::US_DOD::STD490A>

\=item L<Computer Operation Manual (COM) DID|Docs::US_DOD::COM>

\=item L<Computer Programming Manual (CPM) DID)|Docs::US_DOD::CPM>

\=item L<Computer Resources Integrated Support Document (CRISD) DID|Docs::US_DOD::CRISD>

\=item L<Computer System Operator's Manual (CSOM) DID|Docs::US_DOD::CSOM>

\=item L<Database Design Description (DBDD) DID|Docs::US_DOD::DBDD>

\=item L<Engineering Change Proposal (ECP) DID|Docs::US_DOD::ECP>

\=item L<Firmware support Manual (FSM) DID|Docs::US_DOD::FSM>

\=item L<Interface Design Document (IDD) DID|Docs::US_DOD::IDD>

\=item L<Interface Requirements Specification (IRS) DID|Docs::US_DOD::IRS>

\=item L<Operation Concept Description (OCD) DID|Docs::US_DOD::OCD>

\=item L<Specification Change Notice (SCN) DID|Docs::US_DOD::SCN>

\=item L<Software Design Specification (SDD) DID|Docs::US_DOD::SDD>

\=item L<Software Development Plan (SDP) DID|Docs::US_DOD::SDP> 

\=item L<Software Input and Output Manual (SIOM) DID|Docs::US_DOD::SIOM>

\=item L<Software Installation Plan (SIP) DID|Docs::US_DOD::SIP>

\=item L<Software Programmer's Manual (SPM) DID|Docs::US_DOD::SPM>

\=item L<Software Product Specification (SPS) DID|Docs::US_DOD::SPS>

\=item L<Software Requirements Specification (SRS) DID|Docs::US_DOD::SRS>

\=item L<System or Segment Design Document (SSDD) DID|Docs::US_DOD::SSDD>

\=item L<System or Subsystem Specification (SSS) DID|Docs::US_DOD::SSS>

\=item L<Software Test Description (STD) DID|Docs::US_DOD::STD>

\=item L<Software Test Plan (STP) DID|Docs::US_DOD::STP>

\=item L<Software Test Report (STR) DID|Docs::US_DOD::STR>

\=item L<Software Transition Plan (STrP) DID|Docs::US_DOD::STrP>

\=item L<Software User Manual (SUM) DID|Docs::US_DOD::SUM>

\=item L<Software Version Description (SVD) DID|Docs::US_DOD::SVD>

\=item L<Version Description Document (VDD) DID|Docs::US_DOD::VDD>

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


