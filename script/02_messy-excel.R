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

clean_data <- 
  dirty_data %>% 
  remove_empty(c("rows", "cols")) %>% 
  clean_names(case = "snake") %>% 
  mutate(
    hire_date = excel_numeric_to_date(hire_date),
    cert = coalesce(certification_9, certification_10)
  ) %>% 
  select(-starts_with("certi"))

clean_data %>%   
  get_dupes(first_name, last_name)

clean_data %>%   
  distinct(first_name, last_name, .keep_all = TRUE)