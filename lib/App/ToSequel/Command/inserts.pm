package App::ToSequel::Command::inserts;
use App::ToSequel -command;

#ABSTRACT: Convert formatted text files into SQL INSERT Statements

use strict;
use warnings;

sub options {
  return (
    [ "null|N",  "treat empty data as NULL", ],
  );
}
sub execute {
  my ($self, $opt, $args) = @_;

  $self->tablename($opt->tablename) if $opt->tablename;
  $self->csv($args->[0]);

  $self->extract_columns;
  print $self->inserts($opt);
}

sub inserts {
  my ($self, $opt) = @_;

  my $inserts;
  while (my $row = $self->csv->fetchrow_hash) {
    $inserts .= 'INSERT INTO ';
    $inserts .= $self->tablename;
    $inserts .= ' (';
    $inserts .= join(',',keys(%$row));
    $inserts .= ") VALUES (";
    my $first = 1;
    for my $key (keys(%$row)) {
      my $value;
      if($opt->{'null'}) {
        $value = $row->{$key} // 'NULL';
      }
      else {
        $value = $row->{$key} // '';
      }
      $value =~ s/'/''/g;
      $inserts .= $first ? '' : ',';
      $inserts .= $value eq 'NULL' ? $value : "'$value'";
      $first = 0;
    }
    $inserts .= ");\n";
  }

  return $inserts;
}

1;
