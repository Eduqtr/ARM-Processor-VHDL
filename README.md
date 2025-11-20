# ARM Processor Implementation in VHDL

![ARM Processor](https://www.arm.com/) ![Architecture](https://en.wikipedia.org/wiki/VHDL)

Un processeur ARM simplifié implémenté en VHDL comprenant :

✅ Opérations arithmétiques et logiques de base (ADD, SUB, AND, ORR)  
✅ Barrel shifter pour manipulation de données (LSL, LSR, ASR, ROR)  
✅ Instruction de comparaison (CMP)  
✅ Exécution conditionnelle avec flags (N, Z, C, V)  
✅ Opérations mémoire (LDR, STR)  

---

## 📋 Table des matières

- [Features](#-features)  
- [Architecture](#-architecture)  
- [Getting Started](#-getting-started)  
- [File Structure](#-file-structure)  
- [Instructions Supported](#-instructions-supported)  
- [Testing](#-testing)  
- [Documentation](#-documentation)  
- [Contributing](#-contributing)  
- [License](#-license)  

---

## ✨ Features

### Composants principaux

- **ALU (Arithmetic Logic Unit)** : Effectue les opérations arithmétiques et logiques  
- **Shifter** : Supporte LSL, LSR, ASR, et ROR  
- **Register File** : 16 registres (R0-R15) de 32 bits  
- **Control Unit** : Décode les instructions et génère les signaux de contrôle  
- **Conditional Execution** : Support complet des codes conditionnels ARM  

| Catégorie       | Instructions          |
|-----------------|----------------------|
| Arithmétique    | ADD, SUB             |
| Logique         | AND, ORR             |
| Comparaison     | CMP                  |
| Mémoire         | LDR, STR             |
| Décalages       | LSL, LSR, ASR, ROR   |

---

## 🏗️ Architecture

<img width="812" height="436" alt="Capture d’écran 2025-11-19 225631" src="https://github.com/user-attachments/assets/fb1dfc92-0a38-4a33-815d-9cd35386736c" />

### Modules clés

- ALU : Opérations arithmétiques et logiques avec génération de flags  
- Shifter : Barrel shifter pour manipulation de données  
- RegisterFile : Banque de 16 registres × 32 bits  
- ControlUnit : Décodeur d'instructions et générateur de signaux  
- DataPath : Pipeline de traitement des données avec shifter intégré  

---

## 🚀 Getting Started

### Prérequis

- Xilinx Vivado ou ModelSim pour simulation  
- Connaissances de base en VHDL et architecture ARM  

### Démarrage rapide

```bash
git clone https://github.com/[your-username]/ARM-Processor-VHDL.git
cd ARM-Processor-VHDL
```
- Ouvrir dans Vivado/ModelSim  
- Importer tous les fichiers du dossier `src/`  
- Définir `ARM_Complete.vhd` comme module top  
- Lancer la simulation avec `tb_MiniProject.vhd` comme top simulation  
- Préparer votre fichier d'instructions (`Instructions.txt`)  
- Exécuter la simulation et consulter les résultats dans `miniproject_results.txt`  

---

## 📁 File Structure


ARM-Processor-VHDL/

├── src/

│ ├── core/ # Unités principales

│ ├── control/ # Logique de contrôle

│ ├── datapath/ # Composants du chemin de données

│ ├── utils/ # Modules utilitaires

│ └── top/ # Module de plus haut niveau

├── testbench/ # Bancs d'essai

├── docs/ # Documentation

├── instructions/ # Fichiers d'instructions exemples

└── results/ # Résultats des simulations

---

## 📝 Instructions Supported

### Traitement de données basique

ADD R1, R2, R3
SUB R1, R2, R3
AND R1, R2, R3
ORR R1, R2, R3
CMP R1, R2

### Avec shifter


ADD R1, R2, R3, LSL #2

SUB R4, R5, R6, ASR #3

### Opérations mémoire


LDR R1, [R2, #4]
STR R1, [R2, #4]

---

## 🧪 Testing

### Exécution des tests

Le testbench (`tb_MiniProject.vhd`) :

- Charge les instructions depuis `Instructions.txt`  
- Exécute 20 instructions  
- Enregistre les résultats ALU et données d'écriture  
- Sauvegarde les sorties dans `miniproject_results.txt`  

### Format des résultats

ALUResult_WriteData
00000005_00000003
0000000A_00000005


### Création de programmes de test

Les instructions doivent être au format binaire 32 bits, par exemple :

11100000100000000001000000000010 ; ADD R1, R0, R2
11100000010000010010000000000011 ; SUB R2, R1, R3


---

## 📖 Documentation

Documentation détaillée disponible dans `/docs` :

- Rapport complet du projet (en français)  
- Diagrammes d'architecture  
- Spécifications des modules  
- Tableaux de codage des instructions  

---

## Clés du projet

- Module shifter supportant 4 types de décalages : LSL, LSR, ASR, ROR  
- Instruction CMP : soustraction sans écriture dans un registre, mais mise à jour des flags  
- Exécution conditionnelle complète avec 14 conditions ARM (EQ, NE, GT, LT, etc.)  
- Module CondCheck évalue les flags pour les conditions  

---

## 🤝 Contributing

Les contributions sont les bienvenues !  
Merci de faire des Pull Requests.  

### Roadmap de développement

- Pipeline d'instructions  
- Prédiction de branchements  
- Instructions ARM supplémentaires (MUL, DIV)  
- Mémoire cache  
- Gestion des interruptions  

---

## 📄 License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour les détails.

---

## 👤 Author

Eddy Dago  
GitHub: [Eduqtr](https://github.com/Eduqtr)  
Email: [Eddy.dago@uqtr.ca](mailto:eddy.dago@uqtr.ca)

---

## 🙏 Acknowledgments

Cours : Architecture des ordinateurs et calcul accéléré  
Institution : [Université du Québec à Trois-Rivères]  
Date : 20 Novembre 2025  

> Note : Ce projet est éducatif pour l'apprentissage de l'architecture ARM et du design VHDL. Il implémente un sous-ensemble simplifié des instructions ARM.

---

## 📊 Project Stats

- Plus de 2000 lignes de code VHDL  
- Plus de 20 composants/modules  
- 7 instructions de base + décalages  
- Couverture des tests : fonctionnalité cœur validée  

⭐ N'hésitez pas à mettre un étoile ce dépôt si vous le trouvez utile !
