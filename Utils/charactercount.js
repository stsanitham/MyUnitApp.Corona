$(document).ready(function(){

 var editAbstract=CKEDITOR.instances.UnitGoals;

 editAbstract.on("key",function(e) {      
   
   //    var maxLength=e.editor.config.maxlength;
   
   //    e.editor.document.on("keyup",function() {KeyUp(e.editor,maxLength,"letterCount");});
   //    e.editor.document.on("paste",function() {KeyUp(e.editor,maxLength,"letterCount");});
   //    e.editor.document.on("blur",function() {KeyUp(e.editor,maxLength,"letterCount");});
   // },editAbstract.element.$);


var charCount = document.getElementById("charCount");

CKEDITOR.instances.UnitGoals.on("key", function (event)
{
  charCount.innerHTML = CKEDITOR.instances.UnitGoals.getData().length;

  var txt= CKEDITOR.instances.UnitGoals.getData();
  alert(txt);
});

}

   //function to handle the count check
   function KeyUp(editorID,maxLimit,infoID) {

      //If you want it to count all html code then just remove everything from and after '.replace...'
      var text=CKEDITOR.instances.UnitGoals.getData().replace(/<("[^"]*"|'[^']*'|[^'">])*>/gi, '').replace(/^\s+|\s+$/g, '');
      $("#"+infoID).text(text.length);

      if(text.length>maxLimit) {   
       alert("You cannot have more than "+maxLimit+" characters");         
       CKEDITOR.instances.UnitGoals.setData(text.substr(0,maxLimit));
       editor.cancel();
     } else if (text.length==maxLimit-1) {
       alert("WARNING:\nYou are one character away from your limit.\nIf you continue you could lose any formatting");
       editor.cancel();
     }
   }   
   
 });