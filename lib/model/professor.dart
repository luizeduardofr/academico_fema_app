import 'dart:math';
import 'package:faker/faker.dart';

class Professor {
  static final faker = Faker();

  String matricula; 
  String nome;
  String email;
  //int idade;
  String graduacao;
  String especializacao;
  String status;

  Professor(
    {required this.matricula,
    required this.nome,
    required this.email,
    //required this.idade,
    required this.graduacao,
    required this.especializacao,
    required this.status});
  
  static fake() {
    final matricula = faker.randomGenerator.numberOfLength(8);
    final nome = faker.person.firstName();
    final sobrenome = faker.person.lastName();
    final email = '${nome[0].toLowerCase()}.${sobrenome.toLowerCase()}@gmail.com';
    //final idade = faker.randomGenerator.integer(65, min: 28);
    final graduacoes = [
      'Análise e Desenvolvimentos de Sistemas',
      'Bacharel em Ciências da Computação',
      'Direito',
      'Enfermagem',
      'Ciências Contábeis',
      'Medicina'
    ];
    final graduacao = graduacoes[Random().nextInt(graduacoes.length)];
    final especializacoes = ['Pós-Graduação', 'Mestrado', 'Doutorado'];
    final especializacao = 
        especializacoes[Random().nextInt(especializacoes.length)];
    final opcaoStatus = ['Ativo', 'Inativo'];
    final status = opcaoStatus[Random().nextInt(opcaoStatus.length)];

    return Professor(
      matricula: matricula,
      nome: '$nome $sobrenome',
      email: email,
      //idade: idade,
      graduacao: graduacao,
      especializacao: especializacao,
      status: status);
  }

  factory Professor.fromMap(Map<String,dynamic> values) => Professor(
    matricula: values ['MATRICULA'],
    nome: values ['NOME'],
    email: values ['EMAIL'],
    //idade: int.tryParse(values['IDADE']) ?? 0, // Converter para inteiro
    graduacao: values ['GRADUACAO'],
    especializacao: values ['ESPECIALIZACAO'],
    status: values ['STATUS'],
  );

  Map<String, dynamic> toMap() {
    return {
      'MATRICULA': matricula,
      'NOME': nome,
      'EMAIL': email,
      //'IDADE': idade,
      'GRADUACAO': graduacao,
      'ESPECIALIZACAO': especializacao,
      'STATUS': status
    };
  }
 
  @override
  String toString() {
    return '$matricula - $nome - $email - $graduacao - $especializacao - $status';
  }
}