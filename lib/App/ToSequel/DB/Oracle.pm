package App::ToSequel::DB::Oracle;

#ABSTRACT: Database engine interface plugin for Oracle

sub command_option {
  return [ "Oracle|O",  "Oracle Database", ];
}

=attr varchar

=cut
sub varchar {
  my ($self,$args) = @_;

  return 'VARCHAR2('. $args->{length} .')';
}

sub new {
  my $class = shift;
  $class = ref $class if ref $class;
  my $self = bless {}, $class;
  $self;
}

1;
