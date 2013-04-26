function showHideMessages(){
  element = document.getElementById('showHideMessages').style;
  if (element.display=='none') {element.display='block';}
  else {element.display='none';}
  elementSrc = document.getElementById('showHideImage').src;
  elementMinus = elementSrc.indexOf("minus");
  if (elementMinus!==-1) {document.getElementById('showHideImage').src='/assets/plus.gif';}
  else {document.getElementById('showHideImage').src='/assets/minus.gif';}
}
