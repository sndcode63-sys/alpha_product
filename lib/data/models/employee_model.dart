import '../../domain/entities/entities.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({super.id='', super.name='', super.phone='', super.empCode='', super.role='', super.manager='', super.territory=''});
  factory EmployeeModel.fromEntity(Employee e) => EmployeeModel(id: e.id, name: e.name, phone: e.phone, empCode: e.empCode, role: e.role, manager: e.manager, territory: e.territory);
  factory EmployeeModel.fromJson(Map<String, dynamic> j) => EmployeeModel(id: (j['id']??'').toString(), name: (j['name']??'').toString(), phone: (j['phone']??'').toString(), empCode: (j['empCode']??'').toString(), role: (j['role']??'').toString(), manager: (j['manager']??'').toString(), territory: (j['territory']??'').toString());
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone, 'empCode': empCode, 'role': role, 'manager': manager, 'territory': territory};
}
