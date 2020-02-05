# Persiapan ---------------------------------------------------------------

library(tidyr)
devtools::load_all()

# Kendaraan di Jawa Barat -------------------------------------------------

kendaraan # tidy data

kendaraan1 # messy data

kendaraan_pivot1 = pivot_longer(
  kendaraan1,
  cols = tahun_2013:tahun_2018,
  names_to = "tahun",
  names_prefix = "tahun_",
  names_ptypes = list(tahun = integer()),
  values_to = "jumlah_kendaraan"
)

kendaraan_pivot1 # now it is tidy data

kendaraan2 # messy data

kendaraan_pivot2 = pivot_longer(
  kendaraan2,
  cols = PRIBADI_2013:UMUM_2018,
  names_to = c("fungsi", "tahun"),
  names_sep = "_",
  values_to = "jumlah_kendaraan"
)

kendaraan_pivot2 # now it is tidy data

# Kasus Stunting ----------------------------------------------------------

stunting # tidy data

stunting1 # messy data

stunting_pivot1 =
  pivot_wider(
    stunting1, 
    names_from = "tipe", 
    values_from = "nilai"
  )

stunting_pivot1 # now its is tidy data
