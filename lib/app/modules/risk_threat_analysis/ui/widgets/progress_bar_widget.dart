import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        final bloc = context.read<RiskThreatAnalysisBloc>();
        final progress = bloc.calculateCompletionPercentage();
        final progressText = '${(progress * 100).toInt()}% completado';
        
        return Column(
          children: [
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFCC00),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progressText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DAGRDColors.grisMedio,
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
          ],
        );
      },
    );
  }
}