import '../models/product.dart';
import '../models/category.dart';

final List<Category> categories = [
  Category(id: '1', name: 'Áo Thun', imageUrl: ''),
  Category(id: '2', name: 'Quần Jeans', imageUrl: ''),
  Category(id: '3', name: 'Mũ', imageUrl: ''),
  Category(id: '4', name: 'Áo Hoodie', imageUrl: ''),
  Category(id: '5', name: 'Balo', imageUrl: ''),
];

final List<Product> products = [
  Product(
    id: '1',
    name: 'Áo Thun Oversize Basic',
    category: 'Áo Thun',
    price: 299000,
    imageAsset: 'assets/images/ao.png',   // ← Thay bằng tên file thật của bạn
    description: 'Áo thun cotton cao cấp, form rộng, cực thoải mái, phù hợp mặc hàng ngày.',
    sizes: ['S', 'M', 'L', 'XL'],
    rating: 4.6,
    sold: 1240,
  ),
  Product(
    id: '2',
    name: 'Quần Jeans Nam Skinny',
    category: 'Quần Jeans',
    price: 450000,
    imageAsset: 'assets/images/quan_1.jpg',
    description: 'Quần jeans nam co giãn tốt, form skinny ôm dáng, chất liệu bền đẹp.',
    sizes: ['28', '30', '32', '34'],
    rating: 4.4,
    sold: 890,
  ),
  Product(
    id: '3',
    name: 'Mũ lưỡi trai local brand',
    category: 'Mũ',
    price: 890000,
    imageAsset: 'assets/images/mu_1.jpg',
    description: 'Giày sneakers phong cách cổ điển, êm ái, phù hợp với nhiều outfit.',
    sizes: ['Free Size'],
    rating: 4.8,
    sold: 650,
  ),
  Product(
    id: '4',
    name: 'Áo Hoodie Zip Oversize',
    category: 'Áo Hoodie',
    price: 399000,
    imageAsset: 'assets/images/ao_khoac.png',
    description: 'Áo hoodie nỉ ấm, form rộng thời trang, có khóa kéo tiện lợi.',
    sizes: ['M', 'L', 'XL'],
    rating: 4.5,
    sold: 420,
  ),
  Product(
    id: '5',
    name: 'Balo Thời Trang Unisex',
    category: 'Balo',
    price: 329000,
    imageAsset: 'assets/images/bag_1.jpg',
    description: 'Balo chống thấm nước, nhiều ngăn tiện lợi, phù hợp đi học và đi chơi.',
    sizes: ['One Size'],
    rating: 4.5,
    sold: 980,
  ),
  Product(
    id: '1',
    name: 'Áo Polo Nam Cao Cấp',
    category: 'Áo Thun',
    price: 329000,
    imageAsset: 'assets/images/ao_2.jpg',
    description: 'Áo polo nam cổ bẻ, chất vải thoáng mát, phù hợp đi làm và đi chơi.',
    sizes: ['S', 'M', 'L'],
    rating: 4.3,
    sold: 780,
  ),
];