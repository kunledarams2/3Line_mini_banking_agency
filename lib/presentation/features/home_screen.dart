
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/formatters.dart';
import '../commons/theme/custom_colors.dart';
import 'customer_search/customer_search_screen.dart';


class HomeScreen extends ConsumerWidget {
  final VoidCallback onLogout;
  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final agentName = authState.valueOrNull?.agentName ?? 'Agent';


    final parts = agentName.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : agentName.substring(0, agentName.length.clamp(1, 2)).toUpperCase();

    return Scaffold(
      backgroundColor: CustomColors.scaffoldBackgroundLight,
      body: SafeArea(
        child: Column(
          children: [

            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: CustomColors.surfaceDragHandle,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),


                    Row(
                      children: [

                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: CustomColors.surfaceAvatarBackground,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: CustomColors.textGrey,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3Line Agent',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColors.textDark,
                                ),
                              ),
                              Text(
                                agentName,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CustomColors.textMutedGrey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Settings icon
                        GestureDetector(
                          onTap: () => _confirmLogout(context, ref),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: CustomColors.textSubtleGrey,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _StatsBanner(),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      decoration: BoxDecoration(
                        color: CustomColors.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How do you want to\naccept payment?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: CustomColors.textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 24),


                          _PaymentOption(
                            iconWidget: _paymentOptionIcon(Icons.account_balance),
                            title: 'Pay with bank transfer',
                            subtitle: 'Tap to start deposit processing ..',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CustomerSearchPage(),
                              ),
                            ),
                          ),

                          Divider(
                            color: CustomColors.borderSubtle,
                            height: 1,
                            indent: 64,
                          ),

                          // Card row
                          _PaymentOption(
                            iconWidget: _paymentOptionIcon(Icons.credit_card),
                            title: 'Pay with card',
                            subtitle: 'Tap to process payment',
                            onTap: () {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Card payment coming soon'),
                              //     behavior: SnackBarBehavior.floating,
                              //   ),
                              // );

                              ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(content: Text("Insufficient Balance..."), backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom:  MediaQuery.of(context).size.height -( MediaQuery.of(context).size.height*0.4), left: 20,right: 20),
                                ),

                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Quick actions',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _QuickActionTile(
                      iconWidget: const Icon(Icons.receipt_long_outlined,
                          color: CustomColors.brandIconBlue, size: 22),
                      title: 'Transactions',
                      subtitle: 'View all your transactions here',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _QuickActionTile(
                      iconWidget: const Icon(Icons.person_outline,
                          color: CustomColors.brandIconBlue, size: 22),
                      title: 'Contact Support',
                      subtitle: 'Need help? Submit a ticket here',
                      onTap: () {},
                    ),

                    const SizedBox(height: 48),


                    Center(
                      child: Column(
                        children: [
                          Image.asset("assets/images/3line_card_management_limited_logo.jpeg", height: 40,),
                          const SizedBox(height: 6),
                          Text(
                            '© 2026 3Line',
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.textFooterGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authNotifierProvider.notifier).logout();
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.errorRed,
            ),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


class _PaymentOption extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.textSubtleGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: CustomColors.textSubtleGrey, size: 22),
          ],
        ),
      ),
    );
  }
}


class _QuickActionTile extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: CustomColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CustomColors.surfaceMuted,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.textSubtleGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Widget _paymentOptionIcon(IconData icon){
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: CustomColors.surfacePillLight,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Center(
      child: Icon(
        icon,
        color: CustomColors.brandPillIconBlue,
        size: 24,
      ),
    ),
  );
}

class _StatsBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsNotifierProvider);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.statsGradientStart,
            CustomColors.statsGradientMiddle,
            CustomColors.statsGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                "Today's Summary",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Total balance
              Expanded(
                child: _StatItem(
                  label: 'Total Deposits',
                  value: Formatters.formatCurrency(stats.totalBalance),
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              _verticalDivider(),

              Expanded(
                child: _StatItem(
                  label: 'Transactions',
                  value: stats.depositCount.toString(),
                  icon: Icons.swap_horiz_rounded,
                ),
              ),
              _verticalDivider(),

              Expanded(
                child: _StatItem(
                  label: 'Commission',
                  value: Formatters.formatCurrency(stats.totalCommission),
                  icon: Icons.percent_rounded,
                  highlight: true,
                ),
              ),
            ],
          ),
        SizedBox(height: 15,)
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(highlight ? 0.25 : 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: highlight ? CustomColors.successHighlight : Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: highlight ? CustomColors.successHighlight : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Widget _verticalDivider(){
  return Container(
    width: 1,
    height: 56,
    color: Colors.white.withOpacity(0.2),
    margin: const EdgeInsets.symmetric(horizontal: 4),
  );
}
// class _VerticalDivider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 1,
//       height: 56,
//       color: Colors.white.withOpacity(0.2),
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/providers.dart';
// import 'customer_search/customer_search_screen.dart';
//
// class HomeScreen extends ConsumerWidget {
//   final VoidCallback onLogout;
//   const HomeScreen({super.key, required this.onLogout});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authNotifierProvider);
//     final agentName = authState.valueOrNull?.agentName ?? 'Agent';
//
//     // Derive initials from agent name
//     final parts = agentName.trim().split(' ');
//     final initials = parts.length >= 2
//         ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
//         : agentName.substring(0, agentName.length.clamp(1, 2)).toUpperCase();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFF2F5),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── Top drag handle (mimics modal sheet look) ──
//             Center(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 10, bottom: 6),
//                 width: 48,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1A1A1A),
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//
//                     Row(
//                       children: [
//
//                         Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFD1D5DB),
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: Center(
//                             child: Text(
//                               initials,
//                               style: const TextStyle(
//                                 color: Color(0xFF374151),
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 '3Line Agent',
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF111827),
//                                 ),
//                               ),
//                               Text(
//                                 agentName,
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF6B7280),
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Settings icon
//                         GestureDetector(
//                           onTap: () => _confirmLogout(context, ref),
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Icon(
//                               Icons.settings_outlined,
//                               color: Color(0xFF9CA3AF),
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.04),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'How do you want to\naccept payment?',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w800,
//                               color: Color(0xFF111827),
//                               height: 1.3,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//
//                           // Bank Transfer row
//                           _PaymentOption(
//                             iconWidget: _BankIcon(),
//                             title: 'Pay with bank transfer',
//                             subtitle: 'Tap to start deposit processing ..',
//                             onTap: () => Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => const CustomerSearchPage(),
//                               ),
//                             ),
//                           ),
//
//                           Divider(
//                             color: const Color(0xFFE5E7EB),
//                             height: 1,
//                             indent: 64,
//                           ),
//
//                           // Card row
//                           _PaymentOption(
//                             iconWidget: _CardIcon(),
//                             title: 'Pay with card',
//                             subtitle: 'Tap to process payment',
//                             onTap: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Card payment coming soon'),
//                                   behavior: SnackBarBehavior.floating,
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 28),
//
//                     const Text(
//                       'Quick actions',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF111827),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//
//                     _QuickActionTile(
//                       iconWidget: const Icon(Icons.receipt_long_outlined,
//                           color: Color(0xFF6B7280), size: 22),
//                       title: 'Transactions',
//                       subtitle: 'View all your transactions here',
//                       onTap: () {
//
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     _QuickActionTile(
//                       iconWidget: const Icon(Icons.person_outline,
//                           color: Color(0xFF6B7280), size: 22),
//                       title: 'Contact Support',
//                       subtitle: 'Need help? Submit a ticket here',
//                       onTap: () {},
//                     ),
//
//                     const SizedBox(height: 48),
//
//
//                     Center(
//                       child: Column(
//                         children: [
//
//
//                           const SizedBox(height: 6),
//                           const Text(
//                             '© 2026 3Line Limited',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFFB0B8C1),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _confirmLogout(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Sign Out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//
//             onPressed: () {
//               Navigator.pop(ctx);
//               ref.read(authNotifierProvider.notifier).logout();
//               onLogout();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE53935),
//
//             ),
//             child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Payment option row ──────────────────────────────────────────────────────
// class _PaymentOption extends StatelessWidget {
//   final Widget iconWidget;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   const _PaymentOption({
//     required this.iconWidget,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         child: Row(
//           children: [
//             iconWidget,
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF111827),
//                       )),
//                   const SizedBox(height: 2),
//                   Text(subtitle,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFF9CA3AF),
//                       )),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 22),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Quick action tile ───────────────────────────────────────────────────────
// class _QuickActionTile extends StatelessWidget {
//   final Widget iconWidget;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   const _QuickActionTile({
//     required this.iconWidget,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 6,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: Center(child: iconWidget),
//             ),
//             const SizedBox(width: 14),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF111827),
//                     )),
//                 const SizedBox(height: 2),
//                 Text(subtitle,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF9CA3AF),
//                     )),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Icon widgets matching the screenshot ───────────────────────────────────
// class _BankIcon extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF6FF),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: const Center(
//         child: Icon(Icons.account_balance, color: Color(0xFF3B82F6), size: 24),
//       ),
//     );
//   }
// }
//
// class _CardIcon extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF6FF),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: const Center(
//         child: Icon(Icons.credit_card, color: Color(0xFF3B82F6), size: 24),
//       ),
//     );
//   }
// }
