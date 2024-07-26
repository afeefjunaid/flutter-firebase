import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/home/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

import '../../commonWidgets/commonWidgets.dart';
import '../../productDetail/view/productDetailView.dart';

class selectedCategoryView extends StatefulWidget {
  final String category;

  selectedCategoryView({
    this.category = '',
  });

  @override
  State<selectedCategoryView> createState() => _selectedCategoryViewState();
}

class _selectedCategoryViewState extends State<selectedCategoryView> {
  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)?.settings.arguments as String;
    return BaseScaffold(
      body: Container(
        decoration: gradientBackground([
          Colors.red.shade100,
          Colors.white,
          Colors.white,
        ]),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: homeViewModelObject.futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final filteredProducts = snapshot.data.where((product) => product.category == category).toList();
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        double rate = filteredProducts[index].rating ?? 0.0;
                        return Container(
                          width: 150,
                          child: InkWell(
                            onTap: () {
                             // Navigator.pushNamed(context, '/productDetails',arguments: filteredProducts[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => productDetailView(selectedItem: filteredProducts[index],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          filteredProducts[index].image,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3.0, top: 10),
                                        child: Text(
                                          filteredProducts[index].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
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
                                          viewModel.toggleButton(index);
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Icon(
                                            viewModel.favouriteStatus[index] == false
                                                ? Icons.favorite
                                                : Icons.favorite_border_outlined,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Back"))
          ],
        ),
      ),
    );
  }
}
