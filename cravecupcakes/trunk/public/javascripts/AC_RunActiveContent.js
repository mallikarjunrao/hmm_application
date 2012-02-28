// Implements AC_GenerateObj() function. This is a generic function used to generate
// object/embed/param tags. It is used by higher level api functions.

/************** LOCALIZABLE GLOBAL VARIABLES ****************/

var MSG_EvenArgs = 'The %s function requires an even number of arguments.'
                 + '\nArguments should be in the form "atttributeName","attributeValue",...';
var MSG_SrcRequired = "The %s function requires that a movie src be passed in as one of the arguments.";

/******************** END LOCALIZABLE **********************/

// Finds a parameter with the name paramName, and checks to see if it has the 
// passed extension. If it doesn't have it, this function adds the extension.
function AC_AddExtension(args, paramName, extension)
{
  var currArg, paramVal, queryStr, endStr;
  for (var i=0; i < args.length; i=i+2){
    currArg = args[i].toLowerCase();    
    if (currArg == paramName.toLowerCase() && args.length > i+1) {
      paramVal = args[i+1];
      queryStr = "";

      // Pull off the query string if it exists.
      var indQueryStr = args[i+1].indexOf('?');
      if (indQueryStr != -1){
        paramVal = args[i+1].substring(0, indQueryStr);
        queryStr = args[i+1].substr(indQueryStr);
      }

      endStr = "";
      if (paramVal.length > extension.length)
        endStr = paramVal.substr(paramVal.length - extension.length);
      if (endStr.toLowerCase() != extension.toLowerCase()) {
        // Extension doesn't exist, add it
        args[i+1] = paramVal + extension + queryStr;
      }
    }
  }
}

// Builds the codebase value to use. If the 'codebase' parameter is found in the args,
// uses its value as the version for the baseURL. If 'codebase' is not found in the args,
// uses the defaultVersion.
function AC_GetCodebase(baseURL, defaultVersion, args)
{
  var codebase = baseURL + defaultVersion;
  for (var i=0; i < args.length; i=i+2) {
    currArg = args[i].toLowerCase();    
    if (currArg == "codebase" && args.length > i+1) {
      if (args[i+1].indexOf("http://") == 0) {
        // User passed in a full codebase, so use it.
        codebase = args[i+1];
      }
      else {
        codebase = baseURL + args[i+1];
      }
    }
  }
	
  return codebase;	
}

// Substitutes values for %s in a string.
// Usage: AC_sprintf("The %s function requires %s arguments.","foo()","4");
function AC_sprintf(str){
  for (var i=1; i < arguments.length; i++){
    str = str.replace(/%s/,arguments[i]);
  }
  return str;
}
		
// Checks that args, the argument list to check, has an even number of 
// arguments. Alerts the user if an odd number of arguments is found.
function AC_checkArgs(args,callingFn){
  var retVal = true;
  // If number of arguments isn't even, show a warning and return false.
  if (parseFloat(args.length/2) != parseInt(args.length/2)){
    alert(sprintf(MSG_EvenArgs,callingFn));
    retVal = false;
  }
  return retVal;
}
	
function AC_GenerateObj(callingFn, useXHTML, classid, codebase, pluginsPage, mimeType, args){

  if (!AC_checkArgs(args,callingFn)){
    return;
  }

  // Initialize variables
  var tagStr = '';
  var currArg = '';
  var closer = (useXHTML) ? '/>' : '>';
  var srcFound = false;
  var embedStr = '<embed';
  var paramStr = '';
  var embedNameAttr = '';
  var objStr = '<object classid="' + classid + '" codebase="' + codebase + '"';

  // Spin through all the argument pairs, assigning attributes and values to the object,
  // param, and embed tags as appropriate.
  for (var i=0; i < args.length; i=i+2){
    currArg = args[i].toLowerCase();    

    if (currArg == "src"){
      if (callingFn.indexOf("RunSW") != -1){
        paramStr += '<param name="' + args[i] + '" value="' + args[i+1] + '"' + closer + '\n';
        embedStr += ' ' + args[i] + '="' + args[i+1] + '"';
        srcFound = true;
      }
      else if (!srcFound){
        paramStr += '<param name="movie" value="' + args[i+1] + '"' + closer + '\n'; 
        embedStr += ' ' + args[i] + '="' + args[i+1] + '"';
        srcFound = true;
      }
    }
    else if (currArg == "movie"){
      if (!srcFound){
        paramStr += '<param name="' + args[i] + '" value="' + args[i+1] + '"' + closer + '\n'; 
        embedStr += ' src="' + args[i+1] + '"';
        srcFound = true;
      }
    }
    else if (   currArg == "width" 
              || currArg == "height" 
              || currArg == "align" 
              || currArg == "vspace" 
              || currArg == "hspace" 
              || currArg == "class" 
              || currArg == "title" 
              || currArg == "accesskey" 
              || currArg == "tabindex"){
      objStr += ' ' + args[i] + '="' + args[i+1] + '"';
      embedStr += ' ' + args[i] + '="' + args[i+1] + '"';
    }
    else if (currArg == "id"){
      objStr += ' ' + args[i] + '="' + args[i+1] + '"';
      // Only add the name attribute to the embed tag if a name attribute 
      // isn't already there. This is what Dreamweaver does if the user
      // enters a name for a movie in the PI: it adds id to the object
      // tag, and name to the embed tag.
      if (embedNameAttr == "")
        embedNameAttr = ' name="' + args[i+1] + '"';
    }
    else if (currArg == "name"){
      objStr += ' ' + args[i] + '="' + args[i+1] + '"';
      // Replace the current embed tag name attribute with the one passed in.
      embedNameAttr = ' ' + args[i] + '="' + args[i+1] + '"';
    }    
    else if (currArg == "codebase"){
      // The codebase parameter has already been handled, so ignore it. 
    }    
    // This is an attribute we don't know about. Assume that we should add it to the 
    // param and embed strings.
    else{
      paramStr += '<param name="' + args[i] + '" value="' + args[i+1] + '"' + closer + '\n'; 
      embedStr += ' ' + args[i] + '="' + args[i+1] + '"';
    }
  }

  // Tell the user that a movie/src is required, if one was not passed in.
  if (!srcFound){
    alert(AC_sprintf(MSG_SrcRequired,callingFn));
    return;
  }

  if (embedNameAttr)
    embedStr += embedNameAttr;	
  if (pluginsPage)
    embedStr += ' pluginspage="' + pluginsPage + '"';
  if (mimeType)
    embedStr += ' type="' + mimeType + '"';
    
  // Close off the object and embed strings
  objStr += '>\n';
  embedStr += '></embed>\n'; 

  // Assemble the three tag strings into a single string.
  tagStr = objStr + paramStr + embedStr + "</object>\n"; 

  document.write(tagStr);
}
