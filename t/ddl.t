#!/usr/bin/env perl

use Test::More tests => 8;
use Test::Deep;

use_ok('App::ToSequel::Command::ddl');

my $ddl = App::ToSequel::Command::ddl->new( {} );

isa_ok( $ddl, 'App::ToSequel::Command::ddl' );

$ddl->csv('t/data/simple.csv');
$ddl->extract_columns;
cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0 },
    'Column1' => { position => 1 },
    'ColumnC' => { position => 2 },
  }, 'column names and positions'
);

cmp_deeply(
  $ddl->ordered_columns,
  [ qw(
      ColumnA
      Column1
      ColumnC
    )],
  'ordered column list'
);

$ddl->column_lengths;
cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0, length => 16 },
    'Column1' => { position => 1, length => 19 },
    'ColumnC' => { position => 2, length => 9 },
  }, 'column data lengths'
);

$ddl->tablename('simpletable');
is($ddl->ddl,"CREATE TABLE simpletable (\n\t ColumnA\tVARCHAR(16)\n\t,Column1\tVARCHAR(19)\n\t,ColumnC\tVARCHAR(9)\n);\n",'simple ddl');

$ddl->csv('t/data/mismatched.csv');
$ddl->extract_columns;
$ddl->column_lengths;
cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0, length => 23 },
    'Column1' => { position => 1, length => 19 },
    'ColumnC' => { position => 2, length => 9 },
  }, 'column data lengths w/ mismatched columns'
);

$ddl->csv('t/data/datatype.csv');
$ddl->extract_columns;
$ddl->column_lengths({ 'detect' => 1 });
cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0, length => 23, datatype => 'varchar' },
    'Column1' => { position => 1, length => 19, datatype => 'timestamp' },
    'ColumnC' => { position => 2, length => 9, datatype => 'numeric' },
    'Column0' => { position => 3, length => 9, datatype => 'date' },
  }, 'column data lengths w/ mismatched columns'
);
