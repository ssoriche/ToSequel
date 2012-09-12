=attr db

=cut

=attr command_option

=cut

=attr numeric

=cut
sub numeric {
  my ($self,$args) = @_;

  if($self->db->can('numeric')) {
    $self->db->numeric($args);
  }

  return 'NUMERIC';
}

=attr date

=cut

=attr timestamp

=cut

=attr varchar

=cut
