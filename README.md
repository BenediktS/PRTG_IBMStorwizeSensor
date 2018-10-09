# PRTG_IBMStorwizeSensor

Dieses Projekt probiert die fehlenden SNMP Daten von einem Storwize System per ssh in eine PRTG Umgebung zu holen. 
Das Programm verbidnet sich von einem Windowsserver per ssh mit einem IBM Storwize System, setzt einen bash Befehl ab, und wandelt die Antwort in ein JSON um welches PRTG versteht. 

Da ich keine Dokumentation gefunden habe, wie man ein echtes Plugin schreiben kann, habe ich nur einen "Advanced EXE/Script Sensor" geschrieben. Diesen muss man auf einen der Windows Probe Server kopieren und dann die benötigten Infos per Parameter übergeben. 


<br>

Die Exe benötigt mindestens 5 Parameter.

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand>`

Optional kann man dem Programm sagen, dass es nur bestimmte Feldnummern als Sensoren zurück geben soll.</br>

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand> <1..n : FieldNrs that should be returned> `

<br><br>


#### Parameter Anwendungbeispiele (getestet an einem Storwize 3700 Systems)
(Die IP muss natürlich durch die IP des Storwize Systems ersetzt werden)

Hole alle aktuellen Statistikdaten des Systems 
> 192.168.0.1 22 %linuxuser %linuxpassword lssystemstats 1 

Hole die aktuelle Belegung der Festplattengruppen 
> 192.168.0.1 22 %linuxuser %linuxpassword "lsmdiskgrp -bytes" 5 7 9 10 

Zeige mir den Status des ersten Global Mirrors an: 
> 192.168.0.1 22 %linuxuser %linuxpassword "lsrcrelationshipprogress rcrel0"
