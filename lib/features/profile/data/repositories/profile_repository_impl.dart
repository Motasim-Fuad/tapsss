import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileModel> getProfile() => remoteDataSource.getProfile();

  @override
  Future<ProfileModel> updateProfile({required String name, String? imagePath}) {
    return remoteDataSource.updateProfile(name: name, imagePath: imagePath);
  }
}
