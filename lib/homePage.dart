import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:mosjider_hisab/add.dart';
import 'package:mosjider_hisab/dbHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DBHelper dbHelper = DBHelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;


  getTotalBalance(Map entireData){
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    entireData.forEach((key, value) {
      if(value['type'] == "income"){
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      }else{
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  void removeItem(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF113452),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF144652),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Add()),
          ).whenComplete(() {
            setState(() {

            });
          });
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: FutureBuilder<Map>(
          future: dbHelper.fetch(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return const Center(child: Text('Unexpected Error!'),);
            }
            if(snapshot.hasData){
              if(snapshot.data!.isEmpty){
                return const Center(
                  child: Text(
                    'নিচের বাটনটি চেপে হিসাবের খাতা খুলুন ।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              getTotalBalance(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              child: Text(
                                'হিসাবের খাতা',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: const Color(0xFF1B5261),
                          ),
                          child: Icon(
                            Icons.account_balance_outlined,
                            size: 30.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5.w),
                        width: MediaQuery.of(context).size.width,
                        height: 260.h,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF143652),
                                Color(0xFF723552),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(2, 4),
                                blurRadius: 20,
                              ),
                            ]
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h,),
                            Text(
                              'পুরিন্দা পূর্বপাড়া কেন্দ্রিয় জামে মসজিদ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: 16.h,),
                            Text(
                              'মোট টাকা',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h,),
                            Text(
                              '৳ ${BanglaUtility.englishToBanglaDigit(englishDigit: totalBalance)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, top: 15.w,right: 20.w,bottom: 15.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  cardIncome(BanglaUtility.englishToBanglaDigit(englishDigit: totalIncome)),

                                  cardExpense(BanglaUtility.englishToBanglaDigit(englishDigit: totalExpense)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35.h,),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      'আয়-ব্যয় এর তালিকা',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        Map infoAtIndex = snapshot.data![index];
                        if(infoAtIndex['type'] == "income"){
                          return incomeTitle(infoAtIndex["amount"], infoAtIndex["date"] , infoAtIndex["note"]);
                        }else{
                          return expenseTitle(infoAtIndex["amount"], infoAtIndex["date"], infoAtIndex["note"]);
                        }

                      }
                  ),
                ],
              );
            }else{
              return const Center(child: Text('Unexpected Error!'),);
            }
          }
      ),
    );
  }

  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.only(right: 10.w),
          child: Icon(
            Icons.arrow_downward_outlined,
            size: 20.w,
            color: Colors.greenAccent,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আয়',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5.h,),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],

    );
  }

  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.only(right: 10.w),
          child: Icon(
            Icons.arrow_upward_outlined,
            size: 20.w,
            color: Colors.redAccent,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ব্যয়',
              style: TextStyle(
                  color: Color(0xFFF67171),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5.h,),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }


Widget incomeTitle(int value,DateTime date, String note){
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffC9D8DC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Flexible(
                      child: Text(
                        note,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      child: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down_outlined,
                    color: Colors.green,
                    size: 25.w,
                  ),
                  SizedBox(width: 6.w,),
                  Text(
                    'আয়',
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    DateFormat("dd-MM-yyyy").format(date),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                ],
              ),


              Text(
                '+ ${BanglaUtility.englishToBanglaDigit(englishDigit: value)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }


  Widget expenseTitle(int value,DateTime date, String note){
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffC9D8DC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Flexible(
                      child: Text(
                        note,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up_outlined,
                    color: Colors.red,
                    size: 25.w,
                  ),
                  SizedBox(width: 6.w,),
                  Text(
                    'ব্যয়',
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    DateFormat("dd-MM-yyyy").format(date),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                ],
              ),


              Text(
                '+ ${BanglaUtility.englishToBanglaDigit(englishDigit: value)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }


}
