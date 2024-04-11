import 'package:musteatplace_app/model/musteatplace.dart';
import 'package:path/path.dart'; // path 패키지 : 파일 경로를 다루는 함수.
import 'package:sqflite/sqflite.dart'; // sqflite 패키지 : SQLite 데이터베이스를 사용 가능.

/*--------------------------------------
	 * Description : local db viewmodel
	 * Author 	   : LS
	 * Date 	     : 2024.04.10
	 * Details	
	 *-------------------------------------- 
	 */



class DatabaseHandler {
  // SQLite 데이터베이스를 초기화.
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'musteatplace.db'),
      onCreate: (db, version) async {
        await db.execute(
            "create table musteatplace (seq integer primary key autoincrement, name text, phone text, lat double, lng double, image blob, estimate text, initdate text)");
      },
      version: 1,
    );
  }

  // 검색
  Future<List<Musteatplace>> queryMusteatplace() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from musteatplace');
    return queryResults.map((e) => Musteatplace.fromMap(e)).toList();
  }

  // 입력
  Future<int> insertMusteatplace(Musteatplace musteatplace) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'insert into musteatplace(name, phone, lat, lng, image, estimate, initdate) values (?,?,?,?,?,?,?)',
        [
          musteatplace.name,
          musteatplace.phone,
          musteatplace.lat,
          musteatplace.lng,
          musteatplace.image,
          musteatplace.estimate,
          musteatplace.initdate,
        ]);
    return result;
  }

  // 수정
  Future<void> updateMusteatplace(Musteatplace musteatplace) async {
    final Database db = await initializeDB();
    await db.rawUpdate(
        'update musteatplace set name=?, phone=?, lat=?, lng=?, image=?, estimate=?, initdate=? where seq=?',
        [
          musteatplace.name,
          musteatplace.phone,
          musteatplace.lat,
          musteatplace.lng,
          musteatplace.image,
          musteatplace.estimate,
          musteatplace.initdate,
          musteatplace.seq,
        ]);
  }

  // 삭제
  Future<void> deleteMusteatplace(int seq) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from musteatplace where seq = ?', [seq]);
  }
}
