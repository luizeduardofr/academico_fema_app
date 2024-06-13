import 'package:academico_fema_app/helpers/confirmation_dialog_helper.dart';
import 'package:academico_fema_app/helpers/snack_bar_helper.dart';
import 'package:academico_fema_app/helpers/status_helper.dart';
import 'package:academico_fema_app/model/aluno.dart';
import 'package:academico_fema_app/model/professor.dart';
import 'package:academico_fema_app/repository/aluno_repository.dart';
import 'package:academico_fema_app/repository/professor_repository.dart';
import 'package:academico_fema_app/repository/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        // colorSchemeSeed: Colors.blue,
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
        '/alunos': (context) => AlunosPage(),
        '/aluno-form': (context) => AlunoFormPage(),
        '/professores': (context) => ProfessoresPage(),
        '/professor-form': (context) => ProfessorFormPage(),
      },
      initialRoute: '/login',
    );
  }
}

class LoginPage extends StatefulWidget {
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Shared Preferences
class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usuarioFormController = TextEditingController();
  final _senhaFormController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acadêmico FEMA'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boas-vindas',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text('Entre com a sua conta', style: TextStyle(fontSize: 16)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Usuário'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    controller: _usuarioFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O "usuário" deve ser informado.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Senha'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.remove_red_eye_outlined),
                    ),
                    obscureText: true,
                    controller: _senhaFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A "senha" deve ser informada.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  final usuario = _usuarioFormController.text;
                                  final senha = _senhaFormController.text;

                                  final usuarioLogado = widget._usuarioRepository.validar(usuario, senha);

                                  if (usuarioLogado != null) {
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    //   builder: (context) => HomePage(),
                                    // ));

                                    Navigator.of(context).pushReplacementNamed('/home');
                                  } else {
                                    SnackBarHelper.showError(
                                      context,
                                      content: const Text('Usuário ou senha inválidos'),
                                    );
                                  }
                                }
                              },
                              child: const Text('Confirmar'))),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).unselectedWidgetColor,
                              ),
                              onPressed: () {
                                _loginFormKey.currentState!.reset();
                              },
                              child: const Text('Limpar')))
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );

                // AlertDialogHelper
                ConfirmationDialogHelper.showConfirmationDialog(
                  context,
                  title: 'Atenção!',
                  content: 'Deseja encerrar a sessão?',
                  confirmationCallback: () => Navigator.of(context).pushReplacementNamed('/login'),
                );
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Luiz Eduardo'),
                accountEmail: const Text('luizeduardo_francodarocha@outlook.com'),
                currentAccountPicture: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.person_outlined),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  SnackBarHelper.show(context, content: const Text('Página inicial'));
                },
                trailing: const Icon(Icons.favorite_outlined),
              ),
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: const Text('Alunos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/alunos');
                  // SnackBarHelper.show(context, content: const Text('Listagem de alunos'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Professores'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/professores');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Sair'),
                onTap: () {
                  ConfirmationDialogHelper.showConfirmationDialog(
                    context,
                    title: 'Atenção!',
                    content: 'Deseja encerrar a sessão?',
                    confirmationCallback: () => Navigator.of(context).pushReplacementNamed('/login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class AlunosPage extends StatefulWidget {
  final AlunoRepository _alunoRepository = AlunoRepository();

  AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => AlunosPageState();
}

class AlunosPageState extends State<AlunosPage> {
  List<Aluno> alunos = List.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      alunos = await widget._alunoRepository.findAll();
      setState(() {});
    });
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Alunos'),
        actions: [
          IconButton(
              onPressed: () async {
                // final Aluno aluno = Aluno.fake();
                // await widget._alunoRepository.save(aluno);
                // alunos = await widget._alunoRepository.findAll();
                // setState(() {});

                final result = await Navigator.of(context).pushNamed('/aluno-form');

                if (result != null) {
                  alunos = await widget._alunoRepository.findAll();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add_outlined)),
          IconButton(
              onPressed: () {
                if (alunos.isNotEmpty) {
                  ConfirmationDialogHelper.showConfirmationDialog(
                    context,
                    title: 'Atenção',
                    content: 'Confirma exclusão de TODOS os alunos?',
                    confirmationCallback: () async {
                      await widget._alunoRepository.clear();
                      alunos = await widget._alunoRepository.findAll();
                      setState(() {});
                    },
                  );
                }
              },
              icon: const Icon(Icons.clear_outlined)),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Total de Registros: ${alunos.length}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: IconButton(
                  onPressed: () async {
                    alunos = await widget._alunoRepository.findAll(); // async
                    setState(() {
                      _searchController.clear(); // sync
                    });
                  },
                  icon: const Icon(Icons.clear_outlined),
                ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) async {
                alunos = await widget._alunoRepository.findByNome(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // todo: exemplo "fake" de auto-refresh de listagem de dados

                await Future<void>.delayed(const Duration(seconds: 3));

                final Aluno aluno = Aluno.fake();
                await widget._alunoRepository.save(aluno);
                alunos = await widget._alunoRepository.findAll();
                setState(() {});
              },
              child: ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  final aluno = alunos[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListTile(
                      leading: const Icon(Icons.person_outlined),
                      title: Text(aluno.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RA: ${aluno.ra}'),
                          Text('E-mail: ${aluno.email}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(left: 16.0),
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final result = await Navigator.of(context).pushNamed('/aluno-form', arguments: aluno);

                              if (result != null) {
                                alunos = await widget._alunoRepository.findAll();
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.edit_outlined),
                            color: Theme.of(context).primaryColor,
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(left: 16.0),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              ConfirmationDialogHelper.showConfirmationDialog(
                                context,
                                title: 'Atenção',
                                content: 'Confirma exclusão de aluno?',
                                confirmationCallback: () async {
                                  await widget._alunoRepository.deleteByRa(aluno.ra);
                                  alunos = await widget._alunoRepository.findAll();
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      onTap: () {
                        SnackBarHelper.show(
                          context,
                          content: Text(aluno.toString()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlunoFormPage extends StatefulWidget {
  final AlunoRepository _alunoRepository = AlunoRepository();

  AlunoFormPage({super.key});

  @override
  State<AlunoFormPage> createState() => _AlunoFormPageState();
}

class _AlunoFormPageState extends State<AlunoFormPage> {
  Aluno? _alunoEditing;

  final _alunoFormKey = GlobalKey<FormState>();
  final _raFormController = TextEditingController();
  final _nomeFormController = TextEditingController();
  final _emailFormController = TextEditingController();

  isEditing() {
    return _alunoEditing != null;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    _alunoEditing = args as Aluno?;

    if (isEditing()) {
      _raFormController.text = _alunoEditing!.ra;
      _nomeFormController.text = _alunoEditing!.nome;
      _emailFormController.text = _alunoEditing!.email;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Aluno'),
        actions: [
          IconButton(
              onPressed: () async {
                await confirmForm(context);
              },
              icon: const Icon(Icons.save_outlined)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Form(
            key: _alunoFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing() ? 'Edição de aluno' : 'Novo aluno',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Registro Acadêmico'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _raFormController,
                  readOnly: isEditing(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 6,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "RA" deve ser informado.';
                    }
                    final pattern = RegExp(r'^\d{6}$');
                    if (!pattern.hasMatch(value)) {
                      return 'O "RA" deve ser informado com 6 dígitos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Nome completo'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _nomeFormController,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "Nome" deve ser informado.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail_outline_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) async {
                    await confirmForm(context);
                  },
                  controller: _emailFormController,
                  maxLength: 64,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "E-mail" deve ser informado.';
                    }
                    final pattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!pattern.hasMatch(value)) {
                      return 'O "E-mail" deve ser informado corretamente (RFC 5322).';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> confirmForm(BuildContext context) async {
    if (_alunoFormKey.currentState!.validate()) {
      final ra = _raFormController.text;
      final nome = _nomeFormController.text;
      final email = _emailFormController.text;

      final Aluno aluno = Aluno(ra: ra, nome: nome, email: email);
      await widget._alunoRepository.save(aluno);

      if (context.mounted) SnackBarHelper.showInfo(context, content: Text('Aluno ${isEditing() ? "atualizado" : "inserido"} com sucesso!'));

      if (context.mounted) Navigator.pop(context, aluno);
    }
  }
}

class ProfessoresPage extends StatefulWidget {
  final ProfessorRepository _professorRepository = ProfessorRepository();

  ProfessoresPage({super.key});

  @override
    State<ProfessoresPage> createState() => ProfessoresPageState();
}

class ProfessoresPageState extends State<ProfessoresPage> {
    List<Professor> professores = List.empty();

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        professores = await widget._professorRepository.findAll();
        setState(() {});
    });
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Professores'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed('/professor-form');

              if (result != null) {
                professores = await widget._professorRepository.findAll();
                setState(() {});
              }
          },
          icon: const Icon(Icons.add_outlined)),
      IconButton(
        onPressed: () {
          if (professores.isNotEmpty) {
            ConfirmationDialogHelper.showConfirmationDialog(
              context, 
              title: 'Atenção', 
              content: 'Confirma exclusão de TODOS os professores?', 
              confirmationCallback: () async {
                await widget._professorRepository.clear();
                professores = await widget._professorRepository.findAll();
                setState(() {});
              },
            );
          }
        },
        icon: const Icon(Icons.clear_outlined)),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Total de Registros: ${professores.length}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
               ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: IconButton(
                  onPressed: () async {
                    professores = await widget._professorRepository.findAll();
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_outlined),
                ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) async {
                professores = await widget._professorRepository.findByNome(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future<void>.delayed(const Duration(seconds: 3));

                final Professor professor = Professor.fake();
                await widget._professorRepository.save(professor);
                professores = await widget._professorRepository.findAll();
                setState(() {});
              },
              child: ListView.builder(
                itemCount: professores.length,
                itemBuilder: (context, index) {
                  final professor = professores[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListTile(
                      leading: const Icon(Icons.person_outlined),
                      title: Text(professor.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Matrícula: ${professor.matricula}'),
                          Text('E-mail: ${professor.email}'),
                          //Text('Idade: ${professor.idade}'),
                          Text('Graduação: ${professor.graduacao}'),
                          Text('Especialização: ${professor.especializacao}'),
                          Row(
                            children: [
                              Text('Status: '),
                              StatusHelper.getStatusWidget(professor.status),
                            ],
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(left: 16.0),
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final result = await Navigator.of(context).pushNamed('/professor-form', arguments: professor);

                              if (result != null) {
                                professores = await widget._professorRepository.findAll();
                                setState(() {});
                              }
                            }, 
                            icon: const Icon(Icons.edit_outlined),
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onTap: () {
                        SnackBarHelper.show(
                          context, 
                          content: Text(professor.toString()),
                        );
                      },
                    ),
                    );
                },
                ),
            )
            ),
        ],
      ),
    );
  }
}

class ProfessorFormPage extends StatefulWidget {
  final ProfessorRepository _professorRepository = ProfessorRepository();

  ProfessorFormPage({super.key});

  @override
  State<ProfessorFormPage> createState() => _ProfessorFormPageState();
}

class _ProfessorFormPageState extends State<ProfessorFormPage> {
  Professor ? _professorEditing;

  final _professorFormKey = GlobalKey<FormState>();
  final _matriculaFormController = TextEditingController();
  final _nomeFormController = TextEditingController();
  final _emailFormController = TextEditingController();
  //final _idadeFormController = TextEditingController();
  final _graduacaoFormController = TextEditingController();
  final _especializacaoFormController = TextEditingController();
  final _statusFormController = TextEditingController();
  String? _selectedStatus;

  isEditing() {
    return _professorEditing != null;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    _professorEditing = args as Professor?;

    if (isEditing()) {
      _matriculaFormController.text = _professorEditing!.matricula;
      _nomeFormController.text = _professorEditing!.nome;
      _emailFormController.text = _professorEditing!.email;
      //_idadeFormController.text = _professorEditing!.idade.toString();
      _graduacaoFormController.text = _professorEditing!.graduacao;
      _especializacaoFormController.text = _professorEditing!.especializacao;
      _selectedStatus = _professorEditing!.status;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Professor'),
        actions: [
          IconButton(
            onPressed: () async {
              await confirmForm(context);
            }, 
            icon: const Icon(Icons.save_outlined)),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.clear_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Form(
            key: _professorFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing() ? 'Edição de Professor' : 'Novo Professor',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Matrícula Docente'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _matriculaFormController,
                  readOnly: isEditing(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 6,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A "Matrícula" deve ser informada com 8 dígitos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Nome completo'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _nomeFormController,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "Nome" deve ser informado.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail_outline_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) async {
                    await confirmForm(context);
                  },
                  controller: _emailFormController,
                  maxLength: 64,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "E-mail" deve ser informado.';
                    }
                    final pattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!pattern.hasMatch(value)) {
                      return 'O "E-mail" deve ser informado corretamente (RFC 5322).';
                    }
                    return null;
                  },
                ),
                /*
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Idade'),
                    border: OutlineInputBorder(),
                    prefix: Icon(Icons.book_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) async {
                    await confirmForm(context);
                  },
                  controller: _idadeFormController,
                  maxLength: 8,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A "Idade" deve ser informado.';
                    }
                    String validarIdade(String idade) {
                      int idadeNumerica = int.tryParse(idade) ?? 0;

                      if(idadeNumerica < 28 || idadeNumerica > 65) {
                        return 'A idade deve estar entre 28 e 65 anos.';
                      } else {
                        throw ArgumentError('A idade fornecida é inválida.');
                      }
                    }
                    return null;
                  },
                ),
                */
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Graduação'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _graduacaoFormController,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A "Graduação" deve ser informado.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Especialização'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book_outlined),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: _especializacaoFormController,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A "Especialização" deve ser informado.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment_turned_in_outlined),
                  ),
                  value: _selectedStatus,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items: ['Ativo', 'Inativo'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O "Status" deve ser informado.';
                    }
                    return null;
                  },
                ),   
             ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> confirmForm(BuildContext context) async {
    if (_professorFormKey.currentState!.validate()) {
      final matricula = _matriculaFormController.text;
      final nome = _nomeFormController.text;
      final email = _emailFormController.text;
      //final idade = int.tryParse(_idadeFormController.text) ?? 0;
      final graduacao = _graduacaoFormController.text;
      final especializacao = _especializacaoFormController.text;
      final status = _selectedStatus!;

      final Professor professor = Professor(matricula: matricula, nome: nome, email: email, graduacao: graduacao, especializacao: especializacao, status: status);
      await widget._professorRepository.save(professor);

      if (context.mounted) SnackBarHelper.showInfo(context, content: Text('Professor ${isEditing() ? "atualizado" : "inserido"} com sucesso!'));

      if (context.mounted) Navigator.pop(context, professor);
    }
  }
}
