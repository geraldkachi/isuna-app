import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/app/router.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/audit_details.dart';
import 'package:misau/models/balance_expense_model.dart';
import 'package:misau/models/balance_income_model.dart';
import 'package:misau/models/categories_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/expense_payment_model.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/models/facility_balances_model.dart';
import 'package:misau/models/inflow_payment_model.dart';
import 'package:misau/models/page_info_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/shared_preference_service.dart';
import 'package:misau/service/toast_service.dart';
import 'package:misau/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final healthFacilitiesViemodelProvider =
    ChangeNotifierProvider<HealthFacilitiesViewModel>(
        (ref) => HealthFacilitiesViewModel());

class HealthFacilitiesViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();
  final SharedPreferenceService _sharedPreferenceService =
      getIt<SharedPreferenceService>();

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

  PageInfoModel get pageInfoModel =>
      _healthFacilitiesService.pageInfoModel ?? PageInfoModel();

  ExpenseCategory get expenseCategory =>
      _healthFacilitiesService.expenseCategory ?? ExpenseCategory();

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

  final GlobalKey<FormState> inFlowFormKey = GlobalKey();
  final GlobalKey<FormState> expenseFormKey = GlobalKey();

  List<Transaction>? filteredTransactions = [];

  bool isLoading = false;
  bool onInit = false;
  bool hideAmounts = false;
  bool isReasonVisible = false;

  Future<void> onBuild(context) async {
    // getAuditTrails(context);
    Future(() {
      hideAmounts = _sharedPreferenceService.getBool('isAmountHidden')!;
      notifyListeners();
    });
    await facilitiesBalances(context);
    await fetchFacilityTransactionList(context);
    await fetchCategories(context);
    await getBalanceIncome(context);
    await getExpenseIncome(context);
    await fetchExpenseCategory(context);
  }

  void onRefreshFacility(context) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
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
    _sharedPreferenceService.setBool('isAmountHidden', hideAmounts);
    notifyListeners();
  }

  void filterTransactions() {
    final query = searchController.text.toLowerCase().trim();
    if (searchController.text.isEmpty) {
      filteredTransactions =
          _healthFacilitiesService.transactionList?.edges ?? [];
    }
    filteredTransactions =
        _healthFacilitiesService.transactionList?.edges.where((transaction) {
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

  Future<void> fetchFacilitiesPagnated(context, {String? next = ''}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilitiesPagnated(next: next);
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
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> getBalanceIncome(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getBalanceIncome(selectedFacility!.name!,
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

  Future<void> getExpenseIncome(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getBalanceExpense(selectedFacility!.name!,
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

  Future<void> fetchFacilityTransactionList(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilityTransactionList(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!);
      filteredTransactions =
          _healthFacilitiesService.transactionList?.edges ?? [];
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

  // void getAuditTrails(){

  //          Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HealthDetails()),
  //       );
  // }
}
