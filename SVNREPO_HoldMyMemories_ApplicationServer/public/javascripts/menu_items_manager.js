// items structure
// each item is the array of one or more properties:
// [text, link, settings, subitems ...]
// use the builder to export errors free structure if you experience problems with the syntax
//, {'tw':'_top', 'tt':'Welcome Page', 'sb':'Test Status Bar Message'}


var manager_id = document.getElementById("managerID").value;
//market manager menu
{
    var MENU_ITEMS = [
    ['Account Settings', null, null,
    ['Edit my profile','/market_managers/edit_manager/'+manager_id
    ],
    // this is how custom javascript code can be called from the item
    // note how apostrophes are escaped inside the string, i.e. 'Don't' must be 'Don\'t'
    ['My Employees', '/market_managers/my_employee'],
    //Users Information', '/account/customer_list
    ],
    ['Reports', null, null,

    ['Commission Report', '/account/commissionReport_market_manager/'+manager_id],
    ['Acount Setup Report Photos', '/hmm_studios/studiomarket_account_setup_report'],
    ['Acount Setup Report Videos', '/hmm_studios/studiomarket_account_setup_report_video'],
    ['Studio Customers', '/account/studio_customers_report'],
    ['Acount Status Report', '/hmm_studios/created_customers_report'],
    ['Orders Report', '/manage_orders/market_orders_report'],
    ['Cancellation Report', '/hmm_studios/market_pending_requests_admin'],
    // this is how item scope settings are defined
    //Create Customer Account', '/account/verify_emp/'],
    //Create Offer Account', '/account/verify_cuponID/'],
    // this is how multiple item scope settings are defined
    //My Customers', '/account/my_customers'],
    //Premium account users', '/account/premium_users'],
    ],

    ];
}


