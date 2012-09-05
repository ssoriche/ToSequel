package App::ToSequel::Command::ddl;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL DDL Statements
use strict;
use warnings;

use Text::xSV;

sub usage_desc { "tosequel %o [csvfile]" }

sub opt_spec {
  return (
    [ "tablename=s",  "tablename to create", ],
  );
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

  $self->tablename($opt->tablename) if $opt->tablename;
  $self->csv($args->[0]);

  $self->extract_columns;
  $self->column_lengths;
  print $self->ddl;
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

sub column_lengths {
  my ($self) = @_;

  while(my @row = $self->csv->get_row) {
    for my $i (0..$#row) {
      if(defined($row[$i])) {
        if(!defined(${$self->columns}[$i]->{length}) || ${$self->columns}[$i]->{length} < length($row[$i])) {
          ${$self->columns}[$i]->{length} = length($row[$i]);
        }
      }
    }
  }
}

sub ddl {
  my ($self) = @_;

  my $ddl = 'CREATE TABLE ' . $self->tablename . "\n";
  for my $column (@{$self->columns}) {
    $ddl .= "\t" . $column->{name} . "\t";
    $ddl .= $column->{datatype} ? $column->{datatype} : 'VARCHAR';
    $ddl .= '(' . $column->{length} . ')';
    $ddl .= "\n";
  }
  $ddl .= ";\n";

  return $ddl;
}


1;
