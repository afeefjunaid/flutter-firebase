import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';
import 'package:uuid/uuid.dart';
import '../home/viewModel/homeViewModel.dart';
import '../productDetail/view/productDetailView.dart';

buildTextFormField(String? hintText, TextEditingController? controller,
    {bool obscureText = false, String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.red,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.red))),
    ),
  );
}

buildButton(String btnName, void Function()? onTap) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Text(
              btnName,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

buildSocialMediaRow() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialMediaIcon("asset/images/google_logo.png"),
        const SizedBox(width: 20),
        buildSocialMediaIcon("asset/images/Facebook_logo_(square).png"),
      ],
    ),
  );
}

buildSocialMediaIcon(String assetPath) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(28.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            assetPath,
            width: 80,
            height: 80,
          ),
        ),
      ),
    ),
  );
}

alignTextToLeft(
    String textwithoutcolor, String textwithcolor, void Function()? onTap) {
  return Padding(
    padding: EdgeInsets.only(right: 8.0),
    child: Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(text: textwithoutcolor),
            TextSpan(
                text: textwithcolor,
                style: const TextStyle(color: Colors.red),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ],
        ),
      ),
    ),
  );
}

headingText(String txt) {
  return Padding(
    padding: EdgeInsets.only(top: 20.0, left: 10),
    child: Text(
      txt,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
    ),
  );
}

spacingInHeight(BuildContext con, double space) {
  return SizedBox(height: MediaQuery.of(con).size.height * space);
}

gradientBackground(List<Color> colors) {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.bottomRight, end: Alignment.topLeft, colors: colors),
  );
}

listViewWithPadding(List<Widget> children) {
  return Padding(
    padding: EdgeInsets.only(left: 8.0, right: 8),
    child: ListView(
      children: children,
    ),
  );
}

buildImageStack(String imagePath, String text, {VoidCallback? onPressed}) {
  return Stack(
    children: [
      Image.asset(
        width: double.infinity,
        fit: BoxFit.fill,
        imagePath,
      ),
      Positioned(
        left: 10,
        bottom: text.contains('\n') ? 90 : 40,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      if (onPressed != null)
        Positioned(
          left: 10,
          bottom: 40,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                "Check",
                style: TextStyle(color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ),
    ],
  );
}

Widget buildSectionTitle(String? title) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Text(
      (title?.isEmpty == true || title == null || title == "") ? "All" : title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );
}



categoryCard(String title, String imagePath) {
  return Padding(
    padding: EdgeInsets.only(top: 15, bottom: 15),
    child: SizedBox(
      height: 100,
      child: Card(
        color: Colors.red.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Image.asset(
              imagePath,
              height: 280,
              width: 100,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    ),
  );
}

listViewBuilder({String? category}) {
  return FutureBuilder(
    future: homeViewModelObject.futureProducts,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No products found'));
      } else {
        final products = snapshot.data!;
        final filteredProducts = category == null
            ? products
            : products
                .where((product) => product.category == category)
                .toList();
        return Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              double rate = filteredProducts[index].rating ?? 0.0;
              Uuid id=Uuid();
              var nId= id.v4();
              return Container(
                width: 150,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => productDetailView(selectedItem: filteredProducts[index],heroTag:nId ,)));
                  },
                  child: Stack(clipBehavior: Clip.none, children: [
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag:nId,
                            child: Image.network(filteredProducts[index].image,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0, top: 10),
                            child: Text(filteredProducts[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0, top: 5),
                            child: StarRating(
                              length: 5,
                              rating: rate,
                              color: Colors.yellow[800],
                              starSize: 16,
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text("${filteredProducts[index].price}\$"),
                          ),
                        ],
                      ),
                    ),
                    Consumer<homeViewModel>(
                        builder: (context, viewModel, child) {
                      return Positioned(
                        right: 5,
                        bottom: 80,
                        child: InkWell(
                          onTap: () {
                            viewModel.toggleButton(filteredProducts[index]);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              viewModel.favouriteProducts.contains(filteredProducts[index])
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ]),
                ),
              );
            },
          ),
        );
      }
    },
  );
}

buildImageForCategories(String imgPath,String imageText,double top,double bottom, double left, double right){
  return Expanded(
    child: Stack(
      children: [
        Container(
            child: Image.asset(imgPath)),
        Positioned(
            top: top,
            bottom: bottom,
            left: left,
            right: right,
            child: Text(imageText))
      ],
    ),
  );
}
