import 'package:flutter/material.dart';
import '../../core/session/app_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/indiamart_logo.dart';

/// Sign Up flow (new user): Mobile → OTP → Location → Categories → Confirmation → Success.
/// Matches indiamart-login-flow (2).html. SDUI-driven; static content.
class SignInPage extends StatefulWidget {
  final VoidCallback? onSuccess;

  const SignInPage({super.key, this.onSuccess});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _step = 'mobile';
  final _mobileController = TextEditingController();
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _searchController = TextEditingController();
  String? _selectedCity; // dropdown selection
  static const _cities = [
    'Mumbai', 'Delhi', 'New Delhi', 'Bangalore', 'Bengaluru', 'Chennai', 'Hyderabad', 'Kolkata', 'Pune',
    'Ahmedabad', 'Jaipur', 'Surat', 'Lucknow', 'Kanpur', 'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam',
    'Patna', 'Vadodara', 'Ghaziabad', 'Ludhiana', 'Agra', 'Nashik', 'Faridabad', 'Meerut', 'Rajkot', 'Varanasi',
    'Srinagar', 'Aurangabad', 'Dhanbad', 'Amritsar', 'Allahabad', 'Ranchi', 'Howrah', 'Coimbatore', 'Jabalpur',
    'Gwalior', 'Vijayawada', 'Jodhpur', 'Madurai', 'Raipur', 'Kota', 'Guwahati', 'Chandigarh', 'Solapur', 'Tiruchirappalli',
  ];
  final _categorySearchController = TextEditingController();
  final List<int> _selectedCategories = [];
  bool _termsAccepted = false;
  String _displayName = 'User'; // Set after OTP when data is found

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
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _searchController.dispose();
    _categorySearchController.dispose();
    super.dispose();
  }

  void _next(String step) => setState(() => _step = step);
  void _submitMobile() {
    if (_mobileController.text.length == 10 && _termsAccepted) {
      _displayName = 'User';
      _next('location');
    }
  }

  void _submitOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      if (otp == '1234') {
        _displayName = 'User'; // When data found from API, set actual name here
        _next('location');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Use 1234 for demo.')),
        );
      }
    }
  }

  void _submitLocation() {
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      final name = _nameController.text.trim();
      if (name.isNotEmpty) _displayName = name;
      _next('categories');
    }
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

  void _submitCategories() {
    _next('confirmation');
  }

  void _confirmAndFinish() {
    _next('success');
  }

  void _finish() {
    currentUserName.value = _displayName;
    widget.onSuccess?.call();
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildLogo(),
              const SizedBox(height: 24),
              if (_step == 'mobile') _buildMobileStep(),
              if (_step == 'location') _buildLocationStep(),
              if (_step == 'categories') _buildCategoriesStep(),
              if (_step == 'confirmation') _buildConfirmationStep(),
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
        const IndiamartLogo(height: 60, forDarkBackground: false),
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
          ]),
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
                  child: Text(
                    'I accept all the terms and privacy policy',
                    style: AppTypography.textTheme.bodySmall,
                  ),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Verify OTP', style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('We\'ve sent a code to +91-${_mobileController.text}', style: AppTypography.textTheme.bodyMedium),
          TextButton(
            onPressed: () => _next('mobile'),
            child: const Text('Change number?'),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.shade200)),
            child: const Text('Demo: Use OTP 1234 to continue (New User Flow)', style: TextStyle(fontSize: 12)),
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
                    decoration: const InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select Your Location', style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Help us show you relevant suppliers near you', style: AppTypography.textTheme.bodyMedium),
          const SizedBox(height: 20),
          // Name (optional)
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name (optional)',
              hintText: 'Enter your name',
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              prefixIcon: const Icon(Icons.person_outline, size: 22),
            ),
          ),
          const SizedBox(height: 16),
          // Email (optional)
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email (optional)',
              hintText: 'Enter your email',
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              prefixIcon: const Icon(Icons.email_outlined, size: 22),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _selectedCity = 'New Delhi';
                _locationController.text = 'New Delhi, Delhi';
              });
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Auto detect location'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('OR')),
          const SizedBox(height: 16),
          // City dropdown (on click opens list; show ~4 items, rest scrollable)
          DropdownButtonFormField<String>(
            value: _selectedCity,
            menuMaxHeight: 220,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              prefixIcon: Icon(Icons.location_on_outlined, size: 22),
            ),
            hint: const Text('Select city'),
            isExpanded: true,
            items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
                _locationController.text = value ?? '';
              });
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _selectedCity != null && _selectedCity!.isNotEmpty ? _submitLocation : null,
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
      ]),
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

  Widget _buildConfirmationStep() {
    final location = _locationController.text.trim().isEmpty ? 'Not selected' : _locationController.text.trim();
    final selectedIndices = _selectedCategories;
    const lightBlueBg = Color(0xFFE8F4F8);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('Welcome!', style: AppTypography.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Review your location and interests below, then continue.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          // Selected location (card like image)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBlueBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB8D4E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Text('Selected location', style: AppTypography.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(location, style: AppTypography.textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Your interests (card like image)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBlueBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB8D4E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('✨ ', style: AppTypography.textTheme.titleSmall),
                    Text('Your interests', style: AppTypography.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                selectedIndices.isEmpty
                    ? Text('None selected', style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedIndices.map((i) {
                          final (name, icon) = _categories[i];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, size: 18, color: Colors.green.shade700),
                                const SizedBox(width: 6),
                                Text(name, style: AppTypography.textTheme.bodySmall),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _next('categories'),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _confirmAndFinish,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.headerTeal),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Confirm & Continue'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
      ]),
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
          Text("Your account is ready. Let's find what you need!", style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Tap below to start exploring.', style: AppTypography.textTheme.bodyMedium, textAlign: TextAlign.center),
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
