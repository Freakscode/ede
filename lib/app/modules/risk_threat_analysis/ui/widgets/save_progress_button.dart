import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class SaveProgressButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const SaveProgressButton({super.key, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onPressed ?? () => _showProgressInfo(context),
            icon: SvgPicture.asset(
              AppIcons.save,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                DAGRDColors.blancoDAGRD,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              text ?? 'Guardar avance',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFFFFF), // #FFF
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 24 / 14, // line-height: 171.429%
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
        );
      },
    );
  }

  void _showProgressInfo(BuildContext context) {
    // Mostrar información sobre el progreso actual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('El progreso se mantiene activo mientras uses la app'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
