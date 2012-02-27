/**
 *	ImageFlow 0.8
 *
 *	This code is based on Michael L. Perrys Cover flow in Javascript.
 *	For he wrote that "You can take this code and use it as your own" [1]
 *	this is my attempt to improve some things. Feel free to use it! If
 *	you have any questions on it leave me a message in my shoutbox [2].
 *
 *	The reflection is generated server-sided by a slightly hacked  
 *	version of Richard Daveys easyreflections [3] written in PHP.
 *	
 *	The mouse wheel support is an implementation of Adomas Paltanavicius
 *	JavaScript mouse wheel code [4].
 *
 *	Thanks to Stephan Droste ImageFlow is now compatible with Safari 1.x.
 *
 *
 *	[1] http://www.adventuresinsoftware.com/blog/?p=104#comment-1981
 *	[2] http://shoutbox.finnrudolph.de/
 *	[3] http://reflection.corephp.co.uk/v2.php
 *	[4] http://adomas.org/javascript-mouse-wheel/
 */

/* Configuration variables */
var conf_reflection_p  = 0.2;         // Sets the height of the reflection in % of the source image
var conf_focus         = 4;           // Sets the numbers of images on each side of the focussed one
var conf_slider_width  = 14;          // Sets the px width of the slider div
var conf_images_cursor = 'pointer';   // Sets the cursor type for all images default is 'default'
var conf_slider_cursor = 'default';   // Sets the slider cursor type: try "e-resize" default is 'default'

/* Id names used in the HTML */
var conf_imageflow     = 'imageflow'; // Default is 'imageflow'
var conf_loading       = 'loading';   // Default is 'loading'
var conf_images        = 'images';    // Default is 'images'
var conf_captions      = 'captions';  // Default is 'captions'
var conf_scrollbar     = 'scrollbar'; // Default is 'scrollbar'
var conf_slider        = 'slider';    // Default is 'slider'

/* Define global variables */
var caption_id         = 0;
var new_caption_id     = 0;
var current            = 0;
var target             = 0;
var mem_target         = 0;
var timer              = 0;
var array_images       = new Array ( ); // keep index to elements under image-div
var arraySlides        = new Array ( ); // keep the image objects itself. This can either be an img or div object.
var imageCenterLine    = 300; // the center where image, and shadow meet.
var distance           = 0;   // the distance between image and shadow.
var new_slider_pos     = 0;
var dragging           = false;
var dragobject         = null;
var dragx              = 0;
var posx               = 0;
var new_posx           = 0;
var xstep              = 150;

var Reflection = {
	defaultHeight : conf_reflection_p,
	defaultOpacity: 0.2,
	
	add: function ( image, options )  {
		Reflection.remove(image);
		
		doptions = { "height" : Reflection.defaultHeight, "opacity" : Reflection.defaultOpacity }
		if ( options )  {
			for ( var i in doptions ) {
				if ( ! options[i] )
					options[i] = doptions[i];
			}
		} 
		else
			options = doptions;
	
		try  {
			var newDiv     = document.createElement ( 'div' );
			var classes    = image.className.split  (  ' '  );
			var newClasses = '';
			for ( j=0; j<classes.length; j++ )  {
				if ( classes[j] != "reflect" ) {
					if ( newClasses )
					     newClasses += ' '
					
					newClasses += classes[j];
				}
			}

			var reflectionHeight = Math.floor ( image.height * options['height'] );
			//var divHeight        = Math.floor ( image.height * ( 1 + options['height'] ) );
			var divHeight        = Math.floor ( image.height * options['height'] );
			
			var reflectionWidth = image.width;
			
			if ( document.all && ! window.opera )  {
				/* Fix hyperlinks */
				if ( image.parentElement.tagName == 'A' )  {
					var newA  = document.createElement ( 'a' );
					newA.href = image.parentElement.href;
				}

				/* Copy original image's classes & styles to div */
				newDiv.className = newClasses;
				image.className  = 'reflected';
				
				newDiv.style.cssText = image.style.cssText;
				image.style.cssText  = 'vertical-align: bottom';
				newDiv.alt = image.alt;
				newDiv.target = image.target;

				var reflection = document.createElement ( 'img' );
				reflection.src = image.src;
				reflection.style.width = reflectionWidth+'px';
				
				reflection.style.marginBottom = "-"+(image.height-reflectionHeight)+'px';
				reflection.style.filter = 'flipv progid:DXImageTransform.Microsoft.Alpha(opacity='+(options['opacity']*100)+', style=1, finishOpacity=0, startx=0, starty=0, finishx=0, finishy='+(options['height']*100)+')';
				
				newDiv.style.width = reflectionWidth+'px';
				newDiv.style.height = divHeight+'px';
				image.parentNode.replaceChild ( newDiv, image );
				
				newDiv.appendChild ( image );
				newDiv.appendChild ( reflection );
			} 
			else  {
				var  canvas = document.createElement ( 'canvas' );
				if ( canvas.getContext )  {
					/* Copy original image's classes & styles to div */
					newDiv.className = newClasses;
					image.className  = 'reflected';
					
					newDiv.style.cssText  = image.style.cssText;
					image.style.cssText   = 'vertical-align: bottom';
					newDiv.style.position = 'absolute';
					newDiv.alt = image.alt;
					newDiv.target = image.target;

					var context = canvas.getContext ( "2d" );
				
					canvas.style.height = reflectionHeight+'px';
					canvas.style.width  = reflectionWidth+'px';
					canvas.height       = reflectionHeight;
					canvas.width        = reflectionWidth;
					
					newDiv.style.top    = imageCenterLine + 'px';
					
					image.parentNode.replaceChild ( newDiv, image );
					
					newDiv.appendChild ( image  );
					newDiv.appendChild ( canvas );
					context.save ( );
					
					context.translate ( 0, image.height-1 );
					context.scale ( 1, -1 );
					
					context.drawImage ( image, 0, 0, reflectionWidth, image.height );
	
					context.restore ( );
					
					context.globalCompositeOperation = "destination-out";
					var gradient = context.createLinearGradient ( 0, 0, 0, reflectionHeight );
					
					gradient.addColorStop ( 1, "rgba(255, 255, 255, 1.0)" );
					gradient.addColorStop ( 0, "rgba(255, 255, 255, "+(1-options['opacity'])+")" );
		
					context.fillStyle = gradient;
					if ( navigator.appVersion.indexOf ('WebKit') != -1 )  {
						context.fill ( );
					} else {
						context.fillRect ( 0, 0, reflectionWidth, reflectionHeight*2 );
					}
				}
			}
			return newDiv;
		} 
		catch ( e )  {
			return null;
	    }
	},
	
	remove : function ( image )  {
		if ( image.className == "reflected" )  {
			image.className = image.parentNode.className;
			image.parentNode.parentNode.replaceChild ( image, image.parentNode );
		}
	}
}

function step()
{
	switch (target < current-1 || target > current+1) 
	{
		case true:
			moveTo(current + (target-current)/3);
			window.setTimeout(step, 50);
			timer = 1;
			break;

		default:
			timer = 0;
			break;
	}
}

function glideTo ( x, new_caption_id )
{	
	/* Animate gliding to new x position */
	target = x;
	mem_target = x;
	if (timer == 0)
	{
		window.setTimeout(step, 50);
		timer = 1;
	}
	
	/* Display new caption */
	caption_id = new_caption_id;
	var image  = arraySlides[caption_id];
	caption    = image.alt; //getAttribute ( 'alt' );
	image_date  = image.target;
	if ( caption == '' ) 
		 caption = '&nbsp;';
	caption_div.innerHTML = caption;
	slider_div.innerHTML = '<br>'+caption;
	//scrollbar_div.innerHTML = '<br>'+caption;

	/* Set scrollbar slider to new position */
	if (dragging == false)
	{
		new_slider_pos = (scrollbar_width * (-(x*100/((max-1)*xstep))) / 100) - new_posx;
		slider_div.style.marginLeft = (new_slider_pos - conf_slider_width) + 'px';
	}
}

function moveTo ( x )
{
	current = x;
	var zIndex = max;
	
	/* Main loop */
	for (var index = 0; index < max; index++)
	{
		//var image = img_div.childNodes.item(array_images[index]);
		var image = arraySlides[index];
		var current_image = index * -xstep;

		/* Don't display images that are not conf_focussed */
		if ((current_image+max_conf_focus) < mem_target || (current_image-max_conf_focus) > mem_target)
		{
			image.style.visibility = 'hidden';
			image.style.display = 'none';
		}
		else 
		{
			var z = Math.sqrt(10000 + x * x) + 100;
			var xs = x / z * size + size;

			/* Still hide images until they are processed, but set display style to block */
			image.style.display = 'block';
		
			/* Process new image height and image width */
			var new_img_h = (image.h / image.w * image.pc) / z * size;
			switch ( new_img_h > max_height )
			{
				case false:
					var new_img_w = image.pc / z * size;
					break;

				default:
					new_img_h = max_height;
					var new_img_w = image.w * new_img_h / image.h;
					break;
			}
			var new_img_top = (images_width * 0.34 - new_img_h) + images_top + ((new_img_h / (conf_reflection_p + 1)) * conf_reflection_p);
			var new_img_left = xs - (image.pc / 2) / z * size + images_left;



                        /* Set image layer through zIndex */
			switch ( x < 0 )  {
				case true:
					zIndex++;
					break;

				default:
					zIndex = zIndex - 1;
					break;
			}
			/* Set new image properties */
			if ( image.childNodes.length == 2 )  {
				// These two lines move the Reflection
				image.style.left       = new_img_left + 'px';

				var img = image.childNodes[0];
				var ref = image.childNodes[1];
				img.style.height     = new_img_h + 'px';
				img.style.width      = new_img_w + 'px';
 				img.style.top        = ( - new_img_h - distance ) + 'px';
				img.style.visibility = 'visible';
				img.style.zIndex     = zIndex;
				ref.style.height     = ( new_img_h * Reflection.defaultHeight ) + 'px';
				ref.style.width      = new_img_w + 'px';
				ref.style.visibility = 'visible';
				ref.style.zIndex     = zIndex;
			}
			else  {
				image.style.height     = new_img_h    + 'px';
				image.style.width      = new_img_w    + 'px';
				image.style.top        = new_img_top  + 'px';
				image.style.left       = new_img_left + 'px';
				image.style.visibility = 'visible';
			}

			/* Change zIndex and onclick function of the focussed image */
			if ( image.i == caption_id )  {
				zIndex = zIndex + 1;
				img.onclick = function ( )  { glideTo(this.x_pos, this.i);}//document.location = this.url; }
			}
			else
				image.onclick = function ( )  { glideTo(this.x_pos, this.i); }

			//image.style.zIndex = zIndex;
			//ref.style.zIndex   = zIndex;
		}
		x += xstep;
	}
}

function JSSleep ( naptime )  {
	naptime = naptime * 1000;
	var sleeping = true;
	var now = new Date();
	var alarm;
	var startingMSeconds = now.getTime();
	//alert ( "starting nap at timestamp: " + startingMSeconds + "\nWill sleep for: " + naptime + " ms" );
	while ( sleeping )  {
		alarm = new Date ( );
		alarmMSeconds = alarm.getTime ( );
		if ( alarmMSeconds - startingMSeconds > naptime ) { 
			sleeping = false; 
		}
	}     
}

/* Main function */
function refresh ( onload )
{
	/* Cache document objects in global variables */
	imageflow_div = document.getElementById ( conf_imageflow );
	img_div       = document.getElementById ( conf_images    );
	scrollbar_div = document.getElementById ( conf_scrollbar );
	slider_div    = document.getElementById ( conf_slider    );
	caption_div   = document.getElementById ( conf_captions  );

	/* Cache global variables, that only change on refresh */
	images_width      = img_div.offsetWidth;
	images_top        = imageflow_div.offsetTop;
	images_left       = imageflow_div.offsetLeft;
	max_conf_focus    = conf_focus * xstep;
	size              = images_width * 0.5;
	scrollbar_width   = images_width * 0.6;
	conf_slider_width = conf_slider_width * 0.5;
	max_height        = images_width * 0.51;

	/* Change imageflow div properties */
	imageflow_div.style.height     = max_height + 'px';

	/* Change images div properties */
	img_div.style.height           = images_width * 0.338 + 'px';

	/* Change captions div properties */
	caption_div.style.width        = images_width + 'px';
	caption_div.style.marginTop    = images_width * 0.03 + 'px';
	imageCenterLine                = images_width * 0.4; //0.45;

	/* Change scrollbar div properties */
	scrollbar_div.style.marginTop  = images_width * 0.02 + 'px';
	scrollbar_div.style.marginLeft = images_width * 0.2 + 'px';
	scrollbar_div.style.width      = scrollbar_width + 'px';
	
	/* Set slider attributes */
	slider_div.onmousedown         = function () { dragstart(this); };
	slider_div.style.cursor        = conf_slider_cursor;

	/* Cache EVERYTHING! */
	max   = img_div.childNodes.length;
	var i = 0;
	for (var index = 0; index < max; index++)
	{
		var image  = img_div.childNodes.item ( index );
		var newDiv = null;
		if (image.nodeType == 1)
		{
			array_images[i] = index;
			
			/* Add width and height as attributes ONLY once onload */
			if ( onload == true )  {
				var classNames = image.className.split ( ' ' );
				for ( var j = 0;  j < classNames.length; j++ )  {
					if ( classNames[j] == 'reflect' )  {
						//elements.push ( child) ;
						var rheight  = null;
						var ropacity = null;
		
						for ( k=0; k<classNames.length; k++ )  {
							if ( classNames[k].indexOf ( "rheight" ) == 0 )
								rheight = classNames[k].substring(7)/100;
							else if ( classNames[k].indexOf ( "ropacity" ) == 0 )
								ropacity = classNames[k].substring(8)/100;
						}
		
						newDiv   = Reflection.add ( image, { height: rheight, opacity: ropacity } );
						newDiv.i = i;
						break;
					}
				}

				var imgObject = image;
				if ( newDiv  != null ) 
					imgObject = newDiv;
				imgObject.w   = image.width;
				imgObject.h   = image.height;
				arraySlides.push ( imgObject );

				/* Set image onclick by adding i and x_pos as attributes! */
				imgObject.onclick = function ( ) { glideTo ( this.x_pos, this.i ); }
				imgObject.x_pos = ( -i * xstep );
				imgObject.i = i;

				// Check source image format. Get image height minus reflection height !
				if ( imgObject.w > imgObject.h )
					 imgObject.pc = 118; // Landscape format
				else
					 imgObject.pc = 100; // Portrait and square format
			}
			// Set ondblclick event
			image.url        = image.getAttribute('longdesc');
			image.ondblclick = function ( )  { document.location = this.url; }
			// Set image cursor type
			image.style.cursor = conf_images_cursor;
			i++;
		}
	}

	if ( onload != true )  {
		for ( t=0; t<arraySlides.length; t++ )
 			arraySlides[t].style.top = imageCenterLine + 'px';
	}

	max = array_images.length;

	/* Display images in current order */
	moveTo  ( current );
	glideTo ( current, caption_id );
	
}

/* Show/hide element functions */
function show ( id )
{
	var element = document.getElementById ( id );
	element.style.visibility = 'visible';
}
function hide ( id )
{
	var element = document.getElementById ( id );
	element.style.visibility = 'hidden';
	element.style.display    = 'none';
}

/* Hide loading bar, show content and initialize mouse event listening after loading */
window.onload = function ( )
{
	if ( document.getElementById ( conf_imageflow ) )
	{
		refresh ( true );
		//moveTo  ( -450 );
		glideTo( -450, 3);
		hide    ( conf_loading   );
		show    ( conf_images    );
		show    ( conf_scrollbar );
		initMouseWheel ( );
		
		initMouseDrag  ( );
		
	}
}

/* Refresh ImageFlow on window resize */
window.onresize = function()
{
	if ( document.getElementById ( conf_imageflow ) ) 
		refresh ( );
}

/* Handle the wheel angle change (delta) of the mouse wheel */
function handle ( delta )
{
	var change = false;
	switch (delta > 0)
	{
		case true:
			if(caption_id >= 1)
			{
				target = target + xstep;
				new_caption_id = caption_id - 1;
				change = true;
			}
			break;

		default:
			if(caption_id < (max-1))
			{
				target = target - xstep;
				new_caption_id = caption_id + 1;
				change = true;
			}
			break;
	}

	/* Glide to next (mouse wheel down) / previous (mouse wheel up) image */
	if (change == true)
	{
		glideTo(target, new_caption_id);
	}
}

/* Event handler for mouse wheel event */
function wheel ( event )
{
	var delta = 0;
	if ( ! event ) 
		event = window.event;

	if ( event.wheelDelta )
		delta = event.wheelDelta / 120;

	else if ( event.detail )
		delta = -event.detail / 3;


	if ( delta ) 
		handle ( delta );

	if ( event.preventDefault ) 
		event.preventDefault ( );

	event.returnValue = false;
}

/* Initialize mouse wheel event listener */
function initMouseWheel ( )
{
	if ( window.addEventListener ) 
		imageflow_div.addEventListener ( 'DOMMouseScroll', wheel, false );
	imageflow_div.onmousewheel = wheel;
}

/* This function is called to drag an object (= slider div) */
function dragstart ( element )
{
	dragobject = element;
	dragx      = posx - dragobject.offsetLeft + new_slider_pos;
}

/* This function is called to stop dragging an object */
function dragstop()
{
	dragobject = null;
	dragging = false;
}

/* This function is called on mouse movement and moves an object (= slider div) on user action */
function drag ( e )
{
	posx = document.all ? window.event.clientX : e.pageX;
	if(dragobject != null)
	{
		dragging = true;
		new_posx = (posx - dragx) + conf_slider_width;

		/* Make sure, that the slider is moved in proper relation to previous movements by the glideTo function */
		if ( new_posx  < ( - new_slider_pos ) ) 
			new_posx = - new_slider_pos;
		if ( new_posx  > ( scrollbar_width - new_slider_pos ) ) 
			new_posx = scrollbar_width - new_slider_pos;
		
		var slider_pos     = (new_posx + new_slider_pos);
		var step_width     = slider_pos / ((scrollbar_width) / (max-1));
		var image_number   = Math.round(step_width);
		var new_target     = (image_number) * -xstep;
		var new_caption_id = image_number;

		dragobject.style.left = new_posx + "px";
		glideTo(new_target, new_caption_id);
	}
}

/* Initialize mouse event listener */
function initMouseDrag ( )
{
	document.onmousemove = drag;
	document.onmouseup   = dragstop;
}

document.onkeydown = function ( event )
{
	event = event || window.event;
	var charCode  = event.keyCode;
	switch ( charCode )
	{
		/* Right arrow key */
		case 39:
			handle(-1);
			break;
		
		/* Left arrow key */
		case 37:
			handle(1);
			break;
	}
}

