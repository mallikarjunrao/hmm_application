// items structure
// each item is the array of one or more properties:
// [text, link, settings, subitems ...]
// use the builder to export errors free structure if you experience problems with the syntax
//, {'tw':'_top', 'tt':'Welcome Page', 'sb':'Test Status Bar Message'}

var type = document.getElementById("emp_type").value;
var emp_id = document.getElementById("userID").value;
var studio_group = document.getElementById("studio_group").value;

//store manager menu
if (type > 0){
    if (studio_group!=1){
        var MENU_ITEMS = [
        ['Account Settings', null, null,
        ['Edit my profile','/employe_accounts/edit'
        ],

        ],
        ['Orders', null, null,
        ['Manage Orders', '/manage_orders/studio_orders_details'],
        ['Manage Sales Tax & Print Order', '/products/manage_studiosalestax'],
        ['Manage Print Prices', '/print_size_prices/studio_price_list'],

        ['Manage Shipping Prices', '/products/shipping_price_list_group'],
        ],

        ['Customer Report', null, null,
        // this is how item scope settings are defined
        ['Create Customer Account', '/account/verify_emp/'],
        ['Create Offer Account', '/account/verify_cuponID/'],
        // this is how multiple item scope settings are defined
        ['My Customers', '/account/my_customers'],
        ['Premium account users', '/account/premium_users'],
        ['Commission Report', '/account/othercommissionstudioReport'],
        ['Credit Report', '/credit_points/studio_credit_report'],
        ['Credits Used Report', '/credit_points/used_credits'],
        ['Studio Customers', '/account/studio_customers_report'],
        ['Studio Management Customers', '/account/studio_management_customers'],
        ['Studio Premium Customers', '/account/studio_premium_customers_report'],
        ['Sales Person Report', '/hmm_studios/membership_sold_accounts_studio'],
        ['Cancellation Report', '/hmm_studios/studio_pending_requests_admin'],
        ['Account Setup Report Photos', '/hmm_studios/studio_account_setup_report'],
        ['Account Setup Report Videos', '/hmm_studios/studio_account_setup_report_video'],
        ],
        /*['Mobile', null, null,
        // this is how item scope settings are defined
        ['Upload mobile studio logo', '/manage_mobile_studios/manage_studio_logo'],
        ['Manage about us', '/manage_mobile_studios/manage_aboutus'],
        ['Manage studio specials', '/manage_mobile_studios/manage_studio_specials'],
        ['Manage studio portfolios', '/manage_mobile_studios/manage_studio_portfolios'],
        ['Acount Setup Report Photos', '/hmm_studios/studio_account_setup_report'],
        ['Acount Setup Report Videos', '/hmm_studios/studio_account_setup_report_video'],

        ],*/
        ['Studio iPhone App', null, null,
        // this is how item scope settings are defined
        ['Home', '/manage_mobile_studios/home/'],
        ],
        ['Upgrade Account', null, null,
        // this is how item scope settings are defined
        ['Upgrade Customer Account', '/employe_accounts/upgrade_account/'],
        ],
        ['Gift Certificates', null, null,
        // this is how item scope settings are defined
        ['Manage Gift Certificates', '/gift_certificates/manage_gift_certificates'],
        ['Manage Purchased Gift Certificates', '/gift_certificates/studio_certificates_details'],
        ],
        ];
    }else{
        var MENU_ITEMS = [
        ['Account Settings', null, null,
        ['Edit my profile','/employe_accounts/edit'
        ],

        ],
        ['Ecommerce', null, null,
        ['Manage Orders', '/manage_orders/studio_orders_details'],
        ['Manage Sales Tax', '/products/manage_studiosalestax'],
        ['Manage Print Prices', '/print_size_prices/studio_price_list'],

        ['Manage Shipping Prices', '/products/shipping_price_list_group'],
        ],

        ['Customer Report', null, null,
        // this is how item scope settings are defined
        ['Create Customer Account', '/account/verify_emp/'],
        ['Create Offer Account', '/account/verify_cuponID/'],
        // this is how multiple item scope settings are defined
        ['My Customers', '/account/my_customers'],
        ['Studio Customers', '/account/studio_customers_report'],
        ['Premium account users', '/account/premium_users'],
        ['Commission Report', '/account/commissionReport_studio_manager'],
        ['Credit Report', '/credit_points/studio_credit_report'],
        ['Credits Used Report', '/credit_points/used_credits'],
        ['Studio Customers', '/account/studio_customers_report'],
        ['Studio Management Customers', '/account/studio_management_customers'],
        ['Studio Premium Customers', '/account/studio_premium_customers_report'],
        ['Sales Person Report', '/hmm_studios/membership_sold_accounts_studio'],
        ['Cancellation Report', '/hmm_studios/membership_sold_accounts_studio'],
        ['Account Setup Report Photos', '/hmm_studios/studio_account_setup_report'],
        ['Account Setup Report Videos', '/hmm_studios/studio_account_setup_report_video'],
        ],
        /* ['Mobile', null, null,
        // this is how item scope settings are defined
        ['Upload mobile studio logo', '/manage_mobile_studios/manage_studio_logo'],
        ['Manage about us', '/manage_mobile_studios/manage_aboutus'],
        ['Manage studio specials', '/manage_mobile_studios/manage_studio_specials'],
        ['Manage studio portfolios', '/manage_mobile_studios/manage_studio_portfolios'],

        ],*/
        ['Studio iPhone App', null, null,
        // this is how item scope settings are defined
        ['Home', '/manage_mobile_studios/home/'],
        ],
        ['Upgrade Account', null, null,
        // this is how item scope settings are defined
        ['Upgrade Customer Account', '/employe_accounts/upgrade_account/'],
        ],
        ['Gift Certificates', null, null,
        // this is how item scope settings are defined
        ['Manage Gift Certificates', '/gift_certificates/manage_gift_certificates'],
        ['Manage Purchased Gift Certificates', '/gift_certificates/studio_certificates_details'],
        ],
        ];
    }
}
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

    ['Ecommerce', null, null,
    ['Manage Orders', '/manage_orders/studio_orders_details'],
    ['Manage Sales Tax', '/products/manage_studiosalestax'],
    ['Manage Print Prices', '/print_size_prices/studio_price_list'],

    ['Manage Shipping Prices', '/products/shipping_price_list_group'],
    ],
    ['Customer Report', null, null,
    // this is how item scope settings are defined
    ['Create Customer Account', '/customers/authorise_verify'],
    ['Create Offer Account', '/account/verify_cuponID'],
    // this is how multiple item scope settings are defined
    ['My Customers', '/account/my_customers'],
    ['Credit Report', '/credit_points/studio_credit_report'],
    ['Studio Customers', '/account/studio_customers_report'],
    ['Studio Management Customers', '/account/studio_management_customers'],
    ['Studio Premium Customers', '/account/studio_premium_customers_report'],
    ['Sales Person Report', '/hmm_studios/membership_sold_accounts_studio'],
    ['Cancellation Report', '/hmm_studios/studio_pending_requests_admin'],
    ['Account Setup Report Photos', '/hmm_studios/studio_account_setup_report'],
    ['Account Setup Report Videos', '/hmm_studios/studio_account_setup_report_video'],
    ],
    ['Studio iPhone App', null, null,
    // this is how item scope settings are defined
    ['Home', '/manage_mobile_studios/home/'],
    ],
    ['Upgrade Account', null, null,
    // this is how item scope settings are defined
    ['Upgrade Customer Account', '/employe_accounts/upgrade_account/'],
    ],
    ['Gift Certificates', null, null,
    // this is how item scope settings are defined
    ['Manage Gift Certificates', '/gift_certificates/manage_gift_certificates'],
    ['Manage Purchased Gift Certificates', '/gift_certificates/studio_certificates_details'],
    ],

    /*['Mobile', null, null,
    // this is how item scope settings are defined
    ['Upload mobile studio logo', '/manage_mobile_studios/manage_studio_logo'],
    ['Manage about us', '/manage_mobile_studios/manage_aboutus'],
    ['Manage studio specials', '/manage_mobile_studios/manage_studio_specials'],
    ['Manage studio portfolios', '/manage_mobile_studios/manage_studio_portfolios'],

    ],*/

    ];
