<!DOCTYPE html>
<html lang="ro">
<head>
	<title>Gallery - EtnoWeb</title>
	<meta charset = "utf-8" />
	<meta name="keywords" content="monumente, etno, web, etnoweb"/>
	
	<link rel = "stylesheet" type = "text/css" href = "css/stylesheet.css"/>
	<link rel = "stylesheet" type = "text/css" href = "css/gallery_pagination.css"/>
</head>

<body>

	<div class = "header_container">
		<div class="header_text_container">
			<p>EtnoWeb</p>
		</div>
	</div>

	<div class="menu_container">
		<ul>
			<li><a href="index.php">Home</a></li>
			<li><a href="gallery.php" class="current">Gallery</a></li>
			<li><a href="search.php">Search</a></li>
			<li><a href="ghid_utilizare.html">Ghid</a></li>
			<li><a href="contact.php">Contact Us</a></li>
		</ul>       
	</div>   

	<div class="content">
    <?php
		if (isset($_GET['page'])){
			$page_number = $_GET['page'];
			if ($page_number < 1){
				$page_number = 1;
			}
		} else {
			$page_number = 1;
		}
		
		$min= 20 * ($page_number - 1) + 1;
		$max = 20 * $page_number;

		
		$pret_min = 1;
		$pret_max = 9999;
		$categorie = 'student';
	?>
    <div class="gallery">
        <?php

    // Create connection to Oracle
        $conn = oci_connect("student", "STUDENT", "//localhost/XE");

        if (!$conn) {
         $m = oci_error();
         echo $m['Not connected.'], "\n";
         exit;
     }
     else {
        // echo '<h1>Connected</h1>';
    }
	
    $query = 'select * from TABLE(price_filter.getAttractionsByPriceRange(\''.$categorie.'\','.$pret_min.','.$pret_max.','.$min.', '.$max.'))';

    $stid = oci_parse($conn, $query);
    $r = oci_execute($stid);

    // Fetch each row in an associative array
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
	$q = "SELECT count_results.countResultsForAllInGallery() as x FROM dual";
	$stid = oci_parse($conn, $q);
    $r = oci_execute($stid);
	$row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC);
	$maxpage=ceil($row['X']/20);
	?>
	</div>
	<div class = "cleaner"></div>
	
	<div class = "gallery_pagination_container">
	<?php
	if($page_number<$maxpage-2){
		if ($page_number == 1){
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus3"> < Pagina anterioara 33 </p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus2"> <22</p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus1"> <22</p>';
		}
		
		else if ($page_number == 2){
			echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_prev_button"> < Pagina anterioara</p></a>';	
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus1"> <33 </p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus2"> <22 </p>';
			echo '<a href="gallery.php?page=1"><p class = "gallery_cur_page_minus3">1</p></a>';
		}
		else if ($page_number == 3){
			echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_prev_button"> < Pagina anterioara</p></a>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_minus3"> <33 </p>';
			echo '<a href="gallery.php?page=1"><p class = "gallery_cur_page_minus2">1</p></a>';
			echo '<a href="gallery.php?page=2"><p class = "gallery_cur_page_minus1">2</p></a>';
		}

		else {
			echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_prev_button"> < Pagina anterioara</p></a>';
			echo '<a href="gallery.php?page='.($page_number - 3).'"><p class = "gallery_cur_page_minus3">'.($page_number - 3).'</p></a>';
			echo '<a href="gallery.php?page='.($page_number - 2).'"><p class = "gallery_cur_page_minus2">'.($page_number - 2).'</p></a>';
			echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_cur_page_minus1">'.($page_number - 1).'</p></a>';
		}
		echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_next_button">Pagina urmatoare ></p></a>';
		echo '<a href="gallery.php?page='.($page_number + 3).'"><p class = "gallery_cur_page_plus3">'.($page_number + 3).'</p></a>';
		echo '<a href="gallery.php?page='.($page_number + 2).'"><p class = "gallery_cur_page_plus2">'.($page_number + 2).'</p></a>';
		echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_cur_page_plus1">'.($page_number + 1).'</p></a>';
		echo '<p class = "gallery_cur_page">'.$page_number.'</p>';
	}
	else{
		echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_prev_button">< Pagina anterioara</p></a>';
		echo '<a href="gallery.php?page='.($page_number - 3).'"><p class = "gallery_cur_page_minus3">'.($page_number - 3).'</p></a>';
		echo '<a href="gallery.php?page='.($page_number - 2).'"><p class = "gallery_cur_page_minus2">'.($page_number - 2).'</p></a>';
		echo '<a href="gallery.php?page='.($page_number - 1).'"><p class = "gallery_cur_page_minus1">'.($page_number - 1).'</p></a>';
		
		if ($page_number == $maxpage){
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus3"> < 33 Pagina urmatoare ></p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus2"> <22</p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus1"> <22</p>';
			
		}
		else if ($page_number == $maxpage-1){
			echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_next_button">Pagina urmatoare ></p></a>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus3"> <33 </p>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus2"> <22 </p>';
			echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_cur_page_plus1">'.($page_number + 1).'</p></a>';
				
		}
		else if ($page_number == $maxpage-2){
			echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_next_button">Pagina urmatoare ></p></a>';
			echo '<p style="visibility:hidden;" class = "gallery_cur_page_plus3"> <33 </p>';
			echo '<a href="gallery.php?page='.($page_number + 2).'"><p class = "gallery_cur_page_plus2">'.($page_number + 2).'</p></a>';
			echo '<a href="gallery.php?page='.($page_number + 1).'"><p class = "gallery_cur_page_plus1">'.($page_number + 1).'</p></a>';
			
			
		}
		
		echo '<p class = "gallery_cur_page">'.$page_number.'</p>';
	}
	?>
	</div> <!-- end of gallery_pagination_container -->
	<div class = "cleaner"></div>
</div>  <!-- end of content -->
</body>
</html>