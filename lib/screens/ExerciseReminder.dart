import 'package:flutter/material.dart';
import 'MemoryGames.dart';
import 'package:my_app/theme/app_theme.dart';

class ExerciseReminder extends StatefulWidget {
  const ExerciseReminder({super.key});

  @override
  State<ExerciseReminder> createState() =>
      _ExerciseReminderState();
}

class _ExerciseReminderState
    extends State<ExerciseReminder> {

  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      bottomNavigationBar: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(
              icon: Icons.home_outlined,
              title: "HOME",
              active: false,
            ),
            navItem(
              icon: Icons.favorite_border,
              title: "REHAB",
              active: false,
            ),
            navItem(
              icon:  Icons.notifications_outlined,
              title: "ALERTS",
              active: true,
            ),
            navItem(
              icon: Icons.person_outline,
              title: "PROFILE",
              active: false,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 12),

                Row(
                  children: [

                    const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Color(0xffC2410C),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "Exercise Reminders",
                      style: AppTextStyles.bodyMedium
                          .copyWith(
                        color:
                            const Color(0xffC2410C),
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 34),

                Text(
                  "Set Your Schedule",
                  style: AppTextStyles
                      .headlineMedium
                      .copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color:
                        const Color(0xff1A1C1C),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Choose your optimal recovery times.",
                  style:
                      AppTextStyles.bodyMedium
                          .copyWith(
                    color:
                        const Color(0xff414752),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "SELECTED DAYS",
                  style:
                      AppTextStyles.bodyMedium
                          .copyWith(
                    color:
                        const Color(0xff414752),
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 1,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 18),

                Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        dayCircle("M", true),
                        dayCircle("T", false),
                        dayCircle("W", true),
                        dayCircle("T", false),
                        dayCircle("F", true),

                        const SizedBox(width: 38),
                        const SizedBox(width: 38),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        dayCircle("S", false),

                        const SizedBox(width: 38),
                        const SizedBox(width: 38),
                        const SizedBox(width: 38),

                        dayCircle("S", false),

                        const SizedBox(width: 38),
                        const SizedBox(width: 38),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(24),
                  ),

                  child: Column(
                    children: [

                      Text(
                        "DAILY REMINDER TIME",
                        style: AppTextStyles
                            .bodyMedium
                            .copyWith(
                          color: const Color(
                              0xff414752),
                          letterSpacing: 1.5,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          timePicker("09"),

                          const SizedBox(width: 10),

                          Text(
                            ":",
                            style: AppTextStyles
                                .headlineLarge
                                .copyWith(
                              fontSize: 42,
                              fontWeight:
                                  FontWeight.bold,
                              color: const Color(
                                  0xff1A1C1C),
                            ),
                          ),

                          const SizedBox(width: 10),

                          timePicker("30"),

                          const SizedBox(width: 14),

                          Column(
                            children: [

                              amPmButton(
                                  "AM", true),

                              const SizedBox(
                                  height: 10),

                              amPmButton(
                                  "PM", false),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),

                  decoration: BoxDecoration(
                    color:
                        const Color(0xffF5F5F5),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [

                      /// LEFT BELL
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: const Color(
                              0xffDCEBFF),
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),

                        child: const Icon(
                          Icons.notifications_none,
                          color:
                              Color(0xff001C3A),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          "Allow\nNotifications",
                          style: AppTextStyles
                              .bodyLarge
                              .copyWith(
                            fontWeight:
                                FontWeight.bold,
                            height: 1.3,
                            color: const Color(
                                0xff1A1C1C),
                          ),
                        ),
                      ),

                      Switch(
                       value: notificationsEnabled,
                      onChanged: (value) {
                       setState(() {
                         notificationsEnabled = value;
                         });
                        },

                      activeColor: Colors.white,
                       activeTrackColor:
                        const Color(0xff934800),
                       inactiveThumbColor:
                        Colors.white,
                       inactiveTrackColor:
                        Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),

                  decoration: BoxDecoration(
                    color:
                        const Color(0xffDFF5D7),
                    borderRadius:
                        BorderRadius.circular(22),
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 24,
                        height: 24,

                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.check,
                          color:
                              Color(0xff005312),
                          size: 16,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Consistency is key to faster\nrecovery",
                          style: AppTextStyles
                              .bodyMedium
                              .copyWith(
                            color:
                                const Color(
                                    0xff005312),
                            fontWeight:
                                FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MemoryGames(),
                      ),
                    );
                  },

                  child: Container(
                    width: double.infinity,
                    height: 62,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xff934800),
                      borderRadius:
                          BorderRadius.circular(
                              18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.08),
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        Text(
                          "SAVE MY SCHEDULE",
                          style: AppTextStyles
                              .buttonText
                              .copyWith(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons
                              .check_circle_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 34),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xffCFE0FF),
                        Color(0xffBCD3FF),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                            24),
                  ),

                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              "Your Journey\nMatters",
                              style: AppTextStyles
                                  .headlineMedium
                                  .copyWith(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                height: 1.3,
                                color:
                                    const Color(
                                        0xff001C3A),
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              "Most users find that\nmorning sessions lead\nto a 40% higher\ncompletion rate.",
                              style: AppTextStyles
                                  .bodyMedium
                                  .copyWith(
                                color:
                                    const Color(
                                        0xff003567),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 72,
                        height: 72,

                        decoration:
                            const BoxDecoration(
                          color:
                              Color(0xffDCEBFF),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.show_chart,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dayCircle(String day, bool active) {
    return Container(
      width: 38,
      height: 38,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xffB85C00)
            : Colors.grey.shade200,

        shape: BoxShape.circle,
      ),

      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: active
                ? Colors.white
                : const Color(0xff1A1C1C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget timePicker(String value) {
    return Column(
      children: [

        const Icon(
          Icons.keyboard_arrow_up,
          color: Color(0xff934800),
        ),

        Container(
          width: 72,
          height: 62,

          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius:
                BorderRadius.circular(16),
          ),

          child: Center(
            child: Text(
              value,
              style: AppTextStyles
                  .headlineLarge
                  .copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color:
                    const Color(0xff1A1C1C),
              ),
            ),
          ),
        ),

        const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff934800),
        ),
      ],
    );
  }

  Widget amPmButton(String text, bool active) {
    return Container(
      width: 50,
      height: 36,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xffFFDCC6)
            : Colors.grey.shade200,
        borderRadius:
            BorderRadius.circular(10),
      ),

      child: Center(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium
              .copyWith(
            fontWeight: FontWeight.bold,
            color: active
                ? const Color(0xff311300)
                : const Color(0xff414752),
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: active
                ? const Color(0xffF8E3CC)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Icon(
            icon,
            size: 22,
            color: active
                ? AppColors.primaryColor
                : AppColors.lightTextColor,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: active
                ? AppColors.primaryColor
                : AppColors.lightTextColor,
          ),
        ),
      ],
    );
  }
}