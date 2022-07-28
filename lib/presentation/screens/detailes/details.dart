// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotasks/presentation/resources/app_values.dart';
import 'package:todotasks/presentation/resources/color_manager.dart';
import 'package:todotasks/presentation/resources/styles_manager.dart';

import '../../../bloc/task_bloc/task_cubit.dart';
import '../../../bloc/task_bloc/task_states.dart';
import '../../../data/models/tasks_model.dart';
import '../../components/shared/shared_components.dart';
import '../../resources/string_manager.dart';

// SCREEN
class Details extends StatelessWidget {
  Details({this.task, Key? key}) : super(key: key);
  Task? task;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<AppCubit>(context),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (ctx, state) {
              AppCubit cubit = AppCubit.get(context);
              return Scaffold(
                body: Padding(
                  padding:
                      EdgeInsets.only(top: 50, bottom: 20, left: 15, right: 15),
                  child: Column(
                    children: [
                      PagesHeader(
                        leftPadding: 50,
                        rightPadding: 0,
                        icon: Icons.arrow_back_ios,
                        onPressed: () => Navigator.of(context).pop(),
                        // TODO : will be user name
                        head: "Hello Hamada!",
                        isthereActionIcon: false,
                        isthereBackIcon: true,
                      ),
                      SectionOfCaedHeadItem(
                          text: task!.title!, icon: Icons.title_rounded),
                      Container(
                        height: MediaQuery.of(ctx).size.height * .70,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppCubit.get(context)
                                .colorIndexing(task!.color)),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SectionOfCaedHeadItem(
                                text: StringManager.note,
                                icon: task!.statusofcomplete == "completed"
                                    ? Icons.task
                                    : Icons.not_interested),
                            DetailsDvider(),
                            TextOfCardDetails(text: task!.note.toString()),
                            DetailsDvider(),
                            SectionOfCaedHeadItem(
                                text: StringManager.date,
                                icon: Icons.calendar_today_outlined),
                            DetailsDvider(),
                            TextOfCardDetails(text: task!.date.toString()),
                            DetailsDvider(),
                            SectionOfCaedHeadItem(
                                text: StringManager.time, icon: Icons.timer),
                            DetailsDvider(),
                            TextOfCardDetails(
                                text:
                                    "From: ${task!.startTime.toString()}\nTo:     ${task!.endTime.toString()}  "),
                            DetailsDvider(),
                            SectionOfCaedHeadItem(
                              text: StringManager.remind,
                              icon: Icons.repeat_on_rounded,
                            ),
                            DetailsDvider(),
                            TextOfCardDetails(
                              text:
                                  " ${task!.repeat == "one" ? "" : "Will Repeate this  ${task!.repeat.toString()}\n"} Will Remind you ${task!.remind.toString()}  Minutes early ",
                            ),
                            DetailsDvider(),
                            EditButton(
                              task: task!,
                              cubit: cubit,
                            ),
                            DetailsDvider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}

// CARD SECTIONS
class SectionsOfCards extends StatelessWidget {
  const SectionsOfCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [],
    );
  }
}

// HEAD SECTIONS
class SectionOfCaedHeadItem extends StatelessWidget {
  SectionOfCaedHeadItem({required this.icon, required this.text, Key? key})
      : super(key: key);
  IconData icon;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: ColorManager.darkPrimarySwitch,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorManager.mainWight,
            size: AppSizes.iconSize,
          ),
          SizedBox(width: 15),
          CustomText(
            text: text,
            style: CustomTextStyles.detailsbodyStyle,
          ),
        ],
      ),
    );
  }
}

//DIVIDER
class DetailsDvider extends StatelessWidget {
  const DetailsDvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDivider(bottomPadding: 10, topPadding: 10);
  }
}

// TEXT
class TextOfCardDetails extends StatelessWidget {
  TextOfCardDetails({Key? key, required this.text}) : super(key: key);
  String text;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: CustomTextStyles.detailsbodyStyle,
      textAlign: TextAlign.center,
    );
  }
}
