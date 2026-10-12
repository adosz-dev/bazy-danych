-- Schemat bazy: Firma, Pracownicy, Obroty, Zatrudnienie
-- Uruchomienie: mysql -u root -p < schemat.sql

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS firmy;
CREATE DATABASE firmy CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci;
USE firmy;

-- Klucz główny: Nazwa. Klucz kandydujący: Pesel_prezesa
-- (zakładamy, że jedna osoba jest prezesem co najwyżej jednej firmy).
CREATE TABLE Firma (
    Nazwa              VARCHAR(30) NOT NULL,
    Adres              VARCHAR(80),
    `Data_założenia`   DATE,
    `Imię_prezesa`     VARCHAR(30),
    Nazwisko_prezesa   VARCHAR(30),
    Pesel_prezesa      CHAR(11),
    PRIMARY KEY (Nazwa),
    UNIQUE KEY uq_firma_pesel_prezesa (Pesel_prezesa)
);

-- Klucz główny: Id. Klucz kandydujący: Pesel.
CREATE TABLE Pracownicy (
    Id        INT NOT NULL,
    `Imię`    VARCHAR(20) NOT NULL,
    Nazwisko  VARCHAR(30) NOT NULL,
    Pesel     CHAR(11),
    PRIMARY KEY (Id),
    UNIQUE KEY uq_pracownicy_pesel (Pesel)
);

-- Klucz główny: (Nazwa_firmy, Rok, Miesiąc) - jeden wpis na firmę w danym miesiącu.
CREATE TABLE Obroty (
    Nazwa_firmy  VARCHAR(30) NOT NULL,
    Rok          INT NOT NULL,
    `Miesiąc`    INT NOT NULL,
    `Przychód`   INT,
    Wydatki      INT,
    PRIMARY KEY (Nazwa_firmy, Rok, `Miesiąc`),
    FOREIGN KEY (Nazwa_firmy) REFERENCES Firma (Nazwa)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (`Miesiąc` BETWEEN 1 AND 12)
);

-- Klucz główny: (Id_pracownika, Nazwa_firmy, Data_zatrudnienia) - pracownik może
-- pracować w kilku firmach, a także wielokrotnie w tej samej (w różnych okresach).
-- Data_zwolnienia = NULL oznacza, że pracownik nadal jest zatrudniony.
CREATE TABLE Zatrudnienie (
    Id_pracownika         INT NOT NULL,
    Nazwa_firmy           VARCHAR(30) NOT NULL,
    Data_zatrudnienia     DATE NOT NULL,
    Data_zwolnienia       DATE,
    Wynagrodzenie_brutto  INT,
    PRIMARY KEY (Id_pracownika, Nazwa_firmy, Data_zatrudnienia),
    FOREIGN KEY (Id_pracownika) REFERENCES Pracownicy (Id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Nazwa_firmy) REFERENCES Firma (Nazwa)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (Data_zwolnienia IS NULL OR Data_zwolnienia >= Data_zatrudnienia)
);

-- ---------------------------------------------------------------------------
-- Przykładowe dane
-- ---------------------------------------------------------------------------

INSERT INTO Firma (Nazwa, Adres, `Data_założenia`, `Imię_prezesa`, Nazwisko_prezesa, Pesel_prezesa) VALUES
('Kowalski i Syn',  'ul. Długa 12, 00-238 Warszawa',        '1995-04-11', 'Jan',       'Kowalski',  '65031204512'),
('TechSoft',        'ul. Piotrkowska 101, 90-425 Łódź',     '2008-09-01', 'Anna',      'Nowak',     '78110509827'),
('Budimex-Pol',     'al. Grunwaldzka 45, 80-241 Gdańsk',    '2001-02-20', 'Piotr',     'Wiśniewski','70072203115'),
('Zielony Ogród',   'ul. Kwiatowa 3, 31-052 Kraków',        '2015-06-15', 'Katarzyna', 'Wójcik',    '85040411246'),
('Transbud',        'ul. Portowa 8, 70-602 Szczecin',       '2019-11-30', 'Marek',     'Kamiński',  '80121707339');

INSERT INTO Pracownicy (Id, `Imię`, Nazwisko, Pesel) VALUES
( 1, 'Adam',      'Lewandowski', '90010112345'),
( 2, 'Ewa',       'Zielińska',   '92050523456'),
( 3, 'Tomasz',    'Szymański',   '88071034567'),
( 4, 'Magdalena', 'Woźniak',     '95121245678'),
( 5, 'Krzysztof', 'Dąbrowski',   '83030356789'),
( 6, 'Agnieszka', 'Kozłowska',   '91081567890'),
( 7, 'Paweł',     'Jankowski',   '87112078901'),
( 8, 'Monika',    'Mazur',       '94022889012'),
( 9, 'Michał',    'Kwiatkowski', '99060690123'),
(10, 'Joanna',    'Krawczyk',    '86090901234'),
(11, 'Łukasz',    'Piotrowski',  '93041412340'),
(12, 'Karolina',  'Grabowska',   '97101723451'),
(13, 'Jan',       'Kowalski',    '65031204512'),  -- prezes firmy Kowalski i Syn
(14, 'Anna',      'Nowak',       '78110509827'),  -- prezes firmy TechSoft
(15, 'Adam',      'Nowak',       '01231534562');

INSERT INTO Zatrudnienie (Id_pracownika, Nazwa_firmy, Data_zatrudnienia, Data_zwolnienia, Wynagrodzenie_brutto) VALUES
( 1, 'TechSoft',       '2015-03-01', '2019-08-31',  6500),
( 1, 'Kowalski i Syn', '2019-09-01', NULL,          9200),
( 2, 'TechSoft',       '2017-01-15', NULL,         11500),
( 3, 'Budimex-Pol',    '2010-05-10', '2014-12-31',  4200),
( 3, 'Budimex-Pol',    '2016-02-01', NULL,          7800),
( 4, 'Zielony Ogród',  '2018-04-01', NULL,          5100),
( 5, 'Budimex-Pol',    '2005-07-01', '2020-06-30',  8900),
( 5, 'Transbud',       '2020-07-01', NULL,         10200),
( 6, 'Kowalski i Syn', '2012-10-01', '2016-03-31',  4800),
( 6, 'TechSoft',       '2016-04-01', NULL,         13400),
( 7, 'Transbud',       '2020-01-02', '2023-01-31',  6100),
( 8, 'Zielony Ogród',  '2016-09-01', '2017-08-31',  3200),
( 8, 'Zielony Ogród',  '2021-03-01', NULL,          5600),
( 9, 'TechSoft',       '2022-07-01', NULL,          7400),
(10, 'Kowalski i Syn', '2008-02-01', NULL,          8300),
(11, 'Transbud',       '2021-05-17', NULL,          6900),
(11, 'Budimex-Pol',    '2023-02-01', NULL,          3500),  -- drugi etat
(12, 'TechSoft',       '2023-10-01', '2024-03-31',  6000),
(13, 'Kowalski i Syn', '1995-04-11', NULL,         15000),
(14, 'TechSoft',       '2008-09-01', NULL,         18000);
-- pracownik 15 (Adam Nowak) nie był nigdzie zatrudniony

INSERT INTO Obroty (Nazwa_firmy, Rok, `Miesiąc`, `Przychód`, Wydatki) VALUES
('Kowalski i Syn', 2024,  1, 120000,  98000),
('Kowalski i Syn', 2024,  2, 115000, 101000),
('Kowalski i Syn', 2024,  3, 134000, 102500),
('Kowalski i Syn', 2024,  4, 128000, 131000),
('Kowalski i Syn', 2024,  5, 141000, 104000),
('Kowalski i Syn', 2024,  6, 150000, 110000),
('Kowalski i Syn', 2025,  1, 125000, 100000),
('Kowalski i Syn', 2025,  2, 119000, 121000),
('Kowalski i Syn', 2025,  3, 138000, 103000),
('TechSoft',       2024,  1, 310000, 240000),
('TechSoft',       2024,  2, 295000, 238000),
('TechSoft',       2024,  3, 330000, 251000),
('TechSoft',       2024,  4, 345000, 260000),
('TechSoft',       2024,  5, 280000, 299000),
('TechSoft',       2024,  6, 360000, 262000),
('TechSoft',       2025,  1, 375000, 270000),
('TechSoft',       2025,  2, 390000, 281000),
('TechSoft',       2025,  3, 402000, 285000),
('Budimex-Pol',    2024,  1, 520000, 480000),
('Budimex-Pol',    2024,  2, 410000, 455000),
('Budimex-Pol',    2024,  3, 610000, 500000),
('Budimex-Pol',    2024,  4, 700000, 540000),
('Budimex-Pol',    2024,  5, 720000, 560000),
('Budimex-Pol',    2024,  6, 690000, 575000),
('Budimex-Pol',    2025,  1, 480000, 470000),
('Budimex-Pol',    2025,  2, 450000, 490000),
('Zielony Ogród',  2024,  3,  42000,  38000),
('Zielony Ogród',  2024,  4,  65000,  41000),
('Zielony Ogród',  2024,  5,  78000,  45000),
('Zielony Ogród',  2024,  6,  81000,  47000),
('Zielony Ogród',  2025,  3,  45000,  40000),
('Transbud',       2024,  1,  90000,  85000),
('Transbud',       2024,  2,  87000,  92000),
('Transbud',       2024,  3,  95000,  88000),
('Transbud',       2025,  1,  99000,  91000);
