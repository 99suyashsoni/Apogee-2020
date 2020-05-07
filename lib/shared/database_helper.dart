import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database _database;

List<String> tables = ['''
  CREATE TABLE stalls (
    stallId INTEGER PRIMARY KEY,
    stallName TEXT NON NULL,
    closed INTEGER NON NULL,
    imageUrl TEXT NON NULL,
    description TEXT NON NULL
  )
  ''', '''
  CREATE TABLE stall_items (
    itemId INTEGER PRIMARY KEY,
    itemName TEXT NON NULL,
    stallId INTEGER NON NULL,
    stallName TEXT NON NULL,
    category TEXT NON NULL,
    current_price INTEGER NON NULL,
    isAvailable INTEGER NON NULL,
    isVeg INTEGER NON NULL,
    discount INTEGER NON NULL,
    base_price INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NON NULL,
    item_id INTEGER NON NULL,
    quantity INTEGER NON NULL,
    unit_price INTEGER NON NULL,
    order_id INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    shell INTEGER NON NULL,
    otp INTEGER NON NULL,
    otp_seen INTEGER NON NULL,
    status INTEGER NON NULL,
    price INTEGER NON NULL,
    vendor TEXT NON NULL,
    rating INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE cart_data (
    item_id INTEGER PRIMARY KEY,
    quantity INTEGER NON NULL,
    vendor_id INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE fav_data (
    event_id INTEGER PRIMARY KEY,
    is_fav INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE tickets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ticket_id INTEGER NON NULL,
    price INTEGER NON NULL,
    name TEXT NON NULL,
    type TEXT NON NULL,
    shows TEXT
  )
  ''', '''
  CREATE TABLE user_tickets (
    id INTEGER PRIMARY KEY,
    show TEXT NON NULL,
    used INTEGER NON NULL,
    unused INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE tickets_cart (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ticket_id INTEGER NON NULL,
    quantity INTEGER NON NULL,
    type TEXT NON NULL
  )
  ''', '''
  CREATE TABLE events_data (
    event_id INTEGER PRIMARY KEY,
    name TEXT NON NULL,
    about TEXT NON NULL,
    rules TEXT NON NULL,
    time TEXT NON NULL,
    date TEXT NON NULL,
    details TEXT NON NULL,
    venue TEXT NON NULL,
    contact TEXT
  )
  ''', '''
  CREATE TABLE event_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NON NULL,
    filtered INTEGER NON NULL,
    event_id INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE kindItems (
    id INTEGER PRIMARY KEY,
    itemName TEXT NON NULL,
    price INTEGER NON NULL,
    itemImage TEXT,
    availability INTEGER NON NULL
  )
  ''', '''
  CREATE TABLE paytm_transactions (
    txnId TEXT PRIMARY KEY,
    status TEXT NON NULL,
    checkSumHash TEXT NON NULL,
    bankName TEXT NON NULL,
    orderId TEXT NON NULL,
    txnAmount TEXT NON NULL,
    txnDate TEXT NON NULL,
    mid TEXT NON NULL,
    respCode TEXT NON NULL,
    paymentMode TEXT NON NULL,
    bankTxnId TEXT NON NULL,
    currency TEXT NON NULL,
    gatewayName TEXT NON NULL,
    respMsg TEXT NON NULL
  )
  '''];

Future<Database> databaseInstance() async{

  if(_database != null){
    return _database;
  }

  String path = join(await getDatabasesPath(), 'apogee.db');
  _database = await openDatabase(path, version: 1, onCreate: (db, _) async {
    await db.transaction((txn) async{
      for(var table in tables){
        await txn.execute(table);
      }
    });
  });

  return _database;
}