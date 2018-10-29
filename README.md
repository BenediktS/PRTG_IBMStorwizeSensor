[Deutsche Anleitung](#prtg_ibmstorwizesensor-1)
# PRTG_IBMStorwizeSensor  

The Storwize systems don't export statistic data via SNMP. This program tries to get the statistic data from a Storwize system into the PRTG server. The program will be installed on a windows probe server, and will extract the data from the Storwize system via ssh. (So the ssh service has to run on the Storwize system. By default it is running)

You have to follow the installation instructions for a "Advanced EXE/Script Sensor" on a windows probe server. 

<br>

The program needs 5 parameter

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand>`

Optional you could tell the program which fields it should collect as a result.</br>

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand> <1..n : FieldNrs that should be returned> `

<br><br>


#### Sensor parameter examples (tested with a Storwize 3700 system)
(Ofcourse you have to replace the IP with the IP of your Storwize system)
<br><br>

Get system statistics
> 192.168.0.1 22 %linuxuser %linuxpassword lssystemstats 1 

Get disk usage statistics
> 192.168.0.1 22 %linuxuser %linuxpassword "lsmdiskgrp -bytes" 5 7 9 10 

Get the status of the first global mirror
> 192.168.0.1 22 %linuxuser %linuxpassword "lsrcrelationshipprogress rcrel0"


<br><br>

Precompiled exe files are released here: https://github.com/BenediktS/PRTG_IBMStorwizeSensor/releases

<br>

<br>

### compiling the project

To compile the project, you need the SSH Components from Devart. ( https://www.devart.com/sbridge/ )

This components are only used in the uDevartSSHConnector.pas. <br>
I couldn't find a ssh shell from delphi itself. <br>
I would be pleased to hear from you, that i am wrong. <br>

<br>

<br>

<br>


# <a name="Anleitung_Deutsch"></a>PRTG_IBMStorwizeSensor 

Dieses Projekt probiert die fehlenden SNMP Daten von einem Storwize System per ssh in eine PRTG Umgebung zu holen. 
Das Programm verbidnet sich von einem Windowsserver per ssh mit einem IBM Storwize System, setzt einen bash Befehl ab, und wandelt die Antwort in ein JSON um welches PRTG versteht. 

Da ich keine Dokumentation gefunden habe, wie man ein echtes Plugin schreiben kann, habe ich nur einen "Advanced EXE/Script Sensor" geschrieben. Diesen muss man auf einen der Windows Probe Server kopieren und dann die benötigten Infos per Parameter übergeben. 


<br>

Die Exe benötigt mindestens 5 Parameter.

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand>`

Optional kann man dem Programm sagen, dass es nur bestimmte Feldnummern als Sensoren zurück geben soll.</br>

`StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand> <1..n : FieldNrs that should be returned> `

<br><br>


#### Parameter Anwendungbeispiele (getestet an einem Storwize 3700 System)
(Die IP muss natürlich durch die IP des Storwize Systems ersetzt werden)
<br><br>

Hole alle aktuellen Statistikdaten des Systems 
> 192.168.0.1 22 %linuxuser %linuxpassword lssystemstats 1 

Hole die aktuelle Belegung der Festplattengruppen 
> 192.168.0.1 22 %linuxuser %linuxpassword "lsmdiskgrp -bytes" 5 7 9 10 

Zeige mir den Status des ersten Global Mirrors an: 
> 192.168.0.1 22 %linuxuser %linuxpassword "lsrcrelationshipprogress rcrel0"


<br><br>

Aktuelle Exe-Files findet man unter den Releases https://github.com/BenediktS/PRTG_IBMStorwizeSensor/releases

<br>

<br>

### Compilieren des Projekts.

Zum kompilieren des Projekts benötigt man in der aktuellen Version die SSH Komponenten von Devart.
(https://www.devart.com/sbridge/)

Diese Komponenten werden für die Unit uDevartSSHConnector.pas benötigt. 
Ich habe bisher keine SSH Shell implementierung von Embarcadero selber gefunden. 
Nehme aber gerne Hinweise darauf an :) 

