function Toggle(id1,id2) {
    obj=document.getElementById(id1);
    obj2=document.getElementById(id2);

   if ((obj.style.display=='block') || obj2.style.border!='1px solid #C7C7C7'){
    obj.style.display='none';
    obj2.style.border='1px solid #C7C7C7';
   }

  }

  function divToggleOpen(id){

     obj=document.getElementById(id);
     obj.style.display='block';
     document.getElementById(id+'.open').style.display='none';
     document.getElementById(id+'.close').style.display='block';


  }
  function divToggleClose(id){

     obj=document.getElementById(id);
     obj.style.display='none';
     document.getElementById(id+'.open').style.display='block';
     document.getElementById(id+'.close').style.display='none';


  }

  $(function() {
    $("#date_of_order").datepicker({
   onSelect: function(dateText) {setAnchor('timing'); this.form.submit(); },
   defaultDate: +1,
   duration: 'fast',
   minDate: +<%= Time.now.hour > 18 ? 2 : 1 %>  <% if @params[:delivery_method] == "delivery" %>,
   beforeShowDay: $.datepicker.noWeekends
<% end -%>
});
});

 function validateForm( frm ){

    var errMsg = "";

    var store1 = document.getElementById("store1").checked
    var store2 = document.getElementById("store2").checked

    if( (store1 == false) && (store2 == false)) {
      document.getElementById("store").style.display='block';
     // document.getElementById("store1").focus();
      //document.getElementById("last_name").style.border='1px solid red';
      errMsg += "store1,";
    }
    else {
      document.getElementById("store").style.display='none';
    }

    var pick_up = document.getElementById("delivery_method_pickup").checked
    var delivery = document.getElementById("delivery_method_delivery").checked
    if((pick_up == false) && (delivery == false)) {
      document.getElementById("dmethod").style.display='block';
     // document.getElementById("delivery_method_pickup").focus();
      errMsg += "delivery_method_pickup,";
    }
    else {
      document.getElementById("dmethod").style.display='none';
    }

    var time_of_order = document.getElementById("time_of_order").value
    if( time_of_order == "Select" ) {
      document.getElementById("tdorder").style.display='block';
      //document.getElementById("time_of_order").focus();
       errMsg += "time_of_order,";
    }
    else {
      document.getElementById("tdorder").style.display='none';
    }

    // enforce next day order before 6pm
    var date_of_order = document.getElementById("date_of_order").value
    var tomorrow = new Date();
    tomorrow.setTime(tomorrow.getTime() + (1000*3600*24));
    //alert( + " - " + );
    var orderDate = date_of_order.substring(0,10);
    tomorrow = ((tomorrow.getMonth()+1) < 10 ? ("0"+(tomorrow.getMonth()+1)) : (tomorrow.getMonth()+1)) + "/"+ (tomorrow.getDate() < 10 ? "0"+tomorrow.getDate() : tomorrow.getDate())+"/"+ (tomorrow.getYear()+1900)
    //var curTime = new Date()
    //var curr_hour = curTime.getHours();
    <%
    t = Time.now
    cst = (t.gmtime) - (60*60*6)
    %>
    if(orderDate == tomorrow && <%= cst.hour %> > 17 ){
      document.getElementById("dorder").style.display='block';
     // document.getElementById("dorder").focus();
     errMsg += "date_of_order,";
    }

    // counting specials
   var totalSpecials = 0;

   for (var i = 0; i < frm.elements.length; i++) {
     if (frm.elements[i].type == "text" && frm.elements[i].name.indexOf("specials") != -1 && (! isNaN(parseInt(frm.elements[i].value)))) {
       totalSpecials += parseInt(frm.elements[i].value);
     }
   }

   // if specials are not selected count cupcakes
   if(totalSpecials == 0){
     var totalCupcakes = 0;

     for (var i = 0; i < frm.elements.length; i++) {
       if (frm.elements[i].type == "text" && frm.elements[i].name.indexOf("cupcakes") != -1 && (! isNaN(parseInt(frm.elements[i].value)))) {
         totalCupcakes += parseInt(frm.elements[i].value);
       }
     }

     if( totalCupcakes < 12 ){
       if (document.getElementById("ocupcakes") ){

       document.getElementById("ocupcakes").style.display='block';
      // document.getElementById("ocupcakes").focus();
       errMsg += "specials[1],";
      }
       //errMsg += "* You must order at least 12 cupcakes (or a seasonal box, if available).\n";
     }
     else {
       if (document.getElementById("ocupcakes") ){
       document.getElementById("ocupcakes").style.display='none';
       }
     }
   }
   else {
     if (document.getElementById("ocupcakes") ){
       document.getElementById("ocupcakes").style.display='none';
       }
   }


        // calling function chk all quantities are numerical
   if(chk_qtys() == true){

     if (document.getElementById("isordernumeric") ){

       document.getElementById("isordernumeric").style.display='block';
       //document.getElementById("shipto_first_name").focus();
       errMsg += "specials[2],";
      }
       //errMsg += "* You must order at least 12 cupcakes (or a seasonal box, if available).\n";
     }
     else {
       if (document.getElementById("isordernumeric") ){
       document.getElementById("isordernumeric").style.display='none';

       }
     }


   //confirm minimum 12 in order

    // if is_how_to_boxed clicked then how_to_boxed is required
     var com = document.getElementById("is_how_to_boxed");
     if (com != null){
       var is_how_to_boxed = document.getElementById("is_how_to_boxed").checked;
       var how_to_boxed = document.getElementById("how_to_boxed").value;

        if( is_how_to_boxed == true && how_to_boxed.length == 0) {
          document.getElementById("howbox").style.display='block';
          document.getElementById("how_to_boxed").style.border='1px solid red';
         // document.getElementById("how_to_boxed").focus();
          errMsg += "how_to_boxed,";

        }
        else {
          document.getElementById("howbox").style.display='none';
          document.getElementById("how_to_boxed").style.border='1px solid #C7C7C7';
        }
     }

    var firstName = document.getElementById("first_name").value;
    if( firstName.length == 0 ) {
      //document.getElementById("a").value="* Please enter your first name.\n"
      document.getElementById("fname").style.display='block';
      document.getElementById("first_name").style.border='1px solid red';
     // document.getElementById("first_name").focus();
      errMsg += "first_name,";
    }
    else{
      document.getElementById("fname").style.display='none';
      document.getElementById("first_name").style.border='1px solid #C7C7C7';
    }
    var lastName = document.getElementById("last_name").value;
    if( lastName.length == 0 ) {
      document.getElementById("lname").style.display='block';
      document.getElementById("last_name").style.border='1px solid red';
      //document.getElementById("last_name").focus();
      errMsg += "last_name,";
    }
    else {
      document.getElementById("lname").style.display='none';
      document.getElementById("last_name").style.border='1px solid #C7C7C7';
    }
    var emAddress = document.getElementById("email").value;
    if((emAddress.indexOf('@') == -1) || (emAddress.indexOf('.') == -1)) {
      document.getElementById("cemail").style.display='block';
      document.getElementById("email").style.border='1px solid red';
     // document.getElementById("email").focus();
      errMsg += "email,";
    }
    else {
      document.getElementById("cemail").style.display='none';
      document.getElementById("email").style.border='1px solid #C7C7C7';
    }
    var phone = document.getElementById("primary_phone").value + document.getElementById("alt_phone").value;
    if( phone.length == 0 ) {
      document.getElementById("phone").style.display='block';
      document.getElementById("primary_phone").style.border='1px solid red';
      //document.getElementById("primary_phone").focus();
      errMsg += "primary_phone,";
    }
    else {
      document.getElementById("phone").style.display='none';
      document.getElementById("primary_phone").style.border='1px solid #C7C7C7';
    }
    //confirm delivery address
    var isDelivery = document.getElementById("delivery_method_delivery").checked == true;
   if (isDelivery ) {

    // if shipto_is_business clicked then shipto_business required
    var shipto_biz = document.getElementById("shipto_is_business").checked==true;
    if(shipto_biz && document.getElementById("shipto_business").value == ""){

      document.getElementById("bussines").style.display='block';
      document.getElementById("shipto_business").style.border='1px solid red';
      //document.getElementById("shipto_business").focus();
      errMsg += "shipto_business,";
    }
    else {
      document.getElementById("bussines").style.display='none';
      document.getElementById("shipto_business").style.border='1px solid #C7C7C7';
    }

    var shipto_first = document.getElementById("shipto_first_name").value;
    var shipto_last = document.getElementById("shipto_last_name").value;
    var shipto_addr = document.getElementById("shipto_address_1").value;
    var shipto_zip = document.getElementById("shipto_zip").value;
    var isDeliveryInfoComplete = shipto_first == "" | shipto_last == "" | shipto_addr == "" | shipto_zip == "";

     //if (isDeliveryInfoComplete) {
       //errMsg += "* You have indicated that this order will be delivered. Please fill in the delivery address fields: first and last name, street address, and zip are required.\n";
     //}
     if (shipto_first==""){
       document.getElementById("sfname").style.display='block';
      document.getElementById("shipto_first_name").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_first_name,";
     }
     else {
       document.getElementById("sfname").style.display='none';
      document.getElementById("shipto_first_name").style.border='1px solid #C7C7C7';
     }

     if (shipto_last==""){
       document.getElementById("slname").style.display='block';
      document.getElementById("shipto_last_name").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_last_name,";
     }
     else {
       document.getElementById("slname").style.display='none';
      document.getElementById("shipto_last_name").style.border='1px solid #C7C7C7';
     }

     if (shipto_addr==""){
       document.getElementById("sadd").style.display='block';
      document.getElementById("shipto_address_1").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_address_1,";
     }
     else {
       document.getElementById("sadd").style.display='none';
      document.getElementById("shipto_address_1").style.border='1px solid #C7C7C7';
     }

     if (shipto_zip==""){
       document.getElementById("szip").style.display='block';
      document.getElementById("shipto_zip").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_zip,";
     }
     else {
       document.getElementById("szip").style.display='none';
      document.getElementById("shipto_zip").style.border='1px solid #C7C7C7';
     }
   }


     //errMsg += "* One or more of the quantity fields have invalid values. Please enter a number or leave blank.\n";


   <!-- bof Billing info validation -->


    var b_fname = document.getElementById("b_fname").value;
    if( b_fname.length == 0 ) {
      document.getElementById("bfname").style.display='block';
      document.getElementById("b_fname").style.border='1px solid red';
     // document.getElementById("b_fname").focus();
      errMsg += "b_fname,";
    }
    else {
      document.getElementById("bfname").style.display='none';
      document.getElementById("b_fname").style.border='1px solid #C7C7C7';
    }

    var b_lname = document.getElementById("b_lname").value;
    if( b_lname.length == 0 ) {
       document.getElementById("blname").style.display='block';
      document.getElementById("b_lname").style.border='1px solid red';
      //document.getElementById("b_lname").focus();
      errMsg += "b_lname,";
    }
    else {
      document.getElementById("blname").style.display='none';
      document.getElementById("b_lname").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing last name.\n";
    }

     var b_adrs = document.getElementById("b_adrs").value;
    if( b_adrs.length == 0 ) {
       document.getElementById("badd").style.display='block';
      document.getElementById("b_adrs").style.border='1px solid red';
     // document.getElementById("b_adrs").focus();
      errMsg += "b_adrs,";
    }
    else {
      document.getElementById("badd").style.display='none';
      document.getElementById("b_adrs").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing street address.\n";
    }

     var b_city = document.getElementById("b_city").value;
    if( b_city.length == 0 ) {
      document.getElementById("bcity").style.display='block';
      document.getElementById("b_city").style.border='1px solid red';
      //document.getElementById("b_city").focus();
      errMsg += "b_city,";
    }
    else {
      document.getElementById("bcity").style.display='none';
      document.getElementById("b_city").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing city.\n";
    }

     var b_state = document.getElementById("b_state").value;
    if( b_state.length == 0 ) {
      document.getElementById("bstate").style.display='block';
      document.getElementById("b_state").style.border='1px solid red';
     // document.getElementById("b_state").focus();
      errMsg += "b_state,";
    }
    else {
      document.getElementById("bstate").style.display='none';
      document.getElementById("b_state").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing state.\n";
    }

     var b_zip = document.getElementById("b_zip").value;
    if( b_zip.length == 0 ) {
      document.getElementById("bzip").style.display='block';
      document.getElementById("b_zip").style.border='1px solid red';
      //document.getElementById("b_zip").focus();
      errMsg += "b_zip,";
    }
    else {
      document.getElementById("bzip").style.display='none';
      document.getElementById("b_zip").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing zip code.\n";
    }

     var b_phone = document.getElementById("b_phone").value;
    if( b_phone.length == 0 ) {
      document.getElementById("bphone").style.display='block';
      document.getElementById("b_phone").style.border='1px solid red';
      //document.getElementById("b_phone").focus();
      errMsg += "b_phone,";
    }
    else {
      document.getElementById("bphone").style.display='none';
      document.getElementById("b_phone").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing phone number.\n";
    }

     var b_email = document.getElementById("b_email").value;
    if( (b_email.length == 0) ||((b_email.indexOf('@') == -1) || (b_email.indexOf('.') == -1)) ) {
      document.getElementById("bemail").style.display='block';
      document.getElementById("b_email").style.border='1px solid red';
      //document.getElementById("b_email").focus();
      errMsg += "b_email,";
    }
    else {
      document.getElementById("bemail").style.display='none';
      document.getElementById("b_email").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the billing email address.\n";
    }



    //else if((b_email.indexOf('@') == -1) || (b_email.indexOf('.') == -1)) {
      //errMsg += "* Please enter a valid billing email address.\n";
    //}

    var cc_type = document.getElementById("cc_type").value;
    if( cc_type == "Select" ) {
      document.getElementById("cctype").style.display='block';
      document.getElementById("cc_type").style.border='1px solid red';
     // document.getElementById("cc_type").focus();
      errMsg += "cc_type,";
    }
    else {
      document.getElementById("cctype").style.display='none';
      document.getElementById("cc_type").style.border='1px solid #C7C7C7';
      //errMsg += "* Please select a credit card type.\n";
    }

    var ccn = document.getElementById("ccn").value;

    if(cc_type != "Select"){
      myCardType = document.getElementById('cc_type').value;
      if (checkCreditCard (ccn, myCardType)) {
        document.getElementById("ccnumber").style.display='none';
        document.getElementById("ccn").style.border='1px solid #C7C7C7';

      }
      else {
        document.getElementById("ccnumber").style.display='block';
        document.getElementById("ccn").style.border='1px solid red';
        document.getElementById("ccnumber").innerHTML= ccErrors[ccErrorNo];
        //document.getElementById("ccn").focus();
        errMsg += "ccn,";
        //errMsg += ccErrors[ccErrorNo] + "\n";
      }
    }

    var ccv = document.getElementById("ccv").value;
    if( ccv.length == 0 ) {
      document.getElementById("ccvery").style.display='block';
      document.getElementById("ccv").style.border='1px solid red';
      errMsg += "ccv";
    }
    else {
      document.getElementById("ccvery").style.display='none';
      document.getElementById("ccv").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the credit card verification code.\n";
    }




    var exp_month = document.getElementById("exp_month").value;
    var exp_year = document.getElementById("exp_year").value;
    if( (exp_month == "Month") ||(exp_year == "Year") ) {
      document.getElementById("expymonth").style.display='block';
      document.getElementById("expymonth").innerHTML='Please select the credit card expiration month/year.';
      if( (exp_month == "Month")&& (exp_year == "Year")){
        document.getElementById("exp_month").style.border='1px solid red';
        document.getElementById("exp_year").style.border='1px solid red';
        errMsg += "exp_month,";
      }
      else {
      if (exp_month == "Month"){
      document.getElementById("exp_month").style.border='1px solid red';
      document.getElementById("exp_year").style.border='1px solid #C7C7C7';
      errMsg += "exp_month,";
      }
      else {
      document.getElementById("exp_year").style.border='1px solid red';
      document.getElementById("exp_month").style.border='1px solid #C7C7C7';
      errMsg += "exp_month,";
      }

    }
    }
    else {

     if(exp_month < <%= Time.now.month %> && exp_year <= '<%= Time.now.year %>'){
      document.getElementById("expymonth").style.display='block';
      document.getElementById("expymonth").innerHTML='Invalid Credit Card expiration.';
      document.getElementById("exp_month").style.border='1px solid red';
     document.getElementById("exp_year").style.border='1px solid red';
      errMsg += "exp_month,";
    }
    else {
     document.getElementById("expymonth").style.display='none';
     document.getElementById("exp_month").style.border='1px solid #C7C7C7';
     document.getElementById("exp_year").style.border='1px solid #C7C7C7';
      //errMsg += "* Invalid Credit Card expiration.\n";
    }

      //document.getElementById("expymonth").style.display='none';
      //document.getElementById("exp_month").style.border='';
      //document.getElementById("exp_year").style.border='';
      //errMsg += "* Please select the credit card expiration month.\n";
    }


    var tnc = document.getElementById("tnc").checked;
    if( tnc != true ) {
      document.getElementById("termsncon").style.display='block';
      //document.getElementById("exp_year").style.border='1px solid red';
      errMsg += "tnc,";
    }
    else {
      document.getElementById("termsncon").style.display='none';
     // document.getElementById("exp_year").style.border='';
      //errMsg += "* You must agree to the Crave Cupcakes terms and conditions.\n";
    }

   <!-- eof Billing info valication-->

   if( errMsg.length > 0 ){
     myArray = errMsg.split(",");
     //alert( myArray[0] );
     document.getElementById(myArray[0]).focus();
     return false;
   } else {
     return true;
   }
 }


//validation for Admin order Submission.

function validateFormAdmin( frm ){

    var errMsg = "";

    var store1 = document.getElementById("store1").checked
    var store2 = document.getElementById("store2").checked

    if( (store1 == false) && (store2 == false)) {
      document.getElementById("store").style.display='block';
     // document.getElementById("store1").focus();
      //document.getElementById("last_name").style.border='1px solid red';
      errMsg += "store1,";
    }
    else {
      document.getElementById("store").style.display='none';
    }

    var pick_up = document.getElementById("delivery_method_pickup").checked
    var delivery = document.getElementById("delivery_method_delivery").checked
    if((pick_up == false) && (delivery == false)) {
      document.getElementById("dmethod").style.display='block';
     // document.getElementById("delivery_method_pickup").focus();
      errMsg += "delivery_method_pickup,";
    }
    else {
      document.getElementById("dmethod").style.display='none';
    }

    var time_of_order = document.getElementById("time_of_order").value
    if( time_of_order == "Select" ) {
      document.getElementById("tdorder").style.display='block';
      //document.getElementById("time_of_order").focus();
       errMsg += "time_of_order,";
    }
    else {
      document.getElementById("tdorder").style.display='none';
    }

    // enforce next day order before 6pm
    var date_of_order = document.getElementById("date_of_order").value
    var tomorrow = new Date();
    tomorrow.setTime(tomorrow.getTime() + (1000*3600*24));
    //alert( + " - " + );
    var orderDate = date_of_order.substring(0,10);
    tomorrow = ((tomorrow.getMonth()+1) < 10 ? ("0"+(tomorrow.getMonth()+1)) : (tomorrow.getMonth()+1)) + "/"+ (tomorrow.getDate() < 10 ? "0"+tomorrow.getDate() : tomorrow.getDate())+"/"+ (tomorrow.getYear()+1900)
    //var curTime = new Date()
    //var curr_hour = curTime.getHours();
    <%
    t = Time.now
    cst = (t.gmtime) - (60*60*6)
    %>
    if(orderDate == tomorrow && <%= cst.hour %> > 17 ){
      document.getElementById("dorder").style.display='block';
     // document.getElementById("dorder").focus();
     errMsg += "date_of_order,";
    }

    // counting specials
   var totalSpecials = 0;

   for (var i = 0; i < frm.elements.length; i++) {
     if (frm.elements[i].type == "text" && frm.elements[i].name.indexOf("specials") != -1 && (! isNaN(parseInt(frm.elements[i].value)))) {
       totalSpecials += parseInt(frm.elements[i].value);
     }
   }

   // if specials are not selected count cupcakes
   if(totalSpecials == 0){
     var totalCupcakes = 0;

     for (var i = 0; i < frm.elements.length; i++) {
       if (frm.elements[i].type == "text" && frm.elements[i].name.indexOf("cupcakes") != -1 && (! isNaN(parseInt(frm.elements[i].value)))) {
         totalCupcakes += parseInt(frm.elements[i].value);
       }
     }

     if( totalCupcakes < 12 ){
       if (document.getElementById("ocupcakes") ){

       document.getElementById("ocupcakes").style.display='block';
      // document.getElementById("ocupcakes").focus();
       errMsg += "specials[1],";
      }
       //errMsg += "* You must order at least 12 cupcakes (or a seasonal box, if available).\n";
     }
     else {
       if (document.getElementById("ocupcakes") ){
       document.getElementById("ocupcakes").style.display='none';
       }
     }
   }
   else {
     if (document.getElementById("ocupcakes") ){
       document.getElementById("ocupcakes").style.display='none';
       }
   }


        // calling function chk all quantities are numerical
   if(chk_qtys() == true){

     if (document.getElementById("isordernumeric") ){

       document.getElementById("isordernumeric").style.display='block';
       //document.getElementById("shipto_first_name").focus();
       errMsg += "specials[2],";
      }
       //errMsg += "* You must order at least 12 cupcakes (or a seasonal box, if available).\n";
     }
     else {
       if (document.getElementById("isordernumeric") ){
       document.getElementById("isordernumeric").style.display='none';

       }
     }


   //confirm minimum 12 in order

    // if is_how_to_boxed clicked then how_to_boxed is required
     var com = document.getElementById("is_how_to_boxed");
     if (com != null){
       var is_how_to_boxed = document.getElementById("is_how_to_boxed").checked;
       var how_to_boxed = document.getElementById("how_to_boxed").value;

        if( is_how_to_boxed == true && how_to_boxed.length == 0) {
          document.getElementById("howbox").style.display='block';
          document.getElementById("how_to_boxed").style.border='1px solid red';
         // document.getElementById("how_to_boxed").focus();
          errMsg += "how_to_boxed,";

        }
        else {
          document.getElementById("howbox").style.display='none';
          document.getElementById("how_to_boxed").style.border='1px solid #C7C7C7';
        }
     }

    var firstName = document.getElementById("first_name").value;
    if( firstName.length == 0 ) {
      //document.getElementById("a").value="* Please enter your first name.\n"
      document.getElementById("fname").style.display='block';
      document.getElementById("first_name").style.border='1px solid red';
     // document.getElementById("first_name").focus();
      errMsg += "first_name,";
    }
    else{
      document.getElementById("fname").style.display='none';
      document.getElementById("first_name").style.border='1px solid #C7C7C7';
    }
    var lastName = document.getElementById("last_name").value;
    if( lastName.length == 0 ) {
      document.getElementById("lname").style.display='block';
      document.getElementById("last_name").style.border='1px solid red';
      //document.getElementById("last_name").focus();
      errMsg += "last_name,";
    }
    else {
      document.getElementById("lname").style.display='none';
      document.getElementById("last_name").style.border='1px solid #C7C7C7';
    }
    var emAddress = document.getElementById("email").value;
    if((emAddress.indexOf('@') == -1) || (emAddress.indexOf('.') == -1)) {
      document.getElementById("cemail").style.display='block';
      document.getElementById("email").style.border='1px solid red';
     // document.getElementById("email").focus();
      errMsg += "email,";
    }
    else {
      document.getElementById("cemail").style.display='none';
      document.getElementById("email").style.border='1px solid #C7C7C7';
    }
    var phone = document.getElementById("primary_phone").value + document.getElementById("alt_phone").value;
    if( phone.length == 0 ) {
      document.getElementById("phone").style.display='block';
      document.getElementById("primary_phone").style.border='1px solid red';
      //document.getElementById("primary_phone").focus();
      errMsg += "primary_phone,";
    }
    else {
      document.getElementById("phone").style.display='none';
      document.getElementById("primary_phone").style.border='1px solid #C7C7C7';
    }
    //confirm delivery address
    var isDelivery = document.getElementById("delivery_method_delivery").checked == true;
   if (isDelivery ) {

    // if shipto_is_business clicked then shipto_business required
    var shipto_biz = document.getElementById("shipto_is_business").checked==true;
    if(shipto_biz && document.getElementById("shipto_business").value == ""){

      document.getElementById("bussines").style.display='block';
      document.getElementById("shipto_business").style.border='1px solid red';
      //document.getElementById("shipto_business").focus();
      errMsg += "shipto_business,";
    }
    else {
      document.getElementById("bussines").style.display='none';
      document.getElementById("shipto_business").style.border='1px solid #C7C7C7';
    }

    var shipto_first = document.getElementById("shipto_first_name").value;
    var shipto_last = document.getElementById("shipto_last_name").value;
    var shipto_addr = document.getElementById("shipto_address_1").value;
    var shipto_zip = document.getElementById("shipto_zip").value;
    var isDeliveryInfoComplete = shipto_first == "" | shipto_last == "" | shipto_addr == "" | shipto_zip == "";

     //if (isDeliveryInfoComplete) {
       //errMsg += "* You have indicated that this order will be delivered. Please fill in the delivery address fields: first and last name, street address, and zip are required.\n";
     //}
     if (shipto_first==""){
       document.getElementById("sfname").style.display='block';
      document.getElementById("shipto_first_name").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_first_name,";
     }
     else {
       document.getElementById("sfname").style.display='none';
      document.getElementById("shipto_first_name").style.border='1px solid #C7C7C7';
     }

     if (shipto_last==""){
       document.getElementById("slname").style.display='block';
      document.getElementById("shipto_last_name").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_last_name,";
     }
     else {
       document.getElementById("slname").style.display='none';
      document.getElementById("shipto_last_name").style.border='1px solid #C7C7C7';
     }

     if (shipto_addr==""){
       document.getElementById("sadd").style.display='block';
      document.getElementById("shipto_address_1").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_address_1,";
     }
     else {
       document.getElementById("sadd").style.display='none';
      document.getElementById("shipto_address_1").style.border='1px solid #C7C7C7';
     }

     if (shipto_zip==""){
       document.getElementById("szip").style.display='block';
      document.getElementById("shipto_zip").style.border='1px solid red';
      //document.getElementById("shipto_first_name").focus();
      errMsg += "shipto_zip,";
     }
     else {
       document.getElementById("szip").style.display='none';
      document.getElementById("shipto_zip").style.border='1px solid #C7C7C7';
     }
   }


     //errMsg += "* One or more of the quantity fields have invalid values. Please enter a number or leave blank.\n";


   <!-- bof Billing info validation -->


   var paytype = document.getElementById("payment_type").value;
    alert('paytype');
    if(paytype == ""){
      document.getElementById("paymenttype").style.display='block';
      document.getElementById("payment_type").style.border='1px solid red';
      errMsg += "payment_type,";
    }
    else {
      document.getElementById("paymenttype").style.display='none';
      document.getElementById("payment_type").style.border='1px solid #C7C7C7';
      //errMsg += "* Please enter the credit card verification code.\n";
    }


    var tnc = document.getElementById("tnc").checked;
    if( tnc != true ) {
      document.getElementById("termsncon").style.display='block';
      //document.getElementById("exp_year").style.border='1px solid red';
      errMsg += "tnc,";
    }
    else {
      document.getElementById("termsncon").style.display='none';
     // document.getElementById("exp_year").style.border='';
      //errMsg += "* You must agree to the Crave Cupcakes terms and conditions.\n";
    }

   <!-- eof Billing info valication-->

   if( errMsg.length > 0 ){
     myArray = errMsg.split(",");
     //alert( myArray[0] );
     document.getElementById(myArray[0]).focus();
     return false;
   } else {
     return true;
   }
 }




