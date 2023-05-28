import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:mosjider_hisab/dbHelper.dart';
import 'package:mosjider_hisab/homePage.dart';
import 'package:motion_toast/motion_toast.dart';



class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  int? amount;
  String note = "";
  String type = "income";
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime ? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 12),
      lastDate: DateTime(3000, 01),
    );
    if(picked != null && picked != selectedDate){
      selectedDate = picked;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF113452),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12.w),
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child:
                        IconButton( icon: const Icon(Icons.arrow_back, color: Colors.white,),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return const HomePage();
                                }),);
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 25.w),
                        child: Text(
                          'টাকার পরিমান যোগ করুন',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 110.h,),

            Container(
              padding: EdgeInsets.all(20.w),
              height: 400.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF146799),
                    Color(0xFF723752),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("৳", style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.white,
                      ),
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "০",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                          ),
                          onChanged: (val){
                            try{
                              BanglaUtility.englishToBanglaDigit(englishDigit: amount = int.parse(val));
                            }catch(e){}
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 26.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "বর্ণনা করুন",
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                          onChanged: (val){
                            note = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      Icon(
                        Icons.moving_sharp,
                        size: 26.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20.w,),
                      ChoiceChip(
                        label: Text(
                          'আয়',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: type == "income" ? Colors.white : Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w, bottom: 3.h),
                        selectedColor: const Color(0xFF34AD78),
                        backgroundColor: const Color(0xFF723552),
                        selected: type == "income" ? true : false,
                        onSelected: (val){
                          if(val){
                            setState(() {
                              type = "income";
                            });
                          }
                        },
                      ),
                      SizedBox(width: 20.w,),
                      ChoiceChip(
                        label: Text(
                          'ব্যয়',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: type == "expense" ? Colors.white : Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w, bottom: 3.h),
                        selectedColor: const Color(0xFF34AD78),
                        backgroundColor: const Color(0xFF723552),
                        selected: type == "expense" ? true : false,
                        onSelected: (val){
                          if(val){
                            setState(() {
                              type = "expense";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 26.w,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w,),
                        TextButton(
                          onPressed: (){
                            _selectDate(context);

                          },
                          child: Text(
                            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h,),
                  SizedBox(
                    width: 200.w,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF146799)),
                        elevation: MaterialStateProperty.all(20),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        ),
                      ),
                      onPressed: () async {
                        if(amount != null && note.isNotEmpty){
                          DBHelper dbHelper = DBHelper();
                          dbHelper.addData(amount!, selectedDate, note, type);
                          Navigator.of(context).pop();
                          showToastSuccessMsg(context);
                        }else{
                          showToastMsg(context);
                        }
                      },
                      child: Text(
                        "যোগ করুন",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToastSuccessMsg(context){
    MotionToast.success(
      description: Text("আপনার কাজটি সফল হয়েছে",
        style: TextStyle(
          color: Colors.green,
          fontSize: 18.sp,
        ),
      ),
      title: Text("সঠিক হয়েছে",
        style: TextStyle(
          color: Colors.green,
          fontSize: 18.sp,
        ),
      ),
    ).show(context);
  }
  void showToastMsg(context){
    MotionToast.error(
      description: Text("সকল ঘর পূরণ করোন",
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.sp,
        ),
      ),
      title: Text("ঘর খালি আছে",
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.sp,
        ),
      ),
    ).show(context);
  }
}
