

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttScreen extends StatefulWidget {
  const AttScreen({super.key});

  @override
  State<AttScreen> createState() => _AttScreenState();
}

class _AttScreenState extends State<AttScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, String> _attendanceData = {};

  void _onNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
  }

  void _onPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    });
  }

  @override
  void initState() {
    DateTime lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      DateTime day = DateTime(_focusedDay.year, _focusedDay.month, i + 1);
      print("Add Day:: $day");
      if(i%2==0){
        _attendanceData[day] = 'Present'; // Change to 'Present' if needed
      }else {
        _attendanceData[day] = 'Absent'; // Change to 'Present' if needed
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
      ),
      body: Container(
        child: Column(
          children: [
            _buildHeader(),
            Divider(height: 1,
              color: Colors.grey,),
            const SizedBox(height: 10.0),
            _buildDaysOfWeek(),
            const SizedBox(height: 10.0),
             _buildCalendar(),
            const SizedBox(height: 8.0),
            _buildAttendanceStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = DateFormat('MMM yyyy').format(_focusedDay);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _onPreviousMonth,
        ),
        Text(
          '${formattedDate}',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _onNextMonth,
        ),
      ],
    );
  }
  Widget _buildDaysOfWeek() {
    const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: daysOfWeek.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    List<Widget> dayWidgets = [];
    for (int i = 0; i < firstDayOfMonth.weekday - 1; i++) {
      dayWidgets.add(Container());
    }
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      final day = DateTime(_focusedDay.year, _focusedDay.month, i + 1);
      dayWidgets.add(_buildDayButton(day));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      children: dayWidgets,
    );
  }
  Widget _buildDayButton(DateTime day) {
    bool isSelected = day.day == _selectedDay.day && day.month == _selectedDay.month && day.year == _selectedDay.year;
    String? attendanceStatus = _attendanceData[day];
    print("Status:: $attendanceStatus");

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          print("Click Day: $_selectedDay :: $attendanceStatus");
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration:BoxDecoration(
          shape: BoxShape.circle,
          color: attendanceStatus=="Absent" ? Colors.red : attendanceStatus=="Present" ? Colors.green : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey),
        ) ,
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStatus() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDay);
    print("Print Status:: ${_attendanceData[_selectedDay]}");
    if (_attendanceData[_selectedDay] == null) {
      return Text('No attendance recorded for ${formattedDate}');
    } else {
      return Text('Attendance for ${formattedDate}: ${_attendanceData[_selectedDay]}');
    }
  }


}
