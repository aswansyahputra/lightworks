# Mengaktifkan paket dan data ---------------------------------------------

library(readxl)
library(dplyr)
library(janitor)

devtools::load_all()
data(teachers)

# Impor berkas XLSX -------------------------------------------------------

dirty_data <- read_excel("data-raw/dirty_data.xlsx")

# Inspeksi data -----------------------------------------------------------

glimpse(dirty_data)
glimpse(teachers)

# Membersihkan data -------------------------------------------------------

# 1. Hapus baris dan kolom yang kosong
# 2. Merapikan nama kolom (contoh: format penulisan snake case)
# 3. Merapikan penulisan tanggal
# 4. Menangani satu informasi yang tersebar di dua kolom berbeda
# 5. Menghapus kolom yang tidak diperlukan
# 6. Identifikasi observasi duplikat berdasarkan nama depan dan nama belakang
# 7. Menghapus observasi duplikat (opsional)