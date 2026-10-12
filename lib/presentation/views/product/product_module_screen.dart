import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/app_icon.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/models/product.dart';

class ProductModuleScreen extends GetView<ProductController> {
  const ProductModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        leading: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: AppIcon(size: 32.r),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsRow(),
              SizedBox(height: 20.h),
              _buildProductGrid(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.white, size: 24.r),
      ),
    );
  }

  Widget _buildStatsRow() {
    final products = controller.productList;
    final total = products.length;
    final inStock = products.where((p) => p.stock > 0).length;
    final lowStock = products.where((p) => p.stock > 0 && p.stock < 10).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total', total.toString(), AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('In Stock', inStock.toString(), AppColors.success),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('Low Stock', lowStock.toString(), AppColors.alert),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (controller.productList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No products yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
          children: controller.productList.map((product) {
            return _buildProductCard(
              product.name,
              product.sku,
              '₹${product.price.toStringAsFixed(0)}',
              product.stock,
              _getStockColor(product.stock),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    String name,
    String sku,
    String price,
    int stock,
    Color stockColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 40.r,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            sku,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            price,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.inventory, size: 14.r, color: AppColors.textHint),
              SizedBox(width: 4.w),
              Text(
                'Stock: $stock',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: stockColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStockColor(int stock) {
    if (stock == 0) return AppColors.alert;
    if (stock < 10) return AppColors.accentOrange;
    return AppColors.success;
  }

  void _showAddProductDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final skuCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: skuCtrl,
                decoration: const InputDecoration(
                  labelText: 'SKU',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty &&
                  skuCtrl.text.isNotEmpty &&
                  priceCtrl.text.isNotEmpty &&
                  stockCtrl.text.isNotEmpty) {
                final product = Product(
                  name: nameCtrl.text,
                  sku: skuCtrl.text,
                  price: double.tryParse(priceCtrl.text) ?? 0,
                  stock: int.tryParse(stockCtrl.text) ?? 0,
                  createdAt: DateTime.now().toIso8601String(),
                );
                controller.addProduct(product);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
