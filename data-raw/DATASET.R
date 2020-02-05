## code to prepare `DATASET` dataset goes here

library(jabr)
library(readxl)
library(tidyverse)
library(janitor)

kendaraan <- 
  jabr_fetch_group("a7267b0f") %>% 
  unnest(dataset) %>% 
  transmute(
    tahun = str_extract(title, "\\d{4}"),
    kode_kota_kabupaten,
    kota_kabupaten,
    cabang_pelayanan,
    jenis = jenis_kendaraan,
    fungsi = fungsi_kendaraan,
    jumlah
  ) %>% 
  mutate_if(is.character, str_squish) %>% 
  mutate_if(is.character, str_to_upper)

usethis::use_data(kendaraan, overwrite = TRUE)

kendaraan1 <- 
  kendaraan %>% 
  pivot_wider(names_from = tahun, names_prefix = "tahun_", values_from = jumlah)

usethis::use_data(kendaraan1, overwrite = TRUE)

kendaraan2 <- 
  kendaraan %>% 
  pivot_wider(names_from = c(fungsi, tahun), values_from = jumlah) 

usethis::use_data(kendaraan2, overwrite = TRUE)

jumlah_penduduk <- 
  jabr_fetch_group("996b8a8b") %>% 
  filter(str_detect(title, "2015|2016|2017")) %>% 
  unnest(dataset) %>% 
  mutate(
    tahun = str_extract(title, "\\d{4}")
  ) %>% 
  group_by(tahun, kode_kota_kabupaten, kota_kabupaten = nama_kota_kabupaten) %>% 
  summarise(jumlah_penduduk = sum(proyeksi_jumlah_penduduk)) %>% 
  ungroup()

stunting <-
  read_excel("data-raw/stunting.xlsx", sheet = 2) %>%
  clean_names() %>%
  filter(kabupaten_kota != "JABAR") %>%
  pivot_longer(
    cols = starts_with("tahun"),
    names_to = "tahun",
    values_to = "prevalensi",
    names_prefix = "tahun_"
  ) %>%
  transmute(
    kode_kota_kabupaten = as.integer(kode_kab_kota),
    tahun = as.character(tahun),
    prevalensi
  ) %>%
  left_join(jumlah_penduduk) %>%
  select(tahun,
         kode_kota_kabupaten,
         kota_kabupaten,
         prevalensi,
         jumlah_penduduk)

usethis::use_data(stunting, overwrite = TRUE)

stunting1 <- 
  stunting %>%
  pivot_longer(
    cols = prevalensi:jumlah_penduduk,
    names_to = "tipe",
    values_to = "nilai"
  )

usethis::use_data(stunting1, overwrite = TRUE)

teachers <- 
  read_excel("data-raw/dirty_data.xlsx") %>%
  remove_empty() %>%
  clean_names() %>%
  mutate(
    hire_date = excel_numeric_to_date(hire_date),
    cert = coalesce(certification_9, certification_10)
  ) %>%
  select(-certification_9, -certification_10)

usethis::use_data(teachers, overwrite = TRUE)
