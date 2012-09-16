package App::ToSequel::DB::Default;

#ABSTRACT: Database engine interface plugin for Oracle

sub command_option {
  return [ "Oracle|O",  "Oracle Database", ];
}

sub new {
  my $class = shift;
  $class = ref $class if ref $class;
  my $self = bless {}, $class;
  $self;
}

1;
