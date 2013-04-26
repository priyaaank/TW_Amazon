$(document).ready(function() {
  imageX='plus';
function toggleDisplay(e){
                         element = document.getElementById(e).style;
if (element.display=='none') {element.display='block';}
else {element.display='none';}
if (imageX=='plus') {document.getElementById('imagePM').src='minus.gif';imageX='minus';}
else {document.getElementById('imagePM').src='plus.gif';imageX='plus';}
}
}