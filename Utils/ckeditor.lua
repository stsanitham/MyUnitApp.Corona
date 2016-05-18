ckeditor={}

ckeditor.htmlContent = [[
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="robots" content="noindex, nofollow">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<title></title>
	<script src="http://cdn.ckeditor.com/4.5.7/standard-all/ckeditor.js"></script>
	<link href="path_to_css/apprise-v2.min.css" rel="stylesheet" type="text/css" />

<script src="path_to_jquery"></script>
<script src="path_to_scripts/apprise-v2.min.js"></script>
<script type="text/javascript" src="http://www.adblockdetector.com/script.php"></script>
<script src="https://cdn.rawgit.com/t4t5/sweetalert/master/dist/sweetalert.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/t4t5/sweetalert/master/dist/sweetalert.css">
</head>

<body>



	<br>

		<form id="sumbit" type="submit" align="center" >


			<textarea cols="80" id="UnitGoals" name="UnitGoals" rows="10">	

			</textarea>


	</form>


	<script>


		CKEDITOR.replace( 'UnitGoals', {
			fullPage: true,
			extraPlugins: 'docprops',
			allowedContent: true,
			htmlEncodeOutput: true,
		} );



		function get_action(form) {


			var ckvalue = encodeURIComponent(CKEDITOR.instances.UnitGoals.getData());


			var htmldata = CKEDITOR.instances.UnitGoals.document.getBody().getText()


			//alert(htmldata.length)
			if(htmldata.length > 1 )
			{

						var texttemp="corona:close"+ckvalue;
			 			window.location.href = texttemp; 

			}else{

				
				sweetAlert("Please enter Unit Goals");
		
			}
       		
		}


    CKEDITOR.instances.UnitGoals.setData(decodeURIComponent(

]]


ckeditor.buttonHtml = [[<Button onclick=get_action(this) align="center" name="data" type="button" width="58" height="48" style="width=200px; height:35px; background-color:#e92568; padding:10px; color:#fff; font-size:15px; border:none; margin:10px 110px;"> Submit </Button>

<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p><br></p>

]]
	ckeditor.endHtml = [[.replace(/\+/g, '%20')));  


	</script>



	<!-- <button id="submit" onclick="myFunction()">Submit</button> -->
</body>

</html>

]]