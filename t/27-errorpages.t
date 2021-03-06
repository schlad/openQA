# Copyright (C) 2017 SUSE LLC
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

use Mojo::Base -strict;

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use Test::Mojo;
use Test::Warnings;
use OpenQA::Test::Case;

# init test case
my $test_case = OpenQA::Test::Case->new;
$test_case->init_data;
my $t = Test::Mojo->new('OpenQA::WebAPI');

subtest '404 error page' => sub {
    $t->get_ok('/unavailable_page')->status_is(404);
    my $dom = $t->tx->res->dom;
    is_deeply([$dom->find('h1')->map('text')->each], ['Page not found'],   'correct page');
    is_deeply([$dom->find('h2')->map('text')->each], ['Available routes'], 'available routes shown');
    ok(index($t->tx->res->text, 'Each entry contains the') >= 0, 'description shown');
};

subtest 'error pages shown for OpenQA::WebAPI::Controller::Step' => sub {
    my $existing_job = 99946;
    $t->get_ok("/tests/$existing_job/modules/installer_timezone/steps/1")->status_is(302, 'redirection');
    $t->get_ok("/tests/$existing_job/modules/installer_timezone/steps/1", {'X-Requested-With' => 'XMLHttpRequest'})
      ->status_is(200);
    $t->get_ok("/tests/$existing_job/modules/installer_timezone/steps/1/src")->status_is(200);
    $t->get_ok("/tests/$existing_job/modules/installer_timezone/steps/1/edit")->status_is(200);

    subtest 'get error 404 if job not found (instead of 500 and Perl warnings)' => sub {
        my $non_existing_job = 99999;
        $t->get_ok("/tests/$non_existing_job/modules/installer_timezone/steps/1")->status_is(302, 'redirection');
        $t->get_ok("/tests/$non_existing_job/modules/installer_timezone/steps/1",
            {'X-Requested-With' => 'XMLHttpRequest'})->status_is(404);
        $t->get_ok("/tests/$non_existing_job/modules/installer_timezone/steps/1/src")->status_is(404);
        $t->get_ok("/tests/$non_existing_job/modules/installer_timezone/steps/1/edit")->status_is(404);
    };
};


done_testing;
