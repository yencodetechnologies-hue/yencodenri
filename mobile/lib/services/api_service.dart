import '../core/api/api_client.dart';

class ApiService {
  final ApiClient _api = ApiClient();

  Future<dynamic> getDashboard() async {
    final res = await _api.get('/dashboard');
    return res['data'];
  }

  // Properties
  Future<List<dynamic>> getProperties() async {
    final res = await _api.get('/properties');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createProperty(Map<String, dynamic> data) async {
    final res = await _api.post('/properties', data);
    return res['data'];
  }

  Future<dynamic> updateProperty(String id, Map<String, dynamic> data) async {
    final res = await _api.put('/properties/$id', data);
    return res['data'];
  }

  Future<void> deleteProperty(String id) async {
    await _api.delete('/properties/$id');
  }

  // Tenants
  Future<List<dynamic>> getTenants() async {
    final res = await _api.get('/tenants');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createTenant(Map<String, dynamic> data) async {
    final res = await _api.post('/tenants', data);
    return res['data'];
  }

  Future<dynamic> updateTenant(String id, Map<String, dynamic> data) async {
    final res = await _api.put('/tenants/$id', data);
    return res['data'];
  }

  // Agreements
  Future<List<dynamic>> getAgreements() async {
    final res = await _api.get('/agreements');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createAgreement(Map<String, dynamic> data) async {
    final res = await _api.post('/agreements', data);
    return res['data'];
  }

  Future<dynamic> generateAgreementPdf(String id) async {
    final res = await _api.post('/agreements/$id/generate-pdf', {});
    return res['data'];
  }

  Future<dynamic> eSignAgreement(String id) async {
    final res = await _api.post('/agreements/$id/e-sign', {});
    return res['data'];
  }

  // Rent
  Future<List<dynamic>> getRentHistory() async {
    final res = await _api.get('/rent/history');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createRentPayment(Map<String, dynamic> data) async {
    final res = await _api.post('/rent', data);
    return res['data'];
  }

  Future<dynamic> verifyRentPayment(Map<String, dynamic> data) async {
    final res = await _api.post('/rent/verify', data);
    return res['data'];
  }

  // Maintenance
  Future<List<dynamic>> getMaintenanceHistory() async {
    final res = await _api.get('/maintenance/history');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createMaintenancePayment(Map<String, dynamic> data) async {
    final res = await _api.post('/maintenance', data);
    return res['data'];
  }

  // Service Requests
  Future<List<dynamic>> getServiceRequests() async {
    final res = await _api.get('/service-requests');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createServiceRequest(Map<String, dynamic> data) async {
    final res = await _api.post('/service-requests', data);
    return res['data'];
  }

  Future<dynamic> submitFeedback(String id, String feedback, int rating) async {
    final res = await _api.post('/service-requests/$id/feedback', {'feedback': feedback, 'rating': rating});
    return res['data'];
  }

  // Listings
  Future<List<dynamic>> searchBuyListings({String? location, String? propertyType}) async {
    var path = '/listings/buy?';
    if (location != null && location.isNotEmpty) path += 'location=$location&';
    if (propertyType != null && propertyType.isNotEmpty) path += 'propertyType=$propertyType&';
    final res = await _api.get(path, auth: false);
    return res['data'] as List<dynamic>;
  }

  Future<List<dynamic>> getMyListings() async {
    final res = await _api.get('/listings');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createListing(Map<String, dynamic> data) async {
    final res = await _api.post('/listings', data);
    return res['data'];
  }

  Future<dynamic> addLead(String listingId, Map<String, dynamic> data) async {
    final res = await _api.post('/listings/$listingId/leads', data, auth: false);
    return res['data'];
  }

  // Construction
  Future<List<dynamic>> getConstructionProjects() async {
    final res = await _api.get('/construction');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createConstructionProject(Map<String, dynamic> data) async {
    final res = await _api.post('/construction', data);
    return res['data'];
  }

  // Legal
  Future<List<dynamic>> getLegalCases() async {
    final res = await _api.get('/legal');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createLegalCase(Map<String, dynamic> data) async {
    final res = await _api.post('/legal', data);
    return res['data'];
  }

  // Subscriptions
  Future<List<dynamic>> getFees() async {
    final res = await _api.get('/subscriptions/fees', auth: false);
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> createSubscription(String propertyId) async {
    final res = await _api.post('/subscriptions', {'propertyId': propertyId});
    return res['data'];
  }

  Future<List<dynamic>> getMySubscriptions() async {
    final res = await _api.get('/subscriptions');
    return res['data'] as List<dynamic>;
  }

  // Notifications
  Future<List<dynamic>> getNotifications() async {
    final res = await _api.get('/notifications');
    return res['data'] as List<dynamic>;
  }

  // Admin
  Future<List<dynamic>> adminGetUsers() async {
    final res = await _api.get('/admin/users');
    return res['data'] as List<dynamic>;
  }

  Future<void> adminVerifyUser(String id) async {
    await _api.patch('/admin/users/$id/verify', {});
  }

  Future<void> adminSuspendUser(String id) async {
    await _api.patch('/admin/users/$id/suspend', {});
  }

  Future<List<dynamic>> adminGetProperties() async {
    final res = await _api.get('/admin/properties');
    return res['data'] as List<dynamic>;
  }

  Future<void> adminVerifyProperty(String id, String status, {String? reason}) async {
    await _api.patch('/admin/properties/$id/verify', {'status': status, 'rejectionReason': reason});
  }

  Future<List<dynamic>> adminGetTenants() async {
    final res = await _api.get('/admin/tenants');
    return res['data'] as List<dynamic>;
  }

  Future<void> adminVerifyTenant(String id, Map<String, dynamic> data) async {
    await _api.patch('/admin/tenants/$id/verify', data);
  }

  Future<List<dynamic>> adminGetListings() async {
    final res = await _api.get('/admin/listings');
    return res['data'] as List<dynamic>;
  }

  Future<void> adminApproveListing(String id) async {
    await _api.patch('/admin/listings/$id/approve', {});
  }

  Future<void> adminRejectListing(String id, String reason) async {
    await _api.patch('/admin/listings/$id/reject', {'rejectionReason': reason});
  }

  Future<dynamic> adminGetFinance() async {
    final res = await _api.get('/admin/finance');
    return res['data'];
  }

  Future<List<dynamic>> adminGetVendors() async {
    final res = await _api.get('/admin/vendors');
    return res['data'] as List<dynamic>;
  }

  Future<dynamic> adminCreateVendor(Map<String, dynamic> data) async {
    final res = await _api.post('/admin/vendors', data);
    return res['data'];
  }

  Future<List<dynamic>> adminGetServiceRequests() async {
    final res = await _api.get('/admin/service-requests');
    return res['data'] as List<dynamic>;
  }

  Future<void> adminAssignVendor(String requestId, String vendorId) async {
    await _api.patch('/admin/service-requests/$requestId/assign', {'vendorId': vendorId});
  }

  Future<void> adminUpdateServiceStatus(String requestId, String status) async {
    await _api.patch('/admin/service-requests/$requestId/status', {'status': status});
  }
}
