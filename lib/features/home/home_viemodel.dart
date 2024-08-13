import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/lga_model.dart';
import 'package:misau/models/state_model.dart';
import 'package:misau/models/states_and_lga_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/dashboard_service.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/state_and_lga_service.dart';
import 'package:misau/service/toast_service.dart';

final homeViemodelProvider =
    ChangeNotifierProvider<HomeViemodel>((ref) => HomeViemodel());

class HomeViemodel extends ChangeNotifier {
  final DashboardService _dashboardService = getIt<DashboardService>();
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final StateAndLgaService _stateAndLgaService = getIt<StateAndLgaService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();

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
  ExpenseCategory get expenseCategory =>
      _dashboardService.expenseCategory ?? ExpenseCategory();

  TextEditingController searchController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  SingleValueDropDownController searchfacilityController =
      SingleValueDropDownController();

  List<Transaction>? filteredTransactions = [];

  String? selectedState;
  String? selectedLga;
  String? fromDate;
  String? toDate;

  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? get selectedFacility => searchfacilityController.dropDownValue?.value;

  bool isLoading = false;
  bool onInit = false;

  List<String>? get facilitiesList =>
      facilitiesModel.map((value) => value.name as String).toList();

  List<String>? lgaList = [];

  void clearFilters() {
    fromDate = '';
    fromDateController.text = '';
    toDate = '';
    toDateController.text = '';
    selectedState = '';
    selectedLga = '';
    searchfacilityController.dispose();
  }

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
              final facility = transaction.facility.toLowerCase();
              return category.toLowerCase().contains(query) ||
                  facility.contains(query);
            }).toList() ??
            [];
    notifyListeners();
  }

  Future<void> fetchWalletData(context,
      {String? state = '',
      String? lga = '',
      String? facilitys = '',
      String? fromDate = '',
      String? toDate = ''}) async {
    await fetchBalances(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    await fetchIncome(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    await fetchTranxList(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    await fetchExpenseAnalysis(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    await fetchExpenseCategory(context,
        state: state,
        lga: lga,
        facility: facilitys,
        fromDate: fromDate,
        toDate: toDate);
    await fetchFacilities(context);
    await getStates(context);

    onInit = true;
  }

  Future<void> fetchBalances(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchBalances(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
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
          title: 'Error', subTitle: 'fecth balances error ${e.toString()}');
    }
  }

  Future<void> fetchIncome(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchIncome(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
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
          title: 'Error', subTitle: 'fecth income error ${e.toString()}');
    }
  }

  Future<void> fetchTranxList(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchTranxList(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
      filteredTransactions = _dashboardService.transactionList?.edges ?? [];
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
          title: 'Error', subTitle: 'fecth transactions error ${e.toString()}');
    }
  }

  Future<void> fetchExpenseAnalysis(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchExpenseAnalysis(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
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
          title: 'Error', subTitle: 'expense analysis error ${e.toString()}');
    }
  }

  Future<void> fetchExpenseCategory(context,
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchExpenseCategory(
          state: state,
          lga: lga,
          facility: facility,
          fromDate: fromDate,
          toDate: toDate);
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
    } catch (e) {
      _toastService.showToast(context, title: 'Error', subTitle: e.toString());
    }
  }

  Future<void> fetchFacilities(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilities();
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      onInit = true;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'facilities error: ${e.toString}');
    }
  }

  Future<void> getStates(context) async {
    try {
      await _stateAndLgaService.getStates();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'state error: ${e.toString}');
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
    } catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'lga error: ${e.toString}');
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
      fromDate = DateFormat('dd-MM-yyyy').format(selectedFromDate!);
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
      toDate = DateFormat('dd-MM-yyyy').format(selectedFromDate!);
      toDateController.text = toDate!;
      notifyListeners();
    }
  }
}
