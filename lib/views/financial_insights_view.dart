import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/transaction_viewmodel.dart';

class FinancialInsightsView extends ConsumerWidget {
  final int userId;

  const FinancialInsightsView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transactionProvider(userId));

    double healthScore = txState.totalIncome == 0
        ? 0
        : ((txState.totalIncome - txState.totalExpense) /
                txState.totalIncome)
            .clamp(0.0, 1.0);

    final scoreColor = healthScore >= 0.7
        ? Colors.green
        : healthScore >= 0.4
            ? Colors.orange
            : Colors.red;

    final scoreText = healthScore >= 0.7
        ? 'Excelente'
        : healthScore >= 0.4
            ? 'Boa'
            : 'Atenção';

    final balance =
        txState.totalIncome - txState.totalExpense;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Insights Financeiros',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade700,
              Colors.grey.shade100,
            ],
            stops: const [0.18, 0.18],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // CARD SAÚDE FINANCEIRA
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Saúde Financeira',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        '${(healthScore * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      LinearProgressIndicator(
                        value: healthScore,
                        minHeight: 14,
                        borderRadius:
                            BorderRadius.circular(20),
                        backgroundColor:
                            Colors.grey.shade300,
                        color: scoreColor,
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scoreColor.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          scoreText,
                          style: TextStyle(
                            color: scoreColor,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Resumo Financeiro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildMetricCard(
                'Receitas do Mês',
                'R\$ ${txState.totalIncome.toStringAsFixed(2)}',
                Icons.trending_up_rounded,
                Colors.green,
              ),

              const SizedBox(height: 12),

              _buildMetricCard(
                'Despesas do Mês',
                'R\$ ${txState.totalExpense.toStringAsFixed(2)}',
                Icons.trending_down_rounded,
                Colors.red,
              ),

              const SizedBox(height: 12),

              _buildMetricCard(
                'Saldo Atual',
                'R\$ ${balance.toStringAsFixed(2)}',
                Icons.account_balance_wallet_rounded,
                Colors.blue,
              ),

              const SizedBox(height: 24),

              const Text(
                'Recomendação Inteligente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 4,
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        healthScore >= 0.5
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: healthScore >= 0.5
                            ? Colors.green
                            : Colors.orange,
                        size: 34,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          healthScore >= 0.5
                              ? 'Suas finanças estão equilibradas. Continue acompanhando seus gastos e mantendo uma reserva financeira.'
                              : 'Os gastos estão consumindo uma parcela significativa da sua renda. Considere revisar despesas não essenciais.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber,
                        size: 42,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Meta de Economia',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Você economizou R\$ ${balance > 0 ? balance.toStringAsFixed(2) : '0.00'} neste período.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
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

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
