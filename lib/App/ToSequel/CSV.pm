package App::ToSequel::CSV;

#ABSTRACT: Abstract Text::CSV_XS internal workings

use strict;
use warnings;

use Text::CSV_XS;
use v5.12;

sub new {
  my $class = shift;
  $class = ref $class if ref $class;
  my $self = bless {}, $class;
  $self->{csv} = Text::CSV_XS->new({ binary => 1 });
  $self;
}

sub filename {
  my ($self,$filename) = @_;

  if($filename) {
    $self->{filename} = $filename;
    open $self->{filehandle}, "<:encoding(utf8)", $filename;
  }

  return $self->{filename};
}

sub read_header {
  my ($self) = @_;

  my $column_list = $self->{csv}->getline($self->{filehandle});
  my $i = 0;

  my %column_hash;
  foreach my $column (@$column_list) {
    $column_hash{$column} = $i++;
  }
  $self->{csv}->column_names($column_list);

  return \%column_hash;
}

sub fetchrow_hash {
  my ($self) = @_;

  $self->{csv}->getline_hr($self->{filehandle});
}

1;
