class Employee {
  final String id;
  final String name;
  final String phone;
  final String empCode;
  final String role;
  final String manager;
  final String territory;
  const Employee({this.id='', this.name='', this.phone='', this.empCode='', this.role='', this.manager='', this.territory=''});
  Employee copyWith({String? id, String? name, String? phone, String? empCode, String? role, String? manager, String? territory}) => Employee(id: id ?? this.id, name: name ?? this.name, phone: phone ?? this.phone, empCode: empCode ?? this.empCode, role: role ?? this.role, manager: manager ?? this.manager, territory: territory ?? this.territory);
}
