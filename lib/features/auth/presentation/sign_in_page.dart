import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/widgets/brand_mark.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'hello@aruamarket.ug');
  final _passwordController = TextEditingController(text: 'password');
  UserRole _selectedRole = UserRole.customer;
  bool _isSigningIn = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSigningIn = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _isSigningIn = false);
    Navigator.of(context).pushReplacementNamed(routeForRole(_selectedRole));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            return Row(
              children: [
                if (isWide)
                  Expanded(
                    flex: 11,
                    child: _WelcomePanel(onExplore: _signIn),
                  ),
                Expanded(
                  flex: isWide ? 9 : 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 64 : 24,
                      vertical: 32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: _SignInForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          selectedRole: _selectedRole,
                          obscurePassword: _obscurePassword,
                          isSigningIn: _isSigningIn,
                          onRoleChanged: (role) {
                            setState(() => _selectedRole = role);
                          },
                          onTogglePassword: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          onSubmit: _signIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(52),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=1200&q=80',
          ),
          fit: BoxFit.cover,
          opacity: .17,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandMark(),
          const Spacer(),
          const Text(
            'Good food starts\nwith good soil.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              height: 1.08,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.4,
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 420,
            child: Text(
              'A trusted marketplace connecting Arua families with the people who grow their food.',
              style: TextStyle(
                color: Color(0xFFD9F0DD),
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _TrustPill(icon: Icons.verified_rounded, label: 'Verified farmers'),
              _TrustPill(icon: Icons.local_shipping_rounded, label: 'Local delivery'),
              _TrustPill(icon: Icons.eco_rounded, label: 'Fresh harvests'),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onExplore,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Explore the marketplace'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  const _TrustPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.13),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.leaf, size: 17),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.obscurePassword,
    required this.isSigningIn,
    required this.onRoleChanged,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final UserRole selectedRole;
  final bool obscurePassword;
  final bool isSigningIn;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandMark(compact: true),
          const SizedBox(height: 52),
          Text(
            'Welcome back',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to continue to your Arua Smart Market account.',
            style: TextStyle(color: AppColors.slate, fontSize: 15),
          ),
          const SizedBox(height: 32),
          const Text(
            'I am signing in as',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: UserRole.values
                .map(
                  (role) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: role == UserRole.customer ? 8 : 0,
                      ),
                      child: _RoleChoice(
                        role: role,
                        selected: selectedRole == role,
                        onTap: () => onRoleChanged(role),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email address',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSigningIn ? null : onSubmit,
              child: isSigningIn
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Sign in'),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('New to Arua Smart Market? Create account'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Demo mode • Connect authentication service in Phase 2',
              style: textTheme.bodySmall?.copyWith(color: AppColors.slate),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChoice extends StatelessWidget {
  const _RoleChoice({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.mint : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.forest : AppColors.line,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              role == UserRole.farmer
                  ? Icons.agriculture_rounded
                  : Icons.shopping_basket_outlined,
              color: selected ? AppColors.forest : AppColors.slate,
              size: 21,
            ),
            const SizedBox(width: 8),
            Text(
              role.label,
              style: TextStyle(
                color: selected ? AppColors.forest : AppColors.slate,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}