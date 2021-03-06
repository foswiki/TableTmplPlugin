# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2001-2003 John Talintyre, jet@cheerful.com
# Copyright (C) 2001-2004 Peter Thoeny, peter@thoeny.org
# Copyright (C) 2005-2007 TWiki Contributors
# Copyright (C) 2008 Foswiki Contributors.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html
#
# As per the GPL, removal of this notice is prohibited.
#
# Allow sorting of tables, plus setting of background colour for
# headings and data cells. See %SYSTEMWEB%.TablePlugin for details of use

use strict;

package Foswiki::Plugins::TableTmplPlugin;

use Foswiki::Func ();    # The plugins API
use Foswiki::Plugins (); # For the API version

use vars qw( $topic $installWeb $initialised );

our $VERSION = '$Rev: 3457 $';
our $RELEASE = '1.038';
our $SHORTDESCRIPTION = 'Control attributes of tables and sorting of table columns';
our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my( $web, $user );
    ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 1.026 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between TablePlugin and Plugins.pm' );
        return 0;
    }

    my $cgi = Foswiki::Func::getCgiQuery();
    return 0 unless $cgi;

    $initialised = 0;


	#Init	
	$Foswiki::Plugins::TableTmplPlugin::Core::topic=$topic;
	$Foswiki::Plugins::TableTmplPlugin::Core::web=$web;
	$Foswiki::Plugins::TableTmplPlugin::Core::user=$user;
	$Foswiki::Plugins::TableTmplPlugin::Core::templates=();
	
	
    return 1;
}

sub preRenderingHandler {
    ### my ( $text, $removed ) = @_;

    my $sort = Foswiki::Func::getPreferencesValue( 'TABLEPLUGIN_SORT' )
      || 'all';
    return unless ($sort && $sort =~ /^(all|attachments)$/) ||
      $_[0] =~ /%TABLE{.*?}%/;

    # on-demand inclusion
    require Foswiki::Plugins::TableTmplPlugin::Core;
    Foswiki::Plugins::TableTmplPlugin::Core::handler( @_ );
}

1;
