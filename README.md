# Leia-me!
Repositório para guardar código de infraestrutura na nuvem, escrito em Terraform, Ansible e Docker.

### Terraform

O terraform define uma máquina virtual para a AWS no EC2, com ambiente de desenvolvimento e produção.
 O ambiente dev tem instâncias menores, menos armazenamento e expõe o banco de dados para a internet para testes.
O ambiente prod tem instâncias maiores, mais armazenamento e não expõe o banco de dados na internet.
Apenas a aplicação dentro da instância pode acessá-lo.

Além disso, a máquina virtual conta com EBS criptografado;
e também o código busca dinamicamente a ID do AMI na região em questão para o Ubuntu Server 20.04 LTS.

### Ansible

O Ansible define as configurações da máquina à nível de software. Onde o Docker é instalado;
os arquivos de credenciais são copiados; e também é configurado do usuário principal poder usar o Docker sem o *sudo*.

**ATENÇÃO** É necessário desligar a instância por outros meios(que não o  Ansible) para que o usuário possa efetivamente usar o docker sem *sudo*.

### Docker
Com o Docker, pode-se definir os containers que executarão cada aplicação.

O Container Java 17 com Spring Boot é montado a partir do Dockerfile.

O Arquivo docker-compose.yaml contém a definição do cluster de containers. A aplicação Java, então, usa uma imagem custom construída a partir do Dockerfile em questão,
enquanto o banco de dados Cassandra usa a imagem padrão, e o ElasticSearch e o Kibana também.

Com relação às credenciais, são usados arquivos de credenciais(escondidos pelo gitignore) para demarcar as variáveis de ambiente referentes às senhas.

Todos os containers estão conectados por uma *bridge network* para se comunicarem entre si.

Para carregar um Keyspace inicial(que não seja do tipo *system*) é usado o arquivo *schema.cql*.
Além disso, é utilizado um container auxiliar do Cassandra, que serve para criar o keyspace no container principal do banco de dados Cassandra, através do arquivo *schema.cql*.
A execução completa deste container auxiliar é essencial para o container Java, pois ele precisa de um keyspace criado para estabelecer conexão com o banco de dados Cassandra.

### Resultados
![Cassandra Resultados](docs/cassandra.png?raw=true "Cassandra Resultados")
![Kibana Resultados](docs/kibana.png?raw=true "Kibana Resultados")
