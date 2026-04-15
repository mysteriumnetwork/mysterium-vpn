import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class CustomPlatformMenu extends StatefulWidget {
  const CustomPlatformMenu({required this.child, required this.appName, super.key});
  final Widget child;
  final String appName;

  @override
  State<CustomPlatformMenu> createState() => _CustomPlatformMenuState();
}

class _CustomPlatformMenuState extends State<CustomPlatformMenu> with WindowListener {
  bool isAppWindowFocused = true;
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void onWindowEvent(String eventType) {
    if (eventType == 'closed' || eventType == 'minimized' || eventType == 'blur') {
      setState(() {
        isAppWindowFocused = false;
      });
    }
    if (eventType == 'restored' || eventType == 'focus') {
      setState(() {
        isAppWindowFocused = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Platform.isMacOS
      ? PlatformMenuBar(
          menus: <PlatformMenuItem>[
            PlatformMenu(
              label: widget.appName,
              menus: <PlatformMenuItem>[
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.about))
                      const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.servicesSubmenu,
                    ))
                      const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.servicesSubmenu,
                      ),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.hide))
                      const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
                    if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.hideOtherApplications,
                    ))
                      const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.hideOtherApplications,
                      ),
                    if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.showAllApplications,
                    ))
                      const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.showAllApplications,
                      ),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.quit))
                      const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
                  ],
                ),
              ],
            ),
            const PlatformMenu(
              label: 'File',
              menus: <PlatformMenuItem>[
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'New',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyN, meta: true),
                    ),
                  ],
                ),
              ],
            ),
            PlatformMenu(
              label: 'Edit',
              menus: <PlatformMenuItem>[
                const PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'Undo',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
                    ),
                    PlatformMenuItem(
                      label: 'Redo',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyZ, meta: true, shift: true),
                    ),
                  ],
                ),
                const PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'Cut',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyX, meta: true),
                    ),
                    PlatformMenuItem(
                      label: 'Copy',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyC, meta: true),
                    ),
                    PlatformMenuItem(
                      label: 'Paste',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyV, meta: true),
                    ),
                    PlatformMenuItem(label: 'Delete'),
                  ],
                ),
                const PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'Select All',
                      shortcut: SingleActivator(LogicalKeyboardKey.keyA, meta: true),
                    ),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenu(
                      label: 'Speech',
                      menus: <PlatformMenuItem>[
                        PlatformMenuItemGroup(
                          members: <PlatformMenuItem>[
                            if (PlatformProvidedMenuItem.hasMenu(
                              PlatformProvidedMenuItemType.startSpeaking,
                            ))
                              const PlatformProvidedMenuItem(
                                type: PlatformProvidedMenuItemType.startSpeaking,
                              ),
                            if (PlatformProvidedMenuItem.hasMenu(
                              PlatformProvidedMenuItemType.stopSpeaking,
                            ))
                              const PlatformProvidedMenuItem(
                                type: PlatformProvidedMenuItemType.stopSpeaking,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            PlatformMenu(
              label: 'View',
              menus: <PlatformMenuItem>[
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.toggleFullScreen,
                    ))
                      const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.toggleFullScreen,
                      ),
                  ],
                ),
              ],
            ),
            PlatformMenu(
              label: 'Window',
              menus: <PlatformMenuItem>[
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'Close',
                      shortcut: const SingleActivator(LogicalKeyboardKey.keyW, meta: true),
                      onSelected: isAppWindowFocused
                          ? () async {
                              if (await windowManager.isVisible()) {
                                windowManager.hide();
                              }
                            }
                          : null,
                    ),
                    PlatformMenuItem(
                      label: 'Minimize',
                      shortcut: const SingleActivator(LogicalKeyboardKey.keyM, meta: true),
                      onSelected: isAppWindowFocused
                          ? () async {
                              if (await windowManager.isMinimized()) {
                                return;
                              }
                              windowManager.minimize();
                            }
                          : null,
                    ),
                    if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.zoomWindow))
                      const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: widget.appName,
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.digit1,
                        meta: true,
                        shift: true,
                      ),
                      onSelected: () async {
                        if (!(await windowManager.isVisible())) {
                          windowManager.show();
                        }
                      },
                    ),
                  ],
                ),
                PlatformMenuItemGroup(
                  members: <PlatformMenuItem>[
                    PlatformMenuItem(
                      label: 'Bring All to Front',
                      onSelected: () async {
                        if (!(await windowManager.isVisible())) {
                          windowManager.show();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
          child: widget.child,
        )
      : SizedBox(child: widget.child);
}
