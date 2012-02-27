YAHOO.util.Event.addListener('uploader_0','change', addFile, '0');
YAHOO.util.Event.addListener(window,'load', windowOnLoad);

var uploadFiles = new Array();

function windowOnLoad()
{
	// Reset the file input field because FF/IE might remember it automatically which is not wanted for this app
	$('uploader_0').value = '';
}

function addFile(e, el)
{
	var uElement = $('uploader_'+el);

	if (!uElement)
	{
		uElement = $('uploader_'+(parseInt(el)-1));
	}
	if (!uElement)
	{
		alert('Something odd is happening. Check eyecandy.js');
	}
	

	uploadFiles.push(uElement.value);	
	renderUploads();
	
	uElement.style.display = 'none';
	
	var newUploader = document.createElement('input');
	newUploader.type = 'file';
	newUploader.id = 'uploader_'+uploadFiles.length;
	newUploader.name = 'upfile_'+uploadFiles.length;	
	
	$('uploaders-container').appendChild(newUploader);
	
	YAHOO.util.Event.addListener(newUploader,'change', addFile, uploadFiles.length);	
	
	return true;
}

function removeFile(id)
{
	var uploadersContainer = $('uploaders-container');
	
	uploadersContainer.removeChild($('uploader_'+id));
	uploadFiles.splice(id, 1);
	
	for (i=0; i<uploadersContainer.childNodes.length; i++)
	{
		uploadersContainer.childNodes[i].id = 'uploader_'+i;
		uploadersContainer.childNodes[i].name = 'upfile_'+i;				
	}
	
	renderUploads();
}

function renderUploads()
{
	var uploadButton = $('upload-button');
	var noFilesInfo = $('no-files-info');
	var filesList = $('files-list');
	
	filesList.innerHTML = '';
	$('upload-range').value = uploadFiles.length;
	
	if (uploadFiles.length==0)
	{
		noFilesInfo.style.display = 'block';
		uploadButton.style.display = 'none';
		return false;		
	}
	else if (uploadFiles.length==1)
		uploadButton.value = 'Upload file';
	else
		uploadButton.value = 'Upload files';
		
	noFilesInfo.style.display = 'none';				
	uploadButton.style.display = 'block';

	for (i=0; i<uploadFiles.length; i++)
	{
		filesList.innerHTML = filesList.innerHTML +'<li>'+uploadFiles[i]+' - <a href="javascript:removeFile(\''+i+'\')">Remove</a></li>';
	}
	
	return true;
}

function tryItAgain()
{
	$('upload-done').style.display = 'none';			
	$('choose-file-div').style.display = 'block';
	$('upload-list-div').style.display = 'block';
	$('upload-button').style.display = 'none';	
	$('no-files-info').style.display = 'block';	
	
	clearStuff();
	
	$('upload-range').value = 0;
	
	var newUploader = document.createElement('input');
	newUploader.type = 'file';
	newUploader.id = 'uploader_0';
	newUploader.name = 'upfile_0';
		
	$('uploaders-container').appendChild(newUploader);	
	
	YAHOO.util.Event.addListener('uploader_0','change', addFile, '0');	


	upload_sid = shift_sid(upload_sid);
	
	CakeTimer.monitorUploads($('upload-form'), 
							 '/cgi-bin/uber_uploader.cgi', 
							 'uploads/progress', 
							 {progress: handleProgress, error: handleError, begin: handleBegin, done: handleDone}, 
							 upload_sid);		
}

function shift_sid(sid)
{
	return sid.substr(sid.length-1,1)+sid.substr(0, sid.length-1);
}

function clearStuff()
{
	uploadFiles = new Array();
	var uploadersContainer = $('uploaders-container');
	var filesList = $('files-list');

	filesList.innerHTML = '';
	
	for (i=0; i<uploadersContainer.childNodes.length; i++)
	{
		uploadersContainer.removeChild(uploadersContainer.childNodes[i]);
	}
	
	uploadersContainer.innerHTML = '';
}