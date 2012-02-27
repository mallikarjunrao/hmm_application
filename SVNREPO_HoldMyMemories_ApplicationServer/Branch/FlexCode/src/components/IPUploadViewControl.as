package components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	import model.HmmChaptersModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import qs.ipeControls.classes.IPEBase;
	
	import vo.WebFileVO;

	public class IPUploadViewControl extends IPEBase
	{
		[Embed(source="../assets/uploaddef.png")]
		private var uploadDefSkin : Class;
		[Embed(source="../assets/uploadovr.png")]
		private var uploadOVerSkin : Class;
		public var uploadSelection : UploadSelection;
		public var uploadImageSelection : UploadedImageSelection;
		private var uploadButton : Button;
		[Bindable]
		private var imagesOnComplete : ArrayCollection;
		public var proxyUrl : String;
		public function IPUploadViewControl()
		{
			super();
			nonEditableControl = new UploadedImageSelection();
			editableControl = new UploadSelection();
			uploadImageSelection = nonEditableControl as UploadedImageSelection;
			uploadSelection = editableControl as UploadSelection;
			
			
			uploadImageSelection.addEventListener("upload", handleUploadEvent);
			uploadSelection.addEventListener(CustomFileReferenceList.LIST_COMPLETE, handleUploadDone);
			uploadSelection.addEventListener(CustomFileReferenceList.LIST_CANCEL,handleUploadCancel);
			facadeEvents(editableControl,"change","enter","textInput","valueCommit");
			//handleUploadDone(null);
			if(uploadButton == null)
			{
				uploadButton = new Button();
				uploadButton.setStyle("upSkin", uploadDefSkin);
				uploadButton.setStyle("overSkin", uploadOVerSkin);
				uploadButton.setStyle("downSkin", uploadDefSkin);
				uploadButton.setStyle("disabledSkin", uploadDefSkin);
				uploadButton.addEventListener(MouseEvent.CLICK, handleUploadClicked);
				this.addChild(uploadButton);
			}
		}
		
		public function getUserContentsOnComplete() : void
		{
			var getImages : HTTPService = new HTTPService();
			getImages.url = "/customers/uncategorized/"+HmmChaptersModel.getInstance().userId;
			getImages.addEventListener(ResultEvent.RESULT, handleOncompletGetImagesResult);
			getImages.addEventListener(FaultEvent.FAULT, handleOncompletGetImagesFault);
			var urlVars : URLVariables = new URLVariables();
			urlVars.time = new Date().toTimeString();
			getImages.send(urlVars);
			FadingNotifier.setBusyState();
				
		}
		
		private function handleOncompletGetImagesResult(event : ResultEvent) : void
		{
			var uploadCancel : HTTPService = new HTTPService();
			if(Application.application.parameters.hasOwnProperty("proxyurl"))
				uploadCancel.url = proxyUrl+"/temp_uploads/deletetempcontents/"+HmmChaptersModel.getInstance().userId;//"/user_content/cancelUpload/"+HmmChaptersModel.getInstance().userId;
			else	
				uploadCancel.url = "http://12.156.60.97/temp_uploads/deletetempcontents/"+HmmChaptersModel.getInstance().userId;//"/user_content/cancelUpload/"+HmmChaptersModel.getInstance().userId;
			uploadCancel.addEventListener(ResultEvent.RESULT, handletempresult);
			uploadCancel.addEventListener(FaultEvent.FAULT, handletempFault);
			var obj : Object = new Object();
			obj.id = HmmChaptersModel.getInstance().userId;
			uploadCancel.send(obj);
			if(event.result.images)
			{
				if(event.result.images.image is ArrayCollection)
					imagesOnComplete = event.result.images.image as ArrayCollection;
				else
					imagesOnComplete = new ArrayCollection([event.result.images.image]);
				
				if(imagesOnComplete.length > 0)
				{
					CursorManager.removeBusyCursor();
					Alert.show("There was an error while uploading content on a previous occasion.\n Do you want to pull up those Images now ?.\n Press 'NO'  to send them to Un-Categorized folder.",null, Alert.OK|Alert.NO, null,getUncategorizedOnComplete);	
				}
				else
					FadingNotifier.removeBusyState();
			}	
			else
				FadingNotifier.removeBusyState();
		}
		
		private function handletempresult(event : ResultEvent) : void
		{
			trace(event.message);	
		}
		
		private function handletempFault(event : FaultEvent) : void
		{
			trace(event.message);
		}
		
		private function getUncategorizedOnComplete(event : CloseEvent) : void
		{
			if(event.detail == Alert.OK)
			{
				var files : ArrayCollection = new ArrayCollection();
				for( var i : int = 0; i < imagesOnComplete.length; i++)
				{
					var file : WebFileVO = new WebFileVO();
					
					file.name = imagesOnComplete[i].name;
					file.id = imagesOnComplete[i].id;
					file.type = imagesOnComplete[i].type;
					file.icon = imagesOnComplete[i].icon;
					file.creationDate = new Date(imagesOnComplete[i].creationdate);
					files.addItem(file);
				}
				uploadImageSelection.dataProvider = files;
				//setEditable(!editable,true);
				//uploadButton.visible = false;
				FadingNotifier.removeBusyState();
			}
			else
				FadingNotifier.removeBusyState();
		}
		
		private function handleOncompletGetImagesFault(event : FaultEvent) : void
		{
			trace(event.message);
		}
		
		
		private function handleUploadCancel(event : Event) : void
		{
			Alert.show("Upload cancelled ","Upload Cancelled !!!",Alert.OK,null);
			
		}
		
		private function handleUploadClicked(event : Event) : void
		{
			if(uploadSelection.listOfFiles.length > 0)
			{
				uploadSelection.uploadFiles();
				uploadButton.visible = false;
			}
			else
			 dispatchEvent(new Event("help"));	
			
		}
		
		private function handleUploadDone(event : Event) : void
		{
			Alert.show("Uploading done... Now we will be getting your recently uploaded items.", "Upload Done!!!", Alert.OK, null,getUncategorized);
		}
		
		
		private function getUncategorized(event : CloseEvent) : void
		{
			if(event.detail == Alert.OK)
			{
				var getImages : HTTPService = new HTTPService();
				getImages.url = "/customers/uncategorized/"+HmmChaptersModel.getInstance().userId;
				getImages.addEventListener(ResultEvent.RESULT, handleGetImagesResult);
				getImages.addEventListener(FaultEvent.FAULT, handleGetImagesFault);
				var urlVars : URLVariables = new URLVariables();
				urlVars.time = new Date().toTimeString();
				getImages.send(urlVars);
				FadingNotifier.setBusyState();
			}
		}
		
		private function handleGetImagesResult(event : ResultEvent) : void
		{
			if(event.result.images)
			{
				if(event.result.images.image is ArrayCollection)
					var images : ArrayCollection = event.result.images.image as ArrayCollection;
				else
					images = new ArrayCollection([event.result.images.image]);
				
			}	
			
				
			var files : ArrayCollection = new ArrayCollection();
			if(images)	
			{
				for( var i : int = 0; i < images.length; i++)
				{
					var file : WebFileVO = new WebFileVO();
					
					file.name = images[i].name;
					file.id = images[i].id;
					file.type = images[i].type;
					file.icon = images[i].icon;
					file.creationDate = new Date(images[i].creationdate);
					files.addItem(file);
				}
			}
			
			var lastUploadedImages : ArrayCollection = uploadImageSelection.dataProvider as ArrayCollection;
			if(lastUploadedImages)
				files.source = files.source.concat(lastUploadedImages.source);
			uploadImageSelection.dataProvider = files;
			setEditable(!editable,true);
			uploadButton.visible = false;
			uploadSelection.clearFileList();
			FadingNotifier.removeBusyState();
		}
		
		private function handleGetImagesFault(event : FaultEvent) : void
		{
			trace(event.fault.toString());
			FadingNotifier.removeBusyState();
		}
		
		override protected function commitEditedValue() : void
		{
			
		}
		
		override protected function iconClickHandler(e:Event):void
		{
			if(editable)
			{
				
				
			}else
			{
				super.iconClickHandler(e);
			}
			uploadButton.visible = true;
			uploadSelection.selectFiles(); 
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(uploadButton != null)
			{
				if(_editButton != null)
				{
					uploadButton.y = _editButton.y + _editButton.measuredHeight + 5;
					uploadButton.setActualSize(uploadButton.measuredWidth,uploadButton.measuredHeight);	
				}
				
			}
		}
		
		private function handleUploadEvent(event : Event) : void
		{
			
		}
		
		public function hideControls() : void
		{
			uploadButton.visible = false;
			_editButton.visible = false;
			uploadButton.width = 0;
			_editButton.width = 0;
			editableControl.percentWidth = 100;
			nonEditableControl.percentWidth = 100;
		}
	}
}