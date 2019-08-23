#!/usr/bin/perl
#
# WARNING: not fully tested yet
#
# a simple web (http/https) downloader written in perl using only
# tools installed on a base openbsd.
#
# this uses the perl module File::Fetch which is documented at
#     https://perldoc.perl.org/File/Fetch.html
#
# this simple command line tool takes two arguments:
#  1. a url in either http: or https: format
#  2. a filepath to store the results
#     NOTE: using a '-' for STDOUT does NOT work!
#
# a temporary file will be created in $TMP, or /tmp if $TMP is not defined

use warnings;
use strict;
use File::Fetch;
use File::Copy;

my $usage = <<"TEXT";
A simple http/s downloader, saving contents to to a file.

usage:
$0 url path

where:
url      http or https url to fetch from. Note: no validation of
         HTTPS certs is done
path     local path to save the contents to. if the file exists, it
         will be overwritten without warning

options: none

Exit status is zero on success, and non-zero for any error.

A temporary file is stored in \$TMP, or /tmp if \$TMP is not defined.
TEXT
my $tmp = '/tmp';

die $usage if $#ARGV < 1;
my ($url, $out) = @ARGV;

my $ff = File::Fetch->new(uri => $url);
my $res = $ff->fetch(to => (\$ENV{'TMP'} || \$tmp)) or die $ff->error;

# this is the filename that the fetch command downloads to
# print $res, "\n";
copy($res, $out) or die "copy failed: $!";

# cleanup temp file
END {
  if (defined $res && -f $res) {
    unlink($res) or warn "can't remove temporary file $res: $!";
  }
}
