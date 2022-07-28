// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todotasks/bloc/task_bloc/task_cubit.dart';
import 'package:todotasks/bloc/task_bloc/task_states.dart';
import 'package:todotasks/presentation/resources/routes_manager.dart';
import 'package:todotasks/presentation/resources/styles_manager.dart';
import 'package:todotasks/presentation/screens/detailes/details.dart';

import '../../../data/models/tasks_model.dart';
import '../../../data/services/notifications_services.dart';
import '../../resources/app_values.dart';
import '../../resources/color_manager.dart';
import '../../resources/string_manager.dart';

// customText
class CustomText extends StatelessWidget {
  const CustomText({Key? key, this.style, required this.text})
      : super(key: key);
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

// divider
class CustomDivider extends StatelessWidget {
  CustomDivider({
    required this.topPadding,
    required this.bottomPadding,
    Key? key,
  }) : super(key: key);

  double bottomPadding = 0;
  double topPadding = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Divider(
          height: AppHieghtes.deviderHieght, color: ColorManager.darkGrey),
    );
  }
}

// main button used
class MyButton extends StatelessWidget {
  const MyButton({required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHieghtes.buttonHieght,
      width: MediaQuery.of(context).size.width * AppWidths.buttonWidth,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          label,
          style: CustomTextStyles.buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// inputfield
class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.readOnly,
      this.label,
      this.hintText,
      this.controller,
      this.widget})
      : super(key: key);
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? widget;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MarginManagment.inpufieldMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: label!,
              style: TextStyle(fontSize: 18, color: ColorManager.darkGrey)),
          Container(
            padding: const EdgeInsets.only(left: 16),
            margin: const EdgeInsets.only(top: 8),
            width: MediaQuery.of(context).size.width * .9,
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey)),
            child: TextFormField(
              // style: subtitleStyle,
              autofocus: false,
              // cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              controller: controller,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hintText,
                // hintStyle: subtitleStyle,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 0,
                )),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 0,
                )),
                suffixIcon: widget,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This Field Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// page header
class PagesHeader extends StatelessWidget {
  final String head;
  final bool isthereBackIcon;
  final bool isthereActionIcon;
  final Color? color;
  final IconData icon;
  final void Function() onPressed;
  double rightPadding = 0;
  double leftPadding = 0;
  PagesHeader({
    Key? key,
    this.color,
    required this.isthereBackIcon,
    required this.isthereActionIcon,
    required this.head,
    required this.leftPadding,
    required this.rightPadding,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PaddingManagment.pagHeaderPadding,
      color: color,
      child: Row(
        children: [
          // is there back arrow button
          BackIconSet(isthereBackIcon, icon, onPressed),
          // the title of the page
          TitleOfPages(leftPadding, rightPadding, head: head),
          // if there action buttons just into board
          ActionIconsSet(isthereActionIcon)
        ],
      ),
    );
  }
}

// title text
class TitleOfPages extends StatelessWidget {
  TitleOfPages(this.leftPadding, this.rightPadding, {required this.head});

  final String head;
  double leftPadding = 0;
  double rightPadding = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Text(
          head,
          style: CustomTextStyles.headOfPagesTitleStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

// back icon
class BackIconSet extends StatelessWidget {
  BackIconSet(this.isthereBackIcon, this.icon, this.onPressed);
  bool isthereBackIcon = false;
  IconData icon;
  void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return isthereBackIcon
        ? IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
            ),
          )
        : Container();
  }
}

// action icons
class ActionIconsSet extends StatelessWidget {
  ActionIconsSet(this.isthereActionIcon);
  bool isthereActionIcon = false;
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return isthereActionIcon
        ? Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.search);
                },
                icon: const Icon(
                  Icons.search,
                  // color: Get.isDarkMode ? Colors.white : darkGreyClr,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.deleteAllData();
                },
                icon: const Icon(
                  Icons.cleaning_services_outlined,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.scheduleRoute);
                },
                icon: const Icon(
                  Icons.edit_calendar_outlined,
                ),
              ),
            ],
          )
        : Container();
  }
}

// tasks list builder
class TaskBuilder extends StatelessWidget {
  TaskBuilder({required this.tasks});
  List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isNotEmpty) {
      return Column(children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => CardItem(tasks[index], index),
            itemCount: tasks.length,
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ]);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            )
          ],
        ),
      );
    }
  }
}

//  card for board
class CardItem extends StatelessWidget {
  CardItem(this.task, this.index, {Key? key}) : super(key: key);
  Task? task;
  int? index;
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var date = DateFormat.jm().parse(task!.startTime!);
          var myTime = DateFormat('HH:MM').format(date);
          debugPrint("my time $myTime");
          NotificationApi.scheduledNotification(
            int.parse(myTime.toString().split(':')[0]),
            int.parse(myTime.toString().split(':')[1]),
            task!,
          );
          return Container(
            // key: _key,
            height: 70,
            child: Card(
              elevation: AppSizes.elevationCrd,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            task!.statusofcomplete == cubit.statusoftasks[0]
                                ? cubit.updateStatus(
                                    statusofcomplete: cubit.statusoftasks[1],
                                    statusoffave: task!.statusoffave!,
                                    id: task!.id!)
                                : cubit.updateStatus(
                                    statusoffave: task!.statusoffave!,
                                    statusofcomplete: cubit.statusoftasks[0],
                                    id: task!.id!);
                            debugPrint("here you are ");
                          },
                          icon: Icon(
                            task!.statusofcomplete == cubit.statusoftasks[0]
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 20,
                            color: cubit.colorIndexing(task!.color),
                          ),
                        ),

                        // note title
                        Container(
                          width: MediaQuery.of(context).size.width * .45,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Details(task: task)));
                            },
                            child: Text(
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              task!.title.toString(),
                              style: CustomTextStyles.bodyStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cubit.deleteData(id: task!.id!);
                          },
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            size: 20,
                            color: ColorManager.delete,
                          ),
                        ),
                        // favorite
                        IconButton(
                          onPressed: () {
                            task!.statusoffave == cubit.statusoftasks[3]
                                ? cubit.updateStatus(
                                    statusofcomplete: task!.statusofcomplete!,
                                    statusoffave: cubit.statusoftasks[2],
                                    id: task!.id!)
                                : cubit.updateStatus(
                                    statusofcomplete: task!.statusofcomplete!,
                                    statusoffave: cubit.statusoftasks[3],
                                    id: task!.id!);
                            debugPrint("here you are ");
                          },
                          icon: Icon(
                            task!.statusoffave == cubit.statusoftasks[2]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: cubit.colorIndexing(task!.color),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          );
        },
        listener: (context, state) {});
  }
}

// editButton
class EditButton extends StatelessWidget {
  Task task;
  AppCubit cubit;
  EditButton({required this.task, required this.cubit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.only(bottom: AppPadding.pading20),
      child: TextButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addTaskRoute);
          cubit.setCreateOrUpdateTask("Create");
        },
        icon: Icon(
          Icons.edit_outlined,
          color: ColorManager.darkBlak,
        ),
        label: Text(
          StringManager.editNow,
          style: CustomTextStyles.darktitleStyle,
        ),
      ),
    );
  }
}
