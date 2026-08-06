import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:arashmati_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:arashmati_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:arashmati_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:arashmati_app/features/notification/presentation/controllers/notification_controller.dart';
import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/services/storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_session_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);
    Get.put(
      PreferenceService.instance,
      permanent: true,
    );

    Get.put(ApiClient(Get.find()), permanent: true);

    Get.put<AuthRepository>(
      AuthRepositoryImpl(AuthRemoteDataSource(Get.find())),
      permanent: true,
    );

    Get.put(
      AuthSessionController(authRepository: Get.find(), storageService: Get.find()),
      permanent: true,
    );

    Get.put<NotificationRemoteDataSource>(
      NotificationRemoteDataSource(Get.find<ApiClient>()),
      permanent: true,
    );

    Get.put<NotificationRepository>(
      NotificationRepositoryImpl(
        dataSource: Get.find<NotificationRemoteDataSource>(),
        storageService: Get.find<StorageService>(),
      ),
      permanent: true,
    );

    Get.put<NotificationController>(
      NotificationController(repo: Get.find<NotificationRepository>()),
      permanent: true,
    );
  }
}
