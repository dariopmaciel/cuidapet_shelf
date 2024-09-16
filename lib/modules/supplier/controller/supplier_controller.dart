import 'dart:convert';

import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/modules/supplier/service/i_supplier_service.dart';
import 'package:cuidapet_shelf/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_shelf/modules/supplier/view_models/supplier_update_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

@Injectable()
class SupplierController {
  ISupplierService service;
  final ILogger log;

  SupplierController({required this.service, required this.log});

  @Injectable()
  @Route.get('/')
  Future<Response> findNearByMe(Request request) async {
    try {
      final lat = double.tryParse(request.url.queryParameters['lat'] ?? "");
      final lng = double.tryParse(request.url.queryParameters['lng'] ?? "");

      if (lat == null || lng == null) {
        return Response(
          400,
          body: jsonEncode({'message': 'LATITUDE E LONGITUDE OBRIGATORIOS'}),
        );
      }
      final suppliers = await service.findNearbyMe(lat, lng);
      final result = suppliers
          .map(
            (s) => {
              'id': s.id,
              'name': s.name,
              'logo': s.logo,
              'distance': s.distance,
              'categoty': s.categoryId,
            },
          )
          .toList();

      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      log.error("", e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': "Erro ao buscar fornecedores perto de mim"}));
    }
  }

  //expressão regular para receber APENAS numeros de 0 a 9

  @Route.get('/<id|[0-9]+>')
  Future<Response> findById(Request request, String id) async {
    final supplier = await service.findById(int.parse(id));
    if (supplier == null) {
      return Response.ok(jsonEncode({}));
    }

    return Response.ok(_supplierMapper(supplier));
  }

  @Route.get('/<supplierId|[0-9]+>/services')
  Future<Response> findServicesBySupplierId(
      Request request, String supplierId) async {
    try {
      final supplierServices =
          await service.findServicesBySupplierId(int.parse(supplierId));
      final result = supplierServices
          .map((e) => {
                'id': e.id,
                'supplier_id': e.price,
                'name': e.name,
                'price': e.price,
              })
          .toList();
      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      log.error("Erro ao buscar SERVICOS", e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao buscar SERVICOS'}));
    }
  }

  @Route.get('/user')
  Future<Response> checkUserExists(Request request) async {
    final email = request.url.queryParameters['email'];
    if (email == null) {
      return Response(400, body: jsonEncode({"message": "Email obrigatório"}));
    }
    final isEmailExistes = await service.checkUserEmailExists(email);
    return isEmailExistes ? Response(200) : Response(204);
  }

  @Route.post('/user')
  Future<Response> createUser(Request request) async {
    try {
      final model = CreateSupplierUserViewModel(await request.readAsString());
      await service.createUserSupplier(model);
      return Response.ok(jsonEncode({}));
    } catch (e, s) {
      log.error("Erro ao cadastrar um novo fornecedor e usuario", e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Erro ao cadastrar um novo fornecedor e usuario'}));
    }
  }

  @Route.put('/')
  Future<Response> update(Request request) async {
    try {
      final supplier = int.parse(request.headers['supplier'] ?? "");

      if (supplier == null) {
        return Response(400,
            body:
                jsonEncode({'message': 'CODIGO FORNECEDOR NAO PODE SER NULO'}));
      }

      final model = SupplierUpdateInputModel(
          supplierId: supplier, dataRequest: await request.readAsString());

      final supplierResponse = await service.update(model);

      return Response.ok(_supplierMapper(supplierResponse));
    } catch (e, s) {
      log.error("ERRO AO ATUALIZAR FORNECEDOR", e, s);
      return Response.internalServerError();
    }
  }

//*---------------------------------------------------------------
  String _supplierMapper(Supplier supplier) {
    return jsonEncode({
      'id': supplier.id,
      'name': supplier.name,
      'logo': supplier.logo,
      'address': supplier.address,
      'phone': supplier.phone,
      'latitude': supplier.lat,
      'longitude': supplier.lng,
      'category': {
        'id': supplier.category?.id,
        'name': supplier.category?.name,
        'type': supplier.category?.type,
      }
    });
  }

  Router get router => _$SupplierControllerRouter(this);
}
