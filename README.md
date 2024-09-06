# Dog24

---

##### Alles für den besten Freund – Spiel, Spaß, Stil und Genuss!



**Beschreibung**:  
In unserer App findest du alles, was dein Hund zum glücklich sein braucht: von lustigen Spielzeugen über Bekleidung bis hin zu leckeren Snacks. Entdecke eine breite Palette an Produkten, die speziell für das Wohl deines Vierbeiners entwickelt wurden. Ob zum Spielen, Wohlfühlen oder Verwöhnen – wir haben das Passende für deinen Hund.

**Zielgruppe**:  
Hundebesitzer, die ihren Vierbeiner nicht nur mit hochwertigen Spielzeugen und Kleidung ausstatten wollen, sondern auch mit leckeren Snacks verwöhnen möchten. Perfekt für alle, die das Beste für ihren Hund suchen.

**Was macht die App besonders?**  
Unsere App kombiniert alles, was Hunde lieben: von Spiel und Bewegung über Outfits bis hin zu gesunden Leckereien. Wir legen Wert auf Qualität und Vielfalt, damit jeder Hund – egal welcher Größe oder Rasse – das Richtige findet. Alles an einem Ort, einfach und bequem zu bestellen.

---

## Design

---

![Dog24](https://github.com/KalenderUsta/Dog24/blob/main/Dog24.jpg)

## Features

---

- [ ] **Große Produktauswahl**:  
  Spielzeuge, Bekleidung und Leckerlis – alles für deinen Hund an einem Ort.

- [ ] **Hochwertige Produkte**:  
  Fokus auf Qualität und Sicherheit, damit dein Hund nur das Beste bekommt.

- [ ] **Personalisierte Empfehlungen**:  
  Vorschläge basierend auf der Rasse, Größe und den Vorlieben deines Hundes.

- [ ] **Angebote und Rabatte**:  
  Exklusive Deals und Aktionen für treue Kunden.

- [ ] **Wunschliste**:  
  Speichere deine Lieblingsprodukte und bestelle sie später.

## Technischer Aufbau

---

#### Projektaufbau

In meinem Projekt setze ich die **MVVM-Architektur (Model-View-ViewModel)** ein, um eine klare Trennung zwischen Benutzeroberfläche und Logik zu gewährleisten. Die **Repository-Schicht** ist dafür verantwortlich, Daten von der API abzurufen. Diese Daten werden dann an das **ViewModel** weitergegeben, das die Logik für die Darstellung in der Benutzeroberfläche übernimmt. Auf diese Weise bleibt die Architektur sauber und leicht erweiterbar, und Außenstehende können sich schnell in der Ordnerstruktur zurechtfinden.

#### Datenspeicherung

In meiner App wird Firebase für die **Benutzerauthentifizierung** und das Speichern von Nutzerdaten verwendet. Sobald sich ein Kunde registriert oder anmeldet, werden alle personalisierten Daten, wie beispielsweise die gespeicherten Produkte, mit seinem Firebase-Konto verknüpft. Da Firebase eine cloudbasierte Lösung ist, wird eine **aktive Internetverbindung** benötigt, um die App zu nutzen und die Daten in Echtzeit abzurufen oder zu speichern. Offline-Funktionalitäten werden nicht unterstützt, da die Interaktion mit Firebase stets eine Verbindung zum Server erfordert. Firebase bietet dabei eine sichere und skalierbare Lösung für die Verwaltung und Speicherung von Nutzerdaten.

#### API Calls

Ich werde meine API verwenden die ich dafür zu verfügung steht.

#### 3rd-Party Frameworks

In meinem Projekt verwende ich ausschließlich **Firebase** als externes Framework. Firebase wird für die Authentifizierung und Datenspeicherung der Benutzerdaten eingesetzt. Es wird über **Swift Packages** in das Projekt integriert, um eine einfache Verwaltung und Updates sicherzustellen. Weitere externe Frameworks oder fertige SwiftUI-Views kommen in meiner App nicht zum Einsatz.

