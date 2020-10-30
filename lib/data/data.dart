class SliderModel {
  String imagePath;
  String title;
  String desc;

  SliderModel({this.imagePath, this.title, this.desc});
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel model;
  //1
  model = new SliderModel(
      imagePath: 'assets/search.png',
      title: 'Find',
      desc: 'Find pictures you like');
  slides.add(model);

  //2
  model = new SliderModel(
      imagePath: 'assets/setwallpaper.png',
      title: 'Set wallpapers',
      desc: 'Set any image you like as your wallpaper');
  slides.add(model);

  //3
  model = new SliderModel(
      imagePath: 'assets/share.png',
      title: 'Share',
      desc: 'Share pictures directly to your favourite social media');
  slides.add(model);

  return slides;
}

class CategoryInfo {
  final int position;
  final String name;
  final String iconImage;
  final String description;
  final List<String> images;

  CategoryInfo(
    this.position, {
    this.name,
    this.iconImage,
    this.description,
    this.images,
  });
}

List<CategoryInfo> planets = [
  CategoryInfo(1,
      name: 'City',
      iconImage: 'assets/city.jpg',
      description: "Explore our beautiful pictures about landscape",
      images: [
        'https://cdn.pixabay.com/photo/2013/07/18/10/57/mercury-163610_1280.jpg',
        'https://cdn.pixabay.com/photo/2014/07/01/11/38/planet-381127_1280.jpg',
        'https://cdn.pixabay.com/photo/2015/06/26/18/48/mercury-822825_1280.png',
        'https://image.shutterstock.com/image-illustration/mercury-high-resolution-images-presents-600w-367615301.jpg'
      ]),
  CategoryInfo(2,
      name: 'Nature',
      iconImage: 'assets/nature.png',
      description: "Explore our beautiful pictures about textures",
      images: [
        'https://cdn.pixabay.com/photo/2011/12/13/14/39/venus-11022_1280.jpg',
        'https://image.shutterstock.com/image-photo/solar-system-venus-second-planet-600w-515581927.jpg'
      ]),
  CategoryInfo(3,
      name: 'Animals',
      iconImage: 'assets/animals.png',
      description: "Explore our beautiful pictures about nature",
      images: [
        'https://cdn.pixabay.com/photo/2011/12/13/14/31/earth-11015_1280.jpg',
        'https://cdn.pixabay.com/photo/2011/12/14/12/11/astronaut-11080_1280.jpg',
        'https://cdn.pixabay.com/photo/2016/01/19/17/29/earth-1149733_1280.jpg',
        'https://image.shutterstock.com/image-photo/3d-render-planet-earth-viewed-600w-1069251782.jpg'
      ]),
  CategoryInfo(4,
      name: 'Views',
      iconImage: 'assets/views.jpg',
      description: "Explore our beautiful pictures about cities ",
      images: []),
  CategoryInfo(5,
      name: 'Portrait',
      iconImage: 'assets/portrait.jpg',
      description: "Explore our beautiful pictures about portrait",
      images: []),
];
