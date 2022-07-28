// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:todotasks/bloc/task_bloc/task_cubit.dart';
import 'package:todotasks/presentation/resources/string_manager.dart';

import '../../../bloc/task_bloc/task_states.dart';
import '../../../data/models/tasks_model.dart';
import '../../components/shared/shared_components.dart';
import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  int _selectedRemind = 5;
  final List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AppCubit>(context),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (ctx, state) {
          AppCubit cubit = AppCubit.get(ctx);
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.only(
                  top: 45, bottom: 30, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      StickyHeader(
                        header: PagesHeader(
                            leftPadding: 0,
                            rightPadding: 0,
                            icon: Icons.arrow_back_ios,
                            onPressed: () => Navigator.of(context).pop(),
                            isthereActionIcon: false,
                            head: StringManager.addTask,
                            color: ColorManager.mainWight,
                            isthereBackIcon: true),
                        content: Column(
                          children: [
                            // title
                            InputField(
                              readOnly: false,
                              label: StringManager.title,
                              hintText: StringManager.titleHint,
                              controller: _titleController,
                            ),

                            // note
                            InputField(
                              readOnly: false,
                              label: StringManager.note,
                              hintText: StringManager.noteHint,
                              controller: _noteController,
                            ),

                            //  date
                            InputField(
                              readOnly: true,
                              label: StringManager.date,
                              hintText: DateFormat.yMd()
                                  .format(cubit.selectedDateTime),
                              widget: IconButton(
                                onPressed: () => cubit.getDateFromUser(context),
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            // start end time
                            Row(
                              children: [
                                // start time
                                Expanded(
                                  child: InputField(
                                    readOnly: true,
                                    label: StringManager.startTime,
                                    hintText: cubit.startTime,
                                    widget: IconButton(
                                      onPressed: () => cubit.getTimeFromUser(
                                          context,
                                          isStartTime: true),
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),

                                // end time
                                Expanded(
                                  child: InputField(
                                    readOnly: true,
                                    label: StringManager.endTime,
                                    hintText: cubit.endTime,
                                    widget: IconButton(
                                      onPressed: () => cubit.getTimeFromUser(
                                          context,
                                          isStartTime: false),
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            // reminder
                            InputField(
                              readOnly: true,
                              label: StringManager.remind,
                              hintText:
                                  '${"$_selectedRemind  ${StringManager.minutesHint}"} ',
                              widget: DropdownButton(
                                borderRadius: BorderRadius.circular(15),
                                dropdownColor: Colors.blueGrey,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedRemind = newValue!;
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 26,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                elevation: 4,
                                items: _remindList
                                    .map(
                                      (valueReminded) => DropdownMenuItem(
                                        value: valueReminded,
                                        child: Text(
                                          "$valueReminded", //style: headingStyle
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                            // repeat
                            InputField(
                              readOnly: true,
                              label: StringManager.repeat,
                              hintText: '${_selectedRepeat.toString()} ',
                              widget: DropdownButton(
                                borderRadius: BorderRadius.circular(15),
                                dropdownColor: Colors.blueGrey,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRepeat = newValue!;
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 26,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                elevation: 4,
                                items: _repeatList
                                    .map(
                                      (valueReminded) => DropdownMenuItem(
                                        value: valueReminded,
                                        child: Text(
                                          valueReminded, //style: headingStyle
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            colorPalette(cubit),

                            //submit button
                            MyButton(
                              onTap: () {
                                debugPrint(cubit.createOrUpdate);
                                cubit.createOrUpdate == "Add"
                                    ? cubit.validateDataforAdd(
                                        _titleController,
                                        _noteController,
                                        Task(
                                          title: _titleController.text,
                                          note: _noteController.text,
                                          statusoffave: "notFavorite",
                                          statusofcomplete: "unCompleted",
                                          date: DateFormat.yMd()
                                              .format(cubit.selectedDateTime),
                                          startTime: cubit.startTime,
                                          endTime: cubit.endTime,
                                          color: _selectedColor,
                                          remind: _selectedRemind,
                                          repeat: _selectedRepeat,
                                        ),
                                        ctx)
                                    : cubit.validateDataforUpdate(
                                        _titleController,
                                        _noteController,
                                        Task(
                                          title: _titleController.text,
                                          note: _noteController.text,
                                          statusoffave: "notFavorite",
                                          statusofcomplete: "unCompleted",
                                          date: DateFormat.yMd()
                                              .format(cubit.selectedDateTime),
                                          startTime: cubit.startTime,
                                          endTime: cubit.endTime,
                                          color: _selectedColor,
                                          remind: _selectedRemind,
                                          repeat: _selectedRepeat,
                                        ),
                                        ctx);
                              },
                              label: cubit.createOrUpdate == "Add"
                                  ? StringManager.createButton
                                  : StringManager.update,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// color palettes
  Column colorPalette(AppCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //color
        CustomText(
          style: CustomTextStyles.subTitleStyle,
          text: StringManager.color,
        ),

        const SizedBox(height: 10),
        // colors
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            children: List<Widget>.generate(
              12,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 15, top: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: cubit.colorIndexing(index),
                    child: _selectedColor == index
                        ? const Icon(Icons.done, color: ColorManager.mainWight)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

// get color index
}
