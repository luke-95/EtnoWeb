<!DOCTYPE html>
<html lang = "ro">
<head>
	<title>Search - EtnoWeb</title>
	<meta charset = "utf-8" />	
	<meta name="keywords" content="monumente, etno, web, etnoweb"/>
	
	<link rel = "stylesheet" type = "text/css" href = "css/stylesheet.css"/>
	<link rel = "stylesheet" type = "text/css" href = "css/search_page.css"/>
	<link rel = "stylesheet" type = "text/css" media = "only screen and (min-width:300px) and (max-width:599px)" href="css/stylesheet_300.css"/>
	
</head>
<body>
	<?php 
		// Create connection to Oracle
		$conn = oci_connect("student", "STUDENT", "//localhost/XE");

		if (!$conn) {
			$m = oci_error();
			echo $m['Not connected.'], "\n";
			exit;
		}
		else {
			//echo '<h1>Connected</h1>';
		}
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
			<li><a href="search.php" class="current">Search</a></li>			
			<li><a href="ghid_utilizare.html">Ghid</a></li>
			<li><a href="contact.php">Contact Us</a></li>
		</ul>       
	</div>         

	<div class="content">
	<form action="search.php" method="post">
		<div class="left_filter">	
			
				<div class="radio_input_container">
					<h1>Cauta dupa:</h1>
					<label class = "block"><input type="checkbox" name="filtru1" value="nume_ansamblu"> nume ansamblu</label>
					<label class = "block"><input type="checkbox" name="filtru2" value="nume_muzeu"> nume muzeu</label>
					<label class = "block"><input type="checkbox" name="filtru3" value="zona"> zona</label>
					<label class = "block"><input type="checkbox" name="filtru4" value="localitate"> localitate</label>
					<label class = "block"><input type="checkbox" name="filtru5" value="etnie"> etnie</label>
					<label class = "block"><input type="checkbox" name="filtru6" value="datare"> datare</label>
				</div>
			
				<div class="radio_input_container">
					<h1>Filtreaza pret dupa:</h1>
					<div class="price_value_filter_container">
					<h2>valoare:</h2>			
					<label class = "block"><input type="radio" name="filtruPretValoare" value="0_5"> 0 - 5 RON</label>
					<label class = "block"><input type="radio" name="filtruPretValoare" value="5_10"> 5 - 10 RON</label>
					<label class = "block"><input type="radio" name="filtruPretValoare" value="10_30"> 10 - 30 RON</label>
					<label class = "block"><input type="radio" name="filtruPretValoare" value="30_100"> 30 - 100 RON</label>
					</div>
						
					<div class="price_range_filter_container">
						<label class = "block"><input type="radio" name="filtruPretValoare" value="other"> other:</label>					
						<label class = "block"><input type="number" name="p_min"/>(min)</label>	
						<label class = "block"><input type="number" name="p_max"/>(max)</label>
					</div>
				</div>
				<div class="radio_input_container">
					<h2>categorie:</h2>	
						<label class = "block"><input type="radio" name="filtruPretCategorie" value="angajat"> salariat</label>	
						<label class = "block"><input type="radio" name="filtruPretCategorie" value="student"> student</label>	
						<label class = "block"><input type="radio" name="filtruPretCategorie" value="elev"> elev</label>	
				</div>			
		</div> 	
		
		<div class = "search_box_container">
			<div class = "search_input_container">
				<p>Cuvinte cheie:</p>
				<input id="i_cuv_cheie" type="text" name="fname"/>
				<button type="submit" name="formSubmit" value="Cauta">Cauta</button>
			</div>
	
		
			<div class = "search_results_container">		
			<?php		
			// include autoloader
							require_once 'dompdf/autoload.inc.php';
							// reference the Dompdf namespace
							use Dompdf\Dompdf;
			$html_code_start = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
			<head>
			<style>
			.header_container{
				width:100%;
				height:120px;
				background: url("../images/header_background2.jpg") repeat-x top;
			}
			.header_text_container{
				width:300px;
				text-align:center;	
				padding-top:27px;
				margin: 0 auto;
			}
			.header_text_container p{
				font-size:65px;
				font-family:sans-serif;
				font-weight:bold;
				color:white;
				margin:0px;
				background-color:#a00000;
			}
			.product_box {
				float: left;
				display: inline-block;
				background:#fff;
				width:19%;
				min-width:200px;
				height:240px;
				margin:1%;
				padding:2%;
				padding-bottom:4%;
				box-shadow:1px 1px 3px rgba(0,0,0,.2);
			}
			.thumb_wrapper img {
				width: 100%;
				height:150px;
				margin-bottom: 5%;
			}
			.product_box h3 {
				clear: both;
				padding: 0px;
				margin: 0px;
				font-size: 1.5em;
				color: #BD1929;
			}

			.product_box p{
				font-size:1.4em;
			}
			.url_text{
				font-size:16px;
				color:blue;
				text-decoration: underline;
			}
			.titlu_ansamblu{
				color:#a00;
				font-size:16px;
			}
			.descriere_ansamblu{
				font-size:14px;
			}
			</style>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title>EtnoWeb</title>
			<meta name="keywords" content="monumente, etno, web, etnoweb" />
			<link href="css/stylesheet.css" rel="stylesheet" type="text/css" />
			</head>
			<body>

			<div class = "header_container">
				<div class="header_text_container">
					<p>EtnoWeb</p>
				</div>
			</div>


			<div class="content">

					<div class = "search_results_container">';			
			file_put_contents('search_results.html', $html_code_start);

			$cautare['nume_ansamblu']='denumirea_ansamblului';
			$cautare['nume_muzeu']='nume';
			$cautare['zona']='zona_provenienta';
			$cautare['localitate']='localitate_provenienta';
			$cautare['etnie']='etnia';
			$cautare['datare']='datarea';
			$pdf_body ='';
			$json_body = '';
			// Take data from form and generate content
			if(isset($_POST['formSubmit']))
			{   
				session_start();
				$_SESSION['cautat'] = 1;
				if($_POST['formSubmit'] == "Cauta") 
				{
					$i=0;
					if(isset($_POST['filtru1']))
					{
						$filtru[$i]=$_POST['filtru1'];
						$i++;
					}
					if(isset($_POST['filtru2']))
					{
						$filtru[$i]=$_POST['filtru2'];
						$i++;
					}
					if(isset($_POST['filtru3']))
					{
						$filtru[$i]=$_POST['filtru3'];
						$i++;
					}
					if(isset($_POST['filtru4']))
					{
						$filtru[$i]=$_POST['filtru4'];
						$i++;
					}
					if(isset($_POST['filtru5']))
					{
						$filtru[$i]=$_POST['filtru5'];
						$i++;
					}
					if(isset($_POST['filtru6']))
					{
						$filtru[$i]=$_POST['filtru6'];
						$i++;
					}
					if(isset($_POST['filtru7']))
					{
						$filtru[$i]=$_POST['filtru7'];
						$i++;
					}
					if(isset($filtru))
					{
						$filtruSize=count($filtru);
					}
					else 
						$filtruSize=0;					
					if(isset($_POST['filtruPretValoare']))
					{
						if($_POST['filtruPretValoare']=="other")
						{
							$pretMin=$_POST['p_min'];
							$pretMax=$_POST['p_max'];	
						}
						else
						{
							$pret=explode("_", $_POST['filtruPretValoare']);
							$pretMin=$pret[0];
							$pretMax=$pret[1];
						}
					}
					else 
					{
						$pretMin=null;
						$pretMax=null;
					}
					if(isset($_POST['filtruPretCategorie']))
					{
						$categorie=$_POST['filtruPretCategorie'];
					}
					else
					{
						$categorie=null;
					}					
					$text = $_POST['fname'];					
					$words = explode(" ", $text);
					$size=count($words);

					if($size!=0 && $text!=null)
					{
						if($filtruSize!=0)
						{
							if($pretMin!=null && $pretMax!=null)
							{
								if($categorie!=null)
								{
									$emptyQuery=true;
									print '<div class = "download">
												<a  href="search_results.html" download="search_results.html" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as HTML</a>
												<a  href="search_resultsPDF.pdf" download="search_resultsPDF.pdf" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as PDF</a>
												<a  href="search_resultsJSON.json" download="search_resultsJSON.json" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as JSON</a>
												</div>';
									for($i=0;$i<$filtruSize;$i++)
									{
										$query = 'select * from TABLE(price_filter.getAttractionsByWordAndPrice(\''.$words[0].'\', \''.$cautare[$filtru[$i]].'\','.$pretMin.','.$pretMax.',\''.$categorie.'\', 1, 200))';
										$stid = oci_parse($conn, $query);
										oci_execute($stid);
										while ($row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC)) {
											$emptyQuery=false;
											$query_url = 'SELECT * FROM TABLE(p_gallery_info.get_info (\''.$row['ID_ANSAMBLU'].'\',\'ansamblu.id_ansamblu\'))'; 
											$stid_url = oci_parse($conn, $query_url);
											oci_execute($stid_url);
											$url_row = oci_fetch_array($stid_url, OCI_RETURN_NULLS+OCI_ASSOC);
											$html_code_body = '<div class="product_box">
											<div class="thumb_wrapper">
												<a href="details.php?id='.$row['ID_ANSAMBLU'].'"><img src="'.($url_row['V_URL'] != null ? $url_row['V_URL'] : './images/gallery_placeholder.png').'" alt="image_ansamblu" /></a>
											</div>
												<h3>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3>
												<p>'.$row['DENUMIRE_IN_MUZEU'].'</p>
											</div>';
											print $html_code_body;
									
											file_put_contents('search_results.html', $html_code_body, FILE_APPEND);
											
											$pdf_body = $pdf_body.'<div><p class="url_text">'.$url_row['V_URL'].'</p>
												<p class="titlu_ansamblu">'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</p>
												<p class="descriere_ansamblu">'.$row['DENUMIRE_IN_MUZEU'].'</p></div>';
											$json_body = $json_body.'{"url_imagine":"'.$url_row['V_URL'].'","titlu_ansamblu":"'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'", "descriere_ansamblu":"'.$row['DENUMIRE_IN_MUZEU'].'"},';
										}
									}									
									if ($emptyQuery==true)
									{
										print '<h3>Interogarea nu are rezultate</h3>';
									}
								}
							}
							else if($categorie==null)
							{
								$emptyQuery=true;
								print '<div class = "download">
											<a  href="search_results.html" download="search_results.html" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as HTML</a>
											<a  href="search_resultsPDF.pdf" download="search_resultsPDF.pdf" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as PDF</a>
											<a  href="search_resultsJSON.json" download="search_resultsJSON.json" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as JSON</a>
											</div>';
								for($i=0;$i<$filtruSize;$i++)
								{
									$query = 'select * from TABLE(full_info.getFullInfoByValueAndColumn(\''.$words[0].'\', \''.$cautare[$filtru[$i]].'\', 1, 200))';
									$stid = oci_parse($conn, $query);
									oci_execute($stid);
									while ($row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC)) {
										$emptyQuery=false;
										$query_url = 'SELECT * FROM TABLE(p_gallery_info.get_info (\''.$row['ID_ANSAMBLU'].'\',\'ansamblu.id_ansamblu\'))'; 
										$stid_url = oci_parse($conn, $query_url);
										oci_execute($stid_url);
										$url_row = oci_fetch_array($stid_url, OCI_RETURN_NULLS+OCI_ASSOC);
										$html_code_body = '<div class="product_box margin_r40"><div class="thumb_wrapper"> <a href="details.php?id='.$row['ID_ANSAMBLU'].'"><img src="'.($url_row['V_URL'] != null ? $url_row['V_URL'] : './images/gallery_placeholder.png').'" alt="image_ansamblu" /></a></div><h3>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3><p>'.$row['DENUMIRE_IN_MUZEU'].'</p> </div>';
										print $html_code_body;
										file_put_contents('search_results.html', $html_code_body, FILE_APPEND);
										$pdf_body = $pdf_body.'<div class="thumb_wrapper">'.$url_row['V_URL'].'</div><h3 text-indent: 5em>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3><p>'.$row['DENUMIRE_IN_MUZEU'].'</p>';
										$json_body = $json_body.'{"url_imagine":"'.$url_row['V_URL'].'","titlu_ansamblu":"'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'", "descriere_ansamblu":"'.$row['DENUMIRE_IN_MUZEU'].'"},';
									}
								}
								if ($emptyQuery==true)
								{
									print '<h3>Interogarea nu are rezultate</h3>';
								}
							}
						}
					}					
					if($size==0 || $filtruSize==0)
					{
						if($pretMin!=null && $pretMax!=null && $categorie!=null)
						{
							$emptyQuery=true;
								
							$query = 'select * from TABLE(price_filter.getAttractionsByPriceRange(\''.$categorie.'\','.$pretMin.','.$pretMax.', 1, 200))';
									
							$stid = oci_parse($conn, $query);
							oci_execute($stid);
							print '<div class = "download">
												<a  href="search_results.html" download="search_results.html" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as HTML</a>
												<a  href="search_resultsPDF.pdf" download="search_resultsPDF.pdf" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as PDF</a>
												<a  href="search_resultsJSON.json" download="search_resultsJSON.json" style="color: #BD129; font-size: 17px; text-decoration: underline">Download as JSON</a>
												</div>';
							while ($row = oci_fetch_array($stid, OCI_RETURN_NULLS+OCI_ASSOC)) 
							{
								$emptyQuery=false;
								$query_url = 'SELECT * FROM TABLE(p_gallery_info.get_info (\''.$row['ID_ANSAMBLU'].'\',\'ansamblu.id_ansamblu\'))'; 
								$stid_url = oci_parse($conn, $query_url);
								oci_execute($stid_url);
								$url_row = oci_fetch_array($stid_url, OCI_RETURN_NULLS+OCI_ASSOC);
								$html_code_body = '<div class="product_box margin_r40">
								<div class="thumb_wrapper">
									<a href="details.php?id='.$row['ID_ANSAMBLU'].'"><img src="'.($url_row['V_URL'] != null ? $url_row['V_URL'] : './images/gallery_placeholder.png').'" alt="image_ansamblu" /></a>
								</div>
									<h3 text-indent: 5em>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3>
									<p>'.$row['DENUMIRE_IN_MUZEU'].'</p>
								</div>';
								print $html_code_body;
								
								file_put_contents('search_results.html', $html_code_body, FILE_APPEND);
								
								$pdf_body = $pdf_body.'<div class="thumb_wrapper">'.$url_row['V_URL'].
								'</div>
									<h3>'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'</h3>
									<p>'.$row['DENUMIRE_IN_MUZEU'].'</p>';
								$json_body = $json_body.'{"url_imagine":"'.$url_row['V_URL'].'","titlu_ansamblu":"'.($row['DENUMIRE_ANSAMBLU'] != null ? $row['DENUMIRE_ANSAMBLU'] : ($row['DENUMIRE_LA_ORIGINE'] != null ? $row['DENUMIRE_LA_ORIGINE'] : 'Fara nume' )).'", "descriere_ansamblu":"'.$row['DENUMIRE_IN_MUZEU'].'"},';
							}									
							if ($emptyQuery==true)
							{
								print '<h3>Interogarea nu are rezultate</h3>';
							}							
						}
						else
						{
							print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';
						}
					}
					if($text==null && $pretMin==null && $pretMax==null && $categorie==null && $filtruSize!=0)
					{
						print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';						
					}
					if($text==null && $pretMin!=null && $pretMax!=null && $filtruSize!=0)
					{
						print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';						
					}
					if($text==null && $pretMin==null && $pretMax==null && $categorie!=null && $filtruSize!=0)
					{
						print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';						
					}
					if($text!=null && $pretMin==null && $pretMax==null && $categorie!=null && $filtruSize!=0)
					{
						print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';						
					}
					if($text!=null && $pretMin!=null && $pretMax!=null && $categorie==null && $filtruSize!=0)
					{
						print '<h3>SELECTATI PERECHI [CUVANT CHEIE - CAUTA DUPA], [FILTRARE PRET DUPA VALOARE - CATEGORIE] SAU TOATE CAMPURILE </h3>';						
					}					
				}
			}
			
			$html_code_end = '	</div>	
			<div class="cleaner"></div>
			</div>
			<!-- end of content -->

			</body>
			</html>';
			file_put_contents('search_results.html', $html_code_end, FILE_APPEND);
			
			
			
			function pdf_create($html, $filename='', $stream=TRUE) 
			{
				$savein = '';
				$dompdf = new DOMPDF();
				$dompdf->load_html($html);
				$dompdf->setPaper('A4', 'landscape');
				
				$dompdf->render();
				$pdf = $dompdf->output();      // gets the PDF as a string

				file_put_contents($savein.str_replace("/","-",$filename), $pdf);    // save the pdf file on server
				unset($html);
				unset($dompdf); 

			}
			
			if (isset($_SESSION['cautat']))
			{				
				//$htmll = $html_code_start.'<p>ccdcdc</p>'.$html_code_end;
				$htmll = $html_code_start.$pdf_body.$html_code_end;
				$json_final = '['.rtrim($json_body, ",").']';
				$filename = 'search_resultsPDF.pdf';
				pdf_create($htmll, $filename, TRUE);
				$json_file = fopen("search_resultsJSON.json", "w");
				fwrite($json_file, $json_final);
				fclose($json_file);
			}
			?>
			</div> <!-- end of search_results_container -->
		</div> <!-- end of search_box_container -->
	</form>
		<div class="cleaner"></div>
	</div>	<!-- end of content -->
</body>
</html>