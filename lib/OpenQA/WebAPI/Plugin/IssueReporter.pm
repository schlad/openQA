package OpenQA::WebAPI::Plugin::IssueReporter;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use OpenQA::WebAPI::Plugin::IssueReporter::KernelBug;
use OpenQA::WebAPI::Plugin::IssueReporter::GenericBug;
use OpenQA::WebAPI::Plugin::IssueReporter::ProgressIssue;

sub register ($self, $app, $config) {
    $app->helper(
        report_external_issue => sub ($c) {
            my @actions;

            push @actions, @{OpenQA::WebAPI::Plugin::IssueReporter::GenericBug::actions($c) // []};
            push @actions, @{OpenQA::WebAPI::Plugin::IssueReporter::KernelBug::actions($c) // []};
            push @actions, @{OpenQA::WebAPI::Plugin::IssueReporter::ProgressIssue::actions($c) // []};

            return \@actions;
        });
}

1;
