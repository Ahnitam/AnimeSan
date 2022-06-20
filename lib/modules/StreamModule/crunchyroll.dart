import 'dart:convert';

import 'package:animesan/models/download.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/login/field.dart';
import 'package:animesan/models/login/login_form.dart';
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
  CrunchyrollModule()
      : super(loginForms: [
          LoginForm(
            id: "username_password",
            name: "Email/Password",
            fields: {
              "username_email": Field(
                name: "Username/Email",
                inputType: TextInputType.emailAddress,
                isVisible: true,
              ),
              "password": Field(
                name: "Senha",
                inputType: TextInputType.text,
                isVisible: false,
              ),
            },
          ),
        ]);

  final String userAgent = "Crunchyroll";
  final String authorization = "Basic bzl5aDQ2empyZjc2Z2xjY25wMWw6SnFtZWZoX1Vzc2RBMHV4YVJjTlJtSlBBS255SnRwaTQ=";

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
  Future<void> logar(String loginForm) async {
    LoginForm form = loginForms.firstWhere((form) => form.id == loginForm);
    if (loginForm == "username_password") {
      await _loginWithEmail(form.fields["username_email"]!.value, form.fields["password"]!.value);
    }
  }

  @override
  Future<void> logout() async {
    return;
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
      login.putField(id: "username", name: "Username", value: email, isVisible: true);
      login.putField(id: "refresh_token", name: "", value: result["refresh_token"], isVisible: false);
      login.putField(id: "access_token", name: "", value: result["access_token"], isVisible: false);
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
        "Authorization": "Bearer ${login.getField("access_token")}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      login.putField(id: "username", name: "Username", value: result["username"] ?? result["email"], isVisible: true);
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
        "Authorization": "Bearer ${login.getField("access_token")}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      login.putField(id: "external_id", name: "", value: result["external_id"], isVisible: false);
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
        path: "/subs/v1/subscriptions/${login.getField("external_id")}/benefits",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${login.getField("access_token")}",
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      login.putField(id: "plano", name: "Plano", value: (result["total"] != 0) ? "Premium" : "Free", isVisible: true);
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
        "refresh_token": login.getField("refresh_token"),
        "scope": "offline_access",
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      login.putField(id: "refresh_token", name: "", value: result["refresh_token"], isVisible: false);
      login.putField(id: "access_token", name: "", value: result["access_token"], isVisible: false);
      return;
    } else {
      login.logout();
    }
    throw Exception("Erro get token");
  }

  @override
  Future<void> refreshLogin() async {
    await _infoProfile();
    await _getidExternal();
    await _plano();
  }

  Future<Map<String, String>> _cms() async {
    await _token();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: "/index/v2",
      ),
      headers: {
        "User-Agent": userAgent,
        "Authorization": "Bearer ${login.getField("access_token")}",
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
        "Authorization": "Bearer ${login.getField("access_token")}",
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
                streamId: id,
                streamName: name,
                id: anime['id'],
                titulo: anime['title'],
                descricao: anime['description'],
                imageUrl: anime["images"]["poster_tall"][0][1]["source"] ?? "",
              ),
            );
          }
        }
      }
      return animes;
    }
    throw Exception("Error na Busca");
  }

  @override
  Future<Anime> fetchAnimeInfo(Anime anime) async {
    final Map<String, String> cms = await _cms();
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
          tipo: item["is_dubbed"] ? MediaType.dub : MediaType.leg,
          titulo: item["title"],
          numero: formatterNum(item["season_number"].toString())!,
          anime: anime,
        );
        if (item["is_dubbed"]) {
          if (RegExp(r'.+-portuguese-dub$').hasMatch(item["slug_title"])) {
            await _getEpisodios(temporada, cms);
            anime.temporadas.add(temporada);
          }
        } else {
          await _getEpisodios(temporada, cms);
          anime.temporadas.add(temporada);
        }
      }
      return anime;
    }
    throw Exception("Erro ao buscar temporadas");
  }

  Future<void> _getEpisodios(Temporada temporada, Map<String, String> cms) async {
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
                  MediaType.dub: (!item["is_premium_only"] || (login.state.value == LoginState.logado && login.getField("plano") == "Premium"))
                      ? item["__links__"]["streams"]["href"]
                      : "",
                }
              : {
                  MediaType.leg: (!item["is_premium_only"] || (login.state.value == LoginState.logado && login.getField("plano") == "Premium"))
                      ? item["__links__"]["streams"]["href"]
                      : "",
                },
          isPremium: item["is_premium_only"],
          duracao: Duration(milliseconds: item["duration_ms"]),
          imageUrl: (item["images"]["thumbnail"] != null) ? item["images"]["thumbnail"][0][0]["source"] : "",
          numero: formatterNum(item["episode_number"]?.toString()) ?? "00",
          temporada: temporada,
        );
        temporada.episodios.add(episodio);
      }
      return;
    }
    throw Exception("Erro ao buscar episodios");
  }

  Future<Map<String, dynamic>> _getStreamVideo(String streamLink) async {
    final signed = await _cms();
    final response = await http.get(
      Uri(
        scheme: "https",
        host: apiUrl,
        path: streamLink,
        queryParameters: {
          "locale": "pt-BR",
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

  Future<void> _addDownload({
    required String streamLink,
    required Download download,
    required bool isDual,
  }) async {
    final resultado = await _getStreamVideo(streamLink);
    final streams = await getStreams(resultado["streams"]["adaptive_hls"][""]["url"], headers: null);
    bool isDub = false;
    if (streams != null) {
      if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
        download.streams["video"]!["leg"] = {
          "url": _toStaticLink(await getAdaptUrl(streams["VIDEO"]!, min: false)),
        };
      } else if (resultado["audio_locale"].toString().toUpperCase() == "PT-BR") {
        isDub = true;
        download.streams["video"]!["dub"] = {
          "url": _toStaticLink(await getAdaptUrl(streams["VIDEO"]!, min: false)),
        };
      }
      if (streams["AUDIO"] != null) {
        if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
          download.streams["audio"]!["leg"] = {
            "url": streams["AUDIO"]![0]["url"],
          };
        } else if (resultado["audio_locale"].toString().toUpperCase() == "PT-BR") {
          if (isDual) {
            (download.streams["video"] as Map).remove("dub");
          }
          isDub = true;
          download.streams["audio"]!["dub"] = {
            "url": streams["AUDIO"]![0]["url"],
          };
        }
      }
    } else {
      if (resultado["audio_locale"].toString().toUpperCase() == "JA-JP") {
        download.streams["video"]!["leg"] = {
          "url": resultado["streams"]["adaptive_hls"][""]["url"],
        };
      } else if (resultado["audio_locale"].toString().toUpperCase() == "PT-BR") {
        isDub = true;
        download.streams["video"]!["dub"] = {
          "url": resultado["streams"]["adaptive_hls"][""]["url"],
        };
      }
    }

    if (isDub) {
      try {
        download.streams["legenda"]!["dub"] = {
          "url": _toStaticLink(resultado["subtitles"]["pt-BR"]["url"]),
          "tipo": resultado["subtitles"]["pt-BR"]["format"].toString().toLowerCase(),
        };
        // ignore: empty_catches
      } catch (e) {}
    } else {
      download.streams["legenda"]!["leg"] = {
        "url": _toStaticLink(resultado["subtitles"]["pt-BR"]["url"]),
        "tipo": resultado["subtitles"]["pt-BR"]["format"].toString().toLowerCase(),
      };
    }
  }

  @override
  Future<Episodio> fetchDownloadInfo(Episodio episodio) async {
    Download download = Download(
      episodeId: episodio.id,
      seasonId: episodio.temporada.id,
      duration: episodio.duracao,
      animeName: episodio.temporada.anime.titulo,
      seasonEpisode: "S$episodio.temporada.numeroE$episodio.numero}",
      stream: name,
      streams: {
        "video": {},
        "audio": {},
        "legenda": {},
      },
      tipo: (episodio.mediasId[MediaType.dub] != null && episodio.mediasId[MediaType.leg] != null)
          ? MediaType.dual
          : (episodio.mediasId[MediaType.dub] != null)
              ? MediaType.dub
              : MediaType.leg,
    );

    try {
      await _addDownload(
        streamLink: episodio.mediasId[MediaType.leg]!,
        download: download,
        isDual: (episodio.mediasId[MediaType.dub] != null) ? true : false,
      );
      if (episodio.mediasId[MediaType.dub] != null) {
        await _addDownload(
          streamLink: episodio.mediasId[MediaType.dub]!,
          download: download,
          isDual: true,
        );
      }
      episodio.download = download;
      return episodio;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
