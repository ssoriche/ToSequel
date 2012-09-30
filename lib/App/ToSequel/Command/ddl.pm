package App::ToSequel::Command::ddl;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL DDL Statements
use strict;
use warnings;

use DateTime::Format::Natural;

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
  $self->column_lengths($opt);
  print $self->ddl($opt);
}

sub column_lengths {
  my ($self,$args) = @_;

  while (my $row = $self->csv->fetchrow_hash) {
    for my $column (keys($self->columns)) {
      next unless(defined($row->{$column}));
      if(!defined($self->columns->{$column}->{length}) || $self->columns->{$column}->{length} < length($row->{$column})) {
        $self->columns->{$column}->{length} = length($row->{$column});
      }
      if($args->{detect}) {
        unless($self->columns->{$column}->{datatype} && $self->columns->{$column}->{datatype} eq 'varchar') {
          my $parser =  DateTime::Format::Natural->new;
          my $dt = $parser->parse_datetime($row->{$column});
          if($parser->success) {
            if($dt->hour) {
              $self->columns->{$column}->{datatype} = 'timestamp';
            }
            else {
              $self->columns->{$column}->{datatype} = 'date'
                unless ( $self->columns->{$column}->{datatype} && $self->columns->{$column}->{datatype} eq 'timestamp' );
            }
          }
          elsif($row->{$column} =~ /^[\d]+\.?([\d]+)$/) {
            $self->columns->{$column}->{datatype} = 'numeric';
            $self->columns->{$column}->{precision} = length($1) if(!defined($self->columns->{$column}->{precision}) || length($self->columns->{$column}->{precision}) < length($1));
          }
          elsif($row->{$column} =~ /^[\w\s]+$/) {
            $self->columns->{$column}->{datatype} = 'varchar';
          }
        }
      }
    }
  }
}

sub ddl {
  my ($self,$args) = @_;

  my $ddl = 'CREATE TABLE ' . $self->tablename . " (\n";
  my $first = 1;
  for my $column (@{$self->ordered_columns}) {
    $ddl .= "\t";
    $ddl .= $first ? ' ' : ',';
    $ddl .= $column . "\t";
    if($args->{detect}) {
      my $datatype = $self->columns->{$column}->{datatype};
      $ddl .= $self->db->$datatype( {
          length     => $self->columns->{$column}->{length},
          preceision => $self->columns->{$column}->{precision} } );
    }
    else {
      $ddl .= 'VARCHAR';
      $ddl .= '(' . $self->columns->{$column}->{length} . ')';
    }
    $ddl .= "\n";
    $first = 0;
  }
  $ddl .= ");\n";

  return $ddl;
}


1;
