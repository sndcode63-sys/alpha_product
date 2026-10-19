import 'package:alpha_field_app/imports.dart';

class CustomerListScreen extends GetView<CustomerController> {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.filtered;
      return AppScaffold(
        title: 'Customers',
        nav: true,
        children: [
          LabeledField('', hint: 'Search name, phone, area', onChanged: (v) => controller.query.value = v),
          FilterChips(const ['All', 'Vendor', 'Distributor', 'Retailer'], controller.category.value, (v) => controller.category.value = v),
          if (rows.isEmpty) const EmptyHint('No matching customers'),
          for (final c in rows)
            RowCard(c.name, sub: '${c.category} · ${c.address}', trailing: c.outstanding > 0 ? 'Due ${money(c.outstanding)}' : '', onTap: () => controller.open(c)),
        ],
      );
    });
  }
}
