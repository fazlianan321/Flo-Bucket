
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Data pelanggan yang diteruskan setelah login berhasil.
class CustomerSession {
  final String name;
  final String email;

  const CustomerSession({
    required this.name,
    required this.email,
  });
}

/// Penyimpanan akun demo selama aplikasi berjalan.
/// Untuk penyimpanan permanen, gunakan Firebase atau backend.
class DemoAccountStore {
  DemoAccountStore._();

  static final Map<String, Map<String, String>> accounts = {};
}

class LoginScreen extends StatefulWidget {
  final ValueChanged<bool> onLogin;
  final ValueChanged<CustomerSession>? onCustomerLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
    this.onCustomerLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  bool isAdmin = false;
  bool isRegisterMode = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void changeRole(bool admin) {
    setState(() {
      isAdmin = admin;
      isRegisterMode = false;
      errorMessage = null;
      successMessage = null;
    });
  }

  void changeMode(bool register) {
    setState(() {
      isRegisterMode = register;
      isAdmin = false;
      errorMessage = null;
      successMessage = null;
      passwordController.clear();
      confirmPasswordController.clear();
    });
  }

  Future<void> login() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = normalizeEmail(emailController.text);
    final password = passwordController.text;

    // Login demo admin.
    if (isAdmin) {
      if (email == 'admin@flobucket.com' &&
          password == 'Admin123!') {
        widget.onLogin(true);
      } else {
        setState(() {
          errorMessage = 'Email atau password admin tidak sesuai.';
          successMessage = null;
        });
      }
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    final account = DemoAccountStore.accounts[email];

    final isValidAccount =
        account != null && account['password'] == password;

    setState(() {
      isLoading = false;

      if (!isValidAccount) {
        errorMessage =
            'Akun tidak ditemukan atau password tidak sesuai. '
            'Silakan daftar terlebih dahulu.';
      }
    });

    if (isValidAccount && account != null) {
      widget.onCustomerLogin?.call(
        CustomerSession(
          name: account['name'] ?? 'Flower Lover',
          email: account['email'] ?? email,
        ),
      );

      widget.onLogin(false);
    }
  }

  Future<void> register() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = nameController.text.trim();
    final email = normalizeEmail(emailController.text);
    final password = passwordController.text;

    if (DemoAccountStore.accounts.containsKey(email)) {
      setState(() {
        errorMessage = 'Email sudah terdaftar. Silakan login.';
        successMessage = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    DemoAccountStore.accounts[email] = {
      'name': name,
      'email': email,
      'password': password,
    };

    setState(() {
      isLoading = false;
      isRegisterMode = false;
      isAdmin = false;

      passwordController.clear();
      confirmPasswordController.clear();

      successMessage =
          'Registrasi demo berhasil! Silakan login dengan akunmu.';
    });
  }

  void showSocialLoginInfo(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Login $provider akan aktif setelah autentikasi '
          'backend dikonfigurasi.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.pinkDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned(
            top: -100,
            right: -90,
            child: _DecorativeCircle(
              size: 260,
              color: Color(0x33D96C91),
            ),
          ),
          const Positioned(
            bottom: -100,
            left: -100,
            child: _DecorativeCircle(
              size: 290,
              color: Color(0x22B88772),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  top: 10,
                ),
                child: IconButton(
                  tooltip: 'Kembali',
                  onPressed: () => Navigator.maybePop(context),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Colors.white.withValues(alpha: 0.85),
                    foregroundColor: AppColors.text,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 20,
                  vertical: 35,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 980,
                  ),
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: isWide
                          ? buildWideLayout()
                          : buildCompactLayout(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompactLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: buildLoginCard(),
      ),
    );
  }

  Widget buildWideLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.07),
            blurRadius: 45,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: buildWelcomePanel(),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(34),
                child: buildLoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomePanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(34, 42, 34, 38),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5DCE5),
            Color(0xFFFFF7F0),
            Color(0xFFF3E1D8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pinkDark.withValues(alpha: 0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_florist_rounded,
              size: 55,
              color: AppColors.pinkDark,
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'FLO BUCKET',
            style: TextStyle(
              color: AppColors.pinkDark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Every Flower\nTells a Story.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 34,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Temukan rangkaian bunga yang indah untuk '
            'mengabadikan setiap momen berharga.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WelcomeFeature(
                icon: Icons.spa_outlined,
                label: 'Fresh Flowers',
              ),
              SizedBox(width: 20),
              _WelcomeFeature(
                icon: Icons.favorite_border_rounded,
                label: 'Made with Love',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.055),
            blurRadius: 35,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: buildLoginForm(),
    );
  }

  Widget buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (MediaQuery.sizeOf(context).width < 760) ...[
            Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.pinkLight,
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Icon(
                Icons.local_florist_rounded,
                color: AppColors.pinkDark,
                size: 39,
              ),
            ),
            const SizedBox(height: 19),
            const Text(
              'FLO BUCKET',
              style: TextStyle(
                color: AppColors.pinkDark,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 13),
          ],
          Text(
            isRegisterMode
                ? 'Create an account'
                : isAdmin
                    ? 'Admin access'
                    : 'Welcome back!',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isRegisterMode
                ? 'Buat akun untuk menikmati pengalaman Flo Bucket.'
                : isAdmin
                    ? 'Masuk untuk mengelola Flo Bucket.'
                    : 'Masuk dan temukan bunga favoritmu.',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          if (!isRegisterMode)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _RoleButton(
                      label: 'Pelanggan',
                      icon: Icons.person_outline_rounded,
                      selected: !isAdmin,
                      onTap: () => changeRole(false),
                    ),
                  ),
                  Expanded(
                    child: _RoleButton(
                      label: 'Admin',
                      icon: Icons.shield_outlined,
                      selected: isAdmin,
                      onTap: () => changeRole(true),
                    ),
                  ),
                ],
              ),
            ),
          if (!isRegisterMode) const SizedBox(height: 23),
          if (isRegisterMode) ...[
            fieldLabel('Nama lengkap'),
            const SizedBox(height: 8),
            inputField(
              controller: nameController,
              hint: 'Nama lengkap kamu',
              icon: Icons.person_outline_rounded,
              action: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama lengkap wajib diisi.';
                }
                if (value.trim().length < 2) {
                  return 'Nama minimal 2 karakter.';
                }
                return null;
              },
            ),
            const SizedBox(height: 17),
          ],
          fieldLabel('Email'),
          const SizedBox(height: 8),
          inputField(
            controller: emailController,
            hint: isAdmin ? 'admin@flobucket.com' : 'nama@email.com',
            icon: Icons.mail_outline_rounded,
            type: TextInputType.emailAddress,
            action: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email wajib diisi.';
              }
              if (!isValidEmail(value.trim())) {
                return 'Masukkan alamat email yang valid.';
              }
              return null;
            },
          ),
          const SizedBox(height: 17),
          fieldLabel('Password'),
          const SizedBox(height: 8),
          inputField(
            controller: passwordController,
            hint: 'Minimal 6 karakter',
            icon: Icons.lock_outline_rounded,
            obscure: obscurePassword,
            action: isRegisterMode
                ? TextInputAction.next
                : TextInputAction.done,
            submitted: isRegisterMode ? null : (_) => login(),
            suffix: IconButton(
              tooltip: obscurePassword
                  ? 'Tampilkan password'
                  : 'Sembunyikan password',
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.muted,
                size: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi.';
              }
              if (value.length < 6) {
                return 'Password minimal 6 karakter.';
              }
              return null;
            },
          ),
          if (isRegisterMode) ...[
            const SizedBox(height: 17),
            fieldLabel('Konfirmasi password'),
            const SizedBox(height: 8),
            inputField(
              controller: confirmPasswordController,
              hint: 'Ulangi password',
              icon: Icons.lock_reset_rounded,
              obscure: obscureConfirmPassword,
              action: TextInputAction.done,
              submitted: (_) => register(),
              suffix: IconButton(
                tooltip: obscureConfirmPassword
                    ? 'Tampilkan password'
                    : 'Sembunyikan password',
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password wajib diisi.';
                }
                if (value != passwordController.text) {
                  return 'Konfirmasi password tidak cocok.';
                }
                return null;
              },
            ),
          ],
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            child: buildMessage(),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isLoading
                  ? null
                  : isRegisterMode
                      ? register
                      : login,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinkDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.pinkDark.withValues(alpha: 0.65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        key: ValueKey(
                          isRegisterMode ? 'register' : 'login',
                        ),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isRegisterMode
                                ? 'Buat Akun'
                                : isAdmin
                                    ? 'Masuk ke Dashboard'
                                    : 'Masuk',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Icon(
                            isRegisterMode
                                ? Icons.person_add_alt_1_rounded
                                : Icons.arrow_forward_rounded,
                            size: 17,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (!isAdmin && !isRegisterMode) ...[
            const SizedBox(height: 24),
            buildDivider(),
            const SizedBox(height: 19),
            const Text(
              'Atau masuk dengan',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    icon: Icons.g_mobiledata_rounded,
                    onTap: () => showSocialLoginInfo('Google'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _SocialButton(
                    label: 'Facebook',
                    icon: Icons.facebook_rounded,
                    onTap: () => showSocialLoginInfo('Facebook'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _SocialButton(
                    label: 'Apple',
                    icon: Icons.apple,
                    onTap: () => showSocialLoginInfo('Apple'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 17),
          if (!isAdmin)
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  isRegisterMode
                      ? 'Sudah punya akun? '
                      : 'Belum punya akun? ',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
                TextButton(
                  onPressed: () => changeMode(!isRegisterMode),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.pinkDark,
                  ),
                  child: Text(
                    isRegisterMode ? 'Masuk sekarang' : 'Daftar sekarang',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.maybePop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.muted,
              ),
              child: const Text(
                'Kembali ke halaman utama',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.ivory.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.roseGold,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Akun Demo Admin',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: admin@flobucket.com\nPassword: Admin123!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildMessage() {
    if (errorMessage == null && successMessage == null) {
      return const SizedBox.shrink();
    }

    final hasError = errorMessage != null;
    final message = errorMessage ?? successMessage!;
    final color = hasError ? AppColors.error : AppColors.green;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.divider),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.divider),
        ),
      ],
    );
  }

  Widget fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? type,
    TextInputAction? action,
    bool obscure = false,
    Widget? suffix,
    ValueChanged<String>? submitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      textInputAction: action,
      obscureText: obscure,
      validator: validator,
      onFieldSubmitted: submitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 12,
        ),
        prefixIcon: Icon(icon, color: AppColors.pink, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorMaxLines: 2,
        errorStyle: const TextStyle(fontSize: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.pink,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.text.withValues(alpha: 0.055),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected
                      ? AppColors.pinkDark
                      : AppColors.muted,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? AppColors.pinkDark
                          : AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.divider),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WelcomeFeature({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.pinkDark, size: 23),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
