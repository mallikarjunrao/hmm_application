package
{
	import mx.collections.ArrayCollection;
	
	public class TimeFlyByDataModel
	{
		
		private static var instance : TimeFlyByDataModel;
		private var _data : Array;
		
		public static function getInstance() : TimeFlyByDataModel 
		{
			if(!instance)
				instance = new TimeFlyByDataModel();
		 	return instance;
		 }
		
		public function TimeFlyByDataModel()
		{
		}
		
		public function set data(arr : ArrayCollection) : void
		{
			_data = arr.source;
		}
		
		public function getdata(startTime : Number, endTime : Number) : ArrayCollection
		{
			for(var i : int = 0; i < _data.length; i++)
			{
				if(_data[i].date >= startTime)
					break;
			}	
			var retArray : Array = new Array();
			for(i = i; i < _data.length; i++)
			{
				if(_data[i].date <= endTime)
				{
					retArray.push(_data[i]);
					
				}else
				{
					break;
				}
					
			}
			return new ArrayCollection(retArray);
		}

	}
}