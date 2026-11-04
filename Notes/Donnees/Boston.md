---
tags: [donnees, partie2]
---
# Données — MASS::Boston

Analyse : [[TP/Partie 2 - Boston]] · cours : [[Cours/Cours 4 - Régression]]

## Vue d'ensemble
- Chargement : `library(MASS)` puis `data("Boston")`. Aucun fichier à importer.
- **506 observations, 14 variables**, aucune valeur manquante.
- Une ligne = un **secteur (tract) de la région de Boston**, pas un individu ni un logement.
- Données historiques tirées du **recensement américain de 1970**. Elles ne décrivent pas la situation actuelle.

## Variables du TP
| Variable | Rôle | Signification | Résumé observé |
|---|---|---|---|
| `lstat` | X (explicative) | pourcentage de la population de statut socio-économique faible dans le secteur | 1,73 à 37,97 · moyenne 12,65 · médiane 11,36 · écart-type 7,14 |
| `medv` | Y (expliquée) | valeur médiane des logements occupés par leur propriétaire, en **milliers de dollars** (k$) | 5 à 50 · moyenne 22,53 · médiane 21,2 · écart-type 9,2 |

- Lecture : `medv = 22` signifie une valeur médiane de 22 000 $ (dollars de 1970).
- **Plafonnement** : `medv` est limitée à 50 ; 16 secteurs valent exactement 50, ce qui cache probablement des valeurs plus élevées. À signaler en discussion.
- Corrélation linéaire entre `lstat` et `medv` : environ **−0,74** (relation décroissante, plutôt forte, avec une courbure visible).

## Autres colonnes du jeu (non utilisées dans le TP)
`crim` (criminalité par habitant), `zn`, `indus`, `chas`, `nox`, `rm` (nombre moyen de pièces), `age`, `dis`, `rad`, `tax`, `ptratio`, `black`. Elles existent mais le sujet ne demande que `lstat` et `medv`.

## Précautions d'interprétation
- Analyse **descriptive** : la corrélation n'établit aucune causalité.
- Unité = secteur : une relation entre secteurs n'est pas une relation entre individus.
- Contexte historique (1970) à rappeler dans le rapport, ainsi que le plafond à 50 k$.
