import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:medpharm/Screens/pdfclientview.dart';

class FiliereGridScreen extends StatefulWidget {
  final Semestre semestre;
  const FiliereGridScreen({super.key, required this.semestre});

  @override
  State<FiliereGridScreen> createState() => _FiliereGridScreenState();
}

class _FiliereGridScreenState extends State<FiliereGridScreen> {
  List<Filiere> _filieres = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Modern color scheme - consistent blue theme
  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _secondaryColor = const Color(0xFF42A5F5);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _accentColor = const Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _loadFilieres();
  }

  Future<void> _loadFilieres() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final supabaseManagement = SupabaseManagement();
      final filieres =
          await supabaseManagement.getClasseFilieres(widget.semestre.id);
      setState(() {
        _filieres = filieres;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erreur lors du chargement des modules';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: _primaryColor, // Force la couleur de fond
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _secondaryColor],
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Modules Disponibles',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              widget.semestre.nomSemetre,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.library_books_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            onPressed: _loadFilieres,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_hasError) {
      return _buildErrorView();
    }

    if (_filieres.isEmpty) {
      return _buildEmptyView();
    }

    return _buildFilieresGrid();
  }

  Widget _buildLoadingView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                strokeWidth: 3,
              ),
            ),
            const Gap(24),
            Text(
              'Chargement des modules...',
              style: TextStyle(
                color: _textColor.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilieresGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const Gap(20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filieres.length,
            itemBuilder: (context, index) {
              final filiere = _filieres[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildFiliereCard(filiere, index),
              );
            },
          ),
          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.library_books_outlined,
              color: _primaryColor,
              size: 24,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modules de Formation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const Gap(4),
                Text(
                  '${_filieres.length} module${_filieres.length > 1 ? 's' : ''} disponible${_filieres.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiliereCard(Filiere filiere, int index) {
    final colors = [
      _primaryColor,
      _secondaryColor,
      _accentColor,
      const Color(0xFF2196F3),
      const Color(0xFF1565C0),
      const Color(0xFF0D47A1),
    ];
    final cardColor = colors[index % colors.length];

    return Container(
      height: 320, // Fixed height for proper layout
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfGridScreen(
                  filiereId: filiere.id,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Class name at the top
                // Container(
                //   width: double.infinity,
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: cardColor.withValues(alpha: 0.1),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     filiere.nomClasse,
                //     style: TextStyle(
                //       color: cardColor,
                //       fontSize: 11,
                //       fontWeight: FontWeight.w600,
                //     ),
                //     textAlign: TextAlign.center,
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                // const Gap(12),
                // Full image display
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: filiere.image,
                        fit: BoxFit
                            .contain, // Changed to contain to show full image
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(cardColor),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: cardColor.withValues(alpha: 0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                color: cardColor,
                                size: 40,
                              ),
                              const Gap(8),
                              Text(
                                'Image\nindisponible',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: cardColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // Module name
                Text(
                  filiere.nom,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(12),
                // Action button
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: cardColor,
                        size: 14,
                      ),
                      const Gap(6),
                      Text(
                        'Voir PDF',
                        style: TextStyle(
                          color: cardColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: _primaryColor,
              ),
            ),
            const Gap(32),
            Text(
              _errorMessage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              "Veuillez vérifier votre connexion\net réessayer",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const Gap(32),
            ElevatedButton.icon(
              onPressed: _loadFilieres,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Réessayer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.library_books_outlined,
                size: 64,
                color: _primaryColor,
              ),
            ),
            const Gap(32),
            Text(
              'Aucun module trouvé',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              "Aucun module n'est disponible\npour cette classe",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const Gap(32),
            ElevatedButton.icon(
              onPressed: _loadFilieres,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Actualiser",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
