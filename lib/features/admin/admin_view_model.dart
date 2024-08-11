import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final adminViewModelProvider =
    ChangeNotifierProvider<AdminViewModel>(
        (ref) => AdminViewModel());

class AdminViewModel extends ChangeNotifier{

}