import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class CustomPlatformMenu extends ConsumerWidget {
  const CustomPlatformMenu({required this.child, required this.appName, super.key});
  final Widget child;
  final String appName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(isAppWindowFocused);
    return Platform.isMacOS
        ? PlatformMenuBar(
            menus: <PlatformMenuItem>[
              PlatformMenu(
                label: appName,
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
                        onSelected: isVisible
                            ? () {
                                final window = mainWindow;
                                if (window != null && window.isVisible) {
                                  window.hide();
                                }
                              }
                            : null,
                      ),
                      PlatformMenuItem(
                        label: 'Minimize',
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyM, meta: true),
                        onSelected: isVisible
                            ? () {
                                final window = mainWindow;
                                if (window == null || window.isMinimized) {
                                  return;
                                }
                                window.minimize();
                              }
                            : null,
                      ),
                      if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.zoomWindow))
                        PlatformProvidedMenuItem(
                          type: PlatformProvidedMenuItemType.zoomWindow,
                          enabled: isVisible,
                        ),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: <PlatformMenuItem>[
                      PlatformMenuItem(
                        label: appName,
                        shortcut: const SingleActivator(
                          LogicalKeyboardKey.digit1,
                          meta: true,
                          shift: true,
                        ),
                        onSelected: showMainWindow,
                      ),
                    ],
                  ),
                  const PlatformMenuItemGroup(
                    members: <PlatformMenuItem>[
                      PlatformMenuItem(label: 'Bring All to Front', onSelected: showMainWindow),
                    ],
                  ),
                ],
              ),
            ],
            child: child,
          )
        : SizedBox(child: child);
  }
}
