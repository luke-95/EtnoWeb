<!DOCTYPE html>
<html lang = "ro">
<head>
	<title>Home - EtnoWeb</title>
	<meta charset = "utf-8" />
	<meta name="keywords" content="monumente, etno, web, etnoweb"/>
	
	<link rel = "stylesheet" type = "text/css" href = "css/stylesheet.css"/>
</head>

<body>
<div class = "header_container">
	<div class="header_text_container">
		<p>EtnoWeb</p>
	</div>
</div>

<div class="menu_container">
	<ul>
		<li><a href="index.php" class="current">Home</a></li>
		<li><a href="gallery.php">Gallery</a></li>
		<li><a href="search.php">Search</a></li>		
		<li><a href="ghid_utilizare.html">Ghid</a></li>
		<li><a href="contact.php">Contact Us</a></li>
	</ul>       
</div>         

<div class="content">
    <div class="content_description">
        Overview
    </div>
    <div class="gallery">
		<?php 
		$conn = oci_connect("student", "STUDENT", "//localhost/XE");

        if (!$conn) {
         $m = oci_error();
         echo $m['Not connected.'], "\n";
         exit;
		} else {
			// echo '<h1>Connected</h1>';
		}
		$min = rand(1,700);
		$max = $min + 7;
		$categorie = 'student';
		
		$query = 'select * from TABLE(price_filter.getAttractionsByPriceRange(\'student\',1,9999,'.$min.', '.$max.'))';
		$stid = oci_parse($conn, $query);
		$r = oci_execute($stid);
		
		while ($row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC)) {
			$query_url = 'SELECT * FROM TABLE(p_gallery_info.get_info (\''.$row['ID_ANSAMBLU'].'\',\'ansamblu.id_ansamblu\'))'; 
			$stid_url = oci_parse($conn, $query_url);
			oci_execute($stid_url);
			$url_row = oci_fetch_array($stid_url, OCI_RETURN_NULLS+OCI_ASSOC);
			print '<div class="product_box margin_r40">
			<div class="thumb_wrapper">
				<a href="details.php?id='.$row['ID_ANSAMBLU'].'"><img src="'.($url_row['V_URL'] != null ? $url_row['V_URL'] : './images/gallery_placeholder.png').'" alt="image_ansamblu" /></a>
			</div>
				<h3>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3>
				<p>'.$row['DENUMIRE_IN_MUZEU'].'</p>
			</div>';
		}
		?>
        
    <div class = "cleaner"></div>
	</div>
</div> <!-- end of content -->

</body>
</html>