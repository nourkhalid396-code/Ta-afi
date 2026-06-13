import 'package:flutter/material.dart';
import 'package:my_app/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // TOP BAR
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.healing,
                      color: Color(0xff934800),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "Ta'afi",
                      style:
                          AppTextStyles.headlineMedium.copyWith(
                        color: const Color(0xff934800),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.more_vert,
                      color: Color(0xff64748B),
                    ),
                  ],
                ),
              ),

              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 50,
                ),

                color: const Color(0xff934800),

                child: Column(
                  children: [

                    Container(
                      width: 96,
                      height: 96,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xff934800),
                        size: 48,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Ahmad Khalil",
                      style:
                          AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "ahmad@email.com",
                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -28),

                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  child: Column(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.all(22),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                                  26),
                        ),

                        child: Column(
                          children: [

                            statTile(
                              Icons.local_fire_department,
                              "Streak",
                              "7 days",
                            ),

                            const Divider(
                              height: 28,
                            ),

                            statTile(
                              Icons.emoji_events,
                              "Total Sessions",
                              "24",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Align(
                        alignment:
                            Alignment.centerLeft,

                        child: Text(
                          "SETTINGS",

                          style:
                              AppTextStyles
                                  .bodyMedium
                                  .copyWith(
                            color:
                                const Color(
                                    0xff94A3B8),

                            fontWeight:
                                FontWeight
                                    .bold,

                            letterSpacing:
                                1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      settingsContainer(
                        children: [

                          settingsRow(
                            icon: Icons
                                .notifications_none,

                            title:
                                "Notifications",

                            trailing:
                                Switch(
                              value:
                                  notificationsEnabled,

                              onChanged:
                                  (value) {
                                setState(() {
                                  notificationsEnabled =
                                      value;
                                });
                              },

                              activeColor:
                                  Colors
                                      .white,

                              activeTrackColor:
                                  const Color(
                                      0xff934800),

                              inactiveThumbColor:
                                  Colors
                                      .white,

                              inactiveTrackColor:
                                  Colors.grey
                                      .shade300,
                            ),
                          ),

                          divider(),

                          settingsRow(
                            icon:
                                Icons.language,

                            title:
                                "Language",

                            trailing:
                                Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,

                              children: const [

                                Text(
                                  "العربية",

                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                            0xff934800),
                                  ),
                                ),

                                SizedBox(
                                    width:
                                        4),

                                Icon(
                                  Icons
                                      .chevron_right,

                                  color:
                                      Color(
                                          0xffCBD5E1),
                                ),
                              ],
                            ),
                          ),

                          divider(),

                          settingsRow(
                            icon: Icons
                                .edit_outlined,

                            title:
                                "Edit Profile",

                            trailing:
                                const Icon(
                              Icons
                                  .chevron_right,

                              color: Color(
                                  0xffCBD5E1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      settingsContainer(
                        children: [

                          settingsRow(
                            icon: Icons
                                .lock_outline,

                            title:
                                "Change Password",

                            trailing:
                                const Icon(
                              Icons
                                  .chevron_right,

                              color: Color(
                                  0xffCBD5E1),
                            ),
                          ),

                          divider(),

                          settingsRow(
                            icon: Icons
                                .help_outline,

                            title:
                                "Help & Support",

                            trailing:
                                const Icon(
                              Icons
                                  .chevron_right,

                              color: Color(
                                  0xffCBD5E1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      Container(
                        width:
                            double.infinity,

                        height: 64,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      24),

                          border:
                              Border.all(
                            color:
                                const Color(
                                    0xffF3C4C4),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            const Icon(
                              Icons.logout,
                              color:
                                  Colors.red,
                            ),

                            const SizedBox(
                                width:
                                    10),

                            Text(
                              "Log Out",

                              style:
                                  AppTextStyles
                                      .bodyLarge
                                      .copyWith(
                                color:
                                    Colors.red,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statTile(
      IconData icon,
      String title,
      String value) {
    return Row(
      children: [

        Icon(
          icon,
          color:
              const Color(0xff934800),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(title),
        ),

        Text(
          value,

          style:
              const TextStyle(
            color:
                Color(0xff934800),

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget settingsContainer({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                24),
      ),

      child: Column(
        children: children,
      ),
    );
  }

  Widget settingsRow({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding:
          const EdgeInsets.all(18),

      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 16),

          Expanded(
            child: Text(title),
          ),

          trailing,
        ],
      ),
    );
  }

  Widget divider() {
    return const Divider(
      height: 1,
      indent: 18,
      endIndent: 18,
    );
  }
}
