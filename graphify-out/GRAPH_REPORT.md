# Graph Report - lib  (2026-07-11)

## Corpus Check
- 93 files · ~74,575 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1872 nodes · 2518 edges · 92 communities (87 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Vente Maetiels Module
- Pdfview Module
- Hba Module
- Main Module
- Provider
- Carlendriergrosesse Module
- Ventes Cover Module
- Manage Pdf Module
- Downloaded Pdfs Screen
- App Theme
- Version Check Service
- Manage Materiels Module
- Filieresviewer Module
- Pdfclientview Module
- Supabasemanagement Module
- Add Classe Screen
- Auth Controller
- Manage Filiere Module
- Pharmacie Module
- Manage Publication Module
- Home Module
- Classviewr Module
- Paracetamol Module
- Dashboard Module
- Imc Module
- Amo Module
- Pdf Download Service
- Manage Semestre Module
- Artemether Module
- Glascow Module
- Quinine Module
- Semestre Screen
- Wells Score Module
- Cours Provider
- Auth Layout
- Faculter Screen Page Module
- Artesunate Module
- Medicamentscreen Module
- Search Screen Medicaments Module
- Appgar Module
- Search Screen
- Auth Repository
- Search Screen Amo Amo Module
- Login Screen
- Medicament Repository
- Amo View Module
- Med Module
- Search Screen Amo Dci Module
- Supabase Auth Repository
- Add Classe Screen
- Search Screen Theurapetique Module
- Search Screen Med Classe Module
- Pdfclientview Module
- Medicamentdetailscreen Module
- Calcule Screen
- Pharmacie Repository
- Prescription Module
- Transitions Module
- Local Json Datasource Module
- Materiel Provider
- Downloaded Pdf Module
- Second Calcul Module
- Search Screen Prescription Module
- Register Screen
- Update Password Screen
- Info Module
- Home Module
- Medicament Provider
- Forgot Password Screen
- Pharmacie Provider
- Pdf Module
- Malmart Module
- Categorie Medicament View Module
- Auth Gate
- Manage Semestre Module
- Attributes Card Module
- Az Navigation Module
- Permission Service
- Classemodel Module
- Filiere Module
- Faculter Module
- Amoattributescard Module
- Providers Module
- Pharmacie Module
- Prescription Module
- Vente Maetiels Module
- Utils Module
- Auth Repository
- Imc Module
- Pdfclientview Module
- Community 90 Module

## God Nodes (most connected - your core abstractions)
1. `AuthController` - 23 edges
2. `PremiumPageRoute` - 12 edges
3. `MedicamentProvider` - 11 edges
4. `PharmacieProvider` - 11 edges
5. `CoursProvider` - 9 edges
6. `MaterielProvider` - 9 edges
7. `_HomeState` - 6 edges
8. `_BooksHomePageState` - 5 edges
9. `SupabaseManagement` - 4 edges
10. `Semestre` - 4 edges

## Surprising Connections (you probably didn't know these)
- `_submit` --references--> `AuthController`  [EXTRACTED]
  Screens/auth/forgot_password_screen.dart → auth/auth_controller.dart
- `build` --references--> `AuthController`  [EXTRACTED]
  Screens/auth/forgot_password_screen.dart → auth/auth_controller.dart
- `build` --references--> `AuthController`  [EXTRACTED]
  Screens/auth/register_screen.dart → auth/auth_controller.dart
- `_submit` --references--> `AuthController`  [EXTRACTED]
  Screens/auth/update_password_screen.dart → auth/auth_controller.dart
- `build` --references--> `AuthController`  [EXTRACTED]
  Screens/auth/update_password_screen.dart → auth/auth_controller.dart

## Import Cycles
- None detected.

## Communities (92 total, 5 thin omitted)

### Community 0 - "Vente Maetiels Module"
Cohesion: 0.04
Nodes (53): Animation, AnimationController, package:medpharm/Screens/ventesCover.dart, _accentColor, _backgroundColor, _buildAdvancedFilters, _buildCategoryCard, _buildCategorySection (+45 more)

### Community 1 - "Pdfview Module"
Cohesion: 0.04
Nodes (46): Completer, dart:async, package:flutter_pdfview/flutter_pdfview.dart, package:medpharm/DatabaseManagement/pdf_download_service.dart, package:syncfusion_flutter_core/theme.dart, package:syncfusion_flutter_pdfviewer/pdfviewer.dart, PDFViewController, PdfViewerController (+38 more)

### Community 2 - "Hba Module"
Cohesion: 0.04
Nodes (45): double?, _backgroundColor, build, _buildActionButtons, _buildDefinitionCard, _buildFormulaCard, _buildFormulaItem, _buildInputCard (+37 more)

### Community 3 - "Main Module"
Cohesion: 0.04
Nodes (43): android, firebase_options.dart, DefaultFirebaseOptions, ios, macos, web, windows, analytics (+35 more)

### Community 4 - "Provider"
Cohesion: 0.05
Nodes (42): addClasses, addFiliere, addMateriel, addPDF, addPublication, addSemestre, changeFavoris, changeFavorisPharmacie (+34 more)

### Community 5 - "Carlendriergrosesse Module"
Cohesion: 0.05
Nodes (42): FocusNode, _backgroundColor, build, _buildCalculateButton, _buildDateInputCard, _buildEchographyCard, _buildErrorCard, _buildHeader (+34 more)

### Community 6 - "Ventes Cover Module"
Cohesion: 0.05
Nodes (40): int?, description, fromSnapshot, id, image, Materiel, price, telephone (+32 more)

### Community 7 - "Manage Pdf Module"
Cohesion: 0.05
Nodes (41): package:file_picker/file_picker.dart, required String objectPath,
  String, _addPdf, AddPdfDialog, _AddPdfDialogState, cacheControl, createState, _descriptionController (+33 more)

### Community 8 - "Downloaded Pdfs Screen"
Cohesion: 0.05
Nodes (40): ../DatabaseManagement/pdf_download_service.dart, package:intl/intl.dart, pdfview.dart, _backgroundColor, build, _buildActionButton, _buildContent, _buildDownloadStats (+32 more)

### Community 9 - "App Theme"
Cohesion: 0.05
Nodes (40): static const double, static const TextStyle, static List, AppColors, AppDurations, AppRadius, AppShadows, AppSpacing (+32 more)

### Community 10 - "Version Check Service"
Cohesion: 0.05
Nodes (37): Future, package:medpharm/auth/auth_gate.dart, package:medpharm/Screens/force_update_screen.dart, package:medpharm/Utils/version_check_service.dart, package:package_info_plus/package_info_plus.dart, package:url_launcher/url_launcher.dart, build, config (+29 more)

### Community 11 - "Manage Materiels Module"
Cohesion: 0.06
Nodes (35): _addMateriel, build, _buildEmptySearchState, _buildSearchBar, createState, _deleteMateriel, _descriptionController, dispose (+27 more)

### Community 12 - "Filieresviewer Module"
Cohesion: 0.06
Nodes (33): fromJson, id, image, nomClasse, nomSemetre, Semestre, toJson, package:medpharm/Models/filiere.dart (+25 more)

### Community 13 - "Pdfclientview Module"
Cohesion: 0.06
Nodes (34): package:medpharm/Screens/pdfview.dart, _accentColor, _backgroundColor, build, _buildContent, _buildDownloadOptionCard, _buildEmptyView, _buildErrorView (+26 more)

### Community 14 - "Supabasemanagement Module"
Cohesion: 0.06
Nodes (33): addFiliere, addSemestre, _CachedSignedUrl, _deleteFileFromStorage, deleteSemestre, expiresAt, _extractStoragePath, faculter (+25 more)

### Community 15 - "Add Classe Screen"
Cohesion: 0.06
Nodes (32): package:medpharm/Screens/ManageSemestre.dart, _addClass, categoryId, categoryName, categoryTitle, classe, _classeController, _classes (+24 more)

### Community 16 - "Auth Controller"
Cohesion: 0.07
Nodes (29): AuthOperationResult, AuthStatus, code, dispose, failure, _friendlyAuthError, _handleAuthUpdate, initialize (+21 more)

### Community 17 - "Manage Filiere Module"
Cohesion: 0.07
Nodes (29): package:medpharm/Screens/ManagePDF.dart, _addFiliere, createState, dispose, EditFiliereDialog, _EditFiliereDialogState, filiere, _filiereController (+21 more)

### Community 18 - "Pharmacie Module"
Cohesion: 0.07
Nodes (28): Map, package:medpharm/Screens/searchScreen.dart, package:medpharm/Screens/searchScreenAmoAmo.dart, package:medpharm/Screens/searchScreenAmoDCI.dart, _backgroundColor, build, _buildDefinitionCard, _buildEmptyState (+20 more)

### Community 19 - "Manage Publication Module"
Cohesion: 0.08
Nodes (27): File?, package:image_picker/image_picker.dart, _addPublication, build, createState, _deletePublication, _editPublication, _formKey (+19 more)

### Community 20 - "Home Module"
Cohesion: 0.07
Nodes (27): package:carousel_slider_plus/carousel_slider_plus.dart, package:connectivity_plus/connectivity_plus.dart, package:medpharm/Screens/calculeScreen.dart, package:medpharm/Screens/carlendriergrosesse.dart, package:medpharm/Screens/faculterScreenPage.dart, package:medpharm/Screens/medicamentscreen.dart, package:medpharm/Screens/pharmacie.dart, package:medpharm/Screens/venteMaetiels.dart (+19 more)

### Community 21 - "Classviewr Module"
Cohesion: 0.08
Nodes (26): package:medpharm/Models/classemodel.dart, package:medpharm/Screens/SemestreScreen.dart, _accentColor, _backgroundColor, build, _buildClassesGrid, _buildContent, _buildEmptyView (+18 more)

### Community 22 - "Paracetamol Module"
Cohesion: 0.08
Nodes (26): _backgroundColor, build, _buildAgeCard, _buildAgeOption, _buildAgeOptions, _buildInputCard, _buildReferenceCard, _buildReferenceItem (+18 more)

### Community 23 - "Dashboard Module"
Cohesion: 0.08
Nodes (25): package:medpharm/Screens/AddClasseScreen.dart, package:medpharm/Screens/downloaded_pdfs_screen.dart, package:medpharm/Screens/home.dart, package:medpharm/Screens/manageMateriels.dart, package:medpharm/Screens/managePublication.dart, package:medpharm/Utils/admin_gate.dart, package:medpharm/Utils/app_review_service.dart, _backgroundColor (+17 more)

### Community 24 - "Imc Module"
Cohesion: 0.08
Nodes (25): _backgroundColor, build, _buildActionButtons, _buildDefinitionCard, _buildFormulaCard, _buildInputCard, _buildInputField, _buildResultCard (+17 more)

### Community 25 - "Amo Module"
Cohesion: 0.08
Nodes (24): dart:math, int get, characters, ClassMed, classtherapique, clname, dci, favoris (+16 more)

### Community 26 - "Pdf Download Service"
Cohesion: 0.08
Nodes (24): dart:typed_data, _buildPdfFileName, clearAllDownloads, _database, deleteDownloadedPdf, downloadPdf, _downloadSimpleToInternal, _downloadToExternal (+16 more)

### Community 27 - "Manage Semestre Module"
Cohesion: 0.08
Nodes (24): package:medpharm/Screens/ManageFiliere.dart, classeName, createState, _deleteSemestre, dispose, _imageFile, _imageUrl, isLoading (+16 more)

### Community 28 - "Artemether Module"
Cohesion: 0.08
Nodes (24): ArtemetherScreen, _ArtemetherScreenState, _backgroundColor, build, _buildDoseItem, _buildInputCard, _buildReferenceCard, _buildReferenceItem (+16 more)

### Community 29 - "Glascow Module"
Cohesion: 0.08
Nodes (24): _backgroundColor, build, _buildDefinitionCard, _buildEyeOpeningCard, buildEyeOpeningOptions, _buildMotorResponseCard, buildMotorResponseOptions, _buildRadioOption (+16 more)

### Community 30 - "Quinine Module"
Cohesion: 0.08
Nodes (24): _backgroundColor, build, _buildDoseItem, _buildInputCard, _buildReferenceCard, _buildReferenceItem, _buildResultCard, _calculatePoids (+16 more)

### Community 31 - "Semestre Screen"
Cohesion: 0.08
Nodes (23): package:medpharm/Screens/filieresviewer.dart, _accentColor, _backgroundColor, build, _buildContent, _buildEmptyView, _buildErrorView, _buildLoadingView (+15 more)

### Community 32 - "Wells Score Module"
Cohesion: 0.09
Nodes (23): _backgroundColor, build, _buildCriteriaCard, _buildCriteriaCheckbox, _buildDefinitionCard, _buildLegendCard, _buildResultCard, calculateTotalScore (+15 more)

### Community 33 - "Cours Provider"
Cohesion: 0.09
Nodes (22): addClasses, addFiliere, addPDF, addSemestre, classes, deleteSemestre, faculter, filiere (+14 more)

### Community 34 - "Auth Layout"
Cohesion: 0.09
Nodes (22): FormFieldValidator, IconData?, build, child, color, controller, createState, icon (+14 more)

### Community 35 - "Faculter Screen Page Module"
Cohesion: 0.09
Nodes (22): package:cached_network_image/cached_network_image.dart, package:medpharm/Models/faculter.dart, package:medpharm/Screens/classviewr.dart, _accentColor, _backgroundColor, build, _buildEmptyView, _buildErrorView (+14 more)

### Community 36 - "Artesunate Module"
Cohesion: 0.09
Nodes (22): ArtesunateScreen, _ArtesunateScreenState, _backgroundColor, build, _buildInputCard, _buildReferenceCard, _buildReferenceItem, _buildResultCard (+14 more)

### Community 37 - "Medicamentscreen Module"
Cohesion: 0.10
Nodes (21): package:medpharm/Screens/searchScreenMedicaments.dart, _backgroundColor, build, _buildEmptyState, _buildFavoritesTab, _buildHeader, _buildMedCard, _buildMedicationsTab (+13 more)

### Community 38 - "Search Screen Medicaments Module"
Cohesion: 0.10
Nodes (20): package:medpharm/Widgets/az_navigation.dart, _backgroundColor, _buildEmptyState, _buildMedCard, _buildSearchBar, _cardColor, createState, dispose (+12 more)

### Community 39 - "Appgar Module"
Cohesion: 0.10
Nodes (20): AppgarHomePage, _AppgarHomePageState, _backgroundColor, build, _buildCriteriaCard, _buildDefinitionCard, _buildRadioOption, _buildResultCard (+12 more)

### Community 40 - "Search Screen"
Cohesion: 0.10
Nodes (20): _backgroundColor, build, _buildEmptyState, _buildSearchHeader, _cardColor, createState, dispose, filtered (+12 more)

### Community 41 - "Auth Repository"
Cohesion: 0.10
Nodes (19): AppUser, AuthEventType, authStateChanges, AuthStateUpdate, currentUser, displayName, email, emailConfirmed (+11 more)

### Community 42 - "Search Screen Amo Amo Module"
Cohesion: 0.11
Nodes (19): package:medpharm/Screens/AmoView.dart, _backgroundColor, build, _buildEmptyState, _buildSearchHeader, _buildSearchResults, _cardColor, createState (+11 more)

### Community 43 - "Login Screen"
Cohesion: 0.13
Nodes (18): AuthController, package:flutter/services.dart, package:medpharm/Screens/auth/forgot_password_screen.dart, package:medpharm/Screens/auth/register_screen.dart, build, createState, dispose, _emailController (+10 more)

### Community 44 - "Medicament Repository"
Cohesion: 0.11
Nodes (18): assetPath, _datasource, _dciKey, _favoriteKey, getAll, getFavorites, localFileName, LocalMedicamentRepository (+10 more)

### Community 45 - "Amo View Module"
Cohesion: 0.11
Nodes (18): Amo, package:medpharm/DatabaseManagement/providers/pharmacie_provider.dart, AmoDetailsScreen, _AmoDetailsScreenState, _backgroundColor, build, _buildDefinitionCard2, _buildDetailCard (+10 more)

### Community 46 - "Med Module"
Cohesion: 0.11
Nodes (18): activiteantibacterienne, classtherapique, contreindication, dci, effetindesirable, fromSanpshot, grosseseallaitement, indication (+10 more)

### Community 47 - "Search Screen Amo Dci Module"
Cohesion: 0.11
Nodes (18): _backgroundColor, build, _buildEmptyState, _buildSearchHeader, _buildSearchResults, _cardColor, createState, dispose (+10 more)

### Community 48 - "Supabase Auth Repository"
Cohesion: 0.11
Nodes (17): AppUser? get, authStateChanges, _client, currentUser, _mapEvent, _mapUser, redirectUrl, resendConfirmation (+9 more)

### Community 49 - "Add Classe Screen"
Cohesion: 0.16
Nodes (18): AddClasseDialog, _AddClasseDialogState, CategorySelectionScreen, _CategorySelectionScreenState, EditClasseDialog, _EditClasseDialogState, ManageClasse, _ManageClasseState (+10 more)

### Community 50 - "Search Screen Theurapetique Module"
Cohesion: 0.12
Nodes (17): _backgroundColor, build, _buildClassCard, _buildEmptyState, _buildSearchBar, createState, filtered, hintText (+9 more)

### Community 51 - "Search Screen Med Classe Module"
Cohesion: 0.12
Nodes (16): class, _backgroundColor, _buildEmptyState, _buildMedCard, _buildSearchBar, createState, filtered, hintText (+8 more)

### Community 52 - "Pdfclientview Module"
Cohesion: 0.12
Nodes (17): MaterialPageRoute, build, _buildClassCard, build, _buildPdfCard, _buildFacultyCard, _buildFiliereCard, build (+9 more)

### Community 53 - "Medicamentdetailscreen Module"
Cohesion: 0.12
Nodes (16): package:medpharm/DatabaseManagement/providers/medicament_provider.dart, _backgroundColor, build, _buildAvertissementsCard, _buildDetailCard, _buildDetailsSection, _cardColor, createState (+8 more)

### Community 54 - "Calcule Screen"
Cohesion: 0.12
Nodes (16): package:medpharm/Screens/Appgar.dart, package:medpharm/Screens/glascow.dart, package:medpharm/Screens/hba.dart, package:medpharm/Screens/IMC.dart, package:medpharm/Screens/secondCalcul.dart, package:medpharm/Screens/wells_score.dart, _backgroundColor, build (+8 more)

### Community 55 - "Pharmacie Repository"
Cohesion: 0.13
Nodes (15): _datasource, getAll, getFavorites, LocalPharmacieRepository, _normalize, pharmacieAssetPath, pharmacieLocalFileName, PharmacieRepository (+7 more)

### Community 56 - "Prescription Module"
Cohesion: 0.13
Nodes (15): package:medpharm/Screens/searchScreen%20prescription.dart, build, classth, createState, filteredMedNameList, headerStyle, initState, isLoading (+7 more)

### Community 57 - "Transitions Module"
Cohesion: 0.13
Nodes (15): PageRouteBuilder, PageTransitionsBuilder, _buildGrid, _showAlreadyDownloadedDialog, _showAlreadyDownloadedDialog, _buildPharmacyCard, _buildPharmacyCard, _buildPharmacyCard (+7 more)

### Community 58 - "Local Json Datasource Module"
Cohesion: 0.13
Nodes (14): dart:convert, ensureAssetCopied, _fileNameFromAssetPath, getLocalFile, localFileExists, LocalJsonDatasource, readJsonList, readJsonMap (+6 more)

### Community 59 - "Materiel Provider"
Cohesion: 0.14
Nodes (13): addMateriel, addPublication, deletePublication, getMateriel, getPublication, materiels, pub, removeMateriel (+5 more)

### Community 60 - "Downloaded Pdf Module"
Cohesion: 0.14
Nodes (13): DateTime, description, downloadDate, DownloadedPdf, fileSize, fromMap, hasLogo, id (+5 more)

### Community 61 - "Second Calcul Module"
Cohesion: 0.15
Nodes (13): package:medpharm/Screens/artemether.dart, package:medpharm/Screens/artesunate.dart, package:medpharm/Screens/paracetamol.dart, package:medpharm/Screens/Quinine.dart, _backgroundColor, build, _buildOptionCard, _cardColor (+5 more)

### Community 62 - "Search Screen Prescription Module"
Cohesion: 0.17
Nodes (12): package:medpharm/Models/prescription.dart, build, createState, filtered, hintText, initState, listes, loadPdfFileNames (+4 more)

### Community 63 - "Register Screen"
Cohesion: 0.17
Nodes (12): build, _confirmationController, createState, dispose, _emailController, _formKey, _nameController, _passwordController (+4 more)

### Community 64 - "Update Password Screen"
Cohesion: 0.18
Nodes (11): FormState, build, _confirmationController, createState, dispose, _formKey, _passwordController, _submit (+3 more)

### Community 65 - "Info Module"
Cohesion: 0.18
Nodes (11): MyApp, AuthLayout, AuthPrimaryButton, _BrandMark, _DecorativeCircle, build, main, MyApp (+3 more)

### Community 66 - "Home Module"
Cohesion: 0.22
Nodes (11): ChangeNotifier, MyProvider, MaterielProvider, MedicamentProvider, Home, _HomeState, _initializeData, _refreshPublications (+3 more)

### Community 67 - "Medicament Provider"
Cohesion: 0.18
Nodes (10): changeFavoris, favorisMedicaments, _isMedicamentLoaded, loadMedicamentData, medicament, _medicamentRepository, reloadData, List (+2 more)

### Community 68 - "Forgot Password Screen"
Cohesion: 0.20
Nodes (10): package:medpharm/Screens/auth/auth_layout.dart, build, createState, dispose, _emailController, ForgotPasswordScreen, _ForgotPasswordScreenState, _formKey (+2 more)

### Community 69 - "Pharmacie Provider"
Cohesion: 0.20
Nodes (9): changeFavorisPharmacie, favorisPharmacies, _isPharmacieLoaded, loadPharmacieData, _pharmacieRepository, pharmacies, reloadData, package:medpharm/data/repositories/pharmacie_repository.dart (+1 more)

### Community 70 - "Pdf Module"
Cohesion: 0.20
Nodes (9): description, fromSnapshot, id, idFiliere, image, nom, Pdf, toMap (+1 more)

### Community 71 - "Malmart Module"
Cohesion: 0.20
Nodes (9): package:gap/gap.dart, _backgroundColor, build, _buildClassRow, _buildClassRowMalllampati, _cardColor, MallampatiScreen, _primaryColor (+1 more)

### Community 72 - "Categorie Medicament View Module"
Cohesion: 0.22
Nodes (9): package:medpharm/Screens/medicamentdetailscreen.dart, package:medpharm/Utils/transitions.dart, build, CategorieMedicament, _CategorieMedicamentState, createState, images, meds (+1 more)

### Community 73 - "Auth Gate"
Cohesion: 0.22
Nodes (8): AuthGate, _AuthSplash, build, package:medpharm/auth/auth_controller.dart, package:medpharm/Screens/auth/login_screen.dart, package:medpharm/Screens/auth/update_password_screen.dart, package:medpharm/Screens/dashboard.dart, package:provider/provider.dart

### Community 74 - "Manage Semestre Module"
Cohesion: 0.22
Nodes (9): CoursProvider, AddSemestreDialog, _AddSemestreDialogState, initState, ManageSemestre, _ManageSemestreState, initState, SemestreScreen (+1 more)

### Community 75 - "Attributes Card Module"
Cohesion: 0.22
Nodes (8): String?, alias, AttributesCard, build, couleurs, description, image, title

### Community 76 - "Az Navigation Module"
Cohesion: 0.25
Nodes (7): Color?, Set, activeColor, availableLetters, build, inactiveColor, itemSize

### Community 77 - "Permission Service"
Cohesion: 0.25
Nodes (7): dart:io, package:app_settings/app_settings.dart, package:permission_handler/permission_handler.dart, _getStoragePermissionStatus, PermissionService, requestStoragePermission, _showPermissionDeniedDialog

### Community 78 - "Classemodel Module"
Cohesion: 0.25
Nodes (7): Classe, description, fromSnapshot, idfaculter, image, nom, toMap

### Community 79 - "Filiere Module"
Cohesion: 0.25
Nodes (7): Filiere, fromSnapshot, id, image, nom, semestreId, toMap

### Community 80 - "Faculter Module"
Cohesion: 0.33
Nodes (5): Fac, fromSnapshot, id, image, nom

### Community 81 - "Amoattributescard Module"
Cohesion: 0.33
Nodes (5): package:flutter/material.dart, AmoCard, build, subtitle, title

### Community 82 - "Providers Module"
Cohesion: 0.40
Nodes (4): cours_provider.dart, materiel_provider.dart, medicament_provider.dart, pharmacie_provider.dart

### Community 83 - "Pharmacie Module"
Cohesion: 0.40
Nodes (5): PharmacieProvider, _buildModernAppBar, _loadData, PharmacieScreen, _PharmacieScreenState

### Community 84 - "Prescription Module"
Cohesion: 0.50
Nodes (3): name, Prescription, sortName

### Community 85 - "Vente Maetiels Module"
Cohesion: 0.67
Nodes (3): BooksHomePage, _BooksHomePageState, TickerProviderStateMixin

## Knowledge Gaps
- **1390 isolated node(s):** `PdfDownloadService`, `_database`, `_tableName`, `_sanitizeFileName`, `_buildPdfFileName` (+1385 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Pdf` connect `Pdf Module` to `Pdfview Module`, `Manage Pdf Module`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `AuthController` connect `Login Screen` to `Update Password Screen`, `Home Module`, `Forgot Password Screen`, `Auth Controller`, `Dashboard Module`, `Register Screen`?**
  _High betweenness centrality (0.008) - this node is a cross-community bridge._
- **Why does `Materiel` connect `Ventes Cover Module` to `Manage Materiels Module`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **What connects `PdfDownloadService`, `_database`, `_tableName` to the rest of the system?**
  _1390 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Vente Maetiels Module` be split into smaller, more focused modules?**
  _Cohesion score 0.037037037037037035 - nodes in this community are weakly interconnected._
- **Should `Pdfview Module` be split into smaller, more focused modules?**
  _Cohesion score 0.04343971631205674 - nodes in this community are weakly interconnected._
- **Should `Hba Module` be split into smaller, more focused modules?**
  _Cohesion score 0.04440333024976873 - nodes in this community are weakly interconnected._