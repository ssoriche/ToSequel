package App::ToSequel::Command::ddl;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL DDL Statements
use strict;
use warnings;

use Text::xSV;

=attr tablename

=cut
sub tablename {
  my ($self, $tablename) = @_;
  if ($tablename) {
    $self->{tablename} = $tablename;
  }

  return $self->{tablename};
}

=attr columns
  [
    { name
      position
      maxlength
      datatype
    }
  ]
=cut

sub columns {
  my ($self, $args) = @_;

  $self->{columns} = $args if($args);

  return $self->{columns};
}

=attr csv($filename)

Create a Text::xSV object from the filename.

=cut
sub csv {
  my ($self, $filename) = @_;
  if ($filename) {
    $self->{csv} = Text::xSV->new;
    $self->{csv}->open_file($filename);
  }

  return $self->{csv};
}

sub execute {
  my ($self, $opt, $args) = @_;
}

=method extract_columns

Using the header from the CSV file create column entries

=cut
sub extract_columns {
  my ($self, $args) = @_;

  my $columns = $self->csv->read_header;

  my @columnlist = map {name => $_, position => $columns->{$_}}, sort { $columns->{$a} <=> $columns->{$b} } keys(%$columns);
  $self->columns(\@columnlist);
}


1;
