### PRINCIPAL COMPONENT ANALYSIS (PCA) ###

# Load necessary libraries
library(readxl)
library(pastecs)
library(corrplot)
library(psych)
library(FactoMineR)
library(factoextra)
library(ggplot2)
library(ggrepel)
library(grid)
library(scales)
library(plyr)
library(ggbiplot)

# Set working directory and load data
getwd()
AHORA12 <- read_excel("/Users/florenciastrada/Desktop/MAESTRIA DE DATOS/4.MULTIVARIADOS/COMPONENTES PRINCIPALES/AHORA12v3.xlsx")

# Summary statistics
summary(AHORA12)
dim(AHORA12)

# Disable scientific notation
options(scipen = 999)

# Descriptive statistics
Descriptive_Stats <- stat.desc(AHORA12, basic = TRUE)

# CORRELATION MATRIX
cor_matrix <- cor(AHORA12[, 2:15], method = "pearson")
test_results <- cor.mtest(cor_matrix, conf.level = 0.95)

# Visualize correlation matrix
corrplot(cor_matrix, p.mat = test_results[[1]], sig.level = 0.05, type = "lower")

# BARTLETT'S TEST OF SPHERICITY
cortest.bartlett(cor_matrix, n = 32)

# NUMBER OF PRINCIPAL COMPONENTS TO EXTRACT
# Criterion: Eigenvalue > 1
fit <- PCA(AHORA12[, 2:31], scale.unit = TRUE, ncp = 10, graph = TRUE)
fit$eig

# Scree Plot with color gradient
fviz_pca_var(fit, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE)

# SCREE PLOT
fviz_eig(fit, addlabels = TRUE, ylim = c(0, 100)) +
  theme_grey()

# INTERPRETATION OF PRINCIPAL COMPONENTS

# PCA Variables Representation
pca_data <- data.frame(fit$var$coord[, 1:2])

ggplot(pca_data) +
  geom_point(aes(x = Dim.1, y = Dim.2, colour = "darkred")) +
  geom_text_repel(aes(x = Dim.1, y = Dim.2),
                  label = rownames(pca_data)) +
  geom_vline(xintercept = 0, colour = "darkgray") +
  geom_hline(yintercept = 0, colour = "darkgray") +
  labs(x = "Dimension 1 (78%)", y = "Dimension 2 (12.1%)") +
  theme(legend.position = "none")

# Set province names for PCA individuals representation
rownames(fit[1, ]) <- AHORA12$Provincia

# Visualize PCA individuals (Provinces)
fviz_pca_ind(fit, pointsize = "cos2",
             pointshape = 21, fill = "#E7B800",
             repel = TRUE)

# Calculate Eigenvalues and Eigenvectors
correlation_matrix <- cor(AHORA12[, -1])
eigen_values_vectors <- eigen(correlation_matrix)

# Assign row names (categories) to Eigenvectors
rownames(eigen_values_vectors$vectors) <- c(
  "Food", "Glasses", "Lighting Appliances", "Stationery", "Spas",
  "Bicycles", "Footwear and Leather Goods", "Mattresses", "Computers",
  "Home Appliances", "Medical Equipment", "Clothing", "Musical Instruments",
  "Toys", "Books", "Machinery and Tools", "Construction Materials",
  "Medications", "Motorcycles", "Furniture", "Tires", "Perfumes",
  "Personal Care Services", "Alarm Installation Services",
  "Event Organization Services", "Sports Services", "Educational Services",
  "Technical Services", "Repair Workshops", "Tourism"
)

# Assign column names (Principal Components)
colnames(eigen_values_vectors$vectors) <- paste0("PC", 1:30)

# Display Eigenvalues and Eigenvectors
eigen_values_vectors

# Compute Principal Components
AHORA12_pc <- princomp(correlation_matrix, cor = TRUE)
AHORA12_pc

# REPRESENTATION OF PROVINCES IN PCA
# Check dimensions before merging
dim(fit$ind$coord)  # Should match the number of provinces
length(AHORA12$Provincia)  # Should match the number of observations

# REPRESENTATION OF PROVINCES IN PCA
pca_province_data <- data.frame(fit$ind$coord[, 1:2])  # Use individuals instead of variables
pca_province_data$Province <- AHORA12$Provincia  # Assign province names

colnames(pca_province_data) <- c("Dim.1", "Dim.2", "Province")

# Create scatter plot with province labels
ggplot(pca_province_data) +
  geom_point(aes(x = Dim.1, y = Dim.2, colour = "darkred")) +
  geom_text_repel(aes(x = Dim.1, y = Dim.2, label = Province)) +
  geom_vline(xintercept = 0, colour = "darkgray") +
  geom_hline(yintercept = 0, colour = "darkgray") +
  labs(x = "Dimension 1 (78%)", y = "Dimension 2 (12.1%)") +
  theme(legend.position = "none")


# JOINT REPRESENTATION: BIPLOT
remotes::install_github('vqv/ggbiplot', force = TRUE)

ggbiplot(fit) +
  scale_color_discrete(name = '') +
  expand_limits(x = c(-3.5, 1.5), y = c(-2, 2)) +
  labs(x = "Dimension 1 (78%)", y = "Dimension 2 (12.1%)") +
  geom_text_repel(label = AHORA12$Provincia, size = 3)

# PCA Biplot Visualization
fviz_pca_biplot(fit,
                geom.ind = "point",
                fill.ind = AHORA12$Provincia, col.ind = "black",
                pointshape = 21, pointsize = 2,
                palette = "jco",
                addEllipses = TRUE,
                alpha.var = "contrib", col.var = "contrib",
                gradient.cols = "RdYlBu",
                legend.title = list(fill = "Province", color = "Contrib",
                                    alpha = "Contrib"))

# EXPORT DESCRIPTIVE STATISTICS TABLE
write.csv2(x = Descriptive_Stats, 
           file = "Descriptive_Stats.csv", 
           row.names = TRUE)

# Get working directory
getwd()
