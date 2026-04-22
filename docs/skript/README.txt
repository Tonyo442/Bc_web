CZ

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Davkovy skript pro hromadnou filtraci LAZ/LAS souboru hierarchickou iteraci CSF filtru        ::
::                                  Autor: Antonin SKACEL                                        ::
:: priloha bp - ZPRACOVANI A PREZENTACE LASEROVYCH DATA PRO POTREBY MONITORINGU KOMARICH LIHNIST ::
::                  postup  prevzat z CloudCompare dokumentace a online tutorialu                ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Skript vyžaduje manuální nastavení dvou parametrů, a to:

CC_PATH="zde nastavte cestu k CloudCompare.exe na vašem zařízení"
INPUT_DIR="zde nastavte cestu k adresáři s bodovými mračny ke zpracování - pro limitaci náročnosti na HW výkon je vhodné mít oblast rozdělenou do dlaždic"

POPIS SKRIPTU: 
Skript cyklu FOR zpracovává všechny LAZ soubory v adresáři pomocí CSF filtru, a to ve čtyřech krocích, s proměnlivými hodnotami parametrů Resolution a Classification Treshold.
Výsledkem je adresář se třemi bodovými mračny pro každý vstupní LAZ. Mračno s koncovkou _Ground obsahuje body klasifikované jako terén, mračno s koncovkou _OffGround obsahuje sloučené offground body prvních tří průchodů CSF. Třetí mračno, s koncovkou _04_kontrola obsahuje offground body posledního průchodu CSF k manuální kontrole.

EN
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Batch script for filtering of LAZ files using hierarchical iteration of the CSF filter                           ::
::                                  Author: Antonin SKACEL                                                          ::
:: Appendix of bachelor thesis - Processing and Visualization of LiDAR Data for Monitoring Mosquito Breeding sites  ::
::                 procedure is based on CloudCompare documentation and availible online tutorials                  ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

The script requires manual configuration of two parameters, namely:

CC_PATH="set the path to CloudCompare.exe on your device here"
INPUT_DIR="set the path to the directory containing the point clouds to be processed here - to limit the demand on hardware performance, it is advisable to have the area divided into tiles"


SCRIPT DESCRIPTION: 
The FOR loop script processes all LAZ files in the directory using a CSF filter in four steps, with variable values for the Resolution and Classification Threshold parameters.
The result is a directory containing three point clouds for each input LAZ file. The point cloud with the suffix _Ground contains points classified as terrain; the point cloud with the suffix _OffGround contains merged off-ground points from the first three CSF passes. The third point cloud, with the suffix _04_kontrola, contains off-ground points from the last CSF pass for manual verification.

