# TP — Partie 2 : régression sur MASS::Boston (X = lstat, Y = medv en k$)
# Exécution : Rscript tp_partie2.R
library(MASS)
data("Boston")
x <- Boston$lstat; y <- Boston$medv
options(bitmapType = "cairo")   # accents corrects dans les PNG
invisible(Sys.setlocale("LC_ALL", "C.UTF-8"))
dir.create("figures", showWarnings = FALSE)

# Q1. Nuage de points
png("figures/fig_boston_nuage.png", width = 700, height = 450)
plot(x, y, pch = 16, col = "#00000066", xlab = "lstat (%)", ylab = "medv (k$)",
     main = "Valeur médiane des logements selon lstat (n = 506)")
dev.off()

# Q2. Droite des moindres carrés : formules du cours puis lm()
b1 <- sum((x - mean(x)) * (y - mean(y))) / sum((x - mean(x))^2)
b0 <- mean(y) - b1 * mean(x)
mod <- lm(medv ~ lstat, data = Boston)
c(b0 = b0, b1 = b1); coef(mod)
all.equal(unname(coef(mod)), c(b0, b1))
summary(mod)
png("figures/fig_boston_droite.png", width = 700, height = 450)
plot(x, y, pch = 16, col = "#00000066", xlab = "lstat (%)", ylab = "medv (k$)")
abline(mod, col = "red", lwd = 2)
dev.off()

# Q3-Q4. Corrélation, R², test de Pearson (H0 : rho = 0)
r <- cor(x, y); c(r = r, r2 = r^2, R2_lm = summary(mod)$r.squared)
cor.test(x, y)

# Q5-Q6. Valeurs ajustées et résidus
head(cbind(observe = y, ajuste = fitted(mod)))
res <- residuals(mod)
c(sd_empirique = sd(res), sigma = sigma(mod))   # sigma : dénominateur n-2
png("figures/fig_boston_residus.png", width = 1100, height = 400)
par(mfrow = c(1, 3))
hist(res, col = "grey60", ylab = "Effectif", xlab = "Résidu (k$)", main = "Histogramme des résidus")
boxplot(res, ylab = "Résidu (k$)", main = "Boîte à moustaches")
plot(x, res, pch = 16, col = "#00000066", xlab = "lstat (%)", ylab = "Résidu (k$)",
     main = "Résidus selon lstat")
abline(h = c(-2, 0, 2) * sd(res), lty = c(2, 1, 2), col = "red")
dev.off()

# Q7. Prévision pour lstat = 12 %
predict(mod, data.frame(lstat = 12))

# Q8. Régressogramme (6 classes)
cl <- cut(x, breaks = c(-Inf, 5, 10, 15, 20, 25, Inf))
moy <- tapply(y, cl, mean); moy
bornes <- c(min(x), 5, 10, 15, 20, 25, max(x))   # bornes réelles pour tracer
centres <- c(2.5, 7.5, 12.5, 17.5, 22.5, 30)     # centres ; extrêmes : milieu [0;5], 30 pour >25
png("figures/fig_boston_regressogramme.png", width = 700, height = 450)
plot(x, y, pch = 16, col = "#00000044", xlab = "lstat (%)", ylab = "medv (k$)")
segments(bornes[-7], moy, bornes[-1], moy, col = "blue", lwd = 3)
lines(centres, moy, col = "darkgreen", lwd = 2, type = "b")
abline(mod, col = "red", lwd = 2)
dev.off()
table(cl)

# Q9-Q10. Polynômes de degré 2, 3, 4 et AIC
mods <- list(lin = mod,
             d2 = lm(medv ~ poly(lstat, 2, raw = TRUE), Boston),
             d3 = lm(medv ~ poly(lstat, 3, raw = TRUE), Boston),
             d4 = lm(medv ~ poly(lstat, 4, raw = TRUE), Boston))
sapply(mods, function(m) summary(m)$r.squared)
sapply(mods, AIC)
xs <- data.frame(lstat = seq(min(x), max(x), length.out = 200))
png("figures/fig_boston_poly.png", width = 700, height = 450)
plot(x, y, pch = 16, col = "#00000044", xlab = "lstat (%)", ylab = "medv (k$)")
for (i in 1:4) lines(xs$lstat, predict(mods[[i]], xs), col = c("red", "blue", "darkgreen", "orange")[i], lwd = 2)
legend("topright", c("linéaire", "degré 2", "degré 3", "degré 4"),
       col = c("red", "blue", "darkgreen", "orange"), lwd = 2)
dev.off()
