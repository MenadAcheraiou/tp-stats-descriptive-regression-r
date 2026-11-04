---
tags: [donnees, partie1]
source: Recensement.txt
---
# Données — Recensement.txt (CPS, juillet 2012)

Fichier : [Recensement.txt](../../../Recensement.txt) · description : [[DescriptionA.pdf]] · analyse : [[TP/Partie 1 - Recensement]] · contrôles : [[TP/Qualité des données]]

## Vue d'ensemble
- Enquête américaine CPS (Current Population Survey), juillet 2012. **Données historiques** : elles ne décrivent pas la situation actuelle.
- **Unité statistique** : un individu. **599 lignes × 11 variables**, séparateur tabulation, en-tête présente.
- Aucune variable identifiante (nom, adresse) : on peut afficher les premières lignes.
- Lecture : `read.table("Recensement.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)`.
- Complétude vérifiée : **0 valeur manquante, 0 doublon, 0 salaire nul**.

## Dictionnaire des variables
| Variable   | Signification                    | Type statistique               | Modalités / étendue observées                     |
| ---------- | -------------------------------- | ------------------------------ | ------------------------------------------------- |
| AGE        | âge en années                    | quantitative discrète          | 16 à 80, moyenne 41,9, médiane 42                 |
| SEXE       | sexe                             | qualitative nominale           | F 297 · M 302                                     |
| REGION     | région                           | qualitative nominale           | NE 129 · **NW 122** · S 200 · W 148               |
| STAT_MARI  | statut marital                   | qualitative nominale           | M 325 · C 193 · D 61 · S 14 · V 6                 |
| SAL_HOR    | salaire horaire ($/h)            | quantitative continue          | 2 à 99, moyenne 17,9, médiane 15, écart-type 11,3 |
| SYNDICAT   | appartenance syndicale           | qualitative nominale (binaire) | non 496 · oui 103                                 |
| CATEGORIE  | catégorie professionnelle        | qualitative nominale (codes)   | 1 à 10                                            |
| NIV_ETUDES | niveau d'études                  | qualitative ordinale (codes)   | 32 à 46                                           |
| NB_PERS    | taille du foyer                  | quantitative discrète          | 1 à 13, médiane 3                                 |
| NB_ENF     | enfants du foyer                 | quantitative discrète          | 0 à 6, médiane 0                                  |
| REV_FOYER  | classe de revenu annuel du foyer | qualitative ordinale (classes) | 1 à 16                                            |

Remarque sur le codage : la région est **NW** dans le fichier, alors que le sujet écrit MW. Se fier au fichier.

## Variables à interpréter avec soin
**CATEGORIE (1 à 10).** Les chiffres sont des étiquettes, pas des quantités : la catégorie 4 n'est pas « le double » de la 2. Effectifs : 1 → 46 · 2 → 133 · 3 → 125 · 4 → 48 · 5 → 94 · 6 → 10 · 7 → 36 · 8 → 32 · 9 → 39 · 10 → 36. Catégories étudiées : **1** gestion/commerce/finance (46), **2** profession libérale (133), **5** bureau/administration (94).

**NIV_ETUDES (32 à 46).** Codes ordonnés mais sans écart numérique interprétable. Effectifs bruts : 32→5, 33→6, 34→5, 35→9, 36→5, 37→8, 38→7, **39→187**, **40→148**, 41→22, 42→45, 43→114, 44→29, 45→4, 46→5. Regroupement du sujet : 32–39 primaire/secondaire (232) · 40–42 postsecondaire sans bachelor (215) · 43 bachelor (114) · 44 master (29) · 45 école spécifique (4) · 46 doctorat (5). Les groupes 45 et 46 ont des effectifs minuscules : aucune conclusion fiable.

**REV_FOYER (1 à 16).** Classes de revenu annuel, pas des montants : on ne peut calculer ni revenu moyen ni écart-type exacts. Effectifs : 1→9, 2→5, 3→5, 4→9, 5→7, 6→19, 7→26, 8→38, 9→30, 10→35, 11→61, 12→70, 13→71, 14→89, 15→77, 16→48. Le dictionnaire initial a un saut entre les classes 5 (12 500–14 500 $) et 6 (15 000–20 000 $) : les classes 5 et 6 sont bien présentes dans les données (7 et 19 individus), le trou vient des bornes du dictionnaire. **À signaler, jamais à corriger.**

## Ordres de grandeur utiles
- SAL_HOR : Q1 = 10,5 · Q3 = 22 · IQR = 11,5 · bornes 1,5×IQR : −6,75 et 39,25 → 27 valeurs au-delà de la borne haute (de 40 à 99 $/h).
- Moyenne (17,9) > médiane (15) : distribution asymétrique à droite.
- AGE : Q1 = 29, Q3 = 53,5. NB_PERS : moyenne 3,11. NB_ENF : 413 individus sur 599 n'ont aucun enfant.

## Limites à rappeler dans le rapport
- Données de 2012 : étude historique, pas la situation actuelle.
- Échantillon d'une enquête : pas de pondération disponible ici, donc pas d'extrapolation à toute la population.
- Peu de variables de contexte (expérience, secteur, heures travaillées) : une différence de salaire entre groupes n'est ni une preuve de discrimination ni un lien de causalité.
- Petits effectifs dans certains groupes (études 45/46, catégorie 6, statuts S et V) : prudence.
