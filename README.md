# eval-template

Template LaTeX complet pour générer des évaluations mathématiques multi-versions (A–D) et leurs correctifs. Le dépôt associe un squelette documentaire paramétrable à des macros partagées suivies en sous-module.

## Aperçu du dépôt
| Chemin | Rôle |
| --- | --- |
| `src/main.tex` | Point d'entrée qui charge `base/evaltemplate.sty`, applique la configuration et insère la grille d'évaluation avant la séquence de questions. |
| `src/config.tex` | Définit titres, objectifs et macro `\qseq` qui ordonne les questions/réponses. |
| `src/questions/` & `src/answers/` | Paires LaTeX (`q#.tex` / `a#.tex`) consommées par `\inputqora{n}` et `\inlineanswer{a#}`. Les fichiers `qx.tex`/`ax.tex` servent de modèles. |
| `src/images/` | Logos ou schémas référencés via `\includegraphics`. |
| `src/corr.docx` | Commentaires ou corrigé rédigé, fusionné lors des correctifs concaténés. |
| `base/` *(sous-module)* | Style commun (`evaltemplate.sty`) et widgets de barème (`crit.tex`). Mettre à jour via `./submods.sh`. |
| `examples/` | Exemples prêts à l'emploi (`versions.tex` pour des tableaux multi-colonnes). |
| `build/` | Sorties temporaires générées automatiquement; reste non suivi. |

## Prérequis
- TeX Live/MikTeX avec `pdflatex`, TikZ et tous les packages requis par `base/evaltemplate.sty`.
- `pdfunite` (Poppler) et `soffice --headless` (LibreOffice) pour les concaténations et la conversion DOCX→PDF.
- GNU Make, Bash et Git avec prise en charge des sous-modules.

## Compilation
```bash
make A            # génère build/<name>_<release>_A.pdf
make correctif_B  # version B avec réponses (dossier build/corr/B)
make concatenate  # assemble A–D en fascicules communs
make concatenate_correctif
make clean        # purge build/* et fichiers auxiliaires LaTeX
```
`make` lit `makefile.conf` pour connaître `name` (par défaut le nom du dépôt) et `release` (`mxex-v4.0`). Lancer les commandes depuis la racine du projet garantit les chemins relatifs corrects.

## Ajouter une question
1. `./newquestion.sh` pour cloner `src/questions/qx.tex` vers la prochaine `qN.tex` (et créer `aN.tex`).
2. Écrire l'énoncé avec `\question[pts]`, `\drawline`, `\drawmultilines{n}`, etc.
3. Renseigner la réponse dans `src/answers/aN.tex` via `\corr{...}` ou `\inlineanswer{aN}`.
4. Enregistrer la question dans `\qseq` (`src/config.tex`) afin de synchroniser numérotation et barème auto (`base/crit.tex`).
5. Compiler les variantes concernées (`make A`, `make correctif_A`, etc.) avant toute demande de revue.

`cleanqna.sh` supprime rapidement toutes les questions/réponses au-delà de Q1/A1 pour repartir de zéro.

## Tests et QA
- Compiler chaque variante touchée (standard + correctif) pour vérifier diacritiques, images et pagination.
- Exécuter `make concatenate` après les builds unitaires; ouvrir les PDF fusionnés pour détecter les pages manquantes.
- Traiter les warnings LaTeX (références manquantes, overfull boxes) comme des échecs.

## Sous-modules
Le dossier `base` pointe vers `git@github.com:Makcime/eval-template-base.git`. Après clonage :
```bash
git submodule update --init --recursive
./submods.sh  # récupère les dernières macros partagées
```
Toute modification des macros doit se faire dans ce dépôt amont.

## Cycle de release
1. Ajuster `makefile.conf` (valeurs `name`/`release`).
2. Mettre à jour titres, objectifs et séquence dans `src/config.tex`.
3. Lancer `make all` pour construire A–D et leurs correctifs.
4. Exécuter les cibles de concaténation et archiver les PDF sous `build/` (ne jamais les committer).

## Contribution
- Lire `AGENTS.md` pour les consignes d'approbation et de validation obligatoires (tests approuvés avant tout commit).
- Conserver l'exécutabilité des scripts (`chmod +x`).
- Ajouter les médias dans `src/images/` avec des chemins relatifs.
- Soumettre les modifications de macros via le dépôt `eval-template-base` puis mettre à jour le sous-module ici.
