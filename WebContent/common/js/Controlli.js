function Vuoto(campo)
{
	if (campo=="")
		return true;
	else
		return false;
}

//controlla se la variabile 'campo' è un intero
function ControllaInt(campo)
{
	var esatta=new Boolean(true);

	var lunghezza=campo.length;
	var i=0;
	
	if(lunghezza>1 && campo.slice(0,1)=='-')
		i=1;
	
	for (i;i<lunghezza;i++)
		if (isNaN(parseInt(campo.slice(i,i+1),10)))
			esatta=false;
	return esatta;
}

//controlla se la variabile 'campo' è un intero positivo
function ControllaIntPosNeg(campo)
{
	var esatta=new Boolean(true);

	var lunghezza=campo.length;
	var i=0;

	if (lunghezza>1)
	{
		for (i=1;i<lunghezza;i++)
		{
			if (isNaN(parseInt(campo.slice(i,i+1),10)))
				esatta=false;
		}
		if (esatta && isNaN(parseInt(campo.slice(0,1),10)))
		{	
			if(campo.slice(0,1)!="-")
				esatta=false;
		}
	}
	else 
	{
		if (isNaN(parseInt(campo.slice(0,1),10)))
			esatta=false;
	}
	
	return esatta;
}

function ControllaData(data)
{
	var esatta=new Boolean(true);
	var i;
	var trattini;
	var dd="";
	var mm="";
	var yyyy="";

	data=data.replace(" ","");
		if (data.length<=10)
		{
			i=0;
			trattini=0;
			var cicla=true;
			while((cicla) && (i<data.length))
			{
				if (isNaN(parseInt(data.slice(i,i+1),10)))
				{
					if (data.charAt(i)=="/" && i!=0 && i!=(data.length-1))
						trattini++;
					else
						cicla=false;
				}
				else
				{
					if (trattini==0)
						dd=dd+data.charAt(i);
					if (trattini==1)
						mm=mm+data.charAt(i);
					if (trattini==2)
						yyyy=yyyy+data.charAt(i);
				}
				i++;
			}
			if ((trattini!=2) || (cicla==false))
			{
				esatta=false;
			}
			else
			{
				var gg=parseInt(dd,10);
				var mo=parseInt(mm,10);
				var aa=parseInt(yyyy,10);
				if ((aa<1900) || (aa>2200) || (mo<=0) || (mo>=13))
					esatta=false;
				else
				{
					switch (mo)
					{
						case 2:
							if ((gg<=0)||(gg>29))
								esatta=false;
							break;
						case 1:
						case 3:
						case 5:
						case 7:
						case 8:
						case 10:
						case 12:
							if ((gg<=0)||(gg>31))
								esatta=false;
							break;
						case 4:
						case 6:
						case 9:
						case 11:
							if ((gg<=0)||(gg>30))
								esatta=false;
							break;
					}
				}
			}
		}
		else
			esatta=false;

	return esatta;
}

function Selezionato(selectbox)
{
	return (selectbox.selectedIndex!=-1)
}

function textLimitExceed(obj,limit){
	var fine=(obj.value.length>limit);
	if (fine){
		obj.value=obj.value.substring(0,limit);
		alert("Stai inserendo un numero di caratteri superiore al consentito ("+limit+")");
	}
	return (fine);
}

/*Converte il valore di un campo hidden da 0 al valore di una 
  checkbox associata nel caso in cui il valore di questa sia TRUE*/
function AggiornaBooleano(checkboxfield, hiddenfield)
{
	hiddenfield.value = 0;
	if (checkboxfield.checked)
		hiddenfield.value = checkboxfield.value;
}


//controlla se il valore dell'editbox è numerico (intero e decimale indifferentemente)
//e sostituisce, se c'è, la virgola che separa i decimali con il punto

function controlValoreNumerico(EditBox)
{
	var intero=0, decimale=0;
	var numero=new Array(2);
	var posizione_virgola=0;
	var numerico=true;
	
	// sostituzione della virgola con il punto per i numeri decimali
	posizione_virgola=EditBox.value.indexOf(",")
	if(posizione_virgola!=-1)
	{
		intero=EditBox.value.substr(0,posizione_virgola);
		decimale=EditBox.value.substr(posizione_virgola+1,EditBox.value.length);
		EditBox.value = intero + "." + decimale;
	}
	else
	{
		numero=EditBox.value.split('.');
		intero=numero[0];
		decimale=(numero[1]===undefined ? "0" : numero[1]);
	}

	if(!ControllaIntPosNeg(intero) || !ControllaInt(decimale))
	{
		alert("Valore inserito non numerico!");
		EditBox.value = "";
		numerico=false;
	}
	
	return numerico;
}