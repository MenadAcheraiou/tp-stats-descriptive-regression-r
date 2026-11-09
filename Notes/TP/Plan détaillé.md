---
tags: [tp, plan, checklist]
---
# Plan détaillé du TP — étape par étape

Source : [[TPMLSD.pdf]] · contexte : [[TP/TP - Consignes]] · rapport : [[TP/Rapport - plan et checklist]] · scripts : [[TP/Scripts R]]

**Mode d'emploi.** Une case = une étape = une tâche courte (un tableau, une figure, un paragraphe). Chaque étape a un livrable et une vérification : on coche seulement quand la vérification est faite. Pour exécuter une seule étape, dire « exécute l'étape S1.04 » (ou « prochaine étape ») au skill `tp-executer-etape`. Les scripts `tp_partie1.R` et `tp_partie2.R` (dossier `TP1/`) existent déjà en brouillon : les étapes consistent donc à **vérifier, comprendre, adapter et interpréter**, pas à tout réécrire. L'interprétation reste celle du binôme (voir [[TP/Déclaration IA]]).

Convention : `S<phase>.<n°>` · (Qn) = numéro de question du sujet · `→` = livrable · `✔` = vérification.

## Phase 0 — Préparation
- [x] **S0.01** Relire le sujet et lister les contraintes (20 p. max, PDF, script exécutable, déclaration IA). → liste validée à deux · ✔ rien d'omis par rapport à `TPMLSD.pdf`
- [x] **S0.02** Installer/vérifier R (+ `MASS`, `ggplot2`/`dplyr` si utilisés) et lancer les deux scripts existants tels quels. → état de référence · ✔ `Rscript tp_partie1.R` et `tp_partie2.R` tournent sans erreur
- [x] **S0.03** Choisir le format du rapport (`.Rmd` ou `.qmd` rendu en PDF, ou Word/LaTeX exporté en PDF) et fixer le gabarit. → squelette vide qui compile en PDF · ✔ PDF généré avec page de garde et sommaire
- [ ] **S0.04** Répartir le travail entre les deux membres du binôme. → qui fait quoi · ✔ chacun peut expliquer toutes les parties à la fin

## Phase 1 — Partie 1 : Recensement
### 1.1 Importation et qualité
- [x] **S1.01** (Q1) Import, nombre d'observations/variables, unité statistique, 5 premières lignes. → extrait de sortie · ✔ n = 599 × 11 confirmé sur `Recensement.txt`
- [x] **S1.02** (Q2) Type statistique de chaque variable, avec justification pour NIV_ETUDES, CATEGORIE, REV_FOYER. → tableau variable/type · ✔ cas discutables argumentés
- [x] **S1.03** (Q3) Tableau de contrôle : types R, modalités présentes, NA, doublons. → tableau synthétique · ✔ modalité « NW » vs « MW » de l'énoncé signalée
- [x] **S1.04** (Q4) Règles de contrôle documentées (âge, salaire, enfants, taille du foyer), sans suppression. → règles + effectifs signalés · ✔ aucune ligne supprimée
- [x] **S1.05** (Q5) Population utilisée pour SAL_HOR (NA, zéros) et impact possible. → phrase + effectif · ✔ dénominateur indiqué

### 1.2 Décrire la population
- [x] **S1.06** (Q6) Tableaux effectifs/fréquences : SEXE, REGION, STAT_MARI, SYNDICAT, CATEGORIE. → 5 tableaux · ✔ dénominateurs donnés, somme = 100 %
- [x] **S1.07** (Q7) Deux graphiques adaptés + justification du choix. → 2 figures numérotées, avec unités · ✔ reproduites par le script
- [x] **S1.08** (Q8) Niveaux d'études : codes bruts puis regroupement justifié. → tableau brut + tableau regroupé · ✔ codes 32–46 couverts, regroupement conforme au sujet
- [x] **S1.09** (Q9) Structure des catégories 1, 2, 5 selon sexe et études, en pourcentages conditionnels. → tableaux `prop.table(..., margin=)` · ✔ marge utilisée explicitée
- [x] **S1.10** (Q10) Deux différences marquantes + pourquoi les effectifs bruts trompent. → paragraphe · ✔ effectifs bruts et pourcentages cités ensemble

### 1.3 Distributions et indicateurs
- [x] **S1.11** (Q11) Indicateurs AGE, SAL_HOR, NB_PERS, NB_ENF + justification. → tableau · ✔ n valide, moyenne, médiane, sd, quartiles, min, max
- [x] **S1.12** (Q12) Forme de la distribution de SAL_HOR : histogramme + boxplot. → 1 figure + commentaire · ✔ asymétrie, dispersion, atypiques commentées
- [x] **S1.13** (Q13) Deux histogrammes de SAL_HOR avec classes différentes. → 1 figure double · ✔ effet du découpage expliqué
- [x] **S1.14** (Q14) Moyenne vs médiane du salaire, sans refaire le tableau de Q11. → paragraphe · ✔ renvoi au tableau Q11
- [x] **S1.15** (Q15) IQR, règle 1,5 × IQR, observations atypiques (pas forcément erronées). → chiffres + commentaire · ✔ bornes et nombre de valeurs atypiques recalculés
- [x] **S1.16** (Q16) Fonction de répartition empirique (`ecdf`) + lecture d'une proportion ou d'un quantile. → figure + valeur lue · ✔ valeur recoupée par un calcul direct
- [x] **S1.17** (Q17) Variance en n vs n−1, et `var()` de R. → mini-calcul + explication · ✔ les deux valeurs retrouvées à la main

### 1.4 Comparer et interpréter
- [x] **S1.18** (Q18) Salaires des catégories 1, 2, 5 : tableau commun + graphique, centre et dispersion. → tableau + figure · ✔ effectifs par groupe affichés
- [x] **S1.19** (Q19) Salaires selon le sexe, global puis dans les catégories 1, 2, 5. → tableau + commentaire · ✔ conclusions globales vs par catégorie comparées
- [x] **S1.20** (Q20) Études et salaire, sans conclure à la causalité. → tableau/figure · ✔ formulation non causale
- [x] **S1.21** (Q21) Âge et salaire : nuage + tendance descriptive adaptée, limites. → figure + limites · ✔ tendance justifiée
- [x] **S1.22** (Q22) SYNDICAT selon la catégorie, puis salaires syndiqués/non syndiqués si les effectifs le permettent. → tableaux · ✔ petits effectifs signalés
- [x] **S1.23** (Q23) Trois constats chiffrés et deux limites. → paragraphe · ✔ chaque constat renvoie à un résultat du rapport

### 1.5 Recul critique
- [x] **S1.24** (Q24) Différence observée ≠ discrimination ni causalité ; deux variables de contexte. → paragraphe · ✔ aucune phrase causale
- [x] **S1.25** (Q25) REV_FOYER : ce que permettent les classes, ce qu'elles empêchent de calculer ; trou entre classes 5 et 6 signalé et vérifié, pas corrigé. → paragraphe · ✔ vérification faite sur les données et le dictionnaire
- [x] **S1.26** (Q26, optionnel) Comparaison avec un indicateur récent BLS/Census (définitions, champ, unité, période). → à décider ensemble · ✔ si retenu : source citée et comparabilité discutée — fait le 2026-11-09 : BLS CES0500000003 + CPI-U, sous-section 2.3.1 du rapport

## Phase 2 — Partie 2 : Boston
- [x] **S2.01** (Q1) Nuage `medv` en fonction de `lstat` et description (sens, intensité, non-linéarité). → figure + commentaire · ✔ unités sur les axes
- [x] **S2.02** (Q2) Droite des moindres carrés : formules du cours puis `lm()`/`summary()`, `abline()`, interprétation pente et ordonnée. → coefficients + figure · ✔ formules = `coef(lm)`
- [x] **S2.03** (Q3) Corrélation et R², signification et commentaire. → valeurs + texte · ✔ R² = r²
- [x] **S2.04** (Q4) `cor.test()` à 5 % : hypothèses, statistique, p-valeur, conclusion non causale. → paragraphe · ✔ H0/H1 écrites
- [x] **S2.05** (Q5) Valeurs ajustées `fitted()` vs observées. → extrait + explication · ✔ lien avec la droite
- [x] **S2.06** (Q6) Résidus : histogramme, boxplot, nuage avec ± 2 sd, `sd(residuals(m))` vs `sigma(m)`. → figure + explication · ✔ différence de dénominateur (n−1 vs n−2) expliquée
- [x] **S2.07** (Q7) Prévision avec `predict()` pour une valeur de `lstat` choisie. → valeur choisie + prévision · ✔ interprétation en k$, dans le domaine observé
- [x] **S2.08** (Q8) Régressogramme : `cut()` en 6 classes, moyennes, fonction constante par morceaux, courbe reliant les moyennes (abscisses des classes extrêmes justifiées), comparaison à la droite. → figure · ✔ effectifs par classe donnés
- [x] **S2.09** (Q9) Polynômes degrés 2, 3, 4 : R², courbes, évolution ; pourquoi un R² plus élevé ne garantit pas une meilleure prévision. → tableau + figure · ✔ R² croissants vérifiés
- [x] **S2.10** (Q10) `AIC()` des 4 modèles, choix argumenté (pas seulement le plus petit AIC). → tableau + justification · ✔ complexité et graphiques pris en compte

## Phase 3 — Rédaction du rapport
- [x] **S3.01** Choisir les résultats essentiels à garder dans le rapport (le reste va en annexe). → liste tableaux/figures retenus · ✔ budget de pages estimé ≤ 20
- [ ] **S3.02** Page de garde, sommaire et déclaration d'usage de l'IA (outil + nature exacte de l'aide). → pages 1–2 · ✔ déclaration conforme à [[TP/Déclaration IA]]
- [x] **S3.03** Introduction (objectif, deux jeux de données, plan). → ~0,5 p. · ✔ contexte historique 2012 et 1970 rappelé
- [x] **S3.04** Données et méthodes (fonctions R, règles de qualité, population analysée). → section · ✔ cohérent avec le script
- [x] **S3.05** Résultats commentés, Partie 1. → section · ✔ figures/tableaux numérotés, titrés, avec unités, commentés
- [x] **S3.06** Résultats commentés, Partie 2. → section · ✔ idem
- [x] **S3.07** Discussion critique (limites, causalité, données anciennes, variables omises). → section · ✔ aucune phrase causale
- [x] **S3.08** Conclusion et bibliographie. → fin du rapport · ✔ sources citées
- [ ] **S3.09** Annexes (sorties complémentaires, éventuellement script). → annexes · ✔ hors des 20 pages

## Phase 4 — Vérifications finales
- [x] **S4.01** Faire tourner le script de bout en bout dans une session R propre. → script sans erreur · ✔ toutes les figures et tables du rapport sont régénérées
- [ ] **S4.02** Relecture croisée du script et du rapport (skills `code-review` / `final-review`), simplification (`ponytail`). → corrections · ✔ pas de code mort, chiffres du texte = sorties du script
- [x] **S4.03** Contrôle du PDF (nombre de pages ≤ 20 hors annexes, mise en page). → PDF final · ✔ pages comptées
- [ ] **S4.04** Chacun s'entraîne à expliquer méthodes, script, résultats. → ✔ question-réponse à deux
- [ ] **S4.05** Dépôt sur Moodle ou envoi à l'enseignant. → ✔ accusé de dépôt
