dat2txt (Linux) or dat2txt.exe (Windows)

Commandline tool to convert the viskomat *.dat files to txt files. 
usage: 

dat2txt infile delimiter outfile extended_options


infile:    name of the dat file 
delimiter: , or . giving 123.456 or the Euorpean format 123,456 for all numbers
outfile: name ouf the output text file
extended_options: if set to X the columns are:
		      t regelaus, v, M, Winkel, Sollwert, Momentmess, Temp
		  if not set
		      t v Temp M Winkel
		  where
		    t: time in minutes
		    v: speed in rpm
		    Temp: temperature
		    M : Torque
		    Winkel : angle

		    regelaus: target speed value or some different value (not defined yet)
		    Sollwert: target speed value
		    Momentmess: torque read via another software channel (for internal use only)

For details please check the source code. 
The program may be compile with the freepascal compiler or Lazarus for Windows, Linux, Mac or others. 
(c) Schleibinger Geräte Teubert u. Greim GmbH, Germany, 1999..2018
------------------------------------------------------------------------------------------------------

dat2txt.pas
ist der Quellcode in Pascal um die originalen binären Messdateien nach ASCII zu konvertieren. 

dat2txt
Erzeugt aus binaerem Messdatenfile Textdatei 

 aufruf dat2txt infile Trennzeichen outfile X

 liest Datei Dateien.dat ein und erzeugt die entsprechenden txt Files
 paramstr(1) = Messdatei mit der Endung dat
 paramstr(2) = Trennzeichen Komma oder Punkt
 paramstr(3) = Messdatei als Textfile
 paramstr(4) = wenn X gesetzt, dann erweitertes Format

 t regelaus, v, M, Winkel, Sollwert, Momentmess, temperatur
 geschrieben (Reihenfolge wie in Messty), sonst nur 
 t v Temp M Winkel

Details im Quellcode. 
Das Programm kann unter Freepacal sowohl f. Linux als auch f. Windows etc. compiliert werden. 
Unter Lazarus kann man sich dazu auch noch eine GUI machen wenn man möchte. 
Oder einfach in Matlab als externe Programm aufrufen. 
Matlab kann die erzeugten Textdateien ohne Probleme einlesen. 
Unter Linux wird als Zeielende LF verwendet, unter Windows CR LF. 
Die Textspalten sind mit Tabs ($9) getrennt. 

Die Viskomat Messdateien mit der Endung .dat liegen im Verzeichnis: 

/usr/local/httpd/htdocs/daten

(c) M. Greim, Schleibinger Geräte Teubert u. Greim GmbH. 


