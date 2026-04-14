## ============================================================
## Libraries
## ============================================================
library(haven)
library(dplyr)
library(tidyr)
library(forcats)
library(MASS)      # polr()
library(broom)
library(tibble)
library(tidyselect)

## ============================================================
## Helper: keep only covariates with >= 2 levels
## ============================================================
varying_covariates <- function(dat, vars) {
  vars[vapply(dat[vars], function(x) dplyr::n_distinct(x) > 1L, logical(1))]
}

## ============================================================
## Load + prepare data
## ============================================================
survey_data <- read_sav(
  "WHERE-THE-DATA-LIVES.sav"
)

survey_data <- survey_data %>%
  mutate(across(where(is.labelled), ~ as_factor(.x, levels = "default")))

nssec_target <- "L4: Lower professional and higher technical occupations"
nurse_label  <- "223 Nursing and Midwifery Professionals"

data_employed <- survey_data %>%
  filter(
    ns_sec == nssec_target,
    transport_to_workplace_12a != "Not in employment or aged 15 years and under",
    workplace_travel != "Does not apply"
  ) %>%
  mutate(
    occupation_group = if_else(
      occupation_105a == nurse_label, "Nurse & Midwife", "Everyone Else"
    ),
    commute_distance = factor(
      case_when(
        workplace_travel == "Less than 2km" ~ "<2km",
        workplace_travel == "2km to less than 5km" ~ "2–5km",
        workplace_travel == "5km to less than 10km" ~ "5–10km",
        workplace_travel == "10km to less than 20km" ~ "10–20km",
        workplace_travel == "20km to less than 30km" ~ "20–30km",
        workplace_travel == "30km to less than 40km" ~ "30–40km",
        workplace_travel == "40km to less than 60km" ~ "40–60km",
        workplace_travel == "60km and over" ~ "60km+",
        workplace_travel == "Works mainly at an offshore installation, in no fixed place, or outside the UK"
        ~ "Offshore/Abroad",
        TRUE ~ NA_character_
      ),
      ordered = TRUE,
      levels = c(
        "<2km","2–5km","5–10km","10–20km",
        "20–30km","30–40km","40–60km","60km+","Offshore/Abroad"
      )
    ),
    sex = factor(sex),
    age_group = case_when(
      as.numeric(resident_age_74m) < 25 ~ "<25",
      as.numeric(resident_age_74m) < 35 ~ "25–34",
      as.numeric(resident_age_74m) < 45 ~ "35–44",
      as.numeric(resident_age_74m) < 55 ~ "45–54",
      as.numeric(resident_age_74m) < 65 ~ "55–64",
      as.numeric(resident_age_74m) >= 65 ~ "65+",
      TRUE ~ NA_character_
    ),
    age_group = factor(
      age_group,
      levels = c("<25","25–34","35–44","45–54","55–64","65+")
    ),
    hours_category = case_when(
      hours_per_week_worked == "Part-time: 15 hours or less worked" ~ "<15 hrs",
      hours_per_week_worked == "Part-time: 16 to 30 hours worked"   ~ "16–30 hrs",
      hours_per_week_worked == "Full-time: 31 to 48 hours worked"   ~ "31–48 hrs",
      hours_per_week_worked == "Full-time: 49 or more hours worked" ~ "49+ hrs",
      TRUE ~ NA_character_
    ),
    tenure_simple = case_when(
      hh_tenure %in% c("Owned: Owns outright","Owned: Owns with a mortgage or loan")
      ~ "Own",
      hh_tenure %in% c("Private rented: Private landlord or letting agency",
                       "Private rented: Employer of a household member",
                       "Private rented: Relative or friend of household member",
                       "Private rented: Other")
      ~ "Private Rent",
      hh_tenure %in% c("Social rented: Rents from council or Local Authority",
                       "Social rented: Other social rented")
      ~ "Social Rent",
      hh_tenure %in% c("Shared ownership: Shared ownership","Lives rent free")
      ~ "Other",
      TRUE ~ NA_character_
    ),
    transport_mode = case_when(
      transport_to_workplace_12a %in% c("Underground, metro, light rail, tram", "Train") ~ "Rail",
      transport_to_workplace_12a %in% c("Driving a car or van", "Passenger in a car or van") ~ "Car",
      transport_to_workplace_12a == "Bus, minibus or coach" ~ "Bus",
      transport_to_workplace_12a == "Bicycle" ~ "Bicycle",
      transport_to_workplace_12a == "On foot" ~ "On Foot",
      transport_to_workplace_12a %in% c("Taxi", "Motorcycle, scooter or moped", "Other method of travel to work") ~ "Other",
      transport_to_workplace_12a %in% c("Work mainly at or from home", "Not in employment or aged 15 years and under") ~ "Not Employed or Works from Home",
      transport_to_workplace_12a == "Code not required" ~ NA_character_,
      TRUE ~ NA_character_
    ),
    legal_partnership_status = fct_collapse(
      legal_partnership_status_7a,
      "Never married"     = "Never married and never registered a civil partnership",
      "Married"           = "Married",
      "Civil Partnership" = "In a registered civil partnership",
      "Separated"         = "Separated, but still legally married or still legally in a civil partnership",
      "Divorced"          = "Divorced or formerly in a civil partnership which is now legally dissolved",
      "Widowed"           = "Widowed or surviving partner from a civil partnership"
    )
  ) %>%
  drop_na(
    commute_distance, transport_mode, sex, age_group, occupation_group, hours_category,
    tenure_simple, legal_partnership_status
  ) %>%
  mutate(across(where(is.character), as.factor)) %>%
  droplevels()

#
library(gtsummary)
library(dplyr)

# Reorder occupation_group so columns appear in desired order
data_employed <- data_employed %>%
  mutate(
    occupation_group = factor(
      occupation_group,
      levels = c("Nurse & Midwife", "Everyone Else")
    )
  )

# Variables in desired display order
vars_to_describe <- c(
  "sex",
  "age_group",
  "hours_category",
  "legal_partnership_status",
  "tenure_simple"
)

tbl_occ_descriptives <- data_employed %>%
  select(all_of(vars_to_describe), occupation_group) %>%
  tbl_summary(
    by = occupation_group,
    statistic = everything() ~ "{n} ({p}%)",
    missing = "no",
    label = list(
      sex                      = "Sex",
      age_group                = "Age group",
      hours_category           = "Hours",
      legal_partnership_status = "Legal partnership status",
      tenure_simple            = "Housing tenure"
    )
  ) %>%
  add_overall(last = FALSE) %>%   # place overall FIRST
  add_p() %>%
  bold_labels()

tbl_occ_descriptives

library(gtsummary)
library(dplyr)

# Ensure occupation_group is in the right order
data_employed <- data_employed %>%
  mutate(
    occupation_group = factor(
      occupation_group,
      levels = c("Nurse & Midwife", "Everyone Else")
    )
  )

# Variables for this table
vars_commute <- c("commute_distance", "transport_mode")

tbl_commute_transport <- data_employed %>%
  select(all_of(vars_commute), occupation_group) %>%
  tbl_summary(
    by = occupation_group,
    statistic = everything() ~ "{n} ({p}%)",
    missing = "no",
    label = list(
      commute_distance = "Commute distance",
      transport_mode   = "Transport mode"
    )
  ) %>%
  add_overall(last = FALSE) %>%  # Overall column first
  add_p() %>%
  bold_labels()

tbl_commute_transport



## ============================================================
## Predictor set (after dropping children_in_house + unpaid_carer)
## ============================================================
preds_core <- c(
  "occupation_group",
  "sex", "age_group", "hours_category",
  "tenure_simple", "legal_partnership_status"
)

## ============================================================
## Main modelling function
## ============================================================
run_commute_models <- function(dat, preds_core) {
  
  d <- dat %>%
    filter(commute_distance != "Offshore/Abroad") %>%
    droplevels()
  
  d$commute_distance <- factor(
    d$commute_distance,
    levels = c("<2km","2–5km","5–10km","10–20km",
               "20–30km","30–40km","40–60km","60km+"),
    ordered = TRUE
  )
  
  # Make sure key vars have >= 2 levels
  stopifnot(dplyr::n_distinct(d$occupation_group) >= 2L)
  stopifnot(dplyr::n_distinct(d$commute_distance) >= 2L)
  
  # Remove any existing threshold dummies if present
  d <- d %>%
    dplyr::select(-tidyselect::matches("^ge_\\d+km$"), dplyr::everything())
  
  # Build threshold dummies
  lvl <- levels(d$commute_distance)
  K   <- length(lvl)
  cut_ids <- 2:K
  thr_km  <- as.integer(gsub("\\D.*", "", lvl[cut_ids]))
  thr_vars <- paste0("ge_", thr_km, "km")
  
  make_thr <- function(x, k) as.integer(as.integer(x) >= k)
  th_mat   <- sapply(cut_ids, function(k) make_thr(d$commute_distance, k))
  colnames(th_mat) <- thr_vars
  d <- bind_cols(d, as_tibble(th_mat))
  
  # Figure out which predictors actually vary
  preds_no_occ <- setdiff(preds_core, "occupation_group")
  preds_vary   <- varying_covariates(d, preds_no_occ)
  
  # CLMM formula (polr)
  if (length(preds_vary) == 0L) {
    form_clmm <- commute_distance ~ occupation_group
  } else {
    form_clmm <- as.formula(
      paste("commute_distance ~ occupation_group +",
            paste(preds_vary, collapse = " + "))
    )
  }
  
  clmm_fit <- MASS::polr(
    formula = form_clmm,
    data    = d,
    Hess    = TRUE,
    method  = "logistic"
  )
  
  # Threshold-specific GLMs using the same predictors
  thr_fits <- lapply(thr_vars, function(v) {
    if (length(preds_vary) == 0L) {
      f <- as.formula(paste0(v, " ~ occupation_group"))
    } else {
      f <- as.formula(
        paste0(v, " ~ occupation_group + ", paste(preds_vary, collapse = " + "))
      )
    }
    glm(f, data = d, family = binomial())
  })
  names(thr_fits) <- thr_vars
  
  list(
    data       = d,
    preds_used = c("occupation_group", preds_vary),
    clmm       = clmm_fit,
    thresholds = thr_fits
  )
}

## ============================================================
## Run models: ALL + WOMEN ONLY
## ============================================================
models_all <- run_commute_models(data_employed, preds_core)

data_women  <- data_employed %>%
  filter(sex == "Female") %>%
  droplevels()

models_women <- run_commute_models(data_women, preds_core)

## Quick summary of predictors used
cat("\nPredictors (ALL):\n")
print(models_all$preds_used)

cat("\nPredictors (WOMEN ONLY):\n")
print(models_women$preds_used)

cat("\nFinished running commute models for ALL + WOMEN ONLY.\n")


# cumulative OR for occupation (ALL)
clmm_all_or <- broom::tidy(models_all$clmm, conf.int = TRUE, exponentiate = TRUE) %>%
  filter(grepl("^occupation_group", term))

clmm_all_or

# cumulative OR for occupation (WOMEN ONLY)
clmm_women_or <- broom::tidy(models_women$clmm, conf.int = TRUE, exponentiate = TRUE) %>%
  filter(grepl("^occupation_group", term))

clmm_women_or

extract_threshold_ORs <- function(thr_list) {
  purrr::map_dfr(names(thr_list), function(v){
    broom::tidy(thr_list[[v]], conf.int = TRUE, exponentiate = TRUE) %>%
      filter(grepl("^occupation_group", term)) %>%
      mutate(threshold = v)
  })
}

thr_all_or   <- extract_threshold_ORs(models_all$thresholds)
thr_women_or <- extract_threshold_ORs(models_women$thresholds)

thr_all_or
thr_women_or

library(marginaleffects)

pp_all <- lapply(models_all$thresholds, function(m){
  avg_predictions(m, variables = "occupation_group", type = "response")
})

pp_women <- lapply(models_women$thresholds, function(m){
  avg_predictions(m, variables = "occupation_group", type = "response")
})

pp_all
pp_women

library(glmnet)
library(pROC)

run_ml_thresholds <- function(dat, preds_used, thr_vars,
                              alpha = 0.5, nfolds = 5) {
  
  # Design matrix for covariates (no intercept)
  X <- model.matrix(
    as.formula(paste("~", paste(preds_used, collapse = " + "))),
    data = dat
  )[ , -1, drop = FALSE]
  
  results <- lapply(thr_vars, function(yvar) {
    
    y <- as.numeric(dat[[yvar]])  # 0/1 outcome
    
    # Elastic-net logistic with CV
    cvfit <- cv.glmnet(
      x       = X,
      y       = y,
      family  = "binomial",
      alpha   = alpha,
      nfolds  = nfolds
    )
    
    # Predicted probabilities in the observed data
    p_hat <- as.numeric(
      predict(cvfit, newx = X, s = "lambda.min", type = "response")
    )
    
    # AUC
    roc_obj <- pROC::roc(y, p_hat, quiet = TRUE)
    auc_val <- as.numeric(pROC::auc(roc_obj))
    
    # Brier score
    brier <- mean((y - p_hat)^2)
    
    # ----- Marginal RD by toggling occupation_group -----
    
    base_dat <- dat
    
    # Scenario 1: everyone set to Nurse & Midwife
    dat_nurse <- base_dat
    dat_nurse$occupation_group <- factor(
      "Nurse & Midwife",
      levels = levels(base_dat$occupation_group)
    )
    X_nurse <- model.matrix(
      as.formula(paste("~", paste(preds_used, collapse = " + "))),
      data = dat_nurse
    )[ , -1, drop = FALSE]
    
    p_nurse <- as.numeric(
      predict(cvfit, newx = X_nurse, s = "lambda.min", type = "response")
    )
    
    # Scenario 2: everyone set to Everyone Else
    dat_other <- base_dat
    dat_other$occupation_group <- factor(
      "Everyone Else",
      levels = levels(base_dat$occupation_group)
    )
    X_other <- model.matrix(
      as.formula(paste("~", paste(preds_used, collapse = " + "))),
      data = dat_other
    )[ , -1, drop = FALSE]
    
    p_other <- as.numeric(
      predict(cvfit, newx = X_other, s = "lambda.min", type = "response")
    )
    
    # Population-standardised RD (Nurse – Everyone Else)
    rd_ml <- mean(p_nurse - p_other)
    
    tibble::tibble(
      threshold = yvar,
      auc       = auc_val,
      brier     = brier,
      rd_ml     = rd_ml
    )
  })
  
  dplyr::bind_rows(results)
}

# Threshold variable names come from your fitted threshold GLMs
thr_vars_all   <- names(models_all$thresholds)
thr_vars_women <- names(models_women$thresholds)

# ML benchmark for the full NS-SEC 4 sample
ml_all <- run_ml_thresholds(
  dat       = models_all$data,
  preds_used = models_all$preds_used,
  thr_vars  = thr_vars_all
)

# ML benchmark for women only
ml_women <- run_ml_thresholds(
  dat       = models_women$data,
  preds_used = models_women$preds_used,
  thr_vars  = thr_vars_women
)

ml_all
ml_women


#

