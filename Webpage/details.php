<!DOCTYPE html>
<html lang = "ro">
<head>
	<title>Home - EtnoWeb</title>
	<meta charset = "utf-8" />
	<meta name="keywords" content="monumente, etno, web, etnoweb"/>
	<link rel = "stylesheet" type = "text/css" href = "css/stylesheet.css"/>
	<link rel = "stylesheet" type = "text/css" href = "css/details.css"/>
</head>

<body>

<?php 
	$conn = oci_connect("student", "STUDENT", "//localhost/XE");

	if (!$conn) {
	 $m = oci_error();
	 echo $m['Not connected.'], "\n";
	 exit;
	}
	
	$id_ansamblu = $_GET['id'];
	
    $query = 'select * from TABLE(full_info.getDetailsById(\''.$id_ansamblu.'\'))';
	$image_query = 'select url_imagine from informatii where id_ansamblu = \''.$id_ansamblu.'\'';
	
    $stid = oci_parse($conn, $query);
	$stid2 = oci_parse($conn, $image_query);
	
    oci_execute($stid);
	oci_execute($stid2);
	
	oci_fetch($stid2);
	
	$row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC);
	$image = oci_result($stid2, 'URL_IMAGINE');
	
?>
	<div class = "header_container">
		<div class="header_text_container">
			<p>EtnoWeb</p>
		</div>
	</div>
	
    <div class="menu_container">
		<ul>
			<li><a href="index.php">Home</a></li>
			<li><a href="gallery.php">Gallery</a></li>
			<li><a href="search.php">Search</a></li>
			<li><a href="ghid_utilizare.html">Ghid</a></li>
			<li><a href="contact.php">Contact Us</a></li>
		</ul>       
	</div> 
	
	<div class="content">
		
		<div class = "details_container">	
			<div class = "details_title">
			<?php 
				echo '<h2>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_IN_MUZEU'] != null ? $row['DENUMIRE_IN_MUZEU'] : 'Fara nume' ))
						.'</h2>';
			?>
			
			</div>
			
			<div class = "details_image_container">
			<?php 
					echo '<a href = '.$image.'><img src = '.($image != null ? $image : 'images/gallery_placeholder.png') .' alt="image_ansamblu" /></a>';
			?>
			</div>
			<div class = "details_textbox">
			<?php
			// Create connection to Oracle
			
			if (!$row){
				echo "No results found.";
			} else {
				echo '<p><span>ID ansamblu: </span>'.$row['ID_ANSAMBLU'].'</p>';
				echo '<p><span>Pret bilet: </span>'.($row['PRET_BILET'] ? $row['PRET_BILET'].' lei' : 'Gratuit').'</p>';
				echo '<p><span>Nume muzeu: </span>'.($row['NUME_MUZEU'] ? $row['NUME_MUZEU'] : 'Necunoscut').'</p>';
				echo '<p><span>Denumire la origine: </span>'.($row['DENUMIRE_LA_ORIGINE'] ? $row['DENUMIRE_LA_ORIGINE'] : 'Necunoscuta').'</p>';
				echo '<p><span>Zona de provenienta: </span>'.($row['ZONA_PROV'] ? $row['ZONA_PROV'] : 'Necunoscuta').'</p>';
				echo '<p><span>Localitatea de provenienta: </span>'.($row['LOCALITATE_PROV'] ? $row['LOCALITATE_PROV'] : 'Necunoscuta').'</p>';
				echo '<p><span>Datarea: </span>'.($row['DATAREA'] ? $row['DATAREA'] : 'Necunoscuta').'</p>';
				echo '<p><span>Etnie: </span>'.($row['ETNIA'] ? $row['ETNIA'] : 'Necunoscuta').'</p>';		
				echo ($row['IMPREJMUIRI'] ? '<p><span>Imprejmuiri: </span>'.$row['IMPREJMUIRI'].'</p>' : '');
				echo ($row['DESCRIERE'] ? '<p><span>Descriere: </span>'.$row['DESCRIERE'].'</p>' : '');
				echo ($row['BIBLIOGRAFIE'] ? '<p><span>Bibliografie: </span>'.$row['BIBLIOGRAFIE'].'</p>' : '');
				//echo $row['DENUMIRE_ANSAMBLU'];
			}
			?>
			<div class="buttons">
			
				<a href="https://twitter.com/share" class="twitter-share-button" data-url="http://google.com" data-text="Etnoweb" data-hashtags="EtnoWeb">Tweet</a>
				<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script", "twitter-wjs");</script>
			
			
			
				<script>(function(d, s, id){var js, fjs = d.getElementsByTagName(s)[0];if (d.getElementById(id)) return;js = d.createElement(s); js.id = id;js.src = "//connect.facebook.net/ro_RO/sdk.js#xfbml=1&version=v2.6";fjs.parentNode.insertBefore(js, fjs);}(document, 'script', 'facebook-jssdk'));</script>
			
			<div class="fb-share-button" data-href="https://localhost/etnoweb/Webpage/branch/gallery.php" data-layout="button_count" data-mobile-iframe="true"></div>
			</div>
			</div>
		</div>
		
		<div class="cleaner"></div>
	</div>	<!-- end of content -->
</body>
</html>