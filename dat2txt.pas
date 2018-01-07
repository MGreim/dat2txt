{


03.01.2017
- nochmal etwas verschoenert f. OTH R. 

13.06.2010
Abgeleitet aus vscplot
aber einfacher

- Fehlermeldung Henkel, Unna, gibt leere Dasteien aus bei Mittelung

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

{$ENDIF}

{$IFDEF LINUX}

{$ENDIF}
{Erzeugt aus Binaerem Messdatenfile ASCII File f. Plotmtv
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
	dumm : integer;
        messs : messsty;




PROCEDURE zeileschreiben(VAR datei : TEXT; t, v, Temp, M, winkel : double);

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
		write(datei, wert,#9);
                wert := winkel;
		write(datei, wert,#10);



END;





PROCEDURE zeileschreibenx(VAR datei : TEXT; t, regelaus, geschwindigkeit, moment, winkel, sollwert, momentmess, temperatur : double);

VAR wert : double;

BEGIN
(*        writeln(paramstr(9) + ' Zeile : t ',t:5:2, ' v: ',v:5:2,' Temp: ',Temp:5:2, ' M: ',M:5:2); *)
		wert := t;
		write(datei ,wert,#9);
		wert := regelaus;
		write(datei,wert,#9);
		wert := geschwindigkeit;
		write(datei,wert,#9);
		wert := moment;
		write(datei, wert,#9);
                wert := winkel;
		write(datei, wert,#9);
		wert := sollwert;
		write(datei,wert,#9);
		wert := momentmess;
		write(datei, wert,#9);
                wert := temperatur;
		write(datei, wert,#10);



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


	IF paramstr(3) = '' THEN dateinamemtv := 'default.txt' ELSE dateinamemtv := paramstr(3);

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
		writeln('Kann Datei nicht schliessen');
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
			zeileschreiben(dmtv,(messs.zeit / (60*8000)), regelaus, temperatur, momentmess, winkel);

		END;{with}
	END;
END;



PROCEDURE rumpfx;



BEGIN
	WHILE not(eof(datei)) DO

	BEGIN
		WITH messs DO

		BEGIN
		read(datei, messs);
      (*        Datenstruktur der Binaerdatei: 
    		Die Zeit wird in 1/8000 Sekunden (= Durchlaufzeit des Reglers) hochgezaehlt. 
    		Der Datentyp COMP: 
    		Wertebereich: -2E64+1 .. 2E63-1
    		Genauigkeit: 19 Stellen
    		Speicherbedarf: 8 Byte bzw. 64 Bit
    		1 Vorzeichen | 63 Mantisse
    		
    		Sonstiges: Der Datentyp Comp wird nur bei Prozessoren vom Typ Intel 80x86 angeboten
    		
    		Der Datentyp DOUBLE: 
    		Wertebereich: 5.0E-324 .. 1.7E308
    		Genauigkeit: 15 Stellen
    		Speicherbedarf: 8 Byte bzw. 64 Bit
    		1 Vorzeichen | 11 Expoent  | 52 Mantisse (IEEE)
    		
      
    		messsty = RECORD
                ZEIT : comp;
                regelaus, geschwindigkeit, moment, winkel, sollwert,
                momentmess, temperatur : double ; 
                
                Aus historischen Gründen wird das Moment zweimal gespeichert: 
                moment : korrigiert um Nullpunkt
                momentmess : Rohwert
                
                *)



      		zeileschreibenx(dmtv,(messs.zeit / (60*8000)), regelaus, geschwindigkeit, moment, winkel, sollwert, momentmess, temperatur);

{		     writeln(dmtv);}

		END;{with}
	END;
END;




BEGIN



	IF (paramstr(1) = '') THEN

	BEGIN
		writeln('dat2txt');

		writeln('Erzeugt aus binaerem Messdatenfile Textdatei ');


		writeln;
		writeln(' aufruf dat2txt infile Trennzeichen outfile X');
		writeln;
		writeln(' liest Datei Dateien.dat ein und erzeugt die entsprechenden txt Files');
		writeln(' paramstr(1) = Messdatei mit der Endung dat');
		writeln(' paramstr(2) = Trennzeichen Komma oder Punkt');
		writeln(' paramstr(3) = Messdatei als Textfile');
		writeln(' paramstr(4) = wenn X gesetzt, dann erweitertes Format');
		writeln;
                writeln(' t regelaus, v, M, Winkel, Sollwert, Momentmess, temperatur');
                writeln(' geschrieben (Reihenfolge wie in Messty), sonst nur ');

		writeln(' t v Temp M Winkel');


		exit;
	END;
        writeln;
	writeln('dat2txt aufgerufen mit: 1: ',paramstr(1), ' 2: ',paramstr(2),' 3: ', paramstr(3), ' 4: ', paramstr(4));

	dateioeffnen;
        IF paramstr(4) = 'X' THEN rumpfx ELSE rumpf;
	dateischliessen;


END.
