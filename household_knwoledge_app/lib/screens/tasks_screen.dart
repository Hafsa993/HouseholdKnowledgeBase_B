import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/task_descriptions_provider.dart';
import 'package:household_knwoledge_app/screens/add_task_description_screen.dart';
import 'package:household_knwoledge_app/screens/task_description_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_drawer.dart';
import './change_task_descriptor_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String dropdownvalue = 'All Categories';
  String searchQuery = '';
  List<TaskDescriptor> filteredDescriptors = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredDescriptors with all descriptors from the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final allDescriptors = context.read<TaskDescriptorProvider>().descriptors;
      setState(() {
        filteredDescriptors = List.from(allDescriptors);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Listen to changes in the provider
    final allDescriptors = context.watch<TaskDescriptorProvider>().descriptors;
    bool? isDeleted = false;

    // Apply filtering whenever allDescriptors, searchQuery, or dropdownvalue changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterTasks(searchQuery, dropdownvalue, allDescriptors);
    });

    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 211, 239, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('Instructions'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          SizedBox(height: 10,),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterTasks(searchQuery, dropdownvalue, allDescriptors);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 66, 67, 67),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 57, 58, 57),
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Dropdown Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownvalue,
              items: selectableCategories.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: getCategoryColor(items),
                                radius: 5,
                              ),
                              SizedBox(width: 8),
                              Text(items),
                            ],
                          ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    dropdownvalue = newValue;
                    filterTasks(searchQuery, newValue, allDescriptors);
                  });
                }
              },
            ),
          ),
          // Task List
          Expanded(
            child: filteredDescriptors.isEmpty
                ? Center(child: Text('No tasks found.'))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    //physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredDescriptors.length,
                    itemBuilder: (context, index) {
                      TaskDescriptor descriptor = filteredDescriptors[index];
                      return SizedBox(
                        width: 350,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(descriptor.icon),
                                
                                iconColor: categoryColor(descriptor.category),
                                title: Text(descriptor.title, style: TextStyle(fontSize: 20),),
                                subtitle: Text(descriptor.category, style: TextStyle(color: categoryColor(descriptor.category)),),
                                /*
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDescriptionScreen(task: descriptor),
                                    ),
                                  );
                                },
                                */
                              ),
                            Divider(indent: 5, endIndent: 5, color: Colors.grey,),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(10.0),
                                children: [Text(descriptor.instructions, style: TextStyle(fontSize: 16),)],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                children: [Wrap(
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          //shape: WidgetStateProperty.all(CircleBorder()),
                                          //padding: WidgetStateProperty.all(EdgeInsets.all(-5)),
                                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                                        ),
                                        onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ChangeTaskDescriptorScreen(task: descriptor),
                                                    ),
                                                  ).then((val) {
                                                    if (val != null) {
                                                      setState(() {
                                                        //temptask = val;
                                                      });
                                                    }
                                                  });
                                                }, 
                                        
                                        child: const Icon(Icons.edit, color: Colors.white, size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      ElevatedButton(
                                        
                                        style: ButtonStyle(
                                          //shape: WidgetStateProperty.all(CircleBorder()),
                                          //padding: WidgetStateProperty.all(EdgeInsets.all(-20)),
                                          backgroundColor: WidgetStateProperty.all(Colors.red),
                                        ),
                                        onPressed: () async {
                                                  isDeleted = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text("Are you sure you want to delete this instruction?"),
                                                        content: const Text("This is a non-reversible action."),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context, true);
                                                            },
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Colors.white,
                                                              backgroundColor: Colors.red,
                                                            ),
                                                            child: const Text('Yes, really delete'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, false),
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Colors.white,
                                                              backgroundColor: Colors.grey,
                                                            ),
                                                            child: const Text("No, don't delete"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  
                                                  if (isDeleted == true) {
                                                    Provider.of<TaskDescriptorProvider>(context, listen: false).removeTaskDescriptor(descriptor);
                                                    //Navigator.of(context).pop();
                                                  }
                                                }, 
                                        child: const Icon(Icons.delete, color: Colors.white, size: 20,),
                                      ),
                                    ],
                                  ),],),
                            )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Add Instruction Button
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 21, 208, 255))),
              icon: const Icon(Icons.add, size: 20, color: Colors.white,),
                  label: Text('Add new instruction', style: TextStyle(fontSize: 20, color: Colors.white,)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskDescriptorScreen(),
                      ),
                    );
                  },
                ),
          ),]
        ),
      ),
    );
  }

  // Function to filter tasks based on search query and selected category
  void filterTasks(String query, String category, List<TaskDescriptor> allTasks) {
    List<TaskDescriptor> tempList = allTasks;

    // Filter by category
    if (category != 'All Categories') {
      tempList = tempList.where((task) => task.category == category).toList();
    }

    // Filter by search query
    if (query.isNotEmpty) {
      tempList = tempList.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.instructions.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredDescriptors = tempList;
    });
  }
}

Color getCategoryColor(String s) {
  if (s == 'All Categories') {
    return Colors.black;
  } else {
    return categoryColor(s);
  }
}

