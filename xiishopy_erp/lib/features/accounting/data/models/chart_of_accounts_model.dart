/// Xiishopy ERP - Chart of Accounts Model
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class ChartOfAccountsModel extends Equatable {
  final String id;
  final String accountCode;
  final String accountName;
  final String type; // Asset, Liability, Equity, Revenue, Expense
  final String subtype;
  final String? description;
  final double balance;
  final bool isActive;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChartOfAccountsModel({
    required this.id,
    required this.accountCode,
    required this.accountName,
    required this.type,
    this.subtype = '',
    this.description,
    this.balance = 0.0,
    this.isActive = true,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChartOfAccountsModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ChartOfAccountsModel(
      id: docId,
      accountCode: data['accountCode'] as String? ?? '',
      accountName: data['accountName'] as String? ?? '',
      type: data['type'] as String? ?? 'Asset',
      subtype: data['subtype'] as String? ?? '',
      description: data['description'] as String?,
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: data['isActive'] as bool? ?? true,
      parentId: data['parentId'] as String?,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'accountCode': accountCode,
    'accountName': accountName,
    'type': type,
    'subtype': subtype,
    'description': description,
    'balance': balance,
    'isActive': isActive,
    'parentId': parentId,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  ChartOfAccountsModel copyWith({
    String? accountCode,
    String? accountName,
    String? type,
    String? subtype,
    String? description,
    double? balance,
    bool? isActive,
    String? parentId,
  }) {
    return ChartOfAccountsModel(
      id: id,
      accountCode: accountCode ?? this.accountCode,
      accountName: accountName ?? this.accountName,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      description: description ?? this.description,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, accountCode, accountName, type, balance];
}

class JournalEntryModel extends Equatable {
  final String id;
  final String entryNumber;
  final DateTime entryDate;
  final String description;
  final List<JournalLineItem> lines;
  final double totalDebit;
  final double totalCredit;
  final String status; // Draft, Posted, Reversed
  final String? postedBy;
  final DateTime? postedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntryModel({
    required this.id,
    required this.entryNumber,
    required this.entryDate,
    this.description = '',
    this.lines = const [],
    this.totalDebit = 0.0,
    this.totalCredit = 0.0,
    this.status = 'Draft',
    this.postedBy,
    this.postedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntryModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final linesData = data['lines'] as List<dynamic>? ?? [];
    return JournalEntryModel(
      id: docId,
      entryNumber: data['entryNumber'] as String? ?? '',
      entryDate: safeToDate(data['entryDate']),
      description: data['description'] as String? ?? '',
      lines: linesData.map((l) => JournalLineItem.fromMap(l as Map<String, dynamic>)).toList(),
      totalDebit: (data['totalDebit'] as num?)?.toDouble() ?? 0.0,
      totalCredit: (data['totalCredit'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Draft',
      postedBy: data['postedBy'] as String?,
      postedAt: safeToDate(data['postedAt']),
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'entryNumber': entryNumber,
    'entryDate': entryDate.toIso8601String(),
    'description': description,
    'lines': lines.map((l) => l.toMap()).toList(),
    'totalDebit': totalDebit,
    'totalCredit': totalCredit,
    'status': status,
    'postedBy': postedBy,
    'postedAt': postedAt?.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [id, entryNumber, status, totalDebit, totalCredit];
}

class JournalLineItem extends Equatable {
  final String accountId;
  final String accountName;
  final String accountCode;
  final double debit;
  final double credit;
  final String? description;

  const JournalLineItem({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    this.debit = 0.0,
    this.credit = 0.0,
    this.description,
  });

  factory JournalLineItem.fromMap(Map<String, dynamic> data) {
    return JournalLineItem(
      accountId: data['accountId'] as String? ?? '',
      accountName: data['accountName'] as String? ?? '',
      accountCode: data['accountCode'] as String? ?? '',
      debit: (data['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (data['credit'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'accountId': accountId,
    'accountName': accountName,
    'accountCode': accountCode,
    'debit': debit,
    'credit': credit,
    'description': description,
  };

  @override
  List<Object?> get props => [accountId, debit, credit];
}

class GeneralLedgerModel extends Equatable {
  final String id;
  final String accountId;
  final String accountName;
  final String accountCode;
  final String entryId;
  final String entryNumber;
  final DateTime entryDate;
  final String description;
  final double debit;
  final double credit;
  final double runningBalance;
  final String type; // Asset, Liability, Equity, Revenue, Expense
  final DateTime createdAt;

  const GeneralLedgerModel({
    required this.id,
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    required this.entryId,
    required this.entryNumber,
    required this.entryDate,
    this.description = '',
    this.debit = 0.0,
    this.credit = 0.0,
    this.runningBalance = 0.0,
    this.type = 'Asset',
    required this.createdAt,
  });

  factory GeneralLedgerModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return GeneralLedgerModel(
      id: docId,
      accountId: data['accountId'] as String? ?? '',
      accountName: data['accountName'] as String? ?? '',
      accountCode: data['accountCode'] as String? ?? '',
      entryId: data['entryId'] as String? ?? '',
      entryNumber: data['entryNumber'] as String? ?? '',
      entryDate: safeToDate(data['entryDate']),
      description: data['description'] as String? ?? '',
      debit: (data['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (data['credit'] as num?)?.toDouble() ?? 0.0,
      runningBalance: (data['runningBalance'] as num?)?.toDouble() ?? 0.0,
      type: data['type'] as String? ?? 'Asset',
      createdAt: safeToDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'accountId': accountId,
    'accountName': accountName,
    'accountCode': accountCode,
    'entryId': entryId,
    'entryNumber': entryNumber,
    'entryDate': entryDate.toIso8601String(),
    'description': description,
    'debit': debit,
    'credit': credit,
    'runningBalance': runningBalance,
    'type': type,
  };

  @override
  List<Object?> get props => [id, accountId, entryNumber, debit, credit, runningBalance];
}