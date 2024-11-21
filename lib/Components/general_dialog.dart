import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Components/custom_row_widget.dart';
import 'package:plasma_donor/models/user_model.dart';

class GeneralDialog {
  static final instance = GeneralDialog();

  void showGeneralDialog(
    BuildContext context,
    Function() approve, // Approval function
    Function() reject, // Rejection function
    UserModel user,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'User Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        CustomRow(item: user.name, title: 'Name'),
                        CustomRow(item: user.email, title: 'Email'),
                        CustomRow(item: user.userType, title: 'User Type'),
                        CustomRow(item: user.gender, title: 'Gender'),
                        CustomRow(item: user.bloodGroup, title: 'Blood Group'),
                        CustomRow(item: user.phoneNumber, title: 'Phone'),
                        CustomRow(item: user.location, title: 'Location'),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () async {},
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: kPrimaryColor,
                                  minimumSize: const Size(80, 40),
                                  maximumSize: const Size(80, 40),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                      fontSize: 15, color: kWhiteColor),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () async {},
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: kPrimaryColor,
                                  minimumSize: const Size(80, 40),
                                  maximumSize: const Size(80, 40),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      fontSize: 15, color: kWhiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
