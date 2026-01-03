# Pengujian Sistem

Folder ini berisi script pengujian sistem yang digunakan pada BAB IV skripsi.
Pengujian meliputi uji kapasitas, uji latensi, uji responsivitas, uji skalabilitas,
uji ketahanan sistem, serta pengujian mekanisme redirect.

### Berikut perintah menjalankan pengujiannya
#### 1. uji kapasitas 
- k6 run --vus 5 --duration 1m uji_kapasitas.js
- k6 run --vus 10 --duration 1m uji_kapasitas.js
- k6 run --vus 15 --duration 1m uji_kapasitas.js

#### 2. uji ketahanan sistem
- k6 run stress-test.js

#### 3. uji keamanan redirect
- k6 run redirect_test.js
- sudo hping3 -S --flood -p 80 192.168.1.10
- python3 slowloris.py 1922.168.1.10 -p 80 -s 200

#### 4. uji responsivitas sistem
- k6 run uji_responsivitas.js

#### 5. uji latensi
- k6 run latency_test.js

#### 6. uji skalabilitas
- k6 run skalabilitas.js
- MODE=normal k6 run skalabilitas.js
- MODE=redirect k6 run skalabilitas.js

