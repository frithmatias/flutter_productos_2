import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 50, left: 20, right: 20),
        height: 400,
        decoration: cardDecoration(),
        child: Stack(children: [
          _CardBackgroundImage(this.product),
          Positioned(child: _Availability(this.product), left: 0),
          Positioned(child: _PriceTag(this.product), right: 0),
          Positioned(child: _ProductDetails(this.product), bottom: 0),
        ]));
  }

  BoxDecoration cardDecoration() => BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))
        ],
      );
}

class _CardBackgroundImage extends StatelessWidget {
  final Product product;
  const _CardBackgroundImage(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          height: 400,
          color: Colors.deepPurple,
          child: this.product.picture != null
              ? FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(this.product.picture.toString()),
                  fit: BoxFit.cover)
              : Image(
                  image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)),
    );
  }
}

class _Availability extends StatelessWidget {
  final Product product;
  const _Availability(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: this.product.available
                ? Colors.green.withOpacity(.8)
                : Colors.red.withOpacity(.8),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.product.available ? 'Disponible' : 'Sin Stock',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]));
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;
  const _PriceTag(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$ ${this.product.price}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]));
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  const _ProductDetails(this.product);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        width: screenSize.width - 40,
        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(.8),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                this.product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ]));
  }
}
