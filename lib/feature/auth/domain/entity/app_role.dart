enum AppRole {
  productManager,
  buyer,
  finance,
}

AppRole appRoleFromValue(String? value) {
  switch (value) {
    case 'admin':
      return AppRole.productManager;
    case 'finanzas':
      return AppRole.finance;
    case 'compras':
    default:
      return AppRole.buyer;
  }
}

extension AppRoleX on AppRole {
  String get value {
    switch (this) {
      case AppRole.productManager:
        return 'admin';
      case AppRole.buyer:
        return 'compras';
      case AppRole.finance:
        return 'finanzas';
    }
  }

  String get label {
    switch (this) {
      case AppRole.productManager:
        return 'Productos';
      case AppRole.buyer:
        return 'Compras';
      case AppRole.finance:
        return 'Finanzas';
    }
  }

  bool get canManageProducts => this == AppRole.productManager;
  bool get canBuy => this == AppRole.buyer;
  bool get canViewFinance => this == AppRole.finance;
}
