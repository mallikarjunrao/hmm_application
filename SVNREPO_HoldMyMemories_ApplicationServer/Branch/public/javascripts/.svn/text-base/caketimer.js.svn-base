/**
 * CakeTimerComponent by Felix Geisenörfer
 *
 * http://www.fg-webdesign.de
 * http://www.thinkingphp.org
 *
 * Licensed under the MIT License: http://www.opensource.org/licenses/mit-license.php* 
 *
 */
var CakeTimer = function() {
    return {
		// This values will get overwritten by the resetClass function -> check it before modifying here
		uploading: false,		// Tells if an upload is in progress or not
		callback: null,			// Contains the callback functions
		upload_sid: null,		// The upload_sid used for this upload
		bytesUploaded: 0,		// The amount of bytes Uploaded so far
		bytesTotal: 0,			// The amount of bytes in the Upload (if available yet)
		progressTracker: null,	// The Link to the progressTracker script
		watchForm: null,		// The name of the form to watch
		requestNum: 0,			// Contains the Number of Ajax calls that have been made so far

		monitorUploads: function(watchForm, uploadCGI, progressTracker, callback, upload_sid)
		{		
			//debug('MonitorUploads for '+submit_form);
			this.resetClass(); // Clean up any mess their might have been left from previous usage
			
			YAHOO.util.Event.addListener(watchForm,'submit',this.startUpload, this, true);			
			this.callback = callback;
			this.upload_sid = upload_sid;
			this.progressTracker = progressTracker;
			this.uploadCGI = uploadCGI+"?tmp_sid="+upload_sid;
			this.watchForm = watchForm;

			return true;
		},
		
		startUpload: function(e,el) 
		{			
			if (this.uploading==true)
				return YAHOO.util.Event.stopEvent(e);
		
			$(this.watchForm).action = this.uploadCGI;
			
			//debug('Start Upload');			
			
			this.callback.progress(0, 0);
			this.requestProgress('new');
			
			if (this.callback["begin"])			
				this.callback.begin(this.upload_sid);
								
			this.uploading = true;
			
			// The submit event is sometimes broken on the second upload, so let's make sure it works
			$(this.watchForm).submit();
			
			return true;			
		},
		
		requestProgress: function(type)
		{
			var callback =
			{
				success: this.progressCallback,
				failure: this.progressFailure,
				argument: null,
				scope: this
			}			
						
			var cObj = YAHOO.util.Connect.asyncRequest('GET',this.progressTracker+'?upload_sid='+upload_sid+'&type='+type+'&rqstNum='+this.requestNum,callback,null);		
			
			// This requestNum variable is necessary so each request will have it's unique link. Otherwise some browsers that
			// are very agressive about caching (let's call them opera for now) will break your ajax requests with 304 errors
			this.requestNum = this.requestNum+1;
		},
		
		progressCallback: function(o)
		{
			var data = o.responseText.split("\n");
					
			//debug(o.responseText);
			//debug('Progress Callback ('+data[0]+'/'+data[1]+')');
			//debug(o.responseText);
			if (data[0]=='done')
			{
				this.callback.progress(this.bytesTotal,this.bytesTotal);
				
				data.shift();				
				
				var files = new Array();
				
				for (var i=0; i<data.length/2; i++)
				{
					files[i] = new Array(data[i*2], data[i*2+1]);
				}
				
				if (this.callback["done"])		
					this.callback.done(this.upload_sid, files);
			}
			else if (data[0]=='error')
			{
				if (this.callback["error"])			
					this.callback.error(this.upload_sid, data[1], null);				
			}
			else
			{
				if ((!isInteger(data[0])) || (!isInteger(data[1])))
				{
					if (this.callback["error"])			
						this.callback.error(this.upload_sid, 'progressTracker Data has a wrong format!', o.responseText);
						
					return false;
				}
				
				// This is neccessary, otherwise the bar runs backwards for big multi-file uploads since the perl script
				// changes the size when the files are processed at the end
				if (data[0]=='0')
					this.requestProgress('waiting');
				else
					this.requestProgress('progress');

				if (parseInt(data[0])>=this.bytesUploaded)
				{
					this.callback.progress(data[0],data[1]);
					this.bytesUploaded = parseInt(data[0]);
				}
				
				this.bytesTotal = parseInt(data[1]);
			}			
			
			return true;
		},
				
		progressFailure: function(o)
		{
			// Opera is very agressive about caching, so we'll get a 304 from time to time.
			// 
			/*
			if (o.status==304)
			{
				ignore304
			}*/
			
			
			if (this.callback["error"])			
				this.callback.error(this.upload_sid, 'progressTracker not available', o.statusText);
			//debug('Error: Progress FAILURE!');
			return false;
		},
		
		resetClass: function()
		{
			this.uploading = false;
			this.callback = null;
			this.upload_sid = null;
			this.bytesTotal = 0;
			this.bytesUploaded = 0;
			this.requestNum = 0;
			this.progressTracker = null;
			this.watchForm = null;
		}
    };
} ();

function isInteger(s)
{   var i;
    for (i = 0; i < s.length; i++)
    {   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

	
	function debug(str)
	{
		$('debug').innerHTML = $('debug').innerHTML + str+"<br/>";
	}
	