package components
{
	import flash.events.*;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import model.HmmChaptersModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	 
	public class CustomFileReferenceList extends FileReferenceList {
	    private var uploadURL:URLRequest;
	    private var pendingFiles:ArrayCollection;
	    private var currentIndex : int;
	    private var uploadContentId : Dictionary ;//= new Dictionary();
	    private var idString : String;
	    public var uploadCancelFlag : Boolean = false;
	    public var uploadDoneFlag : Boolean = false;
	    public var doOnCompleteFlag : Boolean = false;
		public static var LIST_COMPLETE:String = "listComplete";
		public static var LIST_CANCEL : String = "listCancel";
		public var proxyName : String;
		public var proxyUrl : String;
	    public function CustomFileReferenceList() {
	        uploadURL = new URLRequest();
	        uploadURL.url = proxyUrl+"/upload_moments/upload_image/";
	        initializeListListeners();
	    }
	
	    private function initializeListListeners():void {
	        addEventListener(Event.SELECT, selectHandler);
	        addEventListener(Event.CANCEL, cancelHandler);
	    }
	
	    public function getTypes(type : int):FileFilter {
	        var filter : FileFilter;
	        switch(type)
	        {
	        	case 0:
	        			filter = getImageTypeFilter();
	        			break;
	        	case 1:
	        			filter = getVideoTypeFilter(); 
	        			break;
	        	case 2:
	        			filter = getAudioTypeFilter();
	        			break;
	        }
	        
	        return filter;
	    }
	 
	    public function getImageTypeFilter():FileFilter {
	        return new FileFilter("*.jpg, *.jpeg, *.gif, *.png, *.JPG", "*.jpg;*.jpeg;*.gif;*.png;*.JPG");
	    }
	 
	    public function getVideoTypeFilter():FileFilter {
	        return new FileFilter("Video Files (*.wmv, *.mpeg, *.mov, *.avi, *.mpg, *.flv, *.mp4)", "*.wmv;*.mpeg;*.mov;*.avi;*.mpg;*.flv;*.mp4");
	    }
	    
	    public function getAudioTypeFilter():FileFilter {
	        return new FileFilter("Audio Files (*.mp3, *.wav)", "*.mp3;*.wav");
	    }
	 
	    public function doOnComplete():void {
	        var event:Event = new Event(CustomFileReferenceList.LIST_COMPLETE);
	        if(!uploadCancelFlag)
	        {
	        	var uploadCancel : HTTPService = new HTTPService();
	        	uploadCancel.url = proxyUrl+"/temp_uploads/deletetempcontents/"+HmmChaptersModel.getInstance().userId;//"/user_content/cancelUpload/"+HmmChaptersModel.getInstance().userId;
				uploadCancel.addEventListener(ResultEvent.RESULT, handletempresult);
				uploadCancel.addEventListener(FaultEvent.FAULT, handletempFault);
				uploadCancel.send();
				dispatchEvent(event);
	        	uploadDoneFlag = true;
	        	uploadCancelFlag = false;
	        }
	        else
	         doOnCompleteFlag = true;
	        
	    }
	    
	    private function handletempresult(event : ResultEvent) : void
	    {
	    	trace(event.message);
	    }
	    
	    private function handletempFault(event : FaultEvent) : void
	    {
	    	trace(event.message);
	    }
	 	
	 	public function doOnCancel() : void
	 	{
	 		for each(var id: String in uploadContentId)
	 		{
	 			if(idString == null)
	 			 idString = id;
	 			else
	 			 idString = idString + "," + id;
	 		}
	 		var uploadCancel : HTTPService = new HTTPService();
			uploadCancel.url = proxyUrl+"/temp_uploads/deleteContents/"+HmmChaptersModel.getInstance().userId;//"/user_content/cancelUpload/"+HmmChaptersModel.getInstance().userId;
			uploadCancel.addEventListener(ResultEvent.RESULT, handleGetCancelResult);
			uploadCancel.addEventListener(FaultEvent.FAULT, handleGetCancelFault);
			//var urlVars : URLVariables = new URLVariables();
			//urlVars.idString = idString;
			//uploadCancel.send(urlVars);
			uploadCancel.send();
			var eventCancel:Event = new Event(CustomFileReferenceList.LIST_CANCEL);
	 		dispatchEvent(eventCancel);	
	 		uploadCancelFlag = false;
	 		uploadDoneFlag = false;
	    }
	 	
	 	private function handleGetCancelResult( event : ResultEvent) : void
	 	{
	 		trace("Cancel Success")
	 	}
	 	
	 	private function handleGetCancelFault(event : FaultEvent) : void
	 	{
	 		trace("Failed to cancel upload")	
	 	}
	    public function addPendingFile(files:ArrayCollection):void {
	        //trace("addPendingFile: name=" + file.name);
	        pendingFiles = new ArrayCollection();
	        for(var i : int = 0; i < files.length;i++)
            {
            	trace("File: "+FileReference(files[i]).name);
            	pendingFiles.addItem(files[i]);
            }	
	        //pendingFiles = files;
	        currentIndex = 0;
	       uploadFile(pendingFiles[0] as FileReference);
	       uploadContentId = new Dictionary();
	       idString = null;
	       uploadCancelFlag = false;
	       uploadDoneFlag = false;
	       doOnCompleteFlag = false;
	    }
	    
	    private function uploadFile(file : FileReference) : void
	    {
	    	trace("Uploading File: name="+file.name);
	    	file.addEventListener(Event.OPEN, openHandler);
	        file.addEventListener(Event.COMPLETE, completeHandler);
	        file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	        file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,handleDataComplete);
	        var filename : String = file.name.toLowerCase();
	        var nameSplit : Array = filename.split(".");
	        var extension : String = nameSplit[nameSplit.length-1];
	        if(extension == "avi" || extension == "flv" || extension == "mpeg" || extension == "mov"
	        || extension  == "mpg" || extension == "wmv" || extension == "mp4" )
	        {
	        	uploadURL.url = proxyUrl+"/upload_moments/uploadVideo/";
	        }else if(extension == "wav" || extension == "mp3")
	        {
	        	uploadURL.url = proxyUrl+"/upload_moments/uploadAudio/";
	        }else if(extension == "jpg" || extension == "jpeg" || extension == "bmp" ||
	        		 extension == "gif" || extension == "png")
	        {
	        	uploadURL.url = proxyUrl+"/upload_moments/upload_image/";
	        }else
	        {
	        	Alert.show("The file format is unrecognized");
	        	return;
	        }
	        
	        var upUri : URLRequest = new URLRequest(uploadURL.url + HmmChaptersModel.getInstance().userId);
	       
	        file.upload(upUri,"Filedata",true);
	    }
	 	
	 	private function handleDataComplete(event : DataEvent) : void
	 	{
	 		uploadContentId[event.target]= event.text;
	 		//var idString : String = null;
	 		
	 		trace("uploadContentId" + uploadContentId[event.target])
	 	}
	 	
	    private function removePendingFile(file:FileReference):void {
	       // for (var i:uint; i < pendingFiles.length; i++) {
	            /* if (pendingFiles[i].name == file.name) {
	                pendingFiles.removeItemAt(i); */
	                currentIndex++;
	                trace("incrementing index: previous filename="+file.name+" index="+currentIndex); 
	                //pendingFiles.removeItemAt(idx);
	                
	                if (pendingFiles.length == currentIndex) {
	                    doOnComplete();
	                }else
	                {
	                	uploadFile(pendingFiles[currentIndex] as FileReference);
	                }
	                return;
	            //}
	       // }
	    }
	 
	    private function selectHandler(event:Event):void {
	        trace("selectHandler: " + fileList.length + " files");
	        pendingFiles = new ArrayCollection();
	        var file:FileReference;
	        /* for (var i:uint = 0; i < fileList.length; i++) {
	            file = FileReference(fileList[i]);
	            addPendingFile(file);
	        } */ 
	    }
	 
	    private function cancelHandler(event:Event):void {
	        var files:FileReferenceList = FileReferenceList(event.target);
	        trace("cancelHandler: name=" + files.fileList.join(","));
	        dispatchEvent(new Event("filebrowsercancel"));
	    }
	 
	    private function openHandler(event:Event):void {
	        var file:FileReference = FileReference(event.target);
	        trace("openHandler: name=" + file.name);
	    }
	 
	    private function progressHandler(event:ProgressEvent):void {
	        var file:FileReference = FileReference(event.target);
	        trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
	    }
	 
	    private function completeHandler(event:Event):void {
	        var file:FileReference = FileReference(event.target);
	        trace("completeHandler: name=" + file.name);
	        
	        removePendingFile(file);
	    }
	 
	    private function httpErrorHandler(event:Event):void {
	        var file:FileReference = FileReference(event.target);
	        trace("httpErrorHandler: name=" + file.name);
	    }
	 
	    private function ioErrorHandler(event:Event):void {
	        var file:FileReference = FileReference(event.target);
	        trace("ioErrorHandler: name=" + file.name);
	    }
	 
	    private function securityErrorHandler(event:Event):void {
	        var file:FileReference = FileReference(event.target);
	        trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
	    }
	}
}