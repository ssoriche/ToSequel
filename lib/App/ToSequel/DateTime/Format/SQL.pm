package App::ToSequel::DateTime::Format::SQL;

#ABSTRACT: Parse standard SQL formatted Date, DateTime and Timestamps

use strict;
use warnings;

our $VERSION = '0.01';
my $SUCCESS = 1;

use DateTime::Format::Builder (
  parsers => {
    parse_datetime => [
      [ on_fail => \&on_fail ],
      {
        regex  => qr/^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/,
        params => [qw( year month day hour minute second )],
      },
      {
        regex  => qr/^(\d{4})(\d\d)(\d\d)$/,
        params => [qw( year month day )],
      },
      {
        regex  => qr/^(\d{2})\/(\d\d)\/(\d{4}) (\d\d?):(\d\d):(\d\d)$/,
        params => [qw( month day year hour minute second)],
      },
      {
        regex  => qr/^(\d{2})\/(\d\d)\/(\d{4}) (\d\d):(\d\d):(\d\d)\.(\d+)$/,
        params => [qw( month day year hour minute second nanosecond)],
      },
      {
        regex  => qr/^(\d{4})[-\/](\d\d)[-\/](\d\d) (\d\d?):(\d\d):(\d\d)\.(\d+)$/,
        params => [qw( year month day hour minute second nanosecond)],
      },
      {
        regex  => qr/^(\d{4})[-\/](\d\d)[-\/](\d\d) (\d\d):(\d\d):(\d\d)$/,
        params => [qw( year month day hour minute second )],
      },
      { strptime => '%d-%B-%y' },
      { strptime => '%d-%m-%y' },
      { strptime => '%d/%m/%y' },
      { strptime => '%m-%d-%y' },
      { strptime => '%m/%d/%y' },
      { Quick => 'DateTime::Format::SQLite' },
    ],
  }
  );

sub on_fail {
  $SUCCESS = undef;
  return undef;
}

sub success {
  my ($self) = shift;
  return $SUCCESS;
}

1;
