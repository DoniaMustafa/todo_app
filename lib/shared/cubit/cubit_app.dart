import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archive/archive_screen.dart';
import 'package:todo/modules/done/done_screen.dart';
import 'package:todo/modules/new_task/task_screen.dart';
import 'package:todo/shared/cubit/state_app.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isBottomSheet = false;
  int select = 0;
  IconData iconData = Icons.edit;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final task = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  Database? db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  List<String> titleName = ['Tasks', 'Done', 'Archive'];
  List<Widget> widgetName = [Home(), DoneScreen(), ArchiveScreen()];

  changeFloatBottomIcon({required bool isSheet, required IconData icon}){
    isBottomSheet= isSheet;
    iconData =icon;
emit(AppChangeFloatBottomIconState());
  }
  Future<TimeOfDay?> timePecker(context) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      time.text = value!.format(context).toString();
      print(value.format(context).toString());
      emit(AppTimePackerLoadingState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppTimePackerSuccessState());
    });
  }

  Future datePecker(context) async {
    return await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('2025-21-12'))
        .then((value) {
      date.text = DateFormat.yMMMd().format(value!);
      print(DateFormat.yMMMd().format(value));
      emit(AppDatePackerLoadingState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppDatePackerSuccessState());
    });
  }

  void onChangeSelect(change) {
    select = change;
    emit(AppSelected());
  }


  void createData() {
    openDatabase('todo.db', version: 2, onCreate: (Database date, int version) {
      date
          .execute(
              'CREATE TABLE Test(id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {})
          .catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (db) {
      getDataFromDatabase(db);
    }).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertDataBases({@required task, @required date, @required time}) async {
    await db!
        .rawInsert(
            'INSERT INTO Test(title, date, time,status) VALUES("$task", "$date", "$time","new")')
        .then((value) {
      print('insert database $value');
      getDataFromDatabase(db);

      emit(AppInsertSuccessState());
    }).catchError((error) {
      print('insert database error ${error.toString()}');
      emit(AppInsertErrorState());
    });
    return null;
  }

  void getDataFromDatabase(db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    db!.rawQuery('SELECT * FROM Test').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);

        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      print(newTasks);
      emit(AppGetDatabaseSuccessState());
    });
  }


  void updateDatabase({required String status,required int id})async {
    emit(AppUpdateLoadingState());
    await db!.rawUpdate(
        'UPDATE Test SET status = ? WHERE id = ?',
        ['$status',id  ]).then((value){
          getDataFromDatabase(db);
          print(value);
          emit(AppUpdateSuccessState());
    }).catchError((onError){
      emit(AppUpdateErrorState());

    });
  }

  void deleteDatabase({required int id})async {
     db!.rawDelete('DELETE FROM Test WHERE id = ?', [id]
    ).then((value){
      getDataFromDatabase(db);
      print(value);
      emit(AppDeleteSuccessState());
    }).catchError((onError){
      emit(AppDeleteErrorState());
    });
  }

}
