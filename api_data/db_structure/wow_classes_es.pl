use open qw(:std :utf8);
use utf8::all; 
use IO::All;
use JSON;
use Data::Dumper;
use DBD::mysql;

my ($dbname,$dbhost,$dbuser,$dbpass) = ('dbname', 'localhost', 'dbuser', 'dbpass');

my $contenido < io('https://eu.api.battle.net/wow/data/character/classes?locale=es_ES&apikey=5gdrgfafqdnkryj8tqafqxsdr4qamdcq');

my $json = JSON->new->utf8->decode($contenido);
print Dumper($json);

my $db = DBI->connect("DBI:mysql:$dbname:$dbhost", "$dbuser", "$dbpass") or die "Imposible conectar con la DB";
$db->{'mysql_enable_utf8'} = 1;

my $sth = $db->prepare("DROP TABLE IF EXISTS `wow_classes_es`");
$sth->execute() or die "imposible borrar la tabla";
$sth->finish;

$sth = $db->prepare("CREATE TABLE `blizzardrankings`.`wow_classes_es` (`id` INT(2) NOT NULL, `name` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL, `power_type` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL, `mask` INT(32) NOT NULL) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_spanish_ci");
$sth->execute() or die "imposible crear la tabla";
$sth->finish;

$sth = $db->prepare("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");
$sth->execute() or die "imposible insertar en la tabla";
$sth->finish;

my @classes = @{$json->{'classes'}};
 
foreach my $indice (keys(@classes)) {
	my $name = $json->{'classes'}->[$indice]->{'name'};
	my $power = $json->{'classes'}->[$indice]->{'powerType'};
	print "$name\n";
	$sth = $db->prepare("INSERT INTO wow_classes_es VALUES ('$json->{'classes'}->[$indice]->{'id'}', '$name', '$power', '$json->{'classes'}->[$indice]->{'mask'}')");
	$sth->execute() or die "imposible insertar en la tabla";
	$sth->finish;
}

$db->disconnect;
