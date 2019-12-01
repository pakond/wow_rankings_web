use IO::All;
use JSON::XS;
use DBD::mysql;

my $api_key = 'apikey';
my $season = 's25';

leadders('eu', '2v2');
leadders('eu', '3v3');
leadders('eu', 'rbg');

sub leadders {
	my ($region, $bracket, $lang) = @_; 
	my ($dbname,$dbhost,$dbuser,$dbpass) = ('dbname', 'dbhost', 'dbuser', 'dbpass');
	
	my $contenido < io("https://$region.api.battle.net/wow/leaderboard/$bracket?locale=en_GB&apikey=$api_key");
	$contenido =~ s/\n//g;
	$contenido =~ s/ //g;
	my $json = decode_json $contenido;
	my @leadder = @{$json->{'rows'}};
	my $check = @leadder;
	
	if ($check > 1000) {
		my $db = DBI->connect("DBI:mysql:$dbname:$dbhost", "$dbuser", "$dbpass") or die "Imposible conectar con la DB";
		$db->{'mysql_enable_utf8'} = 1;

		my $sth;

		#eliminamos datos antiguos
		$sth = $db->prepare("DROP TABLE IF EXISTS `wow_$region\_leadder_$bracket\_$season`");
		$sth->execute() or die "imposible eliminar la tabla";
		$sth->finish;

		#creamos la tabla nueva
		$sth = $db->prepare("CREATE TABLE `blizzardrankings`.`wow_$region\_leadder_$bracket\_$season` ( `name_id` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_bin, `ranking` INT(4) NOT NULL, `rating` INT(4) NOT NULL, `name` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL , `realm_id` INT(4) NOT NULL, `realm_name` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, `realm_slug` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, `race_id` INT(2) NOT NULL, `class_id` INT(2) NOT NULL, `spec_id` INT(3) NOT NULL, `faction_id` INT(2) NOT NULL, `gender_id` INT(2) NOT NULL, `season_wins` INT(5) NOT NULL, `season_losses` INT(5) NOT NULL, `weekly_wins` INT(5) NOT NULL, `weekly_losses` INT(5) NOT NULL) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci");
		$sth->execute() or die "imposible crear la tabla";
		$sth->finish;

		#movidas de utf8
		$sth = $db->prepare("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");
		$sth->execute() or die "imposible cambiar charset en la tabla";
		$sth->finish;

		#insertamos en la tabla nueva
		#my @leadder = @{$json->{'rows'}}; 
		foreach $indice (keys(@leadder)) {
			if ($json->{'rows'}->[$indice]->{'name'}) {
				$json->{'rows'}->[$indice]->{'realmName'} =~ s/'//;
				$sth = $db->prepare("INSERT INTO wow_$region\_leadder_$bracket\_$season VALUES ('$json->{'rows'}->[$indice]->{'name'}', '$json->{'rows'}->[$indice]->{'ranking'}', '$json->{'rows'}->[$indice]->{'rating'}', '$json->{'rows'}->[$indice]->{'name'}', '$json->{'rows'}->[$indice]->{'realmId'}', '$json->{'rows'}->[$indice]->{'realmName'}', '$json->{'rows'}->[$indice]->{'realmSlug'}', '$json->{'rows'}->[$indice]->{'raceId'}', '$json->{'rows'}->[$indice]->{'classId'}', '$json->{'rows'}->[$indice]->{'specId'}', '$json->{'rows'}->[$indice]->{'factionId'}', '$json->{'rows'}->[$indice]->{'genderId'}', '$json->{'rows'}->[$indice]->{'seasonWins'}', '$json->{'rows'}->[$indice]->{'seasonLosses'}', '$json->{'rows'}->[$indice]->{'weeklyWins'}', '$json->{'rows'}->[$indice]->{'weeklyLosses'}')");
				$sth->execute() or die "imposible insertar en la tabla";
				$sth->finish;
			}
		}

		$db->disconnect;
	}

}