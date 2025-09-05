import 'dart:async';
import 'package:caja_herramientas/app/core/constants/app_assets.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Iniciar secuencia de animación
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Iniciar animación del logo
    await _logoController.forward();

    // Esperar un momento
    await Future.delayed(const Duration(milliseconds: 500));

    // Iniciar fade de texto
    await _fadeController.forward();

    // Esperar antes de navegar
    await Future.delayed(const Duration(milliseconds: 2000));

    // Navegar a login
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DAGRDColors.azulDAGRD, // Fondo azul DAGRD
      body: SafeArea(
        child: Column(
          children: [
            // Contenido principal del splash
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo principal con animación
                    AnimatedBuilder(
                      animation: _logoAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoAnimation.value,
                          child: Container(
                            width: 140, // width: 140px según Figma
                            height: 140, // height: 140px según Figma
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9), // background: #D9D9D9
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // border-radius: 12px
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                AppAssets.logoDagrd,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 64,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Caja de ',
                                        style: TextStyle(
                                          color: Colors.white, // #FFF
                                          fontFamily: 'Metropolis',
                                          fontSize: 38,
                                          fontWeight: FontWeight.w500,
                                          height: 1.0, // line-height: normal
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Herramientas ',
                                        style: TextStyle(
                                          color: Color(
                                            0xFFFFCC00,
                                          ), // #FC0 (amarillo)
                                          fontFamily: 'Metropolis',
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          height: 1.0, // line-height: normal
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'DAGRD',
                                        style: TextStyle(
                                          color: Colors.white, // #FFF
                                          fontFamily: 'Metropolis',
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
                                          height: 1.0, // line-height: normal
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Container con logos institucionales en la parte inferior
            Container(
              width: 300, // Ocupa todo el ancho
              height: 110,
              decoration: BoxDecoration(
                color: DAGRDColors.amarDAGRD, // Color amarillo DAGRD
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24), // Bordes redondeados arriba
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 94,
                  child: Image.asset(
                    AppAssets.logoDagrdBomberosAlcaldiaColor,
                    width: 300,
                    height: 94,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
