
# Roboterarm

Wir haben den Roboterarm von dem YouTuber "Skyentific" upgedatet, eine eigene Steuerelektronik dafür entwickelt und einen Softwarecontroller für den PC geschrieben, über die der Roboterarm grafisch programmiert werden kann.
<hr>
<br>

![Roboter Preview](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/StartA1.jpg?raw=true)
<br>

<hr>


![Roboter Preview](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/StartA2.jpg?raw=true)
<br>

<hr>


![Firmware Preview](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/StartA0.jpg?raw=true)
<br>
<hr>

Alle CAD-Dateien und die ursprüngliche Dokumnentation können über diesen Link auf dem [Repo von Skyentific](https://github.com/SkyentificGit/SmallRobotArm) abgerufen werden
<br>

Die Bestellliste um die Teile für den Roboter im europäischen Raum bestellen zu können, befindet sich [hier](/Warenkorb)
<br>

Die Eagle-Dateien für das Controllerboard finden sich [hier](/Elektronik/Eagle), die Gerberfiles [hier](/Elektronik/Gerber)
<br>
Nachdem das Board nach den EAGLE-Dateien aufgebaut wurde, können die Schrittmotor-Treiber, sowie der Teensy auf das Board aufgesteckt werden.
<br>
Anschließend muss die Firmware auf den Controller geladen werden, was in diesem [README](/Firmware) erklärt wird.


⋅⋅⋅![Board Preview](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/MainboardC2.png?raw=true)

Wenn der Roboter selbst fertig aufgebaut ist, was nach der Dokumentation von Skyentific gemacht werden sollte, können Die Motoranschlussleitungen mit dem Controllerboard verbunden werden. Die Günstigste Variante wäre, die Anschlussleitungen direkt auf das Controllerboard zu löten. Soll es etwas Profesioneller aussehen, können stattdesen auch Stift und Buchsenleisten verwendet werden.

Als nächstes benötigt man ein altes PC-ATX-Netzteil. Wir haben so eines schon gehabt, aber dafür kann man jedes herkömmliche ATX-Netzteil, welches auf Amazon erhältlich ist verwenden. Die Anschlussleitung, die normalerweise auf das Mainboard aufgesteckt wird, das ist der Breiteste von den Steckern am Netzteil, sollte aufgtrennt werden, am besten kurz vor dem Stecker, und über die Anschlussblöcke anhand der Platinenbeschriftung angesteckt werden. Folgender Farbcode ist zwar eigentlich genormt, man sollte aber umbedingt mit einem Multimeter vor anschluss des Kabels überprüfen, ob an den entsprechenden Leitungen die richtigen Spannungen anliegen

⋅⋅⋅![Board Pinout](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/PinoutA1.PNG?raw=true)

Der Anschluss des Netzteils sollte unbedingt gewissenhaft durchgeführt werden, da bei fehlerhafter Versorgung unter Umstäden großer Schaden am Controllerboard entstehen kann.
<br>
um das System zu Starten, muss zu erst das Netzteil entsprechend der Herstellerbestimmungen mit Spannnung versorgt werden. Meist über ein Kaltgerätekabel in der Steckdose.

Damit der Controller ordungsgemäß funktioniert, muss bevor der Controller hochfährt der Roboter in  folgender Grundstellung stehen:

⋅⋅⋅![Board Pinout](https://github.com/AMPrO-3D/Roboterarm/blob/main/blob/Bilder/GrundstellungA1.PNG?raw=true)

Als nächstes muss der Controller über ein USB-Micro Kabel an einem Computer angeschlossen werden, woraufhin der Controller hochfahren und die Schrittmotoren bestromt werden sollten. Dies erkennt man daran, das die Motoren ein Haltemoment aufbauen, wenn man die Motoren verucht manuell zu drehen. 

Wenn bis hierhin alles Funktioniert hat, kann man den Roboterarm über den [MotionController](/MotionController) gesteuert werden.
###### Anmerkung: Damit die Software funktionieren kann, müssen die Treiber über die Installation der Firmware installiert sein und auf dem PC die aktuelle JAVA-Version installiert sein