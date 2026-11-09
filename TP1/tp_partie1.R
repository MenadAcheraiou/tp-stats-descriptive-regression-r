# TP statistique descriptive - Partie 1 : Recensement (CPS, juillet 2012)
# Exécution : Rscript tp_partie1.R  (depuis le dossier contenant Recensement.txt)

# ---- 1.1 Importation et qualité des données ----

# Q1. Import : fichier texte, séparateur tabulation, en-tête
d <- read.table("Recensement.txt", header = TRUE, sep = "\t",
                stringsAsFactors = FALSE)
dim(d)        # observations x variables ; unité statistique = un individu
head(d, 5)    # aucune variable identifiante (nom, adresse) : affichage possible


# Q2-Q3. Types R, modalités présentes, valeurs manquantes, doublons
str(d)
controle <- data.frame(
  variable   = names(d),
  type_R     = sapply(d, class),
  n_NA       = colSums(is.na(d)),
  n_modalites = sapply(d, function(x) length(unique(x))),
  min        = sapply(d, function(x) if (is.numeric(x)) min(x, na.rm = TRUE) else NA),
  max        = sapply(d, function(x) if (is.numeric(x)) max(x, na.rm = TRUE) else NA),
  row.names  = NULL
)
controle
sum(duplicated(d))                 # lignes strictement identiques
for (v in c("SEXE", "REGION", "STAT_MARI", "SYNDICAT",
            "CATEGORIE", "NIV_ETUDES", "REV_FOYER")) {
  cat("\n", v, "\n"); print(table(d[[v]], useNA = "ifany"))
}

# Q4. Règles de contrôle : on signale, on ne supprime pas
regles <- list(
  age_hors_16_80      = d$AGE < 16 | d$AGE > 80,
  age_mineur          = d$AGE < 18,
  salaire_non_positif = d$SAL_HOR <= 0,
  salaire_tres_bas    = d$SAL_HOR < 7.25,      # sous le salaire minimum fédéral 2012
  salaire_tres_haut   = d$SAL_HOR > 75,
  enfants_ge_foyer    = d$NB_ENF >= d$NB_PERS, # au moins un adulte attendu
  foyer_plus_de_10    = d$NB_PERS > 10
)
sapply(regles, sum)
d[Reduce(`|`, regles[c("salaire_tres_haut", "foyer_plus_de_10")]), ]

# Q5. Population analysée pour SAL_HOR : salaires valides (non NA) et strictement positifs
# Ici les 599 individus le sont (0 NA, 0 salaire nul) : aucun n'est écarté, la
# population analysée est donc l'échantillon complet. Le garde-fou ci-dessous le vérifie
# et empêcherait de rédiger cette phrase si le fichier changeait.
sal_ok <- !is.na(d$SAL_HOR) & d$SAL_HOR > 0
c(valides = sum(sal_ok), exclus = sum(!sal_ok))
stopifnot(all(sal_ok))
# Sensibilité (Q4-Q5) : les salaires < 7,25 $/h (17 cas) et > 75 $/h (2 cas) sont signalés,
# pas supprimés ; ils peuvent être réels (temps partiel, pourboires, cadres) -> voir Q14-Q15.

# ---- 1.2 Décrire la population ----

# Q6. Effectifs et fréquences (dénominateur : n = nrow(d) = 599 individus, aucune NA)
# Attention : la région est codée NE/NW/S/W dans le fichier (le sujet écrit MW).
freq <- function(x) {
  t <- table(x)
  data.frame(modalite = names(t), effectif = as.vector(t),
             frequence_pct = round(100 * as.vector(prop.table(t)), 1))
}
for (v in c("SEXE", "REGION", "STAT_MARI", "SYNDICAT", "CATEGORIE")) {
  cat("\n", v, "(n =", nrow(d), ")\n"); print(freq(d[[v]]))
}

# Q7. Deux graphiques : barres horizontales ordonnées (CATEGORIE) et barres de SEXE
options(bitmapType = "cairo")   # accents corrects dans les PNG
if (.Platform$OS.type != "windows") invisible(Sys.setlocale("LC_ALL", "C.UTF-8"))
dir.create("figures", showWarnings = FALSE)
png("figures/fig_categories.png", width = 800, height = 500)
barplot(sort(table(d$CATEGORIE)), horiz = TRUE, las = 1, col = "steelblue",
        xlab = "Effectif (individus)", ylab = "Catégorie professionnelle",
        main = paste0("Répartition par catégorie professionnelle (n = ", nrow(d), ")"))
dev.off()
png("figures/fig_region.png", width = 600, height = 450)
barplot(100 * prop.table(table(d$REGION)), col = "grey60",
        ylab = "Fréquence (%)", xlab = "Région",
        main = paste0("Répartition par région (n = ", nrow(d), ")"))
dev.off()

# Q8. Niveaux d'études : codes d'origine puis regroupement (codes de l'énoncé)
table(d$NIV_ETUDES)
d$ETUDES <- cut(d$NIV_ETUDES, breaks = c(31, 39, 42, 43, 44, 45, 46),
                labels = c("<=Secondaire", "Postsecondaire sans bachelor",
                           "Bachelor", "Master", "école spécifique", "Doctorat"))
freq(d$ETUDES)

# Q9. Catégories 1, 2, 5 : pourcentages conditionnels
d3 <- subset(d, CATEGORIE %in% c(1, 2, 5))
round(100 * prop.table(table(d3$CATEGORIE, d3$SEXE), margin = 1), 1)    # sexe | catégorie
round(100 * prop.table(table(d3$CATEGORIE, d3$ETUDES), margin = 1), 1)  # études | catégorie
table(d3$CATEGORIE, d3$SEXE)  # effectifs bruts pour comparaison (Q10)

# ---- 1.3 Distributions et indicateurs ----

# Q11. Indicateurs (effectif valide, moyenne, médiane, écart-type, quartiles, min, max)
resume <- function(x) c(n = sum(!is.na(x)), moyenne = mean(x, na.rm = TRUE),
  mediane = median(x, na.rm = TRUE), ecart_type = sd(x, na.rm = TRUE),
  Q1 = unname(quantile(x, .25, na.rm = TRUE)), Q3 = unname(quantile(x, .75, na.rm = TRUE)),
  min = min(x, na.rm = TRUE), max = max(x, na.rm = TRUE))
round(t(sapply(d[c("AGE", "SAL_HOR", "NB_PERS", "NB_ENF")], resume)), 2)

# Q12-Q13. Histogramme et boîte à moustaches ; deux découpages différents
png("figures/fig_sal_dist.png", width = 900, height = 450)
par(mfrow = c(1, 2))
hist(d$SAL_HOR, breaks = seq(0, 100, 5), col = "steelblue", xlab = "Salaire horaire ($/h)",
     ylab = "Effectif", main = "Histogramme (classes de 5 $/h)")
boxplot(d$SAL_HOR, horizontal = TRUE, xlab = "Salaire horaire ($/h)",
        main = "Boîte à moustaches")
dev.off()
png("figures/fig_sal_classes.png", width = 900, height = 450)
par(mfrow = c(1, 2))
hist(d$SAL_HOR, breaks = seq(0, 100, 20), col = "grey60", xlab = "Salaire horaire ($/h)",
     ylab = "Effectif", main = "Classes de 20 $/h")
hist(d$SAL_HOR, breaks = seq(0, 100, 2), col = "grey60", xlab = "Salaire horaire ($/h)",
     ylab = "Effectif", main = "Classes de 2 $/h")
dev.off()

# Q14-Q15. Moyenne vs médiane ; IQR et règle 1,5 x IQR
iqr <- IQR(d$SAL_HOR)
bornes <- quantile(d$SAL_HOR, c(.25, .75)) + c(-1.5, 1.5) * iqr
iqr; bornes
atypiques <- d$SAL_HOR < bornes[1] | d$SAL_HOR > bornes[2]
sum(atypiques); sort(d$SAL_HOR[atypiques])
# sensibilité aux valeurs extrêmes : moyenne et médiane sans les 2 plus hauts salaires
sans2 <- d$SAL_HOR[-order(d$SAL_HOR, decreasing = TRUE)[1:2]]
c(avec = mean(d$SAL_HOR), sans = mean(sans2))
c(avec = median(d$SAL_HOR), sans = median(sans2))

# Q16. Fonction de répartition empirique du salaire horaire
Fn <- ecdf(d$SAL_HOR)
png("figures/fig_ecdf_sal.png", width = 700, height = 450)
plot(Fn, xlab = "Salaire horaire ($/h)", ylab = "F(x)", main = "Fonction de répartition empirique")
abline(v = 15, h = Fn(15), lty = 2)
dev.off()
Fn(15)                        # proportion gagnant au plus 15 $/h
mean(d$SAL_HOR <= 15)       # recoupement par calcul direct (doit égaler Fn(15))
quantile(d$SAL_HOR, 0.9)      # quantile d'ordre 0,9

# Q17. Variance descriptive (n) vs corrigée (n-1) ; var() utilise n-1
n <- length(d$SAL_HOR)
c(var_R = var(d$SAL_HOR), n_moins_1 = sum((d$SAL_HOR - mean(d$SAL_HOR))^2) / (n - 1),
  n = sum((d$SAL_HOR - mean(d$SAL_HOR))^2) / n)

# ---- 1.4 Comparer et interpréter ----

# Q18. Salaires par catégorie 1, 2, 5 : tableau commun et boxplot comparatif
d3 <- subset(d, CATEGORIE %in% c(1, 2, 5))
d3$CATEGORIE <- factor(d3$CATEGORIE)
tab_cat <- aggregate(SAL_HOR ~ CATEGORIE, d3,
                     function(x) round(c(n = length(x), moy = mean(x), med = median(x),
                                         sd = sd(x), Q1 = unname(quantile(x, .25)),
                                         Q3 = unname(quantile(x, .75))), 2))
tab_cat
png("figures/fig_sal_categorie.png", width = 700, height = 450)
boxplot(SAL_HOR ~ CATEGORIE, d3, xlab = "Catégorie professionnelle",
        ylab = "Salaire horaire ($/h)", main = "Salaire horaire par catégorie")
dev.off()

# Q19. Salaire selon le sexe : global puis par catégorie
aggregate(SAL_HOR ~ SEXE, d, function(x) round(c(n = length(x), moy = mean(x), med = median(x)), 2))
aggregate(SAL_HOR ~ CATEGORIE + SEXE, d3, function(x) round(c(n = length(x), moy = mean(x), med = median(x)), 2))

# Q20. études et salaire (association descriptive, pas de causalité)
aggregate(SAL_HOR ~ ETUDES, d, function(x) round(c(n = length(x), moy = mean(x), med = median(x)), 2))
png("figures/fig_sal_etudes.png", width = 900, height = 500)
par(mar = c(13, 4, 3, 1))
boxplot(SAL_HOR ~ ETUDES, d, las = 2, xlab = "", ylab = "Salaire horaire ($/h)",
        main = "Salaire horaire selon le niveau d'études")
dev.off()
cor(d$NIV_ETUDES, d$SAL_HOR, method = "spearman")

# Q21. Âge et salaire : nuage de points + régressogramme (cours 4) ; tranches de 10 ans, 60-80 regroupées (peu de > 70 ans)
png("figures/fig_age_sal.png", width = 700, height = 450)
par(mar = c(4, 4, 1, 1))
plot(d$AGE, d$SAL_HOR, pch = 16, col = "#00000040", xlab = "Âge (années)",
     ylab = "Salaire horaire ($/h)", frame = FALSE)
cl_age <- cut(d$AGE, breaks = c(10, 20, 30, 40, 50, 60, 80))
stopifnot(!anyNA(cl_age))
table(cl_age); sum(d$AGE > 70)
moy_age <- tapply(d$SAL_HOR, cl_age, mean); moy_age; diff(moy_age)
tapply(d$SAL_HOR, cl_age, median); range(d$AGE[d$AGE > 60])
centres_age <- c(15, 25, 35, 45, 55, 70)   # milieux des tranches (extrêmes : milieux de ]10;20] et ]60;80])
bornes_age <- c(min(d$AGE), 20, 30, 40, 50, 60, max(d$AGE))
segments(bornes_age[-7], moy_age, bornes_age[-1], moy_age, col = "#0072B2", lwd = 3)
lines(centres_age, moy_age, col = "#009E73", lwd = 2, lty = 2, type = "b", pch = 17)
legend("topleft", c("Moyenne par tranche", "Courbe reliant les moyennes"), col = c("#0072B2", "#009E73"),
       lwd = c(3, 2), lty = c(1, 2), pch = c(NA, 17), bty = "n", cex = 0.7)
dev.off()
cor(d$AGE, d$SAL_HOR)

# Q22. Syndicat selon la catégorie ; salaires syndiqués / non syndiqués
round(100 * prop.table(table(d$CATEGORIE, d$SYNDICAT), margin = 1), 1)
table(d$CATEGORIE, d$SYNDICAT)
aggregate(SAL_HOR ~ SYNDICAT, d, function(x) round(c(n = length(x), moy = mean(x), med = median(x)), 2))
aggregate(SAL_HOR ~ SYNDICAT + CATEGORIE, d3, function(x) round(c(n = length(x), med = median(x)), 2))

# ---- 1.5 Revenu du foyer (Q25) ----
# Classes 5 et 6 : bornes du dictionnaire initial 12 500-14 500 puis 15 000-20 000
# -> trou apparent [14 500 ; 15 000] à vérifier avec le dictionnaire complet ;
# effectifs par classe, aucune valeur exacte de revenu n'est calculable.
# Contrôle : toutes les classes 1 à 16 sont présentes, y compris 5 (n=7) et 6 (n=19) ;
# la discontinuité vient des bornes du dictionnaire, pas d'une classe manquante. Non corrigée.
stopifnot(setequal(unique(d$REV_FOYER), 1:16))
table(d$REV_FOYER)
round(100 * prop.table(table(d$REV_FOYER)), 1)
