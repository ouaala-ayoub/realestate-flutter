import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/report.dart';
import 'package:realestate/models/helpers/reports_helper.dart';

class ReportPageProvider extends ChangeNotifier {
  bool loading = false;
  final List<String> reasons = [];
  bool showOthers = false;
  final othersTFController = TextEditingController();

  void handleReason(bool value, String text) {
    value ? reasons.add(text) : reasons.remove(text);
    showOthers = reasons.contains('Other');
    if (!showOthers) {
      othersTFController.clear();
    }
    notifyListeners();
  }

  nofityTextChange() {
    notifyListeners();
  }

  bool dataEntred() {
    final isOthersValid =
        reasons.contains('Other') ? othersTFController.text.isNotEmpty : true;
    return reasons.isNotEmpty && isOthersValid;
  }

  sendReport(Report report,
      {required Function() onSuccess,
      required Function(dynamic) onFail}) async {
    loading = true;
    notifyListeners();
    final res = await ReportsHelper().sendReport(report);
    res.fold((e) => onFail(e), (r) => onSuccess());
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    othersTFController.dispose();
  }
}
