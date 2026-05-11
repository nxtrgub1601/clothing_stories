import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildProductImage(
    String imageUrl,
    String imageAsset, {
      double? height,
      double? width,
    }) {
  if (imageUrl.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => _buildErrorImage(height, width),
    );
  } else {
    return Image.asset(
      imageAsset,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildErrorImage(height, width),
    );
  }
}

Widget _buildErrorImage(double? height, double? width) {
  return Container(
    height: height,
    width: width,
    color: Colors.grey[200],
    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
  );
}