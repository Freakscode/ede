import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/widgets/navigation_buttons_widget.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/widgets/progress_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/info_note_widget.dart';
import '../widgets/image_upload_area_widget.dart';
import '../widgets/save_progress_button.dart';

class EvidenceScreen extends StatefulWidget {
  const EvidenceScreen({super.key});

  @override
  State<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  final List<String> _imagePaths = [];
  final int _maxImages = 3;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final subtitle = state.selectedClassification == 'amenaza'
                      ? 'Calificación de la Amenaza'
                      : 'Calificación de la Vulnerabilidad';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 27),
                    title: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF706F6F),
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 28 / 18,
                      ),
                    ),
                    trailing: SvgPicture.asset(
                      AppIcons.info,
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                        DAGRDColors.amarDAGRD,
                        BlendMode.srcIn,
                      ),
                    ),
                  );
                },
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Evidencia fotográfica',
                          style: const TextStyle(
                            color: DAGRDColors.negroDAGRD,
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            height: 18 / 16,
                          ),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        SvgPicture.asset(
                          AppIcons.info,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            DAGRDColors.negroDAGRD,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const InfoNoteWidget(),
                    const SizedBox(height: 14),
                    ImageUploadAreaWidget(
                      onSelectFromGallery: _selectFromGallery,
                      onTakePhoto: _takePhoto,
                    ),
                    const SizedBox(height: 14),

                    if (_imagePaths.isNotEmpty) ...[
                      _buildUploadedImages(),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const ProgressBarWidget(),
              const SizedBox(height: 24),
              const SaveProgressButton(),
              const SizedBox(height: 40),
              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadedImages() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _imagePaths.asMap().entries.map((entry) {
        final index = entry.key;
        final imagePath = entry.value;
        return _buildImageThumbnail(imagePath, index);
      }).toList(),
    );
  }

  Widget _buildImageThumbnail(String imagePath, int index) {
    return Container(
      // width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3B82F6), width: 1),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Imagen principal
          Container(
            height: 150, // height: 150px
            width: double.infinity, // align-self: stretch
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6), // border-radius: 6px 6px 0 0
                topRight: Radius.circular(6),
              ),
              color: const Color(0xFFD3D3D3), // background: lightgray
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover, // 50% / cover no-repeat
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: const Color(0xFFD3D3D3),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF6B7280),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
                // Botón de eliminar
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      width: 18, // width: 18px
                      height: 18, // height: 18px
                      padding: const EdgeInsets.all(2), // padding: 2px
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999), // border-radius: 9999px
                        color: const Color(0x99EF4444), // background: rgba(239, 68, 68, 0.60)
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white, // stroke: #FFF
                        size: 12, // stroke-width: 2px (ajustado para el tamaño)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sección de coordenadas
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coordenadas',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E), // color: #1E1E1E
                    fontFamily: 'Work Sans', // font-family: "Work Sans"
                    fontSize: 14, // font-size: 14px
                    fontStyle: FontStyle.normal, // font-style: normal
                    fontWeight: FontWeight.w500, // font-weight: 500
                    height: 22 / 14, // line-height: 22px (157.143%)
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Campo de texto con coordenadas
                    Expanded(
                      child: Container(
                        height: 40, // height: 40px
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16, // padding: 8px 16px (lateral)
                          vertical: 8, // padding: 8px 16px (vertical)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '6.244747, -75.573553',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontFamily: 'Work Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Separación de 18px
                    const SizedBox(width: 18),
                    // Botón de ubicación separado
                    GestureDetector(
                      onTap: () => _handleGeoreference(imagePath),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF232B48,
                          ), // Fondo azul para el botón
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectFromGallery() async {
    if (_imagePaths.length >= _maxImages) {
      _showMaxImagesDialog();
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePaths.add(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imagen agregada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _takePhoto() async {
    if (_imagePaths.length >= _maxImages) {
      _showMaxImagesDialog();
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePaths.add(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto tomada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al tomar foto: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  void _showMaxImagesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Límite alcanzado'),
          content: Text('Solo puedes subir un máximo de $_maxImages imágenes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  /// Maneja la georreferenciación de la imagen
  void _handleGeoreference(String imagePath) {
    // TODO: Implementar georreferenciación real
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de georreferenciación en desarrollo'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
