import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Cita Confirmada',
      'message': 'Tu cita para el Corte + Barba está confirmada para mañana a las 10:00 AM',
      'type': 'appointment',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'read': false,
      'archived': false,
    },
    {
      'id': '2',
      'title': 'Promoción Especial',
      'message': '¡20% de descuento en todos los tratamientos faciales este fin de semana!',
      'type': 'promotion',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'read': true,
      'archived': false,
    },
    {
      'id': '3',
      'title': 'Recordatorio de Cita',
      'message': 'Te recordamos que tienes una cita mañana a las 10:00 AM',
      'type': 'reminder',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'read': false,
      'archived': false,
    },
    {
      'id': '4',
      'title': 'Pedido Enviado',
      'message': 'Tu pedido #ORD-001 ha sido enviado y llegará en 2-3 días hábiles',
      'type': 'order',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'read': true,
      'archived': false,
    },
    {
      'id': '5',
      'title': 'Nueva Reseña',
      'message': '¡Gracias por tu reseña! Nos ayuda a mejorar nuestros servicios',
      'type': 'review',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'read': true,
      'archived': false,
    },
  ];

  List<Map<String, dynamic>> get _activeNotifications =>
      _notifications.where((n) => !n['archived']).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _activeNotifications.where((n) => !n['read']).length;

    return BackButtonInterceptor(
      fallbackRoute: '/perfil',
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Notificaciones',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => context.go('/perfil'),
          ),
          actions: [
            if (unreadCount > 0)
              TextButton(
                onPressed: _markAllAsRead,
                child: const Text(
                  'Marcar todas como leídas',
                  style: TextStyle(color: Color(0xFFDC3545)),
                ),
              ),
          ],
        ),
        body: _activeNotifications.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  if (unreadCount > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFFDC3545).withOpacity(0.1),
                      child: Text(
                        'Tienes $unreadCount notificación${unreadCount > 1 ? 'es' : ''} sin leer',
                        style: const TextStyle(
                          color: Color(0xFFDC3545),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _activeNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _activeNotifications[index];
                        return _buildNotificationCard(notification, index);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 120,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes notificaciones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Te notificaremos sobre citas, promociones y más',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final theme = Theme.of(context);
    final isRead = notification['read'] as bool;
    
    return Dismissible(
      key: Key(notification['id']),
      background: _buildSwipeBackground(
        color: Colors.green,
        icon: Icons.archive,
        text: 'Archivar',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        color: Colors.red,
        icon: Icons.delete,
        text: 'Eliminar',
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _archiveNotification(notification['id']);
        } else {
          _deleteNotification(notification['id']);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation();
        }
        return true; // Para archivar no necesita confirmación
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: theme.cardTheme.color,
        child: InkWell(
          onTap: () => _markAsRead(notification['id']),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: !isRead
                  ? Border.all(color: const Color(0xFFDC3545).withOpacity(0.3))
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getNotificationTypeColor(notification['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getNotificationTypeIcon(notification['type']),
                    color: _getNotificationTypeColor(notification['type']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC3545),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(notification['date']),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationTypeIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.calendar_today;
      case 'promotion':
        return Icons.local_offer;
      case 'reminder':
        return Icons.alarm;
      case 'order':
        return Icons.shopping_bag;
      case 'review':
        return Icons.rate_review;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case 'appointment':
        return Colors.blue;
      case 'promotion':
        return Colors.orange;
      case 'reminder':
        return const Color(0xFFDC3545);
      case 'order':
        return Colors.green;
      case 'review':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['read'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _archiveNotification(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['archived'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificación archivada'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              final index = _notifications.indexWhere((n) => n['id'] == notificationId);
              if (index != -1) {
                _notifications[index]['archived'] = false;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteNotification(String notificationId) {
    final deletedNotification = _notifications.firstWhere((n) => n['id'] == notificationId);
    
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificación eliminada'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _notifications.add(deletedNotification);
              _notifications.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
            });
          },
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Eliminar notificación',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta notificación?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
} 