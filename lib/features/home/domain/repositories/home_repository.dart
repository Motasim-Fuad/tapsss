import '../../data/models/dashboard_model.dart';

abstract class HomeRepository {
  Future<DashboardModel> getDashboard();
}
