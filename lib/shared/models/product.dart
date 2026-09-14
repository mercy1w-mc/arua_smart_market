class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.farmer,
    required this.location,
    required this.imageUrl,
    required this.stock,
    this.description = '',
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String farmer;
  final String location;
  final String imageUrl;
  final int stock;
  final String description;
  final bool isFeatured;

  Product copyWith({int? stock}) {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      unit: unit,
      farmer: farmer,
      location: location,
      imageUrl: imageUrl,
      stock: stock ?? this.stock,
      description: description,
      isFeatured: isFeatured,
    );
  }
}

const demoProducts = <Product>[
  Product(
    id: 'tomatoes',
    name: 'Fresh Tomatoes',
    category: 'Vegetables',
    price: 5000,
    unit: 'kg',
    farmer: 'Green Valley Farm',
    location: 'Arua Hill',
    imageUrl:
        'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=800&q=80',
    stock: 100,
    description:
        'Sun-ripened tomatoes harvested this week from our family farm.',
    isFeatured: true,
  ),
  Product(
    id: 'maize',
    name: 'White Maize Grain',
    category: 'Grains',
    price: 2800,
    unit: 'kg',
    farmer: 'Ocea Farmers Co-op',
    location: 'Pakwach Road',
    imageUrl:
        'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=800&q=80',
    stock: 240,
    description: 'Clean, dry and carefully sorted maize grain for your home.',
    isFeatured: true,
  ),
  Product(
    id: 'avocado',
    name: 'Hass Avocados',
    category: 'Fruits',
    price: 7000,
    unit: 'basket',
    farmer: 'Nile Crest Gardens',
    location: 'Adumi',
    imageUrl:
        'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80',
    stock: 32,
    description: 'Creamy Hass avocados, packed fresh for local delivery.',
    isFeatured: true,
  ),
  Product(
    id: 'beans',
    name: 'Red Kidney Beans',
    category: 'Legumes',
    price: 4500,
    unit: 'kg',
    farmer: 'Arua Women Growers',
    location: 'Aroi',
    imageUrl:
        'https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=800&q=80',
    stock: 65,
    description: 'Nutritious red kidney beans from a local farmer collective.',
  ),
];