options(repos = c(CRAN = "https://cloud.r-project.org"))

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

install_if_missing("dotenv")
install_if_missing("readr")
install_if_missing("httr")
install_if_missing("jsonlite")
install_if_missing("dplyr")

#Rscript analysis.R


#file.exists("../.env")        # should be TRUE
#dotenv::load_dot_env("../.env")
install.packages("dotenv")   # only once
library(dotenv)
install.packages("plumber")


# Check the key
print(Sys.getenv("GEMINI_API_KEY"))

install.packages("readr")   # run once if not installed
library(readr)

install.packages(c("httr", "jsonlite"))



library(httr)
library(jsonlite)

install.packages("dplyr")  # run once
library(dplyr)

library(jsonlite)


# Load .env file automatically after you install packages and libraries
load_dot_env("../.env")

call_gemini <- function(summary_text) {
  api_key <- Sys.getenv("GEMINI_API_KEY")

  url <- paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/",
    "gemini-1.5-flash:generateContent?key=", api_key
  )

  body <- list(
    contents = list(
      list(
        parts = list(
          list(text = summary_text)
        )
      )
    )
  )

  response <- POST(
    url,
    body = toJSON(body, auto_unbox = TRUE),
    encode = "json",
    content_type_json()
  )

  result <- content(response, as = "parsed")

  # Extract Gemini text safely
  result$candidates[[1]]$content$parts[[1]]$text
}





# Load expression matrix
expr <- read_tsv("../data/SCP31/expression/k562_both_filt.txt")
expr_small <- expr[1:100, 1:100]
# Load metadata
meta <- read_tsv("../data/SCP31/metadata/k562_metadata.txt")

# Inspect
#glimpse(expr)
#glimpse(meta)
head(expr_small[, 1:10])
summary(expr_small[, 1:10])


num_cells <- nrow(expr_small)
num_genes <- ncol(expr_small)

cat("Number of cells:", num_cells, "\n")
cat("Number of genes:", num_genes, "\n")

missing_per_gene <- colSums(is.na(expr_small))

head(sort(missing_per_gene, decreasing = TRUE))

missing_per_cell <- rowSums(is.na(expr_small))

summary(missing_per_cell)

expr_stats <- expr_small %>%
  summarise(across(where(is.numeric), list(
    mean = ~mean(.x, na.rm = TRUE),
    sd   = ~sd(.x, na.rm = TRUE),
    min  = ~min(.x, na.rm = TRUE),
    max  = ~max(.x, na.rm = TRUE)
  )))

  rm(expr)

# Look at first few genes only
head(expr_stats[, 1:8])

# Look for cluster-like column
colnames(meta)

cluster_summary <- meta %>%
  group_by(perturbation) %>%
  summarise(cells = n())

print(cluster_summary)

threshold <- 50  # max missing genes per cell

filtered_expr <- expr_small[missing_per_cell < threshold, ]

cat("Cells before:", nrow(expr), "\n")
cat("Cells after QC:", nrow(filtered_expr), "\n")

summary_for_gemini <- list(
  dataset_overview = list(
    num_cells = num_cells,
    num_genes = num_genes
  ),
  missing_data = list(
    top_missing_genes = head(sort(missing_per_gene, decreasing = TRUE), 5),
    missing_cells_summary = as.list(summary(missing_per_cell))
  ),
  cluster_summary = cluster_summary,
  qc = list(
    cells_after_filtering = nrow(filtered_expr)
  )
)


jsonlite::write_json(
  summary_for_gemini,
   "../frontend/results.json",
  pretty = TRUE
)
