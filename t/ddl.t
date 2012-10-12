#!/usr/bin/env perl

use Test::More tests => 11;
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
    'ColumnA' => { position => 0, length => 25, datatype => 'varchar' },
    'Column1' => { position => 1, length => 21, precision => 1, datatype => 'timestamp' },
    'ColumnC' => { position => 2, length => 9, precision => 3, datatype => 'numeric' },
    'Column0' => { position => 3, length => 10, datatype => 'date' },
    'Column8' => { position => 4, length => 8, datatype => 'numeric' },
    'ColumnZ' => { position => 5, length => 19, datatype => 'timestamp' },
  }, 'detect datatypes - column data lengths w/ mismatched columns'
);

$ddl->tablename('datatype');
is($ddl->ddl({ 'detect' => 1}),"CREATE TABLE datatype (\n\t ColumnA\tVARCHAR(25)\n\t,Column1\tTIMESTAMP\n\t,ColumnC\tNUMERIC(9,3)\n\t,Column0\tDATE\n\t,Column8\tNUMERIC(8)\n\t,ColumnZ\tTIMESTAMP\n);\n",'datatyped ddl');

$ddl->csv('t/data/datatype.csv');
$ddl->extract_columns;
$ddl->column_lengths({ 'detect' => 1, 'sample' => 2 });
cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0, length => 25, datatype => 'varchar' },
    'Column1' => { position => 1, length => 21, datatype => 'timestamp' },
    'ColumnC' => { position => 2, length => 9, precision => 2, datatype => 'numeric' },
    'Column0' => { position => 3, length => 10, datatype => 'date' },
    'Column8' => { position => 4, length => 8, datatype => 'numeric' },
    'ColumnZ' => { position => 5, length => 19, datatype => 'timestamp' },
  }, 'sample limit - column data lengths w/ mismatched columns'
);

$ddl->csv('t/data/quoted_datatype.csv');
$ddl->extract_columns;
$ddl->column_lengths({ 'detect' => 1 });

cmp_deeply(
  $ddl->columns, {
    'ColumnA' => { position => 0, length => 25, datatype => 'varchar' },
    'Column1' => { position => 1, length => 21, precision => 1, datatype => 'timestamp' },
    'ColumnC' => { position => 2, length => 9, precision => 3, datatype => 'numeric' },
    'Column0' => { position => 3, length => 10, datatype => 'date' },
    'Column8' => { position => 4, length => 8, datatype => 'numeric' },
    'ColumnZ' => { position => 5, length => 19, datatype => 'timestamp' },
  }, 'quoted data - column data lengths w/ mismatched columns'
);
