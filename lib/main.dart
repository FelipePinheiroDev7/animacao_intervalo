import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const Animacao());
}

class Animacao extends StatefulWidget {
  const Animacao({Key? key}) : super(key: key);

  @override
  State<Animacao> createState() => _AnimacaoState();
}

double angulo = 0.0;
int qtd = 0;
bool encerrarAcao = true;
int indice = 0;

List<IconData> icones = <IconData>[
  Icons.autorenew_rounded,
  Icons.ac_unit_outlined,
  Icons.access_alarms_rounded,
  Icons.accessibility_new_sharp,
  Icons.account_balance_outlined,
];

List<IconData> iconesanime = <IconData>[
  Icons.account_circle_outlined,
  Icons.account_box_outlined,
  Icons.account_box_rounded,
  Icons.account_circle,
  Icons.account_circle_outlined,
];

IconData iconeAtualAnime = icones[0];
IconData iconeAtualGiro = icones[0];

class _AnimacaoState extends State<Animacao> {
  Future<void> trocaImagem() async {
    setState(() {
      iconeAtualAnime = icones[Random().nextInt(icones.length)];
    });
    var x = await Future.delayed(const Duration(milliseconds: 70));
    return x;
  }

  Future<void> trocaImagemAnime(int pos) async {
    setState(() {
      if (pos < iconesanime.length - 1) {
        iconeAtualAnime = iconesanime[pos];
      } else {
        iconeAtualAnime = iconesanime[0];
      }
    });
    var x = await Future.delayed(const Duration(milliseconds: 80));
    return x;
  }

  Future<void> giraImagem() async {
    setState(() {
      if (angulo < 360.0) {
        angulo += 1 / 25;
      }
      if (angulo == 360.0) {
        angulo = 0.0;
      }
    });
    var x = await Future.delayed(const Duration(milliseconds: 10));
    return x;
  }

  Future<void> animacaoGiroComFlag() async {
    print("inicio - (Animacao Giro)");
    var res = Future.doWhile(() async {
      await giraImagem();
      //-------------------------------------------------
      // Modo usando Contador para PARAR automaticamente
      //-------------------------------------------------
      if (encerrarAcao) {
        print("fim -(Animacao Giro)");
        setState(() {
          qtd = 0;
        });
        return false;
      } else {
        setState(() {
          qtd++;
        });
        print("Executando");
        return true;
      }
    });
    return res;
  }

  Future<void> animacaoGiroContador() async {
    print("inicio - (Animacao Giro)");
    var res = Future.doWhile(() async {
      await giraImagem();
      //-------------------------------------------------
      // Modo usando Contador para PARAR automaticamente
      //-------------------------------------------------
      if (qtd == 100 /* 200 */) {
        print("fim -(Animacao Giro)");
        setState(() {
          qtd = 0;
          encerrarAcao = true;
        });
        return false;
      } else {
        setState(() {
          qtd++;
          encerrarAcao = false;
        });
        print("Executando");
        return true;
      }
    });
    return res;
  }

  Future<void> animacaoTroca() async {
    print("inicio - (Animacao Troca)");
    var res = Future.doWhile(() async {
      //await trocaImagem(); // Funciona Perfeito!
      await trocaImagemAnime(indice); // Funciona Perfeito!
      if (qtd == 50) {
        print("fim - (Animacao Troca)");
        setState(() {
          qtd = 0;
        });
        return false;
      } else {
        setState(() {
          qtd++;
          if (indice < iconesanime.length - 1) {
            indice++;
          } else {
            indice = 0;
          }
        });
        print("Executando");
        return true;
      }
    });
    return res;
  }

  @override
  void initState() {
    angulo = 0.0;
    qtd = 0;
    encerrarAcao = true;
    iconeAtualAnime = icones[0];
    indice = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                setState(() {
                  encerrarAcao = false;
                });
                /* 
                Usar uma animacao por vez                
                ou animacaoGiroComFlag() 
                ou animacaoGiroContador() 
                ou animacaoTroca() 
                */
                await animacaoTroca(); // funciona !
              },
              label: const Text("Animar"),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 102),
              /* 102 milisegundos = valor padrao */
              /* testar 75 a 95 milisegundos! rotacao invertida! Show! */
              /* testar 115 milisegundos! rotacao normal progressiva Show! */
              /* testar 197 milisegundos! quase o ponto estacionário Show! */
              turns: 0,
              curve: Curves.bounceInOut,
              /*  
              Curves.fastOutSlowIn
              Curves.elasticInOut
              */
              child: Icon(
                iconeAtualAnime,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 50,
              width: 10,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                setState(() {
                  encerrarAcao = false;
                });
                /* 
                Usar uma animacao por vez                
                ou animacaoGiroComFlag() 
                ou animacaoGiroContador() 
                ou animacaoTroca() 
                */
                await animacaoGiroComFlag(); // funciona !
                //await animacaoGiroContador(); // funciona !
                //await animacaoTroca(); // funciona !
              },
              label: const Text("Girar"),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 102),
              /* 102 milisegundos = valor padrao */
              /* testar 75 a 95 milisegundos! rotacao invertida! Show! */
              /* testar 115 milisegundos! rotacao normal progressiva Show! */
              /* testar 197 milisegundos! quase o ponto estacionário Show! */
              turns: angulo,
              curve: Curves.bounceInOut,
              /*  
              Curves.fastOutSlowIn
              Curves.elasticInOut
              */
              child: Icon(
                iconeAtualGiro,
                size: 100,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                setState(() {
                  encerrarAcao = true;
                });
              },
              label: const Text("Encerrar"),
            ),
          ],
        ),
      )),
    );
  }
}
