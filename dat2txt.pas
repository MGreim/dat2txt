{

Do 17 Apr 2025 11:54:14 CEST
- compiliert f. Linux mit fpc 3.0.4 und  Windows 64 bit mit fpc 3.2.2

08.01.2018
- compiliert f. Windows 32 bit mit fpc 3.0.4

03.01.2018
- nochmal etwas verschoenert f. OTH R.

13.06.2010
Abgeleitet aus vscplot
aber einfacher

- Fehlermeldung Henkel, Unna, gibt leere Dasteien aus bei Mittelung

 Revision 1.5  2001-02-18 16:19:25+01  root
 Kann jetzt Diskettendatei schreiben

 Revision 1.1  2001-02-16 12:41:04+01  root
 Initial revision

}

PROGRAM dat2txt;
{$MODE TP}
{$IFDEF DOS}

{$ENDIF}

{$IFDEF LINUX}

{$ENDIF}

USES strutils;

TYPE



        messsty = RECORD
                ZEIT : comp;
                regelaus, geschwindigkeit, moment, winkel, sollwert,
                momentmess, temperatur : double;
        END;




VAR
	datei : FILE OF messsty;
	dmtv : TEXT;
        messs : messsty;


FUNCTION trenn(trenner : string; x : double) : string;

    VAR xs : string;

    BEGIN
    xs := '';
    str(x, xs);
    IF trenner = '.' THEN
        BEGIN
        trenn := xs;
        END
      ELSE
        BEGIN
        trenn := ReplaceStr(xs, '.', trenner);
        END;
    END;




PROCEDURE zeileschreiben(VAR datei : TEXT; t, v, Temp, M, winkel : double; tr : string);

VAR wert : string;

BEGIN
IF tr = '' THEN tr := '.';

(*        writeln(paramstr(9) + ' Zeile : t ',t:5:2, ' v: ',v:5:2,' Temp: ',Temp:5:2, ' M: ',M:5:2); *)
		wert := trenn(tr,t);
		write(datei ,wert,#9);
		wert := trenn(tr,v);
		write(datei,wert,#9);
		wert := trenn(tr,Temp);
		write(datei,wert,#9);
		wert := trenn(tr,M);
		write(datei, wert,#9);
                wert := trenn(tr,winkel);
		write(datei, wert,#10);



END;





PROCEDURE zeileschreibenx(VAR datei : TEXT; t, regelaus, geschwindigkeit, moment, winkel, sollwert, momentmess, temperatur : double; tr : string);

VAR wert : string;

BEGIN
(*        writeln(paramstr(9) + ' Zeile : t ',t:5:2, ' v: ',v:5:2,' Temp: ',Temp:5:2, ' M: ',M:5:2); *)
		wert := trenn(tr, t);
		write(datei ,wert,#9);
		wert := trenn(tr,regelaus);
		write(datei,wert,#9);
		wert := trenn(tr,geschwindigkeit);
		write(datei,wert,#9);
		wert := trenn(tr,moment);
		write(datei, wert,#9);
                wert := trenn(tr,winkel);
		write(datei, wert,#9);
		wert := trenn(tr,sollwert);
		write(datei,wert,#9);
		wert := trenn(tr,momentmess);
		write(datei, wert,#9);
                wert := trenn(tr,temperatur);
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



PROCEDURE rumpf(trenner : string);



BEGIN
	WHILE not(eof(datei)) DO

	BEGIN
		WITH messs DO

		BEGIN
			read(datei, messs);
			zeileschreiben(dmtv,(messs.zeit / (60*8000)), regelaus, temperatur, momentmess, winkel, trenner);

		END;{with}
	END;
END;



PROCEDURE rumpfx(trenner : string);



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



      		zeileschreibenx(dmtv,(messs.zeit / (60*8000)), regelaus, geschwindigkeit, moment, winkel, sollwert, momentmess, temperatur, trenner);

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
	IF paramstr(3) = '' THEN writeln('Ausgabedatei default.txt');
	dateioeffnen;
        IF paramstr(4) = 'X' THEN rumpfx(paramstr(2)) ELSE rumpf(paramstr(2));
	dateischliessen;


END.
