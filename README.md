# TP de statistique descriptive et régression sous R

Travail à rendre en binôme dans le cadre du Master 1 (Université Paris Cité) : analyse de données avec R, en deux parties, accompagnée d'un rapport en français.

## Contenu

**Partie 1 : statistique descriptive sur `Recensement.txt`**
Enquête CPS (juillet 2012), un individu par ligne. Contrôle qualité documenté, description univariée (effectifs, fréquences, indicateurs de position et de dispersion, valeurs atypiques) et comparaisons du salaire horaire selon la catégorie, le sexe, le niveau d'études et l'appartenance syndicale (pourcentages conditionnels).

**Partie 2 : régression sur `MASS::Boston`**
Régression linéaire simple de `medv` (valeur médiane des logements, en k$) sur `lstat` (part de population à faible statut socio-économique) : formules à la main et `lm()`, test de corrélation, résidus, prévision, régressogramme, polynômes de degré 2 à 4 et comparaison par AIC.

Les analyses sont descriptives : elles ne permettent aucune conclusion causale.

## Organisation du dépôt

| Fichier / dossier | Rôle |
|---|---|
| `TP1/tp_partie1.R` | Script de la partie 1 |
| `TP1/tp_partie2.R` | Script de la partie 2 |
| `TP1/trame_rapport.md` | Trame du rapport |
| `Recensement.txt` | Données de la partie 1 |
| `statdes.R` | Script R complémentaire |
| `Notes/` | Notes de cours et du TP (coffre Obsidian) |

Les supports de cours, les annales et l'énoncé (PDF) ne sont pas versionnés.

## Exécution

R (≥ 4.0) avec le package `MASS`, fourni avec R. Depuis la racine du dépôt :

```bash
Rscript TP1/tp_partie1.R
Rscript TP1/tp_partie2.R
```

Les tableaux s'affichent dans la console ; les figures sont enregistrées dans `figures/`.

## Auteurs

Menad Acheraiou et son binôme, M1.
