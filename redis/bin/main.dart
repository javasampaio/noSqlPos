import 'package:redis/redis.dart';

RedisConnection connection;
const String HOST = "localhost";
const int PORT = 6379;

const String USER_KEY = "user:";
const String NAME_KEY = "name";
const String CARTELA_KEY = "bcartela";
const String SCORE_KEY = "bscore";

const String NUMBERS = "numbers";
const String BAG_NUMBERS = "bagNumbers";

const int TOTAL_PLAYERS = 2; //O bingo será jogado por 50 pessoas.
const int TOTAL_CARTELA_NUMBERS = 15;

const String CARTELA = "cartela";
const String SCORE = "score";

Future<void> main() async {
  connection = RedisConnection();
  print("start config Redinsgo");
  await generateNumbers(NUMBERS); //utilize um set com números de 1 a 99
  await generateCartelas(); //utilize sets com 15 números aleatórios cada
  await generateScore(); //utilize uma estrutura de set score para controlar a pontuação de cada participante
  await setPlayers(); //O bingo será jogado por 50 pessoas.
  await generateNumbers(BAG_NUMBERS); //crie um set para ter as “pedras”
  await play(); //crie um “jogo” e retire uma a uma

  print("finish Redinsgo");
}

Future<void> setPlayers() async {
  await connection.connect(HOST, PORT).then((Command command) async{
    for (var i = 0; i < TOTAL_PLAYERS; ++i) {
      var user = "${USER_KEY}:${i}";
      var cartela = "${CARTELA}:${i}";
      var score = "${SCORE}:${i}";

      await command.send_object(["HSET", user, "${NAME_KEY} ${user}"]).catchError(
          (onError) {
        print(onError);
      });
      await command.send_object(
          ["HSET", user, "${CARTELA_KEY} ${cartela}"]).catchError((onError) {
        print(onError);
      });
      await command.send_object(["HSET", user, "${SCORE_KEY} ${score}"]).catchError(
          (onError) {
        print(onError);
      });
    }
  });
  connection.close();
}

Future<void> generateCartelas() async {
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 1; i <= TOTAL_PLAYERS; i++) {
      var cartela = "${CARTELA}:${i}";
      var isFull = false;
      while (!isFull) {
        await command
            .send_object(["SRANDMEMBER", NUMBERS]).then((randonNumber) async {
          await command.send_object(["SCARD", cartela]).then((size) async {
            if (size == TOTAL_CARTELA_NUMBERS) {
              isFull = true;
            } else {
              await command
                  .send_object(["SADD", cartela, randonNumber])
                  .catchError((error) {
                    print(error);
                  });
            }
          }).catchError((error) {
            print(error);
          });
        }).catchError((error) {
          print(error);
        });
      }
    }
  });
  connection.close();
}

Future<void> generateScore() async {
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 0; i < TOTAL_PLAYERS; ++i) {
       var score = "${SCORE}:${i}";
       await command
                  .send_object(["SET", score, 0])
                  .catchError((error) {
                    print(error);
                  });
    }
  });
  connection.close();
}

Future<void> generateNumbers(String key) async {
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 1; i < 100; i++) {
      await command
          .send_object(["SADD", key, "${i}"]).catchError((onError) {
        print(onError);
      });
    }
  });
  connection.close();
}

Future<void> play() async {
  await connection.connect(HOST, PORT).then((Command command) async {

  });
}