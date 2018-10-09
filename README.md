# PRTG_IBMStorwizeSensor
<p>
Dieses Projekt probiert die fehlenden SNMP Daten von einem Storwize System per ssh in eine PRTG Umgebung zu holen. 
Das Programm verbidnet sich von einem Windowsserver per ssh mit einem IBM Storwize System, setzt einen bash Befehl ab, und wandelt die Antwort in ein JSON um welches PRTG versteht. 

Da ich keine Dokumentation gefunden habe, wie man ein echtes Plugin schreiben kann, habe ich nur einen "Advanced EXE/Script Sensor" geschrieben. Diesen muss man auf einen der Windows Probe Server kopieren und dann die benötigten Infos per Parameter übergeben. 
</p>
<p>
Die Exe benötigt mindestens 5 Parameter.</br>
</br>
> StorwizeSensor.exe < host > < port > < username > < password > < IBMCommand > </br>
</br>  
Optional kann man dem Programm sagen, dass es nur bestimmte Feldnummern als Sensoren zurück geben soll.</br>
</br>
```
StorwizeSensor.exe < host > < port > < username > < password > < IBMCommand > < optional: 1..n : FieldNrs that should be returned > </br> 
```
</br>
</p>


<p>
Parameter Anwendungbeispiele (Die IP muss natürlich durch die IP des Storwize Systems ersetzt werden): </br>
</br>
Hole alle aktuellen Statistikdaten des Systems </br>
> 192.168.0.1 22 %linuxuser %linuxpassword lssystemstats 1 </br>
</br>
Hole die aktuelle Belegung der Festplattengruppen </br>
> 192.168.0.1 22 %linuxuser %linuxpassword "lsmdiskgrp -bytes" 5 7 9 10 </br>
</br>
Zeige mir den Status der Global Mirrors an: </br>
> 192.168.0.1 22 %linuxuser %linuxpassword "lsrcrelationshipprogress rcrel0" </br>
</p>

