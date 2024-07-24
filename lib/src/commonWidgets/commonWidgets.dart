import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:star_rating/star_rating.dart';
import '../home/view/homeScreenView.dart';
import '../shop/View/shopView.dart';

buildTextFormField(String? hintText,TextEditingController? controller,{bool obscureText=false,String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: TextFormField(
      controller:controller ,
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

buildButton(String btnName,void Function()? onTap) {
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

alignTextToLeft(String textwithoutcolor,String textwithcolor ,void Function()? onTap ) {
  return Padding(
    padding:EdgeInsets.only(right: 8.0),
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
              recognizer: TapGestureRecognizer()
                ..onTap = onTap
            ),
          ],
        ),
      ),
    ),
  );
}

headingText(String txt){
  return Padding(
    padding: EdgeInsets.only(top: 20.0, left: 10),
    child: Text(txt,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
    ),
  );
}

spacingInHeight(BuildContext con, double space){
  return SizedBox(height: MediaQuery
      .of(con)
      .size
      .height * space);
}

gradientBackground(List<Color> colors){
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: colors
    ),
  );
}

listViewWithPadding(List<Widget> children){
  return Padding(padding: EdgeInsets.only(left: 8.0, right: 8),
    child: ListView(
      children:children ,
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

Widget buildSimpleImage(String imagePath) {
  return Image.asset(
    width: double.infinity,
    fit: BoxFit.fill,
    imagePath,
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );
}

Widget buildHorizontalScrollView(String image,String image2,String Title,String Title1,String price,String price1,bool isSale, double rate,double rate1,{required bool buttonState, required Function toggleButton}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 12.0),
          buildProductColumn(image,Title, price, isSale, buttonState, toggleButton,rate),
          SizedBox(width: 12.0),
          buildProductColumn(image2,Title1, price1, isSale, buttonState, toggleButton,rate1),
        ],
      ),
    ),
  );
}

Widget buildProductColumn(String imagePath,String title, String price, bool isSale, bool buttonState, Function toggleButton,double rate) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 160,
            height: 200,
          ),
          Positioned(
            right: 2,
            bottom: -13,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: () => toggleButton(),
                icon: Icon(
                  buttonState ? Icons.favorite_border_outlined : Icons.favorite,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(right: 30.0,top: 5),
        child: StarRating(
          length: 5,
          rating: rate,
          color: Colors.yellow[800],
          starSize: 16,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Text(
        price,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ],
  );
}

Widget buildTwoColumnImages() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Column(
        children: [
          buildTextImageStack("asset/images/whitebox.png", "Summer\nsale", Colors.red),
          buildTextImageStack("asset/images/pic2.png", "Black", Colors.white),
        ],
      ),
      Image.asset(
        width: 190,
        height: 400,
        fit: BoxFit.fill,
        "asset/images/pic1.png",
      ),
    ],
  );
}

Widget buildTextImageStack(String imagePath, String text, Color textColor) {
  return Stack(
    children: [
      Image.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        imagePath,
      ),
      Positioned(
        left: 10,
        top: 50,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
bottomNavigationBarWidget(BuildContext context,int currentIndex ) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => homeScreenView()));
          },
          icon: Icon(Icons.home_outlined),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => shopView()));
          },
          icon: Icon(Icons.shopping_cart_outlined),
        ),
        label: 'Shop',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_outlined),
        label: 'Bag',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        label: 'Favourites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_2_outlined),
        label: 'Profile',
      ),
    ],
    showSelectedLabels: true,
    showUnselectedLabels: true,
    currentIndex: currentIndex,
    unselectedItemColor: Colors.black,
    selectedItemColor: Colors.red,
    onTap: (int index){
      currentIndex=index;
  }
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