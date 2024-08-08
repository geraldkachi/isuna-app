import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:misau/models/tranx_list_model.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late TextEditingController _searchController;
  late List<Transaction> _filteredTransactions;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterTransactions);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _filteredTransactions = _authProvider.transactionList?.edges ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _authProvider.transactionList?.edges
              .where((transaction) {
                final category = transaction.income != null
                    ? 'Income'
                    : transaction.expense?.category ?? '';
                final facility = transaction.facility.toLowerCase();
                return category.toLowerCase().contains(query) ||
                       facility.contains(query);
              }).toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search transactions',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(11.5),
                      child: SvgPicture.asset(
                        'assets/search.svg',
                        color: Colors.black,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  style: const TextStyle(
                    fontSize: 15.0,
                    letterSpacing: -.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/export.svg',
                  height: 19,
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffDC1D3C),
                ),
                padding: const EdgeInsets.all(13),
                child: SvgPicture.asset(
                  'assets/add.svg',
                  height: 10,
                  width: 10,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: _filteredTransactions.length * 120.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _filteredTransactions.isEmpty
                ? Center(child: Text('No transactions found'))
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 25),
                    itemCount: _filteredTransactions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      final isIncome = transaction.income != null;
                      final amount = isIncome
                          ? "+NGN${transaction.income!.amount}"
                          : "-NGN${transaction.expense!.amount}";
                      final date = isIncome
                          ? transaction.income!.date.toLocal().toString().split(' ')[0]
                          : transaction.expense!.date.toLocal().toString().split(' ')[0];
                      final category = isIncome
                          ? "Income"
                          : transaction.expense!.category;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF4F4F7),
                            ),
                            padding: const EdgeInsets.all(11),
                            margin: const EdgeInsets.only(right: 13),
                            child: SvgPicture.asset(
                              isIncome
                                  ? 'assets/direction_up.svg'
                                  : 'assets/direction_down.svg',
                              height: 19,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Color(0xff1B1C1E),
                                    letterSpacing: -.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  transaction.facility,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xffABB5BC),
                                    letterSpacing: -.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                amount,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Color(0xff1B1C1E),
                                  letterSpacing: -.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xffABB5BC),
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(height: 13),
        ],
      ),
    );
  }
}
