meggageeditor={}

meggageeditor.htmlContent = [[
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="robots" content="noindex, nofollow">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<title></title>
	<script src="http://cdn.ckeditor.com/4.5.7/standard-all/ckeditor.js"></script>
	<script type="text/javascript" src="/jquery/charactercount.js"></script>
	<link href="path_to_css/apprise-v2.min.css" rel="stylesheet" type="text/css" />

<script src="path_to_jquery"></script>
<script src="path_to_scripts/apprise-v2.min.js"></script>
<script type="text/javascript" src="http://www.adblockdetector.com/script.php"></script>
<script src="https://cdn.rawgit.com/t4t5/sweetalert/master/dist/sweetalert.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/t4t5/sweetalert/master/dist/sweetalert.css">
</head>

<body>

			<form id="sumbit" type="submit" align="center" >


			<textarea cols="80" id="UnitGoals" name="UnitGoals" rows="10">	

			</textarea>


	</form>


	<script>


  CKEDITOR.replace( 'UnitGoals', {

    toolbar: [
    { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ , 'Save', 'NewPage', 'Preview', 'Print', '-', 'Templates' ] },
    { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },

    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl', 'Language' ]},
    { name: 'links', items: [ 'Link', 'Unlink' ] },
    { name: 'insert', items: [ 'Image' ] },
 
    { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
    { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
]
});




		function get_action(value) {

			var ckvalue = encodeURIComponent(CKEDITOR.instances.UnitGoals.getData());

			var htmldata = CKEDITOR.instances.UnitGoals.document.getBody().getText()

			//alert(htmldata.length)
			if(htmldata.length > 1 )

			{

				var texttemp="corona:close" + value + ckvalue;
	 			window.location.href = texttemp; 
	 			//window.location.href = ""; 

	 			return false;

			}
			else
			{

				//sweetAlert("Please enter the long text");
		
			}


       		
		}

    CKEDITOR.instances.UnitGoals.setData(decodeURIComponent(

]]


	meggageeditor.buttonHtml = [[
	
	

<div style="text-align:center;">
  <Button onclick=get_action("Schedule") align="left" name="data" type="button" width="58" height="48" style=" height:35px; background-color:#e92568; padding:10px; color:#fff; font-size:15px; border:none;margin:10px 5px"> Schedule </Button>
  <Button onclick=get_action("Send") align="center" name="data" type="button" width="58" height="48" style=" height:35px; background-color:#e92568; padding:10px; color:#fff; font-size:15px; border:none; margin:10px 5px"> Send </Button>
  <Button onclick=get_action("Draft") align="right" name="data" type="button" width="58" height="48" style=" height:35px; background-color:#e92568; padding:10px; color:#fff; font-size:15px; border:none; margin:10px 5px"> Draft </Button>

</div>

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

	meggageeditor.endHtml = [[.replace(/\+/g, '%20')));  


	</script>


	

	<!-- <button id="submit" onclick="myFunction()">Submit</button> -->
</body>

</html>

]]