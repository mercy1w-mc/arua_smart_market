enum UserRole { customer, farmer }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.farmer:
        return 'Farmer';
    }
  }

  String get description {
    switch (this) {
      case UserRole.customer:
        return 'Browse fresh produce from trusted local farmers.';
      case UserRole.farmer:
        return 'List your harvest and grow your farm business.';
    }
  }
}

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final UserRole role;
}