import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/data_model.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit_app.dart';
import 'package:todo/shared/cubit/state_app.dart';

class LayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createData(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: AppCubit.get(context).scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context)
                  .titleName[AppCubit.get(context).select]),
            ),
            body:
                AppCubit.get(context).widgetName[AppCubit.get(context).select],
            floatingActionButton: FloatingActionButton(
              child:Icon( AppCubit.get(context).iconData),
              onPressed: () {
                if (AppCubit.get(context).isBottomSheet) {
                  if (AppCubit.get(context).formKey.currentState!.validate()) {
                    AppCubit.get(context).insertDataBases(
                        task: AppCubit.get(context).task.text,
                        time: AppCubit.get(context).time.text,
                        date: AppCubit.get(context).date.text);
                    print(AppCubit.get(context).task.text);
                    print(AppCubit.get(context).time.text);
                    print(AppCubit.get(context).date.text);
                  }
                } else {
                  AppCubit.get(context)
                      .scaffoldKey
                      .currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Form(
                              key: AppCubit.get(context).formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFiled(
                                      textValidator: 'task must not be empty',
                                      icon: Icons.add_task,
                                      labelText: 'Task Name',
                                      keyboardType: TextInputType.text,
                                      controller: AppCubit.get(context).task),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextFiled(
                                      fun: () => AppCubit.get(context)
                                          .timePecker(context),
                                      textValidator: 'Time must not be empty',
                                      icon: Icons.access_time,
                                      labelText: 'Time',
                                      keyboardType: TextInputType.datetime,
                                      controller: AppCubit.get(context).time),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextFiled(
                                      fun: () => AppCubit.get(context)
                                          .datePecker(context),
                                      textValidator: 'Date must not be empty',
                                      icon: Icons.date_range,
                                      labelText: 'Date',
                                      keyboardType: TextInputType.datetime,
                                      controller: AppCubit.get(context).date)
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    AppCubit.get(context).changeFloatBottomIcon(
                        isSheet: AppCubit.get(context).isBottomSheet = false,
                        icon: Icons.edit);
                  });
                  AppCubit.get(context).changeFloatBottomIcon(
                      isSheet: AppCubit.get(context).isBottomSheet = true,
                      icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive')
              ],
              currentIndex: AppCubit.get(context).select,
              onTap: (i) => AppCubit.get(context).onChangeSelect(i),
              type: BottomNavigationBarType.fixed,
            ),
          );
        },
      ),
    );
  }
}
