

var message = "Images cannot be copied from this website!!"; 
function rtclickcheck(keyp)
{ 
	//alert(keyp.which);
        if (navigator.appName == "Netscape" && keyp.which == 3)
	{ 	
		alert(message); 
		return false; 
	} 
        else
        {
            return true;
        }    
	if (navigator.appVersion.indexOf("MSIE") != -1 && event.button == 2) 
	{ 	
		alert(message); 	
		return false;
        } 
        else
        {
            return true;
        }   
 } 
        
       function callme(id1)
       {
           // alert("Images cannot be copied from this website!!")
         // alert(id1)
          document.getElementById(id1).onmousedown = rtclickcheck;
         //document.getElementById('img1').onkeyup = KeyCheck
        // alert(document.onkeyup)
        //  return false;
        //document.onkeyup = KeyCheck;       
       }
       
       
        
        function KeyCheck()
        {
                var KeyID = event.keyCode;
                //alert(KeyID);
                if(KeyID == 17 )
              {		
                        alert("Images may not be copied from this site!!");	
                        return KeyID;
                }
        }
