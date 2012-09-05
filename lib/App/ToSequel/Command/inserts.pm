package App::ToSequel::Command::inserts;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL INSERT Statements

use strict;
use warnings;

sub options {
  return (
  );
}
sub execute {
  my ($self, $opt, $args) = @_;

  $self->tablename($opt->tablename) if $opt->tablename;
  $self->csv($args->[0]);

  $self->extract_columns;
  print $self->inserts;
}

sub inserts {
  my ($self) = @_;

  my $inserts;
  while (my $row = $self->csv->fetchrow_hash) {
    $inserts .= 'INSERT INTO ';
    $inserts .= $self->tablename;
    $inserts .= ' (';
    $inserts .= join(',',keys(%$row));
    $inserts .= ") VALUES (";
    my $first = 1;
    for my $key (keys(%$row)) {
      my $value = $row->{$key} // '';
      $value =~ s/'/''/g;
      $inserts .= $first ? '' : ',';
      $inserts .= "'$value'";
      $first = 0;
    }
    $inserts .= ");\n";
  }

  return $inserts;
}

1;
