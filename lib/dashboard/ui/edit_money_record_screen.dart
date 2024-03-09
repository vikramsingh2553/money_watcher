import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:money_watcher/shared/app_constant.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:money_watcher/shared/app_text_field.dart';
import 'package:money_watcher/shared/app_util.dart';
import 'package:money_watcher/shared/widget/radio_button_widget.dart';
import 'package:provider/provider.dart';

class EditMoneyRecordScreen extends StatefulWidget {
 final MoneyRecord moneyRecord;

  const EditMoneyRecordScreen({super.key, required this.moneyRecord});
  @override
  _EditMoneyRecordScreenState createState() => _EditMoneyRecordScreenState();
}

class _EditMoneyRecordScreenState extends State<EditMoneyRecordScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String? selectedCategory;

  late int _selectedDate = DateTime.now().millisecondsSinceEpoch;
  late MoneyRecordType _transactionType = MoneyRecordType.expense;


  List<String> _categories = AppConstant.getRecordCategories();

  @override
  void initState() {
 selectedCategory = widget.moneyRecord.category;
 _titleController.text=widget.moneyRecord.title;
 _amountController.text = widget.moneyRecord.amount.toString();
 _selectedDate = widget.moneyRecord.date;
 _transactionType = widget.moneyRecord.type;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editMoneyTitleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _titleController,
                hintText: 'Title',
              ),
              SizedBox(height: 8),
              AppTextField(
                controller: _amountController,
                hintText: 'Amount',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField(
                  value: selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value as String?;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Date:${AppUtil.formattedDate(_selectedDate).toString()}'),
                  TextButton(
                    onPressed: () {
                      // Implement date picker here
                    },
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Select Transaction Type:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.income,
                    selectedValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value as MoneyRecordType;
                      });
                    },
                    title: 'Income',
                  ),
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.expense,
                    selectedValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value as MoneyRecordType;
                      });
                    },
                    title: 'Expense',
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: ()async{
                  await editMoneyRecord();
                  fetchMoneyRecord();
                },


                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: buttonBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Add Record ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future editMoneyRecord()async {
    String category = selectedCategory ?? "Default Category";

    MoneyRecord moneyRecord = MoneyRecord(
      id: widget.moneyRecord.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: category,
      date: _selectedDate,
      type: _transactionType,
    );
    final moneyProvider = Provider.of<MoneyRecordProvider>(
        context,listen: false);
    await moneyProvider.editMoneyRecord(moneyRecord);
    await moneyProvider.getMoneyRecord();

    if(moneyProvider.error==null) {
      if (mounted) {
        AppUtil.showToast(recordEditMsg);
        Navigator.pop(context);
      }
    }
  }
  Future fetchMoneyRecord ()async{
    final moneyProvider = Provider.of<MoneyRecordProvider>(context,listen: false);
    moneyProvider.getMoneyRecord();
  }
}
