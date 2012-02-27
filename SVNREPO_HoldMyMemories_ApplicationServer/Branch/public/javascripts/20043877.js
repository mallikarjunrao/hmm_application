/********************************************************************

Popup Windows - V 4.4
Author: Brian Gosselin
Site URL: http://scriptasylum.com
Read the "releasenotes.txt" for supported features and release notes.

************** EDIT THE LINES BELOW AT YOUR OWN RISK ****************/



var w3c=(document.getElementById)? true: false;
var ns4=(document.layers)?true:false;
var ie5=(w3c && document.all && !window.opera)? true : false;
var ie6 = false /*@cc_on || @_jscript_version < 5.7 @*/;
var ie7 = (typeof document.body.style.maxHeight != "undefined" && document.all);
var strictMode = ((document.documentElement.clientWidth || document.documentElement.clientHeight) && (ie6 || ie7) && !window.opera) ? true : false;
var ns6=(w3c && !document.all)? true: false;
var aw_d=document;
currIDb=null; xoff=0; yoff=0;
oldac=null; newac=null; zdx=1; mx=0; my=0;
var currFb=null; var currFs=null; var currFID=0; var currFcnt=0;
var cidlist=new Array();

var popWidth = 700
var popHeight = 600
var windowWidth = ns6 ? window.innerWidth : document.body.clientWidth;
var windowHeight = ns6 ? window.innerHeight : document.body.clientHeight;
if (windowWidth == 0 || strictMode) windowWidth = document.documentElement.clientWidth;
if (windowHeight == 0 || strictMode)  windowHeight = document.documentElement.clientHeight;
var slideAmountPerFrame = 4; // Pixel distance window moves each fram of animation
var frameLength = 5; // Milliseconds each frame of animation lasts
var slideX = 0;
var slideY = 0;
var scrollX = 0;
var scrollY = 0;
var slideXFinal = Math.round((windowWidth / 2) - (popWidth / 2));
slideXFinal = (slideXFinal < 0) ? 0 : slideXFinal;
var slideYFinal = Math.round((windowHeight / 2) - (popHeight / 2));
slideYFinal = (slideYFinal < 0) ? 0 : slideYFinal;
var slideXInterval = 0;
var slideYInterval = 0;
var slideStop;
var yOffset;

//******* START OF EXPOSED FUNCTIONS. THESE CAN BE USED IN HYPERLINKS. *******\\

function slidebox(id, direction) {
   slideX += slideXInterval;
   slideY += slideYInterval;
   movePopup("pop1", slideX, slideY);

   scrollX = ns6 ? window.scrollX : document.body.scrollLeft;
   scrollY = ns6 ? window.scrollY : document.body.scrollTop;

   if((direction == "top") && (slideY > slideYFinal + scrollY)) {
      clearInterval(slideStop);
   } else if((direction == "bottom") && (slideY < slideYFinal + scrollY)) {
      clearInterval(slideStop);
   } else if((direction == "left") && (slideX > slideXFinal + scrollX)) {
      clearInterval(slideStop);
   } else if((direction == "right") && (slideX < slideXFinal + scrollX)) {
      clearInterval(slideStop);
   } else if((direction == "diag") && (slideY > slideYFinal + scrollY)) {
      clearInterval(slideStop);
   }
}

function slideboxin(id, direction) {
   if(w3c){
      if(direction == "top") {
         slideX = Math.round((windowWidth / 2) - (popWidth / 2));
         slideX = (slideX < 0) ? 0 : slideX;
         slideY = yOffset - windowHeight;
         slideXInterval = 0;
         slideYInterval = slideAmountPerFrame;
         movePopup("pop1", slideX, slideY);
         showbox("pop1");
         slideStop = setInterval('slidebox("pop1", "top")', frameLength)

     } else if(direction == "bottom") {
         slideX = Math.round((windowWidth / 2) - (popWidth / 2));
         slideX = (slideX < 0) ? 0 : slideX;
         slideY = yOffset + windowHeight;
         slideXInterval = 0;
         slideYInterval = -slideAmountPerFrame;
         movePopup("pop1", slideX, slideY);
         showbox("pop1");
         slideStop = setInterval('slidebox("pop1", "bottom")', frameLength)

      } else if(direction == "left") {
         slideX = -windowWidth;
         slideY = yOffset + (Math.round((windowHeight / 2) - (popHeight / 2)));
         slideY = (slideY < 0) ? 0 : slideY;
         slideXInterval = slideAmountPerFrame;
         slideYInterval = 0;
         movePopup("pop1", slideX, slideY);
         showbox("pop1");
         slideStop = setInterval('slidebox("pop1", "left")', frameLength)

      } else if(direction == "right") {
         slideX = windowWidth;
         slideY = yOffset + Math.round((windowHeight / 2) - (popHeight / 2));
         slideY = (slideY < 0) ? 0 : slideY;
         slideXInterval = -slideAmountPerFrame;
         slideYInterval = 0;
         movePopup("pop1", slideX, slideY);
         showbox("pop1");
         slideStop = setInterval('slidebox("pop1", "right")', frameLength)

      } else { // Slide in diagonally from the top left
         slideX = 0;
         slideY = 0;
         slideXInterval = slideAmountPerFrame;
         slideYInterval = slideAmountPerFrame;
         movePopup("pop1", slideX, slideY);
         showbox("pop1");
         slideStop = setInterval('slidebox("pop1", "diag")', frameLength)
     }
   }
}

function fadeboxin(id){
if((currFb==null) && w3c){
clearInterval(currFID);
currFb=aw_d.getElementById(id+'_b');
currFs=aw_d.getElementById(id+'_s');
if(currFb.style.display=='none'){
currFcnt=0;
if(ie5)currFb.style.filter=currFs.style.filter="alpha(opacity=0)";
else currFb.style.MozOpacity=currFs.style.MozOpacity=0;
hideAllScrollbars();
currFb.style.display=currFs.style.display='block';
changez(currFb);
currFID=setInterval('sub_fadein()',20);
}else currFb=null;
}}

function fadeboxout(id){
if((currFb==null) && w3c){
clearInterval(currFID);
currFb=aw_d.getElementById(id+'_b');
currFs=aw_d.getElementById(id+'_s');
if(currFb.style.display=='block'){
currFcnt=100;
if(ie5){
currFb.style.filter="alpha(opacity=100)";
currFs.style.filter="alpha(opacity=50)";
}else{
currFb.style.MozOpacity=1;
currFs.style.MozOpacity=.5;
}
hideAllScrollbars();
currFb.style.display=currFs.style.display='block';
changez(currFb);
currFID=setInterval('sub_fadeout()',20);
}else currFb=null;
}}

function hidebox(id){
if(w3c){
//if(currFb!=aw_d.getElementById(id+'_b')){
aw_d.getElementById(id+'_b').style.display='none';
aw_d.getElementById(id+'_s').style.display='none';
//}
}}

function showbox(id){
if(w3c){
var bx=aw_d.getElementById(id+'_b');
var sh=aw_d.getElementById(id+'_s');
bx.style.display='block';
sh.style.display='block';
sh.style.zIndex=++zdx;
bx.style.zIndex=++zdx;
if(ns6){
bx.style.MozOpacity=1;
sh.style.MozOpacity=.5;
}else{
bx.style.filter="alpha(opacity=100)";
sh.style.filter="alpha(opacity=50)";
}
changez(bx);
}}

function changecontent(id,text){
if(!document.getElementById(id+'_b').isExt){
var aw_d=document.getElementById(id+'_c');
if(ns6)aw_d.style.overflow="hidden";
aw_d.innerHTML=text;
if(ns6)aw_d.style.overflow="block";
}else document.getElementById(id+'_ifrm').src=text;
}

function movePopup(ids,x,y){
if(w3c){
var idb=document.getElementById(ids+'_b');
var ids=document.getElementById(ids+'_s');
idb.style.left=x+'px';
ids.style.left=x+8+'px';
idb.style.top=y+'px';
ids.style.top=y+8+'px';
}}

//******* END OF EXPOSED FUNCTIONS *******\\

function hideAllScrollbars(){
if(document.all){
var id;
for(i=0;i<cidlist.length;i++){
id=cidlist[i];
if(!document.getElementById(id+'_b').isExt)document.getElementById(id+'_c').style.overflow="hidden";
}}}

function showAllScrollbars(){
if(document.all){
var id;
for(i=0;i<cidlist.length;i++){
id=cidlist[i];
if(!document.getElementById(id+'_b').isExt)document.getElementById(id+'_c').style.overflow="auto";
}}}

function sub_fadein(){
currFcnt+=4;
if(ie5){
currFb.style.filter="alpha(opacity="+currFcnt+")";
currFs.style.filter="alpha(opacity="+(currFcnt/2)+")";
}else{
currFb.style.MozOpacity=currFcnt/100;
currFs.style.MozOpacity=(currFcnt/2)/100;
}
if(currFcnt>=99){
currFb.style.display=currFs.style.display='block';
showAllScrollbars()
currFb=null;
clearInterval(currFID);
}}

function sub_fadeout(){
currFcnt=currFcnt-4;
if(ie5){
currFb.style.filter="alpha(opacity="+currFcnt+")";
currFs.style.filter="alpha(opacity="+(currFcnt/2)+")";
}else{
currFb.style.MozOpacity=currFcnt/100;
currFs.style.MozOpacity=(currFcnt/2)/100;
}
if(currFcnt<=0){
currFb.style.display=currFs.style.display='none';
showAllScrollbars()
currFb=null;
clearInterval(currFID);
}}

function preloadBttns(){
var btns=new Array();
btns[0]=new Image(); btns[0].src="http://forms.aweber.com/form/close.gif";
}
preloadBttns();

function minimize(){
if(w3c){
aw_d.getElementById(this.cid+"_b").style.height=(ie5)? '28px':'24px';
aw_d.getElementById(this.cid+"_s").style.height='28px';
aw_d.getElementById(this.cid+"_c").style.display='none';
aw_d.getElementById(this.cid+"_rs").style.display='none';
ns6bugfix();
}}

function restore(){
if(w3c){
aw_d.getElementById(this.cid+"_b").style.height=this.h+'px';
aw_d.getElementById(this.cid+"_s").style.height=(ie5)? this.h+'px':this.h+5+'px';
aw_d.getElementById(this.cid+"_c").style.display='block';
aw_d.getElementById(this.cid+"_rs").style.display='block';
ns6bugfix();
}}

function ns6bugfix(){
if(navigator.userAgent.indexOf("Netscape/6")>0)setTimeout('self.resizeBy(0,1); self.resizeBy(0,-1);', 100);
}

function trackmouse(evt){
mx=(ie5)?event.clientX+aw_d.body.scrollLeft:evt.pageX;
my=(ie5)?event.clientY+aw_d.body.scrollTop:evt.pageY;
if(!ns6)movepopup();
if(currIDb!=null)return false;
}

function movepopup(){
if((currIDb!=null)&&w3c)movePopup(currIDb.cid,mx+xoff,my+yoff);
return false;
}

function changez(v){
var th=(v!=null)?v:this;
if(oldac!=null)aw_d.getElementById(oldac.cid+"_t").style.backgroundColor=oldac.inactivecolor;
if(ns6)aw_d.getElementById(th.cid+"_c").style.overflow='auto';
oldac=th;
aw_d.getElementById(th.cid+"_t").style.backgroundColor=th.activecolor;
aw_d.getElementById(th.cid+"_s").style.zIndex=++zdx;
th.style.zIndex=++zdx;
aw_d.getElementById(th.cid+"_rs").style.zIndex=++zdx;
}

function stopdrag(){
currIDb=null;
document.getElementById(this.cid+"_extWA").style.display="none";
ns6bugfix();
}

function grab_id(evt){
var ex=(ie5)?event.clientX+aw_d.body.scrollLeft:evt.pageX;
var ey=(ie5)?event.clientY+aw_d.body.scrollTop:evt.pageY;
xoff=parseInt(aw_d.getElementById(this.cid+"_b").style.left)-ex;
yoff=parseInt(aw_d.getElementById(this.cid+"_b").style.top)-ey;
currIDb=aw_d.getElementById(this.cid+"_b");
currIDs=aw_d.getElementById(this.cid+"_s");
aw_d.getElementById(this.cid+"_extWA").style.display="block";
return false;
}

function subBox(x,y,w,h,bgc,id){
var v=aw_d.createElement('div');
v.setAttribute('id',id);
v.style.position='absolute';
v.style.left=x+'px';
v.style.top=y+'px';
v.style.width=w+'px';
v.style.height=h+'px';
if(bgc!='')v.style.backgroundColor=bgc;
v.style.visibility='visible';
v.style.padding='0px';
return v;
}

function get_cookie(Name) {
var search=Name+"=";
var returnvalue="";
if(aw_d.cookie.length>0){
offset=aw_d.cookie.indexOf(search);
if(offset!=-1){
offset+=search.length;
end=aw_d.cookie.indexOf(";",offset);
if(end==-1)end=aw_d.cookie.length;
returnvalue=unescape(aw_d.cookie.substring(offset,end));
}}
return returnvalue;
}

function popUp(x,y,w,h,cid,text,bgcolor,textcolor,fontstyleset,title,titlecolor,titletextcolor,bordercolor,scrollcolor,shadowcolor,showonstart,isdrag,isresize,oldOK,isExt,popOnce){
if ((ie6 || ie7) && strictMode) {
   yOffset = document.documentElement.scrollTop;
   slideYFinal = yOffset + slideYFinal;
} else if (ie6 || ie7) {
   yOffset = document.body.scrollTop;
} else {
   yOffset = window.pageYOffset;
   slideYFinal = yOffset + slideYFinal;
}
y = y + yOffset;
var okPopUp=false;
if (popOnce){
if (get_cookie(cid)==""){
okPopUp=true;
aw_d.cookie=cid+"=yes"
}}
else okPopUp=true;
if(okPopUp){
if(w3c){
cidlist[cidlist.length]=cid;
w=Math.max(w,100);
h=Math.max(h,80);
var rdiv=new subBox(w-((ie5 && !strictMode)?12:8),h-((ie5 && !strictMode)?12:8),7,7,'',cid+'_rs');
var tw=(ie5 && !strictMode)?w:w+4;
var th=(ie5 && !strictMode)?h:h+6;
var shadow=new subBox(x+8,y+8,tw,th,shadowcolor,cid+'_s');
if(ie5)shadow.style.filter="alpha(opacity=50)";
else shadow.style.MozOpacity=.5;
shadow.style.zIndex=++zdx;
var outerdiv=new subBox(x,y,w,h,bordercolor,cid+'_b');
outerdiv.style.display="block";
outerdiv.style.borderStyle="outset";
outerdiv.style.borderWidth="2px";
outerdiv.style.borderColor=bordercolor;
outerdiv.style.zIndex=++zdx;
tw=(ie5 && !strictMode)?w-8:w-5;
th=(ie5 && !strictMode)?h+4:h-4;
var titlebar=new subBox(2,2,tw,20,titlecolor,cid+'_t');
titlebar.style.overflow="hidden";
titlebar.style.cursor="default";
titlebar.innerHTML='<span style="position:absolute; left:3px; top:1px; font:bold 10pt sans-serif; color:'+titletextcolor+'; height:18px; overflow:hidden; clip-height:16px;">'+title+'</span><div id="'+cid+'_btt" style="position:absolute; width:48px; height:16px; left:'+(tw-48)+'px; top:2px; text-align:right"><img src="http://forms.aweber.com/form/close.gif" width="16" height="16" id="'+cid+'_cls"></div>';
tw=(ie5 && !strictMode)?w-7:w-13;
var content=new subBox(2,24,tw,h-36,bgcolor,cid+'_c');
content.style.borderColor=bordercolor;
content.style.borderWidth="2px";
if(isExt){
content.innerHTML='<iframe id="'+cid+'_ifrm" src="'+text+'" width="100%" height="100%"></iframe>';
content.style.overflow="hidden";
}else{
if(ie5)content.style.scrollbarBaseColor=scrollcolor;
content.style.borderStyle="inset";
content.style.overflow="auto";
content.style.padding="0px 2px 0px 4px";
content.innerHTML=text;
content.style.font=fontstyleset;
content.style.color=textcolor;
}
var extWA=new subBox(2,24,0,0,'',cid+'_extWA');
extWA.style.display="none";
extWA.style.width='100%';
extWA.style.height='100%';
outerdiv.appendChild(titlebar);
outerdiv.appendChild(content);
outerdiv.appendChild(extWA);
outerdiv.appendChild(rdiv);
aw_d.body.appendChild(shadow);
aw_d.body.appendChild(outerdiv);
aw_d.gEl=aw_d.getElementById;
if(!showonstart)hidebox(cid);
var wB=aw_d.gEl(cid+'_b');
wB.cid=cid;
wB.isExt=(isExt)?true:false;
var wT=aw_d.gEl(cid+'_t');
wT.cid=cid;
var wCLS=aw_d.gEl(cid+'_cls');
var wEXTWA=aw_d.gEl(cid+'_extWA');
wB.activecolor=titlecolor;
wB.inactivecolor=scrollcolor;
if(oldac!=null)aw_d.gEl(oldac.cid+"_t").style.backgroundColor=oldac.inactivecolor;
oldac=wB;
wCLS.onclick=new Function("hidebox('"+cid+"');");
wB.onmousedown=function(){ changez(this) }
if(isdrag){
wT.onmousedown=grab_id;
wT.onmouseup=stopdrag;
}
}else{
if(oldOK){
var ctr=new Date();
ctr=ctr.getTime();
var t=(isExt)?text:'';
var posn=(ns4)? 'screenX='+x+',screenY='+y: 'left='+x+',top='+y;
var win=window.open(t , "abc"+ctr , "status=no,menubar=no,width="+w+",height="+h+",resizable=no,scrollbars=yes,"+posn);
if(!isExt){
t='<html><head><title>'+title+'</title></head><body bgcolor="'+bgcolor+'"><font style="font:'+fontstyleset+'; color:'+textcolor+'">'+text+'</font></body></html>';
win.document.write(t);
win.document.close();
}}}}}

if(ns6)setInterval('movepopup()',40);

if(w3c){
aw_d.onmousemove=trackmouse;
}

   function setCookie(name, value, expires, path, domain, secure) {
     var curCookie = name + "=" + escape(value) +
      ((expires) ? "; expires=" + expires.toGMTString() : "") +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      ((secure) ? "; secure" : "");
     document.cookie = curCookie;
   }

   function getCookie(name) {
      var dc = document.cookie;
      var prefix = name + "=";
      var begin = dc.indexOf("; " + prefix);
      if (begin == -1) {
	 begin = dc.indexOf(prefix);
	 if (begin != 0) return null;
      } else
	 begin += 2;
      var end = document.cookie.indexOf(";", begin);
   if (end == -1)
      end = dc.length;
      return unescape(dc.substring(begin + prefix.length, end));
   }

   var mydate = new Date();
   mydate.setTime(mydate.getTime() + -86400000);
   setCookie('awpopup_20043877', '1', mydate, '/', document.domain, 0);
   if(!getCookie('awpopup_20043877')) {

  
  function getvalue(tot,tot1,tot2)
  {
  	launcher1(tot,tot1,tot2);
  }
   function launcher1(total,total1,total2) {
   	 //alert("wfwefwe");
      new popUp(slideXFinal, slideYFinal, 700, 200, "pop1","<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"515\" align=\"left\" valign=\"top\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td height=\"36\" align=\"left\" valign=\"bottom\"></td></tr><tr><td height=\"20\" align=\"left\" valign=\"top\"></td></tr><tr><td height=\"24\" align=\"left\" valign=\"top\" class=\"cont-big\">You have "+total+" new Family & Friend Requests.To view friend requests <a href='/customers/FnF_Request/'>Click here </a>.</td></tr></table></td></tr><tr><td height=\"24\" align=\"left\" valign=\"top\" class=\"cont-big\">You have "+total1 +" new  shared memories for you.<a href= '/customers/list_share/'>Click here</a> to view.</td></tr></table></td></tr><tr><td height=\"24\" align=\"left\" valign=\"top\" class=\"cont-big\">You have "+total2+" new exported memories.  <a href= '/customers/list_export/'>Click here</a> to view. </td></tr></table></td></tr><tr><td height=\"25\" colspan=\"2\" align=\"left\" valign=\"top\" class=\"cont-big\"></td></tr><tr><td align=\"left\" valign=\"top\"></td><td width=\"262\" height=\"30\" align=\"left\" valign=\"middle\" class=\"cont-big\"></td><td width=\"179\" height=\"40\" align=\"left\" valign=\"middle\" class=\"cont-big\"><a href=\"http://live.newwavetraining.com/site/Register.asp?id=221\" target=\"_blank\" onmouseover=\"MM_swapImage('Image7','','images/dropdown_joinnow_btnovr.gif',1)\" onmouseout=\"MM_swapImgRestore()\"></a></td></tr></table></td></tr><tr><td align=\"left\" valign=\"top\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"74\" align=\"left\" valign=\"top\"></td><td width=\"292\" align=\"left\" valign=\"top\" class=\"cont-big\"></td></tr></table>", "#000000", "#FFFFFF", "10pt sans-serif", "HoldMyMemories.com todays alerts!", "#191919", "#e36500", "#191919", "#e36500", "black", true, true, true, true, false, false,window.focus
	  );
      slideboxin("pop1", "top");

            unique_track = new Image();
      unique_track.src = "http://forms.aweber.com/form/displays.htm?id=TAwMLMwc7Ow=";

   }
   setTimeout('launcher();', 0 * 1000);
}
