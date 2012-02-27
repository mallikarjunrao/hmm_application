/**
 * Date Validation for admin section
 */

function Check_Date(formname){
		
	var From_Year=document.getElementById("from_bdate_ordermonthdayyearstart_year1908_1i").value;
	var From_Month=document.getElementById("from_bdate_ordermonthdayyearstart_year1908_2i").value;
	var From_Day=document.getElementById("from_bdate_ordermonthdayyearstart_year1908_3i").value;
	if(From_Day<10){
		From_Day=0+""+From_Day;
	}
	if(From_Month<10){
		From_Month=0+""+From_Month;
	}
	
	var From_Date=From_Year+"-"+From_Month+"-"+From_Day;
	
	var To_Year=document.getElementById("to_bdate_ordermonthdayyearstart_year1908_1i").value;
	var To_Month=document.getElementById("to_bdate_ordermonthdayyearstart_year1908_2i").value;
	var To_Day=document.getElementById("to_bdate_ordermonthdayyearstart_year1908_3i").value;
	if(To_Month<10){
		To_Month=0+""+To_Month;
	}
	if(To_Day<10){
		To_Day=0+""+To_Day;
	}
	var To_Date=To_Year+"-"+To_Month+"-"+To_Day;

	if(From_Date > To_Date){
		
		alert("From Date Cant be Greater then To Date!!")
		return false;
	}
 return true;
	
}