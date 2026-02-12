import 'package:b2b_marketplace/data/mock_data.dart';
import 'package:b2b_marketplace/data/models/company.dart';
import 'package:b2b_marketplace/features/auth/login_page.dart';
import 'package:b2b_marketplace/features/auth/sign_in_page.dart';
import 'package:b2b_marketplace/features/company/company_page.dart';
import 'package:b2b_marketplace/features/home/home_page.dart';
import 'package:b2b_marketplace/features/listing/listing_page.dart';
import 'sdui_registry.dart';
import 'widgets/sdui_empty_state.dart';
import 'widgets/sdui_listing_card.dart';

/// Registers all B2B SDUI components. Call from main().
void registerSDUIWidgets() {
  final r = SDUIRegistry.instance;

  r.register('ListingCard', sduiListingCard);
  r.register('EmptyState', sduiEmptyState);

  r.register('ListingScreen', (context, node) {
    final listings = node.attributes['listings'] as List?;
    final empty = node.attributes['empty'] as bool? ?? false;
    final skeleton = node.attributes['skeleton'] as bool? ?? false;
    return ListingPage(
      sduiListings: listings?.cast<Map<String, dynamic>>(),
      emptyState: empty,
      useSkeleton: skeleton,
    );
  });

  r.register('CompanyScreen', (context, node) {
    final profileJson = node.attributes['profile'] as Map<String, dynamic>?;
    final profile = profileJson != null
        ? CompanyProfile.fromJson(profileJson)
        : MockData.companyProfile;
    return CompanyPage(profile: profile);
  });

  r.register('HomeScreen', (context, node) {
    final userName = node.attributes['userName'] as String?;
    return HomePage(userName: userName);
  });

  r.register('SignInScreen', (context, node) {
    return const SignInPage();
  });

  r.register('LoginScreen', (context, node) {
    return const LoginPage();
  });
}
