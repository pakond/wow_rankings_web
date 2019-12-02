use open qw(:std :utf8);
use utf8::all;
use IO::All;
use JSON;
use Data::Dumper;
use DBD::mysql;

my ($dbname,$dbhost,$dbuser,$dbpass) = ('dbname', 'localhost', 'dbuser', 'dbpass');

my $contenido < io('https://eu.api.battle.net/wow/data/character/races?locale=es_ES&apikey=5gdrgfafqdnkryj8tqafqxsdr4qamdcq');

my $json = JSON->new->utf8->decode($contenido);
print Dumper($json);

my $db = DBI->connect("DBI:mysql:$dbname:$dbhost", "$dbuser", "$dbpass") or die "Imposible conectar con la DB";
$db->{'mysql_enable_utf8'} = 1;

my $sth = $db->prepare("DROP TABLE IF EXISTS `wow_races_es`");
$sth->execute() or die "imposible crear la tabla";
$sth->finish;

$sth = $db->prepare("CREATE TABLE `blizzardrankings`.`wow_races_es` ( `id` INT(2) NOT NULL, `name` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL , `side` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, `mask` INT(32) NOT NULL) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci");
$sth->execute() or die "imposible crear la tabla";
$sth->finish;

$sth = $db->prepare("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");
$sth->execute() or die "imposible insertar en la tabla";
$sth->finish;

my @races = @{$json->{'races'}};
 
foreach $indice (keys(@races)) {
	my $name = $json->{'races'}->[$indice]->{'name'};
	my $side = $json->{'races'}->[$indice]->{'side'};
	print "$name\n";
	$sth = $db->prepare("INSERT INTO wow_races_es VALUES ('$json->{'races'}->[$indice]->{'id'}', '$name', '$side', '$json->{'races'}->[$indice]->{'mask'}')");
	$sth->execute() or die "imposible crear la tabla";
	$sth->finish;
}

$db->disconnect;
