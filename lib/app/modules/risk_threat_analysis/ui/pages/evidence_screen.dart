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
                  ],
                ),
              ),

              if (_imagePaths.isNotEmpty) ...[
                _buildUploadedImages(),
                const SizedBox(height: 32),
              ],
              const SizedBox(height: 14),
              const ProgressBarWidget(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    AppIcons.save,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.blancoDAGRD,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Guardar avance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 24 / 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              NavigationButtonsWidget(
                onContinuePressed: () {
                  // Acción para continuar
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes subidas',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontFamily: 'Work Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _imagePaths.asMap().entries.map((entry) {
            final index = entry.key;
            final imagePath = entry.value;
            return _buildImageThumbnail(imagePath, index);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(String imagePath, int index) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFF3F4F6),
                  child: const Icon(
                    Icons.image,
                    color: Color(0xFF6B7280),
                    size: 32,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
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
}
