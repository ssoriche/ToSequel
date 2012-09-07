#!/usr/bin/env perl

use Test::More tests => 6;
use Test::Deep;
use Try::Tiny;

use_ok('App::ToSequel::Command::inserts');

my $inserts = App::ToSequel::Command::inserts->new( {} );

isa_ok( $inserts, 'App::ToSequel::Command::inserts' );

$inserts->csv('t/data/simple.csv');
$inserts->extract_columns;
cmp_deeply(
  $inserts->columns,
  [
    { name => 'ColumnA', position => 0 },
    { name => 'ColumnB', position => 1 },
    { name => 'ColumnC', position => 2 },
  ], 'column names and positions'
);

$inserts->tablename('simpletable');
is($inserts->inserts,"INSERT INTO simpletable (ColumnA,ColumnB,ColumnC) VALUES ('This is Column A','2012-09-05 13:51:22','1234.56');\nINSERT INTO simpletable (ColumnA,ColumnB,ColumnC) VALUES ('short','2012-09-06 14:21:20','98765.321');\n",'simple inserts');

$inserts->csv('t/data/mismatched.csv');
$inserts->tablename('mismatchedtable');
$inserts->extract_columns;
is($inserts->inserts,"INSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('This is Column A','2012-09-05 13:51:22','1234.56');\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('missing','2012-09-06 14:21:20','');\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('longerest','2012-09-06 14:21:20','98765.321');\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('I''m in need of escaping','2012-09-06 14:21:20','98765.321');\n",'mismatched inserts');

$inserts->csv('t/data/mismatched.csv');
$inserts->tablename('mismatchedtable');
$inserts->extract_columns;
is($inserts->inserts({null => 1}), "INSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('This is Column A','2012-09-05 13:51:22','1234.56');\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('missing','2012-09-06 14:21:20',NULL);\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('longerest','2012-09-06 14:21:20','98765.321');\nINSERT INTO mismatchedtable (ColumnA,ColumnB,ColumnC) VALUES ('I''m in need of escaping','2012-09-06 14:21:20','98765.321');\n",'mismatched inserts w/NULL');
