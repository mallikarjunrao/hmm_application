//Create a global variable to hold the value of form submit
//Initially set this to true and when submitPage() is called the
//first time change this to false. If the value is false display
//alert message and do not re-submit the form.

var formNotSubmitted = true;

function submitPage()
{
	var returnVal = false;
	if (formNotSubmitted)
	{
		formNotSubmitted = false;
		if ( validateForm() )
		{
			//document.feedbackForm.submit();
			//Not needed since the type in input submit is automatic.
			returnVal = true;
		}
		else
		{
			//There was an error in form validation and need to reset flag.
			formNotSubmitted = true;
			returnVal = false;
		}
	}
	else
	{
		alert("Thank you for sending recipe.");
		returnVal = false;
	}
	return returnVal;
}

function validateForm()
{
	var errorMessage = "";
	var retVal = false;
	
	if(!document.recipeEmail.toEmailAddresses.value || document.recipeEmail.toEmailAddresses.value.length == 0)
	{
		errorMessage = errorMessage + "\"Your Friend's Email Address(es)\" field cannot be blank.\n";
	}
	else
	{
		var emailAddressField = document.recipeEmail.toEmailAddresses.value;
		var email_array = new Array();
		if (emailAddressField.indexOf(",") != -1)
			email_array = emailAddressField.split(",");
		else if (emailAddressField.indexOf(";") != -1)
			email_array = emailAddressField.split(";");
		else if (emailAddressField.indexOf(" ") != -1)
			email_array = emailAddressField.split(" ");
		else
			email_array[0] = emailAddressField;
		
		emailAddressField = "";
		
		for(i=0; i < email_array.length; i++)
		{
			var individualEmailAddress = trim(email_array[i]);
			if (individualEmailAddress.length > 0)
			{
				emailAddressField = emailAddressField + individualEmailAddress + ";";
				if (!checkEmail(individualEmailAddress))
				{
					errorMessage = errorMessage + "\"Your Friend's Email Address(es)\" (" + individualEmailAddress + ") field must contain valid email addresses.\n";
				}
			}
		}
		emailAdderssField = emailAddressField.substring(0,emailAddressField.length-1);
		document.recipeEmail.toEmailAddresses.value = emailAdderssField;
	}
	if (!document.recipeEmail.from.value || document.recipeEmail.from.length == 0)
	{
		errorMessage = errorMessage + "\"Your Name\" field cannot be blank.\n";
	}
	if (!document.recipeEmail.fromEmailAddress.value || document.recipeEmail.fromEmailAddress.value.length == 0)
	{
		// Do nothing.
	}
	else
	{
		if (!checkEmail(document.recipeEmail.fromEmailAddress.value))
		{
			errorMessage = errorMessage + "\"Your Email Address\" field must contain valid email address.\n";
		}
	}
	if (!document.recipeEmail.message.value || document.recipeEmail.message.length == 0)
	{
		errorMessage = errorMessage + "\"Your Message to your Friend(s)\" field cannot be blank.\n";
	}
	if ( errorMessage != "" )
	{
		alert( "The following was missing or incorrectly provided:\n\n" + errorMessage );
		retVal = false;
	}
	else
	{
		retVal = true;
	}
	return retVal;
}

/**
  * Reference: Sandeep V. Tamhankar (stamhankar@hotmail.com),
  * http://javascript.internet.com
  */
function checkEmail(emailStr) {
	if (emailStr.length == 0) {
		return true;
	}
	var emailPat=/^(.+)@(.+)$/;
	var specialChars="\\(\\)<>@,;:\\\\\\\"\\.\\[\\]";
	var validChars="\[^\\s" + specialChars + "\]";
	var quotedUser="(\"[^\"]*\")";
	var ipDomainPat=/^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/;
	var atom=validChars + '+';
	var word="(" + atom + "|" + quotedUser + ")";
	var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
	var domainPat=new RegExp("^" + atom + "(\\." + atom + ")*$");
	var matchArray=emailStr.match(emailPat);
	if (matchArray == null) {
		return false;
	}
	var user=matchArray[1];
	var domain=matchArray[2];
	if (user.match(userPat) == null) {
		return false;
	}
	var IPArray = domain.match(ipDomainPat);
	if (IPArray != null) {
		for (var i = 1; i <= 4; i++) {
			if (IPArray[i] > 255) {
				return false;
			}
		}
		return true;
	}
	var domainArray=domain.match(domainPat);
	if (domainArray == null) {
		return false;
	}
	var atomPat=new RegExp(atom,"g");
	var domArr=domain.match(atomPat);
	var len=domArr.length;
	if ((domArr[domArr.length-1].length < 2) ||
		 (domArr[domArr.length-1].length > 3)) {
		return false;
	}
	if (len < 2) {
		return false;
	}
	return true;
}

function trim(s)
{
	// Remove leading spaces and carriage returns
	
	while ((s.substring(0,1) == ' ') || (s.substring(0,1) == '\n') || (s.substring(0,1) == '\r'))
	{
		s = s.substring(1,s.length);
	}
	
	// Remove trailing spaces and carriage returns
	
	while ((s.substring(s.length-1,s.length) == ' ')
			 || (s.substring(s.length-1,s.length) == '\n')
			 || (s.substring(s.length-1,s.length) == '\r'))
	{
		s = s.substring(0,s.length-1);
	}
	return s;
}
