// items structure
// each item is the array of one or more properties:
// [text, link, settings, subitems ...]
// use the builder to export errors free structure if you experience problems with the syntax
//, {'tw':'_top', 'tt':'Welcome Page', 'sb':'Test Status Bar Message'}

var type = document.getElementById("emp_type").value;
var emp_id = document.getElementById("userID").value;
//store manager menu
if (type > 0){
	var MENU_ITEMS = [
	['Account Settings', null, null,
		['Edit my profile','/employe_accounts/edit'
		],
		// this is how custom javascript code can be called from the item
		// note how apostrophes are escaped inside the string, i.e. 'Don't' must be 'Don\'t'
		['S121 Employee', '/employe_accounts/list1'],
		//Users Information', '/account/customer_list
	],
	['Customer Report', null, null,
		// this is how item scope settings are defined
		['Create Customer Account', '/account/verify_emp/'],
		['Create Offer Account', '/account/verify_cuponID/'],
		// this is how multiple item scope settings are defined
		['My Customers', '/account/my_customers'],
		['Premium account users', '/account/premium_users'],
	],
	
];}
else
//Employee menu
var MENU_ITEMS = [
	['Account Settings', null, null,
		['Edit my profile','/employe_accounts/edit'
		],
		// this is how custom javascript code can be called from the item
		// note how apostrophes are escaped inside the string, i.e. 'Don't' must be 'Don\'t'
		
		//Users Information', '/account/list
	],
	['Customer Report', null, null,
		// this is how item scope settings are defined
		['Create Customer Account', '/customers/authorise_verify'],
		['Create Offer Account', '/account/verify_cuponID'],
		// this is how multiple item scope settings are defined
		['My Customers', '/account/my_customers'],
		
	],
	
];


