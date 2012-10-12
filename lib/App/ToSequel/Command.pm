package App::ToSequel::Command;
use App::Cmd::Setup -command;

#ABSTRACT: Base class for App::ToSequel commands
use strict;
use warnings;

use App::ToSequel::CSV;
use App::ToSequel::DB;

sub opt_spec {
  my ( $class, $app ) = @_;
  return (
    [ 'help' => "This usage screen" ],
    [ "tablename=s",  "tablename to create", ],
    [ "detect|D",  "detect data types", ],
    [ "sample|s=i", "Limit detect to a number of lines", { default => 2000 }],
    $class->options($app),
  )
}

=attr tablename

=cut
sub tablename {
  my ($self, $tablename) = @_;
  if ($tablename) {
    $self->{tablename} = $tablename;
  }

  return $self->{tablename};
}

=attr schema

=cut
sub schema {
  my ($self, $schema) = @_;
  if ($schema) {
    $self->{schema} = $schema;
  }

  return $self->{schema};
}

=attr columns
    { name => {
        position
        maxlength
        datatype
        precision
      }
    }
=cut

sub columns {
  my ($self, $args) = @_;

  $self->{columns} = $args if($args);

  return $self->{columns};
}

=attr ordered_columns

=cut
sub ordered_columns {
  my ($self) = @_;
  return $self->{ordered_columns} if($self->{ordered_columns});

  my $columns = $self->columns;
  my @columnlist;

  push(@columnlist, $_) for (sort { $columns->{$a}->{position} <=> $columns->{$b}->{position} } keys(%$columns));
  $self->_ordered_columns(\@columnlist);

  return $self->{ordered_columns};
}

sub _ordered_columns {
  my ($self,$args) = @_;

  $self->{ordered_columns} = $args;
}

=attr csv($filename)

Create a Text::xSV object from the filename.

=cut
sub csv {
  my ($self, $filename) = @_;
  if ($filename) {
    $self->{csv} = App::ToSequel::CSV->new;
    $self->{csv}->filename($filename);
  }

  return $self->{csv};
}

=method extract_columns

Using the header from the CSV file create column entries

=cut
sub extract_columns {
  my ($self, $args) = @_;

  my $columns = $self->csv->read_header;

  my %columnlist = map {; $_ => {position => $columns->{$_}}} keys(%$columns);
  $self->_ordered_columns(undef);
  $self->columns(\%columnlist);
}

sub db {
  my ($self) = @_;

  unless($self->{db}) {
    $self->{db} = App::ToSequel::DB->new;
  }
  return $self->{db};
}

1;
