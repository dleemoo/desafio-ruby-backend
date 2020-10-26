# Setup

Está incluso um `docker-compose.yml` com tudo que é necessário para rodar a aplicação.
O `Dockerfile` que foi usado está disponível no repositório em no diretório `/docker`.

Para o correto funcionamento deste setup é necessário que o usuário tenha o UID
`1000` na máqina local (normalmente é o padrão das distribuições linux). Sem
isso, alguns problemas de permissão deverão aparecer.

A imagem em questão já está disponível no dockerhub e portanto não é necessário
fazer o build da mesma.

O primeiro passo é configurar o ambiente local:

```
cp .example.env .env
```

A configuração incluida deverá funcionar 100% com o setup do docker e a priori
não é necessário editar nada. Podemos fazer um pull das imagens necessárias:

```
docker-compose pull
```

Isso obterá a imagem do postgres (se necessário) e da aplicação. Neste momento,
podemos fazer o install do bundle, criar os bancos de testes e desenvolvimento
e executar as migrations:


```
docker-compose run --rm cnab-app bin/setup
```

Vale observer que o script anterior pode ser executado sem que o postgres
esteja inicializado (principalmente na primeira execução, quando o diretório de
dados do pg será configurado) Nesse caso, repetir o script deverá resolver (já
que o postgres já estará configurado no docker).

Para executar os specs, fazemos:

```
docker-compose run --rm cnab-app bundle exec rspec
```

Para executar o servidor localmente:

```
docker-compose up
```

A applicação estará disponível em `http://localhost:9292`.

## Nota

Para executar diretamente no localhost o caminho mais fácil é:

1. Configurar o banco (pg12) e atualizar o arquivo `.env`.
2. Possivelmente usar o dotenv fará com que os passos anteriores funcionem.
3. Executar o servidor com `dotenv bundle exec rackup`


# Desafio programação - para vaga Back-end

Por favor leiam este documento do começo ao fim, com muita atenção.
O intuito deste teste é avaliar seus conhecimentos técnicos com o back-end, para ser mais específico em Ruby.

O teste consiste em parsear [este arquivo de texto (CNAB)](https://github.com/mlalbuquerque/desafio-ruby-backend/blob/master/CNAB.txt) e salvar suas informações (transações financeiras) em uma base de dados a critério do candidato.

Este desafio deve ser feito por você em sua casa. 

# Instruções de entrega do desafio

1. Primeiro, faça um fork deste projeto para sua conta no Github (crie uma se você não possuir).
2. Em seguida, implemente o projeto tal qual descrito abaixo, em seu clone local.
3. Por fim, envie via email um arquivo patch para seu contato na Impulso.

# Descrição do projeto

Você recebeu um arquivo CNAB com os dados das movimentações finanaceira de várias lojas.
Precisamos criar uma maneira para que estes dados sejam importados para um banco de dados.

Sua tarefa é criar uma interface web que aceite upload do [arquivo CNAB](https://github.com/mlalbuquerque/desafio-ruby-backend/blob/master/CNAB.txt), normalize os dados e armazene-os em um banco de dados relacional e exiba essas informações em tela.

**Sua aplicação web DEVE:**

1. Ter uma tela (via um formulário) para fazer o upload do arquivo
2. Interpretar ("parsear") o arquivo recebido, normalizar os dados, e salvar corretamente a informação em um banco de dados relacional, **se atente as documentações** que estão logo abaixo.
3. Exibir uma lista das operações importadas por lojas, e nesta lista deve conter um totalizador do saldo em conta
4. Ser escrita obrigatoriamente em Ruby 2.0+
5. Ser simples de configurar e rodar, funcionando em ambiente compatível com Unix (Linux ou Mac OS X). Ela deve utilizar apenas linguagens e bibliotecas livres ou gratuitas.

**Sua aplicação web NÃO precisa:**

1. Lidar com autenticação ou autorização (pontos extras se ela fizer, mais pontos extras se a autenticação for feita via OAuth).
2. Ser escrita usando algum framework específico (mas não há nada errado em usá-los também, use o que achar melhor).

# Documentação do CNAB

| Descrição do campo  | Inicio | Fim | Tamanho | Comentário
| ------------- | ------------- | -----| ---- | ------
| Tipo  | 1  | 1 | 1 | Tipo da transação
| Data  | 2  | 9 | 8 | Data da ocorrência
| Valor | 10 | 19 | 10 | Valor da movimentação. *Obs.* O valor encontrado no arquivo precisa ser divido por cem(valor / 100.00) para normalizá-lo.
| CPF | 20 | 30 | 11 | CPF do beneficiário
| Cartão | 31 | 42 | 12 | Cartão utilizado na transação 
| Hora  | 43 | 48 | 6 | Hora da ocorrência atendendo ao fuso de UTC-3
| Dono da loja | 49 | 62 | 14 | Nome do representante da loja
| Nome loja | 63 | 81 | 19 | Nome da loja

# Documentação sobre os tipos das transações

| Tipo | Descrição | Natureza | Sinal |
| ---- | -------- | --------- | ----- |
| 1 | Débito | Entrada | + |
| 2 | Boleto | Saída | - |
| 3 | Financiamento | Saída | - |
| 4 | Crédito | Entrada | + |
| 5 | Recebimento Empréstimo | Entrada | + |
| 6 | Vendas | Entrada | + |
| 7 | Recebimento TED | Entrada | + |
| 8 | Recebimento DOC | Entrada | + |
| 9 | Aluguel | Saída | - |

# Avaliação

Seu projeto será avaliado de acordo com os seguintes critérios.

1. Sua aplicação preenche os requerimentos básicos?
2. Você documentou a maneira de configurar o ambiente e rodar sua aplicação?
3. Você seguiu as instruções de envio do desafio?
4. Qualidade e cobertura dos testes unitários.

Adicionalmente, tentaremos verificar a sua familiarização com as bibliotecas padrões (standard libs), bem como sua experiência com programação orientada a objetos a partir da estrutura de seu projeto.

---

Boa sorte!
