# FATEC Rubens Lara- Trabalho Final de Haskell - Prof. Alexandre Garcia de Oliveira
# LivroMania 

* Introdução

 A ferramenta LivroMania, permite que o usuário realize avaliações, emitindo sua opnião sobre os livros cadastrados no sistema, tornando-se uma aplicação para verificar opniões de diversos usuários sobre livros lidos, facilitando assim a decisão de futuras compras ou até mesmo indicações de livros.

* Rotas
 
  * Rota > /login
 
    É a rota no qual o usuário é iniciallizado, onde podemos fazer o login como administrador da pagina (Usuário Administrador: admin /     Senha Administrador: admin) ou como usuário, podendo fazer cadastrar um novo usuário ao clicar em Cadastrar-se ou até mesmo            utilizar um dos ja cadastrados usuários (Usúario: 123 / Senha: 123).
    

  * Rota /

    Ao logar-se, você será direcionado a pagina principal da ferramenta, onde encontra-se o menu, com as opções de : 
   
    Consultar Livros > Livros Rota /listalivro ==> consulta os livros cadastrados no sistema e selecionando o livro voce terá acesso a      seus dados, como Título, Autor, Sinópse, etc.
    
    Cadastrar Livros > Rota /livro ==> opção restrita ao administrador, onde pode ser realizado o cadastramento de novos livros,             evitando assim que livros inexistentes ==> sejam cadastrados pelos usuários do sistema.
    
    Avaliações > Rota /listadeavaliacao ==> onde pode ser feita a consulta de avaliações realizadas em cada livro.
    
    Avaliar > Rota /avaliar ==> opção na qual pode se avaliar um livro e emitir sua opnião.
    
    Sobre > Rota /sobre ==> rota para saber mais sobre o LivroMania, seus autores, o seu propósito.
    
    Sair > Rota /bye ==> botão que permite sair do sistema, deslogando seu usuário.

  * Rota >  /visualizar/...

    Rota dedicada a exibir o livro e seus detalhes, como Título, Sinopse, ISBN, Autor, etc.
   
  * Rota >  /visualizaravaliacao/...
   
    Rota dedicada a exibir a avaliação do livro selecionado, exibindo as opniões sobre cada livro.

  * Rota > /user
 
    Rota para cadastro de novo usuário, onde deve ser inserido usuário, senha e nome.




    
    

