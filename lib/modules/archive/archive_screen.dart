import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit_app.dart';
import 'package:todo/shared/cubit/state_app.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              if (state is AppUpdateLoadingState) LinearProgressIndicator(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView.separated(
                    itemBuilder: (context, index) => listItem(
                        AppCubit.get(context).archivedTasks[index], context,index),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: AppCubit.get(context).archivedTasks.length),
              ),
            ],
          ),
        );
      },
    );
  }
}
