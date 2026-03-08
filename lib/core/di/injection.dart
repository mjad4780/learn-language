import 'package:get_it/get_it.dart';
import '../services/storage_service.dart';
import '../services/overlay_service.dart';
import '../../features/sentences/data/repo/sentence_repository.dart';
import '../../features/articles/data/repos/article_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/sentences/presentation/cubit/sentences_cubit.dart';
import '../../features/articles/presentation/cubit/articles_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupService() async {
  // Services
  final storage = StorageService();
  await storage.init();
  getIt.registerSingleton<StorageService>(storage);

  getIt.registerLazySingleton<OverlayService>(() => OverlayService());

  // Repositories
  final sentenceRepo = SentenceRepository(getIt<StorageService>());
  await sentenceRepo.loadSentences();
  getIt.registerSingleton<SentenceRepository>(sentenceRepo);

  getIt.registerLazySingleton<ArticleRepository>(() => ArticleRepository());

  // Cubits
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit());
  getIt.registerFactory<SentencesCubit>(
    () => SentencesCubit(getIt<StorageService>(), getIt<SentenceRepository>()),
  );
  getIt.registerFactory<ArticlesCubit>(() => ArticlesCubit());
}
