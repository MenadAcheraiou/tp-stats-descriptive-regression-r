# TP — Partie 2 : régression sur MASS::Boston (X = lstat, Y = medv en milliers de dollars de 1970)
# Exécution : depuis le dossier TP1/, Rscript tp_partie2.R (les figures sont écrites dans TP1/figures/)
library(MASS)
data("Boston")
x <- Boston$lstat; y <- Boston$medv
options(bitmapType = "cairo")   # accents corrects dans les PNG
if (.Platform$OS.type != "windows") invisible(Sys.setlocale("LC_ALL", "C.UTF-8"))
dir.create("figures", showWarnings = FALSE)
# Palette Okabe-Ito (distincte pour les daltoniens) ; points en gris transparent
gris <- "#00000055"; rouge <- "#D55E00"; bleu <- "#0072B2"; vert <- "#009E73"; rose <- "#CC79A7"

# Q1. Nuage de points
range(x); range(y); sum(y == 50)   # étendues ; secteurs plafonnés à medv = 50
png("figures/fig_boston_nuage.png", width = 700, height = 450)
plot(x, y, pch = 16, col = gris, xlab = "lstat (%)", ylab = "medv (k$)",
     main = "Valeur médiane des logements selon lstat (n = 506)")
dev.off()

# Q2. Droite des moindres carrés : formules du cours (b1 = Cov/Var, même rapport avec n ou n-1) puis lm()
b1 <- cov(x, y) / var(x)
b0 <- mean(y) - b1 * mean(x)
mod <- lm(medv ~ lstat, data = Boston)
c(b0 = b0, b1 = b1); coef(mod)
all.equal(unname(coef(mod)), c(b0, b1))
summary(mod)
png("figures/fig_boston_droite.png", width = 700, height = 450)
plot(x, y, pch = 16, col = gris, xlab = "lstat (%)", ylab = "medv (k$)",
     main = "Droite des moindres carrés (n = 506)")
abline(mod, col = rouge, lwd = 2)
dev.off()

# Q3-Q4. Corrélation, R², test de Pearson (H0 : rho = 0)
r <- cor(x, y); c(r = r, r2 = r^2, R2_lm = summary(mod)$r.squared,
                  R2_var = var(fitted(mod)) / var(y))   # cours : R² = Var(y ajusté) / Var(y)
cor.test(x, y)

# Q5-Q6. Valeurs ajustées et résidus
head(cbind(observe = y, ajuste = fitted(mod), residu = residuals(mod)))
c(moy_ajuste = mean(fitted(mod)), sd_ajuste = sd(fitted(mod)), sd_y = sd(y))
res <- residuals(mod)
c(sd_empirique = sd(res), sigma = sigma(mod), sigma_formule = sqrt(sum(res^2) / (length(res) - 2)))   # sigma : dénominateur n-2 = 504
range(res)
c(au_dessus = sum(res > 2 * sd(res)), en_dessous = sum(res < -2 * sd(res)))   # hors ± 2 sd
png("figures/fig_boston_residus.png", width = 1100, height = 400)
par(mfrow = c(1, 3), mar = c(4, 4, 3, 1), cex.lab = 1.2, cex.axis = 1.1)
hist(res, col = "grey60", ylab = "Effectif", xlab = "Résidu (k$)", main = "Histogramme")
boxplot(res, ylab = "Résidu (k$)", main = "Boîte à moustaches")
plot(x, res, pch = 16, col = gris, xlab = "lstat (%)", ylab = "Résidu (k$)",
     main = "Résidus selon lstat\n(lignes : 0 et ± 2 écarts-types)")
abline(h = c(-2, 0, 2) * sd(res), lty = c(2, 1, 2), col = rouge, lwd = 2)
dev.off()

# Q7. Prévision pour lstat = 12 %
predict(mod, data.frame(lstat = 12))
2 * sigma(mod)   # ordre de grandeur de l'écart d'un secteur à la prévision (environ ± 2 sigma)

# Q8. Régressogramme (6 classes : <= 5, ]5;10], ]10;15], ]15;20], ]20;25], > 25)
# Bornes 0 (un pourcentage est >= 0) et 40 (valeur ronde > max observé 37,97) : mêmes classes que le sujet
cl <- cut(x, breaks = c(0, 5, 10, 15, 20, 25, 40))
stopifnot(!anyNA(cl))   # tous les lstat sont dans ]0 ; 40] : mêmes classes que le sujet
moy <- tapply(y, cl, mean); moy
tapply(res, cl, mean)   # résidu moyen de la droite par classe
bornes <- c(min(x), 5, 10, 15, 20, 25, max(x))   # bornes réelles pour tracer
centres <- c(2.5, 7.5, 12.5, 17.5, 22.5, 32.5)   # milieux de [0 ; 5], ..., [25 ; 40]
png("figures/fig_boston_regressogramme.png", width = 700, height = 450)
plot(x, y, pch = 16, col = gris, xlab = "lstat (%)", ylab = "medv (k$)",
     main = "Régressogramme de medv selon lstat (n = 506)")
segments(bornes[-7], moy, bornes[-1], moy, col = bleu, lwd = 3)
lines(centres, moy, col = vert, lwd = 2, lty = 2, type = "b", pch = 17)
abline(mod, col = rouge, lwd = 2)
legend("topright", c("Moyennes par classe (constante par morceaux)", "Courbe reliant les moyennes", "Droite de régression"),
       col = c(bleu, vert, rouge), lwd = c(3, 2, 2), lty = c(1, 2, 1), pch = c(NA, 17, NA), bty = "n")
dev.off()
table(cl)

# Q9-Q10. Polynômes de degré 2, 3, 4 et AIC
mods <- list(lin = mod,
             d2 = lm(medv ~ poly(lstat, 2, raw = TRUE), Boston),
             d3 = lm(medv ~ poly(lstat, 3, raw = TRUE), Boston),
             d4 = lm(medv ~ poly(lstat, 4, raw = TRUE), Boston))
# R² (summary) et AIC (Q10)
sapply(mods, function(m) summary(m)$r.squared)
sapply(mods, AIC); -diff(sapply(mods, AIC))   # écarts d'AIC d'un degré au suivant
# lstat où la courbe ajustée se met à remonter : grille de pas 0,01 (comme le code du prof),
# premier point où la courbe augmente ; NA si elle reste décroissante sur la plage observée
xg <- data.frame(lstat = seq(min(x), max(x), by = 0.01))
remontee <- function(k) { f <- predict(k, xg); i <- which(diff(f) > 0); if (length(i)) xg$lstat[i[1]] else NA }
hausse <- sapply(mods[2:4], remontee)
stopifnot(is.na(hausse["d3"]))   # seul le degré 3 reste décroissant
hausse; sum(x > hausse["d4"])   # secteurs au-delà de la remontée du degré 4
xs <- data.frame(lstat = seq(min(x), max(x), length.out = 200))
cols <- c(rouge, bleu, vert, rose)
png("figures/fig_boston_poly.png", width = 700, height = 450)
plot(x, y, pch = 16, col = gris, xlab = "lstat (%)", ylab = "medv (k$)",
     main = "Ajustements linéaire et polynomiaux (n = 506)")
lw <- c(2, 2, 3, 2)   # degré 3 (retenu) plus épais
for (i in 1:4) lines(xs$lstat, predict(mods[[i]], xs), col = cols[i], lwd = lw[i], lty = i)
legend("topright", c("linéaire", "degré 2", "degré 3 (retenu)", "degré 4"), col = cols, lwd = lw, lty = 1:4, bty = "n")
dev.off()
