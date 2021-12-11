import 'package:resplash/models/config.dart';

class CategorieModel {
  String? categorieName;
  String? imgUrl;
}

String apiKEY = Config().pexelsKey;

List<CategorieModel> getCategories() {
  List<CategorieModel> categories = [];
  CategorieModel categorieModel = new CategorieModel();


  //
  categorieModel.imgUrl =

  "https://images.pexels.com/photos/1125776/pexels-photo-1125776.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Nature";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();

  //
  categorieModel.imgUrl =

  "https://images.pexels.com/photos/3617457/pexels-photo-3617457.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "City";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();
  //
  categorieModel.imgUrl =
  "https://images.pexels.com/photos/1030983/pexels-photo-1030983.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Quotes";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();


  //
  categorieModel.imgUrl =
  "https://images.pexels.com/photos/2777898/pexels-photo-2777898.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Technology";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();

  //

  categorieModel.imgUrl =
  "https://images.pexels.com/photos/2531608/pexels-photo-2531608.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  categorieModel.categorieName = "Abstract";

  categories.add(categorieModel);
  categorieModel = new CategorieModel();

  //

  categorieModel.imgUrl =
  "https://images.pexels.com/photos/1191710/pexels-photo-1191710.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Colorful";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();

  //
  categorieModel.imgUrl =
  "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Motor Bikes";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();

  //
  categorieModel.imgUrl =
  "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Cars";
  categories.add(categorieModel);
  categorieModel = new CategorieModel();




  return categories;
}