package App::ToSequel::Command::ddl;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL DDL Statements
use strict;
use warnings;

sub usage_desc { "tosequel %o [csvfile]" }

sub options {
  return (
    [ "headerfile=s",  "read column name and order from file", ],
    [ "headers=s",  "column names and order", ],
    [ "schema=s",  "schema to create table in", ],
    [ "guess|G",  "using data guess at data types", ],
  );
}

sub execute {
  my ($self, $opt, $args) = @_;

  $self->tablename($opt->tablename) if $opt->tablename;
  $self->csv($args->[0]);

  $self->extract_columns;
  $self->column_lengths;
  print $self->ddl;
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

  my $ddl = 'CREATE TABLE ' . $self->tablename . " (\n";
  my $first = 1;
  for my $column (@{$self->columns}) {
    $ddl .= "\t";
    $ddl .= $first ? ' ' : ',';
    $ddl .= $column->{name} . "\t";
    $ddl .= $column->{datatype} ? $column->{datatype} : 'VARCHAR';
    $ddl .= '(' . $column->{length} . ')';
    $ddl .= "\n";
    $first = 0;
  }
  $ddl .= ");\n";

  return $ddl;
}


1;
