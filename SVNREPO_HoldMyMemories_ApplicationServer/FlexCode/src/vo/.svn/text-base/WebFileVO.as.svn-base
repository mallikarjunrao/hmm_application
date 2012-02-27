package vo
{
	public class WebFileVO extends BaseVO
	{
		public var creationDate : Date;
		public var type : String;
		public var galleryid  :int;
		public function WebFileVO()
		{
			super();
			classType = "webFileVO";
		}
		
		public function clone() : WebFileVO
		{
			var cl : WebFileVO = new WebFileVO();
			cl.access = this.access;
			cl.classType = this.classType;
			cl.creationDate = this.creationDate;
			cl.description = this.description;
			cl.flag = this.flag;
			cl.galleryid = this.galleryid;
			cl.icon = this.icon;
			cl.id = this.id;
			cl.name = this.name;
			cl.parent = this.parent;
			cl.tags = this.tags;
			cl.type = this.type; 
			return cl;
		}

	}
}