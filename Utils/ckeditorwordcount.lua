
ckeditorwordcount={}


ckeditorwordcount.htmlContent = [[

<!DOCTYPE html>

<html>
<head>
	<meta charset="utf-8">
        <title>WordCount &mdash; CKEditor Sample</title>
        <script src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
        <script src="../../../ckeditor.js"></script>
	<link href="../../../samples/sample.css" rel="stylesheet">
	<meta name="ckeditor-sample-name" content="WordCount plugin">
	<meta name="ckeditor-sample-group" content="Plugins">
    <meta name="ckeditor-sample-description" content="Counts the words an shows the word count in the footer of the editor.">
	<meta name="ckeditor-sample-isnew" content="1">
	<script>
		CKEDITOR.disableAutoInline = true;
	</script>
</head>
<body>

CKEDITOR.replace( '<em>textarea_id</em>', {
	<strong>extraPlugins: 'wordcount', 
                maxWordCount: 4,
	        maxCharCount: 1000,
                // optional events
	        paragraphsCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationparagraphs").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - paragraphs").show();
	        },
	        wordCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationword").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - word").show();
	        },
	        charCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationchar").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - char").show();
	        },
	        charCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationchar").css("background-color", "white").css("color", "black").hide();
	        },
	        paragraphsCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationparagraphs").css("background-color", "white").css("color", "black").hide();
	        },
	        wordCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationword").css("background-color", "white").css("color", "black").hide();
	        }</strong>
} );


<textarea cols="80" id="editor1" name="editor1" rows="10">
    This is some <strong>sample text</strong>. You are using <a href="http://ckeditor.com/">CKEditor</a>.
</textarea>
    <div id="informationchar"></div>
    <div id="informationword"></div>
    <div id="informationparagraphs"></div>
	<script>
	    CKEDITOR.replace('editor1', {
	        extraPlugins: 'wordcount',
	        wordcount: {
	            showWordCount: true, 
                showCharCount: true,
	            maxWordCount: 4,
	            maxCharCount: 1000,
	            paragraphsCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationparagraphs").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - paragraphs").show();
	            },
	            wordCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationword").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - word").show();
	            },
	            charCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationchar").css("background-color", "crimson").css("color", "white").text(currentLength + "/" + maxLength + " - char").show();
	            },
	            charCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationchar").css("background-color", "white").css("color", "black").hide();
	            },
	            paragraphsCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationparagraphs").css("background-color", "white").css("color", "black").hide();
	            },
	            wordCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
	                $("#informationword").css("background-color", "white").css("color", "black").hide();
	            }
	        }
	    });
	</script>

</body>
</html>

]]