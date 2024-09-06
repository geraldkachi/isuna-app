import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/features/main_screen/main_screen_view_model.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/balances_model.dart';
import 'package:isuna/models/expense_analysis_model.dart';
import 'package:isuna/models/expense_category.dart';
import 'package:isuna/models/expense_category_and%20_sub_category_model.dart';
import 'package:isuna/models/expense_category_extract_model.dart';
import 'package:isuna/models/expense_graph_model.dart';
import 'package:isuna/models/facilities_model.dart';
import 'package:isuna/models/income_analysis_model.dart';
import 'package:isuna/models/income_graph_model.dart';
import 'package:isuna/models/lga_model.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/models/state_model.dart';
import 'package:isuna/models/states_and_lga_model.dart';
import 'package:isuna/models/summary_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/dashboard_service.dart';
import 'package:isuna/service/excel_service.dart';
import 'package:isuna/service/health_facilities_service.dart';
import 'package:isuna/service/navigator_service.dart';
import 'package:isuna/service/profile_service.dart';
import 'package:isuna/service/shared_preference_service.dart';
import 'package:isuna/service/state_and_lga_service.dart';
import 'package:isuna/service/toast_service.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final homeViemodelProvider =
    ChangeNotifierProvider.autoDispose<HomeViemodel>((ref) => HomeViemodel());

class HomeViemodel extends ChangeNotifier {
  final DashboardService _dashboardService = getIt<DashboardService>();
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final StateAndLgaService _stateAndLgaService = getIt<StateAndLgaService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final SharedPreferenceService _sharedPreferenceService =
      getIt<SharedPreferenceService>();
  final ExcelService _excelService = getIt<ExcelService>();

  List<StatesAndLgaModel>? get stateAndLgaModel =>
      _stateAndLgaService.statesAndLgaModel;

  List<StateModel>? get stateModel => _stateAndLgaService.stateModel ?? [];

  List<LgaModel>? get lgaModel => _stateAndLgaService.lgaModel ?? [];

  List<FacilitiesModel> get facilitiesModel =>
      _healthFacilitiesService.facilitiesModel ?? [];

  AdminModel get userData => _authService.userData ?? AdminModel();
  Balances get balances => _dashboardService.balances ?? Balances();
  IncomeAnalysis get incomeAnalysis =>
      _dashboardService.incomeAnalysis ?? IncomeAnalysis();
  ExpenseAnalysis get expenseAnalysis =>
      _dashboardService.expenseAnalysis ?? ExpenseAnalysis();
  ExpenseCategoryModel get expenseCategory =>
      _dashboardService.expenseCategoryModel ?? ExpenseCategoryModel();
  ExpenseCategoryAndSubCategoryModel get expenseCategoryAndSubCategoryModel =>
      _dashboardService.expenseCategoryAndSubCategoryModel ??
      ExpenseCategoryAndSubCategoryModel();
  List<IncomeGraphModel>? get incomeGraphModel =>
      _dashboardService.incomeGraphModel;
  List<ExpenseGraphModel>? get expenseGraphModel =>
      _dashboardService.expenseGraphModel;
  SummaryModel get summaryModel =>
      _dashboardService.summaryModel ?? SummaryModel();
  // PieChartModel? pieChartModel;
  // List<ChartData>? chartDataList;
  List<CategoryData>? get categoryDataList =>
      _dashboardService.categoryDataList;
  CategoryData? selectedCategory;

  TextEditingController searchController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  SingleValueDropDownController searchfacilityController =
      SingleValueDropDownController();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RefreshController transactionRefreshController =
      RefreshController(initialRefresh: false);

  List<Transaction>? filteredTransactions = [];
  Transaction? selectedTransaction;
  List<String> states = [];
  TransactionList get transactionList => _dashboardService.transactionList!;

  List<String> stateLga = [];

  double? incomePercentageIncrease;
  double? expensePercentageDecrease;

  String? selectedState;
  String? selectedLga;
  String? fromDate;
  String? toDate;

  String? selectedIncomeChartType = 'Line';
  String? selectedExpenseChartType = 'Line';
  String? statusValue = '';

  bool isStatusWidget = false;
  bool isResolved = false;
  bool isStatusDropdown = false;
  double bottomSheetHeight = 0.82;

  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? get selectedFacility => searchfacilityController.dropDownValue?.value;

  bool isLoadingBooking = false;
  bool isLoadingTransaction = false;
  bool isLoadingIncomeAnalysis = false;
  bool isLoadingExpenseAnalysis = false;
  bool isLoadingExpenseCategory = false;
  bool isLoadingSummary = false;
  bool isLoadingFacilities = false;

  bool isShareLoading = false;
  bool isDeleted = false;
  bool isShowDeleted = false;
  bool isStatus = false;

  bool onInit = false;
  bool hideAmounts = false;
  bool isReasonVisible = false;

  int? screenIndex;

  List<String>? get facilitiesList =>
      facilitiesModel.map((value) => value.name as String).toList();

  List<String>? lgaList = [];

  DateTime now = DateTime.now();
  String get threeMonthsAgo => DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      .format(DateTime(now.year, now.month - 12, now.day));

  Future<void> fetchWalletData(context,
      {String? state = '',
      String? lga = '',
      String? facilitys = '',
      String? fromDate = '',
      String? toDate = '',
      String? prev = '',
      String? next = ''}) async {
    Future(() {
      hideAmounts = _sharedPreferenceService.getBool('isAmountHidden') ?? false;
      notifyListeners();
    });

    states = NigerianStatesAndLGA.allStates;
    filteredTransactions?.clear();

    fetchBalances(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    fetchIncome(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate!.isEmpty ? threeMonthsAgo : fromDate,
        toDate: toDate!.isEmpty ? now.toUtc().toIso8601String() : toDate);
    fetchTranxList(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        prev: prev,
        next: next,
        limit: '10',
        showDeleted: isShowDeleted ? 'yes' : '',
        // clearList: () => filteredTransactions?.clear(),
        toDate: toDate);
    fetchExpenseAnalysis(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate.isEmpty ? threeMonthsAgo : fromDate,
        toDate: toDate.isEmpty ? now.toUtc().toIso8601String() : toDate);
    fetchExpenseCategory(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate.isEmpty ? threeMonthsAgo : fromDate,
        toDate: toDate.isEmpty ? now.toUtc().toIso8601String() : toDate);
    fetchExpenseCategoryAndSubCategory(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate.isEmpty ? threeMonthsAgo : fromDate,
        toDate: toDate.isEmpty ? now.toUtc().toIso8601String() : toDate);
    balances.totalState != 1 ? fetchSummary(context) : null;
    fetchFacilities(context);

    states = NigerianStatesAndLGA.allStates;
    lgaList = List<String>.unmodifiable(balances.lgas!);

    onInit = true;
  }

  void navToAdmin() {
    screenIndex = 2;
    _navigatorService.currentIndex = screenIndex!;
    notifyListeners();
    screenIndex = null;
  }

  void navToFacilities() {
    screenIndex = 1;
    _navigatorService.currentIndex = screenIndex!;
    notifyListeners();
    screenIndex = null;
  }

  void onCategoryTap(CategoryData category) {
    selectedCategory = category;
    notifyListeners();
  }

  void onRefresh(context) {
    isShowDeleted = false;
    fetchWalletData(context);
    refreshController.refreshCompleted();
    transactionRefreshController.refreshCompleted();
  }

  Future<void> shareTransactionSheet(context) async {
    try {
      isShareLoading = true;
      notifyListeners();
      await _dashboardService.fetchTranxList(
          state: '',
          lga: '',
          facility: '',
          fromDate: '',
          prev: '',
          next: '',
          limit: transactionList.totalCount.toString(),
          toDate: '');
      isShareLoading = false;
      _excelService.shareTransaction(transactionList.edges);
      notifyListeners();
    } on MisauException catch (e) {
      // TODO
      isLoadingTransaction = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingTransaction = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'share error', subTitle: 'Something went wrong.');
      debugPrint('share error $e/n$stackTrace');
    }
  }

  void onTransactionLoading(context) {
    fetchTranxList(context,
        state: '',
        lga: '',
        facility: '',
        fromDate: '',
        toDate: '',
        prev: '',
        limit: '10',
        showDeleted: isShowDeleted ? 'yes' : '',
        next: transactionList.pageInfo.hasNextPage
            ? transactionList.pageInfo.endCursor
            : '');
    transactionRefreshController.loadComplete();
  }

  void toggleAmountVisibility() {
    hideAmounts = !hideAmounts;
    _sharedPreferenceService.setBool('isAmountHidden', hideAmounts);
    notifyListeners();
  }

  void clearFilters() {
    fromDate = '';
    fromDateController.text = '';
    toDate = '';
    toDateController.text = '';
    selectedState = null;
    states = [''];
    selectedLga = null;
    stateLga = [''];
    states = NigerianStatesAndLGA.allStates;

    searchfacilityController.clearDropDown();
  }

  void logout() => _authService.logout();

  void filterTransactions() {
    final query = searchController.text.toLowerCase().trim();
    if (searchController.text.isEmpty) {
      filteredTransactions = _dashboardService.transactionList?.edges ?? [];
    }
    filteredTransactions =
        _dashboardService.transactionList?.edges.where((transaction) {
              final category = transaction.income != null
                  ? 'Income'
                  : transaction.expense?.category ?? '';
              final facility = transaction.facility?.toLowerCase();
              final date = transaction.createdAt;
              final state = transaction.state;
              return category.toLowerCase().contains(query) ||
                  facility!.contains(query) ||
                  date.toString().contains(query) ||
                  state!.contains(query);
            }).toList() ??
            [];
    notifyListeners();
  }

  Future<void> fetchBalances(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoadingBooking = true;
      notifyListeners();
      await _dashboardService.fetchBalances(
        state: state,
        lga: lga,
        facility: facility,
      );
      isLoadingBooking = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingBooking = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingBooking = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fecth balances error ${e.toString()}/n $stackTrace');
    }
  }

  Future<void> fetchIncome(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoadingIncomeAnalysis = true;
      notifyListeners();
      await _dashboardService.fetchIncome(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      incomePercentageIncrease = calculatePercentage(incomeAnalysis.incomeDiff);
      isLoadingIncomeAnalysis = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingIncomeAnalysis = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingIncomeAnalysis = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fecth income error ${e.toString()}/n $stackTrace');
    }
  }

  Future<void> fetchTranxList(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? prev,
      String? next,
      String? limit,
      // VoidCallback? clearList,
      String? showDeleted,
      String? toDate}) async {
    try {
      isLoadingTransaction = true;
      notifyListeners();
      await _dashboardService.fetchTranxList(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          prev: prev,
          next: next,
          limit: limit,
          toDate: toDate,
          showDeleted: showDeleted);
      // clearList;
      filteredTransactions?.addAll(_dashboardService.transactionList!.edges);
      isLoadingTransaction = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingTransaction = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingTransaction = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch transaction error: $e/n $stackTrace');
    }
  }

  Future<void> fetchExpenseAnalysis(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoadingExpenseAnalysis = true;
      notifyListeners();
      await _dashboardService.fetchExpenseAnalysis(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      expensePercentageDecrease =
          calculatePercentage(expenseAnalysis.expenseDiff);

      isLoadingExpenseAnalysis = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingExpenseAnalysis = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingExpenseAnalysis = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('expense analysis error ${e.toString()}/n $stackTrace');
    }
  }

  Future<void> fetchExpenseCategory(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoadingExpenseCategory = true;
      notifyListeners();
      await _dashboardService.fetchExpenseCategory(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      isLoadingExpenseCategory = false;
      notifyListeners();
      // pieChartModel = PieChartModel.fromExpenseCategoryModel(expenseCategory);
      // chartDataList = convertToChartData(pieChartModel!);
    } on MisauException catch (e) {
      isLoadingExpenseCategory = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingExpenseCategory = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');

      debugPrint('fecth expense category error: $e/n$stackTrace');
    }
  }

  Future<void> fetchExpenseCategoryAndSubCategory(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoadingExpenseCategory = true;
      notifyListeners();
      await _dashboardService.fetchExpenseCategoryAndSubCategory(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      isLoadingExpenseCategory = false;
      notifyListeners();
      // pieChartModel = PieChartModel.fromExpenseCategoryModel(expenseCategory);
      // chartDataList = convertToChartData(pieChartModel!);
    } on MisauException catch (e) {
      isLoadingExpenseCategory = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingExpenseCategory = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');

      debugPrint('fecth expense category error: $e/n$stackTrace');
    }
  }

  double calculatePercentage(dynamic incomeDiff) {
    double baseValue = 1000000;
    return (incomeDiff / baseValue.toInt()) * 100;
  }

  String calculatePercentageIncrease() {
    final percentageIncrease = (incomeAnalysis.currentMonthIncome ??
            0 - incomeAnalysis.lastMonthIncome!) /
        incomeAnalysis.lastMonthIncome! *
        100;
    return percentageIncrease.abs().toStringAsFixed(1);
  }

  String calculatePercentageDecrease() {
    final percentageDecrease = (expenseAnalysis.currentMonthExpense ??
            0 - expenseAnalysis.lastMonthExpense!) /
        expenseAnalysis.lastMonthExpense! *
        100;
    return percentageDecrease.abs().toStringAsFixed(1);
  }

  Future<void> getStateAndLga(context) async {
    try {
      await _stateAndLgaService.getStateAndLga();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fecth state and lga error: $e/n$stackTrace');
    }
  }

  Future<void> fetchFacilities(context) async {
    try {
      isLoadingFacilities = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilities();
      isLoadingFacilities = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingFacilities = false;
      onInit = true;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stack) {
      isLoadingFacilities = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('facilities error stack $e/n$stack');
    }
  }

  Future<void> fetchSummary(context) async {
    try {
      isLoadingSummary = true;
      notifyListeners();
      await _dashboardService.fetchSummary();
      isLoadingSummary = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoadingSummary = false;
      onInit = true;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoadingSummary = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Somethng went wrong.');
      debugPrint('fetch summary error stack $e/n$stackTrace');
    }
  }

  Future<void> getStates(context) async {
    try {
      await _stateAndLgaService.getStates();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Sonething went wrong.');
      debugPrint('fetch state error  $e/n$stackTrace');
    }
  }

  Future<void> getLga(context, String state) async {
    try {
      await _stateAndLgaService.getLga(state);
      lgaList = lgaModel!.map((value) => value.name as String).toList();
      notifyListeners();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('fetch lga error $e/n$stackTrace');
    }
  }

  void selectFromDateCal(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedFromDate) {
      selectedFromDate = pickedDate;
      fromDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedFromDate!);
      fromDateController.text = fromDate!;
      notifyListeners();
    }
  }

  void selectToDateCal(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedToDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedFromDate) {
      selectedFromDate = pickedDate;
      toDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedFromDate!);
      toDateController.text = toDate!;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(context) async {
    try {
      isDeleted = true;
      notifyListeners();
      await _healthFacilitiesService.deleteTransaction(
          id: selectedTransaction?.id);
      router.pop();
      filteredTransactions?.clear();

      clearFlagBottomSheetFields();
      fetchTranxList(context,
          state: '',
          lga: '',
          facility: '',
          fromDate: '',
          toDate: '',
          prev: '',
          limit: '10',
          showDeleted: '',
          next: '');
      isDeleted = false;
      notifyListeners();
    } on MisauException catch (e) {
      router.pop();

      isDeleted = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      router.pop();

      isDeleted = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('delete transaction error $e/n$stackTrace');
    }
  }

  void clearFlagBottomSheetFields() {
    reasonController.text = '';
  }

  void updateStatus() {
    if (selectedTransaction?.income?.status == null &&
        selectedTransaction?.expense?.status == null) {
      isStatusWidget = false;
      isReasonVisible = true;
      isResolved = false;
      bottomSheetHeight = 0.72;
    } else if (selectedTransaction?.income?.status == 'flagged') {
      isStatusWidget = true;
      bottomSheetHeight = 0.6;
      isResolved = false;
      isReasonVisible = false;
    } else if (selectedTransaction?.expense?.status == 'flagged') {
      isStatusWidget = true;
      bottomSheetHeight = 0.6;
      isReasonVisible = false;
    } else {
      isResolved = true;
      isStatusWidget = true;
      bottomSheetHeight = 0.5;
      isReasonVisible = false;
    }
    notifyListeners();
  }

  Future<void> flagTransaction(context, String status) async {
    try {
      isStatus = true;
      notifyListeners();
      await _healthFacilitiesService.flagTransaction(
          id: selectedTransaction?.id,
          status: status,
          reason: reasonController.text);
      router.pop();
      clearFlagBottomSheetFields();
      filteredTransactions?.clear();
      fetchTranxList(context,
          state: '',
          lga: '',
          facility: '',
          fromDate: '',
          toDate: '',
          prev: '',
          limit: '10',
          showDeleted: '',
          next: '');
      isStatus = false;
      notifyListeners();
    } on MisauException catch (e) {
      router.pop();
      isStatus = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      router.pop();
      isStatus = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
      debugPrint('delete transaction error $e/n$stackTrace');
    }
  }
}
