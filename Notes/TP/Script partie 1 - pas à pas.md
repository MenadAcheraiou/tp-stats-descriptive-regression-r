---
tags: [tp, code, R, partie1]
---
# `tp_partie1.R` expliqué pas à pas

Pour toi, afin de pouvoir expliquer chaque ligne à l'oral. Script : `TP1/tp_partie1.R` · données : [[Donnees/Recensement]] · contrôles : [[TP/Qualité des données]] · sujet : [[TP/Partie 1 - Recensement]] · autre script : [[TP/Script partie 2 - pas à pas]].
Principe général : le script se lit de haut en bas, chaque bloc répond à une question (Qn) du sujet et les figures sont écrites dans `figures/`. Toutes les sorties chiffrées s'affichent dans la console quand on lance `Rscript tp_partie1.R`.

## 1.1 Importation et qualité
**Q1 – import.** `read.table(..., header = TRUE, sep = "\t")` lit un fichier texte dont les colonnes sont séparées par des tabulations et dont la première ligne contient les noms. `dim(d)` donne 599 × 11 ; `head(d, 5)` montre les 5 premières lignes (aucune donnée personnelle).

**Q2-Q3 – types, NA, doublons.** `str(d)` montre le type R de chaque colonne. Le tableau `controle` rassemble, pour chaque variable : type, nombre de NA (`colSums(is.na(d))`), nombre de modalités (`unique`), minimum et maximum si numérique. `sum(duplicated(d))` compte les lignes identiques (0). La boucle `for` affiche `table(..., useNA = "ifany")` pour les variables qualitatives : `useNA` fait apparaître les NA s'il y en a.

**Q4 – règles de contrôle.** La liste `regles` contient des conditions logiques (âge < 18, salaire < 7,25 ou > 75, enfants ≥ taille du foyer, foyer > 10 personnes). `sapply(regles, sum)` compte les cas de chaque règle (TRUE = 1). On ne supprime rien : on signale.

**Q5 – population de SAL_HOR.** `sal_ok` = salaire non manquant ET > 0. `stopifnot(all(sal_ok))` arrête le script si ce n'est plus vrai : preuve que la population analysée est les 599 individus.

## 1.2 Décrire la population
**Q6 – effectifs et fréquences.** La fonction `freq(x)` fait `table(x)` (effectifs) puis `prop.table(t)` (fréquences, dénominateur = n total). La boucle l'applique à SEXE, REGION, STAT_MARI, SYNDICAT, CATEGORIE.

**Q7 – deux graphiques.** `barplot` horizontal trié pour CATEGORIE (10 modalités, étiquettes lisibles) et diagramme en barres des fréquences pour REGION. `png(...)` ouvre le fichier image, `dev.off()` le ferme. `options(bitmapType = "cairo")` et `Sys.setlocale` servent aux accents dans les PNG.

**Q8 – niveaux d'études.** `table(d$NIV_ETUDES)` : codes bruts d'abord. `cut(..., breaks = c(31, 39, 42, 43, 44, 45, 46))` crée les groupes du sujet (intervalles fermés à droite : 32–39, 40–42, 43, 44, 45, 46) avec des libellés.

**Q9-Q10 – catégories 1, 2, 5.** `subset(d, CATEGORIE %in% c(1,2,5))` filtre. `prop.table(table(catégorie, sexe), margin = 1)` : chaque **ligne** somme à 100 % → part de F et M **dans** chaque catégorie. On compare à `table(...)` brut (effectifs) pour voir pourquoi les effectifs seuls trompent quand les tailles de groupes diffèrent (46, 133, 94 personnes).

## 1.3 Distributions et indicateurs
**Q11 – indicateurs.** La fonction `resume(x)` renvoie n valide, moyenne, médiane, écart-type, Q1, Q3, min, max (`na.rm = TRUE` ignore les NA). `sapply` l'applique à AGE, SAL_HOR, NB_PERS, NB_ENF ; `t()` transpose le résultat.

**Q12-Q13 – histogrammes, boxplot.** `hist(..., breaks = 10)` et `boxplot` côte à côte (`par(mfrow = c(1,2))`). Puis deux histogrammes avec 5 et 40 classes : le découpage change la lecture (trop gros = on perd la forme, trop fin = bruit).

**Q14-Q15 – moyenne/médiane, valeurs atypiques.** `IQR` = Q3 − Q1 = 11,5. Les bornes 1,5×IQR : `quantile(c(.25,.75)) ± 1.5*iqr` = −6,75 et 39,25. `atypiques` repère les salaires hors bornes (27). Sensibilité : `sans2` retire les deux plus hauts salaires et on recalcule moyenne et médiane.

**Q16 – ECDF.** `ecdf(x)` renvoie une fonction F(x) = proportion des observations ≤ x. `Fn(15)` = proportion gagnant au plus 15 $/h ; `mean(d$SAL_HOR <= 15)` donne la même valeur par calcul direct (vérification). `quantile(..., 0.9)` = quantile d'ordre 0,9.

**Q17 – variances.** `var()` de R divise par n − 1. Le script recalcule à la main avec n − 1 puis avec n pour montrer la différence (127,22 contre 127,01).

## 1.4 Comparer et interpréter
**Q18 – catégories.** `aggregate(SAL_HOR ~ CATEGORIE, d3, function(x) ...)` calcule effectif, moyenne, médiane, écart-type, quartiles par groupe. `boxplot(SAL_HOR ~ CATEGORIE)` compare centre et dispersion.

**Q19 – sexe.** Même `aggregate`, d'abord globalement (`~ SEXE`) puis dans les catégories (`~ CATEGORIE + SEXE`) : on vérifie si la conclusion globale tient à l'intérieur de chaque catégorie.

**Q20 – études.** `aggregate(SAL_HOR ~ ETUDES)`, boxplot par groupe, et `cor(..., method = "spearman")` : corrélation de rangs, adaptée à des codes ordonnés. Association descriptive, pas causalité.

**Q21 – âge.** Nuage de points et `lowess` (courbe de tendance locale, sans forme imposée), puis `cor` de Pearson.

**Q22 – syndicat.** `prop.table(..., margin = 1)` : % de syndiqués dans chaque catégorie, effectifs bruts à côté, puis salaires selon SYNDICAT (et par catégorie dans d3). Attention aux petits effectifs.

## 1.5 Revenu du foyer (Q25)
`stopifnot(setequal(unique(d$REV_FOYER), 1:16))` vérifie que les 16 classes existent ; `table` et `prop.table` donnent effectifs et %. Le trou entre classes 5 et 6 vient du dictionnaire : signalé, jamais corrigé.

## Comment l'expliquer à l'oral
Pour chaque bloc, sache dire : la fonction R utilisée, le dénominateur, et une limite d'interprétation.
