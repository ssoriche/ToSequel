#!/usr/bin/env perl

use Test::More tests => 3;
use Test::Deep;

use_ok('App::ToSequel::Command::ddl');

my $ddl = App::ToSequel::Command::ddl->new( {} );

isa_ok( $ddl, 'App::ToSequel::Command::ddl' );

$ddl->extract_columns( { filename => 't/data/simple.csv' } );
cmp_deeply(
  $ddl->columns,
  [
    { name => 'ColumnA', position => 0 },
    { name => 'ColumnB', position => 1 },
    { name => 'ColumnC', position => 2 },
  ]
);
