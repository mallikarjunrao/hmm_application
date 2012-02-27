// items structure
// each item is the array of one or more properties:
// [text, link, settings, subitems ...]
// use the builder to export errors free structure if you experience problems with the syntax
//, {'tw':'_top', 'tt':'Welcome Page', 'sb':'Test Status Bar Message'}
var access_level = document.getElementById("access_level").value;
// ********************** this is for master admin .. please add link in both if and else places *******************************************************
if(access_level==1)
{
    var MENU_ITEMS = [

    ['Admin Home', '/account/index1', null,
    ],

    ['Account Settings', null, null,
    ['Edit my profile','/users/edit'
    ],
    // this is how custom javascript code can be called from the item
    // note how apostrophes are escaped inside the string, i.e. 'Don't' must be 'Don\'t'
    ['Add Studio Owner', '/account/new_hmmgroup', null,],
    ['List Studio Owners', '/account/list_hmmgroup', null,],
    ['Add HMM Studios', '/hmm_studios/adminstudio_signup', null,],
    ['list HMM Studios', '/hmm_studios/list', null,],
    ['Upload Studio Logos', '/hmm_studios/studio_list_upload_logo', null,],
    ['HMM Studios Credits', '/credit_points/credit_list', null,],
    ['Add Store Manager / Employee', '/employe_accounts/new', null,],
    ['Add Market Manager', '/market_managers/new', null,],
    ['Store Manager/Employee Rights', '/employe_accounts/list'],
    ['Market Manager Rights', '/market_managers/list'],
    ['Add Business Manager', '/business_managers/new', null,],
    ['Link HMM Users to Studios', '/account/link_list'],
    ['Upgrade Customers Account', '/account/coupon_upgrade_search'],
    ['Users Information', '/account/list'],
    ['Premium Customers', '/account/premium_customer'],
    ['Sales Person Login', '/sales_person/list_salesperson'],
    ['Admin User Login', '/users/listout'],
    ['Support Admin Login', '/users/listout_admin_supports'],


    ],
    ['Content Management', null, null,
    // this is how item scope settings are defined
    ['FAQ\'s Management', '/faqs/list'],
    // this is how multiple item scope settings are defined
    ['Tips Management', '/tips/list'],
    ['Studio Benefit Management', '/studio_benefits/select_group'],
    ['Add Contest Winners', '/contest_admin/contest_winners'],
    ['Home For Holiday Photo Contest', '/contest_admin/contest_photolist/14'],
    ['Home For Holiday Video Contest', '/contest_admin/contest_videolist/14'],
    ['Cute Kids Photo Contest', '/contest_admin/contest_photolist/15'],
    ['Cute Kids Video Contest', '/contest_admin/contest_videolist/15'],

    ],
    ['Ecommerce', null, null,
    ['Manage HMM Sales Tax', '/products/manage_hmm_adminsalestax'],
    ['Manage Studio Sales Tax', '/products/manage_studio_adminsalestax'],
    ['Manage Print Sizes', '/print_sizes/list_sizes'],
    ['Manage Print Prices', '/print_size_prices/list'],
    ['Manage Default Shipping Price', '/products/default_shipping'],
    ['Manage Shipping Prices', '/hmm_studiogroups/admin_shipping_price_list/0'],
    ['Manage Coupons', '/cupons/list_coupons'],
    ['Coupon Reports', '/cupons/ecommerce_coupon_report'],
    ['Manage Orders', '/manage_orders/details'],

    ],
    ['Admin Reports', null, null,
    ['Customers Login Report', '/account/login_report'],
    ['Customers Report', '/account/list'],
    ['Number of Guests Report', '/account/guestReport'],
    ['Media Report', '/account/statReport'],
    ['Chapter Report', '/account/chapReport'],
    ['Contest Report', '/account/contestReport'],
    ['Commission Report', '/account/commissionReport_new'],
    ['Other Studios Commission Report', '/account/othercommissionReport'],
    ['Family Website Share Report', '/familywebsite_shares/list'],
    ['HMM Reporting', '/account/hmm_reporting'],
    ['Orders Report', '/manage_orders/orders_report'],
    ['Credit Report', '/credit_points/credit_report'],
    ['Credits Used Report', '/credit_points/used_credits'],
    ['Zipcodes Log', '/account/zipcodeReport'],
    ['Sales Person Report', '/hmm_studios/membership_sold_accounts_admin'],
    ['Social Networking Share Report', '/social_networkings/display_counts'],
    ['Account cancellation Report', '/account/track_account'],
    ['Account Status Report', '/hmm_studios/created_customers_report'],
    ['Account Upgrade Report', '/hmm_studios/upgraded_customers_report'],
    ['Account Setup Report Photos', '/hmm_studios/account_setup_report'],
    ['Account Setup Report Videos', '/hmm_studios/account_setup_report_video'],
    ['User Content Zip Report', '/contest_admin/show_order_zip'],
    ],
    ['Statistical Reports', null, null,
    ['Media Management', '/account/statReport'],
    ['Chapter Management', '/account/chapReport'],
    ['Comment Management', '/account/commentReport'],
    //User Session Management', '/account/sessionReport
    ['Statistical Report', '/account/fnf_index'],
    //['Customers Email Report', '/account/platinum_user_excel'],
    ['Customers Email Report', '/hmm_studios/email_report'],
    ['Feeds Report', '/account/feed_report'],
    ['Gift Coupon Users Report', '/account/coupon_userlist'],
    ['Template measurement', '/account/template_measurement'],
    ['Account setup new v/s repeat', '/hmm_studios/account_setup_new_repeat_report'],
    ['Reactivation Report', '/account/activation_report'],
    ['No. of Premium Subscriptions', '/hmm_studios/premium_subscriptions'],
    ['Contest Share Report', '/account/contest_shares'],
    ['Upload & Import Count Report', '/account/upload_import_counts'],
    ['iPhone App', '/manage_mobile_studios/show_studios_app'],
    ['Memory Lane iPhone App', '/manage_mobile_studios/ml_app'],



    ],
    ['Coupons & Gift Certificates', null, null,
    ['Generate Coupon', '/cupons/new'],
    ['Create Offer Account', '/account/admin_verify_cuponID'],
    ['Generate Promo Codes', '/hmm_studiogroups/promocode_form'],
    ['Manage Gift Certificates', '/gift_certificates/manage_gift_certificates'],
    ['Manage Purchased Gift Certificates', '/gift_certificates/studio_certificates_details?t=1'],
    ],

    ];
}
else
{
    var MENU_ITEMS = [

    ['Admin Home', '/account/index1', null,
    ],

    ['Account Settings', null, null,
    ['Edit my profile','/users/edit'
    ],
    // this is how custom javascript code can be called from the item
    // note how apostrophes are escaped inside the string, i.e. 'Don't' must be 'Don\'t'
    ['Add Studio Owner', '/account/new_hmmgroup', null,],
    ['List Studio Owners', '/account/list_hmmgroup', null,],
    ['Add HMM Studios', '/hmm_studios/adminstudio_signup', null,],
    ['list HMM Studios', '/hmm_studios/list', null,],
    ['Upload Studio Logos', '/hmm_studios/studio_list_upload_logo', null,],
    ['HMM Studios Credits', '/credit_points/credit_list', null,],
    ['Add Store Manager / Employee', '/employe_accounts/new', null,],
    ['Add Market Manager', '/market_managers/new', null,],
    ['Store Manager/Employee Rights', '/employe_accounts/list'],
    ['Market Manager Rights', '/market_managers/list'],
    ['Add Business Manager', '/business_managers/new', null,],
    ['Link HMM Users to Studios', '/account/link_list'],
    ['Upgrade Customers Account', '/account/coupon_upgrade_search'],
    ['Users Information', '/account/list'],
    ['Premium Customers', '/account/premium_customer'],
    ['Sales Person Login', '/sales_person/listout_admin_supports'],


    ],
    ['Content Management', null, null,
    // this is how item scope settings are defined
    ['FAQ\'s Management', '/faqs/list'],
    // this is how multiple item scope settings are defined
    ['Tips Management', '/tips/list'],
    ['Studio Benefit Management', '/studio_benefits/select_group'],
    ['Home For Holiday Photo Contest', '/contest_admin/contest_photolist/14'],
    ['Home For Holiday Video Contest', '/contest_admin/contest_videolist/14'],
    ['Cute Kids Photo Contest', '/contest_admin/contest_photolist/15'],
    ['Cute Kids Video Contest', '/contest_admin/contest_videolist/15'],

    ],
    ['Ecommerce', null, null,
    ['Manage HMM Sales Tax', '/products/manage_hmm_adminsalestax'],
    ['Manage Studio Sales Tax', '/products/manage_studio_adminsalestax'],
    ['Manage Print Sizes', '/print_sizes/list_sizes'],
    ['Manage Print Prices', '/print_size_prices/list'],
    ['Manage Default Shipping Price', '/products/default_shipping'],
    ['Manage Shipping Prices', '/hmm_studiogroups/admin_shipping_price_list/0'],
    ['Manage Coupons', '/cupons/list_coupons'],
    ['Coupon Reports', '/cupons/ecommerce_coupon_report'],
    ['Manage Orders', '/manage_orders/details'],

    ],
    ['Admin Reports', null, null,
    ['Customers Login Report', '/account/login_report'],
    ['Customers Report', '/account/list'],
    ['Number of Guests Report', '/account/guestReport'],
    ['Media Report', '/account/statReport'],
    ['Chapter Report', '/account/chapReport'],
    ['Contest Report', '/account/contestReport'],
    ['Commission Report', '/account/commissionReport_new'],
    ['Other Studios Commission Report', '/account/othercommissionReport'],
    ['Family Website Share Report', '/familywebsite_shares/list'],
    ['HMM Reporting', '/account/hmm_reporting'],
    ['Orders Report', '/manage_orders/orders_report'],
    ['Credit Report', '/credit_points/credit_report'],
    ['Credits Used Report', '/credit_points/used_credits'],
    ['Zipcodes Log', '/account/zipcodeReport'],
    ['Sales Person Report', '/hmm_studios/membership_sold_accounts_admin'],
    ['Social Networking Share Report', '/social_networkings/display_counts'],
    ['Account cancellation Report', '/account/track_account'],
    ['Account Status Report', '/hmm_studios/created_customers_report'],
    ['Account Upgrade Report', '/hmm_studios/upgraded_customers_report'],
    ['Account Setup Report Photos', '/hmm_studios/account_setup_report'],
    ['Account Setup Report Videos', '/hmm_studios/account_setup_report_video'],
    ['User Content Zip Report', '/contest_admin/show_order_zip'],
    ],
    ['Statistical Reports', null, null,
    ['Media Management', '/account/statReport'],
    ['Chapter Management', '/account/chapReport'],
    ['Comment Management', '/account/commentReport'],
    //User Session Management', '/account/sessionReport
    ['Statistical Report', '/account/fnf_index'],
    //['Customers Email Report', '/account/platinum_user_excel'],
    ['Customers Email Report', '/hmm_studios/email_report'],
    ['Feeds Report', '/account/feed_report'],
    ['Gift Coupon Users Report', '/account/coupon_userlist'],
    ['Template measurement', '/account/template_measurement'],
    ['Account setup new v/s repeat', '/hmm_studios/account_setup_new_repeat_report'],
    ['Reactivation Report', '/account/activation_report'],
    ['No. of Premium Subscriptions', '/hmm_studios/premium_subscriptions'],
    ['Contest Share Report', '/account/contest_shares'],
    ['Upload & Import Count Report', '/account/upload_import_counts'],
    ['iPhone App', '/manage_mobile_studios/show_studios_app'],
    ['Memory Lane iPhone App', '/manage_mobile_studios/ml_app'],


    ],
    ['Coupons', null, null,
    ['Generate Coupon', '/cupons/new'],
    ['Create Offer Account', '/account/admin_verify_cuponID'],
    ['Generate Promo Codes', '/hmm_studiogroups/promocode_form'],
    ['Manage Gift Certificates', '/gift_certificates/manage_gift_certificates'],
    ['Manage Purchased Gift Certificates', '/gift_certificates/studio_certificates_details'],
    ],

    ];
}