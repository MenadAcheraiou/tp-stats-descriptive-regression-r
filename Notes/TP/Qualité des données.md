---
tags: [tp, partie1, qualite]
---
# Contrôle qualité (Recensement)

Principe : des **règles documentées** qui signalent les observations suspectes, **sans rien supprimer automatiquement**. Voir [[TP/Partie 1 - Recensement]] et [[Donnees/Recensement]] · script `tp_partie1.R` (Q3 à Q5).

## Contrôles structurels (résultats)
| Contrôle | Résultat |
|---|---|
| Nombre de lignes × variables | 599 × 11 |
| Valeurs manquantes (NA) | 0 dans toutes les variables |
| Lignes strictement dupliquées | 0 (`sum(duplicated(d))`) |
| Salaires nuls ou négatifs | 0 |
| Modalités présentes | SEXE 2, REGION 4, STAT_MARI 5, SYNDICAT 2, CATEGORIE 10, NIV_ETUDES 15, REV_FOYER 16 |
| Région | **NW** dans le fichier, MW dans le sujet |

Les doublons sont testés sur toute la ligne ; sans identifiant, deux individus réels peuvent être identiques, donc un doublon ne serait signalé qu'à titre d'alerte.

## Règles de contrôle (signalement seulement)
| Règle | Justification | Cas signalés |
|---|---|---|
| AGE < 16 ou > 80 | hors de l'âge de travail de l'enquête | 0 |
| AGE < 18 | mineurs : possible mais à signaler | 4 |
| SAL_HOR ≤ 0 | impossible | 0 |
| SAL_HOR < 7,25 $/h | sous le salaire minimum fédéral de 2012 (cas possibles : pourboires, temps partiel, statuts particuliers) | 17 (minimum observé : 2 $/h) |
| SAL_HOR > 75 $/h | très élevé pour cette population | 2 (90 et 99) |
| NB_ENF ≥ NB_PERS | au moins un adulte attendu dans le foyer | 0 |
| NB_PERS > 10 | foyer atypique | 1 (13 personnes) |

Ces cas sont **suspects, pas forcément erronés**.

## Population analysée pour SAL_HOR
Tous les 599 salaires sont renseignés et strictement positifs : **aucun individu n'est écarté**, la population analysée est l'échantillon complet (n = 599). Le script le vérifie (`stopifnot`) pour ne pas rédiger cette phrase par erreur si le fichier changeait.
Impact possible : les salaires extrêmes (2 $/h, 99 $/h) pèsent sur la moyenne mais peu sur la médiane. Sensibilité : retirer les deux plus hauts salaires fait passer la moyenne de 17,90 à 17,64 $/h et laisse la médiane à 15.

## Valeurs atypiques et REV_FOYER
- Règle 1,5 × IQR sur SAL_HOR : IQR = 11,5, borne haute 39,25 → **27 salaires** au-delà (de 40 à 99 $/h). Atypique ne veut pas dire erroné : cadres, professions libérales.
- REV_FOYER : saut apparent entre les classes 5 et 6 dans le dictionnaire, mais les 16 classes sont présentes dans les données (classe 5 : 7 individus, classe 6 : 19). Signalé, pas corrigé.

## À mentionner dans le rapport
Règles et seuils utilisés, nombre de cas signalés par règle, décision de conserver toutes les observations, et le fait que le choix peut modifier moyenne et écart-type.
