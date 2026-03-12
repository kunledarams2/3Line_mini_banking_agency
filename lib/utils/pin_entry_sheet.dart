import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer_model.dart';

import '../presentation/commons/theme/customText.dart';
import '../presentation/commons/theme/custom_colors.dart';
import '../presentation/commons/widgets/app_button.dart';

import '../providers/pin_entry_provider.dart';
import '../providers/states/pin_entry_state.dart';
import 'formatters.dart';



class PinEntrySheet extends ConsumerStatefulWidget {
  final void Function(String) onCompleted;
  final Customer customer;
  final double amount;
  const PinEntrySheet({super.key,
    required this.onCompleted,
    required this.customer,
    required this.amount});

  @override
  ConsumerState<PinEntrySheet> createState() => _PinEntrySheetState();
}

class _PinEntrySheetState extends ConsumerState<PinEntrySheet> {
  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch(pinEntryProvider);
    final pinVM = ref.read(pinEntryProvider.notifier);

    // Completion listener
    ref.listen<PinEntryState>(pinEntryProvider, (prev, next) async {
      if (next.isComplete && !(prev?.isComplete ?? false)) {
        await Future.delayed(const Duration(milliseconds: 150));
        final pin = next.pin.join();
        Navigator.pop(context);
        widget.onCompleted(pin);
        pinVM.resetKeyPad();
      }
    });

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  pinVM.resetKeyPad();
                  Navigator.pop(context);
                  pinVM.confirmTransfer(false);
                },
                child: const Icon(
                  Icons.close,
                  color: CustomColors.headerTextColor,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          if (!pinState.confirmTransfer)
            Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(Icons.info_outline, color: Color(0xFF0A3D62)),
                  // SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Confirm Deposit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomColors.coolGray700,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _confirmTranfer(widget.customer, widget.amount),
              AppButton(
                label: 'Confirm',
                onPressed: (){
                  pinVM.confirmTransfer(true);
                },
                // isLoading: depositState.isLoading,
                // icon: Icons.arrow_forward,
              ),
            ],),


          const SizedBox(height: 20),
          if (pinState.confirmTransfer)
             Column(children: [
            Text(
              "Enter PIN",
              style: CustomTextStyle.textStyleManrope.copyWith(
                color: CustomColors.coolGray700,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),
            _buildPinDisplay(pinState.pin),
            const SizedBox(height: 20),
            _buildKeypad(),

          ],)

        ],
      ),
    );
  }

  Widget _buildPinDisplay(List<String> pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool filled = pin[index].isNotEmpty;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            // color: CustomColors.t,
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Center(
            child: Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                color: filled ? Colors.black : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeypad() {
    final notifier = ref.read(pinEntryProvider.notifier);

    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', '<']
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((value) {
              if (value.isEmpty) {
                return _keypadButton('', () {});
              } else if (value == '<') {
                return _keypadButton('⌫', notifier.removeDigit);
              } else {
                return _keypadButton(value, () => notifier.addDigit(value));
              }
            }).toList(),
          )
      ],
    );
  }

  Widget _keypadButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: /*Container(
          width: 65.w,
          height: 65.h,
          alignment: Alignment.center,
          child: Text(
            label,
            style: CustomTextStyle.textStyleManrope.copyWith(
              color: CustomColors.coolGray700,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        )*/
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(60, 60),
          elevation: 0.0

        ),

        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _confirmTranfer(Customer customer, double amount ){
    return Column(
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
        _detailRow('Recipient',  customer.name, false),
        _detailRow(
          'Account',
            customer.accountNumber, false),
        _detailRow(
         'Amount',
           Formatters.formatCurrency(amount),
            true),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _detailRow(
   String label,
   String value,
   bool highlight,
      ){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: CustomColors.textMutedGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  color: highlight
                      ? CustomColors.brandDeepBlue
                      : CustomColors.textCardTitle,
                  fontSize: highlight ? 18 : 14,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}
