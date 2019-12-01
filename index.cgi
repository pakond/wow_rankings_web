#!c:/perl64/bin/perl.exe
use strict;
use BlizzardRankings;
use utf8;

my $BlizzardRankings = new BlizzardRankings(
	PARAMS => {
        path => 'c:\xampp\htdocs',
		url => 'http://localhost',
		css => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css',
		keywords => 'rankings, blizzard, wow, starcraft, diablo3',
		description_es => 'Rankings de todos los juegos de Blizzard',
		description => 'Rankings of all Blizzard games',
		charset => 'UTF-8',
		viewport => 'width=device-width, initial-scale=1',
		ajax => 'https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js',
		bootstrap => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js',
		js => 'http://localhost/javascript.js',
		db_host => 'localhost',
		db_user => 'dbuser',
		db_pass => 'dbpass',
		db_name => 'dbname',
	}
);
$BlizzardRankings -> run();