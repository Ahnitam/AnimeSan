import 'dart:convert';

import 'package:animesan/models/download.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/login/field.dart';
import 'package:animesan/modules/StreamModule/crunchyroll/login.dart';
import 'package:animesan/models/login/login_form.dart';
import 'package:animesan/models/login/login.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:animesan/utils/utils.dart';
import 'package:animesan/utils/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrunchyrollModule extends Module with StreamModule {
  final LoginCrunchyroll _login = LoginCrunchyroll();

  final String userAgent = "Crunchyroll";
  final String authorization = "Basic bzl5aDQ2empyZjc2Z2xjY25wMWw6SnFtZWZoX1Vzc2RBMHV4YVJjTlJtSlBBS255SnRwaTQ=";

  CrunchyrollModule(super.loginController);

  @override
  Login get login => _login;

  @override
  List<LoginForm> get loginForms => [
        LoginForm(
          id: "username_password",
          name: "Email/Password",
          fields: {
            "username_email": LoginFormField(
              label: "Username/Email",
              inputType: TextInputType.emailAddress,
              isVisible: true,
              autoFills: [AutofillHints.email, AutofillHints.username],
            ),
            "password": LoginFormField(
              label: "Senha",
              inputType: TextInputType.text,
              isVisible: false,
              autoFills: [AutofillHints.password],
            ),
          },
        ),
      ];

  @override
  String get id => "crunchyroll";

  @override
  String get name => "Crunchyroll";

  @override
  String get apiUrl => "beta-api.crunchyroll.com";

  @override
  Color get color => Colors.orange;

  @override
  String get icon => "assets/streams/cr_logo.svg";

  @override
  Future<void> logar(String loginForm, Map<String, String> fields) async {
    try {
      LoginForm form = loginForms.firstWhere((form) => form.id == loginForm);
      _login.loginForm = loginForm;
      if (loginForm == "username_password") {
        await _loginWithEmail(fields[form.fields.keys.elementAt(0)]!, fields[form.fields.keys.elementAt(1)]!);
      }
    } catch (e) {
      await logout();
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await http.post(
        Uri(
          scheme: "https",
          host: apiUrl,
          path: "/auth/v1/revoke",
        ),
        headers: {
          "User-Agent": userAgent,
          "Authorization": authorization,
        },
        body: {
          "token": _login.refreshToken.value,
        },
      );
      _login.logout();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _loginWithEmail(String email, String senha) async {
    final response = await http.post(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/auth/v1/token",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": authorization,
      },
      body: {
        "username": email,
        "password": senha,
        "grant_type": "password",
        "scope": "offline_access",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      _login.senha.value = senha;
      _login.refreshToken.value = result["refresh_token"];
      _login.accessToken.value = result["access_token"];
      await _infoProfile();
      await _getidExternal();
      await _plano();
      return;
    }
    throw Exception("Error ao logar");
  }

  Future<void> _infoProfile() async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/accounts/v1/me/profile",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${_login.accessToken.value}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      _login.username.value = result["username"];
      _login.email.value = result["email"];
      return;
    }
    throw Exception("Error get profile");
  }

  Future<void> _getidExternal() async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/accounts/v1/me",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${_login.accessToken.value}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      _login.externalId.value = result["external_id"];
      return;
    }
    throw Exception("Erro get external id");
  }

  Future<void> _plano() async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/subs/v1/subscriptions/${_login.externalId.value}/benefits",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${_login.accessToken.value}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      _login.plano.value = (result["total"] != 0) ? "Premium" : "Free";
      return;
    }
    throw Exception("Error get plano");
  }

  Future<void> _token() async {
    final response = await http.post(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/auth/v1/token",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": authorization,
      },
      body: {
        "grant_type": "refresh_token",
        "refresh_token": _login.refreshToken.value,
        "scope": "offline_access",
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      _login.accessToken.value = result["access_token"];
      _login.refreshToken.value = result["refresh_token"];
      return;
    } else if (response.statusCode == 400 && _login.loginForm == "username_password") {
      LoginForm form = loginForms.firstWhere((form) => form.id == _login.loginForm);
      await logar(_login.loginForm!, {form.fields.keys.elementAt(0): _login.email.value, form.fields.keys.elementAt(1): _login.senha.value});
      return;
    }
    throw Exception("Erro get token");
  }

  @override
  Future<void> refreshLogin() async {
    try {
      await _infoProfile();
      await _getidExternal();
      await _plano();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _cms() async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/index/v2",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${_login.accessToken.value}",
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      return result["cms"];
    }
    throw Exception("Erro obter cms");
  }

  @override
  Future<List<Anime>> buscar(String search) async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/content/v1/search",
        queryParameters: {"q": search, "locale": "pt-BR", "n": "10"},
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${_login.accessToken.value}",
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      List<Anime> animes = [];
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        if (item["type"] == "series") {
          for (var anime in item["items"]) {
            animes.add(
              Anime(
                module: this,
                id: anime['id'],
                titulo: anime['title'],
                descricao: anime['description'],
                imageUrl: _getImageUrl(anime["images"]),
              ),
            );
          }
        }
      }
      return animes.toList(growable: false);
    }
    throw Exception("Error na Busca");
  }

  String? _getImageUrl(Map<String, dynamic> images, {ImageType imageType = ImageType.poster}) {
    try {
      if (imageType == ImageType.poster) {
        final Map<String, dynamic> poster = (images["poster_tall"][0] as List<dynamic>).last;
        return poster["source"];
      } else if (imageType == ImageType.thumb) {
        final Map<String, dynamic> poster = (images["thumbnail"][0] as List<dynamic>).first;
        return poster["source"];
      } else {
        throw Exception("ImageType not supported");
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Anime> fetchAnimeInfo(Anime anime) async {
    final Map<String, dynamic> cms = await _cms();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/cms/v2${cms["bucket"]}/seasons",
        queryParameters: {
          "series_id": anime.id,
          "locale": "pt-BR",
          "Signature": cms["signature"],
          "Policy": cms["policy"],
          "Key-Pair-Id": cms["key_pair_id"]
        },
      ),
      headers: {
        "User-Agent": userAgent,
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      anime.temporadas.clear();
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        final Temporada temporada = Temporada(
          id: item["id"],
          tipo: item["is_dubbed"] ? EpisodeType.dub : EpisodeType.leg,
          titulo: item["title"],
          numero: formatterNum(item["season_number"].toString())!,
          anime: anime,
        );
        if (temporada.tipo == EpisodeType.leg || RegExp(r'.+-portuguese-dub$').hasMatch(item["slug_title"])) {
          await _getEpisodios(temporada, cms);
          anime.temporadas.add(temporada);
          if (!anime.temporadasEpisodeTypes.contains(temporada.tipo)) {
            anime.temporadasEpisodeTypes.add(temporada.tipo);
          }
        }
      }
      return anime;
    }
    throw Exception("Erro ao buscar temporadas");
  }

  Future<void> _getEpisodios(Temporada temporada, Map<String, dynamic> cms) async {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/cms/v2${cms["bucket"]}/episodes",
        queryParameters: {
          "season_id": temporada.id,
          "locale": "pt-BR",
          "Signature": cms["signature"],
          "Policy": cms["policy"],
          "Key-Pair-Id": cms["key_pair_id"]
        },
      ),
      headers: {
        "User-Agent": userAgent,
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in result["items"]) {
        final Episodio episodio = Episodio(
          id: item["id"],
          titulo: item["title"],
          descricao: item["description"],
          mediasId: item["is_dubbed"]
              ? {
                  EpisodeType.dub: (!item["is_premium_only"] || (login.state.value == LoginState.logado && _login.plano.value == "Premium"))
                      ? item["__links__"]["streams"]["href"]
                      : "",
                }
              : {
                  EpisodeType.leg: (!item["is_premium_only"] || (login.state.value == LoginState.logado && _login.plano.value == "Premium"))
                      ? item["__links__"]["streams"]["href"]
                      : "",
                },
          isPremium: item["is_premium_only"],
          downloadPermitido: (!item["is_premium_only"] || (login.state.value == LoginState.logado && _login.plano.value == "Premium")) ? true : false,
          duracao: Duration(milliseconds: item["duration_ms"]),
          imageUrl: _getImageUrl(item["images"], imageType: ImageType.thumb),
          numero: formatterNum(item["episode_number"]?.toString()) ?? "00",
          temporada: temporada,
        );
        temporada.episodios.add(episodio);
      }
      return;
    }
    throw Exception("Erro ao buscar episodios");
  }

  Future<Map<String, dynamic>> _getStreamVideo(String streamLink, {required IdiomaType idiomaType}) async {
    final signed = await _cms();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: streamLink,
        queryParameters: {
          "locale": _getIdiomaString(idiomaType),
          "Signature": signed["signature"],
          "Policy": signed["policy"],
          "Key-Pair-Id": signed["key_pair_id"],
        },
      ),
      headers: {
        "User-Agent": userAgent,
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception("Erro ao buscar temporadas");
  }

  String _toStaticLink(String link) {
    final assets = RegExp(r'https:\/\/.+\/evs.{0,1}\/(.+)\/assets\/(.+\.(mp4|ass|txt))').firstMatch(link)!;
    return "https://fy.v.vrv.co/evs/${assets.group(1)}/assets/${assets.group(2)}";
  }

  String _getIdiomaString(IdiomaType? idioma) {
    switch (idioma) {
      case IdiomaType.ptBR:
        return "pt-BR";
      case IdiomaType.enUS:
        return "en-US";
      case IdiomaType.jaJP:
        return "ja-JP";
      default:
        return "";
    }
  }

  String _getUrlStream(Map<String, dynamic> result, IdiomaType? idiomaType) {
    try {
      return result["streams"]["vo_adaptive_hls"][_getIdiomaString(idiomaType)]["url"];
    } catch (e) {
      return result["streams"]["vo_adaptive_hls"][_getIdiomaString(null)]["url"];
    }
  }

  @override
  Future<Download> fetchDownloadInfo({
    required Episodio episodio,
    MediaType? mediaType,
    IdiomaType idiomaType = IdiomaType.ptBR,
    QualidadeDownload qualidade = QualidadeDownload.melhor,
  }) async {
    Download download = Download(
      episodeId: episodio.id,
      seasonId: episodio.temporada.id,
      duration: episodio.duracao,
      animeName: episodio.temporada.anime.titulo,
      seasonEpisode: "S${episodio.temporada.numero}E${episodio.numero}",
      stream: name,
      tipo: mediaType ??
          ((episodio.mediasId[EpisodeType.dub] != null && episodio.mediasId[EpisodeType.leg] != null)
              ? MediaType.dual
              : (episodio.mediasId[EpisodeType.dub] != null)
                  ? MediaType.dub
                  : MediaType.leg),
    );
    try {
      for (var episodeType in episodio.mediasId.keys) {
        final result = await _getStreamVideo(episodio.mediasId[episodeType]!, idiomaType: idiomaType);

        Map<DownloadType, Future<Map<String, List<Map<String, dynamic>>?>?>> downloadStreams = {
          DownloadType.hardsub: getStreams(_getUrlStream(result, idiomaType), headers: null),
          DownloadType.softsub: getStreams(_getUrlStream(result, null), headers: null),
        };

        for (var downloadType in downloadStreams.keys) {
          final Map<String, List<Map<String, dynamic>>?>? streams = await downloadStreams[downloadType];
          final DownloadStream downloadStream = downloadType == DownloadType.hardsub ? download.hardsub : download.softsub;

          final DownloadStreamOptionInfo downloadStreamOptionInfoVideo =
              (episodeType == EpisodeType.leg ? downloadStream.video.leg : downloadStream.video.dub);
          // final DownloadStreamOptionInfo downloadStreamOptionInfoAudio =
          //     (episodeType == EpisodeType.leg ? downloadStream.audio.leg : downloadStream.audio.dub);
          final DownloadStreamOptionInfo downloadStreamOptionInfoLegenda =
              (episodeType == EpisodeType.leg ? downloadStream.legenda.leg : downloadStream.legenda.dub);

          if (streams != null) {
            downloadStreamOptionInfoVideo.url =
                _toStaticLink(getAdaptUrl(streams["VIDEO"]!, min: qualidade == QualidadeDownload.melhor ? false : true));
            downloadStreamOptionInfoVideo.type = "mp4";

            // if (streams["AUDIO"] != null && downloadType == DownloadType.softsub) {
            //   downloadStreamOptionInfoAudio.url = streams["AUDIO"]![0]["url"];
            //   downloadStreamOptionInfoAudio.type = "aac";
            //   if (episodeType == EpisodeType.dub && download.tipo == MediaType.dual) {
            //     downloadStream.video.dub.url = null;
            //     downloadStream.video.dub.type = null;
            //   }
            // }
          } else {
            downloadStreamOptionInfoVideo.url =
                result["streams"]["vo_adaptive_hls"][_getIdiomaString(downloadType == DownloadType.hardsub ? null : idiomaType)]["url"];
            downloadStreamOptionInfoVideo.type = "m3u8";
          }

          try {
            if (downloadType == DownloadType.softsub) {
              downloadStreamOptionInfoLegenda.url = _toStaticLink(result["subtitles"][_getIdiomaString(idiomaType)]["url"]);
              downloadStreamOptionInfoLegenda.type = result["subtitles"][_getIdiomaString(idiomaType)]["format"].toString().toLowerCase();
            }
          } catch (e) {
            debugPrint("Erro ao pegar legenda: ${episodeType.name}");
            if (episodeType == EpisodeType.leg) {
              rethrow;
            }
          }
        }
      }
      return download;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
