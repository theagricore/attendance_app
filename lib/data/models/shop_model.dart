class ShopModel {
  final String shopId;
  final String shopName;
  final double latitude;
  final double longitude;
  final double radius;
  final DateTime createdAt;
  final String? imageUrl; 

  ShopModel({
    required this.shopId,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.createdAt,
    this.imageUrl, 
  });

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'imageUrl': imageUrl, 
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      shopId: map['shopId'] ?? '',
      shopName: map['shopName'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      radius: map['radius']?.toDouble() ?? 100.0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      imageUrl: map['imageUrl'], 
    );
  }
}