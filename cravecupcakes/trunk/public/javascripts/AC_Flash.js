// The code below contains functions that run active content. The functions
// assemble an OBJECT/EMBED tag string, and then perform a document.write of 
// this string in the calling html document.
//   AC_RunFlContent() - build tags to display Flash content.
//   AC_RunFlContentX() - build XHTML formatted tags to display Flash content.
//   AC_RunSWContent() - build tags to display Shockwave content.
//   AC_RunSWContentX()  - build XHTML formatted tags to display Shockwave content.
//
// To call one of these functions, pass all the attributes and values that you would 
// otherwise specify for the object, param, and embed tags in the following form:
//   AC_RunFlContent(
//     "attrName1", "attrValue1"
//     "attrName2", "attrValue2"
//     ...
//     "attrNamen", "attrValuen"
//   )
//
// When passing in the src or movie attributes, do not include the file extension.
// Note, these functions use default values for several standard tag attributes, 
// including classid, codebase, pluginsPage, and mimeType, depending on the function
// you call. So, you should not pass in values for these attributes. If you require
// an alternate values for these attributes, you'll need to modify the default values 
// used in the 'Run' function implementations below. However, you may pass in an
// alternate version for the codebase value, as in AC_RunFlContent("codebase","6,0,0,0",...).
// Note that you should only pass in the version string rather than the full
// codebase URL.
//
// You must include AC_RunActiveContent.js for these functions to work.

function AC_RunFlContent()
{
  // First, look for a "movie" and "src" params, and if either exists, add a ".swf" to the end
  // if it doesn't already have one (this function will only run swf files)
  AC_AddExtension(arguments, "movie", ".swf");
  AC_AddExtension(arguments, "src", ".swf");

  // Build the codebase value. If user passed in a version for the codebase, add the version
  // to the base codebase url. Otherwise, use the default version.
  var codebase = AC_GetCodebase
                 (  "http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version="
                  , "7,0,0,0", arguments 
                 );
	
  AC_GenerateObj
  (  "AC_RunFlContent()", false, "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
   , codebase
   , "http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"
   , "application/x-shockwave-flash", arguments
  );
}

function AC_RunFlContentX()
{
  // First, look for a "movie" and "src" params, and if either exists, add a ".swf" to the end
  // if it doesn't already have one (this function will only run swf files)
  AC_AddExtension(arguments, "movie", ".swf");
  AC_AddExtension(arguments, "src", ".swf");

  // Build the codebase value. If user passed in a version for the codebase, add the version
  // to the base codebase url. Otherwise, use the default version.
  var codebase = AC_GetCodebase
                 (  "http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version="
                  , "7,0,0,0", arguments 
                 );
	
  AC_GenerateObj
  (  "AC_RunFlContentX()", true, "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
   , codebase
   , "http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"
   , "application/x-shockwave-flash", arguments
  );	
}

function AC_RunSWContent()
{
  // First, look for a "src" param, and if it exists, add a ".dcr" to the end
  // if it doesn't already have one (this function will only run dcr files)
  AC_AddExtension(arguments, "src", ".dcr");

  // Build the codebase value. If user passed in a version for the codebase, add the version
  // to the base codebase url. Otherwise, use the default version.
  var codebase = AC_GetCodebase
                 (  "http://fpdownload.macromedia.com/pub/shockwave/cabs/director/sw.cab#version="
                  , "8,5,0,0", arguments 
                 );
	
  AC_GenerateObj
  (  "AC_RunSWContent()", false, "clsid:166B1BCA-3F9C-11CF-8075-444553540000"
   , codebase
   , "http://www.macromedia.com/shockwave/download/", null, arguments
  );
}
	
function AC_RunSWContentX()
{
  // First, look for a "src" param, and if it exists, add a ".dcr" to the end
  // if it doesn't already have one (this function will only run dcr files)
  AC_AddExtension(arguments, "src", ".dcr");

  // Build the codebase value. If user passed in a version for the codebase, add the version
  // to the base codebase url. Otherwise, use the default version.
  var codebase = AC_GetCodebase
                 (  "http://fpdownload.macromedia.com/pub/shockwave/cabs/director/sw.cab#version="
                  , "8,5,0,0", arguments 
                 );
	
  AC_GenerateObj
  (  "AC_RunSWContentX()", true, "clsid:166B1BCA-3F9C-11CF-8075-444553540000"
   , codebase
   , "http://www.macromedia.com/shockwave/download/", null, arguments
  );
}
	
