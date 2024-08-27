import 'package:cuidapet_shelf/application/modules/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';


class DefaultContentType extends Middlewares {

final String contentType;

  DefaultContentType(this.contentType); 

  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response
        // .change(headers: {'content-type': 'application/json;charset=utf-8'});
        //ambas as formas estão corretas
        //recebe por parametro
        .change(headers: {'content-type': contentType});
  }
}
