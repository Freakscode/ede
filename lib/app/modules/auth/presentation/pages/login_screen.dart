import 'package:caja_herramientas/app/core/constants/app_assets.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/utils/env.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/events/auth_events.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController(text: Environment.userBackend);
  final _passwordController = TextEditingController(text: Environment.passwordBackend);
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          CustomSnackBar.showSuccess(
            context,
            title: 'Login exitoso',
            message: state.message,
            duration: const Duration(seconds: 2),
          );
          context.go('/home');
        } else if (state is AuthError) {
          CustomSnackBar.showError(
            context,
            title: 'Error de login',
            message: state.message,
            duration: const Duration(seconds: 3),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              backgroundColor: DAGRDColors.azulDAGRD,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              centerTitle: true,
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
                  bottom: Radius.circular(24),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go('/home'),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: DAGRDColors.amarDAGRD,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppIcons.arrowLeft,
                          width: 26,
                          height: 26,
                          color: DAGRDColors.azulDAGRD,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 27,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'INICIAR SESIÓN',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: DAGRDColors.azulDAGRD,
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 1.167,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Image.asset(
                              AppAssets.logoDagrd,
                              height: 164,
                              width: 164,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Inicie sesión para gestión de datos usuario DAGRD',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: DAGRDColors.azulDAGRD,
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 34),
                            TextFormField(
                              controller: _cedulaController,
                              decoration: InputDecoration(
                                labelText: 'Usuario',
                                labelStyle: const TextStyle(
                                  color: Color(0xFFCCCCCC),
                                  fontFamily: 'Work Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.429,
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
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD1D5DB),
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su usuario';
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
                                  color: Color(0xFFCCCCCC),
                                  fontFamily: 'Work Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.429,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    AppIcons.key,
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFC6C6C6),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: const Color(0xFFC6C6C6),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD1D5DB),
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
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implementar recuperación de contraseña
                                },
                                child: Text(
                                  '¿Olvidaste la contraseña?',
                                  style: TextStyle(
                                    color: DAGRDColors.azulDAGRD,
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.538,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomElevatedButton(
                              text: state is AuthLoading
                                  ? 'Ingresando...'
                                  : 'Ingresar',
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<AuthBloc>().add(
                                          AuthLoginRequested(
                                            cedula: _cedulaController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          ),
                                        );
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
                Container(
                  width: double.infinity,
                  height: 110,
                  decoration: BoxDecoration(
                    color: DAGRDColors.azulDAGRD,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.logoDagrdBomberosAlcaldia,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
