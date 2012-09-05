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
is($inserts->inserts,"INSERT INTO simpletable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-05 13:51:22','1234.56','This is Column A');\nINSERT INTO simpletable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','98765.321','short');\n",'simple inserts');

$inserts->csv('t/data/mismatched.csv');
$inserts->tablename('mismatchedtable');
$inserts->extract_columns;
is($inserts->inserts,"INSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-05 13:51:22','1234.56','This is Column A');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','','missing');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','98765.321','longerest');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','98765.321','I''m in need of escaping');\n",'mismatched inserts');

$inserts->csv('t/data/mismatched.csv');
$inserts->tablename('mismatchedtable');
$inserts->extract_columns;
is($inserts->inserts({null => 1}),"INSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-05 13:51:22','1234.56','This is Column A');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20',NULL,'missing');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','98765.321','longerest');\nINSERT INTO mismatchedtable (ColumnB,ColumnC,ColumnA) VALUES ('2012-09-06 14:21:20','98765.321','I''m in need of escaping');\n",'mismatched inserts w/NULL');
