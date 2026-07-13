import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardModel> getDashboard() {
    return remoteDataSource.getDashboard();
  }
}
