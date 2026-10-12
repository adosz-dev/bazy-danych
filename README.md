# bazy-danych
## Schemat `firmy`

Plik `schemat.sql` tworzy bazę `firmy` (MySQL / MariaDB) z tabelami
`Firma`, `Pracownicy`, `Obroty`, `Zatrudnienie` i wypełnia je przykładowymi danymi.

```bash
mysql -u root -p < schemat.sql
```

Klucze:
- `Firma`: PK `Nazwa`, klucz kandydujący `Pesel_prezesa`
- `Pracownicy`: PK `Id`, klucz kandydujący `Pesel`
- `Obroty`: PK `(Nazwa_firmy, Rok, Miesiąc)`, FK `Nazwa_firmy` → `Firma`
- `Zatrudnienie`: PK `(Id_pracownika, Nazwa_firmy, Data_zatrudnienia)`,
  FK `Id_pracownika` → `Pracownicy`, FK `Nazwa_firmy` → `Firma`
