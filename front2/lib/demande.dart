import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Demandes de Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.grey[400],
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      home: const ServiceRequestsScreen(),
    );
  }
}

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ServiceRequest> pendingRequests = [];
  List<ServiceRequest> completedRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Ajouter des données de test
    pendingRequests = [
      ServiceRequest(
        id: '1',
        clientName: 'Sophie Martin',
        serviceType: 'Nettoyage de maison',
        date: DateTime.now().add(const Duration(days: 2)),
        price: 75.0,
        address: '15 Rue de Paris, 75001 Paris',
        description: 'Nettoyage complet d\'un appartement de 80m²',
        status: RequestStatus.pending,
      ),
      ServiceRequest(
        id: '2',
        clientName: 'Thomas Dubois',
        serviceType: 'Réparation plomberie',
        date: DateTime.now().add(const Duration(days: 1)),
        price: 120.0,
        address: '8 Avenue Victor Hugo, 75016 Paris',
        description: 'Fuite sous l\'évier de la cuisine',
        status: RequestStatus.pending,
      ),
      ServiceRequest(
        id: '3',
        clientName: 'Marie Leroy',
        serviceType: 'Jardinage',
        date: DateTime.now().add(const Duration(days: 3)),
        price: 60.0,
        address: '25 Rue des Fleurs, 75020 Paris',
        description: 'Taille de haie et tonte de pelouse',
        status: RequestStatus.pending,
      ),
    ];

    completedRequests = [
      ServiceRequest(
        id: '4',
        clientName: 'Jean Dupont',
        serviceType: 'Montage de meuble',
        date: DateTime.now().subtract(const Duration(days: 2)),
        price: 50.0,
        address: '10 Rue de Rivoli, 75004 Paris',
        description: 'Montage d\'une armoire IKEA',
        status: RequestStatus.completed,
      ),
      ServiceRequest(
        id: '5',
        clientName: 'Lucie Bernard',
        serviceType: 'Cours de mathématiques',
        date: DateTime.now().subtract(const Duration(days: 5)),
        price: 35.0,
        address: '5 Rue Saint-Michel, 75005 Paris',
        description: 'Cours de soutien en mathématiques niveau lycée',
        status: RequestStatus.completed,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _acceptRequest(ServiceRequest request) {
    setState(() {
      final index = pendingRequests.indexOf(request);
      if (index != -1) {
        pendingRequests[index] = request.copyWith(
          status: RequestStatus.accepted,
        );
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Demande acceptée')));
  }

  void _rejectRequest(ServiceRequest request) {
    setState(() {
      pendingRequests.removeWhere((r) => r.id == request.id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Demande refusée')));
  }

  void _cancelRequest(ServiceRequest request) {
    setState(() {
      pendingRequests.removeWhere((r) => r.id == request.id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Demande annulée')));
  }

  void _completeRequest(ServiceRequest request) {
    setState(() {
      pendingRequests.removeWhere((r) => r.id == request.id);
      completedRequests.add(request.copyWith(status: RequestStatus.completed));
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Demande terminée')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Demandes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'En attente'), Tab(text: 'Terminées')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          pendingRequests.isEmpty
              ? const Center(
                child: Text(
                  'Aucune demande en attente pour le moment.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  final request = pendingRequests[index];
                  return ServiceRequestCard(
                    request: request,
                    onAccept: () => _acceptRequest(request),
                    onReject: () => _rejectRequest(request),
                    onCancel: () => _cancelRequest(request),
                    onComplete: () => _completeRequest(request),
                  );
                },
              ),
          completedRequests.isEmpty
              ? const Center(
                child: Text(
                  'Aucune demande terminée.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: completedRequests.length,
                itemBuilder: (context, index) {
                  final request = completedRequests[index];
                  return CompletedRequestCard(request: request);
                },
              ),
        ],
      ),
    );
  }
}

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const ServiceRequestCard({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onCancel,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.serviceType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _getStatusText(request.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.person_outline, request.clientName),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on_outlined, request.address),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              '${request.date.day}/${request.date.month}/${request.date.year} à ${request.date.hour}:${request.date.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 10),
            Text(
              '${request.price.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              request.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (request.status == RequestStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text('Accepter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[400],
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.cancel_outlined, size: 20),
            label: const Text('Refuser'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[400],
              side: BorderSide(color: Colors.red[400]!),
            ),
          ),
        ],
      );
    } else if (request.status == RequestStatus.accepted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.done_all_outlined, size: 20),
            label: const Text('Terminer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.undo_outlined, size: 20),
            label: const Text('Annuler'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange[400],
              side: BorderSide(color: Colors.orange[400]!),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange[300]!;
      case RequestStatus.accepted:
        return Colors.blue[300]!;
      case RequestStatus.completed:
        return Colors.green[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  String _getStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'En attente';
      case RequestStatus.accepted:
        return 'Acceptée';
      case RequestStatus.completed:
        return 'Terminée';
      default:
        return '';
    }
  }
}

class CompletedRequestCard extends StatelessWidget {
  final ServiceRequest request;

  const CompletedRequestCard({Key? key, required this.request})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.serviceType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[300]!.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Terminée',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.person_outline, request.clientName),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on_outlined, request.address),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              '${request.date.day}/${request.date.month}/${request.date.year} à ${request.date.hour}:${request.date.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 10),
            Text(
              '${request.price.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              request.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}

enum RequestStatus { pending, accepted, completed }

class ServiceRequest {
  final String id;
  final String clientName;
  final String serviceType;
  final DateTime date;
  final double price;
  final String address;
  final String description;
  final RequestStatus status;

  ServiceRequest({
    required this.id,
    required this.clientName,
    required this.serviceType,
    required this.date,
    required this.price,
    required this.address,
    required this.description,
    required this.status,
  });

  ServiceRequest copyWith({
    String? id,
    String? clientName,
    String? serviceType,
    DateTime? date,
    double? price,
    String? address,
    String? description,
    RequestStatus? status,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      price: price ?? this.price,
      address: address ?? this.address,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
