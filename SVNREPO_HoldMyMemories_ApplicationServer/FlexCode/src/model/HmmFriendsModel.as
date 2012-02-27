package model
{
	import mx.collections.ArrayCollection;
	
	import vo.FriendsVO;
	import vo.GroupsVO;
	
	public class HmmFriendsModel 
	{
		private static var instance : HmmFriendsModel;
		private var friendsArray : Array;
		public var initialized : Boolean = false;
		public function HmmFriendsModel()
		{
			super();
			friendsArray = [];
		}
		
		public static function getInstance() : HmmFriendsModel
		{
			if(instance == null)
				instance = new HmmFriendsModel();
			
			return instance;
		}
		
		public function set friendsData( value : Object) : void
		{
			getGroupsList(value);
		}
		
		public function get friendsData() : Object
		{
			return new ArrayCollection(friendsArray);
		}
		
		public function set combinedFriendsList(value : ArrayCollection) : void
		{
			friendsArray = value.source;
		}
		
		public function clearModel() : void
		{
			friendsArray = [];
			initialized = false;
		}
		
		/* private function getFriendsList( value : Object) : void
		{
			if(value is ArrayCollection)
			{
				var friends : ArrayCollection = value as ArrayCollection;
				for(var i : int = 0; i < friends.length; i++)
				{
					var friend : FriendsVO = new FriendsVO();
					friend.icon = friends[i].icon;
					friend.name = friends[i].name;
					friend.email = friends[i].email;
					friend.id = friends[i].id;
					friendsArray.push(friend);					
				}
			}else
			{
				var friend : FriendsVO = new FriendsVO();
				friend.icon = value.icon;
				friend.name = value.name;
				friend.email = value.email;
				friend.id = value.id;
				friendsArray.push(friend);			
			
			}
			
			initialized = false;
		} */
		
		private function getFriendsList(value : Object) : Array
		{
			var friends : Array = new Array();
			if(!value)
			 return null;
			if(value is ArrayCollection)
			{
				var friendsList : ArrayCollection = value as ArrayCollection;
				for(var f : int = 0; f < friendsList.length; f++)
				{
				  	   var friend : FriendsVO = new FriendsVO();
				  	   friend.icon = friendsList[f].icon;
				  	   friend.name = friendsList[f].name;
				  	   friend.email = friendsList[f].email;
				  	   friend.id = friendsList[f].id;
				  	   friends.push(friend);
				}
			}
			else
			{
				
				var friend : FriendsVO = new FriendsVO();
				friend.icon = value.icon;
				friend.name = value.name;
				friend.email = value.email;
				friend.id = value.id;
				friends.push(friend);
			}
			
			return friends;
		}
		
		
		private function getGroupsList( value : Object) : void
		{
			if(value.group is ArrayCollection)
			{
			  var groups : ArrayCollection = value.group as ArrayCollection;
			  for(var g : int = 0; g < 	groups.length; g++)
			  {
			  	var group : GroupsVO = new GroupsVO();
			  	group.name = groups[g].name;
			  	group.friends = getFriendsList(groups[g].friend);
			  	friendsArray.push(group);
			  }
			}
			else
			{
				if(!value)
				 return;
				var group : GroupsVO = new GroupsVO();
			  	group.name = value.group.name;
			  	group.friends = getFriendsList(value.group.friend);
			  	friendsArray.push(group);
			}
			initialized = false;
		}
	}
}