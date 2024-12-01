import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';

class TaskDescriptorProvider with ChangeNotifier{

  List<TaskDescriptor> descriptors = [
    TaskDescriptor(
      title: 'Laundry', 
      instructions: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ', 
      category: 'Cleaning', 
      icon: Icons.local_laundry_service),

    TaskDescriptor(
      title: 'Cooking', 
      instructions: 'Instructions on basic cooking...', 
      category: 'Cooking',  
      icon: Icons.countertops),

    TaskDescriptor(
      title: 'Gardening', 
      instructions: 'Instructions on gardening...', 
      category: 'Gardening', 
      icon: Icons.yard),
      
    TaskDescriptor(
      title: 'Mopping the floors', 
      instructions: 'Instructions on mopping...', 
      category: 'Cleaning', 
      icon: Icons.cleaning_services_outlined),
  ];

  void addTaskDescriptor (TaskDescriptor descriptor) async {
    descriptors.add(descriptor);
   // print('added a task with name: ${descriptor.title}');
   // print(descriptors.toString());
    notifyListeners();
  }
  // is this the same object?
  void removeTaskDescriptor(TaskDescriptor descriptor) {
    descriptors.remove(descriptor);
    notifyListeners();
  }

  void editTaskDescriptor(TaskDescriptor descriptor, String ntitle, String ninstructions, String ncategory, IconData nicon,) {
    //TaskDescriptor ntask = TaskDescriptor(title: ntitle, instructions: ninstructions, category: ncategory, icon: nicon);
    descriptor.title = ntitle;
    descriptor.instructions = ninstructions;
    descriptor.category = ncategory;
    descriptor.icon = nicon;
    notifyListeners();
  }

  int getLength() {
    return descriptors.length;
  }


} 