import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationItem {
  final String title;
  final String description;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Peminjaman Disetujui",
      description:
          "MacBook Pro 13\" (MB-001) telah disetujui untuk dipinjam. Silakan ambil di ruang inventori.",
      timeAgo: "5 menit yang lalu",
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green,
    ),
    NotificationItem(
      title: "Peminjaman Akan Berakhir",
      description:
          "DSLR Camera Canon (CM-003) jatuh tempo besok, 15 Agust 2025. Jangan lupa untuk mengembalikan.",
      timeAgo: "1 jam yang lalu",
      icon: Icons.warning_rounded,
      iconColor: Colors.orange,
    ),
    NotificationItem(
      title: "Peminjaman Terlambat!",
      description:
          "Wireless Microphone (MC-007) sudah terlambat 3 hari. Denda: Rp 150.000. Segera kembalikan!",
      timeAgo: "2 jam yang lalu",
      icon: Icons.error_rounded,
      iconColor: Colors.red,
    ),
    NotificationItem(
      title: "Peminjaman Ditolak",
      description:
          "Permohonan peminjaman iPad Pro 12.9\" (IP-005) ditolak. Alasan: Barang sedang dalam maintenance.",
      timeAgo: "3 jam yang lalu",
      icon: Icons.cancel_rounded,
      iconColor: Colors.red,
      isRead: true,
    ),
    NotificationItem(
      title: "Barang Baru Tersedia",
      description:
          "Surface Laptop Studio (SL-008) telah ditambahkan ke inventori dan tersedia untuk dipinjam.",
      timeAgo: "1 hari yang lalu",
      icon: Icons.new_releases_rounded,
      iconColor: Colors.blue,
      isRead: true,
    ),
    NotificationItem(
      title: "Perpanjangan Disetujui",
      description:
          "Perpanjangan peminjaman Projector Epson (PJ-001) telah disetujui hingga 20 Agust 2025.",
      timeAgo: "1 hari yang lalu",
      icon: Icons.update_rounded,
      iconColor: Colors.purple,
      isRead: true,
    ),
    NotificationItem(
      title: "Pengembalian Diterima",
      description:
          "Terima kasih! Pengembalian Drone DJI Mini (DR-002) telah diterima dalam kondisi baik.",
      timeAgo: "2 hari yang lalu",
      icon: Icons.assignment_return_rounded,
      iconColor: Colors.teal,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadCount = notifications.where((notif) => !notif.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0288D1), Color(0xFF01579B)])),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notif in notifications) {
                    notifications[notifications.indexOf(notif)] =
                        NotificationItem(
                      title: notif.title,
                      description: notif.description,
                      timeAgo: notif.timeAgo,
                      icon: notif.icon,
                      iconColor: notif.iconColor,
                      isRead: true,
                    );
                  }
                });
              },
              child: Text(
                'Tandai Semua',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header dengan jumlah notifikasi belum dibaca
          if (unreadCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue.shade50,
              child: Text(
                '$unreadCount notifikasi belum dibaca',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // List notifikasi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    // Mark as read ketika di-tap
                    if (!notification.isRead) {
                      setState(() {
                        notifications[index] = NotificationItem(
                          title: notification.title,
                          description: notification.description,
                          timeAgo: notification.timeAgo,
                          icon: notification.icon,
                          iconColor: notification.iconColor,
                          isRead: true,
                        );
                      });
                    }

                    // Navigate ke detail atau action lainnya
                    showDetailDialog(context, notification);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDetailDialog(BuildContext context, NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: notification.iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(notification.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          if (notification.title.contains('Disetujui') ||
              notification.title.contains('Terlambat'))
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate ke halaman detail peminjaman
              },
              child: Text('Lihat Detail'),
            ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead ? Colors.white : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: notification.isRead
                  ? null
                  : Border.all(color: Colors.blue.shade100, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: notification.iconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
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
}

// Widget untuk badge notification di AppBar atau BottomNav
class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const NotificationBadge({
    Key? key,
    required this.count,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
