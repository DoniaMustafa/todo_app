import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit_app.dart';

Widget defaultTextFiled(
        {icon,
        labelText,
        TextInputType? keyboardType,
        controller,
        textValidator,
        fun}) =>
    TextFormField(
      autofocus: true,
      keyboardType: keyboardType,
      enabled: true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return textValidator;
        }
        return null;
      },
      onTap: fun,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 15),
          suffixIcon: Icon(icon),
          border: OutlineInputBorder()),
    );

Widget listItem(Map item, context,i) => Dismissible(
  onDismissed: (direction){ AppCubit.get(context).deleteDatabase(id: item['id']);

    },
  key: Key('${item['id']}'),
  // direction: DismissDirection.startToEnd,
background: Container(color: Colors.red,),
  child:   Row(

        children: [

          CircleAvatar(

            radius: 40,

            child: Text(

              item['time'],

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),

            ),

          ),

          SizedBox(

            width: 20,

          ),

          Expanded(

              child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${item['title']}',

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

              ),

              SizedBox(

                height: 10,

              ),

              Text(

                '${item['date']}',

                style: TextStyle(

                    fontSize: 17,

                    color: Colors.grey,

                    fontWeight: FontWeight.bold),

              ),

              SizedBox(

                height: 10,

              ),

            ],

          )),

          IconButton(

              onPressed: () {

                AppCubit.get(context)

                    .updateDatabase(status: 'done', id: item['id']);

              },

              icon: Icon(

                Icons.check_box,

                color: Colors.grey,

                size: 25,

              )),

          IconButton(

              onPressed: () {

                AppCubit.get(context)

                    .updateDatabase(status: 'archive', id: item['id']);

              },

              icon: Icon(

                Icons.archive,

                color: Colors.grey,

                size: 25,

              ))

        ],

      ),
);
