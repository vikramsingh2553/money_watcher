import 'package:flutter/widgets.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/login/service/database_service.dart';
import 'package:money_watcher/shared/app_util.dart';

class MoneyRecordProvider extends ChangeNotifier {
  List<MoneyRecord> moneyRecordList = [];
  DatabaseService databaseService;

  MoneyRecordProvider(this.databaseService);

  bool isLoading = false;
  String? error;

  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      isLoading = true;
      notifyListeners();
      await databaseService.addMoneyRecord(moneyRecord);
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future editMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      isLoading = true;
      notifyListeners();
      await databaseService.editMoneyRecord(moneyRecord);
    } catch (e) {
    }

    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future getMoneyRecord() async {
    try {
      error = null;
      isLoading = false;
      notifyListeners();

      moneyRecordList = await databaseService.getMoneyRecord();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future deleteMoneyRecord(int id) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await databaseService.deleteMoneyRecord(id);
      return true;
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
