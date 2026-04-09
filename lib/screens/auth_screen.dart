import 'dart:ffi';

import 'package:PadsBuga/authentication/auth_service.dart';
import 'package:PadsBuga/utils/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool isEntrando = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 54, 49, 49),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isEntrando) ? "PadsBuga" : "Vamos começar?",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      (isEntrando)
                          ? "Login para arquivar seus Kits"
                          : "Faça seu cadastro para começar a usar seu PadsBuga.",
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("E-mail")),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text("Senha")),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: isEntrando,
                      child: TextButton(
                        onPressed: () {
                          esqueciMinhaSenhaClicado();
                        },
                        child: Text('Esqueci minha senha'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible: !isEntrando,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _confirmaController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  label: Text("Confirme a senha"),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 4) {
                                    return "Insira uma confirmação de senha válida.";
                                  }
                                  if (value != _senhaController.text) {
                                    return "As senhas devem ser iguais.";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(
                                  label: Text("Nome"),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 3) {
                                    return "Insira um nome maior.";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoEnviarClicado();
                      },
                      child: Text(
                        (isEntrando) ? "Entrar" : "Cadastrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEntrando = !isEntrando;
                        });
                      },
                      child: Text(
                        (isEntrando)
                            ? "Ainda não tem conta?\nClique aqui para cadastrar."
                            : "Já tem uma conta?\nClique aqui para entrar",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(email: email, senha: senha);
      } else {
        _criarUsuario(email: email, senha: senha, nome: nome);
      }
    }
  }

  _entrarUsuario({required String email, required String senha}) async {
    final erro = await authService.entrarUsuario(
      email: email,
      senha: senha,
    );
    if (!mounted) return; // <- Verifica se o widget ainda está na árvore

    if (erro != null) {
      showSnackBar(
        context: context,
        mensagem: erro,
      );
    }

    // if (erro == null) {
    //   showSnackBar(
    //     context: context,
    //     mensagem: 'Conta logada com sucesso!',
    //     isErro: false,
    //   );
    // } else {
    //   showSnackBar(
    //     context: context,
    //     mensagem: erro,
    //   );
    // }
  }

  void _criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    final erro = await authService.cadastraUsuario(
      email: email,
      senha: senha,
      nome: nome,
    );

    if (!mounted) return; // <- Verifica se o widget ainda está na árvore

    if (erro != null) {
      showSnackBar(
        context: context,
        mensagem: erro,
      );
    }
    // if (erro == null) {
    //   showSnackBar(
    //     context: context,
    //     mensagem: 'Conta criada com sucesso!',
    //     isErro: false,
    //   );
    // } else {
    //   showSnackBar(
    //     context: context,
    //     mensagem: erro,
    //   );
    // }
  }

  esqueciMinhaSenhaClicado() {
    String email = ''; //_emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefinicaoSenhaController =
            TextEditingController(text: email);
        return AlertDialog(
          title: Text('Confirme o e-mail para redefinição'),
          content: TextFormField(
            controller: redefinicaoSenhaController,
            decoration: InputDecoration(label: Text('Confirme o  em-mail')),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          actions: [
            TextButton(
              onPressed: () async {
                bool result = await solicitarRedefinicaoDeSenha(email);
                if (result) {
                  Navigator.pop(context);
                } else {
                  print('ERRO NA DEFINIÇÃO');
                }
              },
              child: Text('Redefinir senha'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> solicitarRedefinicaoDeSenha(String email) async {
    final existe = await verificaSeEmailExiste(email);

    if (!existe) {
      showSnackBar(
        context: context,
        mensagem: 'Este e-mail não está cadastrado.',
        isErro: true,
      );
      return false;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(
        context: context,
        mensagem: 'Se este e-mail estiver cadastrado, um link foi enviado.',
        isErro: false,
      );
      return true;
    } catch (e) {
      showSnackBar(
        context: context,
        mensagem: 'Erro ao enviar e-mail: ${e.toString()}',
        isErro: true,
      );
      return false;
    }
  }

  Future<bool> verificaSeEmailExiste(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
