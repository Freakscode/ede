import 'package:caja_herramientas/app/core/constants/app_assets.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: DAGRDColors.azulDAGRD, // Color azul DAGRD
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // height: 110px
        centerTitle: true, // Centrar el título
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DAGRD - APP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Caja de Herramientas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24), // ajusta el radio a tu diseño
          ),
        ),
      ),
      body: Column(
        children: [
          // Contenido con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 27),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const SizedBox(height: 27),
                      Text(
                        'INICIAR SESIÓN',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: DAGRDColors.azulDAGRD, // #1E1E1E
                          fontFamily: 'Roboto',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.167, // line-height: 116.667%
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Image.asset(AppAssets.logoDagrd, height: 164, width: 164),
                      const SizedBox(height: 30),
                      Text(
                        'Inicie sesión para gestión de datos usuario DAGRD',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: DAGRDColors.azulDAGRD,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          height: 1.4, // line-height: 140%
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 34),
                      TextFormField(
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          labelText: 'Número de cédula',
                          labelStyle: const TextStyle(
                            color: Color(0xFFCCCCCC), // Texto-inputs #CCC
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.429, // line-height: 142.857%
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              AppIcons.persona,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFC6C6C6),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white, // background: #FFF
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // border-radius: 6px
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB), // Color-bordes #D1D5DB
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su cédula';
                          }
                          if (!RegExp(r'^[0-9]{8,10}$').hasMatch(value)) {
                            return 'Cédula inválida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            color: Color(0xFFCCCCCC), // Texto-inputs #CCC
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.429, // line-height: 142.857%
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              AppIcons.key, // Usando Persona.svg como placeholder
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFC6C6C6),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white, // background: #FFF
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // border-radius: 6px
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB), // Color-bordes #D1D5DB
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1,
                            ),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight, // text-align: right
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implementar recuperación de contraseña
                          },
                          child: Text(
                            '¿Olvidaste la contraseña?',
                            style: TextStyle(
                              color: DAGRDColors
                                  .azulDAGRD, // color: var(--AzulDAGRD, #232B48)
                              fontFamily: 'Roboto', // font-family: Roboto
                              fontSize: 13, // font-size: 13px
                              fontWeight: FontWeight.w500, // font-weight: 500
                              height:
                                  1.538, // line-height: 20px / 13px = 153.846%
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomElevatedButton(
                        text: 'Ingresar',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Simulación de login exitoso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login exitoso'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Navegar a home después del login
                            context.go('/home');
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenedor para logos fuera del scroll, ocupando todo el ancho
          Container(
            width: double.infinity, // Ocupa todo el ancho
            height: 110, // height: 129px
            decoration: BoxDecoration(
              color: DAGRDColors.azulDAGRD, // Mismo color del AppBar
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24), // Bordes redondeados arriba
              ),
            ),
            child: Center(
              child: Image.asset(
                AppAssets.logoDagrdBomberosAlcaldia,
                height: 100, // Ajusta la altura según necesites
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
