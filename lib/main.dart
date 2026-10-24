import 'package:flutter/com.Starts.app';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: تهيئة Firebase هنا باستخدام await Firebase.initializeApp();
  runApp(const WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone - com.Starts.app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        scaffoldBackgroundColor: const Color(0xFF121B22), // الوضع المظلم العصري
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00A884),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2C34),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp (com.Starts.app)', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00A884),
          labelColor: const Color(0xFF00A884),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('الكاميرا', style: TextStyle(color: Colors.white))),
          ChatsTab(),
          Center(child: Text('الحالات', style: TextStyle(color: Colors.white))),
          CallsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A884),
        child: const Icon(Icons.message, color: Colors.white),
        onPressed: () {
          // فتح قائمة جهات الاتصال الحقيقية لبدء دردشة
        },
      ),
    );
  }
}

class ChatsTab extends StatelessWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text('جهة اتصال ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('مرحباً بك، هذه رسالة مشفرة...', style: TextStyle(color: Colors.grey)),
          trailing: const Text('12:45 م', style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(userName: 'جهة اتصال ${index + 1}')),
            );
          },
        );
      },
    );
  }
}

class CallsTab extends StatelessWidget {
  const CallsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text('مستخدم ${index + 1}', style: const TextStyle(color: Colors.white)),
          subtitle: Row(
            children: [
              Icon(
                index.isEven ? Icons.call_made : Icons.call_received,
                color: index.isEven ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text('اليوم، 11:30 ص', style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.videocam, color: Color(0xFF00A884)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CallScreen(callType: 'فيديو')),
              );
            },
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String userName;
  const ChatScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<String> _messages = ['أهلاً بك!', 'كيف يمكنني مساعدتك اليوم؟'];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_msgController.text);
      _msgController.clear();
    });
    // هنا يتم ربط إرسال الرسالة بـ Cloud Firestore لتخزينها بشكل حقيقي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CallScreen(callType: 'فيديو')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CallScreen(callType: 'صوتي')),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe = index.isEven;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_messages[index], style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: const Color(0xFF1F2C34),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF00A884)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallScreen extends StatelessWidget {
  final String callType;
  const CallScreen({Key? key, required this.callType}) : super(key: key);

  @override
  Widget build(ButtonContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock, color: Colors.grey, size: 14),
                  SizedBox(width: 6),
                  Text('مكالمة مشفرة من الطرفين (End-to-End)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Column(
              children: const [
                CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 60, color: Colors.white)),
                SizedBox(height: 20),
                Text('جاري الاتصال...', style: TextStyle(color: Colors.white, fontSize: 22)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              cloud: Row(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.mic_off, color: Colors.white), onPressed: () {}),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(icon: const Icon(Icons.volume_up, color: Colors.white), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}