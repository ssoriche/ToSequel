#!/usr/bin/env perl

use Test::More tests => 3;
use Test::Deep;

use_ok('App::ToSequel::Command::ddl');

my $ddl = App::ToSequel::Command::ddl->new( {} );

isa_ok( $ddl, 'App::ToSequel::Command::ddl' );

$ddl->csv('t/data/simple.csv');
$ddl->extract_columns;
cmp_deeply(
  $ddl->columns,
  [
    { name => 'ColumnA', position => 0 },
    { name => 'ColumnB', position => 1 },
    { name => 'ColumnC', position => 2 },
  ], 'column names and positions'
);
