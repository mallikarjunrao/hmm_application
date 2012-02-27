package helpers {
	public class DateUtil {	
		
		import mx.utils.StringUtil;
		import mx.collections.ArrayCollection;
		
		public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		
		private static const kmDays:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		public static const monthNames:Array=["January" , "February" ,"March" ,
					"April" , "May" , "June" , "July" , "August" , "September" ,
					"October" , "November" , "December"]; 
		
		/**
		 *  Determine if a year is a leap year			 */
		public static function isLeapYear(year:Number):Boolean	{	
		     return (   year % 4 == 0 &&	
		             (year % 100 != 0 || year % 400 == 0) );
		}
		
		/**
		 *  Determine number of days in month	
		 *  (including leap years)	
		 */	
		public static function daysInMonth(year:Number,mNbr:Number):Number // month is from 0 - 11	
		{	
		  //http://board.flashkit.com/board/showthread.php?threadid=561381	
		  return kmDays[mNbr] + (mNbr == 1 && isLeapYear(year));	
		}
		
		/**
		 * Return (float) number of days betwen two dates		 */
		public static function daysBetween(a:Date,b:Date):Number{
			if (b.getTime() < a.getTime()){
				var t:Number=a.getTime();
				a=new Date(b.getTime());
				b=new Date(t);	
			}
			return (b.getTime()-a.getTime())/millisecondsPerDay;
		} 
		
		/**
		 * Add the indicated number of days to a date		 */ 
		public static function addDaysTo(i:Number,d:Date):Date{
			return new Date(d.getTime()+(i*millisecondsPerDay));
		} 

		/**
		 * Return the date with (non-UTC) time set to 23:59:59		 */
		public static function endOfDay(h:Date):Date{
			h.seconds=23;	
			h.hours=23;
			h.minutes=23;
			h.milliseconds=59;
			return h;
		}
		
		/**
		 * Return the date with (non-UTC) time set to 0:0:0
		 */
		public static function startOfDay(d:Date):Date{
			d.seconds=0;	
			d.hours=0;
			d.minutes=0;
			d.milliseconds=0;			
			return d;
		}
		
		/**
		 * Parse a string into a Date (will not work with strings that are datetimes)
		 * Will parse as if you are in the UK locale
		 * Bloody Flex Date(string) constructor doesn't work with commonly formated dates
		 *	 22/3/06 => 3 Oct 1907 (nb not even right in the US)!
		 *	 10 dec 06 => fails
		 * This method understands: (all will parse to 10th Decemeber 2006 00:00:00)
		 * 10 Dec 2006
		 * 10 dec 2006
		 * Dec 10 2006
		 * dec 10 2006
		 * 10 December 2006
		 * 10 december 2006
		 * December 10 2006
		 * december 10 2006
		 * 10.12.2006
		 * 10.12.06
		 * 10/12/06
		 * 10/12/2006
		 * etc.
		 * See testDateUtil.mxml in root of as3 utils project for full list
		 * - dates containing month names work with 'st' or 'th' after day of month		 */
		public static function parseDate(s:String):Date{
			var a:Array;
			var m:String;
			var y:String;
			s=StringUtil.trim(s);
			if (s.length == 0){	//move along...
				return new Date(s);
			}
			if (s.indexOf('.')>0){ //assume d.m.y
				a=s.split('.');
				if (a[2].length == 2){
					return new Date(20+a[2],a[1]-1,a[0]);	//TODO fix Y3K problem
				}else{
					return new Date(a[2],a[1]-1,a[0]);
				}
			}
			if (s.indexOf('/')>0){ //assume d/m/y
				a=s.split('/');
				if (a[2].length == 2){
					return new Date(20+a[2],a[1]-1,a[0]);	//TODO fix Y3K problem
				}else{
					return new Date(a[2],a[1]-1,a[0]);
				}
			}
			
			//'n[n][st] str nnnn => needs uppercase inital letter
			var p:RegExp = /^(\d{1,2})(?:|th|st|rd|nd) ([a-zA-Z]{3,}) (\d{4})$/;   	
			var res:Object=p.exec(s);
			if (res != null){
				m=initCap(res[2])
				if (isValidMonthName(m)){					
					return new Date(res[1]+" "+m.substr(0,3)+" "+res[3]);
				}
			}	
			//as above but two digit dates
			p = /^(\d{1,2})(?:|th|st|rd|nd) ([a-zA-Z]{3,}) (\d{2})$/;   
			res=p.exec(s);
			if (res != null){
				m=initCap(res[2]);
				y=20+res[3];						//TODO fix Y3K problem
				if (isValidMonthName(m)){					
					return new Date(res[1]+" "+m.substr(0,3)+" "+y);
				}
			}		
			
			//'str n[n][st] nn[nn] as above two cases but transposed month name and day
			p = /^([a-zA-Z]{3,}) (\d{1,2})(?:|th|st|rd|nd) (\d{4})$/;   	
			res=p.exec(s);
			if (res != null){
				m=initCap(res[1])
				if (isValidMonthName(m)){					
					return new Date(res[2]+" "+m.substr(0,3)+" "+res[3]);
				}
			}	
			p = /^([a-zA-Z]{3,}) (\d{1,2})(?:|th|st|rd|nd) (\d{2})$/;   
			res=p.exec(s);
			if (res != null){
				m=initCap(res[1]);
				y=20+res[3];						//TODO fix Y3K problem
				if (isValidMonthName(m)){					
					return new Date(res[2]+" "+m.substr(0,3)+" "+y);
				}
			}
			
			return new Date(s);	//pass over to the Date constructor for anything else
		}
		
		/**
		 * Determine if the string is a valid Gregorian English month name
		 * case must be correct too.		 */
		public static function isValidMonthName(s:String):Boolean{
			var a:ArrayCollection=new ArrayCollection(monthNames);
			s=StringUtil.trim(s);
			if (s.length<3){
				return false;
			}
			if (s.length>3){
				if (a.contains(s)){
					return true;
				}
				return false;
			}
			
			//try to find a match with the inital 3 letters
			for each (var i:String in monthNames){
				var t:String=i.substr(0,3);
				if (t == s){
					return true;	
				}
			}	
			
			return false;
		}
		
		private static function initCap(s:String):String{			
			return s.substr(0,1).toUpperCase()+s.substr(1,s.length-1);				
		}
		
	}	
}
