package App::GitGot::Command::exec;
# ABSTRACT: run a git command across all configured repos

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use App::GitGot::Repo::Git;
use Try::Tiny;

sub _execute {
  my( $self , $opt , $args ) = @_;

  my $cmd = shift @$args;

  ### FIXME should probably do something clever here to make sure it's a legit
  ### git subcommand...

 REPO: for my $repo ( $self->active_repos ) {
    next REPO unless $repo->type eq 'git';

    my @output;
    try {
      my @output = $repo->$cmd;
    }
    catch {
      ### FIXME should *def* do something clever here to deal with errors
      print STDERR "ERROR";
      print STDERR $_->error;
    };

    printf "- #%3d) --[ %s ]--\n" , $repo->number , $repo->label;
    print "$_\n" foreach @output;
    print "\n\n";

  }

  __PACKAGE__->meta->make_immutable;
  1;
}
