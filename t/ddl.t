#!/usr/bin/env perl

use Test::More tests => 5;
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

$ddl->column_lengths;
cmp_deeply(
  $ddl->columns,
  [
    { name => 'ColumnA', position => 0, length => 16 },
    { name => 'ColumnB', position => 1, length => 19 },
    { name => 'ColumnC', position => 2, length => 9 },
  ], 'column data lengths'
);

$ddl->tablename('simpletable');
is($ddl->ddl,"CREATE TABLE simpletable (\n\t ColumnA\tVARCHAR(16)\n\t,ColumnB\tVARCHAR(19)\n\t,ColumnC\tVARCHAR(9)\n);\n",'simple ddl');
