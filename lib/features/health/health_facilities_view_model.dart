import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/Income_expense_chart_model.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/audit_details.dart';
import 'package:isuna/models/balance_expense_model.dart';
import 'package:isuna/models/balance_income_model.dart';
import 'package:isuna/models/categories_model.dart';
import 'package:isuna/models/expense_category.dart';
import 'package:isuna/models/expense_payment_model.dart';
import 'package:isuna/models/facilities_model.dart';
import 'package:isuna/models/facility_balances_model.dart';
import 'package:isuna/models/income_analysis_model.dart';
import 'package:isuna/models/inflow_payment_model.dart';
import 'package:isuna/models/page_info_model.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/excel_service.dart';
import 'package:isuna/service/health_facilities_service.dart';
import 'package:isuna/service/shared_preference_service.dart';
import 'package:isuna/service/toast_service.dart';
import 'package:isuna/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final healthFacilitiesViemodelProvider =
    ChangeNotifierProvider.autoDispose<HealthFacilitiesViewModel>(
        (ref) => HealthFacilitiesViewModel());

class HealthFacilitiesViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();
  final SharedPreferenceService _sharedPreferenceService =
      getIt<SharedPreferenceService>();
  final ExcelService _excelService = getIt<ExcelService>();

  List<FacilitiesModel> get facilitiesModel =>
      _healthFacilitiesService.facilitiesModel ?? [];

  List<FacilitiesModel>? searchFacilities = [];

  FacilitiesModel? selectedFacility;

  List<AuditTrailsModel> get auditTrailsModel =>
      _healthFacilitiesService.auditTrailsModel ?? [];

  List<Transaction>? get transactions =>
      _healthFacilitiesService.transactionList?.edges;

  AdminModel get userData => _authService.userData ?? AdminModel();
  BalanceExpenseModel get balanceExpenseModel =>
      _healthFacilitiesService.balanceExpenseModel ?? BalanceExpenseModel();

  BalanceIncomeModel get balanceIncomeModel =>
      _healthFacilitiesService.balanceIncomeModel ?? BalanceIncomeModel();

  List<CategoriesModel> get categoriesModel =>
      _healthFacilitiesService.categoriesModel ?? [];

  FacilityBalancesModel get facilityBalancesModel =>
      _healthFacilitiesService.facilityBalancesModel ?? FacilityBalancesModel();

  IncomeAnalysis get incomeAnalysis =>
      _healthFacilitiesService.incomeAnalysis ?? IncomeAnalysis();

  PageInfoModel get pageInfoModel =>
      _healthFacilitiesService.pageInfoModel ?? PageInfoModel();

  ExpenseCategoryModel get expenseCategory =>
      _healthFacilitiesService.expenseCategoryModel ?? ExpenseCategoryModel();

  // PieChartModel? pieChartModel;
  // List<ChartData>? chartDataList = [];
  List<GraphChartData> graphChartData = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController transactionSearchController = TextEditingController();

  TextEditingController inflowAmountContoller = TextEditingController();
  String? inflowStatusValue;
  TextEditingController expenseAmountContoller = TextEditingController();
  TextEditingController reasonContoller = TextEditingController();
  RefreshController transactionController =
      RefreshController(initialRefresh: false);
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController facilitiesController =
      RefreshController(initialRefresh: false);

  int page = 0;

  String? expenseStatusValue;
  String? selectedCategory;
  String? selectedSubCategory;
  double? incomPercentageIncrease;

  final GlobalKey<FormState> inFlowFormKey = GlobalKey();
  final GlobalKey<FormState> expenseFormKey = GlobalKey();

  List<Transaction>? filteredTransactions = [];

  bool isLoading = false;
  bool onInit = false;
  bool hideAmounts = false;
  bool isReasonVisible = false;
  bool isShareLoading = false;

  DateTime now = DateTime.now();
  String get threeMonthsAgo => DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      .format(DateTime(now.year, now.month - 3, now.day));

  Future<void> onBuild(context) async {
    // getAuditTrails(context);
    Future(() {
      hideAmounts =
          _sharedPreferenceService.getBool('isFacilityAmountHidden') ?? false;
      notifyListeners();
    });
    await facilitiesBalances(context);
    await fetchFacilityTransactionList(context, next: '');
    await fetchCategories(context);
    await getBalanceIncome(context);
    await getExpenseIncome(context);
    await fetchExpenseCategory(context);
    await fetchIncome(context);
  }

  void logout() => _authService.logout();

  void clearExpenseFields() {
    expenseAmountContoller.text = '';
    selectedCategory = null;
  }

  void clearInflowFields() {
    inflowAmountContoller.text = '';
  }

  void onRefreshFacility(context) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    transactionSearchController.clear();
    onBuild(context);
    refreshController.refreshCompleted();
    transactionController.refreshCompleted();
  }

  void onLoadingFacility() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    refreshController.loadComplete();
    transactionController.loadComplete();
  }

  double calculatePercentage(dynamic incomeDiff) {
    double baseValue = 1000000;
    return (incomeDiff / baseValue.toInt()) * 100;
  }

  void populateGraphChart() {
    for (int i = 0; i < balanceIncomeModel.categories!.length; i++) {
      String category = balanceIncomeModel.categories![i];
      double income = balanceIncomeModel.data![i].toDouble();
      double expense = balanceExpenseModel.data![i].toString() != "null"
          ? double.parse(balanceExpenseModel.data![i])
          : 0.0;

      graphChartData.add(GraphChartData(category, income, expense));
    }
  }

  void onLoadingTransactions(context) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    fetchFacilityTransactionList(context,
        next: _healthFacilitiesService.transactionList!.pageInfo.endCursor);
    transactionController.loadComplete();
  }

  void onRefreshHealthFacilities(context) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    fetchFacilitiesPagnated(context, next: '');
    facilitiesController.refreshCompleted();
  }

  void onLoadingHealthFacilities(context) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    fetchFacilitiesPagnated(context,
        next: pageInfoModel.hasNextPage! ? pageInfoModel.endCursor : '');
    facilitiesController.loadComplete();
  }

  void toggleAmountVisibility() {
    hideAmounts = !hideAmounts;
    _sharedPreferenceService.setBool('isFacilityAmountHidden', hideAmounts);
    notifyListeners();
  }

  void searchFacilitiesName(context) {
    fetchFacilitiesPagnated(context, search: searchController.text);
  }

  void filterTransactions() {
    final query = transactionSearchController.text.toLowerCase().trim();
    if (transactionSearchController.text.isEmpty) {
      filteredTransactions =
          _healthFacilitiesService.transactionList?.edges ?? [];
    }
    filteredTransactions =
        _healthFacilitiesService.transactionList?.edges.where((transaction) {
              final category = transaction.income != null
                  ? 'Income'
                  : transaction.expense?.category ?? '';
              final facility = transaction.facility.toLowerCase();
              final date = transaction.createdAt;
              final state = transaction.state;
              final amount = transaction.income?.amount == null
                  ? transaction.expense?.amount
                  : transaction.income?.amount;
              return category.toLowerCase().contains(query) ||
                  facility.contains(query) ||
                  date.toString().contains(query) ||
                  state.contains(query) ||
                  amount.toString().contains(query);
            }).toList() ??
            [];
    notifyListeners();
  }

  Future<void> fetchFacilities(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilities();
      searchFacilities = facilitiesModel;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      onInit = true;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stack) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');

      debugPrint('fetch facilities error: $e\ns$stack');
    }
  }

  Future<void> fetchFacilitiesPagnated(context,
      {String? next = '', String search = ''}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilitiesPagnated(
          next: next, search: search);
      searchFacilities?.clear();
      searchFacilities?.addAll(facilitiesModel);
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      onInit = true;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stack) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');

      debugPrint('fetch facilities pagnated error: $e\ns$stack');
    }
  }

  void getFilteredFacilities() {
    if (searchController.text.isEmpty) {
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
    }
    searchFacilities =
        _healthFacilitiesService.facilitiesModel?.where((facility) {
      return facility.name!
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> getAuditTrails(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getAuditTrails(selectedFacility!.name!,
          selectedFacility!.state!, selectedFacility!.lga!);
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;

      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> fetchCategories(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchCategories();
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stack) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch categories error: $e\ns$stack');
    }
  }

  Future<void> fetchIncome(context,
      {String? state = '',
      String? lga = '',
      String? facility = '',
      String? fromDate = '',
      String? toDate = ''}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchIncome(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      incomPercentageIncrease = calculatePercentage(incomeAnalysis.incomeDiff);
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fecth income error ${e.toString()}/n $stackTrace');
    }
  }

  Future<void> fetchExpenseCategory(
    context,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchExpenseCategory(
        state: selectedFacility!.state,
        lga: selectedFacility!.lga,
        facility: selectedFacility!.name,
      );
      // pieChartModel = PieChartModel.fromExpenseCategoryModel(expenseCategory);
      // chartDataList = convertToChartData(pieChartModel!);
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error',
          subTitle: 'fecth expense category error ${e.toString()}');
    }
  }

  Future<void> facilitiesBalances(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getFacilitiesBalances(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!);
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch facilities balances error: $e\ns$stackTrace');
    }
  }

  Future<void> getBalanceIncome(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getBalanceIncome(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!,
          threeMonthsAgo,
          now.toUtc().toIso8601String());
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch balance income error: $e\ns$stackTrace');
    }
  }

  Future<void> getExpenseIncome(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getBalanceExpense(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!,
          threeMonthsAgo,
          now.toUtc().toIso8601String());
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      populateGraphChart();
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch expence income error: $e\ns$stackTrace');
    }
  }

  Future<void> fetchFacilityTransactionList(context, {String? next}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilityTransactionList(
          facility: selectedFacility!.name!,
          state: selectedFacility!.state!,
          lga: selectedFacility!.lga!,
          search: transactionSearchController.text.isEmpty
              ? ''
              : transactionSearchController.text,
          limit: '',
          prev: '',
          next: next);
      filteredTransactions?.clear();
      filteredTransactions
          ?.addAll(_healthFacilitiesService.transactionList?.edges ?? []);
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stack) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error',
          subTitle: 'facility transaction error: ${e.toString}');
      debugPrint('facility transaction error $stack');
    }
  }

  Future<void> addInflowPayment(context) async {
    if (inFlowFormKey.currentState!.validate()) {
      inFlowFormKey.currentState!.save();
      try {
        Utils.showLoadingDialog(context);
        final List<IncomeData> income = [];
        IncomeData incomeData = IncomeData(
            amount: inflowAmountContoller.text, date: DateTime.now());

        income.add(incomeData);

        InflowPaymentModel inflowPaymentModel = InflowPaymentModel(
            state: selectedFacility?.state,
            ward: selectedFacility?.ward,
            facility: selectedFacility?.name,
            incomeAmount: inflowAmountContoller.text,
            incomeDate: DateTime.now(),
            lga: selectedFacility?.lga,
            status: inflowStatusValue?.toLowerCase(),
            income: income);

        await _healthFacilitiesService.addInflow(inflowPaymentModel);
        router.pop();
        router.pop();
        onBuild(context);
        _toastService.showToast(context,
            title: 'Success',
            subTitle: 'Payment added succefully.',
            type: ToastType.success);
      } on MisauException catch (e) {
        // TODO
        isLoading = false;
        notifyListeners();
        _toastService.showToast(context,
            title: 'Error', subTitle: e.message ?? '');
      } catch (e, stackTrace) {
        isLoading = false;
        notifyListeners();
        _toastService.showToast(context,
            title: 'Error', subTitle: 'Something went wrong.');

        debugPrint('add inflow error $e/n $stackTrace');
      }
    }
  }

  Future<void> addExpensePayment(context) async {
    if (expenseFormKey.currentState!.validate()) {
      expenseFormKey.currentState!.save();
      try {
        Utils.showLoadingDialog(context);
        final List<ExpenseData> expense = [];
        ExpenseData expenseData = ExpenseData(
            status: expenseStatusValue,
            reason: reasonContoller.text,
            date: DateTime.now(),
            category: selectedCategory,
            amount: expenseAmountContoller.text,
            subCategory: selectedSubCategory);

        expense.add(expenseData);

        ExpensePaymentModel expensePaymentModel = ExpensePaymentModel(
            state: selectedFacility?.state,
            ward: selectedFacility?.ward,
            facility: selectedFacility?.name,
            lga: selectedFacility?.lga,
            expense: expense);

        await _healthFacilitiesService.addExpense(expensePaymentModel);
        router.pop();
        router.pop();
        onBuild(context);
        _toastService.showToast(context,
            title: 'Success',
            subTitle: 'Payment added succefully.',
            type: ToastType.success);
      } on MisauException catch (e) {
        // TODO
        isLoading = false;
        notifyListeners();
        _toastService.showToast(context,
            title: 'Error', subTitle: e.message ?? '');
      } catch (e, stackTrace) {
        isLoading = false;
        notifyListeners();
        _toastService.showToast(context,
            title: 'Error', subTitle: 'Something went wrong.');

        debugPrint('add inflow error $e/n $stackTrace');
      }
    }
  }

  Future<void> shareTransactionSheet(context,
      {String state = '', String lga = ''}) async {
    try {
      isShareLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilityTransactionList(
          facility: selectedFacility?.name,
          state: state,
          lga: lga,
          prev: '',
          next: '',
          search: '',
          limit:
              _healthFacilitiesService.transactionList?.totalCount.toString());
      isShareLoading = false;
      _excelService.shareTransaction(transactions!,
          facility: selectedFacility?.name);
      notifyListeners();
    } on MisauException catch (e) {
      // TODO
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'share error', subTitle: 'Something went wrong.');
      debugPrint('share error $e/n$stackTrace');
    }
  }

  // void getAuditTrails(){

  //          Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HealthDetails()),
  //       );
  // }
}
