{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
import Yesod.Static
 
pRoutes = [parseRoutes|
   /user UsuarioR GET POST
   /listar ListUserR GET
   /favicon FaviconR GET
   /login LoginR GET POST
   / WelcomeR GET
   /bye ByeR GET
   /livro LivroR GET POST
   /listalivro ListLivR GET
   /visualizar/#LivroId VisualizarR GET
   /avaliar AvaliarR GET POST
   /listadeavaliacao ListaDeAvR GET
   /visualizaravaliacao/#LivroId VisAvaR GET
   /sobre SobreR GET
|]