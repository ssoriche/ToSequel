package App::ToSequel::Command::validate_pk;
use App::ToSequel -command;

#ABSTRACT: Check input file for key column violations

use v5.12;

use strict;
use warnings;

sub options {
  return (
    [ "primary_key|pk=s", "primary key for the table"],
  );
}

sub pk {
  my ($self, $pk) = @_;
  if ($pk) {
    my %hash = map { uc($_) => 1 } split(',',$pk);
    $self->{pk} = \%hash;
  }

  return $self->{pk};
}

sub execute {
  my ($self, $opt, $args) = @_;

  $self->tablename($opt->tablename) if $opt->tablename;
  $self->pk($opt->primary_key);
  $self->csv($args->[0]);

  $self->extract_columns;
  return $self->validate_pk($opt);
}

sub validate_pk {
  my ($self, $opt) = @_;

  my $error = 0;
  my %keylist = ();
  while (my $row = $self->csv->fetchrow_hash) {
    my $combined_key='';
    my $first = 1;
    for my $key (keys(%$row)) {
      next unless $self->pk->{uc($key)};
      $combined_key .= $first ? '' : ',';
      $combined_key .= $row->{$key};
      $first = 0;
    }
    if($keylist{$combined_key}) {
      print STDERR "Duplicate Key: $combined_key\n";
      $error++;
    }
    $keylist{$combined_key} = 1;
  }
  return $error;
}

1;
