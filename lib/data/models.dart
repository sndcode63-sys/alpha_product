import 'package:flutter/material.dart';

import '../core/app_theme.dart';

enum UserRole { admin, delivery, sales }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Admin / Manager',
        UserRole.delivery => 'Delivery Driver',
        UserRole.sales => 'Order Booking',
      };

  String get shortCode => switch (this) {
        UserRole.admin => 'ADMIN',
        UserRole.delivery => 'DRIVER',
        UserRole.sales => 'Order',
      };

  Color get color => switch (this) {
        UserRole.admin => AppColors.primary,
        UserRole.delivery => AppColors.info,
        UserRole.sales => AppColors.success,
      };

  IconData get icon => switch (this) {
        UserRole.admin => Icons.admin_panel_settings_outlined,
        UserRole.delivery => Icons.local_shipping_outlined,
        UserRole.sales => Icons.point_of_sale_outlined,
      };
}

class UserProfile {
  final String empId;
  final String name;
  final String email;
  final String mobile;
  final UserRole role;
  final String defaultPassword;

  const UserProfile({
    required this.empId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.defaultPassword,
  });
}

enum DeliveryStatus { pending, inTransit, completed }

extension DeliveryStatusX on DeliveryStatus {
  String get label => switch (this) {
        DeliveryStatus.pending => 'Pending',
        DeliveryStatus.inTransit => 'In Transit',
        DeliveryStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        DeliveryStatus.pending => AppColors.warning,
        DeliveryStatus.inTransit => AppColors.primary,
        DeliveryStatus.completed => AppColors.success,
      };
}

class DeliveryItem {
  final String name;
  final int qty;
  final String unit;
  const DeliveryItem(this.name, this.qty, this.unit);
}

class Delivery {
  final String id;
  final String customer;
  final String contact;
  final String phone;
  final String address;
  final String slot;
  final double distanceKm;
  final List<DeliveryItem> items;
  DeliveryStatus status;
  // completion data (submit ke baad bharta hai)
  List<int>? deliveredQty;
  String remarks = '';
  DateTime? completedAt;
  bool proofPhoto = false;
  List<List<Offset>> signature = [];

  Delivery({
    required this.id,
    required this.customer,
    required this.contact,
    required this.phone,
    required this.address,
    required this.slot,
    required this.distanceKm,
    required this.items,
    this.status = DeliveryStatus.pending,
  });

  int get totalQty => items.fold(0, (a, b) => a + b.qty);
}

class AttendanceRecord {
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final Duration worked;
  final String status;
  const AttendanceRecord(this.date, this.checkIn, this.checkOut, this.worked, this.status);
}

class LocationPoint {
  final DateTime time;
  final String place;
  final double km;
  const LocationPoint(this.time, this.place, this.km);
}

class Product {
  final String name;
  final String sku;
  final String unit;
  final double price;
  const Product(this.name, this.sku, this.unit, this.price);
}

class Trip {
  final String id;
  final DateTime date;
  final String start;
  final String end;
  final double km;
  final int deliveries;
  final Duration duration;
  const Trip(this.id, this.date, this.start, this.end, this.km, this.deliveries, this.duration);
}

class OrderLine {
  final String name;
  final int qty;
  final double price;
  const OrderLine(this.name, this.qty, this.price);
  double get total => qty * price;
}

class Order {
  final String id;
  final String customer;
  final DateTime date;
  final String status; // Placed / Confirmed / Dispatched / Delivered
  final List<OrderLine> lines;
  const Order(this.id, this.customer, this.date, this.status, this.lines);
  double get total => lines.fold(0.0, (a, b) => a + b.total);
  int get totalQty => lines.fold(0, (a, b) => a + b.qty);
}

/// Dummy data — replace with REST API responses.
class MockData {
  static List<UserProfile> mockUsers() => const [
        UserProfile(
          empId: 'EMP-0142',
          name: 'Rakesh Kumar',
          email: 'rakesh.kumar@alphaproducts.in',
          mobile: '+91 98765 43210',
          role: UserRole.delivery,
          defaultPassword: '1234',
        ),
        UserProfile(
          empId: 'SALE-0088',
          name: 'Vikram Singh',
          email: 'vikram.singh@alphaproducts.in',
          mobile: '+91 98111 22334',
          role: UserRole.sales,
          defaultPassword: '1234',
        ),
        UserProfile(
          empId: 'ADMIN-001',
          name: 'Amit Sharma',
          email: 'amit.sharma@alphaproducts.in',
          mobile: '+91 99887 76655',
          role: UserRole.admin,
          defaultPassword: '1234',
        ),
      ];

  static List<Delivery> deliveries() => [
        Delivery(
          id: 'DLV-1021',
          customer: 'Shree Ganesh Traders',
          contact: 'Mahesh Patil',
          phone: '+91 98220 11234',
          address: 'Shop 12, Market Yard, Gultekdi, Pune 411037',
          slot: '10:00 AM - 11:00 AM',
          distanceKm: 6.4,
          items: const [DeliveryItem('Alpha Mustard Oil 1L', 24, 'Box'), DeliveryItem('Alpha Basmati Rice 5kg', 40, 'Bag')],
        ),
        Delivery(
          id: 'DLV-1022',
          customer: 'Om Sai Super Mart',
          contact: 'Sunil Deshmukh',
          phone: '+91 98900 45678',
          address: 'Plot 7, Hadapsar Industrial Estate, Pune 411013',
          slot: '12:00 PM - 01:00 PM',
          distanceKm: 11.2,
          items: const [DeliveryItem('Alpha Wheat Flour 10kg', 30, 'Bag'), DeliveryItem('Alpha Sugar 1kg', 100, 'Pack')],
        ),
        Delivery(
          id: 'DLV-1023',
          customer: 'Balaji Kirana Store',
          contact: 'Rajesh Jain',
          phone: '+91 97300 99887',
          address: '45, Station Road, Kondhwa, Pune 411048',
          slot: '02:30 PM - 03:30 PM',
          distanceKm: 15.8,
          items: const [DeliveryItem('Alpha Tea 500g', 60, 'Pack'), DeliveryItem('Alpha Salt 1kg', 80, 'Pack'), DeliveryItem('Alpha Toor Dal 1kg', 50, 'Pack')],
        ),
        Delivery(
          id: 'DLV-1019',
          customer: 'Krishna Departmental',
          contact: 'Anil Kulkarni',
          phone: '+91 99220 33221',
          address: 'Shop 3, Camp Road, Pune 411001',
          slot: '08:30 AM - 09:30 AM',
          distanceKm: 4.1,
          items: const [DeliveryItem('Alpha Mustard Oil 1L', 12, 'Box')],
          status: DeliveryStatus.completed,
        )
          ..deliveredQty = [12]
          ..remarks = 'Owner ko deliver kiya, sab theek tha'
          ..completedAt = DateTime.now().subtract(const Duration(hours: 3))
          ..proofPhoto = true
          ..signature = [
            [const Offset(10, 40), const Offset(30, 10), const Offset(50, 45), const Offset(70, 15), const Offset(95, 40)],
          ],
      ];

  static List<AttendanceRecord> attendance() => [
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 1)), '09:02 AM', '06:15 PM', const Duration(hours: 9, minutes: 13), 'Present'),
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 2)), '09:10 AM', '06:05 PM', const Duration(hours: 8, minutes: 55), 'Present'),
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 3)), '09:45 AM', '06:00 PM', const Duration(hours: 8, minutes: 15), 'Late'),
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 4)), '--', '--', Duration.zero, 'Absent'),
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 5)), '08:58 AM', '06:20 PM', const Duration(hours: 9, minutes: 22), 'Present'),
        AttendanceRecord(DateTime.now().subtract(const Duration(days: 6)), '09:05 AM', '02:10 PM', const Duration(hours: 5, minutes: 5), 'Half Day'),
      ];

  static List<Product> products() => const [
        Product('Alpha Mustard Oil 1L', 'ALP-001', 'Box', 1450),
        Product('Alpha Basmati Rice 5kg', 'ALP-002', 'Bag', 620),
        Product('Alpha Wheat Flour 10kg', 'ALP-003', 'Bag', 410),
        Product('Alpha Sugar 1kg', 'ALP-004', 'Pack', 46),
        Product('Alpha Tea 500g', 'ALP-005', 'Pack', 215),
        Product('Alpha Toor Dal 1kg', 'ALP-006', 'Pack', 142),
      ];

  static List<Trip> trips() => [
        Trip('TRP-0031', DateTime.now().subtract(const Duration(days: 1)), '09:20 AM', '05:45 PM', 58.2, 5, const Duration(hours: 8, minutes: 25)),
        Trip('TRP-0030', DateTime.now().subtract(const Duration(days: 2)), '09:35 AM', '04:50 PM', 44.7, 4, const Duration(hours: 7, minutes: 15)),
        Trip('TRP-0029', DateTime.now().subtract(const Duration(days: 3)), '10:05 AM', '05:10 PM', 36.1, 3, const Duration(hours: 7, minutes: 5)),
        Trip('TRP-0028', DateTime.now().subtract(const Duration(days: 5)), '09:15 AM', '06:00 PM', 63.9, 6, const Duration(hours: 8, minutes: 45)),
      ];

  static List<Order> orders() => [
        Order('ORD-5012', 'Shree Ganesh Traders', DateTime.now().subtract(const Duration(days: 1)), 'Confirmed',
            const [OrderLine('Alpha Tea 500g', 20, 215), OrderLine('Alpha Sugar 1kg', 30, 46)]),
        Order('ORD-5009', 'Om Sai Super Mart', DateTime.now().subtract(const Duration(days: 3)), 'Dispatched',
            const [OrderLine('Alpha Wheat Flour 10kg', 15, 410)]),
        Order('ORD-5001', 'Krishna Departmental', DateTime.now().subtract(const Duration(days: 6)), 'Delivered',
            const [OrderLine('Alpha Mustard Oil 1L', 10, 1450), OrderLine('Alpha Toor Dal 1kg', 25, 142)]),
      ];
}
