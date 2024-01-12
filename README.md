# reti-logiche-22-23
Prova finale di reti logiche a.a. 2022/2023 del Politecnico di Milano

## Descrizione generale
La specifica della Prova Finale (Progetto di Reti Logiche) per l’Anno Accademico
2022/2023 chiede di implementare un modulo HW (descritto in VHDL) che si interfacci con
una memoria.
Ad elevato livello di astrazione, il sistema riceve indicazioni circa una locazione di memoria,
il cui contenuto deve essere indirizzato verso un canale di uscita fra i quattro disponibili.
Le indicazioni circa il canale da utilizzare e l’indirizzo di memoria a cui accedere vengono
forniti mediante un ingresso seriale da un bit, mentre le uscite del sistema, ovvero i succitati
canali, forniscono tutti i bit della parola di memoria in parallelo.

## Interfacce
Il modulo da implementare ha due ingressi primari da 1 bit ( W e START ) e 5 uscite
primarie . Le uscite sono le seguenti: quattro da 8 bit ( Z0, Z1, Z2, Z3 ) e una da 1 bit ( DONE ).
Inoltre, il modulo ha un segnale di clock CLK , unico per tutto il sistema e un segnale di reset
RESET anch’esso unico.

## Funzionamento Dettagliato
- Al momento del reset del sistema, le uscite sono inizializzate come segue: `Z0`, `Z1`, `Z2`, `Z3` sono 0000 0000, mentre `DONE` è 0.
- I dati in ingresso (`W`) sono organizzati in sequenze contenenti 2 bit di intestazione seguiti da `N` bit di indirizzo della memoria. Questi bit permettono di costruire un indirizzo di memoria.
- Gli indirizzi di memoria variano da 0 a un massimo di 16 bit. Se il numero di bit `N` è inferiore a 16, l'indirizzo viene esteso con zeri sui bit più significativi.
- La sequenza di ingresso è valida quando il segnale `START` è alto (=1) e termina quando `START` è basso (=0).
- Il segnale `START` rimane alto per almeno 2 cicli di clock e non più di 18 cicli di clock.
- Le uscite `Z0`, `Z1`, `Z2`, `Z3` sono inizialmente 0. I valori rimangono inalterati, tranne il canale su cui viene mandato il messaggio letto in memoria, visibile solo quando `DONE` è 1.
- Quando `DONE` è 0, tutti i canali devono essere a zero. Quando `DONE` è 1, il canale associato al messaggio cambierà il suo valore, mentre gli altri canali mostreranno l'ultimo valore trasmesso.
- Il tempo massimo per produrre il risultato (da `START`=0 a `DONE`=1) deve essere inferiore a 20 cicli di clock.
