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
	
</head>

<body>

	<textarea cols="80" id="UnitGoals" name="UnitGoals" rows="10">		
	</textarea>



	<script>


		CKEDITOR.replace( 'UnitGoals', {
			fullPage: true,
			extraPlugins: 'docprops',
			allowedContent: true,
			height: 260,
			htmlEncodeOutput: false,
			width: 330
		} );



			function get_action(form) {


			var ckvalue = encodeURIComponent(CKEDITOR.instances.UnitGoals.getData());

			 var texttemp="corona:close"+ckvalue


			 form.action = texttemp
       		
			}



function readTextFile(file)
{
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", file, false);
    rawFile.onreadystatechange = function ()
    {
        if(rawFile.readyState === 4)
        {
            if(rawFile.status === 200 || rawFile.status == 0)
            {
                var allText = rawFile.responseText;
                 allText = decodeURIComponent((allText).replace(/\+/g, '%20'));
                CKEDITOR.instances.UnitGoals.setData(allText);  
            }
        }
    }
     rawFile.send(null);
}

readTextFile("sample.txt");

		 

	</script>



	<form onsubmit="get_action(this);">
        <input type="submit" style="background-color:#e92568; padding:5px; color:#fff; font-weight:600; border:none; margin:10px 110px;">
	</form>

	<!-- <button id="submit" onclick="myFunction()">Submit</button> -->
</body>

</html>
]]