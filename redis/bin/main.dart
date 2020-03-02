import 'package:redis/redis.dart';

RedisConnection connection;
const String HOST = "localhost";
const int PORT = 6379;

const String userKey = "user:";
const String nameKey = "name ";
const String cartelaKey = "bcartela ";
const String scoreKey = "bscore ";

Future<void> main() async {
  connection = RedisConnection();
  print("Inicio Bingo");
  await initBingo();
  var cartela = await getCartela();
  print("aki");
  print(cartela);
  //setPlayers(1);
  //jogado por 50 pessoas

  print("Fim Bingo");
}

void setPlayers(int total) {
  connection.connect(HOST, PORT).then((Command command) {
    for (var i = 0; i < total; ++i) {
      var user = userKey + i.toString();
      var cartela = cartelaKey + i.toString();
      var score = scoreKey + i.toString();

      command.send_object(["HSET", user, "${nameKey} ${userKey}"]).catchError(
          (onError) {
        print(onError);
      });
      command.send_object(
          ["HSET", user, "${cartelaKey} ${cartela}"]).catchError((onError) {
        print(onError);
      });
      command.send_object(["HSET", user, "${scoreKey} ${score}"]).catchError(
          (onError) {
        print(onError);
      });
    }
  });
}

Future<dynamic> getCartela() async {
  await connection.connect(HOST, PORT).then((Command command) {
    command.send_object(["SRANDMEMBER", "numbers"]).then((onValue) {
      print(onValue);
      return onValue;
    }).catchError((error) {
      print(error);
    });
  });
}

Future<void> initBingo() async {
  for (var i = 1; i < 100; i++) {
    await connection.connect(HOST, PORT).then((Command command) {
      command.send_object(["SADD", "numbers", "${i}"]).then((response) {
        print(response);
      }).catchError((onError) {
        print(onError);
      });
    });
  }
}
