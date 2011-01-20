{

20.01.2011
FÃ¼r Windows angepasst

13.06.2010
Abgeleitet aus vscplot
aber einfacher

- Fehlermeldung Henkel, Unna, gibt leere Dasteien aus bei Mittelung


 $Author: root $
 $Revision: 1.5 $
 $Log: vscplot.pp,v $
 Revision 1.5  2001-02-18 16:19:25+01  root
 Kann jetzt Diskettendatei schreiben

 Revision 1.4  2001-02-18 15:39:40+01  root
 *** Empty log message ***

 Revision 1.3  2001-02-16 15:10:58+01  root
 *** Empty log message ***

 Revision 1.2  2001-02-16 15:09:38+01  root
 *** Empty log message ***

 Revision 1.1  2001-02-16 12:41:04+01  root
 Initial revision

}

PROGRAM dat2txt;
{$MODE TP}
{$IFDEF DOS}
USES  vglob,  vfehler2;
{$ENDIF}

{$IFDEF LINUX}

{$ENDIF}
{Erzeugt aus Bin„rem Messdatenfile ASCII File f. Plotmtv
 aufruf mtvplot messdatei profildatei ausdatei xlabel ylabel autoscale}

TYPE

	prfty =
	RECORD
		t, v, Temp, M : double
	END;

        messsty = RECORD
                ZEIT : comp;
                regelaus, geschwindigkeit, moment, winkel, sollwert,
                momentmess, temperatur : double;
        END;

        messsfilety = FILE OF messsty;




VAR
	datei : FILE OF messsty;
	dateiprf, dmtv : TEXT;
	fehler : Boolean;
	mnr : integer;
	tempss : string;
	dumm : integer;
        messs : messsty;




PROCEDURE zeileschreiben(VAR datei : TEXT; t, v, Temp, M : double);

VAR wert : double;

BEGIN
(*        writeln(paramstr(9) + ' Zeile : t ',t:5:2, ' v: ',v:5:2,' Temp: ',Temp:5:2, ' M: ',M:5:2); *)
		wert := t;
		write(datei ,wert,#9);
		wert := v;
		write(datei,wert,#9);
		wert := Temp;
		write(datei,wert,#9);
		wert := M;
		write(datei, wert);
		write(datei, chr(13)); 
		write(datei, chr(10));


END;





PROCEDURE dateioeffnen;

VAR dateiname, dateinamemtv : string;

BEGIN
	IF paramstr(1) = '' THEN dateiname := 'default.dat' ELSE dateiname := paramstr(1);
{$I-}
	assign(datei, dateiname);
	reset(datei);
{$I+}
	IF ioresult <> 0 THEN

	BEGIN
		writeln('Fehler beim Lesen der Messdatei' + dateiname);
		exit;
	END;


	IF paramstr(2) = '' THEN dateinamemtv := 'default.txt' ELSE dateinamemtv := paramstr(2);

{$I-}
	assign(dmtv, dateinamemtv);
	rewrite(dmtv);
{$I+}
	IF ioresult <> 0 THEN

	BEGIN
		writeln('Kann TXT nicht schreiben');
		writeln('Fehler beim Schreiben der MTV - Datei');
		exit;
	END;



END;


PROCEDURE dateischliessen;

BEGIN
{$I-}
	close(datei);
{$I+}
	IF ioresult <> 0 THEN
	BEGIN
		writeln('Kann Datei nicht schliessen');
		exit;
	END;
{$I-}
	flush(dmtv);
{$I+}
	IF ioresult <> 0 THEN
	BEGIN
		writeln('Kann Datei dmtv nicht schliessen');
		exit;
	END;

	close(dmtv);
END;



PROCEDURE rumpf;



BEGIN
	WHILE not(eof(datei)) DO

	BEGIN
		WITH messs DO

		BEGIN
			read(datei, messs);
{			write(dmtv, ' t ');

			write(dmtv, (messs.zeit / (60*8000):6:2));
			write(dmtv,' v ');
			write(dmtv,  regelaus:5:2);
			write(dmtv,' T ');
			write(dmtv, temperatur:5:1);
			write(dmtv,' M ');
			write(dmtv, momentmess:7:1);
			write(dmtv, chr(13), chr(10)); }
			zeileschreiben(dmtv,(messs.zeit / (60*8000)), regelaus, temperatur, momentmess);

{		     writeln(dmtv);}

		END;{with}
	END;
END;



BEGIN



	IF (paramstr(1) = '') THEN

	BEGIN
		writeln('dat2txt');

		writeln('Erzeugt aus binaerem Messdatenfile vsc Daten ');


		writeln;
		writeln(' aufruf dat2txt');
		writeln(' liest Datei Dateien.dat ein und erzeugt die entsprechenden txt Files');
		writeln(' paramstr(1) = Eindatei paramstr(2) = ausdatei');
		writeln(' Reihenfolge der Spalten t v Temp M');


		exit;
	END;
        writeln;
	writeln('dat2txt aufgerufen mit: 1: ',paramstr(1), ' 2: ',paramstr(2),' 3: ', paramstr(3),' 4: ',paramstr(4), ' 5: ',
                paramstr(5),' 6: ',paramstr(6),' 7: ',paramstr(7),' 8: ',
                paramstr(8), ' 9: ', paramstr(9), ' 10: ',paramstr(10));

	dateioeffnen;
	writeln('Dateien geoeffnet');
	writeln('Kopf geschrieben');
	rumpf;
	writeln('Rumpf geschrieben');
	dateischliessen;
	writeln('Datei geschlossen');


END.
