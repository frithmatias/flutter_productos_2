import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Product product;

  ProductFormProvider(this.product);

  bool isValidForm() {
    print("----------------");
    print(product.name);
    print(product.description);
    print(product.price);
    print(product.available);
    print('Formulario válido: ${formKey.currentState?.validate()}');
    return formKey.currentState?.validate() ?? false;
  }

  updateAvailability(bool value) {
    this.product.available = value;
    notifyListeners();
  }
}
