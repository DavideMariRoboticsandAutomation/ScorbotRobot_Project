Questo é un mio progetto scritto nel software PROCESSING realizzato durante i miei studi universitari.

Per chi non conoscesse il software PROCESSING:
E'un ambiente di sviluppo open source utilizzato per creare applicazioni grafiche interattive, visualizzazioni di dati, animazioni, arte generativa e altro ancora. Si basa sul linguaggio di programmazione Java ed è progettato per essere facile da imparare e usare anche per chi non ha una conoscenza approfondita della programmazione.Processing fornisce una vasta gamma di funzioni e librerie grafiche per rendere la creazione di immagini e animazioni più facile e veloce. Inoltre, è possibile integrare librerie di terze parti per estendere le funzionalità di base di Processing.E'stato creato per essere utilizzato sia da artisti che da programmatori e per supportare una vasta gamma di applicazioni, dall'arte digitale all'elaborazione di dati scientifici. È disponibile gratuitamente e può essere eseguito su diverse piattaforme, tra cui Windows, Mac OS X e Linux.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Track Project:
Lo SCORBOT si deve muovere in base alla configurazione (xd,yd,zd,βd,ωd) desiderata della pinza nello spazio di lavoro. 
L'assegnazione della configurazione desiderata della pinza va fatta nel seguente modo: con x minuscolo si diminuisce la coordinata x, con X maiuscolo la si aumenta (lo stesso discorso vale per le altre variabili, per β si può usare per esempio la lettera b e per ω la lettera w).
L'apertura e chiusura della pinza NON è richiesta come obiettivo del lavoro. 
SCEGLIERE COME TERNA DI RIFERIMENTO (x0,y0,z0)
TRASCURARE per semplicità il problema delle COLLISIONI tra i vari link del robot.
Deve essere possibile da tastiera selezionare la soluzione GOMITO ALTO e GOMITO BASSO ma anche la soluzione che fa lavorare il robot PROTESO in AVANTI (quella delle formule viste a lezione) o RIVOLTO all'INDIETRO (vedere i suggerimenti sotto per ricavare le formule in questo caso).
Scrivere sullo schermo il valore delle coordinate richieste (xd,yd,zd,βd,ωd), quello degli angoli (in gradi) di giunto θi, i=1,2,...,5 via via raggiunti e la matrice R05 che descrive l'orientamento della mano rispetto alla terna di base.
Valutare se le due soluzioni ROBOT in AVANTI e ROBOT all'INDIETRO permettono di raggiungere le stesse configurazioni desiderate per la pinza oppure se alcune configurazioni possono essere ottenute solo col robot in avanti e altre solo col robot all'indietro.
