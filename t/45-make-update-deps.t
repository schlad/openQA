#!/usr/bin/env perl
# Copyright (C) 2020 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use Test::More;
use Test::Warnings;

my $make = "make update-deps";
my @out  = qx{$make};
my $rc   = $?;
die "Could not run $make: rc=$rc" if $rc;

my @status = grep { not m/^\?/ } qx{git status --porcelain};

ok(!@status, "No changed files after '$make'")
  or diag @status;

done_testing;

