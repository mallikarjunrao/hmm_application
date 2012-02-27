/**
 * @author farooq
 */

function checkAll(){
	if (document.getElementById('CheckAll').checked == true)
	{
		for (i = 1; i <=document.getElementById('len').value; i++) 
		{
			document.getElementById('colmn_'+i).checked = true;
		}
	}
	else 
	{
		for (i = 1; i <=document.getElementById('len').value; i++) 
		{
			document.getElementById('colmn_'+i).checked = false;
		}
	}
}

function confirmation() 
{
	for (i = 1; i <=document.getElementById('len').value; i++)
	{
		if (document.getElementById('colmn_'+i).checked == true)
		{
			
			var flag=1;
			break;
		}
		else
			flag=0;
	}
	if (flag == 0) 
	{
		alert("please check atleast one value");
		return false;
	}
	else 
	{
		var answer = confirm("Are You Sure That You Wanna Delete This Hmm User!!")
		if (answer) 
			{
				alert("You Have deleted The Selected Customer Record")
				return true;
			}
		else 
			{
			alert("You Have Aborted The Delete Process!!")
			return false;
			}
		
	}
}

