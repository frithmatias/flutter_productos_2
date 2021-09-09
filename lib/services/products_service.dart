import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/services/services.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-productos-3dd4b-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product? selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  File? newPicFile;

  final storage = new FlutterSecureStorage();

  ProductsService() {
    this.loadProducts();
  }

  Future loadProducts() async {
    this.isLoading = true;

    final url = Uri.https(_baseUrl, 'productos2.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      AlertService.showSnackbar('Error de autenticación');
      return;
    }

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((id, product) {
      final prodTemp = Product.fromMap(product);
      prodTemp.id = id;
      products.add(prodTemp);
    });

    this.isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    this.isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await this.createProduct(product);
    } else {
      await this.updateProduct(product);
    }

    this.isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos2/${product.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.put(url, body: product.toJson());
    if (resp.statusCode != 200) {
      AlertService.showSnackbar('Error de autenticación');
      return '';
    }

    final i = this.products.indexWhere((element) => element.id == product.id);
    this.products[i] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos2.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.post(url, body: product.toJson());
    if (resp.statusCode != 200) {
      AlertService.showSnackbar('Error de autenticación');
      return '';
    }

    final resJson = json.decode(resp.body);
    product.id = resJson['name'];
    this.products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    this.newPicFile = File.fromUri(Uri(path: path));
    this.selectedProduct?.picture = path;
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPicFile == null) return null;
    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/crab-devs/image/upload?upload_preset=flutter-products');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPicFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salió mal');
      print(resp.body);
      return null;
    }

    this.newPicFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
