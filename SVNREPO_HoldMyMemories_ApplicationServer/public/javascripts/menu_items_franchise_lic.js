// items structure
// each item is the array of one or more properties:
// [text, link, settings, subitems ...]
// use the builder to export errors free structure if you experience problems with the syntax
//, {'tw':'_top', 'tt':'Welcome Page', 'sb':'Test Status Bar Message'}


var manager_id = document.getElementById("franchiseID").value;
//market manager menu
if(manager_id != 1){
    var MENU_ITEMS = [
    ['Account Settings', null, null,
    ['List Studios', '/hmm_studios/studio_credit_list'],
    ['Edit Profile', '/hmm_studiogroups/studiogroup_editprofile'],
    ['Change Password', '/hmm_studiogroups/studiogroup_changepassword'],
    ['License Agreement', '/hmm_studiogroups/license_form'],
    ['Studio Credits', '/hmm_studios/franchise_credit_list'],
    ['Studio Benefit Management', '/studio_benefits/list'],


    ],
    ['Reports', null, null,
    ['Commission Report', '/account/othercommissionsownerReport'],

    ],
    ['Ecommerce', null, null,
    ['Manage Sales Tax', '/hmm_studios/studio_list'],
    ['Manage Sizes & Prices', '/print_size_prices/franchise_list/'],
    ['Manage Shipping Prices', '/hmm_studiogroups/shipping_price_list/'],
    ['Manage Coupons', '/cupons/list_studiocoupons'],
    ['Coupon Reports', '/cupons/studio_ecommerce_coupon_report'],
    ['Manage Orders', '/hmm_studiogroups/order_details'],

    ],
    ['iPhone App', null, null,
    ['Home', '/hmm_studiogroups/manage_studio_logo'],

    ],
    ];
}
else
    var MENU_ITEMS = [
    ['Account Settings', null, null,
    ['List Studios', '/hmm_studios/studio_credit_list'],
    ['Edit Profile', '/hmm_studiogroups/studiogroup_editprofile'],
    ['Change Password', '/hmm_studiogroups/studiogroup_changepassword'],
    ['License Agreement', '/hmm_studiogroups/license_form'],
    ['Studio Credits', '/hmm_studios/franchise_credit_list'],
    ],
   
    ['Reports', null, null,
    ['Commission Report', '/account/othercommissionsownerReport'],

    ],
    ['iPhone App', null, null,
    ['Home', '/hmm_studiogroups/manage_studio_logo'],

    ],

    ];