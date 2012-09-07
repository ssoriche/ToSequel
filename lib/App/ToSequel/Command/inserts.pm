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

  my $columns = $self->ordered_columns;
  my $inserts;
  while (my $row = $self->csv->fetchrow_hash) {
    $inserts .= 'INSERT INTO ';
    $inserts .= $self->tablename;
    $inserts .= ' (';
    $inserts .= join(',',@$columns);
    $inserts .= ") VALUES (";

    my @values;
    for my $column (@$columns) {
      my $value;
      if($opt->{'null'}) {
        $value = $row->{$column} // 'NULL';
      }
      else {
        $value = $row->{$column} // '';
      }
      $value =~ s/'/''/g;
      push(@values,$value eq 'NULL' ? $value : "'$value'");
    }
    $inserts .= join(',',@values);
    $inserts .= ");\n";
  }

  return $inserts;
}

1;
