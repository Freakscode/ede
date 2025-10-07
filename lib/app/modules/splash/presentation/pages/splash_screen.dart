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
  
  Timer? _fadeTimer;
  Timer? _navigationTimer;

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

    // Configurar listener para secuencia de animación
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Cuando termine la animación del logo, iniciar fade después de un delay
        _fadeTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            _fadeController.forward();
          }
        });
      }
    });

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Cuando termine el fade, navegar después de un delay
        _navigationTimer = Timer(const Duration(milliseconds: 2000), () {
          if (mounted) {
            context.go('/home');
          }
        });
      }
    });

    // Iniciar secuencia de animación
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // Solo iniciar la primera animación, los listeners manejan el resto
    if (mounted) {
      _logoController.forward();
    }
  }

  @override
  void dispose() {
    // Cancelar timers si están activos
    _fadeTimer?.cancel();
    _navigationTimer?.cancel();
    
    // Detener las animaciones antes de hacer dispose
    _logoController.stop();
    _fadeController.stop();
    
    // Hacer dispose de los controllers
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
                              // child: Image.asset(
                              //   AppAssets.logoDagrd,
                              //   fit: BoxFit.contain,
                              // ),
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
