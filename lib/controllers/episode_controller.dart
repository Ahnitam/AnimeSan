import 'package:animesan/models/download.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/mixins.dart';
import 'package:get/get.dart';

class EpisodeController extends GetxController with StateMixin<Download> {
  final Episodio episodio;
  final List<StreamModule> streamsModules = Get.find<List<StreamModule>>();

  EpisodeController({required this.episodio});

  fetchDownload() {
    change(episodio.download, status: RxStatus.loading());
    try {
      if (episodio.download == null) {}
      change(episodio.download, status: RxStatus.success());
    } catch (e) {
      change(episodio.download, status: RxStatus.error(e.toString()));
    }
  }
}
