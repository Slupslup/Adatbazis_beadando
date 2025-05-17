Baranyi Balázs - t1lu8o
Dudás Tamás - lyw7wu
Varga Barnabás - hpplbl

Szépségszalon adatbázis
Ez a relációs modell egy szépségszalon foglalási és pénzügyi folyamatait írja le.

Ugyfel
Ügyfelek törzsadatai
id, név, telefonszám, email

Alkalmazottak
Dolgozók adatai
id, nev, csatlakozas

Választható szolgáltatások
id, megnevezes, megjegyzes, ar

Fizetes
Pénzügyi tranzakciók
id, idopont (dátum‑idő), osszeg, mod

Idopont
Foglalások
idopont_id, datum_ido, ugyfel_id, szolgaltatas_id, alkalmazott_id, fizetes_id

Kapcsolatok:

1‑N: Ugyfel → Idopont  (egy ügyfélnek több időpontja lehet)

1‑N: Alkalmazottak → Idopont  (egy dolgozó több foglalást kezelhet)

1‑N: Szolgaltatas → Idopont  (egy szolgáltatás többször foglalható)

1‑1: Fizetes → Idopont  (egy fizetés egy konkrét időponthoz tartozik)

![sql beadando_2025-05-17T21_19_27 380Z](https://github.com/user-attachments/assets/2fa68137-2f62-4a75-9f5f-20b8f36185f8)

