=attr db

=cut

=attr command_option

=cut

=attr numeric({ length => 8, precision => 2 })

=cut
sub numeric {
  my ($self,$args) = @_;

  if($self->db->can('numeric')) {
    return $self->db->numeric($args);
  }

  return 'NUMERIC('. $args->{length} . ')';
}

=attr date

=cut
sub date {
  my ($self,$args) = @_;

  if($self->db->can('date')) {
    return $self->db->date($args);
  }

  return 'DATE';
}

=attr timestamp

=cut
sub timestamp {
  my ($self,$args) = @_;

  if($self->db->can('timestamp')) {
    return $self->db->timestamp($args);
  }

  return 'TIMESTAMP';
}

=attr varchar

=cut
sub varchar {
  my ($self,$args) = @_;

  if($self->db->can('varchar')) {
    return $self->db->varchar($args);
  }

  return 'VARCHAR('. $args->{length} . ')';
}
