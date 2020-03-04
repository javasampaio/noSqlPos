import 'package:redis/redis.dart';

RedisConnection connection;
const String HOST = "localhost";
const int PORT = 6379;

const String USER_KEY = "user";
const String NAME_KEY = "name";
const String CARTELA_KEY = "bcartela";
const String SCORE_KEY = "bscore";

const String NUMBERS = "numbers";
const String BAG_NUMBERS = "bagNumbers";

const int TOTAL_PLAYERS = 50; //O bingo será jogado por 50 pessoas.
const int TOTAL_CARD_NUMBERS = 15;

const String CARD = "card";
const String SCORE = "score";

var numbersSorted = [];

Future<void> main() async {
  connection = RedisConnection();
   await connection.connect(HOST, PORT).then((Command command) async {
     await command.send_object(
          ["FLUSHALL"]).catchError((onError) {
        print(onError);
      });
   });
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
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 1; i <= TOTAL_PLAYERS; i++) {
      var user = "${USER_KEY}:${i}";
      var card = "${CARD}:${i}";
      var score = "${SCORE}:${i}";

      await command.send_object(
          ["HSET", user, "${NAME_KEY}", "${user}"]).catchError((onError) {
        print(onError);
      });
      await command.send_object(
          ["HSET", user, "${CARTELA_KEY}", "${card}"]).catchError((onError) {
        print(onError);
      });
      await command.send_object(
          ["HSET", user, "${SCORE_KEY}", "${score}"]).catchError((onError) {
        print(onError);
      });
    }
  });
  connection.close();
}

Future<void> generateCartelas() async {
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 1; i <= TOTAL_PLAYERS; i++) {
      var cartela = "${CARD}:${i}";
      var isFull = false;
      while (!isFull) {
        await command
            .send_object(["SRANDMEMBER", NUMBERS]).then((randonNumber) async {
          await command.send_object(["SCARD", cartela]).then((size) async {
            if (size == TOTAL_CARD_NUMBERS) {
              isFull = true;
            } else {
              await command.send_object(
                  ["SADD", cartela, randonNumber]).catchError((error) {
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
      await command.send_object(["SET", score, 0]).catchError((error) {
        print(error);
      });
    }
  });
  connection.close();
}

Future<void> generateNumbers(String key) async {
  await connection.connect(HOST, PORT).then((Command command) async {
    for (var i = 1; i < 100; i++) {
      await command.send_object(["SADD", key, "${i}"]).catchError((onError) {
        print(onError);
      });
    }
  });
  connection.close();
}

Future<void> play() async {
  var needContinue = true;
  await connection.connect(HOST, PORT).then((Command command) async {
    while (needContinue) {
      await command.send_object(["SCARD", BAG_NUMBERS]).then((size) async {
        if (size == 0) {
          needContinue = false;
        } else {
          await command.send_object(["SRANDMEMBER", BAG_NUMBERS]).then(
              (randonNumber) async {
            numbersSorted.add(randonNumber);
            await command.send_object(["SREM", BAG_NUMBERS, randonNumber]).then(
                (response) async {
              await verifyCartela(command, randonNumber)
                  .then((winner) {
                needContinue = winner;
              });
            }).catchError((error) {
              print(error);
            });
          }).catchError((error) {
            print(error);
          });
        }
      }).catchError((error) {
        print(error);
      });
    }
    print("finish game");
  });
  connection.close();
}

Future<bool> verifyCartela(Command command, var number) async {
  var needContinue = true;

  for (var i = 1; i <= TOTAL_PLAYERS; i++) {
    var user = "${USER_KEY}:${i}";
    var card = "${CARD}:${i}";
    var score = "${SCORE}:${i}";

    await command
        .send_object(["SISMEMBER", card, number]).then((response) async {
      if (response == 1) {
        print("${user} has ball number: ${number} ");
        await command.send_object(["INCR", score]).then((incr) async {
          await command.send_object(["GET", score]).then((score) async {
            print("${user} score: ${score}");
            if (int.parse(score) == TOTAL_CARD_NUMBERS) {
              await command.send_object(["SMEMBERS", card]).then((numbersCard) {
                print("numbers card: ${numbersCard}");
              });
              await command.send_object(["HGETALL", user]).then((userRedis) {
                print("winner: ${userRedis}");
              });
              print("It was sorted ${numbersSorted.length} balls");
              print("Numbers sorted ${numbersSorted} balls");
              needContinue = false;
            }
          });
        });
      }
    });
  }
  return needContinue;
}
