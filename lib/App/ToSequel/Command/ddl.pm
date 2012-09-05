package App::ToSequel::Command::ddl;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL DDL Statements
use strict;
use warnings;

use Text::xSV;

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

sub execute {
  my ($self, $opt, $args) = @_;
}

=method extract_columns({ filename => 'filename' })

Using the header from the CSV file create column entries

=cut
sub extract_columns {
  my ($self, $args) = @_;

  my $csv = Text::xSV->new;
  $csv->open_file($args->{filename});

  my $columns = $csv->read_header;

  my @columnlist = map {name => $_, position => $columns->{$_}}, sort { $columns->{$a} <=> $columns->{$b} } keys(%$columns);
  $self->columns(\@columnlist);
}


1;
