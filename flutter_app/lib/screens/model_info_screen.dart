import 'package:flutter/material.dart';

class ModelInfoScreen extends StatelessWidget {
  const ModelInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Info',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF111111),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.memory, color: Color(0xFF1565C0), size: 56),
                  const SizedBox(height: 12),
                  const Text('Model Information',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('MLP Neural Network for Churn Prediction',
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Model metrics
            _buildSection(
              title: 'Performance Metrics',
              icon: Icons.bar_chart,
              children: [
                _buildMetricRow('Accuracy', '95.89%', Colors.green),
                _buildMetricRow('Precision', '89.58%', Colors.blue),
                _buildMetricRow('Recall', '70.49%', Colors.orange),
                _buildMetricRow('F1 Score', '78.90%', Colors.purple),
                _buildMetricRow('AUC-ROC', '94.74%', Colors.teal),
              ],
            ),

            const SizedBox(height: 16),

            // Architecture
            _buildSection(
              title: 'Architecture',
              icon: Icons.account_tree,
              children: [
                _buildInfoRow('Type', 'PyTorch MLP (Binary Classification)'),
                _buildInfoRow('Input Features', '17 Features'),
                _buildInfoRow('Hidden Layer 1', '256 neurons + BatchNorm + ReLU'),
                _buildInfoRow('Hidden Layer 2', '128 neurons + BatchNorm + ReLU'),
                _buildInfoRow('Hidden Layer 3', '64 neurons + BatchNorm + ReLU'),
                _buildInfoRow('Output', '1 neuron (Sigmoid)'),
                _buildInfoRow('Dropout', '0.3 per layer'),
                _buildInfoRow('Confidence Threshold', '0.5'),
              ],
            ),

            const SizedBox(height: 16),

            // Preprocessing
            _buildSection(
              title: 'Preprocessing',
              icon: Icons.tune,
              children: [
                _buildInfoRow('Scaling', 'StandardScaler (numeric)'),
                _buildInfoRow('Encoding', 'OneHotEncoder (categorical)'),
                _buildInfoRow('Balancing', 'SMOTE'),
                _buildInfoRow('Categorical Features', 'International Plan, Voice Mail Plan'),
                _buildInfoRow('Numeric Features', '15 features'),
              ],
            ),

            const SizedBox(height: 16),

            // Feature importance
            _buildSection(
              title: 'Feature Weights (from dataset)',
              icon: Icons.insights,
              children: [
                _buildFeatureRow('Total Day Charge', 0.9),
                _buildFeatureRow('Total Day Minutes', 0.88),
                _buildFeatureRow('Customer Service Calls', 0.75),
                _buildFeatureRow('Total Eve Charge', 0.65),
                _buildFeatureRow('International Plan', 0.60),
                _buildFeatureRow('Total Intl Calls', 0.45),
                _buildFeatureRow('Total Night Charge', 0.40),
              ],
            ),

            const SizedBox(height: 16),

            // Dataset info
            _buildSection(
              title: 'Dataset',
              icon: Icons.dataset,
              children: [
                _buildInfoRow('Source', 'IBM Telco Churn Dataset'),
                _buildInfoRow('Total Rows', '3,333 records'),
                _buildInfoRow('Features', '17 input features'),
                _buildInfoRow('Target', 'Churn (True/False)'),
                _buildInfoRow('Train/Test Split', '80% / 20%'),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1565C0), size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(value,
                style:
                    TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, double weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(feature,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              Text('${(weight * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      color: Color(0xFF1565C0), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: weight,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}