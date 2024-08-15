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
import 'package:misau/models/facilities_model.dart';
import 'package:misau/models/facility_balances_model.dart';
import 'package:misau/models/inflow_payment_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/toast_service.dart';
import 'package:misau/utils/utils.dart';

final healthFacilitiesViemodelProvider =
    ChangeNotifierProvider<HealthFacilitiesViewModel>(
        (ref) => HealthFacilitiesViewModel());

class HealthFacilitiesViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();

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

  TextEditingController searchController = TextEditingController();
  TextEditingController inflowAmountContoller = TextEditingController();
  String? inflowStatusValue;
  TextEditingController expenseAmountContoller = TextEditingController();
  TextEditingController reasonContoller = TextEditingController();

  String? expenseStatusValue;
  final GlobalKey<FormState> formKey = GlobalKey();

  List<Transaction>? filteredTransactions = [];

  bool isLoading = false;
  bool onInit = false;
  bool hideAmounts = false;
  bool isReasonVisible = false;

  Future<void> onBuild(context) async {
    // getAuditTrails(context);
    await facilitiesBalances(context);
    await fetchFacilityTransactionList(context);
    await fetchCategories(context);
    await getBalanceIncome(context);
    await getExpenseIncome(context);
  }

  void toggleAmountVisibility() {
    hideAmounts = !hideAmounts;
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
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
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

  Future<void> fetchFacilitiesPagnated(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilitiesPagnated();
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
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

  Future<void> addPayment(context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
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

  // void getAuditTrails(){

  //          Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HealthDetails()),
  //       );
  // }
}
