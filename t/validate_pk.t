#!/usr/bin/env perl

use Test::More tests => 6;
use Test::Deep;

use_ok('App::ToSequel::Command::validate_pk');

my $validator = App::ToSequel::Command::validate_pk->new( {} );

isa_ok( $validator, 'App::ToSequel::Command::validate_pk' );

$validator->csv('t/data/simple.csv');
$validator->extract_columns;
cmp_deeply(
  $validator->columns, {
    'ColumnA' => { position => 0 },
    'Column1' => { position => 1 },
    'ColumnC' => { position => 2 },
  }, 'column names and positions'
);

$validator->pk('ColumnA');
is($validator->validate_pk,0,'valid keys');

$validator->csv('t/data/duplicate_key.csv');
$validator->extract_columns;
$validator->pk('ColumnA');
is($validator->validate_pk,1,'invalid keys');

$validator->csv('t/data/duplicate_key.csv');
$validator->extract_columns;
$validator->pk('ColumnA,Column1');
is($validator->validate_pk,1,'invalid keys');
