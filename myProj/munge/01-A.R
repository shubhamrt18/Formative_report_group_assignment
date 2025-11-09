# Example preprocessing script.


library(dplyr)
library(ggplot2)
library(readxl)
library(knitr)
library(scales)

# --- Data Loading ---
Adult <- read_excel(
  "data/NCD_RisC_Lancet_2024_BMI_age_standardised_country.xlsx",
  na = "NA",
  col_names = TRUE,
  .name_repair = "minimal"
)

Child <- read_excel(
  "data/NCD_RisC_Lancet_2024_BMI_child_adolescent_country_ageStd.xlsx",
  na = "NA",
  col_names = TRUE,
  .name_repair = "minimal"
)

# ADULT OBESITY Data
adult_obesity <- Adult %>%
  select(
    Year,
    Country = `Country/Region/World`,
    Sex,
    Prevalence = `Prevalence of BMI>=30 kg/m² (obesity)`,
    UI_Lower = `Prevalence of BMI>=30 kg/m² (obesity) lower 95% uncertainty interval`,
    UI_Upper = `Prevalence of BMI>=30 kg/m² (obesity) upper 95% uncertainty interval`
  ) %>%
  filter(
    Country == "China",
    Year >= 2012,
    Year <= 2022
  ) %>%
  mutate(
    Age_Group = "Adult",
    Metric = "Obesity",
    Metric_Category = "Obesity"
  )

#UNDERWEIGHT Data
adult_underweight <- Adult %>%
  select(
    Year,
    Country = `Country/Region/World`,
    Sex,
    Prevalence = `Prevalence of BMI<18.5 kg/m² (underweight)`,
    UI_Lower = `Prevalence of BMI<18.5 kg/m² (underweight) lower 95% uncertainty interval`,
    UI_Upper = `Prevalence of BMI<18.5 kg/m² (underweight) upper 95% uncertainty interval`
  ) %>%
  filter(
    Country == "China",
    Year >= 2012,
    Year <= 2022
  ) %>%
  mutate(
    Age_Group = "Adult",
    Metric = "Underweight",
    Metric_Category = "Underweight/Thinness"
  )

# CHILD OBESITY Data
child_obesity <- Child %>%
  select(
    Year,
    Country = `Country/Region/World`,
    Sex,
    Prevalence = `Prevalence of BMI > 2SD (obesity)`,
    UI_Lower = `Prevalence of BMI > 2SD (obesity) lower 95% uncertainty interval`,
    UI_Upper = `Prevalence of BMI > 2SD (obesity) upper 95% uncertainty interval`
  ) %>%
  filter(
    Country == "China",
    Year >= 2012,
    Year <= 2022
  ) %>%
  mutate(
    Age_Group = "Child",
    Metric = "Obesity",
    Metric_Category = "Obesity"
  )

# CHILD THINNESS Data
child_thinness <- Child %>%
  select(
    Year,
    Country = `Country/Region/World`,
    Sex,
    Prevalence = `Prevalence of BMI < -2SD (thinness)`,
    UI_Lower = `Prevalence of BMI < -2SD (thinness) lower 95% uncertainty interval`,
    UI_Upper = `Prevalence of BMI < -2SD (thinness) upper 95% uncertainty interval`
  ) %>%
  filter(
    Country == "China",
    Year >= 2012,
    Year <= 2022
  ) %>%
  mutate(
    Age_Group = "Child",
    Metric = "Underweight",
    Metric_Category = "Underweight/Thinness"
  )

#Merge all four datasets vertically
merged_bmi_data <- bind_rows(
  adult_obesity,
  adult_underweight,
  child_obesity,
  child_thinness
)

# 4. Cache the resulting data object
cache("merged_bmi_data")