# Trame du rapport (à rédiger par le binôme — 20 pages max hors annexes)

Les chiffres viennent de `tp_partie1.R` et `tp_partie2.R` ; les figures sont dans `figures/`. Les interprétations sont à écrire par vous (consigne du TP) ; les pistes ci-dessous sont des points à vérifier, pas du texte à recopier.

## 0. Page de garde, sommaire, déclaration d'usage de l'IA (nom de l'outil + nature exacte de l'aide)

## 1. Introduction (0,5 p) — objectif, deux jeux de données, plan

## 2. Partie 1 — Recensement 2012 (n = 599, 11 variables)
**Données et qualité (Q1-Q5)** : 0 NA, 0 doublon ; modalité NW présente alors que l'énoncé annonce MW (aucune ligne MW) ; 4 individus < 18 ans ; 17 salaires < 7,25 $/h ; salaires 90 et 99 $/h ; un foyer à 13 personnes. Aucune ligne supprimée ; population SAL_HOR = 599 (aucun salaire manquant ou nul).
**Population (Q6-Q10)** : SEXE 297 F / 302 M ; SYNDICAT 103 oui (17,2 %) ; CATEGORIE 2 = 22,2 %, 3 = 20,9 %, 5 = 15,7 %, 1 = 7,7 %. Études regroupées : ≤secondaire 38,7 %, postsecondaire sans bachelor 35,9 %, bachelor 19,0 %, master 4,8 %, école spécifique 0,7 %, doctorat 0,8 %. Part des femmes : cat. 1 = 50 %, cat. 2 = 61,7 %, cat. 5 = 76,6 % (pourcentages conditionnels ; effectifs bruts 23/23, 82/51, 72/22). Figures : fig_categories, fig_region.
**Indicateurs (Q11-Q17)** : SAL_HOR moyenne 17,90, médiane 15, sd 11,28, Q1 10,5, Q3 22, min 2, max 99 ; IQR 11,5 ; borne haute 39,25 → 27 valeurs atypiques. F(15) = 53,6 % ; 90e percentile = 30 $/h. var(n−1) = 127,22 vs var(n) = 127,01. Figures : fig_sal_dist, fig_sal_classes, fig_ecdf_sal.
**Comparaisons (Q18-Q23)** : moyenne par catégorie 25,2 / 23,9 / 15,2 ; sexe 19,17 (M) vs 16,60 (F) globalement, mais cat. 5 : 14,76 vs 15,28 (écart inversé) ; études : médiane 12,5 → 18,25 (bachelor) ; corr. Spearman études-salaire 0,35 ; corr. âge-salaire 0,25 ; syndiqués 21,06 vs 17,24, mais cat. 2 : médiane 17 (syndiqués) vs 20 (non). Figures : fig_sal_categorie, fig_sal_etudes, fig_age_sal.
**Recul critique (Q24-Q26)** : association ≠ causalité ; variables de contexte (ancienneté, heures travaillées, secteur…) ; REV_FOYER en classes : pas de moyenne exacte ; vérifier la discontinuité des classes 5-6 avec le dictionnaire complet.

## 3. Partie 2 — Boston (n = 506, 1970)
Pente −0,950 k$ par point de lstat, ordonnée 34,55 k$ (formules du cours = lm) ; r = −0,738, R² = 0,544 ; cor.test : t = −24,53, ddl 504, p < 2,2e-16 ; sd(résidus) = 6,2096 vs sigma = 6,2158 (dénominateurs n−1 vs n−2) ; prévision lstat = 12 → 23,15 k$. Régressogramme : 37,79 / 26,19 / 20,63 / 16,51 / 12,86 / 11,81 (effectifs 62/157/125/88/40/34). R² : 0,544 (lin), 0,641 (d2), 0,658 (d3), 0,673 (d4) ; AIC : 3289,0 / 3170,5 / 3147,8 / 3126,9. Figures : fig_boston_nuage, fig_boston_droite, fig_boston_residus, fig_boston_regressogramme, fig_boston_poly.
Pistes : relation courbe (le linéaire sous-estime aux extrêmes), le gain du degré 2 est grand et celui des degrés 3-4 plus faible → à discuter (parcimonie, sur-ajustement, validation croisée possible). Rappeler le contexte historique de 1970 et que lstat est un indicateur de statut socio-économique.

## 4. Discussion critique et conclusion
## 5. Bibliographie · Annexes (sorties complémentaires, script)
