import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/customer_model.dart';
import '../../../providers/providers.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../commons/theme/custom_colors.dart';
import '../../commons/widgets/app_button.dart';
import '../../commons/widgets/app_text_field.dart';
import '../../commons/widgets/error_banner.dart';
import '../deposit/deposit_screen.dart';




class CustomerSearchPage extends ConsumerWidget {
  const CustomerSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CustomColors.scaffoldBackgroundLight,
      appBar: AppBar(
        backgroundColor: CustomColors.surfaceCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: CustomColors.textDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Bank Transfer',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: CustomColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: const _CustomerSearchBody(),
    );
  }
}

class _CustomerSearchBody extends ConsumerStatefulWidget {
  const _CustomerSearchBody();

  @override
  ConsumerState<_CustomerSearchBody> createState() =>
      _CustomerSearchBodyState();
}

class _CustomerSearchBodyState extends ConsumerState<_CustomerSearchBody> {
  final _formKey = GlobalKey<FormState>();
  final _accountCtrl = TextEditingController();

  @override
  void dispose() {
    _accountCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(customerNotifierProvider.notifier)
        .searchCustomer(_accountCtrl.text.trim());
  }

  void _clear() {
    _accountCtrl.clear();
    ref.read(customerNotifierProvider.notifier).clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(20),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Customer',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter a 10-digit account number to look up',
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.textSubtleGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Account Number',
                    hint: '0123456789',
                    controller: _accountCtrl,
                    validator: Validators.validateAccountNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.search,
                    prefixIcon: Icon(
                      Icons.search,
                      color: CustomColors.textSubtleGrey,
                    ),
                    suffixIcon: _accountCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: CustomColors.textSubtleGrey,
                              size: 18,
                            ),
                            onPressed: _clear,
                          )
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    label: 'Search',
                    onPressed: _search,
                    isLoading: state.isLoading,
                    icon: Icons.person_search_outlined,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),


          if (state.error != null)
            ErrorBanner(
              message: state.error!,
              onDismiss: () => ref.read(customerNotifierProvider.notifier).clear(),
            ),


          if (state.customer != null) ...[
            _CustomerResultCard(
              customer: state.customer!,
              onDeposit: () => _openDepositSheet(context, state.customer!),
            ),
          ],


          if (state.customer == null && state.error == null && !state.isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: CustomColors.surfaceEmptyState,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 32,
                              color: CustomColors.textSubtleGrey,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No customer loaded yet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: CustomColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }

  void _openDepositSheet(BuildContext context, Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DepositSheet(customer: customer),
    );
  }
}


class _CustomerResultCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onDeposit;

  const _CustomerResultCard(
      {required this.customer, required this.onDeposit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.customerCardStart,
            CustomColors.customerCardEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Center(
                  child: Text(
                    customer.name[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                        customer.accountNumber,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 13)),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Active',
                    style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(Formatters.formatCurrency(customer.balance),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onDeposit,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Deposit',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: CustomColors.brandActionBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
