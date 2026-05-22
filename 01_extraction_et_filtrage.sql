-- PROJET : Analyse de la couverture hospitalière en France
-- OBJECTIF : Extraction et pré-filtrage des données d'établissements
-- AUTEUR : Data Analyst Portfolio

-- 1. Création de la table de staging pour accueillir les données brutes de santé
CREATE TABLE staging_healthcare_facilities (
    facility_id VARCHAR(50) PRIMARY KEY,
    facility_name VARCHAR(255),
    facility_category_code VARCHAR(10),
    facility_category_label VARCHAR(255),
    department_code VARCHAR(5),
    department_name VARCHAR(100),
    region_name VARCHAR(100),
    active_beds_count INT
);

-- 2. Requête d'analyse Globale (Vision Brute : inclut tout le médico-social)
-- Cette requête simule l'extraction brute avant nettoyage de biais
SELECT 
    department_code,
    department_name,
    COUNT(facility_id) AS total_facilities,
    SUM(active_beds_count) AS total_beds
FROM 
    staging_healthcare_facilities
GROUP BY 
    department_code, 
    department_name
ORDER BY 
    department_code;

-- 3. Requête d'analyse Ciblée (Vision "Vrais Soins" - Filtrée au niveau de la base)
-- C'est ici qu'on montre au recruteur qu'on sait filtrer directement en SQL !
SELECT 
    department_code,
    department_name,
    COUNT(facility_id) AS filtered_facilities_count,
    SUM(active_beds_count) AS filtered_beds_count
FROM 
    staging_healthcare_facilities
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