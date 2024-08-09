class Balances {
  final int? actualBalance;
  final int? pendingBalance;
  final int? totalBalance;

  Balances({
     this.actualBalance,
     this.pendingBalance,
     this.totalBalance,
  });

  // Convert JSON to Balances object
  factory Balances.fromJson(Map<String, dynamic> json) {
    return Balances(
      actualBalance: json['actualBalance'],
      pendingBalance: json['pendingBalance'],
      totalBalance: json['totalBalance'],
    );
  }

    // Convert Balances object to JSON
  Map<String, dynamic> toJson() {
    return {
      'actualBalance': actualBalance,
      'pendingBalance': pendingBalance,
      'totalBalance': totalBalance,
    };
  }
}
