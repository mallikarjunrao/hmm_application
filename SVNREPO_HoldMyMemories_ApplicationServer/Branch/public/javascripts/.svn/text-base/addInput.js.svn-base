var counter = 1;
var limit = 10;
function addInput(divName){
     if (counter == limit)  {
          alert("You have reached the limit of adding " + counter + " inputs");
     }
     else {
          var newdiv = document.createElement('div');
          newdiv.innerHTML = "<font color='#ffffff'>Moment " + (counter + 1) + " </font><br><input type='file' name='myFiles[]'>";
          document.getElementById(divName).appendChild(newdiv);
          counter++;
     }
}