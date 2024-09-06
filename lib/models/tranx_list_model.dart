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



class Transaction {
    final String? id;
    final Income? income;
    final Expense? expense;
    final String? addedBy;
    final String? facility;
    final String? ward;
    final String? lga;
    final String? state;
    final String? healthInstituteId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Transaction({
        this.id,
        this.income,
        this.expense,
        this.addedBy,
        this.facility,
        this.ward,
        this.lga,
        this.state,
        this.healthInstituteId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        income: json["income"] == null ? null : Income.fromJson(json["income"]),
        expense: json["expense"] == null ? null : Expense.fromJson(json["expense"]),
        addedBy: json["addedBy"],
        facility: json["facility"],
        ward: json["ward"],
        lga: json["lga"],
        state: json["state"],
        healthInstituteId: json["healthInstituteId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "income": income?.toJson(),
        "expense": expense?.toJson(),
        "addedBy": addedBy,
        "facility": facility,
        "ward": ward,
        "lga": lga,
        "state": state,
        "healthInstituteId": healthInstituteId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}

class Expense {
    final dynamic amount;
    final String? category;
    final String? subCategory;
    final DateTime? date;
    final List<Log>? log;
    final String? status;
    final String? reason;

    Expense({
        this.amount,
        this.category,
        this.subCategory,
        this.date,
        this.log,
        this.status,
        this.reason,
    });

    factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        amount: json["amount"],
        category: json["category"],
        subCategory: json["subCategory"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        log: json["log"] == null ? [] : List<Log>.from(json["log"]!.map((x) => Log.fromJson(x))),
        status: json["status"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "category": category,
        "subCategory": subCategory,
        "date": date?.toIso8601String(),
        "log": log == null ? [] : List<dynamic>.from(log!.map((x) => x.toJson())),
        "status": status,
        "reason": reason,
    };
}

class Log {
    final String? status;
    final String? reason;
    final String? adminId;
    final String? lastName;
    final String? firstName;
    final String? email;

    Log({
        this.status,
        this.reason,
        this.adminId,
        this.lastName,
        this.firstName,
        this.email,
    });

    factory Log.fromJson(Map<String, dynamic> json) => Log(
        status: json["status"],
        reason: json["reason"],
        adminId: json["adminId"],
        lastName: json["lastName"],
        firstName: json["firstName"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "reason": reason,
        "adminId": adminId,
        "lastName": lastName,
        "firstName": firstName,
        "email": email,
    };
}

class Income {
    final dynamic amount;
    final DateTime? date;
    final List<Log>? log;
    final String? status;
    final String? reason;

    Income({
        this.amount,
        this.date,
        this.log,
        this.status,
        this.reason,
    });

    factory Income.fromJson(Map<String, dynamic> json) => Income(
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        log: json["log"] == null ? [] : List<Log>.from(json["log"]!.map((x) => Log.fromJson(x))),
        status: json["status"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date?.toIso8601String(),
        "log": log == null ? [] : List<dynamic>.from(log!.map((x) => x.toJson())),
        "status": status,
        "reason": reason,
    };
}
