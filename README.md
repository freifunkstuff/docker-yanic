# Dockerisierter Yanic

Yanic ist ein Client für respondd und verantwortlich, Knoten-Broadcasts einzusammeln und daraus die Knoten-Daten für die Karte zu generieren. Der Container verwendet das Netzwerk von "fastd", um Zugang zum Feifunk-Netz zu bekommen.

Die generierten Daten werden auf ein Volume geschrieben, welches vom Meshviewer-Kartenserver aus zugäglich ist.

Umgebungsvariablen:

* `INFLUXDB_URL` (benötigt): Adresse eines Influxdb-kompatiblen Datensammlers (z.B. VictoriaMetrics)
* `INFLUXDB_DATABASE` (default: nodes): Datenbankname
