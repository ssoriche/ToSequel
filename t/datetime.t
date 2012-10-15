#!/usr/bin/env perl

use Test::More tests => 12;
use strict;
use warnings;

use_ok('App::ToSequel::DateTime::Format::SQL');

my $parser =  App::ToSequel::DateTime::Format::SQL->new;
my $dt;
isa_ok($parser, 'App::ToSequel::DateTime::Format::SQL');
ok($parser->parse_datetime('2012-09-05 13:51:22'),'YYYY-MM-DD HH:mm:SS');
ok($parser->parse_datetime('12-JUL-73'),'DD-MON-YY');
ok($parser->parse_datetime('04/27/2010 11:53:31'),'MM/DD/YYYY HH:mm:SS');
ok($dt = $parser->parse_datetime('2012-10-05 15:02:01.1'),'YYYY-MM-DD HH:mm:SS.F');
ok($dt->nanosecond,'Fractions of a second');
ok($parser->parse_datetime('08/26/2012 8:09:14'),'MM/DD/YYYY H:mm:SS');
ok($parser->parse_datetime('10/08/2012'),'MM/DD/YYYY');
ok($dt = $parser->parse_datetime('2012-08-31 23:11:15.356'),'YYYY-MM-DD HH:mm:SS.FFF');
ok($dt->nanosecond,'Fractions of a second');
ok($parser->parse_datetime('08-31-2012'),'MM-DD-YYYY');
