import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/ui/inputs_decoration.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.selectedProduct!),
        child: _ProductScreenBody(productService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productsService;
  const _ProductScreenBody(this.productsService);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(children: [
            ProductImage(productsService.selectedProduct?.picture),

            // voler
            Positioned(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 32, color: Colors.white)),
                top: 40,
                left: 20),

            // tomar una foto
            Positioned(
                child: IconButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);

                      if (image == null) {
                        print('No se selecciono nada');
                        return;
                      }

                      print('Imagen: ${image.path}');
                      productsService.updateSelectedProductImage(image.path);
                    },
                    icon: Icon(Icons.camera_alt_outlined,
                        size: 32, color: Colors.white)),
                top: 40,
                right: 20),
          ]),
          _ProductForm(),
          SizedBox(height: 100)
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: productsService.isSaving
            ? Colors.grey.withOpacity(.8)
            : Colors.indigo,
        child: productsService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save_outlined),
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;

                final String? imageUrl = await productsService.uploadImage();
                if (imageUrl != null)
                  productFormProvider.product.picture = imageUrl;
                print('image $imageUrl');

                await productsService
                    .saveOrCreateProduct(productFormProvider.product);
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 300,
          decoration: _formBoxDecoration(),
          child: Form(
              key: productProvider.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                SizedBox(height: 5),

                // name
                TextFormField(
                    initialValue: productProvider.product.name,
                    onChanged: (value) => productProvider.product.name = value,
                    validator: (value) {
                      if (value == null || value.length < 1)
                        return 'Ingrese el nombre del producto';
                    },
                    decoration: InputsDecoration.authInputDecoration(
                        'Nombre del producto',
                        'Producto:',
                        Icons.emoji_objects)),
                SizedBox(height: 5),

                // description
                TextFormField(
                    initialValue: productProvider.product.description,
                    onChanged: (value) =>
                        productProvider.product.description = value,
                    validator: (value) {
                      if (value == null || value.length < 1)
                        return 'Ingrese la descripción del producto';
                    },
                    decoration: InputsDecoration.authInputDecoration(
                        'Descripción del producto',
                        'Descripción:',
                        Icons.check)),
                SizedBox(height: 5),

                // price
                TextFormField(
                    initialValue: '${productProvider.product.price}',
                    inputFormatters: [
                      // solo numeros, punto, y dos decimales, requiere import 'package:flutter/services.dart';
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      print(value);
                      if (double.tryParse(value) == null) {
                        productProvider.product.price = 0;
                      } else {
                        productProvider.product.price = double.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputsDecoration.authInputDecoration(
                        '\$150', 'Precio:', Icons.paid)),
                SizedBox(height: 5),

                // available
                SwitchListTile(
                  value: productProvider.product.available,
                  title: productProvider.product.available
                      ? Text('Disponible')
                      : Text('Sin Stock'),
                  activeColor: Colors.indigo,
                  onChanged: productProvider.updateAvailability,
                ),
                SizedBox(height: 5),
              ]))),
    );
  }

  BoxDecoration _formBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                offset: Offset(0, 3),
                blurRadius: 5)
          ]);
}
