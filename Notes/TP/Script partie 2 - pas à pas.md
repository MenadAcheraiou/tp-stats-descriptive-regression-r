---
tags: [tp, code, R, partie2]
---
# `tp_partie2.R` expliqué pas à pas

Script : `TP1/tp_partie2.R` · données : [[Donnees/Boston]] · sujet : [[TP/Partie 2 - Boston]] · concepts : [[Concepts/Régression linéaire simple]], [[Concepts/Résidus et sigma]], [[Concepts/Régressogramme]], [[Concepts/Polynômes et AIC]] · autre script : [[TP/Script partie 1 - pas à pas]].
Notation : x = `lstat` (% de population de statut faible), y = `medv` (valeur médiane des logements, k$). Les résultats chiffrés ci-dessous sont ceux de l'exécution du script.

## Préparation
`library(MASS); data("Boston")` charge les 506 secteurs. `x <- Boston$lstat; y <- Boston$medv` simplifie l'écriture.

## Q1 – nuage de points
`plot(x, y)` : la relation est décroissante (plus lstat est grand, plus medv est petit) et **courbée** (pas parfaitement linéaire).

## Q2 – droite des moindres carrés, à la main puis avec `lm()`
- Pente : `b1 = Σ(xi − x̄)(yi − ȳ) / Σ(xi − x̄)²` ; ordonnée : `b0 = ȳ − b1·x̄`.
- `lm(medv ~ lstat)` fait le même calcul. `all.equal(coef(mod), c(b0, b1))` vaut TRUE.
- Résultats : **b0 = 34,55** et **b1 = −0,950**. Interprétation : un secteur sans population à faible statut aurait un `medv` prédit d'environ 34,6 k$ ; chaque point de pourcentage de `lstat` en plus est associé à environ 0,95 k$ de moins (association, pas causalité).
- `abline(mod)` trace la droite sur le nuage.

## Q3-Q4 – corrélation, R², test de Pearson
- `cor(x, y)` = **−0,738**. `r²` = **0,544** = `R²` de `lm` : 54 % de la variabilité de `medv` est expliquée linéairement par `lstat`.
- `cor.test(x, y)` : H0 : ρ = 0 contre H1 : ρ ≠ 0 ; statistique t = −24,53 à 504 ddl, p-valeur < 2,2e-16 → on rejette H0 à 5 %. Une corrélation significative n'implique pas une relation causale.

## Q5-Q6 – valeurs ajustées et résidus
- `fitted(mod)` = valeurs prédites par la droite pour chaque secteur ; `residuals(mod)` = observé − ajusté.
- `sd(res)` = **6,2096** (dénominateur n − 1) ; `sigma(mod)` = **6,2158** (dénominateur n − 2, estimateur usuel de l'écart-type des erreurs). Proches mais différents.
- Figure : histogramme, boîte à moustaches et nuage des résidus avec lignes à ± 2 écarts-types. Une structure courbée ou une asymétrie des résidus révèle que la droite ne suffit pas.

## Q7 – prévision
`predict(mod, data.frame(lstat = 12))` = **23,15 k$**. À interpréter dans le domaine observé de `lstat` (1,7 à 38) : c'est une valeur moyenne attendue, pas une certitude.

## Q8 – régressogramme
- `cut(x, breaks = c(-Inf, 5, 10, 15, 20, 25, Inf))` fait 6 classes (intervalles fermés à droite : x ≤ 5, 5 < x ≤ 10, …). Effectifs : 62, 157, 125, 88, 40, 34.
- `tapply(y, cl, mean)` : moyennes de `medv` par classe : 37,8 · 26,2 · 20,6 · 16,5 · 12,9 · 11,8.
- Fonction constante par morceaux : `segments(...)`. Courbe reliant les moyennes : `lines(centres, moy)`. Abscisses choisies : milieux des classes ; pour les classes extrêmes non bornées, 2,5 (milieu de [0 ; 5]) et 30 pour la classe > 25 (choix à justifier dans le rapport).
- Comparaison à la droite rouge : le régressogramme suit la courbure, la droite non.

## Q9-Q10 – polynômes et AIC
- `lm(medv ~ poly(lstat, k, raw = TRUE))` pour k = 2, 3, 4. R² : 0,544 (linéaire) · 0,641 · 0,658 · 0,673. Le R² augmente forcément avec le degré, ce qui ne garantit pas une meilleure prévision.
- `AIC` : 3289,0 · 3170,5 · 3147,8 · 3126,9 : décroissant jusqu'au degré 4. Le plus petit AIC ne suffit pas à choisir : regarder aussi la complexité (surajustement) et l'allure des courbes aux extrémités.

## À savoir expliquer à l'oral
Pourquoi `sd(res)` ≠ `sigma(mod)` (n − 1 contre n − 2), ce que mesurent r et R², ce que le test dit et ne dit pas, et pourquoi le plafond de `medv` à 50 (voir [[Donnees/Boston]]) limite la lecture.
