# ABSTRACT: Base repository objects
use mop;
use 5.010;

class App::GitGot::Repo {
  has $label  is ro;
  has $name   is ro = do { die };
  has $number is ro = do { die }; # type('Int')
  has $path   is ro = do { die }; # type('Str')
  has $repo   is ro; # type('Str');
  has $tags   is ro; # type('Str');
  has $type   is ro = do { die }; # type('Str')

  method new ($args) {
    my $count = $args->{count} || 0;

    die "Must provide entry" unless
      my $entry = $args->{entry};

    my $repo = $entry->{repo} //= '';

    unless ( defined $entry->{name} ) {
      $entry->{name} = ( $repo =~ m|([^/]+).git$| ) ? $1 : '';
    }

    $entry->{tags} //= '';

    my $munged_args = {
      number => $count ,
      name   => $entry->{name} ,
      path   => $entry->{path} ,
      repo   => $repo ,
      type   => $entry->{type} ,
      tags   => $entry->{tags} ,
    };

    $munged_args->{label} = $args->{label}
      if $args->{label};

    $class->next::method($munged_args)
  }

=method in_writable_format

Returns a serialized representation of the repository for writing out in a
config file.

=cut

  method in_writable_format {
    my $writeable = {
      name => $self->name ,
      path => $self->path ,
    };

    foreach ( qw/ repo tags type /) {
      $writeable->{$_} = $self->$_ if $self->$_;
    }

    return $writeable;
  }

}

1;
