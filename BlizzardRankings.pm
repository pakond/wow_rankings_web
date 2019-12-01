package BlizzardRankings;
use base qw ( CGI::Application );
use CGI::Carp qw(fatalsToBrowser);
use DBD::mysql;
use strict;
use utf8;
use Data::Dumper;

sub setup {
    my $self = shift;
    $self->run_modes(
        'index' => 'index',
		'wow' => 'wow',
		'starcraft' => 'starcraft',
		'diablo3' => 'diablo3',
		'contact' => 'contact',
		'sitemap' => 'sitemap',
    );
	$self->start_mode('index');
	$self->mode_param('action');
}

sub cgiapp_init {
    my $self = shift;
    my $query = $self->query;
	
	#$self->header_add( -type => 'text/html', -charset => 'UTF-8');

    my ($dbname,$dbhost,$dbuser,$dbpass) = ($self->param('db_name'), $self->param('db_host'), $self->param('db_user'), $self->param('db_pass'));
    my $db = DBI->connect("DBI:mysql:$dbname:$dbhost", "$dbuser", "$dbpass") or die "Imposible conectar con la DB";
	#$db->{'mysql_enable_utf8'} = 1;
	#my $sth = $db->prepare("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");
	#$sth->execute() or die "imposible insertar en la tabla";
	#$sth->finish;
	$self->param('db' => $db);	
}

sub teardown {
    my $self = shift;
    my $db = $self->param('db');
    $db->disconnect;
}

sub index {
    my $self = shift;
    my $query = $self->query;
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	
	my $db = $self->param('db');
    my $sth = $db->prepare("select id, name, power_type, mask from wow_classes_es");
    $sth->execute() or die "imposible ejecutar la consulta";
    my @nombres;
    while(my $data = $sth->fetchrow_hashref()){
		push @nombres, $data;
    }
    $sth->finish;
	
	my $return = "";
	
	if ($datos{lang} eq 'es') {
		$return .= $self->header(
			$datos{lang}, 
			$self->param('css'), 
			$self->param('charset'), 
			'Blizzard Rankings', 
			$self->param('description_es'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_es('index');
		$return .= $self->index_es(@nombres);
		$return .= $self->footer_es();
	}
	else {
		$return .= $self->header(
			'en', 
			$self->param('css'), 
			$self->param('charset'), 
			'Blizzard Rankings', 
			$self->param('description'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_en('index');
		$return .= $self->index_en(@nombres);
		$return .= $self->footer_en();
	}
    
    return $return;
}

sub wow {
	my $self = shift;
    my $query = $self->query;
    
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	#my $get = $ENV{QUERY_STRING};
	
	my $return = "";
	
	if ($datos{mode} eq 'pvp') {
		if ($datos{lang} eq 'es') {
			$return .= $self->header(
				$datos{lang}, 
				$self->param('css'), 
				$self->param('charset'), 
				'Rankings PVP World of Warcraft', 
				$self->param('description_es'), 
				$self->param('keywords'),
				$self->param('viewport'),
				$self->param('ajax'),
				$self->param('javascript'),
				$self->param('bootstrap')
			);
			$return .= $self->navbar_es('wow', $url);
			$return .= $self->wow_pvp_es($self->get_ranking_wow_pvp());
			$return .= $self->footer_es();
		}
		else {
			if ($datos{bracket} eq '2v2') {
				$return .= $self->header(
					'en', 
					$self->param('css'), 
					$self->param('charset'), 
					'World of Warcraft 2v2 PVP Rankings', 
					$self->param('description'), 
					$self->param('keywords'),
					$self->param('viewport'),
					$self->param('ajax'),
					$self->param('javascript'),
					$self->param('bootstrap')
				);
				$return .= $self->navbar_en('wow', $url);
				my ($players, $total_rows) = $self->get_ranking_wow_pvp(2, $datos{page}, $datos{player}, $datos{spec}, $datos{realm}, $datos{faction});
				$return .= $self->wow_pvp_en_bracket($players, '2v2', $datos{page}, $total_rows, $datos{mode});
				$return .= $self->footer_en();
			}
			elsif ($datos{bracket} eq '3v3') {
				$return .= $self->header(
					'en', 
					$self->param('css'), 
					$self->param('charset'), 
					'World of Warcraft 3v3 PVP Rankings', 
					$self->param('description'), 
					$self->param('keywords'),
					$self->param('viewport'),
					$self->param('ajax'),
					$self->param('javascript'),
					$self->param('bootstrap')
				);
				$return .= $self->navbar_en('wow', $url);
				my ($players, $total_rows) = $self->get_ranking_wow_pvp(3, $datos{page}, $datos{player}, $datos{spec}, $datos{realm}, $datos{faction});
				$return .= $self->wow_pvp_en_bracket($players, '3v3', $datos{page}, $total_rows, $datos{mode});
				$return .= $self->footer_en();
			}
			elsif ($datos{bracket} eq 'rbg') {
				$return .= $self->header(
					'en', 
					$self->param('css'), 
					$self->param('charset'), 
					'World of Warcraft RBG PVP Rankings', 
					$self->param('description'), 
					$self->param('keywords'),
					$self->param('viewport'),
					$self->param('ajax'),
					$self->param('javascript'),
					$self->param('bootstrap')
				);
				$return .= $self->navbar_en('wow', $url);
				my ($players, $total_rows) = $self->get_ranking_wow_pvp(1, $datos{page}, $datos{player}, $datos{spec}, $datos{realm}, $datos{faction});
				$return .= $self->wow_pvp_en_bracket($players, 'rbg', $datos{page}, $total_rows, $datos{mode});
				$return .= $self->footer_en();
			}
			else {
				$return .= $self->header(
					'en', 
					$self->param('css'), 
					$self->param('charset'), 
					'World of Warcraft PVP Rankings', 
					$self->param('description'), 
					$self->param('keywords'),
					$self->param('viewport'),
					$self->param('ajax'),
					$self->param('javascript'),
					$self->param('bootstrap')
				);
				$return .= $self->navbar_en('wow', $url);
				$return .= $self->wow_pvp_en($self->get_ranking_wow_pvp());
				$return .= $self->footer_en();
			}
		}
	}
	elsif ($datos{mode} eq 'mythics') {
		if ($datos{lang} eq 'es') {
			$return .= $self->header(
				$datos{lang}, 
				$self->param('css'), 
				$self->param('charset'), 
				"Rankings Míticas World of Warcraft", 
				$self->param('description_es'), 
				$self->param('keywords'),
				$self->param('viewport'),
				$self->param('ajax'),
				$self->param('javascript'),
				$self->param('bootstrap')
			);
			$return .= $self->navbar_es('wow', $url);
			$return .= $self->wow_mythics_es();
			$return .= $self->footer_es();
		}
		else {
			$return .= $self->header(
				'en', 
				$self->param('css'), 
				$self->param('description'), 
				$self->param('keywords'),
				$self->param('charset'), 
				'World of Warcraft Mythics Rankings', 
				$self->param('viewport'),
				$self->param('ajax'),
				$self->param('javascript'),
				$self->param('bootstrap')
			);
			$return .= $self->navbar_en('wow', $url);
			$return .= $self->wow_mythics_en();
			$return .= $self->footer_en();
		}
	}
	else {
		if ($datos{lang} eq 'es') {
			$return .= $self->header(
				$datos{lang}, 
				$self->param('css'), 
				$self->param('charset'), 
				'Rankings World of Warcraft', 
				$self->param('description_es'), 
				$self->param('keywords'),
				$self->param('viewport'),
				$self->param('ajax'),
				$self->param('javascript'),
				$self->param('bootstrap')
			);
			$return .= $self->navbar_es('wow', $url);
			$return .= $self->wow_es();
			$return .= $self->footer_es();
		}
		else {
			$return .= $self->header(
				'en', 
				$self->param('css'), 
				$self->param('charset'), 
				'World of Warcraft Rankings', 
				$self->param('description'), 
				$self->param('keywords'),
				$self->param('viewport'),
				$self->param('ajax'),
				$self->param('javascript'),
				$self->param('bootstrap')
			);
			$return .= $self->navbar_en('wow', $url);
			$return .= $self->wow_en();
			$return .= $self->footer_en();
		}
	}
	
    return $return;	
}

sub starcraft {
	my $self = shift;
    my $query = $self->query;
    
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	
	my $return = "";
	
	if ($datos{lang} eq "es") {
		$return .= $self->header(
			$datos{lang}, 
			$self->param('css'), 
			$self->param('charset'), 
			'Rankings Starcraft', 
			$self->param('description_es'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_es('sc', $url);
		$return .= $self->starcraft_es();
		$return .= $self->footer_es();
	}
	else {
		$return .= $self->header(
			'en', 
			$self->param('css'), 
			$self->param('charset'), 
			'Starcraft Rankings', 
			$self->param('description'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_en('sc', $url);
		$return .= $self->starcraft_en();
		$return .= $self->footer_en();
	}
	
    return $return;	
}

sub diablo3 {
	my $self = shift;
    my $query = $self->query;
    
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	
	my $return = "";
	
	if ($datos{lang} eq 'es') {
		$return .= $self->header(
			$datos{lang}, 
			$self->param('css'), 
			$self->param('charset'), 
			'Diablo3 Normal mode Rankings', 
			$self->param('description_es'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_es('d3', $url);
		$return .= $self->diablo3_es();
		$return .= $self->footer_es();
	}
	else {
		$return .= $self->header(
			'en', 
			$self->param('css'), 
			$self->param('charset'), 
			'Rankings Diablo3 Normal mode', 
			$self->param('description'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_en('d3', $url);
		$return .= $self->diablo3_en();
		$return .= $self->footer_en();
	}
	
    return $return;	
}

sub contact {
	my $self = shift;
    my $query = $self->query;
    
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	
	my $return = "";
	
	if ($datos{lang} eq 'es') {
		$return .= $self->header(
			$datos{lang}, 
			$self->param('css'), 
			$self->param('charset'), 
			'Blizzard Rankings Contact', 
			$self->param('description_es'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_es('', $url);
		$return .= $self->contact_es();
		$return .= $self->footer_es();
	}
	else {
		$return .= $self->header(
			'en', 
			$self->param('css'), 
			$self->param('charset'), 
			'Contacto Blizzard Rankings', 
			$self->param('description'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_en('', $url);
		$return .= $self->contact_en();
		$return .= $self->footer_en();
	}
	
    return $return;	
}

sub sitemap {
	my $self = shift;
    my $query = $self->query;
    
	my %datos = $query->Vars;
	my $url = $ENV{REQUEST_URI};
	
	my $return = "";
	
	if ($datos{lang} eq 'es') {
		$return .= $self->header(
			$datos{lang}, 
			$self->param('css'), 
			$self->param('charset'), 
			'Mapa del sitio Blizzard Rankings', 
			$self->param('description_es'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_es('', $url);
		$return .= $self->sitemap_es();
		$return .= $self->footer_es();
	}
	else {
		$return .= $self->header(
			'en', 
			$self->param('css'), 
			$self->param('charset'), 
			'Sitemap Blizzard Rankings', 
			$self->param('description'), 
			$self->param('keywords'),
			$self->param('viewport'),
			$self->param('ajax'),
			$self->param('javascript'),
			$self->param('bootstrap')
		);
		$return .= $self->navbar_en('', $url);
		$return .= $self->sitemap_en();
		$return .= $self->footer_en();
	}
	
    return $return;	
}

sub get_ranking_wow_pvp {
	my ($self, $bracket, $pagina, $player, $spec, $realm, $faction) = @_;
	my $db = $self->param('db');
	my $players;
	
	if ($pagina >= 2) {
	    $pagina = $pagina - 1;
		$pagina = $pagina * 100;
	}
	else {
		$pagina = 0;
	}
	
	if ($faction eq 'Both') {
		undef $faction;
	}
	
	if ($realm eq 'All') {
		undef $realm;
	}
	
	if ($bracket == 1) {
		my $query = "select * from wow_eu_leadder_rbg";
		if ((!$player) && (!$spec) && (!$realm) && (!$faction)) {
			$query .= " LIMIT 100 OFFSET $pagina";
			my $sth = $db->prepare($query);
			$sth->execute() or die "imposible ejecutar la consulta $query";
			my @players;
			while(my $data = $sth->fetchrow_hashref()){
				push @players, $data;
			}
			$sth->finish;
			$players->{'rbg'} = \@players;
		
			$query =~ s/LIMIT 100 OFFSET $pagina//;
			my $sth = $db->prepare($query);
			$sth->execute() or die "imposible ejecutar la consulta";
			my $count = $sth->rows;
			$sth->finish;
		
			return ($players, $count);
		}
		else {
			$query .= " where";
			if ($player) {
				$query .= " name like '$player' AND";
			}
			if ($spec) {
				#die Dumper($spec);
				my @specs = split(/_/, $spec);
				#die Dumper(@specs);
				my $longitud = @specs;
				if ($longitud > 1) {
					for (my $i = 0; $i < $longitud; $i++) {
						if ($i == 0) {
							$query .= " spec_id IN ($specs[$i],";
						}
						if (($i != 0) && ($i != $longitud-1)) {
							$query .= " $specs[$i],";
						}
						if ($i == $longitud-1) {
							$query .= " $specs[$i]) AND";
						}
					}
				}
				else {
					$query .= " spec_id = $specs[0] AND";
				}
			}
			if ($realm) {
				$query .= " realm_name = '$realm' AND";
			}
			if ($faction eq 'Horde') {
				$query .= " faction_id = 1 AND";
			}
			if ($faction eq 'Alliance') {
				$query .= " faction_id = 0 AND";
			}
			$query =~ s/AND$//;
			$query .= " LIMIT 100 OFFSET $pagina";
			#die "Consulta ejecutada: $query";
			my $sth = $db->prepare($query);
			$sth->execute() or die "imposible ejecutar la consulta $query";
			my @players;
			while(my $data = $sth->fetchrow_hashref()){
				push @players, $data;
			}
			$sth->finish;
			$players->{'rbg'} = \@players;
		
			$query =~ s/LIMIT 100 OFFSET $pagina//;
			my $sth = $db->prepare($query);
			$sth->execute() or die "imposible ejecutar la consulta";
			my $count = $sth->rows;
			$sth->finish;
		
			return ($players, $count);
		}
	}
	elsif ($bracket == 2) {
		my $sth = $db->prepare("select * from wow_eu_leadder_2v2 LIMIT 100 OFFSET $pagina");
		$sth->execute() or die "imposible ejecutar la consulta";
		my @players;
		while(my $data = $sth->fetchrow_hashref()){
			push @players, $data;
		}
		$sth->finish;
		$players->{'2v2'} = \@players;
		
		my $sth = $db->prepare("select * from wow_eu_leadder_2v2");
		$sth->execute() or die "imposible ejecutar la consulta";
		my $count = $sth->rows;
		$sth->finish;
		
		return ($players, $count);
	}
	elsif ($bracket == 3) {
		my $sth = $db->prepare("select * from wow_eu_leadder_3v3 LIMIT 100 OFFSET $pagina");
		$sth->execute() or die "imposible ejecutar la consulta";
		my @players;
		while(my $data = $sth->fetchrow_hashref()){
			push @players, $data;
		}
		$sth->finish;
		$players->{'3v3'} = \@players;
		
		my $sth = $db->prepare("select * from wow_eu_leadder_3v3");
		$sth->execute() or die "imposible ejecutar la consulta";
		my $count = $sth->rows;
		$sth->finish;
		
		return ($players, $count);
	}
	else {
		my $sth = $db->prepare("select * from wow_eu_leadder_2v2 LIMIT 10");
		$sth->execute() or die "imposible ejecutar la consulta";
		my @players2v2;
		while(my $data = $sth->fetchrow_hashref()){
			push @players2v2, $data;
		}
		$sth->finish;
	
		my $sth = $db->prepare("select * from wow_eu_leadder_3v3 LIMIT 10");
		$sth->execute() or die "imposible ejecutar la consulta";
		my @players3v3;
		while(my $data = $sth->fetchrow_hashref()){
			push @players3v3, $data;
		}
		$sth->finish;
	
		my $sth = $db->prepare("select * from wow_eu_leadder_rbg LIMIT 10");
		$sth->execute() or die "imposible ejecutar la consulta";
		my @playersrbg;
		while(my $data = $sth->fetchrow_hashref()){
			push @playersrbg, $data;
		}
		$sth->finish;
	
		$players->{'2v2'} = \@players2v2;
		$players->{'3v3'} = \@players3v3;
		$players->{'rbg'} = \@playersrbg;
	
		return $players;
	}
}

sub winratio {
	my ($self, $wins, $losses) = @_;
	my $totalpartidas = $wins + $losses;
	my $num = 100 / $totalpartidas;
	my $porcentaje = int($num * $wins);
	return $porcentaje;
}

sub spec_en {
	my ($self, $spec_id) = @_;
	my $db = $self->param('db');
	
	my $sth = $db->prepare("select name, class from wow_specs where id = $spec_id");
	$sth->execute() or die "Imposible ejecutar la consulta para $spec_id";
    my $spec = $sth->fetchrow_hashref();
    $sth->finish;
	
	return ($spec->{name}, $spec->{class});
}

sub race_en {
	my ($self, $race_id) = @_;
	my $db = $self->param('db');
	
	my $sth = $db->prepare("select name from wow_races where id = $race_id");
	$sth->execute() or die "Imposible ejecutar la consulta para $race_id";
    my $race = $sth->fetchrow_hashref();
    $sth->finish;
	
	return $race->{name};
}

sub get_eu_servers {
	my $self = shift;
	my $db = $self->param('db');
	
	my $sth = $db->prepare("select name from wow_eu_servers");
	$sth->execute() or die "Imposible ejecutar la consulta para get_eu_servers";
	
	my @servers;
	while (my $server = $sth->fetchrow_array()) {
		push @servers, $server;
	}
    $sth->finish;
	
	return @servers;
}

sub header {
	my ($self, $lang, $css, $charset, $title, $description, $keywords, $viewport, $ajax, $js, $bootstrap, $js) = @_;
    my $return = "";
	$return .= <<EOT;
<!DOCTYPE html>
<html lang="$lang">
<head>
 <meta charset="$charset">
 <meta name="description" content="$description">
 <meta name="keywords" content="$keywords">
 <meta name="viewport" content="$viewport">
 <link rel="stylesheet" href="$css">
 <script src="$ajax"></script>
 <script src="$bootstrap"></script>
 <script src="http://localhost/javascript.js"></script>
 <title>$title</title>
</head>
<body>
EOT
	return $return;
}

sub navbar_es {
	my ($self, $active, $referer) = @_;
	my $url = $self->{'url'};
    my $return = "";
	
	$return .= <<EOT;	
<nav class="navbar navbar-inverse">
  <div class="container">
    <div class="navbar-header">
      <a class="navbar-brand" href="$url/es">Blizzard Rankings</a>
    </div>
    <ul class="nav navbar-nav">
EOT
    if ($active eq 'index') {
		$return .= <<EOT;
      <li class="active"><a href="$url/es">Home</a></li>
EOT
    }
    else {
		$return .= <<EOT;
      <li><a href="$url/es">Home</a></li>
EOT
    }
	if ($active eq 'wow') {
		$return .= <<EOT;
	  <li class="active"><a href="$url/es/wow">World of Warcraft</a></li>      
EOT
    }
    else {
		$return .= <<EOT;
	  <li><a href="$url/es/wow">World of Warcraft</a></li>
EOT
    }
	if ($active eq 'sc') {
		$return .= <<EOT;
      <li class="active"><a href="$url/es/starcraft">Starcraft</a></li>
EOT
    }
    else {
		$return .= <<EOT;
      <li><a href="$url/es/starcraft">Starcraft</a></li>
EOT
    }
	if ($active eq 'd3') {
		$return .= <<EOT;
      <li class="active"><a href="$url/es/diablo3">Diablo3</a></li>
EOT
    }
    else {
		$return .= <<EOT;
	  <li><a href="$url/es/diablo3">Diablo 3</a></li>
EOT
    }
    $return .= <<EOT;		  
    </ul>
	<ul class="nav navbar-nav navbar-right">
EOT
	if (!$referer) {
		$return .= <<EOT;
	 <li><a href="/en" >Ingles</a></li>
	 <li class="active"><a href="/es">Español</a></li>
EOT
	}
	else {
		my $referer2 = $referer;
		if($referer2) {
			$referer2 =~ s/^\/es/\/en/;
			$return .= <<EOT;
	 <li><a href="$referer2" >Ingles</a></li>
EOT
		}
		$return .= <<EOT;
	 <li class="active"><a href="$referer">Español</a></li>
EOT
	}
	$return .= <<EOT;
	</ul>
  </div>
</nav>
EOT
	return $return;
}

sub navbar_en {
	my ($self, $active, $referer) = @_;
	my $url = $self->{'url'};
    my $return = "";
	
	$return .= <<EOT;
<nav class="navbar navbar-inverse">
  <div class="container">
    <div class="navbar-header">
      <a class="navbar-brand" href="$url/en">Blizzard Rankings</a>
    </div>
    <ul class="nav navbar-nav">
EOT
    if ($active eq 'index') {
		$return .= <<EOT;
      <li class="active"><a href="$url/en">Home</a></li>
EOT
    }
    else {
		$return .= <<EOT;
      <li><a href="$url/en">Home</a></li>
EOT
    }
	if ($active eq 'wow') {
		$return .= <<EOT;
	  <li class="active"><a href="$url/en/wow">World of Warcraft</a></li>
EOT
    }
    else {
		$return .= <<EOT;
	  <li><a href="$url/en/wow">World of Warcraft</a></li>
EOT
    }
	if ($active eq 'sc') {
		$return .= <<EOT;
      <li class="active"><a href="$url/en/starcraft">Starcraft</a></li>
EOT
    }
    else {
		$return .= <<EOT;
      <li><a href="$url/en/starcraft">Starcraft</a></li>
EOT
    }
	if ($active eq 'd3') {
		$return .= <<EOT;
      <li class="active"><a href="$url/en/diablo3">Diablo 3</a></li>
EOT
    }
    else {
		$return .= <<EOT;
	  <li><a href="$url/en/diablo3">Diablo 3</a></li>
EOT
    }
    $return .= <<EOT;		  
    </ul>
	<ul class="nav navbar-nav navbar-right">
EOT
	if (!$referer) {
		$return .= <<EOT;;
	 <li class="active"><a href="/en">Ingles</a></li>
	 <li><a href="/es">Español</a></li>
EOT
	}
	else {
		$return .= <<EOT;;
	 <li class="active"><a href="$referer">Ingles</a></li>
EOT
		$referer =~ s/^\/en/\/es/;
		$return .= <<EOT;
	 <li><a href="$referer">Español</a></li>
EOT
	}
	$return .= <<EOT;
	</ul>
  </div>
</nav>	
EOT
	return $return;
}

sub index_es {
	my ($self, @nombres) = @_;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Blizzard Rankings</h1> 
 <p>Rankings de todos los juegos de Blizzard</p>
EOT
	for(@nombres) {
		$return .= <<EOT;
 <p>$_->{id} --- $_->{name} --- $_->{mask} --- $_->{power_type}</p>		
EOT
	}
    $return.= <<EOT;
 <table class="table">
  <thead>
    <tr>
     <th>World of Warcraft</th>
	 <th>Starcraft</th>
	 <th>Diablo3</th>
    </tr>
   </thead>
   <tbody>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
   </tbody>
 </table>
</div>
EOT
	return $return;
}

sub index_en {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Blizzard Rankings</h1> 
 <p>Rankings of all Blizzard Games</p>
 <table class="table">
  <thead>
    <tr>
     <th>World of Warcraft</th>
	 <th>Starcraft</th>
	 <th>Diablo3</th>
    </tr>
   </thead>
   <tbody>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
     <tr>
	  <td>Super</td>
	  <td>Super</td>
	  <td>Super</td>
     </tr>
   </tbody>
 </table>
</div>
EOT
	return $return;
}

sub wow_es {
	my $self = shift;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/es/wow/mythics" class="btn btn-primary">Míticas</a>
  <a href="$url/es/wow/pvp" class="btn btn-primary">Jugador contra Jugador</a>
 </div>
 <h1>Rankings de World of Warcraft</h1> 
 <p>Rankings de World of Warcraft</p>
</div>
EOT
	return $return;
}

sub wow_en {
	my $self = shift;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/en/wow/mythics" class="btn btn-primary">Mythics</a>
  <a href="$url/en/wow/pvp" class="btn btn-primary">Player vs Player</a>
 </div>
 <h1>Rankings of World of Warcraft</h1> 
 <p>Rankings of World of Warcraft</p>
</div>
EOT
	return $return;
}

sub wow_pvp_es {
	my ($self, $uri, @players) = @_;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/es/wow/mythics" class="btn btn-primary">Míticas</a>
  <a href="$url/es/wow/pvp" class="btn btn-primary">Jugador contra Jugador</a>
 </div>
 <h1>Rankings PVP de World of Warcraft</h1> 
 <p>Rankings PVP de World of Warcraft</p>
</div>
EOT
	return $return;
}

sub wow_pvp_en {
	my ($self, $players) = @_;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/en/wow/mythics" class="btn btn-primary">Mythics</a>
  <a href="$url/en/wow/pvp" class="btn btn-primary active">Player vs Player</a>
 </div>
 <p></p>
 <div class="btn-group btn-group-justified">
  <a href="$url/en/wow/pvp/3v3" class="btn btn-success">3v3 Ranking</a>
  <a href="$url/en/wow/pvp/2v2" class="btn btn-success">2v2 Ranking</a>
  <a href="$url/en/wow/pvp/rbg" class="btn btn-success">RBG Ranking</a>
 </div>
 <h1>World of Warcraft PVP Rankings</h1> 
 <div class="row">
  <div class="col-sm-4">
   <h2 class="text-center">Top 10 <a href="$url/en/wow/pvp/2v2"><ins>2v2</ins></a></h2>
   <table class="table table-bordered">
    <thead>
     <tr>
      <th>Ranking</th>
	  <th>Player</th>
	  <th>Rating</th>
     </tr>
    </thead>
    <tbody>
EOT
	my @players2v2 = @{$players->{'2v2'}};
	foreach my $data (@players2v2) {
		my $faction = $data->{faction_id};
		$return .= <<EOT;
	 <tr>
	  <td><span class="text-warning">#$data->{ranking}</span></td>
	  <td><img src="/img/faction_$data->{faction_id}.jpg" class="img-rounded"><a class="bg-success" style="color: green" target="_blank" href="https://worldofwarcraft.com/en-gb/character/$data->{realm_slug}/$data->{name}">$data->{name}</a></td>
	  <td><b>$data->{rating}</b></td>
	 </tr>
EOT
	}
	$return .= <<EOT;
	</tbody>
   </table>
  </div>
  <div class="col-sm-4">
   <h2 class="text-center">Top 10 <a href="$url/en/wow/pvp/3v3"><ins>3v3</ins></a></h2>
   <table class="table table-bordered">
    <thead>
     <tr>
      <th>Ranking</th>
	  <th>Player</th>
	  <th>Rating</th>
     </tr>
    </thead>
    <tbody>
EOT
	my @players3v3 = @{$players->{'3v3'}};
	foreach my $data (@players3v3) {
		my $faction = $data->{faction_id};
		$return .= <<EOT;
	 <tr>
	  <td><span class="text-warning">#$data->{ranking}</span></td>
	  <td><img src="/img/faction_$data->{faction_id}.jpg" class="img-rounded"><a class="bg-success" style="color: green" target="_blank" href="https://worldofwarcraft.com/en-gb/character/$data->{realm_slug}/$data->{name}">$data->{name}</a></td>
	  <td><b>$data->{rating}</b></td>
	 </tr>
EOT
	}
	$return .= <<EOT;
	</tbody>
   </table>
  </div>
  <div class="col-sm-4">
   <h2 class="text-center">Top 10 <a href="$url/en/wow/pvp/rbg"><ins>RBG</ins></a></h2>
   <table class="table table-bordered">
    <thead>
     <tr>
      <th>Ranking</th>
	  <th>Player</th>
	  <th>Rating</th>
     </tr>
    </thead>
    <tbody>
EOT
	my @playersrbg = @{$players->{'rbg'}};
	foreach my $data (@playersrbg) {
		my $faction = $data->{faction_id};
		$return .= <<EOT;
	 <tr>
	  <td><span class="text-warning">#$data->{ranking}</span></td>
	  <td><img src="/img/faction_$data->{faction_id}.jpg" class="img-rounded"><a class="bg-success" style="color: green" target="_blank" href="https://worldofwarcraft.com/en-gb/character/$data->{realm_slug}/$data->{name}">$data->{name}</a></td>
	  <td><b>$data->{rating}</b></td>
	 </tr>
EOT
	}
	$return .= <<EOT;
	</tbody>
   </table>
  </div>
  </div>
</div>
EOT
	return $return;
}

sub wow_pvp_en_bracket {
	my ($self, $players, $bracket, $page, $total_entradas, $mode, $return_spec) = @_;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/en/wow/mythics" class="btn btn-primary">Mythics</a>
  <a href="$url/en/wow/pvp" class="btn btn-primary active">Player vs Player</a>
 </div>
 <p></p>
 <div class="btn-group btn-group-justified">
EOT
	if ($bracket eq '3v3') {
		$return .= <<EOT;
   <a href="$url/en/wow/pvp/3v3" class="btn btn-success active">3v3 Ranking</a>	
EOT
	}
	else {
		$return .= <<EOT;
   <a href="$url/en/wow/pvp/3v3" class="btn btn-success">3v3 Ranking</a>		
EOT
	}
	if ($bracket eq '2v2') {
		$return .= <<EOT;
   <a href="$url/en/wow/pvp/2v2" class="btn btn-success active">2v2 Ranking</a>
EOT
	}
	else {
		$return .= <<EOT;
   <a href="$url/en/wow/pvp/2v2" class="btn btn-success">2v2 Ranking</a>	
EOT
	}
	if ($bracket eq 'rbg') {
		$return .= <<EOT
   <a href="$url/en/wow/pvp/rbg" class="btn btn-success active">RBG Ranking</a>
EOT
	}
	else {
		$return .= <<EOT;
   <a href="$url/en/wow/pvp/rbg" class="btn btn-success">RBG Ranking</a>		
EOT
	}
	$return .= <<EOT;
 </div>
EOT
	if ($bracket eq '2v2') {
		$return .= <<EOT;
 <h1>World of Warcraft 2v2 PVP Rankings</h1>
EOT
}
	elsif ($bracket eq '3v3') {
		$return .= <<EOT;
 <h1>World of Warcraft 3v3 PVP Rankings</h1>
EOT
}
	elsif ($bracket eq 'rbg') {
		$return .= <<EOT;
 <h1>World of Warcraft RBG PVP Rankings</h1>
EOT
}
	my $entradas_total = int($total_entradas / 100);
	if ($page > $entradas_total) {
		$return .= <<EOT;
 <h2 class="text-danger">NO RESULTS TO SHOW</h2>
EOT
	}
	else {
	    my @players = @{$players->{$bracket}};
		my $list_players = @players;
		$return .= <<EOT;
 <p>$return_spec</p>
 <p>Showing $list_players players ($total_entradas total)</p>
 <form class="form-inline" action="$url/en/wow/pvp/$bracket" method="get">
 <div class="row">
  <div class="col-xs-2 form-group">
   <label for="player">Player Name:</label>
   <input type="text" class="form-control" name="player">
  </div>
  <div class="col-xs-2 form group">
   <p>
   <label class="checkbox-inline"><input type="checkbox" value="class_1" data-toggle="collapse" data-target="#warrior" class="check-warrior"><img src="/img/class_1.jpg" class="img-rounded" alt="Warrior"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_2" data-toggle="collapse" data-target="#paladin" class="check-paladin"><img src="/img/class_2.jpg" class="img-rounded" alt="Paladin"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_3" data-toggle="collapse" data-target="#hunter" class="check-hunter"><img src="/img/class_3.jpg" class="img-rounded" alt="Hunter"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_4" data-toggle="collapse" data-target="#rogue" class="check-rogue"><img src="/img/class_4.jpg" class="img-rounded" alt="Rogue"></label>
   </p>
   <p>
   <label class="checkbox-inline"><input type="checkbox" value="class_5" data-toggle="collapse" data-target="#priest" class="check-priest"><img src="/img/class_5.jpg" class="img-rounded" alt="Priest"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_6" data-toggle="collapse" data-target="#deathknight" class="check-deathknight"><img src="/img/class_6.jpg" class="img-rounded" alt="Death Knight"></label> 
   <label class="checkbox-inline"><input type="checkbox" value="class_7" data-toggle="collapse" data-target="#shaman" class="check-shaman"><img src="/img/class_7.jpg" class="img-rounded" alt="Shaman"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_8" data-toggle="collapse" data-target="#mage" class="check-mage"><img src="/img/class_8.jpg" class="img-rounded" alt="Mage"></label>
   </p>
   <p>
   <label class="checkbox-inline"><input type="checkbox" value="class_9" data-toggle="collapse" data-target="#warlock" class="check-warlock"><img src="/img/class_9.jpg" class="img-rounded" alt="Warlock"></label> 
   <label class="checkbox-inline"><input type="checkbox" value="class_10" data-toggle="collapse" data-target="#monk" class="check-monk"><img src="/img/class_10.jpg" class="img-rounded" alt="Monk"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_11" data-toggle="collapse" data-target="#druid" class="check-druid"><img src="/img/class_11.jpg" class="img-rounded" alt="Druid"></label>
   <label class="checkbox-inline"><input type="checkbox" value="class_12" data-toggle="collapse" data-target="#demonhunter" class="check-demonhunter"><img src="/img/class_12.jpg" class="img-rounded" alt="Demon Hunter"></label>
   </p>
  </div>
  <div class="col-xs-2 form group">
   <div id="warrior" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="71_"><img src="/img/spec_71.jpg" class="img-rounded" alt="Arms"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="72_"><img src="/img/spec_72.jpg" class="img-rounded" alt="Fury"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="73_"><img src="/img/spec_73.jpg" class="img-rounded" alt="Protection"></label>
   </div>
   <div id="paladin" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="65_"><img src="/img/spec_65.jpg" class="img-rounded" alt="Holy"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="66_"><img src="/img/spec_66.jpg" class="img-rounded" alt="Protection"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="70_"><img src="/img/spec_70.jpg" class="img-rounded" alt="Retribution"></label>
   </div>
   <div id="hunter" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="253_"><img src="/img/spec_253.jpg" class="img-rounded" alt="Beast Mastery"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="254_"><img src="/img/spec_254.jpg" class="img-rounded" alt="Marksmanship"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="255_"><img src="/img/spec_255.jpg" class="img-rounded" alt="Survival"></label>
   </div>
   <div id="rogue" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="259_"><img src="/img/spec_259.jpg" class="img-rounded" alt="Assassination"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="260_"><img src="/img/spec_260.jpg" class="img-rounded" alt="Outlaw"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="261_"><img src="/img/spec_261.jpg" class="img-rounded" alt="Subtlety"></label>
   </div>
   <div id="priest" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="256_"><img src="/img/spec_256.jpg" class="img-rounded" alt="Discipline"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="257_"><img src="/img/spec_257.jpg" class="img-rounded" alt="Holy"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="258_"><img src="/img/spec_258.jpg" class="img-rounded" alt="Shadow"></label>
   </div>
   <div id="deathknight" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="250_"><img src="/img/spec_250.jpg" class="img-rounded" alt="Blood"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="251_"><img src="/img/spec_251.jpg" class="img-rounded" alt="Forst"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="252_"><img src="/img/spec_252.jpg" class="img-rounded" alt="Unholy"></label>
   </div>
   <div id="shaman" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="262_"><img src="/img/spec_262.jpg" class="img-rounded" alt="Elemental"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="263_"><img src="/img/spec_263.jpg" class="img-rounded" alt="Enchancement"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="264_"><img src="/img/spec_264.jpg" class="img-rounded" alt="Restoration"></label>
   </div>
   <div id="mage" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="62_"><img src="/img/spec_62.jpg" class="img-rounded" alt="Arcane"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="63_"><img src="/img/spec_63.jpg" class="img-rounded" alt="Fire"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="64_"><img src="/img/spec_64.jpg" class="img-rounded" alt="Frost"></label>
   </div>
   <div id="warlock" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="265_"><img src="/img/spec_265.jpg" class="img-rounded" alt="Affliction"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="266_"><img src="/img/spec_266.jpg" class="img-rounded" alt="Demonology"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="267_"><img src="/img/spec_267.jpg" class="img-rounded" alt="Destruction"></label>
   </div>
   <div id="monk" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="268_"><img src="/img/spec_268.jpg" class="img-rounded" alt="Brewmaster"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="269_"><img src="/img/spec_269.jpg" class="img-rounded" alt="Windwalker"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="270_"><img src="/img/spec_270.jpg" class="img-rounded" alt="Mistweaver"></label>
   </div>
   <div id="druid" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="102_"><img src="/img/spec_102.jpg" class="img-rounded" alt="Balance"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="103_"><img src="/img/spec_103.jpg" class="img-rounded" alt="Feral"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="104_"><img src="/img/spec_104.jpg" class="img-rounded" alt="Guardian"></label>
	<label class="checkbox-inline"><input type="checkbox" name="spec" value="105_"><img src="/img/spec_105.jpg" class="img-rounded" alt="Restoration"></label>
   </div>
   <div id="demonhunter" class="collapse">
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="577_"><img src="/img/spec_577.jpg" class="img-rounded" alt="Havoc"></label>
    <label class="checkbox-inline"><input type="checkbox" name="spec" value="581_"><img src="/img/spec_581.jpg" class="img-rounded" alt="Devastation"></label>
   </div>
  </div>
  <div class="col-xs-2 form group">
   <label for="realm">Realm:</label>
   <select name="realm" class="form-control" id="realm">
	<option>All</option>
EOT
	my @servers = $self->get_eu_servers();
	foreach my $server (@servers) {
		$return .= <<EOT;
	<option>$server</option>	
EOT
	}
	$return .= <<EOT;
   </select>
  </div>
  <div class="col-xs-2 form group">
   <label for="faction">Faction:</label>
   <select name="faction" class="form-control" id="faction">
    <option>Both</option>
    <option>Alliance</option>
    <option>Horde</option>
   </select>
  </div>
  <div class="col-xs-2 form group">
   <button type="submit" class="btn btn-default">Filter</button>
   <button class="btn btn-default">Reset</button>
  </div>
 </div>
 </form>
 <p></p>
EOT
		$return .=<<EOT;
 <table class="table table-bordered">
  <thead>
    <tr>
     <th>Ranking</th>
	 <th>Details</th>
	 <th>Player</th>
	 <th>Realm</th>
	 <th>Season Stats</th>
	 <th>Rating</th>
    </tr>
   </thead>
   <tbody>
EOT
		foreach my $data (@players) {
			my $porcentaje = $self->winratio($data->{season_wins}, $data->{season_losses});
			my $faction = $data->{faction_id};
			$return .= <<EOT;
	 <tr>
	  <td><span class="text-warning">#$data->{ranking}</span></td>
	  <td><img src="/img/race_$data->{race_id}_$data->{gender_id}.jpg" class="img-rounded"> <img src="/img/class_$data->{class_id}.jpg" class="img-rounded"> <img src="/img/spec_$data->{spec_id}.jpg" class="img-rounded"></td>
	  <td><img src="/img/faction_$data->{faction_id}.jpg" class="img-rounded"><a class="bg-success" style="color: green" target="_blank" href="https://worldofwarcraft.com/en-gb/character/$data->{realm_slug}/$data->{name}">$data->{name}</a></td>
EOT
			if ($faction == 1) {
				$return .= <<EOT;
	  <td><span class="text-danger">$data->{realm_name}</span></td>
EOT
			}
			else {
				$return .= <<EOT;
	  <td><span class="text-primary">$data->{realm_name}</span></td>
EOT
			}
			$return .= <<EOT;
	  <td><span class="text-success">$data->{season_wins}</span> - <span class="text-danger">$data->{season_losses}</span> ($porcentaje%)</td>
	  <td><b>$data->{rating}</b></td>
	 </tr>
EOT
		}
		$return .= <<EOT;
   </tbody>
 </table>
EOT
	}
	$return .= pagination($self, $page, 'wow', $bracket, 'en', $total_entradas, $mode);
	$return .= <<EOT;
</div>
EOT
	return $return;
}

sub wow_mythics_es {
	my $self = shift;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/es/wow/mythics" class="btn btn-primary">Míticas</a>
  <a href="$url/es/wow/pvp" class="btn btn-primary">Jugador contra Jugador</a>
 </div>
 <h1>Rankings de Míticas World of Warcraft</h1> 
 <p>Rankings de Míticas World of Warcraft</p>
</div>
EOT
	return $return;
}

sub wow_mythics_en {
	my $self = shift;
    my $return = "";
	my $url = $self->param('url');
	
	$return .= <<EOT;
<div class="container-fluid">
 <div class="btn-group btn-group-justified">
  <a href="$url/en/wow/mythics" class="btn btn-primary">Mythics</a>
  <a href="$url/en/wow/pvp" class="btn btn-primary">Player vs Player</a>
 </div>
 <h1>Mythic Rankings of World of Warcraft</h1> 
 <p>Mythic Rankings of World of Warcraft</p>
</div>
EOT
	return $return;
}

sub starcraft_es {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Rankings de Starcraft</h1> 
 <p>Rankings de Starcraft</p>
</div>
EOT
	return $return;
}

sub starcraft_en {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Rankings of Starcraft</h1> 
 <p>Rankings of Starcraft</p>
</div>
EOT
	return $return;
}

sub diablo3_en {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Rankings of Diablo 3</h1> 
 <p>Rankings of Diablo 3</p>
</div>
EOT
	return $return;
}

sub diablo3_es {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Rankings de Diablo 3</h1> 
 <p>Rankings de Diablo 3</p>
</div>
EOT
	return $return;
}

sub contact_es {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Contacta con nosotros</h1> 
 <p>Formulario de contacto</p>
</div>
EOT
	return $return;
}
sub contact_en {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Contact</h1> 
 <p>Contact Form</p>
</div>
EOT
	return $return;
}

sub sitemap_es {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Mapa del sitio</h1> 
 <p>Mapa del sitio</p>
</div>
EOT
	return $return;
}

sub sitemap_en {
	my $self = shift;
    my $return = "";
	
	$return .= <<EOT;
<div class="container-fluid">
 <h1>Sitemap</h1> 
 <p>Sitemap</p>
</div>
EOT
	return $return;
}

sub footer_es {
	my $self = shift;
	my $return = "";
	my $url = $self->{'url'};
	$return .= <<EOT;
<div id="footer">
 <div class="container-fluid">
  <p>
   <a class="btn btn-default" role="button" href="$url/es/sitemap">Mapa del sitio</a>
   <a class="btn btn-default" role="button" href="$url/es/contact">Contacto</a>
   © Blizzard Rankings
  </p>
 </div>
</div>
</body>
</html>
EOT
	return $return;
}

sub footer_en {
	my $self = shift;
	my $return = "";
	my $url = $self->{'url'};
	$return .= <<EOT;
<div id="footer">
 <div class="container-fluid">
  <p>
   <a class="btn btn-default" role="button" href="$url/en/sitemap">Sitemap</a>
   <a class="btn btn-default" role="button" href="$url/en/contact">Contact</a>
   © Blizzard Rankings
  </p>
 </div>
</div>
</body>
</html>
EOT
	return $return;
}

sub pagination {
	my ($self, $page, $game, $bracket, $lang, $total_entradas, $mode) = @_;
	my $return;
	my $url = $self->param('url');
	$return .= <<EOT;
EOT
	$total_entradas = int($total_entradas / 100);

	$return .= <<EOT;
 <ul class="pagination">
EOT
	if (($page == 1) || (!$page)) {
		$return .= <<EOT;
  <li class="active"><a href="$url/$lang/$game/$mode/$bracket?page=1">1</a></li>
EOT
	}
	else {
		$return .= <<EOT;
  <li><a href="$url/$lang/$game/$mode/$bracket?page=1">1</a></li>
EOT
	}
	$return .= <<EOT;
  <li class="disabled"><a href="#">...</a></li>
EOT
	my $pagina_final = $page + 5;
	my $pagina_inicio = $page - 5;
	if ($pagina_inicio <= 0) {
		$pagina_inicio = 1;
		$pagina_final += 5;
	}
	elsif ($pagina_final >= $total_entradas) {
		$pagina_final = $pagina_final - 5;
	}
	
	for my $i ($pagina_inicio .. $pagina_final) {
		if (($i == 1) || ($i == $total_entradas)) {
		}
		elsif ($i > $total_entradas) {
			last;
		}
		else {
			if ($i == $page) {
				$return .= <<EOT
  <li class="active"><a href="$url/$lang/$game/$mode/$bracket?page=$i">$i</a></li>
EOT
			}
			else {
				$return .= <<EOT
  <li><a href="$url/$lang/$game/$mode/$bracket?page=$i">$i</a></li>
EOT
			}
		}
	}

	$return .= <<EOT;
  <li class="disabled"><a href="#">...</a></li>
EOT
	if ($page == $total_entradas) {
		$return .= <<EOT;
  <li class="active"><a href="$url/$lang/$game/$mode/$bracket?page=$total_entradas">$total_entradas</a></li>
EOT
	}
	else {
		$return .= <<EOT;
  <li><a href="$url/$lang/$game/$mode/$bracket?page=$total_entradas">$total_entradas</a></li>
EOT
	}
	$return .= <<EOT;
</ul>
EOT
	return $return;
}

1;