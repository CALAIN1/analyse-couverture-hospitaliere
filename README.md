#  Détection et Correction des Biais Statistiques : Couverture Hospitalière en France

![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=Power+BI&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-4169E1?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-20B2AA?style=for-the-badge)

##  Présentation du Projet
Ce projet décisionnel vise à évaluer et cartographier la densité réelle des infrastructures de santé par département pour 100 000 habitants en France. 

**La problématique majeure traitée :** L'analyse des données brutes (Fichier National FINESS) intègre indistinctement des structures médico-sociales (EHPAD, maisons de retraite) qui ne dispensent pas de soins de médecine active (urgences, chirurgie, réanimation). Cela crée une **illusion de couverture complète** et masque les véritables déserts médicaux.

Ce projet met en place un pipeline de données complet pour isoler la médecine active et révéler la réalité du terrain.

---

##  Architecture Technique & Pipeline Data

Le projet est modélisé de bout en bout (End-to-End) selon l'architecture suivante :

1. **Extraction & Structuration (SQL) :** Modélisation d'une table de staging et requêtage ciblé pour filtrer les catégories d'établissements hors-sujet à la racine de la base de données.
2. **Préparation & Nettoyage (Power Query) :** Gestion des valeurs manquantes, normalisation des codes départements et exclusion des hôpitaux locaux et des territoires d'Outre-mer pour garantir la cohérence statistique.
3. **Modélisation des Données (Power BI) :** Création d'une relation en étoile entre la table de faits (`Fact_Finess_Bruit`) et la table de référence démographique (`Ref_Population_Departements`).
4. **Calculs Métier Avancés (DAX) :** Développement d'une mesure dynamique de **Taux d'Accessibilité** standardisée à l'échelle nationale pour 100 000 habitants.

---

##  Extrait du Script SQL de Nettoyage

```sql
-- Requête d'analyse Ciblée (Vision "Vrais Soins" - Filtrée au niveau de la base)
SELECT 
    department_code,
    department_name,
    COUNT(facility_id) AS filtered_facilities_count,
    SUM(active_beds_count) AS filtered_beds_count
FROM 
    healthcare_data_staging
WHERE 
    facility_category_label IN (
        'Centre Hospitalier (CH)',
        'Centre Hospitalier Régional (CHR)',
        'Centre de Lutte Contre le Cancer'
    )
    AND active_beds_count > 0
GROUP BY 
    department_code,
    department_name
ORDER BY 
    filtered_facilities_count DESC;