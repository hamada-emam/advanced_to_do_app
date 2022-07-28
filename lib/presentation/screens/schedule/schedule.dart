import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/task_bloc/task_cubit.dart';
import '../../../bloc/task_bloc/task_states.dart';

import '../../components/shared/shared_components.dart';
import '../../resources/string_manager.dart';
// ignore_for_file: must_be_immutable

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:intl/intl.dart';

import '../../../data/models/tasks_model.dart';
import '../../../data/services/notifications_services.dart';
import '../../resources/app_values.dart';
import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';
import '../../screens/detailes/details.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// SCHEDUAL PAGE
class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<AppCubit>(context),
        child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
          // if (state is AppInsertDatabaseState) Navigator.pop(ctx);
        }, builder: (ctx, state) {
          AppCubit cubit = AppCubit.get(ctx);
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                PagesHeader(
                    leftPadding: 0,
                    rightPadding: 0,
                    icon: Icons.arrow_back_ios,
                    onPressed: () => Navigator.of(context).pop(),
                    isthereBackIcon: true,
                    isthereActionIcon: false,
                    head: StringManager.schedualHeadTitle),
                DatePickertoselect(cubit: cubit),
                SizedBox(
                    height: MediaQuery.of(context).size.height * .67,
                    child: ShowAllTasksinAnimation(cubit: cubit)),
              ],
            ),
          );
        }));
  }
}

// DATE TIMELINE ITEM
class DatePickertoselect extends StatelessWidget {
  DatePickertoselect({required this.cubit, Key? key}) : super(key: key);
  AppCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: cubit.selectedDate,
        width: 80,
        height: 90,
        selectedTextColor: Colors.white,
        selectionColor: ColorManager.primarySwitch,
        onDateChange: (newDate) {
          cubit.setDatePicket(newDate);
        },
      ),
    );
  }
}

// CARD ITEM
class ScheduleCardItem extends StatelessWidget {
  ScheduleCardItem(this.task, this.index, {Key? key}) : super(key: key);
  Task? task;
  int? index;
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return SizedBox(
            height: 100,
            child: Card(
              color: cubit.colorIndexing(task!.color),
              elevation: AppSizes.elevationCrd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * .80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                Details(task: task)));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // title
                                      textNote(
                                          "Title: ${task!.title.toString()}"),

                                      // date
                                      textNote(
                                          "Date: ${task!.date.toString()}"),
                                    ],
                                  )),
                            ),
                            Row(
                              children: [
                                // completed
                                IconButton(
                                  onPressed: () {
                                    task!.statusofcomplete ==
                                            cubit.statusoftasks[0]
                                        ? cubit.updateStatus(
                                            statusofcomplete:
                                                cubit.statusoftasks[1],
                                            statusoffave: task!.statusoffave!,
                                            id: task!.id!)
                                        : cubit.updateStatus(
                                            statusoffave: task!.statusoffave!,
                                            statusofcomplete:
                                                cubit.statusoftasks[0],
                                            id: task!.id!);
                                    debugPrint("here you are ");
                                  },
                                  icon: Icon(
                                    task!.statusofcomplete ==
                                            cubit.statusoftasks[0]
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 20,
                                    color: ColorManager.mainWight,
                                  ),
                                ),
                                // delete
                                IconButton(
                                  onPressed: () {
                                    cubit.deleteData(id: task!.id!);
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever_outlined,
                                    size: 20,
                                    color: ColorManager.mainWight,
                                  ),
                                ),
                                // favorite
                                IconButton(
                                  onPressed: () {
                                    task!.statusoffave == cubit.statusoftasks[3]
                                        ? cubit.updateStatus(
                                            statusofcomplete:
                                                task!.statusofcomplete!,
                                            statusoffave:
                                                cubit.statusoftasks[2],
                                            id: task!.id!)
                                        : cubit.updateStatus(
                                            statusofcomplete:
                                                task!.statusofcomplete!,
                                            statusoffave:
                                                cubit.statusoftasks[3],
                                            id: task!.id!);
                                    debugPrint("here you are ");
                                  },
                                  icon: Icon(
                                    task!.statusoffave == cubit.statusoftasks[2]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: ColorManager.mainWight,
                                  ),
                                ),
                                EditButton(task: task!, cubit: cubit),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // actionButtons
                      task!.statusofcomplete == "completed"
                          ? const Icon(
                              Icons.published_with_changes,
                              color: ColorManager.mainWight,
                            )
                          : const Icon(
                              Icons.unpublished_outlined,
                              color: ColorManager.mainWight,
                            ),
                    ]),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }

  Text textNote(
    String text,
  ) {
    return Text(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text.toString(),
      style: CustomTextStyles.detailesFont,
    );
  }
}

// GET ALL TASKS IN THIS DAY
class ShowAllTasksinAnimation extends StatelessWidget {
  ShowAllTasksinAnimation({required this.cubit, Key? key}) : super(key: key);
  AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      semanticsLabel: "refresh",
      displacement: 60,
      onRefresh: () async {
        cubit.getDataBase();
      },
      edgeOffset: 30,
      backgroundColor: Colors.grey,
      child: ListView.builder(
        itemCount: cubit.allTasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = cubit.allTasks[index];
          if (task.repeat == 'Daily' ||
              task.date == DateFormat.yMd().format(cubit.selectedDate!) ||
              (task.repeat == 'Weekly' &&
                  cubit.selectedDate!
                              .difference(DateFormat.yMd().parse(task.date!))
                              .inDays %
                          7 ==
                      0) ||
              (task.repeat == 'Monthly' &&
                  DateFormat.yMd().parse(task.date!).day ==
                      cubit.selectedDate!.day)) {
            var date = DateFormat.jm().parse(task.startTime!);
            var myTime = DateFormat('HH:MM').format(date);
            debugPrint("my time $myTime");
            NotificationApi.scheduledNotification(
              int.parse(myTime.toString().split(':')[0]),
              int.parse(myTime.toString().split(':')[1]),
              task,
            );
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1500),
              child: SlideAnimation(
                horizontalOffset: 300,
                verticalOffset: 300,
                child: FadeInAnimation(
                  curve: Curves.easeInOutCirc,
                  child: ScheduleCardItem(task, index),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
