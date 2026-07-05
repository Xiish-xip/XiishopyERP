/// Xiishopy ERP - Shared Enums & Constants
/// Mirrors the backend enum values for consistency.
library;

/// User roles in the system
enum UserRole {
  distributor,
  retailer;

  String get databaseValue => name;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere((e) => e.name == value, orElse: () => UserRole.retailer);
  }
}

/// Countries supported by Xiishopy
enum Country {
  ke,
  tz,
  ug,
  rw;

  String get databaseValue => name.toUpperCase();
  String get displayName {
    switch (this) {
      case Country.ke: return 'Kenya';
      case Country.tz: return 'Tanzania';
      case Country.ug: return 'Uganda';
      case Country.rw: return 'Rwanda';
    }
  }
}

/// Supported languages
enum AppLanguage {
  en,
  sw,
  lg,
  fr;

  String get displayName {
    switch (this) {
      case AppLanguage.en: return 'English';
      case AppLanguage.sw: return 'Kiswahili';
      case AppLanguage.lg: return 'Luganda';
      case AppLanguage.fr: return 'Français';
    }
  }
}

/// Currencies supported
enum CurrencyCode {
  usd,
  kes,
  tzs,
  ugx,
  rwf;

  String get symbol {
    switch (this) {
      case CurrencyCode.usd: return r'\$';
      case CurrencyCode.kes: return 'KSh';
      case CurrencyCode.tzs: return 'TSh';
      case CurrencyCode.ugx: return 'USh';
      case CurrencyCode.rwf: return 'FRw';
    }
  }

  String get code => name.toUpperCase();
}

/// Order lifecycle statuses
enum OrderStatus {
  pending,
  paid,
  processing,
  shipped,
  delivered,
  cancelled;

  String get displayName => name[0].toUpperCase() + name.substring(1);
  String get databaseValue => name;
}

/// Payment providers
enum PaymentProvider {
  mpesa,
  airtelMoney,
  selcom,
  pesapal;

  String get displayName {
    switch (this) {
      case PaymentProvider.mpesa: return 'M-Pesa';
      case PaymentProvider.airtelMoney: return 'Airtel Money';
      case PaymentProvider.selcom: return 'Selcom';
      case PaymentProvider.pesapal: return 'PesaPal';
    }
  }
}

/// Payment statuses
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded;
}

/// Shipment tracking statuses
enum ShipmentStatus {
  pickedUp,
  inTransit,
  outForDelivery,
  delivered,
  exception;

  String get displayName {
    switch (this) {
      case ShipmentStatus.pickedUp: return 'Picked up';
      case ShipmentStatus.inTransit: return 'In Transit';
      case ShipmentStatus.outForDelivery: return 'Out for Delivery';
      case ShipmentStatus.delivered: return 'Delivered';
      case ShipmentStatus.exception: return 'Exception';
    }
  }
}

/// Carriers
enum Carrier {
  dhlAfrica,
  sendy,
  amitTrucking;

  String get displayName {
    switch (this) {
      case Carrier.dhlAfrica: return 'DHL Africa';
      case Carrier.sendy: return 'Sendy';
      case Carrier.amitTrucking: return 'Amit Trucking';
    }
  }
}