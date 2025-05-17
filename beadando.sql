/* Adatok létrehozása*/

CREATE TABLE Ugyfel (
    id INT PRIMARY KEY IDENTITY,
    név VARCHAR(100) NOT NULL,
    telefonszám VARCHAR(20),
    email VARCHAR(100)
);
 
CREATE TABLE Alkalmazottak (
    id INT PRIMARY KEY IDENTITY,
    nev VARCHAR(100) NOT NULL,
    csatlakozas DATE
);
 
CREATE TABLE Szolgaltatas (
    id INT PRIMARY KEY IDENTITY,
    megnevezes VARCHAR(100) NOT NULL,
    megjegyzes TEXT,
    ar INT CHECK (ar >= 0)
);
 
CREATE TABLE Fizetes (
    id INT PRIMARY KEY IDENTITY,
    idopont DATETIME NOT NULL,
    osszeg INT CHECK (osszeg >= 0),
    mod VARCHAR(20) CHECK (mod IN ('készpenz', 'kártya', 'utalás'))
);
 
CREATE TABLE Idopont (
    idopont_id INT PRIMARY KEY IDENTITY,
    datum_ido DATETIME NOT NULL,
    ugyfel_id INT FOREIGN KEY REFERENCES Ugyfel(id),
    szolgaltatas_id INT FOREIGN KEY REFERENCES Szolgaltatas(id),
    alkalmazott_id INT FOREIGN KEY REFERENCES Alkalmazottak(id),
    fizetes_id INT FOREIGN KEY REFERENCES Fizetes(id)
);

/* Adatok betöltése */

-- Ugyfel
SET IDENTITY_INSERT dbo.Ugyfel ON;
INSERT INTO dbo.Ugyfel (id, név, telefonszám, email) VALUES
  (1, N'John Doe',        '06301234567', 'john.doe@example.com'),
  (2, N'Kovács Anna',     '06201234567', 'anna.kovacs@example.com'),
  (3, N'Müller Péter',    '06302223344', 'peter.muller@example.com'),
  (4, N'Nagy Éva',        '06301239876', 'eva.nagy@example.com'),
  (5, N'Szabó Gábor',     '06701230011', 'gabor.szabo@example.com');
SET IDENTITY_INSERT dbo.Ugyfel OFF;

-- Alkalmazottak
SET IDENTITY_INSERT dbo.Alkalmazottak ON;
INSERT INTO dbo.Alkalmazottak (id, nev, csatlakozas) VALUES
  (1, N'Tóth Krisztián', '2023-06-01'),
  (2, N'Simon Laura',    '2024-02-15'),
  (3, N'Horváth Bence',  '2024-09-01');
SET IDENTITY_INSERT dbo.Alkalmazottak OFF;

-- Szolgaltatas
SET IDENTITY_INSERT dbo.Szolgaltatas ON;
INSERT INTO dbo.Szolgaltatas (id, megnevezes, megjegyzes, ar) VALUES
  (1, N'Hajvágás',  N'Rövid frizura igazítása', 6000),
  (2, N'Festés',    N'Teljes hajhossz',        15000),
  (3, N'Manikűr',   N'Géllakkozás',             5000),
  (4, N'Masszázs',  N'Aromaterápiás',          12000);
SET IDENTITY_INSERT dbo.Szolgaltatas OFF;

-- Fizetes
SET IDENTITY_INSERT dbo.Fizetes ON;
INSERT INTO dbo.Fizetes (id, idopont, osszeg, mod) VALUES
  (1, '2025-05-05 09:00:00', 6000, N'készpenz'),
  (2, '2025-05-05 10:00:00', 15000, N'kártya'),
  (3, '2025-05-07 11:00:00', 5000, N'utalás'),
  (4, '2025-05-08 09:00:00', 12000, N'kártya'),
  (5, '2025-05-08 10:00:00', 6000, N'készpenz'),
  (6, '2025-05-08 11:00:00', 5000, N'utalás'),
  (7, '2025-05-10 10:00:00', 15000, N'kártya'),
  (8, '2025-05-10 11:00:00', 12000, N'készpenz'),
  (9, '2025-05-13 09:00:00', 6000, N'készpenz'),
  (10,'2025-05-14 09:30:00', 5000, N'utalás'),
  (11,'2025-05-14 10:30:00', 6000, N'kártya'),
  (12,'2025-05-15 11:00:00', 12000, N'kártya'),
  (13,'2025-05-17 10:00:00', 6000, N'készpenz');
SET IDENTITY_INSERT dbo.Fizetes OFF;

-- Idopont 
SET IDENTITY_INSERT dbo.Idopont ON;
INSERT INTO dbo.Idopont (idopont_id, datum_ido, ugyfel_id, szolgaltatas_id, alkalmazott_id, fizetes_id) VALUES
  (1, '2025-05-05 09:00:00', 1, 1, 1, 1),
  (2, '2025-05-05 10:00:00', 2, 2, 2, 2),
  (3, '2025-05-07 11:00:00', 3, 3, 3, 3),
  (4, '2025-05-08 09:00:00', 4, 4, 1, 4),
  (5, '2025-05-08 10:00:00', 5, 1, 2, 5),
  (6, '2025-05-08 11:00:00', 1, 2, 3, 6),
  (7, '2025-05-10 10:00:00', 2, 3, 1, 7),
  (8, '2025-05-10 11:00:00', 3, 4, 2, 8),
  (9, '2025-05-13 09:00:00', 4, 1, 3, 9),
  (10,'2025-05-14 09:30:00', 5, 2, 1, 10),
  (11,'2025-05-14 10:30:00', 1, 3, 2, 11),
  (12,'2025-05-15 11:00:00', 2, 4, 3, 12),
  (13,'2025-05-17 10:00:00', 3, 1, 1, 13);
SET IDENTITY_INSERT dbo.Idopont OFF;

/*Lekérdezések*/

/*Megmutatja az egyes alkalmazottak heti bevételeit, az alkalmazottak teljes heti bevételét (összes hétre), a hetek teljes bevételét (összes alkalmazottra), valamint a végső teljes bevételt*/
WITH HetiBevetelek AS (
    SELECT
        a.nev AS AlkalmazottNeve,
        CONCAT(YEAR(i.datum_ido), '-W', FORMAT(DATEPART(iso_week, i.datum_ido), '00')) AS EvHet,
        f.osszeg
    FROM
        Idopont i
    JOIN
        Fizetes f ON i.fizetes_id = f.id
    JOIN
        Alkalmazottak a ON i.alkalmazott_id = a.id)
SELECT
    CASE
        WHEN GROUPING(hb.AlkalmazottNeve) = 1 THEN 'Minden alkalmazott (összesen)'
        ELSE hb.AlkalmazottNeve
    END AS Alkalmazott,
 
    CASE
        WHEN GROUPING(hb.EvHet) = 1 THEN 'Összes hét (összesen)'
        ELSE hb.EvHet
    END AS Het,
    SUM(hb.osszeg) AS Heti_Össz_Bevétel
FROM
    HetiBevetelek hb
GROUP BY
    ROLLUP (hb.AlkalmazottNeve, hb.EvHet)
ORDER BY
    GROUPING(hb.AlkalmazottNeve), 
    hb.AlkalmazottNeve,
    GROUPING(hb.EvHet),
    hb.EvHet;

/*Ügyfelenként kumulatív költést időrendben és az előző vásárlás összegét mutatja*/
SELECT
    u.id,
    u.név,
    i.datum_ido,
    f.osszeg AS jelenlegi_fiz,
    SUM(f.osszeg) OVER (PARTITION BY u.id ORDER BY i.datum_ido ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS kumulativ_osszeg,
    LAG(f.osszeg, 1, 0) OVER (PARTITION BY u.id ORDER BY i.datum_ido) AS elozo_osszeg
FROM Idopont i
JOIN Ugyfel u ON u.id = i.ugyfel_id
JOIN Fizetes f ON f.id = i.fizetes_id
ORDER BY u.id, i.datum_ido;

/*Napi bevétel nézet */

CREATE View napi_bevetel
AS
SELECT CONVERT(date, i.datum_ido) AS nap,
       SUM(f.osszeg) AS bevetel
FROM Idopont i
JOIN Fizetes f ON f.id = i.fizetes_id
GROUP BY CONVERT(date, i.datum_ido);

/*Melyik alkalmazott mennyi bevételt hozott és besorolva jeleníti meg?*/

SELECT 
  a.nev,
  SUM(f.osszeg) AS bevetel,
  IIF(SUM(f.osszeg) >= 30000, N'Sok', N'Kevés') AS minosites
FROM Idopont i
JOIN Alkalmazottak a ON a.id = i.alkalmazott_id
JOIN Fizetes f ON f.id = i.fizetes_id
GROUP BY a.nev;

/*Heti összehasonlítás, listázza azokat akiknek kevesebb bevételük volt, mint az előző héten*/
WITH HetiBevetel AS (
    SELECT
        i.alkalmazott_id,
        CONCAT(YEAR(i.datum_ido), '-W', FORMAT(DATEPART(iso_week, i.datum_ido), '00')) AS EvHet,
        SUM(f.osszeg) AS HetiOsszeg
    FROM
        Idopont i
    JOIN
        Fizetes f ON i.fizetes_id = f.id
    WHERE
        CONCAT(YEAR(i.datum_ido), '-W', FORMAT(DATEPART(iso_week, i.datum_ido), '00')) IN ('2025-W19', '2025-W20')
    GROUP BY
        i.alkalmazott_id,
        CONCAT(YEAR(i.datum_ido), '-W', FORMAT(DATEPART(iso_week, i.datum_ido), '00'))
)
SELECT
    alk.nev AS "Alkalmazott Neve",
    H_aktualis.alkalmazott_id,
    H_aktualis.HetiOsszeg AS "Mostani hét bevétele",
    (
        SELECT
            H_elozo_display.HetiOsszeg
        FROM
            HetiBevetel H_elozo_display
        WHERE
            H_elozo_display.alkalmazott_id = H_aktualis.alkalmazott_id
            AND H_elozo_display.EvHet = '2025-W19'
    ) AS "Előző hét bevétele"
FROM
    HetiBevetel AS H_aktualis
JOIN
    Alkalmazottak alk ON H_aktualis.alkalmazott_id = alk.id
WHERE
    H_aktualis.EvHet = '2025-W20'
    AND EXISTS (
        SELECT 1
        FROM HetiBevetel H_elozo_ell
        WHERE H_elozo_ell.alkalmazott_id = H_aktualis.alkalmazott_id
          AND H_elozo_ell.EvHet = '2025-W19'
    )
GROUP BY
    alk.nev,
    H_aktualis.alkalmazott_id,
    H_aktualis.HetiOsszeg
HAVING
    H_aktualis.HetiOsszeg < (
        SELECT
            H_elozo.HetiOsszeg
        FROM
            HetiBevetel H_elozo
        WHERE
            H_elozo.alkalmazott_id = H_aktualis.alkalmazott_id
            AND H_elozo.EvHet = '2025-W19'
    );