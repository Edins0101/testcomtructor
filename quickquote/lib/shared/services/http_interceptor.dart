// ignore_for_file: use_build_context_synchronously, unused_catch_stack

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickquote/env/enviroment.dart';
import 'package:quickquote/shared/helpers/global_helper.dart';
import 'package:quickquote/shared/models/general_response.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/widgets/alert_template.dart';

class InterceptorHttp {
  static final InterceptorHttp _instance = InterceptorHttp._internal();
  factory InterceptorHttp() => _instance;

  InterceptorHttp._internal();

  int activeRequests = 0;

  Future<GeneralResponse> request(
    BuildContext context,
    String method,
    String urlEndPoint,
    dynamic body, {
    bool showLoading = true,
    Map<String, dynamic>? queryParameters,
    List<http.MultipartFile>? multipartFiles,
    Map<String, String>? multipartFields,
    String requestType = "JSON",
    Function(int sentBytes, int totalBytes)? onProgressLoad,
    bool isLogin = false,
  }) async {
    final urlService = Environment().config?.serviceUrl ?? "no url";

    String url =
        "$urlService$urlEndPoint?${Uri(queryParameters: queryParameters).query}";

    GeneralResponse generalResponse =
        GeneralResponse(data: null, message: "", error: true);

    final fp = Provider.of<FunctionalProvider>(context, listen: false);
    final keyLoading = GlobalHelper.genKey();
    final keyError = GlobalHelper.genKey();

    String? messageButton;
    void Function()? onPress;

    try {
      activeRequests++;
      http.Response response;
      Uri uri = Uri.parse(url);

      if (showLoading && activeRequests == 1) {
        //debugPrint("KeyLoading del interceptor: $keyLoading");
        fp.showAlert(key: keyLoading, content: const AlertLoading());
        await Future.delayed(const Duration(milliseconds: 600));

        // fp.alertLoading = [const SizedBox()];
      }

      //? Envio de TOKEN



      // if (userData != null) {
      //   tokenSesion = userData.sessionToken!;
      // }

      //PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      int responseStatusCode = 0;
      String responseBody = "";

      switch (requestType) {
        case "JSON":
          switch (method) {
            case "POST":
              response = await http.post(uri,
                  headers: headers,
                  body: body != null ? json.encode(body) : null);
              inspect(response);
              break;
            case "GET":
              response = await http.get(uri, headers: headers);
              break;
            case "PUT":
              response = await http.put(uri,
                  headers: headers,
                  body: body != null ? json.encode(body) : null);
              break;
            case "PATCH":
              response = await http.patch(uri,
                  headers: headers,
                  body: body != null ? json.encode(body) : null);
              break;
            case "DELETE":
              response = await http.delete(uri,
                  headers: headers,
                  body: body != null ? json.encode(body) : null);
            default:
              response = await http.post(uri, body: jsonEncode(body));
              break;
          }
          responseBody = response.body;
          responseStatusCode = json.decode(responseBody)["code"];

          break;
        case "FORM":
          // headers.forEach((key, value) {
          //   request.headers.set(key, value); // << en vez de solo Authorization
          // });
          final httpClient = getHttpClient();
          final request = await httpClient.postUrl(Uri.parse(url));

          int byteCount = 0;
          var requestMultipart = http.MultipartRequest(method, Uri.parse(url));
          if (multipartFiles != null) {
            requestMultipart.files.addAll(multipartFiles);
          }
          if (multipartFields != null) {
            requestMultipart.fields.addAll(multipartFields);
          }

          // headers.forEach((key, value) {
          //   request.headers.set("Authorization", 'Bearer $tokenSesion');
          // });

          debugPrint("TOKEN CARGADO");

          var msStream = requestMultipart.finalize();

          var totalByteLength = requestMultipart.contentLength;

          request.contentLength = totalByteLength;

          request.headers.set(HttpHeaders.contentTypeHeader,
              requestMultipart.headers[HttpHeaders.contentTypeHeader]!);
          Stream<List<int>> streamUpload = msStream.transform(
            StreamTransformer.fromHandlers(
              handleData: (data, sink) {
                sink.add(data);

                byteCount += data.length;

                if (onProgressLoad != null) {
                  onProgressLoad(byteCount, totalByteLength);
                }
              },
              handleError: (error, stack, sink) {
                generalResponse.error = true;
                throw error;
              },
              handleDone: (sink) {
                sink.close();
              },
            ),
          );

          await request.addStream(streamUpload);

          final httpResponse = await request.close();
          var statusCode = httpResponse.statusCode;

          responseStatusCode = statusCode;
          if (statusCode ~/ 100 != 2) {
            // String serverErrorResponse =
            await utf8.decoder.bind(httpResponse).join();
            throw Exception(
                'Error uploading file, Status code: ${httpResponse.statusCode}');
          } else {
            await for (var data in httpResponse.transform(utf8.decoder)) {
              responseBody = data;
            }
          }
          break;
      }

      switch (responseStatusCode) {
        case 200:
          var responseDecoded = json.decode(responseBody);
          generalResponse.data = responseDecoded["data"];
          generalResponse.error = false;
          generalResponse.message = responseDecoded["message"];
          fp.dismissAlert(key: keyLoading);
          break;
        case 201:
          var responseDecoded = json.decode(responseBody);
          generalResponse.data = responseDecoded["data"];
          generalResponse.error = false;
          generalResponse.message = responseDecoded["message"];
          fp.dismissAlert(key: keyLoading);
          break;
        case 204:
          var responseDecoded = json.decode(responseBody);
          generalResponse.data = responseDecoded["data"];
          //final keySesion = GlobalHelper.genKey();
          generalResponse.error = false;
          generalResponse.message = responseDecoded["message"];
          fp.dismissAlert(key: keyLoading);

          break;
        case 307:
          generalResponse.error = true;
          generalResponse.message =
              "Ocurrió un error al consultar con los servicios. Intente con una red que le permita el acceso";
          fp.dismissAlert(key: keyLoading);
          break;
        case 400:
          var responseDecoded = json.decode(responseBody);
          generalResponse.error = true;
          generalResponse.message = responseDecoded["message"];
          fp.dismissAlert(key: keyLoading);
          break;
        case 404:
          generalResponse.error = true;
          generalResponse.message = json.decode(responseBody)["message"];
          fp.dismissAlert(key: keyLoading);
          break;
        case 406:
          fp.dismissAlert(key: keyLoading);
          break;
        default:
          generalResponse.error = true;
          generalResponse.message = json.decode(responseBody)["message"];
          fp.dismissAlert(key: keyLoading);
          break;
      }
    } on TimeoutException catch (e) {
      debugPrint('$e');
      generalResponse.error = true;
      generalResponse.message = 'Tiempo de conexión excedido.';
      fp.dismissAlert(key: keyLoading);
    } on FormatException catch (ex) {
      generalResponse.error = true;
      generalResponse.message =
          "Ocurrió un error al consultar el servicio. Contáctese con el administrador";
      debugPrint(ex.toString());
      fp.dismissAlert(key: keyLoading);
    } on SocketException catch (e, stacktrace) {
      generalResponse.error = true;
      generalResponse.message =e.message;
      fp.dismissAlert(key: keyLoading);
      onPress = () {
        fp.clearAllAlert();
      };
    } on Exception catch (e, stacktrace) {
      generalResponse.error = true;
      generalResponse.message = "Ocurrio un error, vuelva a intentarlo.";
      fp.dismissAlert(key: keyLoading);
    } finally {
      activeRequests--;

      if (activeRequests == 0) {
        fp.dismissAlert(key: keyLoading);
      }
    }

    if (!generalResponse.error) {
      if (showLoading) {
        fp.dismissAlert(key: keyLoading);
      }
    } else {
      fp.dismissAlert(key: keyLoading);
      fp.showAlert(
        key: keyError,
        content: AlertGeneric(
          content: ErrorGeneric(
            keyToClose: keyError,
            message: generalResponse.message,
            messageButton: messageButton,
            onPress: onPress,
          ),
        ),
      );
    }
    return generalResponse;
  }

  HttpClient getHttpClient() {
    bool trustSelfSigned = true;
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
      // print(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
