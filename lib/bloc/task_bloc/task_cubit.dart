// import 'package:bloc/bloc.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:todotasks/bloc/task_bloc/task_states.dart';
import 'package:todotasks/data/db/db_helper.dart';
import 'package:todotasks/data/models/tasks_model.dart';
import 'package:todotasks/presentation/resources/color_manager.dart';
import 'package:todotasks/presentation/resources/string_manager.dart';

import '../../data/reposetory/tasks_reposetory.dart';
import '../../data/services/notifications_services.dart';
import '../../presentation/components/shared/shared_components.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // CUBIT INITIALIZATION INSTANCE
  static AppCubit get(context) {
    return BlocProvider.of(context);
  }

////**************************************************************************************
  //*                          1- Time Picker logic                                    ***
  //*                          2- DateTime PickerLojic                                 ***
  //                           3- NOTIFICATIONS INITIALIZARION                         ***
  //**************************************************************************************
// TIME AND DATE PICKERS

  initializeNotifications() async {
    await NotificationApi.initializeNotification();
    NotificationApi.requestIOSPermissions();
    emit(InitializeNotificationState());
  }

  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  DateTime selectedDateTime = DateTime.now();

  setStarttime(formatedTime) {
    startTime = formatedTime;
    emit(ShowTimePicker());
  }

  setEndtime(formatedTime) {
    endTime = formatedTime;
    emit(ShowTimePicker());
  }

// time picker
  getTimeFromUser(context, {required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      helpText: "Enter your time as you want",
      // cancelText: "خروج",
      // confirmText: "تأكيد",
      // minuteLabelText: "دقائق",
      // hourLabelText: "ساعات",
      // errorInvalidText: "تاكد من ان الوقت الذي ادخلته صحيح",
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String formatedTime = pickedTime!.format(context);
    if (isStartTime) {
      setStarttime(formatedTime);
    } else if (!isStartTime) {
      setEndtime(formatedTime);
    } else {
      debugPrint("it's null or something wrong!");
    }
  }

  setDateState(pickedDate) {
    selectedDateTime = pickedDate;
    emit(ShowDtePicker());
  }

// date picker
  getDateFromUser(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    if (pickedDate != null) {
      setDateState(pickedDate);
    } else {
      debugPrint("it's null or something wrong!");
    }
  }

////**************************************************************************************
  //*                          1- DateTime  Picker of Schedule                         ***
  //*                          2- Schedule page logic                                  ***
  //**************************************************************************************

  DateTime? selectedDate = DateTime.now();

  setDatePicket(newDate) {
    selectedDate = newDate;
    emit(DateTimePickerForSheduled());
  }

  // ignore: slash_for_doc_comments
  /****************************************************************************************
    *                          1- lists foe cach data on ui                             ***
    *                          2- data base creation                                    ***
    *                          2- DATABASE HANDLING                                     ***
    ***************************************************************************************/

  List<Widget> tabsTitle = [
    //all
    const CustomText(
      text: StringManager.all,
    ),
    //completed
    CustomText(
      text: StringManager.completed,
    ),
    //uncompleted
    CustomText(
      text: StringManager.uncompleted,
    ),
    //favorite
    CustomText(
      text: StringManager.favoret,
    ),
  ];

  // CREATE DATABASE
  createDataBase() {
    DBHelper.database.then((value) {
      emit(AppCreateDatabaseState());
    });
  }

  // REPO INSTANCE
  TodoRepository todoRepository = TodoRepository();

  // LISTS OF HANDLING REPRESENTING TASKS
  List<String> statusoftasks = [
    "completed",
    "unCompleted",
    "favorite",
    "notFavorite"
  ];
  List<Task> todos = TodoRepository.listtodos;
  List<Task> allTasks = [];
  List<Task> completed = [];
  List<Task> unCompleted = [];
  List<Task> favorite = [];
  List<Task> searchList = [];

  // search FUNCTION into database
  setSearchList(valueTosearchBy) {
    searchList.clear();
    emit(SetSearchListState());
    for (var element in allTasks) {
      if (element.title!.contains(valueTosearchBy)) {
        searchList.add(element);
        emit(SetSearchListState());
      }
    }
    emit(SetSearchListState());
  }

  // GET ALL FROM DATABASE
  void getDataBase() async {
    allTasks = [];
    completed = [];
    unCompleted = [];
    favorite = [];

    todoRepository.getAllTodos().then((value) {
      // print(todos.toList());
      for (var element in value) {
        allTasks.add(element);
        if (element.statusofcomplete == statusoftasks[0]) {
          completed.add(element);
          if (element.statusoffave == statusoftasks[2]) {
            favorite.add(element);
          }
          // debugPrint("========================??${completed[0]}");
          // emit(AppGetDatabaseLoadingState());
        } else if (element.statusofcomplete == statusoftasks[1]) {
          unCompleted.add(element);
          if (element.statusoffave == statusoftasks[2]) {
            favorite.add(element);
          }
          emit(AppGetDatabaseLoadingState());
          // debugPrint("========================??${unCompleted[0]}");
        } else if (element.statusoffave == statusoftasks[2]) {
          favorite.add(element);
          // debugPrint(
          //     "========================?? tas00000000000000000000000000000000ks ${favorite[0].toString()}");

          emit(AppUpdateDatabasefavoritState());
          // emit(AppGetDatabaseLoadingState());
        }
        // debugPrint("========================??${allTasks[0].toString()}");
        emit(AppGetDatabaseLoadingState());
      }
    });
  }

  // UPDATE ALL DATA
  updateAllData({
    required Task task,
  }) {
    todoRepository.updateAllTask(task).then((value) {
      getDataBase();
      emit(AppUpdateDatabaseState());
      debugPrint("from cubit update method");
      for (var element in allTasks) {
        debugPrint(element.title.toString());
      }
    });
  }

  // UPDATE STATUS ONLY
  updateStatus({
    required String statusoffave,
    required String statusofcomplete,
    required int id,
  }) {
    todoRepository
        .updateStatus(statusoffave, statusofcomplete, id)
        .then((value) {
      emit(AppUpdateDatabaseState());
      getDataBase();
    });
  }

  // INITIAL VALUE IS ADDING
  String createOrUpdate = "Add";
  // HANDLING STATE OF CREATE OR UPDATE TSK
  setCreateOrUpdateTask(setTypeCreateOrUpdate) {
    createOrUpdate = setTypeCreateOrUpdate;
    emit(CreateOrUpdateTaskState());
    debugPrint(createOrUpdate);
  }

  // FUNCTION OF  ADD NEW TASK
  validateDataforAdd(titleController, noteController, task, ctx) async {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      await insertToDatabase(task: task);
      Future.delayed(
          const Duration(seconds: 10),
          () => NotificationApi.displayNotification(
              title: "new Note", body: "you have created new note "));
      Navigator.of(ctx).pop();
      debugPrint(
          "you have created onefrom validate method new 000000000000000000000000000000000000000000000");
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          dismissDirection: DismissDirection.up,
          backgroundColor: ColorManager.primarySwitch,
          content: Text(
            "pleas inter a title and note ",
          )));
    } else {
      debugPrint("SOME THING GO WRONG!!");
    }
    // Navigator.of(context).pop();
  }

  // insert to database
  insertToDatabase({
    required Task task,
  }) {
    todoRepository.insertTodo(task).then((value) {
      emit(AppInsertDatabaseState());
      getDataBase();
    });
  }

  // FUNCTION OF DOING EDIT ALL TASK
  validateDataforUpdate(titleController, noteController, task, ctx) async {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      await updateAllData(task: task);
      // getDataBase();
      Navigator.of(ctx).pop();
      debugPrint(
          "you have updated new task here ya sedy from validate method  1111111111111111111");
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          dismissDirection: DismissDirection.up,
          backgroundColor: ColorManager.primarySwitch,
          content: Text(
            "pleas inter a title and note ",
          )));
    } else {
      debugPrint("SOME THING GO WRONG!!");
    }
    getDataBase();
    // Navigator.of(context).pop();
  }

  // DELETE PARTICULAR DATA
  void deleteData({
    required int id,
  }) {
    todoRepository.deleteTodoById(id).then((value) {
      getDataBase();
      NotificationApi.cancelNotification(id);
      emit(AppDeleteDatabaseState());
    });
  }

  // DELETE ALL TASKS
  void deleteAllData() {
    todoRepository.deleteAllTodos().then((value) {
      getDataBase();
      NotificationApi.cancelAllNotification();
      emit(AppDeleteDatabaseState());
    });
  }

  // HANDLLING COLOR PALET
  Color? colorIndexing(index) {
    return index == 0
        ? Color.fromRGBO(45, 45, 45, 0.544)
        : index == 1
            ? const Color.fromARGB(255, 255, 7, 28)
            : index == 2
                ? const Color.fromARGB(255, 250, 33, 192)
                : index == 3
                    ? const Color.fromARGB(255, 5, 123, 132)
                    : index == 4
                        ? const Color.fromARGB(255, 5, 148, 91)
                        : index == 5
                            ? const Color.fromARGB(255, 4, 155, 9)
                            : index == 6
                                ? const Color.fromARGB(255, 167, 191, 59)
                                : index == 7
                                    ? const Color.fromARGB(255, 253, 60, 21)
                                    : index == 8
                                        ? const Color.fromARGB(255, 45, 37, 77)
                                        : index == 9
                                            ? const Color.fromARGB(
                                                255, 192, 93, 17)
                                            : index == 10
                                                ? const Color.fromARGB(
                                                    255, 237, 219, 26)
                                                : index == 11
                                                    ? const Color.fromARGB(
                                                        255, 237, 18, 178)
                                                    : const Color.fromARGB(
                                                        255, 113, 4, 4);
    // return color;
  }
}
