import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/admin_login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/property/property_list_screen.dart';
import 'screens/property/add_property_screen.dart';
import 'screens/property/property_detail_screen.dart';
import 'screens/tenant/tenant_list_screen.dart';
import 'screens/tenant/add_tenant_screen.dart';
import 'screens/tenant/tenant_detail_screen.dart';
import 'screens/rental/agreement_screens.dart';
import 'screens/rent/rent_screens.dart';
import 'screens/service/service_screens.dart';
import 'screens/listing/listing_screens.dart';
import 'screens/other/other_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NriApp());
}

class NriApp extends StatelessWidget {
  const NriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NRI Property Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/admin-login': (_) => const AdminLoginScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/admin-dashboard': (_) => const AdminDashboardScreen(),
        '/properties': (_) => const PropertyListScreen(),
        '/properties/add': (_) => const AddPropertyScreen(),
        '/properties/detail': (_) => const PropertyDetailScreen(),
        '/tenants': (_) => const TenantListScreen(),
        '/tenants/add': (_) => const AddTenantScreen(),
        '/tenants/detail': (_) => const TenantDetailScreen(),
        '/agreements': (_) => const AgreementListScreen(),
        '/agreements/create': (_) => const CreateAgreementScreen(),
        '/agreements/detail': (_) => const AgreementDetailScreen(),
        '/rent': (_) => const RentPaymentScreen(),
        '/maintenance': (_) => const MaintenanceScreen(),
        '/service-requests': (_) => const ServiceRequestListScreen(),
        '/service-requests/create': (_) => const CreateServiceRequestScreen(),
        '/listings/buy': (_) => const BuySearchScreen(),
        '/listings/sell': (_) => const SellListingScreen(),
        '/construction': (_) => const ConstructionScreen(),
        '/legal': (_) => const LegalScreen(),
        '/subscription': (_) => const SubscriptionScreen(),
        '/notifications': (_) => const NotificationScreen(),
      },
    );
  }
}
