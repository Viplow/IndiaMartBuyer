import 'package:flutter/material.dart';
import '../../core/session/app_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/indiamart_logo.dart';

/// Login flow: Mobile → OTP → (returning user: Success | new user: Location → Categories → Success).
/// Matches indiamart-login-flow.html. SDUI-driven; static content. Demo: OTP 1234 = returning user.
class LoginPage extends StatefulWidget {
  final VoidCallback? onSuccess;

  const LoginPage({super.key, this.onSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _step = 'mobile';
  final _mobileController = TextEditingController();
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final _locationController = TextEditingController();
  final _searchController = TextEditingController();
  final _categorySearchController = TextEditingController();
  final List<int> _selectedCategories = [];
  bool _termsAccepted = false;
  bool _isReturningUser = true; // after OTP we set this; 1234 = returning
  String _displayName = 'User';

  static const _categories = [
    ('Electronics & Electrical', Icons.bolt),
    ('Building & Construction', Icons.apartment),
    ('Industrial Machinery', Icons.precision_manufacturing),
    ('Apparel & Garments', Icons.checkroom),
    ('Chemicals', Icons.science),
    ('Food & Agriculture', Icons.agriculture),
  ];

  @override
  void dispose() {
    _mobileController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _locationController.dispose();
    _searchController.dispose();
    _categorySearchController.dispose();
    super.dispose();
  }

  void _next(String step) => setState(() => _step = step);

  void _submitMobile() {
    if (_mobileController.text.length == 10 && _termsAccepted) _next('otp');
  }

  void _submitOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 4) return;
    if (otp != '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use 1234 for demo.')),
      );
      return;
    }
    _displayName = 'User'; // When data found from API, set actual name
    _isReturningUser = true;
    _next('success');
  }

  void _submitLocation() {
    if (_locationController.text.trim().isNotEmpty) _next('categories');
  }

  void _toggleCategory(int i) {
    setState(() {
      if (_selectedCategories.contains(i)) {
        _selectedCategories.remove(i);
      } else {
        _selectedCategories.add(i);
      }
    });
  }

  void _submitCategories() => _next('success');

  void _finish() {
    currentUserName.value = _displayName;
    widget.onSuccess?.call();
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step == 'mobile') {
              Navigator.of(context).pop();
            } else {
              setState(() {
                if (_step == 'otp') {
                  _step = 'mobile';
                  for (final c in _otpControllers) {
                    c.clear();
                  }
                }
              });
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildLogo(),
              const SizedBox(height: 24),
              if (_step == 'mobile') _buildMobileStep(),
              if (_step == 'otp') _buildOtpStep(),
              if (_step == 'location') _buildLocationStep(),
              if (_step == 'categories') _buildCategoriesStep(),
              if (_step == 'success') _buildSuccessStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        const IndiamartLogo(height: 80, forDarkBackground: false),
        const SizedBox(height: 4),
        Text("India's Largest B2B Marketplace", style: AppTypography.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildMobileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welcome!', style: AppTypography.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('Enter your mobile number to get started', style: AppTypography.textTheme.bodyMedium),
              const SizedBox(height: 24),
              Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
                child: const Text('+91', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Enter 10 digit number',
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                  activeColor: AppColors.accent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                  child: Text('I accept all the terms and privacy policy', style: AppTypography.textTheme.bodySmall),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('Your details are safe with us', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.accentDark)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _mobileController.text.length == 10 && _termsAccepted ? _submitMobile : null,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.accent),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Continue'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)],
            ),
          ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Verify OTP', style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('We\'ve sent a code to +91-${_mobileController.text}', style: AppTypography.textTheme.bodyMedium),
          TextButton(onPressed: () => _next('mobile'), child: const Text('Change number?')),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Text('Demo: Use OTP 1234 to continue', style: TextStyle(fontSize: 12)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _otpControllers[i],
                    focusNode: _otpFocusNodes[i],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 3) {
                        FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
                      } else if (v.isEmpty && i > 0) {
                        FocusScope.of(context).requestFocus(_otpFocusNodes[i - 1]);
                      }
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _next('mobile');
                    for (final c in _otpControllers) {
                      c.clear();
                    }
                  },
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _otpControllers.every((c) => c.text.length == 1) ? _submitOtp : null,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Verify'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select Your Location', style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Help us show you relevant suppliers near you', style: AppTypography.textTheme.bodyMedium),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              _locationController.text = 'New Delhi, Delhi';
              setState(() {});
            },
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Use Current Location'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('OR')),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Enter your city or pincode',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _locationController.text.trim().isNotEmpty ? _submitLocation : null,
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Continue'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesStep() {
    final query = _categorySearchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? List.generate(_categories.length, (i) => i)
        : List.generate(_categories.length, (i) => i).where((i) => _categories[i].$1.toLowerCase().contains(query)).toList();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What interests you?', style: AppTypography.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text('Select categories to personalize your experience', style: AppTypography.textTheme.bodyMedium),
                  ],
                ),
              ),
              TextButton(
                onPressed: _submitCategories,
                child: const Text('Skip'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.textTertiary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _categorySearchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Text('${_selectedCategories.length} selected', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                ],
              ),
            ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: List.generate(filtered.length, (idx) {
              final i = filtered[idx];
              final (name, icon) = _categories[i];
              final selected = _selectedCategories.contains(i);
              return InkWell(
                onTap: () => _toggleCategory(i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accentLight : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.accent : AppColors.border, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 28, color: selected ? AppColors.accent : AppColors.textSecondary),
                      const SizedBox(height: 8),
                      Text(name, style: AppTypography.textTheme.bodySmall, textAlign: TextAlign.center, maxLines: 2),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitCategories,
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Get Started'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          Text('Welcome $_displayName!', style: AppTypography.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            _isReturningUser
                ? "You've successfully signed in to IndiaMART"
                : "Your account is ready. Let's find what you need!",
            style: AppTypography.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _finish,
            style: FilledButton.styleFrom(backgroundColor: AppColors.headerTeal, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: const Text('Start Exploring'),
          ),
        ],
      ),
    );
  }
}
