import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:three_line_agency_banking/utils/pin_entry_sheet.dart';

import '../../../models/customer_model.dart';
import '../../../providers/providers.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../commons/theme/custom_colors.dart';
import '../../commons/widgets/app_button.dart';
import '../../commons/widgets/app_text_field.dart';
import '../../commons/widgets/error_banner.dart';
import '../home_screen.dart';


class DepositSheet extends ConsumerStatefulWidget {
  final Customer customer;
  const DepositSheet({super.key, required this.customer});

  @override
  ConsumerState<DepositSheet> createState() => _DepositSheetState();
}

class _DepositSheetState extends ConsumerState<DepositSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  double? get _parsedAmount {
    final cleaned = _amountCtrl.text.replaceAll(',', '').trim();
    return double.tryParse(cleaned);
  }

  // Future<void> _showConfirmation() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   FocusScope.of(context).unfocus();
  //
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => _ConfirmDepositDialog(
  //       customer: widget.customer,
  //       amount: _parsedAmount!,
  //     ),
  //   );
  //
  //   if (confirmed == true && mounted) {
  //     await _processDeposit();
  //   }
  // }

  Future<void> _processDeposit(String transactionPin) async {
    final success = await ref
        .read(depositNotifierProvider.notifier)
        .deposit(widget.customer.accountNumber, _parsedAmount!,transactionPin );

    if (success && mounted) {
      final txnId = ref.read(depositNotifierProvider).response?.transactionId ?? '';
      ref.read(pinEntryProvider.notifier).confirmTransfer(false);
      Navigator.of(context).pop();
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _SuccessDialog(
            customer: widget.customer,
            amount: _parsedAmount!,
            transactionId: txnId,
          ),
        );

        ref.read(statsNotifierProvider.notifier).recordDeposit(_parsedAmount!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final depositState = ref.watch(depositNotifierProvider);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.82,
      decoration: const BoxDecoration(
        color: CustomColors.surfaceCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColors.borderNeutral,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.surfaceQuickInfo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_downward,
                    color: CustomColors.brandArrowBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cash Deposit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textCardTitle,
                        ),
                      ),
                      Text(
                        'Transfer funds to customer account',
                        style: TextStyle(
                          color: CustomColors.textMutedGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: CustomColors.textMutedGrey,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: mediaQuery.viewInsets.bottom + 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CustomColors.surfaceQuickInfo,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: CustomColors.surfaceQuickInfoBorder),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: CustomColors.brandDeepBlue,
                            child: Text(
                              widget.customer.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.customer.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text(
                                Formatters.maskAccountNumber(
                                    widget.customer.accountNumber),
                                style: const TextStyle(
                                    color: Color(0xFF6B7280), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (depositState.error != null) ...[
                      ErrorBanner(
                        message: depositState.error!,
                        onDismiss: () =>
                            ref.read(depositNotifierProvider.notifier).reset(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      'Deposit Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: CustomColors.textCardTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Minimum: ₦100 · Maximum: ₦5,000,000',
                      style: TextStyle(
                        color: CustomColors.textSubtleGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      label: 'Amount (₦)',
                      hint: '0.00',
                      controller: _amountCtrl,
                      validator: Validators.validateDepositAmount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                      ],
                      textInputAction: TextInputAction.next,
                      prefixIcon: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 4, top: 10),
                        child: Text(
                          '₦',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.brandDeepBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),


                    Text(
                      'Quick amounts',
                      style: TextStyle(
                        color: CustomColors.textSubtleGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [1000, 2000, 5000, 10000, 20000, 50000]
                          .map((amt) => _QuickAmountChip(
                                amount: amt.toDouble(),
                                onTap: () {
                                  _amountCtrl.text =
                                      Formatters.formatAmount(amt.toDouble());
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Note (optional)',
                      hint: 'e.g. Salary payment',
                      controller: _noteCtrl,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icon(
                        Icons.note_outlined,
                        color: CustomColors.textMutedGrey,
                      ),
                    ),
                    const SizedBox(height: 28),

                    AppButton(
                      label: 'Continue',
                      onPressed: (){

                        if (!_formKey.currentState!.validate()) return;
                        if(widget.customer.balance < _parsedAmount!) {


                        }
                        FocusScope.of(context).unfocus();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => PinEntrySheet(
                            onCompleted: (pin) async {
                              if (pin.isNotEmpty && pin.length ==4){
                                _processDeposit(pin);
                              }



                            }, customer: widget.customer, amount: _parsedAmount??0,
                          ),
                        );
                      },
                      isLoading: depositState.isLoading,
                      icon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;
  const _QuickAmountChip({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: CustomColors.surfaceQuickInfo,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CustomColors.surfaceQuickInfoBorder),
        ),
        child: Text(
          '₦${Formatters.formatAmount(amount)}',
          style: const TextStyle(
            color: CustomColors.brandInfoBlue,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ConfirmDepositDialog extends StatelessWidget {
  final Customer customer;
  final double amount;
  const _ConfirmDepositDialog({required this.customer, required this.amount});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.info_outline, color: CustomColors.brandDeepBlue),
          SizedBox(width: 10),
          Text('Confirm Deposit'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  Text(
                    'Please verify transaction details:',
                    style: TextStyle(
                      color: CustomColors.textMutedGrey,
                      fontSize: 14,
                    ),
                  ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Recipient', value: customer.name),
          _DetailRow(
              label: 'Account',
              value: Formatters.maskAccountNumber(customer.accountNumber)),
          _DetailRow(
              label: 'Amount',
              value: Formatters.formatCurrency(amount),
              highlight: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.warningBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 16,
                  color: CustomColors.warningOrange,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This action cannot be undone.',
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.warningOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: CustomColors.textMutedGrey),
          ),
        ),
        ElevatedButton(
    // Navigator.of(context).pop(true)
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.brandDeepBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm Deposit',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _DetailRow(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  color: highlight
                      ? const Color(0xFF0A3D62)
                      : const Color(0xFF1A1A2E),
                  fontSize: highlight ? 16 : 14,
                  fontWeight:
                      highlight ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final Customer customer;
  final double amount;
  final String transactionId;
  const _SuccessDialog(
      {required this.customer,
      required this.amount,
      required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: CustomColors.surfaceSuccessBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: CustomColors.successGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Deposit Successful!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            Text(
              '${Formatters.formatCurrency(amount)} has been deposited to ${customer.name}\'s account.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CustomColors.surfaceNeutral,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CustomColors.borderNeutral),
              ),
              child: Column(
                children: [
                  Text(
                    'Transaction ID',
                    style: TextStyle(
                      color: CustomColors.textSubtleGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    transactionId,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.brandDeepBlue,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>HomeScreen(onLogout: (){})));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.brandDeepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Done',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
