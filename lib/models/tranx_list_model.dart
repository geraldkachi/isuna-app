class TransactionList {
  final List<Transaction> edges;
  final PageInfo pageInfo;
  final int totalCount;

  TransactionList({
    required this.edges,
    required this.pageInfo,
    required this.totalCount,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      edges:
          (json['edges'] as List).map((e) => Transaction.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'edges': edges.map((e) => e.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
      'totalCount': totalCount,
    };
  }
}

class PageInfo {
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String startCursor;
  final String endCursor;

  PageInfo({
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.startCursor,
    required this.endCursor,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
      startCursor: json['startCursor'] ?? '',
      endCursor: json['endCursor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'startCursor': startCursor,
      'endCursor': endCursor,
    };
  }
}

class Expense {
  final double amount;
  final String? category;
  final String subCategory;
  final DateTime date;

  Expense({
    required this.amount,
    required this.category,
    required this.subCategory,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: double.parse(json['amount']),
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'subCategory': subCategory,
      'date': date.toIso8601String(),
    };
  }
}

class Income {
  final double amount;
  final DateTime date;

  Income({
    required this.amount,
    required this.date,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      amount: double.parse(json['amount']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

class Transaction {
  final String id;
  final Income? income;
  final Expense? expense;
  final String addedBy;
  final String facility;
  final String ward;
  final String lga;
  final String state;
  final String healthInstituteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Transaction({
    required this.id,
    this.income,
    this.expense,
    required this.addedBy,
    required this.facility,
    required this.ward,
    required this.lga,
    required this.state,
    required this.healthInstituteId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      income: json['income'] != null ? Income.fromJson(json['income']) : null,
      expense:
          json['expense'] != null ? Expense.fromJson(json['expense']) : null,
      addedBy: json['addedBy'],
      facility: json['facility'],
      ward: json['ward'],
      lga: json['lga'],
      state: json['state'],
      healthInstituteId: json['healthInstituteId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'income': income?.toJson(),
      'expense': expense?.toJson(),
      'addedBy': addedBy,
      'facility': facility,
      'ward': ward,
      'lga': lga,
      'state': state,
      'healthInstituteId': healthInstituteId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
