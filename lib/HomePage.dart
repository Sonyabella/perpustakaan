import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart';


class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  // Fungsi untuk mengambil data books dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();

    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  // Fungsi untuk menambahkan books baru
  Future<void> addBook(String title, String author, String description) async {
    final response = await Supabase.instance.client
        .from('books')
        .insert({'judul': title, 'penulis': author, 'deskripsi': description});

    if (response.error == null) {
      // Menambahkan books yang baru ke dalam daftar books
      setState(() {
        books.add({
          'judul': title,
          'penulis': author,
          'deskripsi': description,
        });
      });

      // Tampilkan pesan berhasil (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('books berhasil ditambahkan')),
      );
    } else {
      // Tampilkan pesan error (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan books: ${response.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text('Daftar books'),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBooks,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu Daftar books',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          books.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          elevation: 4,
                          color: Color.fromARGB(255, 246, 240, 247),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.book,
                              color: Colors.green[200],
                              size: 40,
                            ),
                            title: Text(
                              book['title'] ?? 'Judul',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['author'] ?? 'Penulis',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 14),
                                ),
                                Text(
                                  book['descrition'] ?? 'Deskripsi',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol edit
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Implement your edit logic here
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Implement your delete logic here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(
                      onAddBook: (title, author, description) {
                        addBook(title, author, description);
                        Navigator.pop(context);  // Close the AddBookPage
                      },
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.green[200],
            ),
          ),
        ],
      ),
    );
  }
}