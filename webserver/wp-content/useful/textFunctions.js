/**
 * @return the text of the given element, converted into an array of strings, delimited by
 * the given delimiter. Ignores blank items.
 */
function getLines(element /* element */, delimiter /* string */)
{
	var text = element.value;
	var lines = text.split(delimiter);
	var nonBlankLines = new Array();
	
	for(var i=0; i<lines.length; i++)
	{
		var line = lines[i].trim();
		if(line != "")
		{
			nonBlankLines.push(line);
		}
	}
	
	return nonBlankLines;
}

function concatenateLines(lines /* string [] */, delimiter /* string */)
{
	var text = "";
	for(var i = 0; i < lines.length; i++)
	{
		text += lines[i];
		if(i != lines.length-1)
		{
			text += delimiter;
		}
	}
	
	return text;
}

/**
 * String functions
 */
String.prototype.trim = function() 
{ 
	return this.replace(/^\s+|\s+$/g, ''); 
};

/**
 * Returns the delimiter that has been entered into the text box of the given id.
 */
function getDelimiter(elementId /* string */) /* string */
{
	var delimiter = document.getElementById(elementId).value;
	//log("delimiter='" + delimiter + "'");
	if(delimiter == '\\n' || delimiter == "")
	{
		//log("delim = \\n");
		return "\n";
	}
	return delimiter;
}


/**
 * Used by Array.sort()
 */
function compareIgnoreCase(a /* string */, b /* string */)
{
	a = a.toLowerCase(); 
	b = b.toLowerCase();
	if (a>b) return 1;
	if (a <b) return -1;
	return 0; 
}

/**
 * Extensions to the Array object
 */

//This affects the indexOf, add and remove methods
//but the case sensitivity of the sort method is controlled using a 
//pointer to the compareIgnoreCase method.
Array.prototype.isCaseSensitive = true;

Array.prototype.setCaseSensitive = function(caseSensitive /* boolean */)
{
	Array.prototype.isCaseSensitive = caseSensitive;
}

Array.prototype.indexOf = function(value /* var */)
{
	for (var i=0; i<this.length; i++)
	{
		if (this.isCaseSensitive)
		{
			if(this[i]==value)
			{
				return i;
			}
		} 
		else
		{
			if(this[i].toLowerCase() == value.toLowerCase())
			{
				return i;
			}
		}
	}
	return -1;
}

Array.prototype.contains = function(value /* var */)
{
	return this.indexOf(value) != -1;
}

Array.prototype.addAll = function(array /* array */)
{
	for(var i=0; i<array.length; i++)
	{
		this.push(array[i]);
	}
}

/**
 * Removes the array item matching the given item.
 * @param vItem the item to remove.
 * @return The removed item.
 */
Array.prototype.remove = function (vItem /*:variant*/) /*:variant*/ 
{
    this.removeAt(this.indexOf(vItem));    
    return vItem;
};

/**
 * Removes the array item in the given position.
 * @param iIndex The index of the item to remove.
 * @return The removed item.
 */
Array.prototype.removeAt = function (iIndex /*:int */) /*:variant*/
{
    var vItem = this[iIndex];
    if (vItem) 
    {
        this.splice(iIndex, 1);
    }
    return vItem;
};


if(Array.concat == undefined)
{
	Array.concat = function (array /*array*/) /* array */
	{
		var newArray = new Array[array.length];
		for(var i=0; i<array.length; i++)
		{
			newArray[i]= (array[i]);
		}
		return newArray;
	}
	
}

/*
 * Logging vars
 */
var logTextArea = null;
var isLoggingOn = null;

/**
 * Logs the text if the log row is displayed
 */
function log(text)
{
	if(logTextArea == null)
	{
		logTextArea = document.getElementById('log');
		isLoggingOn = true; //document.getElementById('logRow').style.display != "none";
	}
	
	if(isLoggingOn)
	{
	//alert(text);
		logTextArea.value += text + "\n";
	}
}

